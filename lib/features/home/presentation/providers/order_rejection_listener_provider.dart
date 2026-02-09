import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/infrastructure/notification/notification_service.dart';
import '../../domain/value_objects.dart';

part 'order_rejection_listener_provider.g.dart';

/// Listens to order rejection status changes for current driver's orders
/// Shows notification when admin approves or rejects driver's excuse
@Riverpod(keepAlive: true)
class OrderRejectionListener extends _$OrderRejectionListener {
  StreamSubscription<QuerySnapshot>? _subscription;
  final Set<String> _processedOrders = {};

  @override
  void build() {
    ref.onDispose(() {
      _subscription?.cancel();
      _processedOrders.clear();
    });

    // Start listening
    _startListening();
  }

  void _startListening() {
    try {
      final user = ref.watch(currentUserProvider);

      // Listen to orders where driver has submitted rejection request
      _subscription?.cancel();
      _subscription = FirebaseFirestore.instance
          .collection('orders')
          .where('driver_id', isEqualTo: user.id)
          .where(
            'rejectionStatus',
            whereIn: [
              RejectionStatus.adminApproved.jsonValue,
              RejectionStatus.adminRefused.jsonValue,
            ],
          )
          .snapshots()
          .listen(
            _handleOrderUpdates,
            onError: (Object error) {
              debugPrint('Order rejection listener error: $error');
            },
          );
    } catch (e) {
      debugPrint('Failed to start rejection listener: $e');
    }
  }

  void _handleOrderUpdates(QuerySnapshot snapshot) {
    for (final change in snapshot.docChanges) {
      // Only process added documents (new notifications) or modified ones
      if (change.type == DocumentChangeType.added ||
          change.type == DocumentChangeType.modified) {
        _handleOrderChange(change.doc);
      }
    }
  }

  void _handleOrderChange(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return;

    final rejectionStatusString = data['rejectionStatus'] as String?;
    if (rejectionStatusString == null) return;

    final orderId = doc.id;

    // Avoid duplicate notifications
    final notificationKey = '${orderId}_$rejectionStatusString';
    if (_processedOrders.contains(notificationKey)) return;
    _processedOrders.add(notificationKey);

    final adminComment = data['adminComment'] as String?;

    final rejectionStatus = RejectionStatus.values.firstWhere(
      (e) => e.jsonValue == rejectionStatusString,
      orElse: () => RejectionStatus.none,
    );

    // Show notification based on admin decision
    switch (rejectionStatus) {
      case RejectionStatus.adminApproved:
        _showApprovedNotification(orderId);
      case RejectionStatus.adminRefused:
        _showRefusedNotification(orderId, adminComment);
      default:
        break;
    }
  }

  void _showApprovedNotification(String orderId) {
    // Show local push notification
    final notificationService = ref.read(notificationServiceProvider);
    notificationService.showLocalNotification(
      title: 'تم قبول اعتذارك',
      body: 'تم قبول اعتذارك عن الطلب #${orderId.substring(0, 8)}',
    );
  }

  void _showRefusedNotification(String orderId, String? adminComment) {
    // Show local push notification
    final notificationService = ref.read(notificationServiceProvider);
    final reason = adminComment != null && adminComment.isNotEmpty
        ? '\nالسبب: $adminComment'
        : '';
    notificationService.showLocalNotification(
      title: '⚠️ تم رفض اعتذارك - توجه إلزامي',
      body: 'يجب عليك توصيل الطلب #${orderId.substring(0, 8)} إلزامياً$reason',
    );
  }
}

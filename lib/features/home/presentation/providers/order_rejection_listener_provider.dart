import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../auth/domain/user.dart';
import '../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/presentation/widgets/toasts.dart';
import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../domain/value_objects.dart';

part 'order_rejection_listener_provider.g.dart';

/// Listens to order rejection status changes for current driver's orders
/// Shows notification when admin approves or rejects driver's excuse
@Riverpod(keepAlive: true)
class OrderRejectionListener extends _$OrderRejectionListener {
  StreamSubscription<QuerySnapshot>? _subscription;

  @override
  void build() {
    ref.onDispose(() {
      _subscription?.cancel();
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
          .where('deliveryId', isEqualTo: user.id)
          .where('rejectionStatus', whereIn: [
            RejectionStatus.adminApproved.name,
            RejectionStatus.adminRefused.name,
          ])
          .snapshots()
          .listen(
            (snapshot) => _handleOrderUpdates(snapshot),
            onError: (error) {
              debugPrint('Order rejection listener error: $error');
            },
          );
    } catch (e) {
      debugPrint('Failed to start rejection listener: $e');
    }
  }

  void _handleOrderUpdates(QuerySnapshot snapshot) {
    for (final change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.modified) {
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
    final rejectionStatus = RejectionStatus.values.firstWhere(
      (e) => e.name == rejectionStatusString,
      orElse: () => RejectionStatus.none,
    );

    // Show notification based on admin decision
    switch (rejectionStatus) {
      case RejectionStatus.adminApproved:
        _showApprovedNotification(orderId);
        break;
      case RejectionStatus.adminRefused:
        _showRefusedNotification(orderId);
        break;
      default:
        break;
    }
  }

  void _showApprovedNotification(String orderId) {
    debugPrint('✅ تم قبول اعتذارك عن الطلب #${orderId.substring(0, 8)}');
    // TODO: Show notification in UI when BuildContext is available
  }

  void _showRefusedNotification(String orderId) {
    debugPrint('❌ تم رفض اعتذارك عن الطلب #${orderId.substring(0, 8)}');
    // TODO: Show notification in UI when BuildContext is available
  }
}

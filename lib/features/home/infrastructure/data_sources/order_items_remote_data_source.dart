import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/infrastructure/error/app_exception.dart';
import '../../../../core/infrastructure/network/main_api/api_callers/firebase_firestore_facade.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../dtos/order_item_dto.dart';

part 'order_items_remote_data_source.g.dart';

@Riverpod(keepAlive: true)
OrderItemsRemoteDataSource orderItemsRemoteDataSource(Ref ref) {
  return OrderItemsRemoteDataSource(
    ref,
    firebaseFirestore: ref.watch(firebaseFirestoreFacadeProvider),
  );
}

class OrderItemsRemoteDataSource {
  OrderItemsRemoteDataSource(
    this.ref, {
    required this.firebaseFirestore,
  });

  final Ref ref;
  final FirebaseFirestoreFacade firebaseFirestore;

  static const String orderItemsCollectionPath = 'order_items';

  /// Get all items for a specific order
  Future<List<OrderItemDto>> getOrderItems(String orderId) async {
    if (orderId.isEmpty) {
      throw ServerException(
        type: ServerExceptionType.conflict,
        message: 'Order ID cannot be empty',
      );
    }

    try {
      
      
      final snapshot = await firebaseFirestore.getCollectionData(
        path: orderItemsCollectionPath,
        queryBuilder: (query) => query.where('order_id', isEqualTo: orderId),
      );

      final items = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Add document ID to the data
        data['id'] = doc.id;
        
        return OrderItemDto.fromJson(data);
      }).toList();

      return items;
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading order items: $e');
      debugPrint('Stack trace: $stackTrace');
      // Return empty list instead of rethrowing to avoid causing UI errors
      return [];
    }
  }

  /// Stream order items for a specific order (real-time updates)
  Stream<List<OrderItemDto>> streamOrderItems(String orderId) {
    if (orderId.isEmpty) {
      return Stream.value([]);
    }
    
    return firebaseFirestore
        .collectionStream(
      path: orderItemsCollectionPath,
      queryBuilder: (query) => query.where('order_id', isEqualTo: orderId),
    )
        .map((snapshot) {
      final items = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return OrderItemDto.fromJson(data);
      }).toList();
      
      return items;
    }).handleError((error, stackTrace) {
      return <OrderItemDto>[];
    });
  }
}

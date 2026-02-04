import 'dart:async';
import '../../../../core/infrastructure/utils/platform_exceptions.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/infrastructure/error/app_exception.dart';
import '../../../../core/infrastructure/network/main_api/api_callers/firebase_firestore_facade.dart';
import '../../../../core/infrastructure/utils/retry_utility.dart';
import '../../../../core/infrastructure/utils/network_retry_strategy.dart';
import '../../../../core/infrastructure/utils/geo_point_validator.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/value_objects.dart';
import '../dtos/order_dto.dart';
import '../dtos/update_delivery_geo_point_dto.dart';
import '../dtos/update_delivery_status_dto.dart';

part 'orders_remote_data_source.g.dart';

@Riverpod(keepAlive: true)
OrdersRemoteDataSource ordersRemoteDataSource(Ref ref) {
  return OrdersRemoteDataSource(
    ref,
    firebaseFirestore: ref.watch(firebaseFirestoreFacadeProvider),
  );
}

class OrdersRemoteDataSource {
  OrdersRemoteDataSource(
    this.ref, {
    required this.firebaseFirestore,
  });

  final Ref ref;
  final FirebaseFirestoreFacade firebaseFirestore;

  static const String ordersCollectionPath = 'orders';

  static String orderDocPath(String id) => '$ordersCollectionPath/$id';

  Stream<List<OrderDto>> getUpcomingOrders() {
    // Simplified query without orderBy to avoid needing composite index
    // Sorting is done in memory instead
    debugPrint('🔍 Querying orders with status field...');
    return firebaseFirestore
        .collectionStream(
      path: ordersCollectionPath,
      queryBuilder: (query) => query.where(
        'status', // Changed from 'deliveryStatus' to match database field
        whereIn: [
          'confirmed', // Using confirmed instead of upcoming
          'onTheWay',
        ],
      ),
    )
        .map((snapshot) {
      debugPrint(
          '📥 Received ${snapshot.docs.length} documents from Firestore');
      // Filter by pickupOption and sort by date in memory
      final orders = OrderDto.parseListOfDocument(snapshot.docs)
          .where((o) => o.pickupOption == PickupOption.delivery)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return orders;
    }).transform(
      StreamTransformer<List<OrderDto>, List<OrderDto>>.fromHandlers(
        handleData: (data, sink) {
          debugPrint('📦 Orders received after filtering: ${data.length}');
          sink.add(data);
        },
        handleError: (error, stackTrace, sink) {
          debugPrint('❌ Orders error: $error');
          debugPrint('Stack trace: $stackTrace');
          sink.add(<OrderDto>[]);
        },
      ),
    );
  }

  /// Get orders assigned to a specific delivery user (on the way or delivered)
  Stream<List<OrderDto>> getMyOrders(String deliveryId) {
    debugPrint('🔍 [getMyOrders] Querying MY orders for driver: $deliveryId');
    debugPrint(
        '🔍 [getMyOrders] Query: driver_id == $deliveryId AND status IN [onTheWay, delivered]');

    return firebaseFirestore
        .collectionStream(
      path: ordersCollectionPath,
      queryBuilder: (query) => query
          .where('driver_id',
              isEqualTo: deliveryId) // Changed from 'deliveryId'
          .where(
            'status', // Changed from 'deliveryStatus'
            whereIn: [
              'onTheWay', // Using string values
              'delivered',
            ],
          )
          .orderBy('created_at', descending: true) // Changed from 'date'
          .limit(50),
    )
        .map((snapshot) {
      debugPrint(
          '📥 [getMyOrders] Received ${snapshot.docs.length} documents from Firestore');

      if (snapshot.docs.isEmpty) {
        debugPrint('⚠️ [getMyOrders] No documents found! Check:');
        debugPrint('   1. driver_id in orders matches: $deliveryId');
        debugPrint('   2. status is "onTheWay" or "delivered"');
      }

      final orders = OrderDto.parseListOfDocument(snapshot.docs);
      debugPrint('📦 [getMyOrders] Parsed ${orders.length} orders');

      // Log each order for debugging
      for (var order in orders) {
        debugPrint(
            '   - Order ${order.id}: status=${order.deliveryStatus}, driver=${order.deliveryId}');
      }

      orders.sort((a, b) => b.date.compareTo(a.date));
      return orders;
    }).transform(
      StreamTransformer<List<OrderDto>, List<OrderDto>>.fromHandlers(
        handleData: (data, sink) {
          debugPrint(
              '📦 [getMyOrders] Final count after transform: ${data.length}');
          sink.add(data);
        },
        handleError: (error, stackTrace, sink) {
          debugPrint('❌ [getMyOrders] ERROR: $error');
          debugPrint('❌ Stack trace: $stackTrace');
          sink.add(<OrderDto>[]);
        },
      ),
    );
  }

  Future<OrderDto> getOrder(String orderId) async {
    if (orderId.isEmpty) {
      throw ServerException(
        type: ServerExceptionType.conflict,
        message: 'Order ID cannot be empty',
      );
    }

    try {
      final response =
          await firebaseFirestore.getData(path: orderDocPath(orderId));

      if (response.data() != null) {
        final order = OrderDto.fromFirestore(response);
        debugPrint('✅ تم تحميل الطلب: $orderId');
        return order;
      } else {
        throw const ServerException(
          type: ServerExceptionType.notFound,
          message: 'Order not found.',
        );
      }
    } catch (e) {
      debugPrint('❌ خطأ في تحميل الطلب: $e');
      rethrow;
    }
  }

  Future<void> updateDeliveryStatus(UpdateDeliveryStatusDto params) async {
    if (params.orderId.isEmpty) {
      throw ServerException(
        type: ServerExceptionType.conflict,
        message: 'Order ID cannot be empty',
      );
    }

    try {
      await RetryUtility.retry(
        operation: () => firebaseFirestore.updateData(
          path: orderDocPath(params.orderId),
          data: params.toJson(),
        ),
        maxRetries: 3,
        retryIf: (e) {
          if (e is FirebaseException) {
            return NetworkRetryStrategy.shouldRetry(e);
          }
          return e is SocketException || e is TimeoutException;
        },
      );

      // Increment totalDeliveries for the driver if the order is delivered
      if (params.deliveryStatus == DeliveryStatus.delivered &&
          params.deliveryId != null) {
        debugPrint(
            '🔄 Updating totalDeliveries for driver: ${params.deliveryId}');
        await firebaseFirestore.updateData(
          path: 'drivers/${params.deliveryId}',
          data: {
            'totalDeliveries': FieldValue.increment(1),
          },
        );
      }

      debugPrint('✅ تم تحديث حالة الطلب: ${params.orderId}');
    } catch (e) {
      debugPrint('❌ خطأ في تحديث حالة الطلب: $e');
      rethrow;
    }
  }

  Future<void> updateDeliveryGeoPoint(UpdateDeliveryGeoPointDto params) async {
    if (params.orderId.isEmpty) {
      throw ServerException(
        type: ServerExceptionType.conflict,
        message: 'Order ID cannot be empty',
      );
    }

    // التحقق من صحة الموقع
    if (!GeoPointValidator.isValidGeoPoint(params.geoPoint)) {
      final error = GeoPointValidator.getValidationError(params.geoPoint);
      throw ServerException(
        type: ServerExceptionType.conflict,
        message: error ?? 'Coordinates are invalid',
      );
    }

    try {
      await RetryUtility.retry(
        operation: () => firebaseFirestore.updateData(
          path: orderDocPath(params.orderId),
          data: params.toJson(),
        ),
        maxRetries: 3,
        retryIf: (e) {
          if (e is FirebaseException) {
            return NetworkRetryStrategy.shouldRetry(e);
          }
          return e is SocketException || e is TimeoutException;
        },
      );
      debugPrint('✅ تم تحديث موقع الطلب: ${params.orderId}');
    } catch (e) {
      debugPrint('❌ خطأ في تحديث موقع الطلب: $e');
      rethrow;
    }
  }
}

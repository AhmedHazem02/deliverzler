import 'dart:async';

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
    return firebaseFirestore
        .collectionStream(
      path: ordersCollectionPath,
      queryBuilder: (query) => query.where(
        'deliveryStatus',
        whereIn: [
          DeliveryStatus.upcoming.name,
          DeliveryStatus.onTheWay.name,
        ],
      ),
    )
        .map((snapshot) {
      // Filter by pickupOption and sort by date in memory
      final orders = OrderDto.parseListOfDocument(snapshot.docs)
          .where((o) => o.pickupOption == PickupOption.delivery)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return orders;
    }).transform(
      StreamTransformer<List<OrderDto>, List<OrderDto>>.fromHandlers(
        handleData: (data, sink) {
          debugPrint('📦 Orders received: ${data.length}');
          sink.add(data);
        },
        handleError: (error, stackTrace, sink) {
          debugPrint('❌ Orders error: $error');
          sink.add(<OrderDto>[]);
        },
      ),
    );
  }

  /// Get orders assigned to a specific delivery user (on the way or delivered)
  Stream<List<OrderDto>> getMyOrders(String deliveryId) {
    return firebaseFirestore
        .collectionStream(
      path: ordersCollectionPath,
      queryBuilder: (query) =>
          query.where('deliveryId', isEqualTo: deliveryId).where(
        'deliveryStatus',
        whereIn: [
          DeliveryStatus.onTheWay.name,
          DeliveryStatus.delivered.name,
        ],
      ),
    )
        .map((snapshot) {
      final orders = OrderDto.parseListOfDocument(snapshot.docs)
        ..sort((a, b) => b.date.compareTo(a.date));
      return orders;
    }).transform(
      StreamTransformer<List<OrderDto>, List<OrderDto>>.fromHandlers(
        handleData: (data, sink) {
          debugPrint('📦 My orders received: ${data.length}');
          sink.add(data);
        },
        handleError: (error, stackTrace, sink) {
          debugPrint('❌ My orders error: $error');
          sink.add(<OrderDto>[]);
        },
      ),
    );
  }

  Future<OrderDto> getOrder(String orderId) async {
    if (orderId.isEmpty) {
      throw const ClientException(
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
      throw const ClientException(
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
      debugPrint('✅ تم تحديث حالة الطلب: ${params.orderId}');
    } catch (e) {
      debugPrint('❌ خطأ في تحديث حالة الطلب: $e');
      rethrow;
    }
  }

  Future<void> updateDeliveryGeoPoint(UpdateDeliveryGeoPointDto params) async {
    if (params.orderId.isEmpty) {
      throw const ClientException(
        message: 'Order ID cannot be empty',
      );
    }

    // التحقق من صحة الموقع
    if (!GeoPointValidator.isValidGeoPoint(params.geoPoint)) {
      final error = GeoPointValidator.getValidationError(params.geoPoint);
      throw ClientException(message: error ?? 'Coordinates are invalid');
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


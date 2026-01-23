import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/infrastructure/error/app_exception.dart';
import '../../../../core/infrastructure/network/main_api/api_callers/firebase_firestore_facade.dart';
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
    final response =
        await firebaseFirestore.getData(path: orderDocPath(orderId));
    if (response.data() != null) {
      return OrderDto.fromFirestore(response);
    } else {
      throw const ServerException(
        type: ServerExceptionType.notFound,
        message: 'Order not found.',
      );
    }
  }

  Future<void> updateDeliveryStatus(UpdateDeliveryStatusDto params) async {
    await firebaseFirestore.updateData(
      path: orderDocPath(params.orderId),
      data: params.toJson(),
    );
  }

  Future<void> updateDeliveryGeoPoint(UpdateDeliveryGeoPointDto params) async {
    await firebaseFirestore.updateData(
      path: orderDocPath(params.orderId),
      data: params.toJson(),
    );
  }
}


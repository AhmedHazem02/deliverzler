import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/order.dart';
import '../../domain/update_delivery_geopoint.dart';
import '../../domain/update_delivery_status.dart';
import '../../domain/value_objects.dart';
import '../data_sources/orders_remote_data_source.dart';
import '../dtos/update_delivery_geo_point_dto.dart';
import '../dtos/update_delivery_status_dto.dart';

part 'orders_repo.g.dart';

@Riverpod(keepAlive: true)
OrdersRepo ordersRepo(Ref ref) {
  return OrdersRepo(ref);
}

class OrdersRepo {
  OrdersRepo(this.ref);

  final Ref ref;
  OrdersRemoteDataSource get remoteDataSource =>
      ref.read(ordersRemoteDataSourceProvider);

  Stream<List<AppOrder>> getUpcomingOrders(String userId) {
    return remoteDataSource.getUpcomingOrders().map(
      (orders) {
        final filtered = orders
            .where(
              (order) {
                final status = order.deliveryStatus;
                final driverId = order.deliveryId;

                // Show orders ONLY if assigned to THIS driver (deliveryId == userId)
                // If deliveryId is null or empty, the order waits for admin assignment
                final isAssignedToMe = driverId != null &&
                    driverId.isNotEmpty &&
                    driverId == userId;

                // Show confirmed orders ONLY if assigned to this driver
                final isConfirmedAndMine =
                    status == DeliveryStatus.confirmed && isAssignedToMe;

                // Show orders on the way ONLY if assigned to this driver
                final isOnTheWayAndMine =
                    status == DeliveryStatus.onTheWay && isAssignedToMe;

                final shouldInclude = isConfirmedAndMine || isOnTheWayAndMine;

                return shouldInclude;
              },
            )
            .map((o) => o.toDomain())
            .toList();
        return filtered;
      },
    );
  }

  Future<AppOrder> getOrder(String orderId) async {
    final order = await remoteDataSource.getOrder(orderId);
    return order.toDomain();
  }

  Future<void> updateDeliveryStatus(UpdateDeliveryStatus params) async {
    final dto = UpdateDeliveryStatusDto.fromDomain(params);
    await remoteDataSource.updateDeliveryStatus(dto);
  }

  Future<void> updateDeliveryGeoPoint(UpdateDeliveryGeoPoint params) async {
    final dto = UpdateDeliveryGeoPointDto.fromDomain(params);
    await remoteDataSource.updateDeliveryGeoPoint(dto);
  }

  /// Get orders assigned to a specific delivery user (on the way or delivered)
  Stream<List<AppOrder>> getMyOrders(String userId) {
    return remoteDataSource.getMyOrders(userId).map(
          (orders) => orders.map((o) => o.toDomain()).toList(),
        );
  }
}

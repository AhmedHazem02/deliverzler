import 'dart:async';

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
OrdersRepo ordersRepo(OrdersRepoRef ref) {
  return OrdersRepo(ref);
}

class OrdersRepo {
  OrdersRepo(this.ref);

  final Ref ref;
  OrdersRemoteDataSource get remoteDataSource =>
      ref.read(ordersRemoteDataSourceProvider);

  Stream<List<AppOrder>> getUpcomingOrders(String userId) {
    print(
        '🏪 OrdersRepo.getUpcomingOrders called for userId: $userId'); // DEBUG
    return remoteDataSource.getUpcomingOrders().map(
      (orders) {
        print('📦 Raw orders from remote: ${orders.length}'); // DEBUG
        final filtered = orders
            .where(
              (order) {
                final status = order.deliveryStatus;
                // Show all upcoming orders (available for any delivery to take)
                // OR orders that are on the way and assigned to this delivery
                final shouldInclude = status == DeliveryStatus.upcoming ||
                    (status == DeliveryStatus.onTheWay &&
                        order.deliveryId == userId);
                print(
                    '  Order ${order.id}: status=$status, deliveryId=${order.deliveryId}, include=$shouldInclude'); // DEBUG
                return shouldInclude;
              },
            )
            .map((o) => o.toDomain())
            .toList();
        print('✅ Filtered orders: ${filtered.length}'); // DEBUG
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

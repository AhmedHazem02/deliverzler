// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';

import '../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/presentation/providers/provider_utils.dart';
import '../../../../core/presentation/utils/fp_framework.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/order.dart';
import '../../domain/value_objects.dart';
import 'my_delivering_orders_provider.dart';
import 'upcoming_orders_provider.dart';

part 'selected_order_provider.g.dart';

@riverpod
class SelectedOrderId extends _$SelectedOrderId {
  @override
  Option<String> build() {
    ref.keepAliveUntilNoListeners();

    final userId = ref.watch(currentUserProvider.select((user) => user.id));

    // First try onTheWay orders (driver actively delivering)
    final deliveringOrders = ref.watch(myDeliveringOrdersProvider);
    print(
        '🔍 [SelectedOrderId] Delivering Orders (onTheWay) count: ${deliveringOrders.length}');

    if (deliveringOrders.isNotEmpty) {
      print(
          '🔍 [SelectedOrderId] Auto-selecting onTheWay order: ${deliveringOrders.first.id}');
      return Some(deliveringOrders.first.id);
    }

    // Then try confirmed orders assigned to this driver
    final upcomingOrdersAsync = ref.watch(upcomingOrdersProvider);
    final upcomingOrders = upcomingOrdersAsync.valueOrNull ?? [];
    final confirmedOrders = upcomingOrders
        .where((order) =>
            order.deliveryId == userId &&
            order.deliveryStatus == DeliveryStatus.confirmed)
        .toList();

    print(
        '🔍 [SelectedOrderId] Confirmed Orders for driver count: ${confirmedOrders.length}');

    if (confirmedOrders.isNotEmpty) {
      print(
          '🔍 [SelectedOrderId] Auto-selecting confirmed order: ${confirmedOrders.first.id}');
      return Some(confirmedOrders.first.id);
    }

    print('🔍 [SelectedOrderId] No orders found for driver.');
    return const None();
  }

  void update(Option<String> Function(Option<String> state) fn) =>
      state = fn(state);
}

@riverpod
Option<AppOrder> selectedOrder(Ref ref) {
  final selectedOrderId = ref.watch(selectedOrderIdProvider);
  return selectedOrderId.match(
    () => const None(),
    (id) {
      // First try to find in delivering orders (onTheWay)
      final deliveringOrders = ref.watch(myDeliveringOrdersProvider);
      final deliveringOrder =
          deliveringOrders.firstWhereOrNull((order) => order.id == id);
      if (deliveringOrder != null) {
        return Some(deliveringOrder);
      }

      // Then try to find in all upcoming orders (confirmed + onTheWay)
      final upcomingOrdersAsync = ref.watch(upcomingOrdersProvider);
      return upcomingOrdersAsync.maybeWhen(
        data: (orders) => Option<AppOrder>.fromNullable(
          orders.firstWhereOrNull((order) => order.id == id),
        ),
        orElse: () => const None(),
      );
    },
  );
}

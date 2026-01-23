import 'dart:async';

import '../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/order.dart';
import '../../domain/value_objects.dart';
import '../../infrastructure/repos/orders_repo.dart';

part 'my_orders_provider.g.dart';

/// Provider for orders assigned to the current delivery user
/// Shows orders that are either on the way or delivered
@riverpod
Stream<List<AppOrder>> myOrders(Ref ref) {
  final userId = ref.watch(currentUserProvider.select((user) => user.id));
  return ref.watch(ordersRepoProvider).getMyOrders(userId);
}

/// Filter for my orders - all, on the way, or delivered
enum MyOrdersFilter { all, onTheWay, delivered }

@riverpod
class MyOrdersFilterState extends _$MyOrdersFilterState {
  @override
  MyOrdersFilter build() => MyOrdersFilter.all;

  void setFilter(MyOrdersFilter filter) {
    state = filter;
  }
}

/// Filtered my orders based on the selected filter
@riverpod
List<AppOrder> filteredMyOrders(Ref ref) {
  final ordersAsync = ref.watch(myOrdersProvider);
  final filter = ref.watch(myOrdersFilterStateProvider);

  return ordersAsync.maybeWhen(
    data: (orders) {
      switch (filter) {
        case MyOrdersFilter.all:
          return orders;
        case MyOrdersFilter.onTheWay:
          return orders
              .where((o) => o.deliveryStatus == DeliveryStatus.onTheWay)
              .toList();
        case MyOrdersFilter.delivered:
          return orders
              .where((o) => o.deliveryStatus == DeliveryStatus.delivered)
              .toList();
      }
    },
    orElse: () => [],
  );
}


import '../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/order.dart';
import '../../domain/value_objects.dart';
import 'upcoming_orders_provider.dart';

part 'my_delivering_orders_provider.g.dart';

@riverpod
List<AppOrder> myDeliveringOrders(Ref ref) {
  final userId = ref.watch(currentUserProvider.select((user) => user.id));
  final orders = ref.watch(
    upcomingOrdersProvider.select(
      (orders) {
        final allOrders = orders.valueOrNull ?? [];
        
        final filtered = allOrders
            .where(
              (order) {
                final match = order.deliveryId == userId && order.deliveryStatus == DeliveryStatus.onTheWay;
                
                return match;
              },
            )
            .toList();
        return filtered;
      },
    ),
  );
  return orders ?? [];
}


import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/order.dart';
import '../../domain/value_objects.dart';
import 'upcoming_orders_provider.dart';

part 'pending_review_orders_provider.g.dart';

/// Provider that filters orders pending admin review from the upcoming orders
/// This helps display an indicator in the home screen showing how many orders
/// are waiting for admin decision on driver's excuse
@riverpod
List<AppOrder> pendingReviewOrders(Ref ref) {
  final ordersAsync = ref.watch(upcomingOrdersProvider);

  return ordersAsync.maybeWhen(
    data: (orders) => orders
        .where((order) => order.rejectionStatus == RejectionStatus.requested)
        .toList(),
    orElse: () => [],
  );
}

/// Provider that returns count of orders pending admin review
@riverpod
int pendingReviewCount(Ref ref) {
  return ref.watch(pendingReviewOrdersProvider).length;
}

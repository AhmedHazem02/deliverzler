import 'package:flutter/material.dart';

import '../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../core/presentation/routing/app_router.dart';
import '../../../../core/presentation/styles/styles.dart';
import '../../../../core/presentation/utils/fp_framework.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../core/presentation/widgets/toasts.dart';
import '../../domain/order.dart';
import '../../domain/orders_service.dart';
import '../../domain/pickup_stop.dart';
import '../../domain/update_delivery_status.dart';
import '../../domain/value_objects.dart';
import '../providers/selected_order_provider.dart';
import '../providers/submit_excuse_provider.dart';
import '../providers/upcoming_orders_provider.dart';
import '../providers/update_delivery_status_provider/update_delivery_status_provider.dart';
import '../widgets/order_dialogs.dart';
import 'card_button_component.dart';
import 'card_details_button_component.dart';
import 'card_order_details_component.dart';
import 'card_user_details_component.dart';

class CardItemComponent extends ConsumerWidget {
  const CardItemComponent({
    required this.order,
    super.key,
  });

  final AppOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserProvider.select((user) => user.id));
    final isConfirmedOrder = order.deliveryStatus == DeliveryStatus.confirmed;
    final isRejectionPending =
        order.rejectionStatus == RejectionStatus.requested;
    final isAdminRefused =
        order.rejectionStatus == RejectionStatus.adminRefused;

    ({bool canProceed, bool isLoading}) fetchOrderAuthority() {
      return ref.read(ordersServiceProvider).orderAuthority(
            userId: userId,
            orderDeliveryId: order.deliveryId,
          );
    }

    void showMap() {
      final authority = fetchOrderAuthority();

      switch (authority) {
        case (canProceed: true, isLoading: false):
          ref
              .read(selectedOrderIdProvider.notifier)
              .update((_) => Some(order.id));
          const MapRoute().go(context);
        case (canProceed: false, isLoading: false):
          OrderDialogs.showCanNotProceedDialog(context);
        case _:
          return;
      }
    }

    Future<void> confirmOrder() async {
      final authority = fetchOrderAuthority();

      switch (authority) {
        case (canProceed: true, isLoading: false):
          return OrderDialogs.confirmChoiceDialog(
            context,
            tr(context).doYouWantToConfirmTheOrder,
          ).then(
            (confirmChoice) {
              if (confirmChoice) {
                final params = UpdateDeliveryStatus(
                  orderId: order.id,
                  deliveryStatus: DeliveryStatus.delivered,
                );
                ref
                    .read(updateDeliveryStatusControllerProvider.notifier)
                    .updateStatus(params);
              }
            },
          );
        case (canProceed: false, isLoading: false):
          OrderDialogs.showCanNotProceedDialog(context);
        case _:
          return;
      }
    }

    Future<void> deliverOrder() async {
      final authority = fetchOrderAuthority();

      switch (authority) {
        case (canProceed: _, isLoading: false):
          final confirmChoice = await OrderDialogs.confirmChoiceDialog(
            context,
            tr(context).doYouWantToDeliverTheOrder,
          );
          if (confirmChoice) {
            final params = UpdateDeliveryStatus(
              orderId: order.id,
              deliveryStatus: DeliveryStatus.onTheWay,
              deliveryId: userId,
            );
            await ref
                .read(updateDeliveryStatusControllerProvider.notifier)
                .updateStatus(params);
          }
        case _:
          return;
      }
    }

    Future<void> submitExcuse() async {
      // Cannot submit excuse if already pending or admin refused
      if (isRejectionPending) {
        Toasts.showTitledToast(
          context,
          title: tr(context).cannotSubmitExcuse,
          description: tr(context).waitingAdminReview,
        );
        return;
      }

      if (isAdminRefused) {
        Toasts.showTitledToast(
          context,
          title: tr(context).excuseRefused,
          description: tr(context).mustDeliverOrder,
        );
        return;
      }

      final authority = fetchOrderAuthority();

      switch (authority) {
        case (canProceed: true, isLoading: false):
          return OrderDialogs.showExcuseSubmissionDialog(context).then(
            (excuseReason) async {
              if (excuseReason != null && excuseReason.trim().isNotEmpty) {
                await ref
                    .read(submitExcuseControllerProvider.notifier)
                    .submitExcuse(
                      order: order,
                      reason: excuseReason,
                    );

                // Force refresh orders to get updated rejectionStatus
                ref.invalidate(upcomingOrdersProvider);

                if (context.mounted) {
                  Toasts.showTitledToast(
                    context,
                    title: tr(context).excuseSubmittedSuccessfully,
                    description: tr(context).waitingAdminReview,
                  );
                }
              }
            },
          );
        case (canProceed: false, isLoading: false):
          OrderDialogs.showCanNotProceedDialog(context);
        case _:
          return;
      }
    }

    return Card(
      elevation: 6,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.cardR12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.cardPaddingV16,
          horizontal: Sizes.cardPaddingH20,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CardOrderDetailsComponent(
                    order: order,
                  ),
                ),
                CardDetailsButtonComponent(
                  title: tr(context).details,
                  onPressed: () {
                    OrderDialogs.showOrderDetailsDialog(
                      context,
                      order: order,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: Sizes.marginV8,
            ),
            CardUserDetailsComponent(
              order: order,
            ),
            const SizedBox(
              height: Sizes.marginV8,
            ),
            // Multi-store pickup stops section
            if (order.isMultiStore) ...[
              _MultiStoreStopsSection(order: order),
              const SizedBox(height: Sizes.marginV8),
            ],
            if (isRejectionPending)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.paddingV8,
                  horizontal: Sizes.paddingH12,
                ),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Sizes.cardR8),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.hourglass_top,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ),
                        const SizedBox(width: Sizes.marginH8),
                        Expanded(
                          child: Text(
                            tr(context).waitingAdminReview,
                            style: TextStyles.f14(context).copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Sizes.marginV6),
                    Text(
                      tr(context).buttonsDisabledUntilReview,
                      style: TextStyles.f12(context).copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            if (isRejectionPending)
              const SizedBox(
                height: Sizes.marginV8,
              ),
            // Admin refused excuse - mandatory delivery warning
            if (isAdminRefused)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.paddingV8,
                  horizontal: Sizes.paddingH12,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Sizes.cardR8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Theme.of(context).colorScheme.error,
                          size: 24,
                        ),
                        const SizedBox(width: Sizes.marginH8),
                        Expanded(
                          child: Text(
                            tr(context).mustDeliverOrder,
                            style: TextStyles.f14(context).copyWith(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (order.adminComment != null &&
                        order.adminComment!.isNotEmpty) ...[
                      const SizedBox(height: Sizes.marginV8),
                      Text(
                        '${tr(context).refusalReason}: ${order.adminComment}',
                        style: TextStyles.f12(context).copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            if (isAdminRefused)
              const SizedBox(
                height: Sizes.marginV8,
              ),
            // Show map button only for onTheWay orders
            if (!isConfirmedOrder)
              CardButtonComponent(
                title: tr(context).showMap,
                isColored: true,
                onPressed: isRejectionPending ? null : showMap,
              ),
            if (!isConfirmedOrder)
              const SizedBox(
                height: Sizes.marginV6,
              ),
            // Show excuse button ONLY for confirmed orders (not onTheWay)
            // and only if admin hasn't refused
            if (isConfirmedOrder && !isAdminRefused)
              CardButtonComponent(
                title: tr(context).submitExcuse,
                isColored: false,
                onPressed: isRejectionPending ? null : submitExcuse,
              ),
            if (isConfirmedOrder && !isAdminRefused)
              const SizedBox(
                height: Sizes.marginV6,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isConfirmedOrder)
                  Expanded(
                    child: CardButtonComponent(
                      title: tr(context).deliver,
                      isColored: true,
                      onPressed: isRejectionPending ? null : deliverOrder,
                    ),
                  )
                else
                  Expanded(
                    child: CardButtonComponent(
                      title: tr(context).confirm,
                      isColored: true,
                      onPressed: isRejectionPending ? null : confirmOrder,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the list of pickup stops for a multi-store order (read-only).
/// Status is managed by the backend/store, not by the driver.
class _MultiStoreStopsSection extends StatelessWidget {
  const _MultiStoreStopsSection({required this.order});

  final AppOrder order;

  @override
  Widget build(BuildContext context) {
    final stops = order.pickupStops;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.3),
        borderRadius: BorderRadius.circular(Sizes.cardR8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.store,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'محلات الطلب (${stops.length})',
                style: TextStyles.f14(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Stops list
          ...List.generate(stops.length, (index) {
            final stop = stops[index];
            return _PickupStopTile(stop: stop, index: index + 1);
          }),
        ],
      ),
    );
  }
}

/// A single pickup stop tile showing store name, item count, and subtotal (read-only).
class _PickupStopTile extends StatelessWidget {
  const _PickupStopTile({
    required this.stop,
    required this.index,
  });

  final PickupStop stop;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          // Index circle
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyles.f12(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Store name and details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop.storeName,
                  style: TextStyles.f14(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${stop.items.isNotEmpty ? '${stop.totalItemsCount} صنف • ' : ''}${stop.subtotal.toStringAsFixed(0)} ج.م',
                  style: TextStyles.f12(context).copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

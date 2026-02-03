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
import '../../domain/update_delivery_status.dart';
import '../../domain/value_objects.dart';
import '../providers/selected_order_provider.dart';
import '../providers/submit_excuse_provider.dart';
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
    final isUpcomingOrder = order.deliveryStatus == DeliveryStatus.upcoming;
    final isRejectionPending =
        order.rejectionStatus == RejectionStatus.requested;

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

    Future<void> cancelOrder() async {
      final authority = fetchOrderAuthority();

      switch (authority) {
        case (canProceed: true, isLoading: false):
          return OrderDialogs.showCancelOrderDialog(context).then(
            (cancelNote) {
              if (cancelNote != null) {
                final params = UpdateDeliveryStatus(
                  orderId: order.id,
                  deliveryStatus: DeliveryStatus.canceled,
                  employeeCancelNote: cancelNote,
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

    Future<void> submitExcuse() async {
      if (isRejectionPending) {
        Toasts.showTitledToast(
          context,
          title: tr(context).cannotSubmitExcuse,
          description: tr(context).waitingAdminReview,
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
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                    const SizedBox(width: Sizes.marginH8),
                    Expanded(
                      child: Text(
                        tr(context).waitingAdminReview,
                        style: TextStyles.f14(context).copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (isRejectionPending)
              const SizedBox(
                height: Sizes.marginV8,
              ),
            if (!isUpcomingOrder)
              CardButtonComponent(
                title: tr(context).showMap,
                isColored: true,
                onPressed: isRejectionPending ? null : showMap,
              ),
            const SizedBox(
              height: Sizes.marginV6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CardButtonComponent(
                    title: tr(context).cancel,
                    isColored: false,
                    onPressed: isRejectionPending ? null : cancelOrder,
                  ),
                ),
                const SizedBox(width: Sizes.marginH8),
                Expanded(
                  child: CardButtonComponent(
                    title: tr(context).submitExcuse,
                    isColored: false,
                    onPressed: isRejectionPending ? null : submitExcuse,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: Sizes.marginV6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isUpcomingOrder)
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

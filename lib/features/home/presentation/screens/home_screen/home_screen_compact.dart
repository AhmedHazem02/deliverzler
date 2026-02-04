import 'package:flutter/material.dart';

import '../../../../../core/core_features/theme/presentation/utils/custom_colors.dart';
import '../../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../../core/presentation/screens/nested_screen_scaffold.dart';
import '../../../../../core/presentation/styles/styles.dart';
import '../../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../../core/presentation/widgets/loading_widgets.dart';
import '../../components/retry_again_component.dart';
import '../../components/upcoming_orders_component.dart';
import '../../providers/driver_availability_provider.dart';
import '../../providers/location_stream_provider.dart';
import '../../providers/order_rejection_listener_provider.dart';
import '../../providers/pending_review_orders_provider.dart';
import '../../providers/save_route_history_provider.dart';
import '../../providers/update_delivery_geo_point_provider.dart';
import '../../utils/location_error.dart';

class HomeScreenCompact extends HookConsumerWidget {
  const HomeScreenCompact({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(
      //Using select to avoid rebuilding when location change
      locationStreamProvider.select((value) => value.whenData((value) => true)),
    );

    ref.listen(updateDeliveryGeoPointStateProvider, (previous, next) {});

    // FIX: Save route history every 15s or 100m for dispute resolution
    ref.listen(saveRouteHistoryProvider, (previous, next) {});

    // Listen to order rejection status updates
    ref.watch(orderRejectionListenerProvider);

    final availabilityAsync = ref.watch(driverAvailabilityProvider);

    return NestedScreenScaffold(
      body: Column(
        children: [
          // App Bar with Online/Offline Switch
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.screenPaddingH28,
              vertical: Sizes.screenPaddingV16,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    tr(context).home,
                    style: TextStyles.f20(context).copyWith(
                      fontWeight: FontStyles.fontWeightSemiBold,
                    ),
                  ),
                ),
                // Online/Offline Switch
                availabilityAsync.when(
                  loading: () => const SizedBox(
                    width: 80,
                    child: Center(
                        child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (isOnline) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOnline
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isOnline ? Colors.green : Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isOnline ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isOnline
                              ? tr(context).available
                              : tr(context).unavailable,
                          style: TextStyles.f14(context).copyWith(
                            color: isOnline ? Colors.green : Colors.grey,
                            fontWeight: FontStyles.fontWeightSemiBold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        SizedBox(
                          height: 24,
                          child: Switch(
                            value: isOnline,
                            onChanged: (_) {
                              ref
                                  .read(driverAvailabilityProvider.notifier)
                                  .toggleAvailability();
                            },
                            activeColor: Colors.green,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Pending review indicator
          Builder(
            builder: (context) {
              final pendingCount = ref.watch(pendingReviewCountProvider);
              if (pendingCount == 0) return const SizedBox.shrink();

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.screenPaddingH28,
                  vertical: Sizes.paddingV8,
                ),
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                child: Row(
                  children: [
                    Icon(
                      Icons.hourglass_top,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${tr(context).pendingAdminReview}: $pendingCount',
                      style: TextStyles.f14(context).copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Body content
          Expanded(
            child: locationAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: !locationAsync.hasError,
              loading: () => TitledLoadingIndicator(
                  message: tr(context).determine_location),
              error: (error, st) => RetryAgainComponent(
                description: (error as LocationError).getErrorText(context),
                onPressed: () {
                  ref.invalidate(locationStreamProvider);
                },
              ),
              data: (_) => const UpcomingOrdersComponent(),
            ),
          ),
        ],
      ),
    );
  }
}

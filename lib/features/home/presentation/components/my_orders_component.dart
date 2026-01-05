import 'package:flutter/material.dart';

import '../../../../core/presentation/extensions/future_extensions.dart';
import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../core/presentation/styles/styles.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../core/presentation/widgets/loading_widgets.dart';
import '../../../../core/presentation/widgets/platform_widgets/platform_refresh_indicator.dart';
import '../../../../core/presentation/widgets/seperated_sliver_child_builder_delegate.dart';
import '../providers/my_orders_provider.dart';
import 'my_order_card_component.dart';

class MyOrdersComponent extends ConsumerWidget {
  const MyOrdersComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myOrdersAsync = ref.watch(myOrdersProvider);
    final filter = ref.watch(myOrdersFilterStateProvider);

    Future<void> refresh() async {
      return ref.refresh(myOrdersProvider.future).suppressError();
    }

    return Column(
      children: [
        // Filter chips
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.screenPaddingH28,
            vertical: Sizes.marginV8,
          ),
          child: Row(
            children: [
              _FilterChip(
                label: tr(context).all,
                isSelected: filter == MyOrdersFilter.all,
                onSelected: () => ref
                    .read(myOrdersFilterStateProvider.notifier)
                    .setFilter(MyOrdersFilter.all),
              ),
              const SizedBox(width: Sizes.marginH8),
              _FilterChip(
                label: tr(context).onTheWay,
                isSelected: filter == MyOrdersFilter.onTheWay,
                onSelected: () => ref
                    .read(myOrdersFilterStateProvider.notifier)
                    .setFilter(MyOrdersFilter.onTheWay),
              ),
              const SizedBox(width: Sizes.marginH8),
              _FilterChip(
                label: tr(context).delivered,
                isSelected: filter == MyOrdersFilter.delivered,
                onSelected: () => ref
                    .read(myOrdersFilterStateProvider.notifier)
                    .setFilter(MyOrdersFilter.delivered),
              ),
            ],
          ),
        ),
        // Orders list
        Expanded(
          child: myOrdersAsync.when(
            skipLoadingOnReload: true,
            skipLoadingOnRefresh: !myOrdersAsync.hasError,
            data: (orders) {
              final filteredOrders = ref.watch(filteredMyOrdersProvider);
              return PlatformRefreshIndicator(
                onRefresh: refresh,
                slivers: [
                  if (filteredOrders.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Sizes.screenPaddingV16,
                        horizontal: Sizes.screenPaddingH28,
                      ),
                      sliver: SliverList(
                        delegate: SeparatedSliverChildBuilderDelegate(
                          itemBuilder: (BuildContext context, int index) {
                            return MyOrderCardComponent(
                              key: ValueKey(filteredOrders[index].id),
                              order: filteredOrders[index],
                            );
                          },
                          itemCount: filteredOrders.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: Sizes.marginV28,
                            );
                          },
                        ),
                      ),
                    )
                  else
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          tr(context).noOrdersFound,
                          style: TextStyles.f18(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
            error: (error, st) => PlatformRefreshIndicator(
              onRefresh: refresh,
              slivers: [
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      '${tr(context).somethingWentWrong}\n${tr(context).pleaseTryAgain}',
                      style: TextStyles.f18(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            loading: () => const DeliveryLoadingAnimation(),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }
}

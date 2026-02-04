import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../../core/presentation/styles/styles.dart';
import '../../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../domain/order.dart';
import '../../../domain/order_item.dart';
import '../../providers/order_items_provider.dart';
import '../../providers/store_provider.dart';

class OrderDetailsDialog extends StatelessWidget {
  const OrderDetailsDialog({
    required this.order,
    super.key,
  });
  final AppOrder order;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 320,
        maxWidth: 500,
        maxHeight: 700,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Order ID
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.receipt_long,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(context).orderDetails,
                          style: TextStyles.f14(context).copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.9),
                          ),
                        ),
                        Text(
                          '#${order.id.substring(0, 8)}',
                          style: TextStyles.f18SemiBold(context).copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.deliveryStatus.name.toUpperCase(),
                      style: TextStyles.f12(context).copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Order Items Section - Using FutureBuilder
            Consumer(
              builder: (context, ref, child) {
                final orderItemsAsync = ref.watch(orderItemsProvider(order.id));

                return orderItemsAsync.when(
                  data: (items) => _buildOrderItemsSection(context, items),
                  loading: () => _buildLoadingOrderItems(context),
                  error: (error, stack) =>
                      _buildErrorOrderItems(context, error),
                );
              },
            ),

            const SizedBox(height: 20),

            // Store Information Section (fetch from `stores` collection)
            if (order.storeId != null && order.storeId!.isNotEmpty) ...[
              _buildSectionHeader(
                context,
                icon: Icons.store,
                title: 'معلومات المتجر',
              ),
              const SizedBox(height: 12),
              Consumer(
                builder: (context, ref, child) {
                  final storeAsync = ref.watch(storeProvider(order.storeId!));
                  return storeAsync.when(
                    data: (store) {
                      final displayName = (store != null &&
                              store.name.isNotEmpty)
                          ? store.name
                          : (order.storeName != null &&
                                  order.storeName!.isNotEmpty)
                              ? order.storeName!
                              : '#${order.storeId!.substring(0, order.storeId!.length > 8 ? 8 : order.storeId!.length)}';
                      final displayAddress =
                          (store != null && store.address.isNotEmpty)
                              ? store.address
                              : (order.storeAddress != null &&
                                      order.storeAddress!.isNotEmpty)
                                  ? order.storeAddress!
                                  : '';

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.store_outlined,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'اسم المتجر',
                                    style: TextStyles.f12(context).copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    displayName,
                                    style: TextStyles.f14(context).copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (displayAddress.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      displayAddress,
                                      style: TextStyles.f12(context).copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () {
                      // show fallback while loading
                      final fallbackName = (order.storeName != null &&
                              order.storeName!.isNotEmpty)
                          ? order.storeName!
                          : '#${order.storeId!.substring(0, order.storeId!.length > 8 ? 8 : order.storeId!.length)}';
                      final fallbackAddress = (order.storeAddress != null &&
                              order.storeAddress!.isNotEmpty)
                          ? order.storeAddress!
                          : '';
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.store_outlined,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'اسم المتجر',
                                    style: TextStyles.f12(context).copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    fallbackName,
                                    style: TextStyles.f14(context).copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (fallbackAddress.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      fallbackAddress,
                                      style: TextStyles.f12(context).copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    error: (err, st) {
                      final fallbackName = (order.storeName != null &&
                              order.storeName!.isNotEmpty)
                          ? order.storeName!
                          : '#${order.storeId!.substring(0, order.storeId!.length > 8 ? 8 : order.storeId!.length)}';
                      final fallbackAddress = (order.storeAddress != null &&
                              order.storeAddress!.isNotEmpty)
                          ? order.storeAddress!
                          : '';
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.store_outlined,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'اسم المتجر',
                                    style: TextStyles.f12(context).copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    fallbackName,
                                    style: TextStyles.f14(context).copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (fallbackAddress.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      fallbackAddress,
                                      style: TextStyles.f12(context).copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],

            // User Details
            _buildSectionHeader(
              context,
              icon: Icons.person,
              title: tr(context).userDetails,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    context,
                    icon: Icons.person_outline,
                    label: tr(context).name,
                    value: order.userName.isEmpty
                        ? '${tr(context).user} ${order.userId.substring(0, 6)}'
                        : order.userName,
                  ),
                  if (order.address != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      icon: Icons.location_on_outlined,
                      label: tr(context).details,
                      value:
                          '${order.address!.state}, ${order.address!.city}, ${order.address!.street}',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      icon: Icons.phone_outlined,
                      label: tr(context).mobileNumber,
                      value: order.address!.mobile,
                    ),
                  ]
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Note Section
            if (order.userNote.isNotEmpty) ...[
              _buildSectionHeader(
                context,
                icon: Icons.note_outlined,
                title: tr(context).note,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.5),
                  ),
                ),
                child: Text(
                  order.userNote,
                  style: TextStyles.f14(context),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context,
      {required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyles.f16SemiBold(context).copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context,
      {required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Theme.of(context).hintColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyles.f12(context).copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyles.f14(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItemsSection(BuildContext context, List<OrderItem> items) {
    if (items.isEmpty) {
      return _buildEmptyOrderItems(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          icon: Icons.shopping_bag,
          title: 'المنتجات المطلوبة',
        ),
        const SizedBox(height: 12),

        // Items List
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    _buildOrderItem(context, item),
                    if (index < items.length - 1)
                      Divider(
                        height: 1,
                        color: Theme.of(context).dividerColor.withOpacity(0.3),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Totals Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              _buildDetailRow(
                context,
                'المجموع الفرعي',
                '${order.subTotal.toStringAsFixed(0)} ${tr(context).currency}',
                isBold: false,
              ),
              if (order.deliveryFee != null && order.deliveryFee! > 0) ...[
                const SizedBox(height: 8),
                _buildDetailRow(
                  context,
                  'رسوم التوصيل',
                  '${order.deliveryFee!.toStringAsFixed(0)} ${tr(context).currency}',
                  isBold: false,
                ),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(
                  color: Theme.of(context).dividerColor,
                  thickness: 1,
                ),
              ),
              _buildDetailRow(
                context,
                'المجموع الكلي',
                '${order.total.toStringAsFixed(0)} ${tr(context).currency}',
                isBold: true,
                valueColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOrderItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'جاري تحميل المنتجات...',
              style: TextStyles.f14(context).copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorOrderItems(BuildContext context, Object error) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'حدث خطأ في تحميل المنتجات',
              style: TextStyles.f14(context).copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyOrderItems(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Icon(
              Icons.shopping_basket_outlined,
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد منتجات في هذا الطلب',
              style: TextStyles.f14(context).copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? TextStyles.f16SemiBold(context)
              : TextStyles.f14(context),
        ),
        Text(
          value,
          style: (isBold
                  ? TextStyles.f16SemiBold(context)
                  : TextStyles.f14(context))
              .copyWith(
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: item.imageUrl!,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.restaurant,
                        size: 32,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  )
                : Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.restaurant,
                      size: 32,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyles.f14(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.close,
                            size: 12,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${item.quantity}',
                            style: TextStyles.f12(context).copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${item.price.toStringAsFixed(0)} ${tr(context).currency}',
                      style: TextStyles.f12(context).copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
                if (item.description != null &&
                    item.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description!,
                    style: TextStyles.f12(context).copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Item Total Price
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${item.total.toStringAsFixed(0)}',
              style: TextStyles.f14(context).copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

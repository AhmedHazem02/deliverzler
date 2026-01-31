import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';


import '../../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../../core/presentation/styles/styles.dart';
import '../../../domain/order.dart';
import '../../../domain/order_item.dart';

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
        minWidth: Sizes.dialogWidth280,
        maxHeight: 600,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Order Details Header
            Text(
              '${tr(context).orderDetails}:',
              style: TextStyles.f16SemiBold(context).copyWith(
                decoration: TextDecoration.underline,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: Sizes.marginV8),
            _buildDetailRow(context, tr(context).id, '#${order.id.substring(0, 6)}'),
            _buildDetailRow(context, tr(context).status, order.pickupOption.name),
            _buildDetailRow(context, tr(context).payment, order.paymentMethod),
            
            const SizedBox(height: Sizes.marginV12),
            const Divider(),
            const SizedBox(height: Sizes.marginV12),

            // Order Items Section
            if (order.items.isNotEmpty) ...[
              Text(
                '${tr(context).orderItems}:',
                style: TextStyles.f18SemiBold(context).copyWith(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: Sizes.marginV8),
              ...order.items.asMap().entries.map((entry) {
                 final index = entry.key;
                 final item = entry.value;
                 return Column(
                   children: [
                     _buildOrderItem(context, item),
                     if (index < order.items.length - 1)
                        const Divider(height: 16),
                   ],
                 );
              }),
              const SizedBox(height: Sizes.marginV16),

              // Totals Section
              Container(
                padding: const EdgeInsets.all(Sizes.paddingV12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(context, tr(context).subtotal, '${order.subTotal.toStringAsFixed(0)} ${tr(context).currency}', isBold: false),
                    if (order.deliveryFee != null && order.deliveryFee! > 0) ...[
                      const SizedBox(height: 4),
                      _buildDetailRow(context, tr(context).deliveryFee, '${order.deliveryFee!.toStringAsFixed(0)} ${tr(context).currency}', isBold: false),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(color: Theme.of(context).dividerColor),
                    ),
                    _buildDetailRow(context, tr(context).total, '${order.total.toStringAsFixed(0)} ${tr(context).currency}', isBold: true, valueColor: Theme.of(context).colorScheme.primary),
                  ],
                ),
              ),
            ] else ...[
              // Empty State
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Sizes.screenPaddingV16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_basket_outlined,
                        size: 48,
                        color: Theme.of(context).disabledColor,
                      ),
                      const SizedBox(height: Sizes.marginV8),
                      Text(
                        tr(context).noItemsInOrder,
                        style: TextStyles.f14(context).copyWith(
                           color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: Sizes.marginV20),

            // User Details
            Text(
              '${tr(context).userDetails}:',
              style: TextStyles.f18SemiBold(context).copyWith(
                decoration: TextDecoration.underline,
                 color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 4.0),
            Container(
              padding: const EdgeInsets.all(Sizes.paddingV14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(context, tr(context).name, order.userName.isEmpty ? '${tr(context).user} ${order.userId.substring(0, 6)}' : order.userName),
                   if (order.address != null) ...[
                      const SizedBox(height: 8),
                      _buildDetailRow(context, tr(context).details, '${order.address!.state}, ${order.address!.city}, ${order.address!.street}'),
                      const SizedBox(height: 4),
                      _buildDetailRow(context, tr(context).mobileNumber, order.address!.mobile),
                   ]
                ],
              ),
            ),
            
            const SizedBox(height: Sizes.marginV16),

            // Note
            Text(
              '${tr(context).note}:',
              style: TextStyles.f18SemiBold(context).copyWith(
                decoration: TextDecoration.underline,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 4.0),
            Container(
               width: double.infinity,
               padding: const EdgeInsets.all(Sizes.paddingV14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                   border: Border.all(color: Theme.of(context).dividerColor),
                ),
              child: Text(
                order.userNote.isEmpty ? tr(context).none : order.userNote,
                style: TextStyles.f14(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: isBold ? TextStyles.f16SemiBold(context) : TextStyles.f16(context),
        ),
        Flexible(
          child: Text(
            value,
            style: (isBold ? TextStyles.f16SemiBold(context) : TextStyles.f16(context)).copyWith(
              color: valueColor,
            ),
             textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Item Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: item.imageUrl != null && item.imageUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: item.imageUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 60,
                    height: 60,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                     child: const Center(
                       child: SizedBox(
                         width: 20,
                         height: 20,
                         child: CircularProgressIndicator(strokeWidth: 2),
                       ),
                     ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 60,
                    height: 60,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Icon(Icons.restaurant, size: 24, color: Theme.of(context).iconTheme.color),
                  ),
                )
              : Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.restaurant, size: 24, color: Theme.of(context).iconTheme.color),
                ),
        ),
        const SizedBox(width: Sizes.marginH12),

        // Item Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: TextStyles.f14(context).copyWith(
                  fontWeight: FontStyles.fontWeightSemiBold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${tr(context).quantity}: ${item.quantity}',
                style: TextStyles.f12(context).copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
              if (item.description != null && item.description!.isNotEmpty)
                Text(
                  item.description!,
                  style: TextStyles.f12(context).copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),

        // Item Price
        Text(
          '${item.total.toStringAsFixed(0)} ${tr(context).currency}',
          style: TextStyles.f14(context).copyWith(
            fontWeight: FontStyles.fontWeightSemiBold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

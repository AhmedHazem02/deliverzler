import 'package:flutter/material.dart';

import '../../../../presentation/utils/riverpod_framework.dart';
import '../app_settings_provider.dart';
import '../../domain/app_settings.dart';

/// A widget that displays the delivery fee based on distance.
///
/// This widget automatically calculates and formats the delivery fee
/// using the app settings from Firebase.
class DeliveryFeeDisplay extends ConsumerWidget {
  const DeliveryFeeDisplay({
    required this.distanceKm,
    this.style,
    this.loadingWidget,
    this.errorWidget,
    super.key,
  });

  /// The distance in kilometers to calculate the fee for.
  final double distanceKm;

  /// Optional text style for the fee display.
  final TextStyle? style;

  /// Optional widget to show while loading.
  final Widget? loadingWidget;

  /// Optional widget to show on error.
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feeAsync =
        ref.watch(calculateDeliveryFeeProvider(distanceKm: distanceKm));
    final currencyAsync = ref.watch(currencySymbolProvider);

    return feeAsync.when(
      data: (double fee) {
        final currency = currencyAsync.valueOrNull ?? 'ج.م';
        return Text(
          '$currency ${fee.toStringAsFixed(2)}',
          style: style ?? Theme.of(context).textTheme.titleMedium,
        );
      },
      loading: () =>
          loadingWidget ??
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      error: (Object e, _) => errorWidget ?? const Text('--'),
    );
  }
}

/// A widget that displays delivery availability for a given distance.
///
/// Shows whether delivery is available for the specified distance
/// based on the app settings.
class DeliveryAvailabilityBadge extends ConsumerWidget {
  const DeliveryAvailabilityBadge({
    required this.distanceKm,
    this.availableText = 'توصيل متاح',
    this.unavailableText = 'خارج نطاق التوصيل',
    this.availableColor,
    this.unavailableColor,
    super.key,
  });

  /// The distance in kilometers to check availability for.
  final double distanceKm;

  /// Text to show when delivery is available.
  final String availableText;

  /// Text to show when delivery is not available.
  final String unavailableText;

  /// Color for available badge.
  final Color? availableColor;

  /// Color for unavailable badge.
  final Color? unavailableColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAvailableAsync =
        ref.watch(isWithinDeliveryRadiusProvider(distanceKm: distanceKm));

    return isAvailableAsync.when(
      data: (bool isAvailable) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isAvailable
                ? (availableColor ?? Colors.green).withOpacity(0.1)
                : (unavailableColor ?? Colors.red).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isAvailable
                  ? (availableColor ?? Colors.green)
                  : (unavailableColor ?? Colors.red),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isAvailable ? Icons.check_circle : Icons.cancel,
                size: 16,
                color: isAvailable
                    ? (availableColor ?? Colors.green)
                    : (unavailableColor ?? Colors.red),
              ),
              const SizedBox(width: 6),
              Text(
                isAvailable ? availableText : unavailableText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isAvailable
                      ? (availableColor ?? Colors.green)
                      : (unavailableColor ?? Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (Object e, _) => const SizedBox.shrink(),
    );
  }
}

/// A card widget that displays delivery fee breakdown.
///
/// Shows base fee, distance fee, and total delivery fee with
/// all relevant information from app settings.
class DeliveryFeeCard extends ConsumerWidget {
  const DeliveryFeeCard({
    required this.distanceKm,
    this.showBreakdown = true,
    super.key,
  });

  /// The distance in kilometers.
  final double distanceKm;

  /// Whether to show the fee breakdown or just the total.
  final bool showBreakdown;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final currencyAsync = ref.watch(currencySymbolProvider);

    return settingsAsync.when(
      data: (AppSettings settings) {
        final delivery = settings.delivery;
        final currency = currencyAsync.valueOrNull ?? 'ج.م';
        final totalFee = delivery.calculateDeliveryFee(distanceKm);
        final distanceFee = distanceKm * delivery.feePerKilometer;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'رسوم التوصيل',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    DeliveryAvailabilityBadge(distanceKm: distanceKm),
                  ],
                ),
                if (showBreakdown) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  _buildRow(
                    context,
                    'الرسوم الأساسية',
                    '$currency ${delivery.baseDeliveryFee.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 8),
                  _buildRow(
                    context,
                    'رسوم المسافة (${distanceKm.toStringAsFixed(1)} كم)',
                    '$currency ${distanceFee.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                ],
                const SizedBox(height: 12),
                _buildRow(
                  context,
                  'الإجمالي',
                  '$currency ${totalFee.toStringAsFixed(2)}',
                  isTotal: true,
                ),
                const SizedBox(height: 8),
                Text(
                  'الوقت المتوقع: ${delivery.estimatedDeliveryTime} دقيقة',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (Object e, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('خطأ في تحميل رسوم التوصيل: $e'),
        ),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
              : Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: isTotal
              ? Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  )
              : Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
        ),
      ],
    );
  }
}

/// Extension on DeliverySettings for convenient fee calculations.
extension DeliverySettingsX on DeliverySettings {
  /// Format delivery fee with currency.
  String formatFee(double distanceKm, String currency) {
    // Use this. to reference entity properties, avoiding provider name collision
    final fee = this.baseDeliveryFee + (this.feePerKilometer * distanceKm);
    return '$currency ${fee.toStringAsFixed(2)}';
  }
}

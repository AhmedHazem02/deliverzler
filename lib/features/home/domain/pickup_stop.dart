import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_item.dart';

part 'pickup_stop.freezed.dart';

/// Status of a single pickup stop within a multi-store order.
///
/// These statuses are managed by the backend/store, NOT by the driver.
/// The driver app reads these statuses for display purposes only.
enum PickupStopStatus {
  pending('pending'),
  confirmed('confirmed'),
  pickedUp('picked_up'),
  rejected('rejected');

  const PickupStopStatus(this.jsonValue);
  final String jsonValue;

  static PickupStopStatus fromValue(String value) {
    return PickupStopStatus.values.firstWhere(
      (s) => s.jsonValue == value,
      orElse: () => PickupStopStatus.pending,
    );
  }
}

/// Represents a single pickup stop in a multi-store order.
///
/// Each stop contains a store's items for the order.
/// Statuses are managed by the backend/store — the driver only reads them.
@freezed
class PickupStop with _$PickupStop {
  const factory PickupStop({
    required String storeId,
    required String storeName,
    required double subtotal,
    @Default(PickupStopStatus.pending) PickupStopStatus status,
    @Default([]) List<OrderItem> items,
    DateTime? confirmedAt,
    DateTime? pickedUpAt,
    DateTime? rejectedAt,
    String? rejectionReason,
  }) = _PickupStop;
  const PickupStop._();

  /// Whether this stop has been picked up by the driver.
  bool get isPickedUp => status == PickupStopStatus.pickedUp;

  /// Whether this stop was rejected by the store.
  bool get isRejected => status == PickupStopStatus.rejected;

  /// Whether this stop is still pending or confirmed (not yet picked up).
  bool get isActive =>
      status == PickupStopStatus.pending ||
      status == PickupStopStatus.confirmed;

  /// Total number of items in this stop.
  int get totalItemsCount =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);
}

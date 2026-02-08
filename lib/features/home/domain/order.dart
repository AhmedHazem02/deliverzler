// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/value_validators.dart';
import '../../../core/presentation/utils/fp_framework.dart';
import 'order_item.dart';
import 'pickup_stop.dart';
import 'value_objects.dart';

part 'order.freezed.dart';

@freezed
class AppOrder with _$AppOrder {
  const factory AppOrder({
    required String id,
    required int date,
    required PickupOption pickupOption,
    required String paymentMethod,
    required Address? address,
    required String userId,
    required String userName,
    required String userImage,
    required String userPhone,
    required String userNote,
    required String? employeeCancelNote,
    required DeliveryStatus deliveryStatus,
    required String? deliveryId,
    required GeoPoint? deliveryGeoPoint,
    required double? deliveryHeading,
    @Default(RejectionStatus.none) RejectionStatus rejectionStatus,
    @Default([]) List<OrderItem> items,
    @Default(0.0) double subTotal,
    @Default(0.0) double total,
    double? deliveryFee,
    // Store information
    String? storeId,
    String? storeName,
    String? storeAddress,
    // Admin comment when excuse is refused
    String? adminComment,
    // List of driver IDs who rejected/excused this order
    @Default([]) List<String> rejectedByDrivers,
    // Multi-store order fields
    @Default(OrderType.singleStore) OrderType orderType,
    @Default([]) List<PickupStop> pickupStops,
    double? driverCommission,
    String? driverName,
  }) = _AppOrder;
  const AppOrder._();

  /// Whether this is a multi-store order with pickup stops.
  bool get isMultiStore => orderType == OrderType.multiStore;

  /// Returns the current active pickup stop (first non-picked-up, non-rejected).
  PickupStop? get currentPickupStop {
    if (!isMultiStore || pickupStops.isEmpty) return null;
    try {
      return pickupStops.firstWhere((stop) => stop.isActive);
    } catch (_) {
      return null;
    }
  }

  /// Whether all non-rejected stores have been picked up.
  bool get allStoresPickedUp {
    if (!isMultiStore || pickupStops.isEmpty) return false;
    return pickupStops
        .where((stop) => !stop.isRejected)
        .every((stop) => stop.isPickedUp);
  }

  /// Number of stores that have been picked up.
  int get pickedUpStopsCount =>
      pickupStops.where((stop) => stop.isPickedUp).length;

  /// Number of active (non-rejected) stores.
  int get activeStopsCount =>
      pickupStops.where((stop) => !stop.isRejected).length;

  /// All items across all pickup stops (flattened).
  List<OrderItem> get allItems {
    if (!isMultiStore || pickupStops.isEmpty) return items;
    return pickupStops.expand((stop) => stop.items).toList();
  }

  Option<String> get validatedUserPhone =>
      ValueValidators.isNumeric(userPhone) ? Some(userPhone) : none();

  //Use custom equality implementation to ignore deliveryGeoPoint value
  //this helps [upcomingOrdersProvider] to ignore deliveryGeoPoint in deep equality of distinct method
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppOrder &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.pickupOption, pickupOption) ||
                other.pickupOption == pickupOption) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userImage, userImage) ||
                other.userImage == userImage) &&
            (identical(other.userPhone, userPhone) ||
                other.userPhone == userPhone) &&
            (identical(other.userNote, userNote) ||
                other.userNote == userNote) &&
            (identical(other.employeeCancelNote, employeeCancelNote) ||
                other.employeeCancelNote == employeeCancelNote) &&
            (identical(other.deliveryStatus, deliveryStatus) ||
                other.deliveryStatus == deliveryStatus) &&
            (identical(other.deliveryId, deliveryId) ||
                other.deliveryId == deliveryId));
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        id,
        date,
        pickupOption,
        paymentMethod,
        address,
        userId,
        userName,
        userImage,
        userPhone,
        userNote,
        employeeCancelNote,
        deliveryStatus,
        deliveryId,
      );
}

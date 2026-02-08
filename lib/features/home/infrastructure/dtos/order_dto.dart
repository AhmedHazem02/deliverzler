import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/json_converters/geo_point_converter.dart';
import '../../domain/order.dart';
import '../../domain/pickup_stop.dart';
import '../../domain/value_objects.dart';
import 'order_item_dto.dart';
import 'pickup_stop_dto.dart';

part 'order_dto.freezed.dart';
part 'order_dto.g.dart';

// Helper function to trim status field (fixes "upcoming " with trailing space)
// Also handles legacy data where actual status is in 'deliveryStatus' field
Object? _readStatusValue(Map json, String key) {
  final value = json[key];
  if (value is String) {
    final trimmed = value.trim();
    // If status is 'upcoming' but deliveryStatus has actual status, use deliveryStatus
    if (trimmed == 'upcoming' && json['deliveryStatus'] != null) {
      final deliveryStatus = json['deliveryStatus'];
      if (deliveryStatus is String && deliveryStatus.trim() != 'upcoming') {
        debugPrint(
            '🔄 [OrderDto] Fallback: status="$trimmed" → using deliveryStatus="$deliveryStatus"');
        return deliveryStatus.trim();
      }
    }
    return trimmed;
  }
  return value;
}

// Helper function to convert created_at to milliseconds
int _readDateValue(Map json, String key) {
  final value = json['created_at'];
  if (value is String) {
    return DateTime.parse(value).millisecondsSinceEpoch;
  } else if (value is Timestamp) {
    return value.millisecondsSinceEpoch;
  } else if (value is int) {
    return value;
  }
  return DateTime.now().millisecondsSinceEpoch;
}

@Freezed(toJson: false)
class OrderDto with _$OrderDto {
  const factory OrderDto({
    // Date field mapping
    @JsonKey(name: 'created_at', readValue: _readDateValue) required int date,

    // Pickup option (default to delivery)
    @Default(PickupOption.delivery) PickupOption pickupOption,
    @Default('cash') String paymentMethod,

    // Customer fields mapping
    @JsonKey(name: 'customer_id') required String userId,
    @JsonKey(name: 'customer_name') required String userName,
    @JsonKey(name: 'customer_phone') required String userPhone,
    @Default('') String userImage,
    @Default('') String userNote,

    // Address fields (flat structure in DB)
    @JsonKey(name: 'delivery_state') String? deliveryState,
    @JsonKey(name: 'delivery_city') String? deliveryCity,
    @JsonKey(name: 'delivery_address') String? deliveryStreet,

    // Coordinates (separate lat/lng fields)
    @JsonKey(name: 'delivery_latitude') double? deliveryLatitude,
    @JsonKey(name: 'delivery_longitude') double? deliveryLongitude,

    // Status field (with trim to handle trailing spaces)
    @JsonKey(name: 'status', readValue: _readStatusValue)
    required DeliveryStatus deliveryStatus,

    // Driver assignment
    @JsonKey(name: 'driver_id') String? deliveryId,
    String? employeeCancelNote,
    @Default(RejectionStatus.none) RejectionStatus rejectionStatus,

    // Price fields
    @Default(0.0) double subTotal,
    required double total,
    @JsonKey(name: 'delivery_price') double? deliveryFee,

    // Store information
    @JsonKey(name: 'store_id') String? storeId,

    // Admin comment when excuse is refused
    String? adminComment,

    // List of driver IDs who rejected/excused this order
    @JsonKey(name: 'rejected_by_drivers')
    @Default([])
    List<String> rejectedByDrivers,

    // Multi-store order fields
    @JsonKey(name: 'order_type') String? orderType,
    @JsonKey(name: 'driver_commission') double? driverCommission,
    @JsonKey(name: 'driver_name') String? driverName,
    @JsonKey(includeToJson: false) String? id,
    // Raw pickup_stops - parsed manually, not by json_serializable
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default([])
    List<PickupStop> pickupStops,
  }) = _OrderDto;

  factory OrderDto.fromDomain(AppOrder order) {
    return OrderDto(
      id: order.id,
      date: order.date,
      pickupOption: order.pickupOption,
      paymentMethod: order.paymentMethod,
      userId: order.userId,
      userName: order.userName,
      userPhone: order.userPhone,
      userImage: order.userImage,
      userNote: order.userNote,
      deliveryState: order.address?.state,
      deliveryCity: order.address?.city,
      deliveryStreet: order.address?.street,
      deliveryLatitude: order.deliveryGeoPoint?.latitude,
      deliveryLongitude: order.deliveryGeoPoint?.longitude,
      employeeCancelNote: order.employeeCancelNote,
      deliveryStatus: order.deliveryStatus,
      deliveryId: order.deliveryId,
      rejectionStatus: order.rejectionStatus,
      subTotal: order.subTotal,
      total: order.total,
      deliveryFee: order.deliveryFee,
      storeId: order.storeId,
    );
  }

  const OrderDto._();

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);

  factory OrderDto.fromFirestore(DocumentSnapshot document) {
    final json = document.data()! as Map<String, dynamic>;
    final dto = OrderDto.fromJson(json).copyWith(id: document.id);

    // Parse pickup_stops manually (not handled by json_serializable)
    final rawStops = json['pickup_stops'] as List<dynamic>?;
    if (rawStops != null && rawStops.isNotEmpty) {
      return dto.copyWith(
        pickupStops: PickupStopDto.parseList(rawStops),
      );
    }
    return dto;
  }

  static List<OrderDto> parseListOfDocument(
    List<QueryDocumentSnapshot> documents,
  ) {
    return List<OrderDto>.from(documents.map(OrderDto.fromFirestore));
  }

  AppOrder toDomain() {
    // Build Address entity from flat fields
    Address? addressEntity;
    if (deliveryCity != null || deliveryStreet != null) {
      addressEntity = Address(
        state: deliveryState ?? '',
        city: deliveryCity ?? '',
        street: deliveryStreet ?? '',
        mobile: userPhone,
        geoPoint: (deliveryLatitude != null && deliveryLongitude != null)
            ? GeoPoint(deliveryLatitude!, deliveryLongitude!)
            : null,
      );
    }

    final parsedOrderType = OrderType.fromValue(orderType);

    return AppOrder(
      id: id ?? '',
      date: date,
      pickupOption: pickupOption,
      paymentMethod: paymentMethod,
      address: addressEntity,
      userId: userId,
      userName: userName,
      userImage: userImage,
      userPhone: userPhone,
      userNote: userNote,
      employeeCancelNote: employeeCancelNote,
      deliveryStatus: deliveryStatus,
      deliveryId: deliveryId,
      deliveryGeoPoint: (deliveryLatitude != null && deliveryLongitude != null)
          ? GeoPoint(deliveryLatitude!, deliveryLongitude!)
          : null,
      deliveryHeading: null,
      rejectionStatus: rejectionStatus,
      items: [], // For single_store, loaded separately. For multi_store, from pickupStops.
      subTotal: subTotal,
      total: total,
      deliveryFee: deliveryFee ?? 0.0,
      storeId: storeId,
      storeName: null, // Will be loaded separately if needed
      storeAddress: null, // Will be loaded separately if needed
      adminComment: adminComment,
      rejectedByDrivers: rejectedByDrivers,
      // Multi-store fields
      orderType: parsedOrderType,
      pickupStops: pickupStops,
      driverCommission: driverCommission,
      driverName: driverName,
    );
  }
}

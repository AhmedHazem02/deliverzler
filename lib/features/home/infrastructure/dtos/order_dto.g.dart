// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderDtoImpl _$$OrderDtoImplFromJson(Map<String, dynamic> json) =>
    _$OrderDtoImpl(
      date: (_readDateValue(json, 'created_at') as num).toInt(),
      pickupOption:
          $enumDecodeNullable(_$PickupOptionEnumMap, json['pickupOption']) ??
              PickupOption.delivery,
      paymentMethod: json['paymentMethod'] as String? ?? 'cash',
      userId: json['customer_id'] as String,
      userName: json['customer_name'] as String,
      userPhone: json['customer_phone'] as String,
      userImage: json['userImage'] as String? ?? '',
      userNote: json['userNote'] as String? ?? '',
      deliveryState: json['delivery_state'] as String?,
      deliveryCity: json['delivery_city'] as String?,
      deliveryStreet: json['delivery_address'] as String?,
      deliveryLatitude: (json['delivery_latitude'] as num?)?.toDouble(),
      deliveryLongitude: (json['delivery_longitude'] as num?)?.toDouble(),
      deliveryStatus: $enumDecode(
          _$DeliveryStatusEnumMap, _readStatusValue(json, 'status')),
      deliveryId: json['driver_id'] as String?,
      employeeCancelNote: json['employeeCancelNote'] as String?,
      rejectionStatus: $enumDecodeNullable(
              _$RejectionStatusEnumMap, json['rejectionStatus']) ??
          RejectionStatus.none,
      subTotal: (json['subTotal'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num).toDouble(),
      deliveryFee: (json['delivery_price'] as num?)?.toDouble(),
      storeId: json['store_id'] as String?,
      adminComment: json['adminComment'] as String?,
      rejectedByDrivers: (json['rejected_by_drivers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      id: json['id'] as String?,
    );

const _$PickupOptionEnumMap = {
  PickupOption.delivery: 'delivery',
  PickupOption.pickUp: 'pickUp',
  PickupOption.diningRoom: 'diningRoom',
};

const _$DeliveryStatusEnumMap = {
  DeliveryStatus.pending: 'pending',
  DeliveryStatus.confirmed: 'confirmed',
  DeliveryStatus.onTheWay: 'onTheWay',
  DeliveryStatus.delivered: 'delivered',
  DeliveryStatus.canceled: 'canceled',
};

const _$RejectionStatusEnumMap = {
  RejectionStatus.none: 'none',
  RejectionStatus.requested: 'requested',
  RejectionStatus.adminApproved: 'adminApproved',
  RejectionStatus.adminRefused: 'adminRefused',
};

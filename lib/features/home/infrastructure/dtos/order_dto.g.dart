// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderDtoImpl _$$OrderDtoImplFromJson(Map<String, dynamic> json) =>
    _$OrderDtoImpl(
      date: (json['date'] as num).toInt(),
      pickupOption: $enumDecode(_$PickupOptionEnumMap, json['pickupOption']),
      paymentMethod: json['paymentMethod'] as String,
      address: json['addressModel'] == null
          ? null
          : AddressDto.fromJson(json['addressModel'] as Map<String, dynamic>),
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userImage: json['userImage'] as String,
      userPhone: json['userPhone'] as String,
      userNote: json['userNote'] as String,
      employeeCancelNote: json['employeeCancelNote'] as String?,
      deliveryStatus:
          $enumDecode(_$DeliveryStatusEnumMap, json['deliveryStatus']),
      deliveryId: json['deliveryId'] as String?,
      deliveryGeoPoint: _$JsonConverterFromJson<GeoPoint, GeoPoint>(
          json['deliveryGeoPoint'], const GeoPointConverter().fromJson),
      deliveryHeading: (json['deliveryHeading'] as num?)?.toDouble(),
      rejectionStatus: $enumDecodeNullable(
              _$RejectionStatusEnumMap, json['rejectionStatus']) ??
          RejectionStatus.none,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subTotal: (json['subTotal'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble(),
      id: json['id'] as String?,
    );

const _$PickupOptionEnumMap = {
  PickupOption.delivery: 'delivery',
  PickupOption.pickUp: 'pickUp',
  PickupOption.diningRoom: 'diningRoom',
};

const _$DeliveryStatusEnumMap = {
  DeliveryStatus.pending: 'pending',
  DeliveryStatus.upcoming: 'upcoming',
  DeliveryStatus.onTheWay: 'onTheWay',
  DeliveryStatus.delivered: 'delivered',
  DeliveryStatus.canceled: 'canceled',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

const _$RejectionStatusEnumMap = {
  RejectionStatus.none: 'none',
  RejectionStatus.requested: 'requested',
  RejectionStatus.adminApproved: 'adminApproved',
  RejectionStatus.adminRefused: 'adminRefused',
};

_$AddressDtoImpl _$$AddressDtoImplFromJson(Map<String, dynamic> json) =>
    _$AddressDtoImpl(
      state: json['state'] as String,
      city: json['city'] as String,
      street: json['street'] as String,
      mobile: json['mobile'] as String,
      geoPoint: _$JsonConverterFromJson<GeoPoint, GeoPoint>(
          json['geoPoint'], const GeoPointConverter().fromJson),
    );

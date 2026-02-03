import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/json_converters/geo_point_converter.dart';
import '../../domain/order.dart';
import '../../domain/value_objects.dart';
import 'order_item_dto.dart';

part 'order_dto.freezed.dart';

part 'order_dto.g.dart';

@Freezed(toJson: false)
class OrderDto with _$OrderDto {
  const factory OrderDto({
    required int date,
    required PickupOption pickupOption,
    required String paymentMethod,
    @JsonKey(name: 'addressModel') required AddressDto? address,
    required String userId,
    required String userName,
    required String userImage,
    required String userPhone,
    required String userNote,
    required String? employeeCancelNote,
    required DeliveryStatus deliveryStatus,
    required String? deliveryId,
    @GeoPointConverter() required GeoPoint? deliveryGeoPoint,
    required double? deliveryHeading,
    @Default(RejectionStatus.none) RejectionStatus rejectionStatus,
    @Default([]) List<OrderItemDto> items,
    @Default(0.0) double subTotal,
    @Default(0.0) double total,
    double? deliveryFee,
    @JsonKey(includeToJson: false) String? id,
  }) = _OrderDto;

  factory OrderDto.fromDomain(AppOrder order) {
    return OrderDto(
      id: order.id,
      date: order.date,
      pickupOption: order.pickupOption,
      paymentMethod: order.paymentMethod,
      address:
          order.address != null ? AddressDto.fromDomain(order.address!) : null,
      userId: order.userId,
      userName: order.userName,
      userImage: order.userImage,
      userPhone: order.userPhone,
      userNote: order.userNote,
      employeeCancelNote: order.employeeCancelNote,
      deliveryStatus: order.deliveryStatus,
      deliveryId: order.deliveryId,
      deliveryGeoPoint: order.deliveryGeoPoint,
      deliveryHeading: order.deliveryHeading,
      rejectionStatus: order.rejectionStatus,
      items: order.items
          .map((item) => OrderItemDto(
                id: item.id,
                name: item.name,
                imageUrl: item.imageUrl,
                quantity: item.quantity,
                price: item.price,
                total: item.total,
                category: item.category,
                description: item.description,
              ))
          .toList(),
      subTotal: order.subTotal,
      total: order.total,
      deliveryFee: order.deliveryFee,
    );
  }
  const OrderDto._();

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);

  factory OrderDto.fromFirestore(DocumentSnapshot document) {
    return OrderDto.fromJson(document.data()! as Map<String, dynamic>)
        .copyWith(id: document.id);
  }

  static List<OrderDto> parseListOfDocument(
    List<QueryDocumentSnapshot> documents,
  ) {
    return List<OrderDto>.from(documents.map(OrderDto.fromFirestore));
  }

  AppOrder toDomain() {
    return AppOrder(
      id: id ?? '',
      date: date,
      pickupOption: pickupOption,
      paymentMethod: paymentMethod,
      address: address?.toDomain(),
      userId: userId,
      userName: userName,
      userImage: userImage,
      userPhone: userPhone,
      userNote: userNote,
      employeeCancelNote: employeeCancelNote,
      deliveryStatus: deliveryStatus,
      deliveryId: deliveryId,
      deliveryGeoPoint: deliveryGeoPoint,
      deliveryHeading: deliveryHeading,
      rejectionStatus: rejectionStatus,
      items: items.map((item) => item.toDomain()).toList(),
      subTotal: subTotal == 0
          ? items.fold(0.0, (sum, item) => sum + item.total)
          : subTotal,
      total: total,
      deliveryFee: deliveryFee,
    );
  }
}

@Freezed(toJson: false)
class AddressDto with _$AddressDto {
  const factory AddressDto({
    required String state,
    required String city,
    required String street,
    required String mobile,
    @GeoPointConverter() required GeoPoint? geoPoint,
  }) = _AddressDto;
  const AddressDto._();

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);

  factory AddressDto.fromDomain(Address address) {
    return AddressDto(
      state: address.state,
      city: address.city,
      street: address.street,
      mobile: address.mobile,
      geoPoint: address.geoPoint,
    );
  }

  Address toDomain() {
    return Address(
      state: state,
      city: city,
      street: street,
      mobile: mobile,
      geoPoint: geoPoint,
    );
  }
}

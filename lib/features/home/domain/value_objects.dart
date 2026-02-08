import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'value_objects.freezed.dart';

@freezed
class Address with _$Address {
  const factory Address({
    required String state,
    required String city,
    required String street,
    required String mobile,
    required GeoPoint? geoPoint,
  }) = _Address;
}

@JsonEnum(valueField: 'jsonValue')
enum PickupOption {
  delivery('delivery'),
  pickUp('pickUp'),
  diningRoom('diningRoom');

  const PickupOption(this.jsonValue);

  final String jsonValue;
}

@JsonEnum(valueField: 'jsonValue')
enum DeliveryStatus {
  pending('pending'),
  confirmed('confirmed'),
  onTheWay('onTheWay'),
  delivered('delivered'),
  canceled('canceled');

  const DeliveryStatus(this.jsonValue);

  final String jsonValue;
}

@JsonEnum(valueField: 'jsonValue')
enum RejectionStatus {
  none('none'),
  requested('requested'),
  adminApproved('adminApproved'),
  adminRefused('adminRefused');

  const RejectionStatus(this.jsonValue);

  final String jsonValue;
}

/// Type of order — single store or multi-store with pickup stops.
@JsonEnum(valueField: 'jsonValue')
enum OrderType {
  singleStore('single_store'),
  multiStore('multi_store');

  const OrderType(this.jsonValue);

  final String jsonValue;

  static OrderType fromValue(String? value) {
    if (value == 'multi_store') return OrderType.multiStore;
    return OrderType.singleStore;
  }
}

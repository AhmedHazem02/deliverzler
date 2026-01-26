// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_delivery_geo_point_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UpdateDeliveryGeoPointDto {
  @JsonKey(includeToJson: false)
  String get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'deliveryGeoPoint')
  @GeoPointConverter()
  GeoPoint get geoPoint => throw _privateConstructorUsedError;
  @JsonKey(name: 'deliveryHeading')
  double get heading => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateDeliveryGeoPointDtoCopyWith<UpdateDeliveryGeoPointDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateDeliveryGeoPointDtoCopyWith<$Res> {
  factory $UpdateDeliveryGeoPointDtoCopyWith(UpdateDeliveryGeoPointDto value,
          $Res Function(UpdateDeliveryGeoPointDto) then) =
      _$UpdateDeliveryGeoPointDtoCopyWithImpl<$Res, UpdateDeliveryGeoPointDto>;
  @useResult
  $Res call(
      {@JsonKey(includeToJson: false) String orderId,
      @JsonKey(name: 'deliveryGeoPoint') @GeoPointConverter() GeoPoint geoPoint,
      @JsonKey(name: 'deliveryHeading') double heading});
}

/// @nodoc
class _$UpdateDeliveryGeoPointDtoCopyWithImpl<$Res,
        $Val extends UpdateDeliveryGeoPointDto>
    implements $UpdateDeliveryGeoPointDtoCopyWith<$Res> {
  _$UpdateDeliveryGeoPointDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? geoPoint = null,
    Object? heading = null,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      geoPoint: null == geoPoint
          ? _value.geoPoint
          : geoPoint // ignore: cast_nullable_to_non_nullable
              as GeoPoint,
      heading: null == heading
          ? _value.heading
          : heading // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateDeliveryGeoPointDtoImplCopyWith<$Res>
    implements $UpdateDeliveryGeoPointDtoCopyWith<$Res> {
  factory _$$UpdateDeliveryGeoPointDtoImplCopyWith(
          _$UpdateDeliveryGeoPointDtoImpl value,
          $Res Function(_$UpdateDeliveryGeoPointDtoImpl) then) =
      __$$UpdateDeliveryGeoPointDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(includeToJson: false) String orderId,
      @JsonKey(name: 'deliveryGeoPoint') @GeoPointConverter() GeoPoint geoPoint,
      @JsonKey(name: 'deliveryHeading') double heading});
}

/// @nodoc
class __$$UpdateDeliveryGeoPointDtoImplCopyWithImpl<$Res>
    extends _$UpdateDeliveryGeoPointDtoCopyWithImpl<$Res,
        _$UpdateDeliveryGeoPointDtoImpl>
    implements _$$UpdateDeliveryGeoPointDtoImplCopyWith<$Res> {
  __$$UpdateDeliveryGeoPointDtoImplCopyWithImpl(
      _$UpdateDeliveryGeoPointDtoImpl _value,
      $Res Function(_$UpdateDeliveryGeoPointDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? geoPoint = null,
    Object? heading = null,
  }) {
    return _then(_$UpdateDeliveryGeoPointDtoImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      geoPoint: null == geoPoint
          ? _value.geoPoint
          : geoPoint // ignore: cast_nullable_to_non_nullable
              as GeoPoint,
      heading: null == heading
          ? _value.heading
          : heading // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable(createFactory: false)
class _$UpdateDeliveryGeoPointDtoImpl implements _UpdateDeliveryGeoPointDto {
  const _$UpdateDeliveryGeoPointDtoImpl(
      {@JsonKey(includeToJson: false) required this.orderId,
      @JsonKey(name: 'deliveryGeoPoint')
      @GeoPointConverter()
      required this.geoPoint,
      @JsonKey(name: 'deliveryHeading') required this.heading});

  @override
  @JsonKey(includeToJson: false)
  final String orderId;
  @override
  @JsonKey(name: 'deliveryGeoPoint')
  @GeoPointConverter()
  final GeoPoint geoPoint;
  @override
  @JsonKey(name: 'deliveryHeading')
  final double heading;

  @override
  String toString() {
    return 'UpdateDeliveryGeoPointDto(orderId: $orderId, geoPoint: $geoPoint, heading: $heading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateDeliveryGeoPointDtoImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.geoPoint, geoPoint) ||
                other.geoPoint == geoPoint) &&
            (identical(other.heading, heading) || other.heading == heading));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, orderId, geoPoint, heading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateDeliveryGeoPointDtoImplCopyWith<_$UpdateDeliveryGeoPointDtoImpl>
      get copyWith => __$$UpdateDeliveryGeoPointDtoImplCopyWithImpl<
          _$UpdateDeliveryGeoPointDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateDeliveryGeoPointDtoImplToJson(
      this,
    );
  }
}

abstract class _UpdateDeliveryGeoPointDto implements UpdateDeliveryGeoPointDto {
  const factory _UpdateDeliveryGeoPointDto(
          {@JsonKey(includeToJson: false) required final String orderId,
          @JsonKey(name: 'deliveryGeoPoint')
          @GeoPointConverter()
          required final GeoPoint geoPoint,
          @JsonKey(name: 'deliveryHeading') required final double heading}) =
      _$UpdateDeliveryGeoPointDtoImpl;

  @override
  @JsonKey(includeToJson: false)
  String get orderId;
  @override
  @JsonKey(name: 'deliveryGeoPoint')
  @GeoPointConverter()
  GeoPoint get geoPoint;
  @override
  @JsonKey(name: 'deliveryHeading')
  double get heading;
  @override
  @JsonKey(ignore: true)
  _$$UpdateDeliveryGeoPointDtoImplCopyWith<_$UpdateDeliveryGeoPointDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

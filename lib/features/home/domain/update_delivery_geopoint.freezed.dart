// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_delivery_geopoint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UpdateDeliveryGeoPoint {
  String get orderId => throw _privateConstructorUsedError;
  GeoPoint get geoPoint => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UpdateDeliveryGeoPointCopyWith<UpdateDeliveryGeoPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateDeliveryGeoPointCopyWith<$Res> {
  factory $UpdateDeliveryGeoPointCopyWith(UpdateDeliveryGeoPoint value,
          $Res Function(UpdateDeliveryGeoPoint) then) =
      _$UpdateDeliveryGeoPointCopyWithImpl<$Res, UpdateDeliveryGeoPoint>;
  @useResult
  $Res call({String orderId, GeoPoint geoPoint});
}

/// @nodoc
class _$UpdateDeliveryGeoPointCopyWithImpl<$Res,
        $Val extends UpdateDeliveryGeoPoint>
    implements $UpdateDeliveryGeoPointCopyWith<$Res> {
  _$UpdateDeliveryGeoPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? geoPoint = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateDeliveryGeoPointImplCopyWith<$Res>
    implements $UpdateDeliveryGeoPointCopyWith<$Res> {
  factory _$$UpdateDeliveryGeoPointImplCopyWith(
          _$UpdateDeliveryGeoPointImpl value,
          $Res Function(_$UpdateDeliveryGeoPointImpl) then) =
      __$$UpdateDeliveryGeoPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String orderId, GeoPoint geoPoint});
}

/// @nodoc
class __$$UpdateDeliveryGeoPointImplCopyWithImpl<$Res>
    extends _$UpdateDeliveryGeoPointCopyWithImpl<$Res,
        _$UpdateDeliveryGeoPointImpl>
    implements _$$UpdateDeliveryGeoPointImplCopyWith<$Res> {
  __$$UpdateDeliveryGeoPointImplCopyWithImpl(
      _$UpdateDeliveryGeoPointImpl _value,
      $Res Function(_$UpdateDeliveryGeoPointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? geoPoint = null,
  }) {
    return _then(_$UpdateDeliveryGeoPointImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      geoPoint: null == geoPoint
          ? _value.geoPoint
          : geoPoint // ignore: cast_nullable_to_non_nullable
              as GeoPoint,
    ));
  }
}

/// @nodoc

class _$UpdateDeliveryGeoPointImpl implements _UpdateDeliveryGeoPoint {
  const _$UpdateDeliveryGeoPointImpl(
      {required this.orderId, required this.geoPoint});

  @override
  final String orderId;
  @override
  final GeoPoint geoPoint;

  @override
  String toString() {
    return 'UpdateDeliveryGeoPoint(orderId: $orderId, geoPoint: $geoPoint)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateDeliveryGeoPointImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.geoPoint, geoPoint) ||
                other.geoPoint == geoPoint));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orderId, geoPoint);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateDeliveryGeoPointImplCopyWith<_$UpdateDeliveryGeoPointImpl>
      get copyWith => __$$UpdateDeliveryGeoPointImplCopyWithImpl<
          _$UpdateDeliveryGeoPointImpl>(this, _$identity);
}

abstract class _UpdateDeliveryGeoPoint implements UpdateDeliveryGeoPoint {
  const factory _UpdateDeliveryGeoPoint(
      {required final String orderId,
      required final GeoPoint geoPoint}) = _$UpdateDeliveryGeoPointImpl;

  @override
  String get orderId;
  @override
  GeoPoint get geoPoint;
  @override
  @JsonKey(ignore: true)
  _$$UpdateDeliveryGeoPointImplCopyWith<_$UpdateDeliveryGeoPointImpl>
      get copyWith => throw _privateConstructorUsedError;
}

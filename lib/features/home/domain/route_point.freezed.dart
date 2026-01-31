// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RoutePoint _$RoutePointFromJson(Map<String, dynamic> json) {
  return _RoutePoint.fromJson(json);
}

/// @nodoc
mixin _$RoutePoint {
  @GeoPointConverter()
  GeoPoint get geoPoint => throw _privateConstructorUsedError;
  double get heading => throw _privateConstructorUsedError;
  double get speed => throw _privateConstructorUsedError;
  double get accuracy => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError;
  bool get isMocked => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoutePointCopyWith<RoutePoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutePointCopyWith<$Res> {
  factory $RoutePointCopyWith(
          RoutePoint value, $Res Function(RoutePoint) then) =
      _$RoutePointCopyWithImpl<$Res, RoutePoint>;
  @useResult
  $Res call(
      {@GeoPointConverter() GeoPoint geoPoint,
      double heading,
      double speed,
      double accuracy,
      int timestamp,
      bool isMocked});
}

/// @nodoc
class _$RoutePointCopyWithImpl<$Res, $Val extends RoutePoint>
    implements $RoutePointCopyWith<$Res> {
  _$RoutePointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geoPoint = null,
    Object? heading = null,
    Object? speed = null,
    Object? accuracy = null,
    Object? timestamp = null,
    Object? isMocked = null,
  }) {
    return _then(_value.copyWith(
      geoPoint: null == geoPoint
          ? _value.geoPoint
          : geoPoint // ignore: cast_nullable_to_non_nullable
              as GeoPoint,
      heading: null == heading
          ? _value.heading
          : heading // ignore: cast_nullable_to_non_nullable
              as double,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      accuracy: null == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      isMocked: null == isMocked
          ? _value.isMocked
          : isMocked // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoutePointImplCopyWith<$Res>
    implements $RoutePointCopyWith<$Res> {
  factory _$$RoutePointImplCopyWith(
          _$RoutePointImpl value, $Res Function(_$RoutePointImpl) then) =
      __$$RoutePointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@GeoPointConverter() GeoPoint geoPoint,
      double heading,
      double speed,
      double accuracy,
      int timestamp,
      bool isMocked});
}

/// @nodoc
class __$$RoutePointImplCopyWithImpl<$Res>
    extends _$RoutePointCopyWithImpl<$Res, _$RoutePointImpl>
    implements _$$RoutePointImplCopyWith<$Res> {
  __$$RoutePointImplCopyWithImpl(
      _$RoutePointImpl _value, $Res Function(_$RoutePointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geoPoint = null,
    Object? heading = null,
    Object? speed = null,
    Object? accuracy = null,
    Object? timestamp = null,
    Object? isMocked = null,
  }) {
    return _then(_$RoutePointImpl(
      geoPoint: null == geoPoint
          ? _value.geoPoint
          : geoPoint // ignore: cast_nullable_to_non_nullable
              as GeoPoint,
      heading: null == heading
          ? _value.heading
          : heading // ignore: cast_nullable_to_non_nullable
              as double,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      accuracy: null == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      isMocked: null == isMocked
          ? _value.isMocked
          : isMocked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutePointImpl implements _RoutePoint {
  const _$RoutePointImpl(
      {@GeoPointConverter() required this.geoPoint,
      required this.heading,
      required this.speed,
      required this.accuracy,
      required this.timestamp,
      this.isMocked = false});

  factory _$RoutePointImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutePointImplFromJson(json);

  @override
  @GeoPointConverter()
  final GeoPoint geoPoint;
  @override
  final double heading;
  @override
  final double speed;
  @override
  final double accuracy;
  @override
  final int timestamp;
  @override
  @JsonKey()
  final bool isMocked;

  @override
  String toString() {
    return 'RoutePoint(geoPoint: $geoPoint, heading: $heading, speed: $speed, accuracy: $accuracy, timestamp: $timestamp, isMocked: $isMocked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutePointImpl &&
            (identical(other.geoPoint, geoPoint) ||
                other.geoPoint == geoPoint) &&
            (identical(other.heading, heading) || other.heading == heading) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isMocked, isMocked) ||
                other.isMocked == isMocked));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, geoPoint, heading, speed, accuracy, timestamp, isMocked);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutePointImplCopyWith<_$RoutePointImpl> get copyWith =>
      __$$RoutePointImplCopyWithImpl<_$RoutePointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutePointImplToJson(
      this,
    );
  }
}

abstract class _RoutePoint implements RoutePoint {
  const factory _RoutePoint(
      {@GeoPointConverter() required final GeoPoint geoPoint,
      required final double heading,
      required final double speed,
      required final double accuracy,
      required final int timestamp,
      final bool isMocked}) = _$RoutePointImpl;

  factory _RoutePoint.fromJson(Map<String, dynamic> json) =
      _$RoutePointImpl.fromJson;

  @override
  @GeoPointConverter()
  GeoPoint get geoPoint;
  @override
  double get heading;
  @override
  double get speed;
  @override
  double get accuracy;
  @override
  int get timestamp;
  @override
  bool get isMocked;
  @override
  @JsonKey(ignore: true)
  _$$RoutePointImplCopyWith<_$RoutePointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

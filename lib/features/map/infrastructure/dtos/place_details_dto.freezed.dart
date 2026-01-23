// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place_details_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlaceDetailsDto _$PlaceDetailsDtoFromJson(Map<String, dynamic> json) {
  return _PlaceDetailsDto.fromJson(json);
}

/// @nodoc
mixin _$PlaceDetailsDto {
  @JsonKey(name: 'geometry', fromJson: _fromJsonGeoPoint)
  GeoPoint get geoPoint => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlaceDetailsDtoCopyWith<PlaceDetailsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceDetailsDtoCopyWith<$Res> {
  factory $PlaceDetailsDtoCopyWith(
          PlaceDetailsDto value, $Res Function(PlaceDetailsDto) then) =
      _$PlaceDetailsDtoCopyWithImpl<$Res, PlaceDetailsDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'geometry', fromJson: _fromJsonGeoPoint)
      GeoPoint geoPoint});
}

/// @nodoc
class _$PlaceDetailsDtoCopyWithImpl<$Res, $Val extends PlaceDetailsDto>
    implements $PlaceDetailsDtoCopyWith<$Res> {
  _$PlaceDetailsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geoPoint = null,
  }) {
    return _then(_value.copyWith(
      geoPoint: null == geoPoint
          ? _value.geoPoint
          : geoPoint // ignore: cast_nullable_to_non_nullable
              as GeoPoint,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaceDetailsDtoImplCopyWith<$Res>
    implements $PlaceDetailsDtoCopyWith<$Res> {
  factory _$$PlaceDetailsDtoImplCopyWith(_$PlaceDetailsDtoImpl value,
          $Res Function(_$PlaceDetailsDtoImpl) then) =
      __$$PlaceDetailsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'geometry', fromJson: _fromJsonGeoPoint)
      GeoPoint geoPoint});
}

/// @nodoc
class __$$PlaceDetailsDtoImplCopyWithImpl<$Res>
    extends _$PlaceDetailsDtoCopyWithImpl<$Res, _$PlaceDetailsDtoImpl>
    implements _$$PlaceDetailsDtoImplCopyWith<$Res> {
  __$$PlaceDetailsDtoImplCopyWithImpl(
      _$PlaceDetailsDtoImpl _value, $Res Function(_$PlaceDetailsDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geoPoint = null,
  }) {
    return _then(_$PlaceDetailsDtoImpl(
      geoPoint: null == geoPoint
          ? _value.geoPoint
          : geoPoint // ignore: cast_nullable_to_non_nullable
              as GeoPoint,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$PlaceDetailsDtoImpl extends _PlaceDetailsDto {
  const _$PlaceDetailsDtoImpl(
      {@JsonKey(name: 'geometry', fromJson: _fromJsonGeoPoint)
      required this.geoPoint})
      : super._();

  factory _$PlaceDetailsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceDetailsDtoImplFromJson(json);

  @override
  @JsonKey(name: 'geometry', fromJson: _fromJsonGeoPoint)
  final GeoPoint geoPoint;

  @override
  String toString() {
    return 'PlaceDetailsDto(geoPoint: $geoPoint)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceDetailsDtoImpl &&
            (identical(other.geoPoint, geoPoint) ||
                other.geoPoint == geoPoint));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, geoPoint);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceDetailsDtoImplCopyWith<_$PlaceDetailsDtoImpl> get copyWith =>
      __$$PlaceDetailsDtoImplCopyWithImpl<_$PlaceDetailsDtoImpl>(
          this, _$identity);
}

abstract class _PlaceDetailsDto extends PlaceDetailsDto {
  const factory _PlaceDetailsDto(
      {@JsonKey(name: 'geometry', fromJson: _fromJsonGeoPoint)
      required final GeoPoint geoPoint}) = _$PlaceDetailsDtoImpl;
  const _PlaceDetailsDto._() : super._();

  factory _PlaceDetailsDto.fromJson(Map<String, dynamic> json) =
      _$PlaceDetailsDtoImpl.fromJson;

  @override
  @JsonKey(name: 'geometry', fromJson: _fromJsonGeoPoint)
  GeoPoint get geoPoint;
  @override
  @JsonKey(ignore: true)
  _$$PlaceDetailsDtoImplCopyWith<_$PlaceDetailsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rejection_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RejectionRequestDto _$RejectionRequestDtoFromJson(Map<String, dynamic> json) {
  return _RejectionRequestDto.fromJson(json);
}

/// @nodoc
mixin _$RejectionRequestDto {
  String get orderId => throw _privateConstructorUsedError;
  String get driverId => throw _privateConstructorUsedError;
  String get driverName => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  AdminDecision get adminDecision => throw _privateConstructorUsedError;
  String? get adminComment => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RejectionRequestDtoCopyWith<RejectionRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RejectionRequestDtoCopyWith<$Res> {
  factory $RejectionRequestDtoCopyWith(
          RejectionRequestDto value, $Res Function(RejectionRequestDto) then) =
      _$RejectionRequestDtoCopyWithImpl<$Res, RejectionRequestDto>;
  @useResult
  $Res call(
      {String orderId,
      String driverId,
      String driverName,
      String reason,
      AdminDecision adminDecision,
      String? adminComment,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) String? id});
}

/// @nodoc
class _$RejectionRequestDtoCopyWithImpl<$Res, $Val extends RejectionRequestDto>
    implements $RejectionRequestDtoCopyWith<$Res> {
  _$RejectionRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? driverId = null,
    Object? driverName = null,
    Object? reason = null,
    Object? adminDecision = null,
    Object? adminComment = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      driverName: null == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      adminDecision: null == adminDecision
          ? _value.adminDecision
          : adminDecision // ignore: cast_nullable_to_non_nullable
              as AdminDecision,
      adminComment: freezed == adminComment
          ? _value.adminComment
          : adminComment // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RejectionRequestDtoImplCopyWith<$Res>
    implements $RejectionRequestDtoCopyWith<$Res> {
  factory _$$RejectionRequestDtoImplCopyWith(_$RejectionRequestDtoImpl value,
          $Res Function(_$RejectionRequestDtoImpl) then) =
      __$$RejectionRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String orderId,
      String driverId,
      String driverName,
      String reason,
      AdminDecision adminDecision,
      String? adminComment,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) String? id});
}

/// @nodoc
class __$$RejectionRequestDtoImplCopyWithImpl<$Res>
    extends _$RejectionRequestDtoCopyWithImpl<$Res, _$RejectionRequestDtoImpl>
    implements _$$RejectionRequestDtoImplCopyWith<$Res> {
  __$$RejectionRequestDtoImplCopyWithImpl(_$RejectionRequestDtoImpl _value,
      $Res Function(_$RejectionRequestDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? driverId = null,
    Object? driverName = null,
    Object? reason = null,
    Object? adminDecision = null,
    Object? adminComment = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? id = freezed,
  }) {
    return _then(_$RejectionRequestDtoImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      driverName: null == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      adminDecision: null == adminDecision
          ? _value.adminDecision
          : adminDecision // ignore: cast_nullable_to_non_nullable
              as AdminDecision,
      adminComment: freezed == adminComment
          ? _value.adminComment
          : adminComment // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RejectionRequestDtoImpl extends _RejectionRequestDto {
  const _$RejectionRequestDtoImpl(
      {required this.orderId,
      required this.driverId,
      required this.driverName,
      required this.reason,
      required this.adminDecision,
      this.adminComment,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) this.id})
      : super._();

  factory _$RejectionRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RejectionRequestDtoImplFromJson(json);

  @override
  final String orderId;
  @override
  final String driverId;
  @override
  final String driverName;
  @override
  final String reason;
  @override
  final AdminDecision adminDecision;
  @override
  final String? adminComment;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? updatedAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? id;

  @override
  String toString() {
    return 'RejectionRequestDto(orderId: $orderId, driverId: $driverId, driverName: $driverName, reason: $reason, adminDecision: $adminDecision, adminComment: $adminComment, createdAt: $createdAt, updatedAt: $updatedAt, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RejectionRequestDtoImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.adminDecision, adminDecision) ||
                other.adminDecision == adminDecision) &&
            (identical(other.adminComment, adminComment) ||
                other.adminComment == adminComment) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, orderId, driverId, driverName,
      reason, adminDecision, adminComment, createdAt, updatedAt, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RejectionRequestDtoImplCopyWith<_$RejectionRequestDtoImpl> get copyWith =>
      __$$RejectionRequestDtoImplCopyWithImpl<_$RejectionRequestDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RejectionRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _RejectionRequestDto extends RejectionRequestDto {
  const factory _RejectionRequestDto(
      {required final String orderId,
      required final String driverId,
      required final String driverName,
      required final String reason,
      required final AdminDecision adminDecision,
      final String? adminComment,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required final DateTime createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final String? id}) = _$RejectionRequestDtoImpl;
  const _RejectionRequestDto._() : super._();

  factory _RejectionRequestDto.fromJson(Map<String, dynamic> json) =
      _$RejectionRequestDtoImpl.fromJson;

  @override
  String get orderId;
  @override
  String get driverId;
  @override
  String get driverName;
  @override
  String get reason;
  @override
  AdminDecision get adminDecision;
  @override
  String? get adminComment;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get id;
  @override
  @JsonKey(ignore: true)
  _$$RejectionRequestDtoImplCopyWith<_$RejectionRequestDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rejection_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RejectionRequest {
  String get requestId => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  String get driverId => throw _privateConstructorUsedError;
  String get driverName => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  AdminDecision get adminDecision => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get adminComment => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RejectionRequestCopyWith<RejectionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RejectionRequestCopyWith<$Res> {
  factory $RejectionRequestCopyWith(
          RejectionRequest value, $Res Function(RejectionRequest) then) =
      _$RejectionRequestCopyWithImpl<$Res, RejectionRequest>;
  @useResult
  $Res call(
      {String requestId,
      String orderId,
      String driverId,
      String driverName,
      String reason,
      AdminDecision adminDecision,
      DateTime createdAt,
      String? adminComment,
      DateTime? updatedAt});
}

/// @nodoc
class _$RejectionRequestCopyWithImpl<$Res, $Val extends RejectionRequest>
    implements $RejectionRequestCopyWith<$Res> {
  _$RejectionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? orderId = null,
    Object? driverId = null,
    Object? driverName = null,
    Object? reason = null,
    Object? adminDecision = null,
    Object? createdAt = null,
    Object? adminComment = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      adminComment: freezed == adminComment
          ? _value.adminComment
          : adminComment // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RejectionRequestImplCopyWith<$Res>
    implements $RejectionRequestCopyWith<$Res> {
  factory _$$RejectionRequestImplCopyWith(_$RejectionRequestImpl value,
          $Res Function(_$RejectionRequestImpl) then) =
      __$$RejectionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String requestId,
      String orderId,
      String driverId,
      String driverName,
      String reason,
      AdminDecision adminDecision,
      DateTime createdAt,
      String? adminComment,
      DateTime? updatedAt});
}

/// @nodoc
class __$$RejectionRequestImplCopyWithImpl<$Res>
    extends _$RejectionRequestCopyWithImpl<$Res, _$RejectionRequestImpl>
    implements _$$RejectionRequestImplCopyWith<$Res> {
  __$$RejectionRequestImplCopyWithImpl(_$RejectionRequestImpl _value,
      $Res Function(_$RejectionRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? orderId = null,
    Object? driverId = null,
    Object? driverName = null,
    Object? reason = null,
    Object? adminDecision = null,
    Object? createdAt = null,
    Object? adminComment = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$RejectionRequestImpl(
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      adminComment: freezed == adminComment
          ? _value.adminComment
          : adminComment // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$RejectionRequestImpl extends _RejectionRequest {
  const _$RejectionRequestImpl(
      {required this.requestId,
      required this.orderId,
      required this.driverId,
      required this.driverName,
      required this.reason,
      required this.adminDecision,
      required this.createdAt,
      this.adminComment,
      this.updatedAt})
      : super._();

  @override
  final String requestId;
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
  final DateTime createdAt;
  @override
  final String? adminComment;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'RejectionRequest(requestId: $requestId, orderId: $orderId, driverId: $driverId, driverName: $driverName, reason: $reason, adminDecision: $adminDecision, createdAt: $createdAt, adminComment: $adminComment, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RejectionRequestImpl &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.adminDecision, adminDecision) ||
                other.adminDecision == adminDecision) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.adminComment, adminComment) ||
                other.adminComment == adminComment) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, requestId, orderId, driverId,
      driverName, reason, adminDecision, createdAt, adminComment, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RejectionRequestImplCopyWith<_$RejectionRequestImpl> get copyWith =>
      __$$RejectionRequestImplCopyWithImpl<_$RejectionRequestImpl>(
          this, _$identity);
}

abstract class _RejectionRequest extends RejectionRequest {
  const factory _RejectionRequest(
      {required final String requestId,
      required final String orderId,
      required final String driverId,
      required final String driverName,
      required final String reason,
      required final AdminDecision adminDecision,
      required final DateTime createdAt,
      final String? adminComment,
      final DateTime? updatedAt}) = _$RejectionRequestImpl;
  const _RejectionRequest._() : super._();

  @override
  String get requestId;
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
  DateTime get createdAt;
  @override
  String? get adminComment;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$RejectionRequestImplCopyWith<_$RejectionRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

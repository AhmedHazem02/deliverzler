// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offline_sync_manager.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PendingOperation _$PendingOperationFromJson(Map<String, dynamic> json) {
  return _PendingOperation.fromJson(json);
}

/// @nodoc
mixin _$PendingOperation {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  String get operationType =>
      throw _privateConstructorUsedError; // 'update_status', 'update_location'
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get retryCount => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PendingOperationCopyWith<PendingOperation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PendingOperationCopyWith<$Res> {
  factory $PendingOperationCopyWith(
          PendingOperation value, $Res Function(PendingOperation) then) =
      _$PendingOperationCopyWithImpl<$Res, PendingOperation>;
  @useResult
  $Res call(
      {String id,
      String orderId,
      String operationType,
      Map<String, dynamic> data,
      DateTime createdAt,
      int retryCount,
      String? error});
}

/// @nodoc
class _$PendingOperationCopyWithImpl<$Res, $Val extends PendingOperation>
    implements $PendingOperationCopyWith<$Res> {
  _$PendingOperationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? operationType = null,
    Object? data = null,
    Object? createdAt = null,
    Object? retryCount = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      operationType: null == operationType
          ? _value.operationType
          : operationType // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PendingOperationImplCopyWith<$Res>
    implements $PendingOperationCopyWith<$Res> {
  factory _$$PendingOperationImplCopyWith(_$PendingOperationImpl value,
          $Res Function(_$PendingOperationImpl) then) =
      __$$PendingOperationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String orderId,
      String operationType,
      Map<String, dynamic> data,
      DateTime createdAt,
      int retryCount,
      String? error});
}

/// @nodoc
class __$$PendingOperationImplCopyWithImpl<$Res>
    extends _$PendingOperationCopyWithImpl<$Res, _$PendingOperationImpl>
    implements _$$PendingOperationImplCopyWith<$Res> {
  __$$PendingOperationImplCopyWithImpl(_$PendingOperationImpl _value,
      $Res Function(_$PendingOperationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? operationType = null,
    Object? data = null,
    Object? createdAt = null,
    Object? retryCount = null,
    Object? error = freezed,
  }) {
    return _then(_$PendingOperationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      operationType: null == operationType
          ? _value.operationType
          : operationType // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PendingOperationImpl
    with DiagnosticableTreeMixin
    implements _PendingOperation {
  const _$PendingOperationImpl(
      {required this.id,
      required this.orderId,
      required this.operationType,
      required final Map<String, dynamic> data,
      required this.createdAt,
      required this.retryCount,
      this.error = null})
      : _data = data;

  factory _$PendingOperationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingOperationImplFromJson(json);

  @override
  final String id;
  @override
  final String orderId;
  @override
  final String operationType;
// 'update_status', 'update_location'
  final Map<String, dynamic> _data;
// 'update_status', 'update_location'
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  final DateTime createdAt;
  @override
  final int retryCount;
  @override
  @JsonKey()
  final String? error;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PendingOperation(id: $id, orderId: $orderId, operationType: $operationType, data: $data, createdAt: $createdAt, retryCount: $retryCount, error: $error)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PendingOperation'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('orderId', orderId))
      ..add(DiagnosticsProperty('operationType', operationType))
      ..add(DiagnosticsProperty('data', data))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('retryCount', retryCount))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingOperationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.operationType, operationType) ||
                other.operationType == operationType) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, orderId, operationType,
      const DeepCollectionEquality().hash(_data), createdAt, retryCount, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingOperationImplCopyWith<_$PendingOperationImpl> get copyWith =>
      __$$PendingOperationImplCopyWithImpl<_$PendingOperationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingOperationImplToJson(
      this,
    );
  }
}

abstract class _PendingOperation implements PendingOperation {
  const factory _PendingOperation(
      {required final String id,
      required final String orderId,
      required final String operationType,
      required final Map<String, dynamic> data,
      required final DateTime createdAt,
      required final int retryCount,
      final String? error}) = _$PendingOperationImpl;

  factory _PendingOperation.fromJson(Map<String, dynamic> json) =
      _$PendingOperationImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId;
  @override
  String get operationType;
  @override // 'update_status', 'update_location'
  Map<String, dynamic> get data;
  @override
  DateTime get createdAt;
  @override
  int get retryCount;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$PendingOperationImplCopyWith<_$PendingOperationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

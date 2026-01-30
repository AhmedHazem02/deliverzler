// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_delivery_status_optimistic_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UpdateDeliveryStatusState {
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool get isOptimistic => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UpdateDeliveryStatusStateCopyWith<UpdateDeliveryStatusState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateDeliveryStatusStateCopyWith<$Res> {
  factory $UpdateDeliveryStatusStateCopyWith(UpdateDeliveryStatusState value,
          $Res Function(UpdateDeliveryStatusState) then) =
      _$UpdateDeliveryStatusStateCopyWithImpl<$Res, UpdateDeliveryStatusState>;
  @useResult
  $Res call({bool isLoading, String? error, bool isOptimistic});
}

/// @nodoc
class _$UpdateDeliveryStatusStateCopyWithImpl<$Res,
        $Val extends UpdateDeliveryStatusState>
    implements $UpdateDeliveryStatusStateCopyWith<$Res> {
  _$UpdateDeliveryStatusStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = freezed,
    Object? isOptimistic = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isOptimistic: null == isOptimistic
          ? _value.isOptimistic
          : isOptimistic // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateDeliveryStatusStateImplCopyWith<$Res>
    implements $UpdateDeliveryStatusStateCopyWith<$Res> {
  factory _$$UpdateDeliveryStatusStateImplCopyWith(
          _$UpdateDeliveryStatusStateImpl value,
          $Res Function(_$UpdateDeliveryStatusStateImpl) then) =
      __$$UpdateDeliveryStatusStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, String? error, bool isOptimistic});
}

/// @nodoc
class __$$UpdateDeliveryStatusStateImplCopyWithImpl<$Res>
    extends _$UpdateDeliveryStatusStateCopyWithImpl<$Res,
        _$UpdateDeliveryStatusStateImpl>
    implements _$$UpdateDeliveryStatusStateImplCopyWith<$Res> {
  __$$UpdateDeliveryStatusStateImplCopyWithImpl(
      _$UpdateDeliveryStatusStateImpl _value,
      $Res Function(_$UpdateDeliveryStatusStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = freezed,
    Object? isOptimistic = null,
  }) {
    return _then(_$UpdateDeliveryStatusStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isOptimistic: null == isOptimistic
          ? _value.isOptimistic
          : isOptimistic // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$UpdateDeliveryStatusStateImpl implements _UpdateDeliveryStatusState {
  const _$UpdateDeliveryStatusStateImpl(
      {this.isLoading = false, this.error = null, this.isOptimistic = false});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String? error;
  @override
  @JsonKey()
  final bool isOptimistic;

  @override
  String toString() {
    return 'UpdateDeliveryStatusState(isLoading: $isLoading, error: $error, isOptimistic: $isOptimistic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateDeliveryStatusStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isOptimistic, isOptimistic) ||
                other.isOptimistic == isOptimistic));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, error, isOptimistic);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateDeliveryStatusStateImplCopyWith<_$UpdateDeliveryStatusStateImpl>
      get copyWith => __$$UpdateDeliveryStatusStateImplCopyWithImpl<
          _$UpdateDeliveryStatusStateImpl>(this, _$identity);
}

abstract class _UpdateDeliveryStatusState implements UpdateDeliveryStatusState {
  const factory _UpdateDeliveryStatusState(
      {final bool isLoading,
      final String? error,
      final bool isOptimistic}) = _$UpdateDeliveryStatusStateImpl;

  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  bool get isOptimistic;
  @override
  @JsonKey(ignore: true)
  _$$UpdateDeliveryStatusStateImplCopyWith<_$UpdateDeliveryStatusStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

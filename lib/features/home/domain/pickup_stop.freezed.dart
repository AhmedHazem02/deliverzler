// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pickup_stop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PickupStop {
  String get storeId => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  PickupStopStatus get status => throw _privateConstructorUsedError;
  List<OrderItem> get items => throw _privateConstructorUsedError;
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  DateTime? get pickedUpAt => throw _privateConstructorUsedError;
  DateTime? get rejectedAt => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PickupStopCopyWith<PickupStop> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PickupStopCopyWith<$Res> {
  factory $PickupStopCopyWith(
          PickupStop value, $Res Function(PickupStop) then) =
      _$PickupStopCopyWithImpl<$Res, PickupStop>;
  @useResult
  $Res call(
      {String storeId,
      String storeName,
      double subtotal,
      PickupStopStatus status,
      List<OrderItem> items,
      DateTime? confirmedAt,
      DateTime? pickedUpAt,
      DateTime? rejectedAt,
      String? rejectionReason});
}

/// @nodoc
class _$PickupStopCopyWithImpl<$Res, $Val extends PickupStop>
    implements $PickupStopCopyWith<$Res> {
  _$PickupStopCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? subtotal = null,
    Object? status = null,
    Object? items = null,
    Object? confirmedAt = freezed,
    Object? pickedUpAt = freezed,
    Object? rejectedAt = freezed,
    Object? rejectionReason = freezed,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PickupStopStatus,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickedUpAt: freezed == pickedUpAt
          ? _value.pickedUpAt
          : pickedUpAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectedAt: freezed == rejectedAt
          ? _value.rejectedAt
          : rejectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PickupStopImplCopyWith<$Res>
    implements $PickupStopCopyWith<$Res> {
  factory _$$PickupStopImplCopyWith(
          _$PickupStopImpl value, $Res Function(_$PickupStopImpl) then) =
      __$$PickupStopImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String storeId,
      String storeName,
      double subtotal,
      PickupStopStatus status,
      List<OrderItem> items,
      DateTime? confirmedAt,
      DateTime? pickedUpAt,
      DateTime? rejectedAt,
      String? rejectionReason});
}

/// @nodoc
class __$$PickupStopImplCopyWithImpl<$Res>
    extends _$PickupStopCopyWithImpl<$Res, _$PickupStopImpl>
    implements _$$PickupStopImplCopyWith<$Res> {
  __$$PickupStopImplCopyWithImpl(
      _$PickupStopImpl _value, $Res Function(_$PickupStopImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? subtotal = null,
    Object? status = null,
    Object? items = null,
    Object? confirmedAt = freezed,
    Object? pickedUpAt = freezed,
    Object? rejectedAt = freezed,
    Object? rejectionReason = freezed,
  }) {
    return _then(_$PickupStopImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PickupStopStatus,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickedUpAt: freezed == pickedUpAt
          ? _value.pickedUpAt
          : pickedUpAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectedAt: freezed == rejectedAt
          ? _value.rejectedAt
          : rejectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PickupStopImpl extends _PickupStop {
  const _$PickupStopImpl(
      {required this.storeId,
      required this.storeName,
      required this.subtotal,
      this.status = PickupStopStatus.pending,
      final List<OrderItem> items = const [],
      this.confirmedAt,
      this.pickedUpAt,
      this.rejectedAt,
      this.rejectionReason})
      : _items = items,
        super._();

  @override
  final String storeId;
  @override
  final String storeName;
  @override
  final double subtotal;
  @override
  @JsonKey()
  final PickupStopStatus status;
  final List<OrderItem> _items;
  @override
  @JsonKey()
  List<OrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final DateTime? confirmedAt;
  @override
  final DateTime? pickedUpAt;
  @override
  final DateTime? rejectedAt;
  @override
  final String? rejectionReason;

  @override
  String toString() {
    return 'PickupStop(storeId: $storeId, storeName: $storeName, subtotal: $subtotal, status: $status, items: $items, confirmedAt: $confirmedAt, pickedUpAt: $pickedUpAt, rejectedAt: $rejectedAt, rejectionReason: $rejectionReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PickupStopImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.pickedUpAt, pickedUpAt) ||
                other.pickedUpAt == pickedUpAt) &&
            (identical(other.rejectedAt, rejectedAt) ||
                other.rejectedAt == rejectedAt) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      storeId,
      storeName,
      subtotal,
      status,
      const DeepCollectionEquality().hash(_items),
      confirmedAt,
      pickedUpAt,
      rejectedAt,
      rejectionReason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PickupStopImplCopyWith<_$PickupStopImpl> get copyWith =>
      __$$PickupStopImplCopyWithImpl<_$PickupStopImpl>(this, _$identity);
}

abstract class _PickupStop extends PickupStop {
  const factory _PickupStop(
      {required final String storeId,
      required final String storeName,
      required final double subtotal,
      final PickupStopStatus status,
      final List<OrderItem> items,
      final DateTime? confirmedAt,
      final DateTime? pickedUpAt,
      final DateTime? rejectedAt,
      final String? rejectionReason}) = _$PickupStopImpl;
  const _PickupStop._() : super._();

  @override
  String get storeId;
  @override
  String get storeName;
  @override
  double get subtotal;
  @override
  PickupStopStatus get status;
  @override
  List<OrderItem> get items;
  @override
  DateTime? get confirmedAt;
  @override
  DateTime? get pickedUpAt;
  @override
  DateTime? get rejectedAt;
  @override
  String? get rejectionReason;
  @override
  @JsonKey(ignore: true)
  _$$PickupStopImplCopyWith<_$PickupStopImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

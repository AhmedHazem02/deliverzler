// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderDto _$OrderDtoFromJson(Map<String, dynamic> json) {
  return _OrderDto.fromJson(json);
}

/// @nodoc
mixin _$OrderDto {
// Date field mapping
  @JsonKey(name: 'created_at', readValue: _readDateValue)
  int get date =>
      throw _privateConstructorUsedError; // Pickup option (default to delivery)
  PickupOption get pickupOption => throw _privateConstructorUsedError;
  String get paymentMethod =>
      throw _privateConstructorUsedError; // Customer fields mapping
  @JsonKey(name: 'customer_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name')
  String get userName => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_phone')
  String get userPhone => throw _privateConstructorUsedError;
  String get userImage => throw _privateConstructorUsedError;
  String get userNote =>
      throw _privateConstructorUsedError; // Address fields (flat structure in DB)
  @JsonKey(name: 'delivery_state')
  String? get deliveryState => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_city')
  String? get deliveryCity => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_address')
  String? get deliveryStreet =>
      throw _privateConstructorUsedError; // Coordinates (separate lat/lng fields)
  @JsonKey(name: 'delivery_latitude')
  double? get deliveryLatitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_longitude')
  double? get deliveryLongitude =>
      throw _privateConstructorUsedError; // Status field (with trim to handle trailing spaces)
  @JsonKey(name: 'status', readValue: _readStatusValue)
  DeliveryStatus get deliveryStatus =>
      throw _privateConstructorUsedError; // Driver assignment
  @JsonKey(name: 'driver_id')
  String? get deliveryId => throw _privateConstructorUsedError;
  String? get employeeCancelNote => throw _privateConstructorUsedError;
  RejectionStatus get rejectionStatus =>
      throw _privateConstructorUsedError; // Price fields
  double get subTotal => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_price')
  double? get deliveryFee =>
      throw _privateConstructorUsedError; // Store information
  @JsonKey(name: 'store_id')
  String? get storeId =>
      throw _privateConstructorUsedError; // Admin comment when excuse is refused
  String? get adminComment =>
      throw _privateConstructorUsedError; // List of driver IDs who rejected/excused this order
  @JsonKey(name: 'rejected_by_drivers')
  List<String> get rejectedByDrivers => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false)
  String? get id => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrderDtoCopyWith<OrderDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderDtoCopyWith<$Res> {
  factory $OrderDtoCopyWith(OrderDto value, $Res Function(OrderDto) then) =
      _$OrderDtoCopyWithImpl<$Res, OrderDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'created_at', readValue: _readDateValue) int date,
      PickupOption pickupOption,
      String paymentMethod,
      @JsonKey(name: 'customer_id') String userId,
      @JsonKey(name: 'customer_name') String userName,
      @JsonKey(name: 'customer_phone') String userPhone,
      String userImage,
      String userNote,
      @JsonKey(name: 'delivery_state') String? deliveryState,
      @JsonKey(name: 'delivery_city') String? deliveryCity,
      @JsonKey(name: 'delivery_address') String? deliveryStreet,
      @JsonKey(name: 'delivery_latitude') double? deliveryLatitude,
      @JsonKey(name: 'delivery_longitude') double? deliveryLongitude,
      @JsonKey(name: 'status', readValue: _readStatusValue)
      DeliveryStatus deliveryStatus,
      @JsonKey(name: 'driver_id') String? deliveryId,
      String? employeeCancelNote,
      RejectionStatus rejectionStatus,
      double subTotal,
      double total,
      @JsonKey(name: 'delivery_price') double? deliveryFee,
      @JsonKey(name: 'store_id') String? storeId,
      String? adminComment,
      @JsonKey(name: 'rejected_by_drivers') List<String> rejectedByDrivers,
      @JsonKey(includeToJson: false) String? id});
}

/// @nodoc
class _$OrderDtoCopyWithImpl<$Res, $Val extends OrderDto>
    implements $OrderDtoCopyWith<$Res> {
  _$OrderDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? pickupOption = null,
    Object? paymentMethod = null,
    Object? userId = null,
    Object? userName = null,
    Object? userPhone = null,
    Object? userImage = null,
    Object? userNote = null,
    Object? deliveryState = freezed,
    Object? deliveryCity = freezed,
    Object? deliveryStreet = freezed,
    Object? deliveryLatitude = freezed,
    Object? deliveryLongitude = freezed,
    Object? deliveryStatus = null,
    Object? deliveryId = freezed,
    Object? employeeCancelNote = freezed,
    Object? rejectionStatus = null,
    Object? subTotal = null,
    Object? total = null,
    Object? deliveryFee = freezed,
    Object? storeId = freezed,
    Object? adminComment = freezed,
    Object? rejectedByDrivers = null,
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as int,
      pickupOption: null == pickupOption
          ? _value.pickupOption
          : pickupOption // ignore: cast_nullable_to_non_nullable
              as PickupOption,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userPhone: null == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String,
      userImage: null == userImage
          ? _value.userImage
          : userImage // ignore: cast_nullable_to_non_nullable
              as String,
      userNote: null == userNote
          ? _value.userNote
          : userNote // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryState: freezed == deliveryState
          ? _value.deliveryState
          : deliveryState // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryCity: freezed == deliveryCity
          ? _value.deliveryCity
          : deliveryCity // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryStreet: freezed == deliveryStreet
          ? _value.deliveryStreet
          : deliveryStreet // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryLatitude: freezed == deliveryLatitude
          ? _value.deliveryLatitude
          : deliveryLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      deliveryLongitude: freezed == deliveryLongitude
          ? _value.deliveryLongitude
          : deliveryLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      deliveryStatus: null == deliveryStatus
          ? _value.deliveryStatus
          : deliveryStatus // ignore: cast_nullable_to_non_nullable
              as DeliveryStatus,
      deliveryId: freezed == deliveryId
          ? _value.deliveryId
          : deliveryId // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeCancelNote: freezed == employeeCancelNote
          ? _value.employeeCancelNote
          : employeeCancelNote // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionStatus: null == rejectionStatus
          ? _value.rejectionStatus
          : rejectionStatus // ignore: cast_nullable_to_non_nullable
              as RejectionStatus,
      subTotal: null == subTotal
          ? _value.subTotal
          : subTotal // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFee: freezed == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      adminComment: freezed == adminComment
          ? _value.adminComment
          : adminComment // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedByDrivers: null == rejectedByDrivers
          ? _value.rejectedByDrivers
          : rejectedByDrivers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderDtoImplCopyWith<$Res>
    implements $OrderDtoCopyWith<$Res> {
  factory _$$OrderDtoImplCopyWith(
          _$OrderDtoImpl value, $Res Function(_$OrderDtoImpl) then) =
      __$$OrderDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'created_at', readValue: _readDateValue) int date,
      PickupOption pickupOption,
      String paymentMethod,
      @JsonKey(name: 'customer_id') String userId,
      @JsonKey(name: 'customer_name') String userName,
      @JsonKey(name: 'customer_phone') String userPhone,
      String userImage,
      String userNote,
      @JsonKey(name: 'delivery_state') String? deliveryState,
      @JsonKey(name: 'delivery_city') String? deliveryCity,
      @JsonKey(name: 'delivery_address') String? deliveryStreet,
      @JsonKey(name: 'delivery_latitude') double? deliveryLatitude,
      @JsonKey(name: 'delivery_longitude') double? deliveryLongitude,
      @JsonKey(name: 'status', readValue: _readStatusValue)
      DeliveryStatus deliveryStatus,
      @JsonKey(name: 'driver_id') String? deliveryId,
      String? employeeCancelNote,
      RejectionStatus rejectionStatus,
      double subTotal,
      double total,
      @JsonKey(name: 'delivery_price') double? deliveryFee,
      @JsonKey(name: 'store_id') String? storeId,
      String? adminComment,
      @JsonKey(name: 'rejected_by_drivers') List<String> rejectedByDrivers,
      @JsonKey(includeToJson: false) String? id});
}

/// @nodoc
class __$$OrderDtoImplCopyWithImpl<$Res>
    extends _$OrderDtoCopyWithImpl<$Res, _$OrderDtoImpl>
    implements _$$OrderDtoImplCopyWith<$Res> {
  __$$OrderDtoImplCopyWithImpl(
      _$OrderDtoImpl _value, $Res Function(_$OrderDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? pickupOption = null,
    Object? paymentMethod = null,
    Object? userId = null,
    Object? userName = null,
    Object? userPhone = null,
    Object? userImage = null,
    Object? userNote = null,
    Object? deliveryState = freezed,
    Object? deliveryCity = freezed,
    Object? deliveryStreet = freezed,
    Object? deliveryLatitude = freezed,
    Object? deliveryLongitude = freezed,
    Object? deliveryStatus = null,
    Object? deliveryId = freezed,
    Object? employeeCancelNote = freezed,
    Object? rejectionStatus = null,
    Object? subTotal = null,
    Object? total = null,
    Object? deliveryFee = freezed,
    Object? storeId = freezed,
    Object? adminComment = freezed,
    Object? rejectedByDrivers = null,
    Object? id = freezed,
  }) {
    return _then(_$OrderDtoImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as int,
      pickupOption: null == pickupOption
          ? _value.pickupOption
          : pickupOption // ignore: cast_nullable_to_non_nullable
              as PickupOption,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userPhone: null == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String,
      userImage: null == userImage
          ? _value.userImage
          : userImage // ignore: cast_nullable_to_non_nullable
              as String,
      userNote: null == userNote
          ? _value.userNote
          : userNote // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryState: freezed == deliveryState
          ? _value.deliveryState
          : deliveryState // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryCity: freezed == deliveryCity
          ? _value.deliveryCity
          : deliveryCity // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryStreet: freezed == deliveryStreet
          ? _value.deliveryStreet
          : deliveryStreet // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryLatitude: freezed == deliveryLatitude
          ? _value.deliveryLatitude
          : deliveryLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      deliveryLongitude: freezed == deliveryLongitude
          ? _value.deliveryLongitude
          : deliveryLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      deliveryStatus: null == deliveryStatus
          ? _value.deliveryStatus
          : deliveryStatus // ignore: cast_nullable_to_non_nullable
              as DeliveryStatus,
      deliveryId: freezed == deliveryId
          ? _value.deliveryId
          : deliveryId // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeCancelNote: freezed == employeeCancelNote
          ? _value.employeeCancelNote
          : employeeCancelNote // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionStatus: null == rejectionStatus
          ? _value.rejectionStatus
          : rejectionStatus // ignore: cast_nullable_to_non_nullable
              as RejectionStatus,
      subTotal: null == subTotal
          ? _value.subTotal
          : subTotal // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFee: freezed == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      adminComment: freezed == adminComment
          ? _value.adminComment
          : adminComment // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedByDrivers: null == rejectedByDrivers
          ? _value._rejectedByDrivers
          : rejectedByDrivers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$OrderDtoImpl extends _OrderDto with DiagnosticableTreeMixin {
  const _$OrderDtoImpl(
      {@JsonKey(name: 'created_at', readValue: _readDateValue)
      required this.date,
      this.pickupOption = PickupOption.delivery,
      this.paymentMethod = 'cash',
      @JsonKey(name: 'customer_id') required this.userId,
      @JsonKey(name: 'customer_name') required this.userName,
      @JsonKey(name: 'customer_phone') required this.userPhone,
      this.userImage = '',
      this.userNote = '',
      @JsonKey(name: 'delivery_state') this.deliveryState,
      @JsonKey(name: 'delivery_city') this.deliveryCity,
      @JsonKey(name: 'delivery_address') this.deliveryStreet,
      @JsonKey(name: 'delivery_latitude') this.deliveryLatitude,
      @JsonKey(name: 'delivery_longitude') this.deliveryLongitude,
      @JsonKey(name: 'status', readValue: _readStatusValue)
      required this.deliveryStatus,
      @JsonKey(name: 'driver_id') this.deliveryId,
      this.employeeCancelNote,
      this.rejectionStatus = RejectionStatus.none,
      this.subTotal = 0.0,
      required this.total,
      @JsonKey(name: 'delivery_price') this.deliveryFee,
      @JsonKey(name: 'store_id') this.storeId,
      this.adminComment,
      @JsonKey(name: 'rejected_by_drivers')
      final List<String> rejectedByDrivers = const [],
      @JsonKey(includeToJson: false) this.id})
      : _rejectedByDrivers = rejectedByDrivers,
        super._();

  factory _$OrderDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderDtoImplFromJson(json);

// Date field mapping
  @override
  @JsonKey(name: 'created_at', readValue: _readDateValue)
  final int date;
// Pickup option (default to delivery)
  @override
  @JsonKey()
  final PickupOption pickupOption;
  @override
  @JsonKey()
  final String paymentMethod;
// Customer fields mapping
  @override
  @JsonKey(name: 'customer_id')
  final String userId;
  @override
  @JsonKey(name: 'customer_name')
  final String userName;
  @override
  @JsonKey(name: 'customer_phone')
  final String userPhone;
  @override
  @JsonKey()
  final String userImage;
  @override
  @JsonKey()
  final String userNote;
// Address fields (flat structure in DB)
  @override
  @JsonKey(name: 'delivery_state')
  final String? deliveryState;
  @override
  @JsonKey(name: 'delivery_city')
  final String? deliveryCity;
  @override
  @JsonKey(name: 'delivery_address')
  final String? deliveryStreet;
// Coordinates (separate lat/lng fields)
  @override
  @JsonKey(name: 'delivery_latitude')
  final double? deliveryLatitude;
  @override
  @JsonKey(name: 'delivery_longitude')
  final double? deliveryLongitude;
// Status field (with trim to handle trailing spaces)
  @override
  @JsonKey(name: 'status', readValue: _readStatusValue)
  final DeliveryStatus deliveryStatus;
// Driver assignment
  @override
  @JsonKey(name: 'driver_id')
  final String? deliveryId;
  @override
  final String? employeeCancelNote;
  @override
  @JsonKey()
  final RejectionStatus rejectionStatus;
// Price fields
  @override
  @JsonKey()
  final double subTotal;
  @override
  final double total;
  @override
  @JsonKey(name: 'delivery_price')
  final double? deliveryFee;
// Store information
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;
// Admin comment when excuse is refused
  @override
  final String? adminComment;
// List of driver IDs who rejected/excused this order
  final List<String> _rejectedByDrivers;
// List of driver IDs who rejected/excused this order
  @override
  @JsonKey(name: 'rejected_by_drivers')
  List<String> get rejectedByDrivers {
    if (_rejectedByDrivers is EqualUnmodifiableListView)
      return _rejectedByDrivers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rejectedByDrivers);
  }

  @override
  @JsonKey(includeToJson: false)
  final String? id;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderDto(date: $date, pickupOption: $pickupOption, paymentMethod: $paymentMethod, userId: $userId, userName: $userName, userPhone: $userPhone, userImage: $userImage, userNote: $userNote, deliveryState: $deliveryState, deliveryCity: $deliveryCity, deliveryStreet: $deliveryStreet, deliveryLatitude: $deliveryLatitude, deliveryLongitude: $deliveryLongitude, deliveryStatus: $deliveryStatus, deliveryId: $deliveryId, employeeCancelNote: $employeeCancelNote, rejectionStatus: $rejectionStatus, subTotal: $subTotal, total: $total, deliveryFee: $deliveryFee, storeId: $storeId, adminComment: $adminComment, rejectedByDrivers: $rejectedByDrivers, id: $id)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderDto'))
      ..add(DiagnosticsProperty('date', date))
      ..add(DiagnosticsProperty('pickupOption', pickupOption))
      ..add(DiagnosticsProperty('paymentMethod', paymentMethod))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('userName', userName))
      ..add(DiagnosticsProperty('userPhone', userPhone))
      ..add(DiagnosticsProperty('userImage', userImage))
      ..add(DiagnosticsProperty('userNote', userNote))
      ..add(DiagnosticsProperty('deliveryState', deliveryState))
      ..add(DiagnosticsProperty('deliveryCity', deliveryCity))
      ..add(DiagnosticsProperty('deliveryStreet', deliveryStreet))
      ..add(DiagnosticsProperty('deliveryLatitude', deliveryLatitude))
      ..add(DiagnosticsProperty('deliveryLongitude', deliveryLongitude))
      ..add(DiagnosticsProperty('deliveryStatus', deliveryStatus))
      ..add(DiagnosticsProperty('deliveryId', deliveryId))
      ..add(DiagnosticsProperty('employeeCancelNote', employeeCancelNote))
      ..add(DiagnosticsProperty('rejectionStatus', rejectionStatus))
      ..add(DiagnosticsProperty('subTotal', subTotal))
      ..add(DiagnosticsProperty('total', total))
      ..add(DiagnosticsProperty('deliveryFee', deliveryFee))
      ..add(DiagnosticsProperty('storeId', storeId))
      ..add(DiagnosticsProperty('adminComment', adminComment))
      ..add(DiagnosticsProperty('rejectedByDrivers', rejectedByDrivers))
      ..add(DiagnosticsProperty('id', id));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderDtoImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.pickupOption, pickupOption) ||
                other.pickupOption == pickupOption) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userPhone, userPhone) ||
                other.userPhone == userPhone) &&
            (identical(other.userImage, userImage) ||
                other.userImage == userImage) &&
            (identical(other.userNote, userNote) ||
                other.userNote == userNote) &&
            (identical(other.deliveryState, deliveryState) ||
                other.deliveryState == deliveryState) &&
            (identical(other.deliveryCity, deliveryCity) ||
                other.deliveryCity == deliveryCity) &&
            (identical(other.deliveryStreet, deliveryStreet) ||
                other.deliveryStreet == deliveryStreet) &&
            (identical(other.deliveryLatitude, deliveryLatitude) ||
                other.deliveryLatitude == deliveryLatitude) &&
            (identical(other.deliveryLongitude, deliveryLongitude) ||
                other.deliveryLongitude == deliveryLongitude) &&
            (identical(other.deliveryStatus, deliveryStatus) ||
                other.deliveryStatus == deliveryStatus) &&
            (identical(other.deliveryId, deliveryId) ||
                other.deliveryId == deliveryId) &&
            (identical(other.employeeCancelNote, employeeCancelNote) ||
                other.employeeCancelNote == employeeCancelNote) &&
            (identical(other.rejectionStatus, rejectionStatus) ||
                other.rejectionStatus == rejectionStatus) &&
            (identical(other.subTotal, subTotal) ||
                other.subTotal == subTotal) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.adminComment, adminComment) ||
                other.adminComment == adminComment) &&
            const DeepCollectionEquality()
                .equals(other._rejectedByDrivers, _rejectedByDrivers) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        date,
        pickupOption,
        paymentMethod,
        userId,
        userName,
        userPhone,
        userImage,
        userNote,
        deliveryState,
        deliveryCity,
        deliveryStreet,
        deliveryLatitude,
        deliveryLongitude,
        deliveryStatus,
        deliveryId,
        employeeCancelNote,
        rejectionStatus,
        subTotal,
        total,
        deliveryFee,
        storeId,
        adminComment,
        const DeepCollectionEquality().hash(_rejectedByDrivers),
        id
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderDtoImplCopyWith<_$OrderDtoImpl> get copyWith =>
      __$$OrderDtoImplCopyWithImpl<_$OrderDtoImpl>(this, _$identity);
}

abstract class _OrderDto extends OrderDto {
  const factory _OrderDto(
      {@JsonKey(name: 'created_at', readValue: _readDateValue)
      required final int date,
      final PickupOption pickupOption,
      final String paymentMethod,
      @JsonKey(name: 'customer_id') required final String userId,
      @JsonKey(name: 'customer_name') required final String userName,
      @JsonKey(name: 'customer_phone') required final String userPhone,
      final String userImage,
      final String userNote,
      @JsonKey(name: 'delivery_state') final String? deliveryState,
      @JsonKey(name: 'delivery_city') final String? deliveryCity,
      @JsonKey(name: 'delivery_address') final String? deliveryStreet,
      @JsonKey(name: 'delivery_latitude') final double? deliveryLatitude,
      @JsonKey(name: 'delivery_longitude') final double? deliveryLongitude,
      @JsonKey(name: 'status', readValue: _readStatusValue)
      required final DeliveryStatus deliveryStatus,
      @JsonKey(name: 'driver_id') final String? deliveryId,
      final String? employeeCancelNote,
      final RejectionStatus rejectionStatus,
      final double subTotal,
      required final double total,
      @JsonKey(name: 'delivery_price') final double? deliveryFee,
      @JsonKey(name: 'store_id') final String? storeId,
      final String? adminComment,
      @JsonKey(name: 'rejected_by_drivers')
      final List<String> rejectedByDrivers,
      @JsonKey(includeToJson: false) final String? id}) = _$OrderDtoImpl;
  const _OrderDto._() : super._();

  factory _OrderDto.fromJson(Map<String, dynamic> json) =
      _$OrderDtoImpl.fromJson;

  @override // Date field mapping
  @JsonKey(name: 'created_at', readValue: _readDateValue)
  int get date;
  @override // Pickup option (default to delivery)
  PickupOption get pickupOption;
  @override
  String get paymentMethod;
  @override // Customer fields mapping
  @JsonKey(name: 'customer_id')
  String get userId;
  @override
  @JsonKey(name: 'customer_name')
  String get userName;
  @override
  @JsonKey(name: 'customer_phone')
  String get userPhone;
  @override
  String get userImage;
  @override
  String get userNote;
  @override // Address fields (flat structure in DB)
  @JsonKey(name: 'delivery_state')
  String? get deliveryState;
  @override
  @JsonKey(name: 'delivery_city')
  String? get deliveryCity;
  @override
  @JsonKey(name: 'delivery_address')
  String? get deliveryStreet;
  @override // Coordinates (separate lat/lng fields)
  @JsonKey(name: 'delivery_latitude')
  double? get deliveryLatitude;
  @override
  @JsonKey(name: 'delivery_longitude')
  double? get deliveryLongitude;
  @override // Status field (with trim to handle trailing spaces)
  @JsonKey(name: 'status', readValue: _readStatusValue)
  DeliveryStatus get deliveryStatus;
  @override // Driver assignment
  @JsonKey(name: 'driver_id')
  String? get deliveryId;
  @override
  String? get employeeCancelNote;
  @override
  RejectionStatus get rejectionStatus;
  @override // Price fields
  double get subTotal;
  @override
  double get total;
  @override
  @JsonKey(name: 'delivery_price')
  double? get deliveryFee;
  @override // Store information
  @JsonKey(name: 'store_id')
  String? get storeId;
  @override // Admin comment when excuse is refused
  String? get adminComment;
  @override // List of driver IDs who rejected/excused this order
  @JsonKey(name: 'rejected_by_drivers')
  List<String> get rejectedByDrivers;
  @override
  @JsonKey(includeToJson: false)
  String? get id;
  @override
  @JsonKey(ignore: true)
  _$$OrderDtoImplCopyWith<_$OrderDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

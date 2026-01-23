// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_application_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DriverApplicationDto _$DriverApplicationDtoFromJson(Map<String, dynamic> json) {
  return _DriverApplicationDto.fromJson(json);
}

/// @nodoc
mixin _$DriverApplicationDto {
  /// Application ID (document ID).
  String get id => throw _privateConstructorUsedError;

  /// User ID from Firebase Auth.
  String get userId => throw _privateConstructorUsedError;

  /// Application status string.
  String get status => throw _privateConstructorUsedError;

  /// Type indicator for Admin Dashboard.
  String get type => throw _privateConstructorUsedError;

  /// Driver's full name.
  String get name => throw _privateConstructorUsedError;

  /// Driver's email.
  String get email => throw _privateConstructorUsedError;

  /// Driver's phone number.
  String get phone => throw _privateConstructorUsedError;

  /// National ID number.
  String get idNumber => throw _privateConstructorUsedError;

  /// Driver's license number.
  String get licenseNumber => throw _privateConstructorUsedError;

  /// License expiry date as timestamp.
  int get licenseExpiryDate => throw _privateConstructorUsedError;

  /// Type of vehicle.
  String get vehicleType => throw _privateConstructorUsedError;

  /// Vehicle plate number.
  String get vehiclePlate => throw _privateConstructorUsedError;

  /// Profile photo URL.
  String? get photoUrl => throw _privateConstructorUsedError;

  /// National ID document URL.
  String? get idDocumentUrl => throw _privateConstructorUsedError;

  /// Driver's license document URL.
  String? get licenseUrl => throw _privateConstructorUsedError;

  /// Vehicle registration document URL.
  String? get vehicleRegistrationUrl => throw _privateConstructorUsedError;

  /// Vehicle insurance document URL.
  String? get vehicleInsuranceUrl => throw _privateConstructorUsedError;

  /// Application submission date as timestamp.
  int get createdAt => throw _privateConstructorUsedError;

  /// Date when application was reviewed.
  int? get reviewedAt => throw _privateConstructorUsedError;

  /// ID of admin who reviewed.
  String? get reviewedBy => throw _privateConstructorUsedError;

  /// Reason for rejection.
  String? get rejectionReason => throw _privateConstructorUsedError;

  /// Additional notes.
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DriverApplicationDtoCopyWith<DriverApplicationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DriverApplicationDtoCopyWith<$Res> {
  factory $DriverApplicationDtoCopyWith(DriverApplicationDto value,
          $Res Function(DriverApplicationDto) then) =
      _$DriverApplicationDtoCopyWithImpl<$Res, DriverApplicationDto>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String status,
      String type,
      String name,
      String email,
      String phone,
      String idNumber,
      String licenseNumber,
      int licenseExpiryDate,
      String vehicleType,
      String vehiclePlate,
      String? photoUrl,
      String? idDocumentUrl,
      String? licenseUrl,
      String? vehicleRegistrationUrl,
      String? vehicleInsuranceUrl,
      int createdAt,
      int? reviewedAt,
      String? reviewedBy,
      String? rejectionReason,
      String? notes});
}

/// @nodoc
class _$DriverApplicationDtoCopyWithImpl<$Res,
        $Val extends DriverApplicationDto>
    implements $DriverApplicationDtoCopyWith<$Res> {
  _$DriverApplicationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? status = null,
    Object? type = null,
    Object? name = null,
    Object? email = null,
    Object? phone = null,
    Object? idNumber = null,
    Object? licenseNumber = null,
    Object? licenseExpiryDate = null,
    Object? vehicleType = null,
    Object? vehiclePlate = null,
    Object? photoUrl = freezed,
    Object? idDocumentUrl = freezed,
    Object? licenseUrl = freezed,
    Object? vehicleRegistrationUrl = freezed,
    Object? vehicleInsuranceUrl = freezed,
    Object? createdAt = null,
    Object? reviewedAt = freezed,
    Object? reviewedBy = freezed,
    Object? rejectionReason = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      idNumber: null == idNumber
          ? _value.idNumber
          : idNumber // ignore: cast_nullable_to_non_nullable
              as String,
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      licenseExpiryDate: null == licenseExpiryDate
          ? _value.licenseExpiryDate
          : licenseExpiryDate // ignore: cast_nullable_to_non_nullable
              as int,
      vehicleType: null == vehicleType
          ? _value.vehicleType
          : vehicleType // ignore: cast_nullable_to_non_nullable
              as String,
      vehiclePlate: null == vehiclePlate
          ? _value.vehiclePlate
          : vehiclePlate // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      idDocumentUrl: freezed == idDocumentUrl
          ? _value.idDocumentUrl
          : idDocumentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseUrl: freezed == licenseUrl
          ? _value.licenseUrl
          : licenseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleRegistrationUrl: freezed == vehicleRegistrationUrl
          ? _value.vehicleRegistrationUrl
          : vehicleRegistrationUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleInsuranceUrl: freezed == vehicleInsuranceUrl
          ? _value.vehicleInsuranceUrl
          : vehicleInsuranceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as int?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DriverApplicationDtoImplCopyWith<$Res>
    implements $DriverApplicationDtoCopyWith<$Res> {
  factory _$$DriverApplicationDtoImplCopyWith(_$DriverApplicationDtoImpl value,
          $Res Function(_$DriverApplicationDtoImpl) then) =
      __$$DriverApplicationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String status,
      String type,
      String name,
      String email,
      String phone,
      String idNumber,
      String licenseNumber,
      int licenseExpiryDate,
      String vehicleType,
      String vehiclePlate,
      String? photoUrl,
      String? idDocumentUrl,
      String? licenseUrl,
      String? vehicleRegistrationUrl,
      String? vehicleInsuranceUrl,
      int createdAt,
      int? reviewedAt,
      String? reviewedBy,
      String? rejectionReason,
      String? notes});
}

/// @nodoc
class __$$DriverApplicationDtoImplCopyWithImpl<$Res>
    extends _$DriverApplicationDtoCopyWithImpl<$Res, _$DriverApplicationDtoImpl>
    implements _$$DriverApplicationDtoImplCopyWith<$Res> {
  __$$DriverApplicationDtoImplCopyWithImpl(_$DriverApplicationDtoImpl _value,
      $Res Function(_$DriverApplicationDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? status = null,
    Object? type = null,
    Object? name = null,
    Object? email = null,
    Object? phone = null,
    Object? idNumber = null,
    Object? licenseNumber = null,
    Object? licenseExpiryDate = null,
    Object? vehicleType = null,
    Object? vehiclePlate = null,
    Object? photoUrl = freezed,
    Object? idDocumentUrl = freezed,
    Object? licenseUrl = freezed,
    Object? vehicleRegistrationUrl = freezed,
    Object? vehicleInsuranceUrl = freezed,
    Object? createdAt = null,
    Object? reviewedAt = freezed,
    Object? reviewedBy = freezed,
    Object? rejectionReason = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$DriverApplicationDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      idNumber: null == idNumber
          ? _value.idNumber
          : idNumber // ignore: cast_nullable_to_non_nullable
              as String,
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      licenseExpiryDate: null == licenseExpiryDate
          ? _value.licenseExpiryDate
          : licenseExpiryDate // ignore: cast_nullable_to_non_nullable
              as int,
      vehicleType: null == vehicleType
          ? _value.vehicleType
          : vehicleType // ignore: cast_nullable_to_non_nullable
              as String,
      vehiclePlate: null == vehiclePlate
          ? _value.vehiclePlate
          : vehiclePlate // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      idDocumentUrl: freezed == idDocumentUrl
          ? _value.idDocumentUrl
          : idDocumentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseUrl: freezed == licenseUrl
          ? _value.licenseUrl
          : licenseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleRegistrationUrl: freezed == vehicleRegistrationUrl
          ? _value.vehicleRegistrationUrl
          : vehicleRegistrationUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleInsuranceUrl: freezed == vehicleInsuranceUrl
          ? _value.vehicleInsuranceUrl
          : vehicleInsuranceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as int?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DriverApplicationDtoImpl extends _DriverApplicationDto {
  const _$DriverApplicationDtoImpl(
      {required this.id,
      required this.userId,
      required this.status,
      this.type = 'driver',
      required this.name,
      required this.email,
      required this.phone,
      required this.idNumber,
      required this.licenseNumber,
      required this.licenseExpiryDate,
      required this.vehicleType,
      required this.vehiclePlate,
      this.photoUrl,
      this.idDocumentUrl,
      this.licenseUrl,
      this.vehicleRegistrationUrl,
      this.vehicleInsuranceUrl,
      required this.createdAt,
      this.reviewedAt,
      this.reviewedBy,
      this.rejectionReason,
      this.notes})
      : super._();

  factory _$DriverApplicationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DriverApplicationDtoImplFromJson(json);

  /// Application ID (document ID).
  @override
  final String id;

  /// User ID from Firebase Auth.
  @override
  final String userId;

  /// Application status string.
  @override
  final String status;

  /// Type indicator for Admin Dashboard.
  @override
  @JsonKey()
  final String type;

  /// Driver's full name.
  @override
  final String name;

  /// Driver's email.
  @override
  final String email;

  /// Driver's phone number.
  @override
  final String phone;

  /// National ID number.
  @override
  final String idNumber;

  /// Driver's license number.
  @override
  final String licenseNumber;

  /// License expiry date as timestamp.
  @override
  final int licenseExpiryDate;

  /// Type of vehicle.
  @override
  final String vehicleType;

  /// Vehicle plate number.
  @override
  final String vehiclePlate;

  /// Profile photo URL.
  @override
  final String? photoUrl;

  /// National ID document URL.
  @override
  final String? idDocumentUrl;

  /// Driver's license document URL.
  @override
  final String? licenseUrl;

  /// Vehicle registration document URL.
  @override
  final String? vehicleRegistrationUrl;

  /// Vehicle insurance document URL.
  @override
  final String? vehicleInsuranceUrl;

  /// Application submission date as timestamp.
  @override
  final int createdAt;

  /// Date when application was reviewed.
  @override
  final int? reviewedAt;

  /// ID of admin who reviewed.
  @override
  final String? reviewedBy;

  /// Reason for rejection.
  @override
  final String? rejectionReason;

  /// Additional notes.
  @override
  final String? notes;

  @override
  String toString() {
    return 'DriverApplicationDto(id: $id, userId: $userId, status: $status, type: $type, name: $name, email: $email, phone: $phone, idNumber: $idNumber, licenseNumber: $licenseNumber, licenseExpiryDate: $licenseExpiryDate, vehicleType: $vehicleType, vehiclePlate: $vehiclePlate, photoUrl: $photoUrl, idDocumentUrl: $idDocumentUrl, licenseUrl: $licenseUrl, vehicleRegistrationUrl: $vehicleRegistrationUrl, vehicleInsuranceUrl: $vehicleInsuranceUrl, createdAt: $createdAt, reviewedAt: $reviewedAt, reviewedBy: $reviewedBy, rejectionReason: $rejectionReason, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DriverApplicationDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.idNumber, idNumber) ||
                other.idNumber == idNumber) &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.licenseExpiryDate, licenseExpiryDate) ||
                other.licenseExpiryDate == licenseExpiryDate) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            (identical(other.vehiclePlate, vehiclePlate) ||
                other.vehiclePlate == vehiclePlate) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.idDocumentUrl, idDocumentUrl) ||
                other.idDocumentUrl == idDocumentUrl) &&
            (identical(other.licenseUrl, licenseUrl) ||
                other.licenseUrl == licenseUrl) &&
            (identical(other.vehicleRegistrationUrl, vehicleRegistrationUrl) ||
                other.vehicleRegistrationUrl == vehicleRegistrationUrl) &&
            (identical(other.vehicleInsuranceUrl, vehicleInsuranceUrl) ||
                other.vehicleInsuranceUrl == vehicleInsuranceUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.reviewedBy, reviewedBy) ||
                other.reviewedBy == reviewedBy) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        status,
        type,
        name,
        email,
        phone,
        idNumber,
        licenseNumber,
        licenseExpiryDate,
        vehicleType,
        vehiclePlate,
        photoUrl,
        idDocumentUrl,
        licenseUrl,
        vehicleRegistrationUrl,
        vehicleInsuranceUrl,
        createdAt,
        reviewedAt,
        reviewedBy,
        rejectionReason,
        notes
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DriverApplicationDtoImplCopyWith<_$DriverApplicationDtoImpl>
      get copyWith =>
          __$$DriverApplicationDtoImplCopyWithImpl<_$DriverApplicationDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DriverApplicationDtoImplToJson(
      this,
    );
  }
}

abstract class _DriverApplicationDto extends DriverApplicationDto {
  const factory _DriverApplicationDto(
      {required final String id,
      required final String userId,
      required final String status,
      final String type,
      required final String name,
      required final String email,
      required final String phone,
      required final String idNumber,
      required final String licenseNumber,
      required final int licenseExpiryDate,
      required final String vehicleType,
      required final String vehiclePlate,
      final String? photoUrl,
      final String? idDocumentUrl,
      final String? licenseUrl,
      final String? vehicleRegistrationUrl,
      final String? vehicleInsuranceUrl,
      required final int createdAt,
      final int? reviewedAt,
      final String? reviewedBy,
      final String? rejectionReason,
      final String? notes}) = _$DriverApplicationDtoImpl;
  const _DriverApplicationDto._() : super._();

  factory _DriverApplicationDto.fromJson(Map<String, dynamic> json) =
      _$DriverApplicationDtoImpl.fromJson;

  @override

  /// Application ID (document ID).
  String get id;
  @override

  /// User ID from Firebase Auth.
  String get userId;
  @override

  /// Application status string.
  String get status;
  @override

  /// Type indicator for Admin Dashboard.
  String get type;
  @override

  /// Driver's full name.
  String get name;
  @override

  /// Driver's email.
  String get email;
  @override

  /// Driver's phone number.
  String get phone;
  @override

  /// National ID number.
  String get idNumber;
  @override

  /// Driver's license number.
  String get licenseNumber;
  @override

  /// License expiry date as timestamp.
  int get licenseExpiryDate;
  @override

  /// Type of vehicle.
  String get vehicleType;
  @override

  /// Vehicle plate number.
  String get vehiclePlate;
  @override

  /// Profile photo URL.
  String? get photoUrl;
  @override

  /// National ID document URL.
  String? get idDocumentUrl;
  @override

  /// Driver's license document URL.
  String? get licenseUrl;
  @override

  /// Vehicle registration document URL.
  String? get vehicleRegistrationUrl;
  @override

  /// Vehicle insurance document URL.
  String? get vehicleInsuranceUrl;
  @override

  /// Application submission date as timestamp.
  int get createdAt;
  @override

  /// Date when application was reviewed.
  int? get reviewedAt;
  @override

  /// ID of admin who reviewed.
  String? get reviewedBy;
  @override

  /// Reason for rejection.
  String? get rejectionReason;
  @override

  /// Additional notes.
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$DriverApplicationDtoImplCopyWith<_$DriverApplicationDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

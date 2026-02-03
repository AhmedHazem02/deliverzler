import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as f_auth;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/user.dart';

part 'user_dto.freezed.dart';

part 'user_dto.g.dart';

// Timestamp converter functions (must be top-level or static)
DateTime? _timestampFromJson(dynamic timestamp) {
  if (timestamp == null) return null;
  if (timestamp is int) return DateTime.fromMillisecondsSinceEpoch(timestamp);
  return (timestamp as Timestamp).toDate();
}

dynamic _timestampToJson(DateTime? dateTime) {
  return dateTime != null ? Timestamp.fromDate(dateTime) : null;
}

// TODO(Ahmed): extend User entity when extending another Freezed class is supported:
// https://github.com/rrousselGit/freezed/issues/907
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    required String? name,
    required String? phone,
    required String? image,
    @Default(false) bool isOnline,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? lastActiveAt,
    @Default(0) int rejectionsCounter,
    @Default(0) int currentOrdersCount,
  }) = _UserDto;

  const UserDto._();

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  factory UserDto.fromUserCredential(f_auth.User user) {
    return UserDto(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName?.split(' ').first ?? '',
      phone: user.phoneNumber ?? '',
      image: user.photoURL ?? '',
      isOnline: false,
      lastActiveAt: null,
      rejectionsCounter: 0,
      currentOrdersCount: 0,
    );
  }

  factory UserDto.fromDomain(User user) {
    return UserDto(
      id: user.id,
      email: user.email,
      name: user.name,
      phone: user.phone,
      image: user.image,
      isOnline: user.isOnline,
      lastActiveAt: user.lastActiveAt,
      rejectionsCounter: user.rejectionsCounter,
      currentOrdersCount: user.currentOrdersCount,
    );
  }

  User toDomain() {
    return User(
      id: id,
      email: email,
      name: name,
      phone: phone,
      image: image,
      isOnline: isOnline,
      lastActiveAt: lastActiveAt,
      rejectionsCounter: rejectionsCounter,
      currentOrdersCount: currentOrdersCount,
    );
  }
}

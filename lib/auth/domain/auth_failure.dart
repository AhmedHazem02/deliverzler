import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.userNotFound() = _UserNotFound;
  const factory AuthFailure.invalidEmail() = _InvalidEmail;
  const factory AuthFailure.emailAlreadyInUse() = _EmailAlreadyInUse;
  const factory AuthFailure.wrongPassword() = _WrongPassword;
  const factory AuthFailure.tooManyRequests() = _TooManyRequests;
  const factory AuthFailure.networkError() = _NetworkError;
  const factory AuthFailure.serverError([String? message]) = _ServerError;
  const factory AuthFailure.emailNotVerified() = _EmailNotVerified;
  const factory AuthFailure.userDisabled() = _UserDisabled;
}

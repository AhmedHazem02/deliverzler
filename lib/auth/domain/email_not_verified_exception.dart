import '../../../core/infrastructure/error/app_exception.dart';

/// Exception thrown when email is not verified
class EmailNotVerifiedException implements Exception {
  const EmailNotVerifiedException({this.email});

  final String? email;

  @override
  String toString() =>
      'EmailNotVerifiedException: Email $email is not verified';
}

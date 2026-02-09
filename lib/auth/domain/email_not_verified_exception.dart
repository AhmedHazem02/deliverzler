/// Exception thrown when email is not verified
class EmailNotVerifiedException implements Exception {
  const EmailNotVerifiedException({this.email});

  final String? email;

  @override
  String toString() =>
      'EmailNotVerifiedException: Email $email is not verified';
}

/// Exception thrown when user has not completed identity verification
/// (neither email nor phone).
class NotVerifiedException implements Exception {
  const NotVerifiedException({this.email, this.phone, this.chosenMethod});

  final String? email;
  final String? phone;

  /// The verification method the user previously chose, or null if they
  /// haven't chosen yet (first time after sign-up).
  final String? chosenMethod;

  @override
  String toString() =>
      'NotVerifiedException: user not verified (email=$email, phone=$phone, method=$chosenMethod)';
}

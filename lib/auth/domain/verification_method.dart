/// The method chosen by the user to verify their identity after sign-up.
enum VerificationMethod {
  email,
  phone;

  static VerificationMethod? fromString(String? value) {
    if (value == null) return null;
    return VerificationMethod.values.cast<VerificationMethod?>().firstWhere(
          (e) => e?.name == value,
          orElse: () => null,
        );
  }
}

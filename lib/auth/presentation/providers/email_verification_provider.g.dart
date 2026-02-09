// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_verification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emailVerificationHash() => r'56bb5671bc5e52109f85682c5fc59441480444ed';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$EmailVerification
    extends BuildlessAutoDisposeNotifier<EmailVerificationState> {
  late final String email;

  EmailVerificationState build(
    String email,
  );
}

/// See also [EmailVerification].
@ProviderFor(EmailVerification)
const emailVerificationProvider = EmailVerificationFamily();

/// See also [EmailVerification].
class EmailVerificationFamily extends Family<EmailVerificationState> {
  /// See also [EmailVerification].
  const EmailVerificationFamily();

  /// See also [EmailVerification].
  EmailVerificationProvider call(
    String email,
  ) {
    return EmailVerificationProvider(
      email,
    );
  }

  @override
  EmailVerificationProvider getProviderOverride(
    covariant EmailVerificationProvider provider,
  ) {
    return call(
      provider.email,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'emailVerificationProvider';
}

/// See also [EmailVerification].
class EmailVerificationProvider extends AutoDisposeNotifierProviderImpl<
    EmailVerification, EmailVerificationState> {
  /// See also [EmailVerification].
  EmailVerificationProvider(
    String email,
  ) : this._internal(
          () => EmailVerification()..email = email,
          from: emailVerificationProvider,
          name: r'emailVerificationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$emailVerificationHash,
          dependencies: EmailVerificationFamily._dependencies,
          allTransitiveDependencies:
              EmailVerificationFamily._allTransitiveDependencies,
          email: email,
        );

  EmailVerificationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
  }) : super.internal();

  final String email;

  @override
  EmailVerificationState runNotifierBuild(
    covariant EmailVerification notifier,
  ) {
    return notifier.build(
      email,
    );
  }

  @override
  Override overrideWith(EmailVerification Function() create) {
    return ProviderOverride(
      origin: this,
      override: EmailVerificationProvider._internal(
        () => create()..email = email,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<EmailVerification, EmailVerificationState>
      createElement() {
    return _EmailVerificationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EmailVerificationProvider && other.email == email;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EmailVerificationRef
    on AutoDisposeNotifierProviderRef<EmailVerificationState> {
  /// The parameter `email` of this provider.
  String get email;
}

class _EmailVerificationProviderElement
    extends AutoDisposeNotifierProviderElement<EmailVerification,
        EmailVerificationState> with EmailVerificationRef {
  _EmailVerificationProviderElement(super.provider);

  @override
  String get email => (origin as EmailVerificationProvider).email;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

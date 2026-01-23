// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserStateHash() => r'2b93039d1ff8690ca51ae05229d108d629275be7';

/// See also [currentUserState].
@ProviderFor(currentUserState)
final currentUserStateProvider = AutoDisposeFutureProvider<User>.internal(
  currentUserState,
  name: r'currentUserStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserStateRef = AutoDisposeFutureProviderRef<User>;
String _$currentUserHash() => r'd09be3f914f2a534685898b14f34f766f48ec8c1';

/// See also [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeProvider<User>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserRef = AutoDisposeProviderRef<User>;
String _$authStateHash() => r'1009ba3f81452f2e5b7062ad2709ebc8cacc8375';

/// See also [AuthState].
@ProviderFor(AuthState)
final authStateProvider = NotifierProvider<AuthState, Option<User>>.internal(
  AuthState.new,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthState = Notifier<Option<User>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

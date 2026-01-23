// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_remote_message_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getInitialMessageHash() => r'c820733e8d8352536acf326d3ea0f8989b648f89';

/// Called when the application open from a terminated state.
/// If it opened via notification, RemoteMessage will be returned, otherwise it will be null.
/// Should be called in app initState or at home screen because we need context for navigation.
///
/// Copied from [getInitialMessage].
@ProviderFor(getInitialMessage)
final getInitialMessageProvider =
    AutoDisposeFutureProvider<Option<RemoteMessage>>.internal(
  getInitialMessage,
  name: r'getInitialMessageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getInitialMessageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetInitialMessageRef
    = AutoDisposeFutureProviderRef<Option<RemoteMessage>>;
String _$onMessageHash() => r'9ee872063c99d34d7cfccede900ea5c4bf7ddd55';

/// Called when FCM payload is received while the app is in the foreground.
///
/// Copied from [onMessage].
@ProviderFor(onMessage)
final onMessageProvider = AutoDisposeStreamProvider<RemoteMessage>.internal(
  onMessage,
  name: r'onMessageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$onMessageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OnMessageRef = AutoDisposeStreamProviderRef<RemoteMessage>;
String _$onMessageOpenedAppHash() =>
    r'0943f4995543e4b8fa671f9979602a089bae9511';

/// Called when a user presses a notification message displayed via FCM.
/// Only if the app has opened from background state (not foreground or terminated).
///
/// Copied from [onMessageOpenedApp].
@ProviderFor(onMessageOpenedApp)
final onMessageOpenedAppProvider =
    AutoDisposeStreamProvider<RemoteMessage>.internal(
  onMessageOpenedApp,
  name: r'onMessageOpenedAppProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$onMessageOpenedAppHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OnMessageOpenedAppRef = AutoDisposeStreamProviderRef<RemoteMessage>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

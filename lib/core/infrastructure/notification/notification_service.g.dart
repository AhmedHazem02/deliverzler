// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$setupFlutterNotificationsHash() =>
    r'960e1b2ce8edce2b1764d8e12ab66f5b1f67b1e9';

/// See also [setupFlutterNotifications].
@ProviderFor(setupFlutterNotifications)
final setupFlutterNotificationsProvider =
    AutoDisposeFutureProvider<void>.internal(
  setupFlutterNotifications,
  name: r'setupFlutterNotificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$setupFlutterNotificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SetupFlutterNotificationsRef = AutoDisposeFutureProviderRef<void>;
String _$requestNotificationPermissionsHash() =>
    r'c10db31a1a28201b52076b34fe6c925b4be643ad';

/// See also [requestNotificationPermissions].
@ProviderFor(requestNotificationPermissions)
final requestNotificationPermissionsProvider =
    AutoDisposeFutureProvider<AuthorizationStatus>.internal(
  requestNotificationPermissions,
  name: r'requestNotificationPermissionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$requestNotificationPermissionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RequestNotificationPermissionsRef
    = AutoDisposeFutureProviderRef<AuthorizationStatus>;
String _$notificationServiceHash() =>
    r'd2e964b663aa126eb7e1cf6a9879402488955bd5';

/// See also [notificationService].
@ProviderFor(notificationService)
final notificationServiceProvider = Provider<NotificationService>.internal(
  notificationService,
  name: r'notificationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationServiceRef = ProviderRef<NotificationService>;
String _$notificationResponseEventHash() =>
    r'066b43ade586232ab7836146ce39847407fd3116';

/// See also [NotificationResponseEvent].
@ProviderFor(NotificationResponseEvent)
final notificationResponseEventProvider = NotifierProvider<
    NotificationResponseEvent, Option<NotificationResponse>>.internal(
  NotificationResponseEvent.new,
  name: r'notificationResponseEventProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationResponseEventHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationResponseEvent = Notifier<Option<NotificationResponse>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

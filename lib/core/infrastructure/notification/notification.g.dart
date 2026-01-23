// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationPayloadImpl _$$NotificationPayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationPayloadImpl(
      routeLocation: json['routeLocation'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$NotificationPayloadImplToJson(
        _$NotificationPayloadImpl instance) =>
    <String, dynamic>{
      'routeLocation': instance.routeLocation,
      'data': instance.data,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tappedNotificationHash() =>
    r'87ecce11ccbefa686392c1be284cc5f9b8d7fb5e';

/// See also [tappedNotification].
@ProviderFor(tappedNotification)
final tappedNotificationProvider =
    AutoDisposeProvider<Option<NotificationPayload>>.internal(
  tappedNotification,
  name: r'tappedNotificationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tappedNotificationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TappedNotificationRef
    = AutoDisposeProviderRef<Option<NotificationPayload>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

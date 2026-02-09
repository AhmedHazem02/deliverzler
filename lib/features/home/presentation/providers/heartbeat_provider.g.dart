// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heartbeat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$heartbeatHash() => r'2055d71e0bdb58671a407c5c681bcb257d7cccec';

/// Provider that sends periodic heartbeat to update driver's lastActiveAt.
///
/// Runs every 10 minutes while driver is online to prevent auto-offline.
/// Also updates on location changes.
///
/// Copied from [Heartbeat].
@ProviderFor(Heartbeat)
final heartbeatProvider = AutoDisposeNotifierProvider<Heartbeat, void>.internal(
  Heartbeat.new,
  name: r'heartbeatProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$heartbeatHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Heartbeat = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

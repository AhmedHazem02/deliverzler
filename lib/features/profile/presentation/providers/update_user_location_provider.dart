import 'package:geolocator/geolocator.dart';

import '../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../home/presentation/providers/location_stream_provider.dart';
import '../../infrastructure/repos/profile_repo.dart';

part 'update_user_location_provider.g.dart';

// Track last update to throttle Firestore writes
Position? _lastUpdatedPosition;
DateTime? _lastUpdateTime;

@riverpod
Future<void> updateUserLocationState(
  Ref ref,
) async {
  // Only update if user is authenticated
  final authState = ref.watch(authStateProvider);
  final isAuth = authState.isSome();
  if (!isAuth) return;

  final position = ref.watch(locationStreamProvider).valueOrNull;
  if (position == null) return;

  // CRITICAL FIX: Throttle updates to prevent infinite loop
  // Only update if:
  // 1. Never updated before, OR
  // 2. Position changed by > 50m, OR
  // 3. 30 seconds have passed since last update
  final now = DateTime.now();

  if (_lastUpdatedPosition != null && _lastUpdateTime != null) {
    final distance = Geolocator.distanceBetween(
      _lastUpdatedPosition!.latitude,
      _lastUpdatedPosition!.longitude,
      position.latitude,
      position.longitude,
    );

    final timeSinceLastUpdate = now.difference(_lastUpdateTime!);

    // Skip update if position hasn't changed significantly and time threshold not met
    if (distance < 50 && timeSinceLastUpdate.inSeconds < 30) {
      return;
    }
  }

  // Update Firestore
  await ref.read(profileRepoProvider).updateUserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );

  // Track this update
  _lastUpdatedPosition = position;
  _lastUpdateTime = now;
}

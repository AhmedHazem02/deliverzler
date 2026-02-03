import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/infrastructure/error/app_exception.dart';
import '../../../../core/infrastructure/network/main_api/api_callers/firebase_firestore_facade.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../auth/presentation/providers/auth_state_provider.dart';

part 'driver_availability_provider.g.dart';

/// Provider for managing driver's online/offline status.
@riverpod
class DriverAvailability extends _$DriverAvailability {
  @override
  Future<bool> build() async {
    // Get initial status from user data
    final user = ref.watch(currentUserProvider);
    return user.isOnline;
  }

  /// Toggle driver's online status.
  Future<void> toggleAvailability() async {
    final firebaseFirestore = ref.read(firebaseFirestoreFacadeProvider);
    final userId = ref.read(currentUserProvider).id;

    // Get current state
    final currentState = state.valueOrNull ?? false;
    final newState = !currentState;

    // Optimistically update UI
    state = AsyncValue.data(newState);

    try {
      await firebaseFirestore.updateData(
        path: 'users/$userId',
        data: {
          'isOnline': newState,
          'lastActiveAt': FieldValue.serverTimestamp(),
        },
      );

      // Update successful - state already updated
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(currentState);

      throw ServerException(
        type: ServerExceptionType.general,
        message: 'Failed to update availability: $e',
      );
    }
  }

  /// Set online status explicitly.
  Future<void> setOnline(bool isOnline) async {
    final firebaseFirestore = ref.read(firebaseFirestoreFacadeProvider);
    final userId = ref.read(currentUserProvider).id;

    // Optimistically update UI
    state = AsyncValue.data(isOnline);

    try {
      await firebaseFirestore.updateData(
        path: 'users/$userId',
        data: {
          'isOnline': isOnline,
          'lastActiveAt': FieldValue.serverTimestamp(),
        },
      );
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(!isOnline);

      throw ServerException(
        type: ServerExceptionType.general,
        message: 'Failed to update availability: $e',
      );
    }
  }

  /// Set driver offline (on app close/logout).
  Future<void> goOffline() async {
    return setOnline(false);
  }
}

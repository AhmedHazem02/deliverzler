import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/infrastructure/network/main_api/api_callers/firebase_firestore_facade.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../auth/presentation/providers/auth_state_provider.dart';
import 'driver_availability_provider.dart';

part 'heartbeat_provider.g.dart';

/// Provider that sends periodic heartbeat to update driver's lastActiveAt.
///
/// Runs every 10 minutes while driver is online to prevent auto-offline.
/// Also updates on location changes.
@riverpod
class Heartbeat extends _$Heartbeat {
  Timer? _timer;

  @override
  void build() {
    // Watch driver availability to start/stop heartbeat
    ref.listen(driverAvailabilityProvider, (previous, next) {
      next.whenData((isOnline) {
        if (isOnline) {
          _startHeartbeat();
        } else {
          _stopHeartbeat();
        }
      });
    });

    // Start immediately if online
    final isOnline = ref.read(driverAvailabilityProvider).valueOrNull ?? false;
    if (isOnline) {
      _startHeartbeat();
    }

    // Cleanup on dispose
    ref.onDispose(() {
      _stopHeartbeat();
    });
  }

  void _startHeartbeat() {
    // Cancel existing timer if any
    _timer?.cancel();

    // Send initial heartbeat
    _sendHeartbeat();

    // Set up periodic heartbeat every 10 minutes
    _timer = Timer.periodic(const Duration(minutes: 10), (_) {
      _sendHeartbeat();
    });
  }

  void _stopHeartbeat() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _sendHeartbeat() async {
    try {
      final firebaseFirestore = ref.read(firebaseFirestoreFacadeProvider);
      final userId = ref.read(currentUserProvider).id;

      await firebaseFirestore.updateData(
        path: 'users/$userId',
        data: {
          'lastActiveAt': FieldValue.serverTimestamp(),
        },
      );
    } catch (e) {
      // Silently fail - don't disrupt user experience
      // The cleanup function will handle stale drivers
    }
  }

  /// Manual trigger for heartbeat (e.g., on location update).
  Future<void> sendHeartbeat() async {
    return _sendHeartbeat();
  }
}

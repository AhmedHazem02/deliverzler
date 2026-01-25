import '../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../home/presentation/providers/location_stream_provider.dart';
import '../../infrastructure/repos/profile_repo.dart';

part 'update_user_location_provider.g.dart';

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

  await ref.read(profileRepoProvider).updateUserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
}

import 'package:flutter/foundation.dart';

import '../../../../../core/presentation/providers/provider_utils.dart';
import '../../../../../core/presentation/utils/fp_framework.dart';
import '../../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../home/presentation/providers/location_stream_provider.dart';
import '../../../domain/place_directions.dart';
import '../../../infrastructure/repos/map_repo.dart';
import 'target_location_geo_point_provider.dart';

part 'target_location_directions_provider.g.dart';

@riverpod
Option<PlaceDirections> targetLocationDirections(
  TargetLocationDirectionsRef ref,
) {
  final asyncValue = ref.watch(getTargetLocationDirectionsProvider);
  debugPrint('🧭 targetLocationDirections asyncValue: $asyncValue');

  return asyncValue.maybeWhen(
    skipError: true,
    skipLoadingOnReload: true,
    skipLoadingOnRefresh: true,
    data: (data) {
      debugPrint(
          '🧭 ✅ Got directions with ${data.polylinePoints.length} points');
      return Some(data);
    },
    orElse: () {
      debugPrint('🧭 ❌ No directions yet (loading or error)');
      return const None();
    },
  );
}

@riverpod
Future<PlaceDirections> getTargetLocationDirections(
  GetTargetLocationDirectionsRef ref,
) async {
  debugPrint('🧭 getTargetLocationDirections called');

  final myLocation =
      ref.watch(locationStreamProvider.select((value) => value.valueOrNull));
  debugPrint(
      '🧭 myLocation: ${myLocation != null ? "${myLocation.latitude}, ${myLocation.longitude}" : "null"}');
  if (myLocation == null) {
    debugPrint('🧭 ❌ Aborting: No myLocation');
    throw AbortedException();
  }

  final targetLocationOpt = ref.watch(targetLocationGeoPointProvider);
  debugPrint(
      '🧭 targetLocationOpt: ${targetLocationOpt is Some ? "Some" : "None"}');

  final targetLocation = targetLocationOpt.getOrElse(() {
    debugPrint('🧭 ❌ Aborting: No targetLocation');
    throw AbortedException();
  });
  debugPrint(
      '🧭 targetLocation: ${targetLocation.latitude}, ${targetLocation.longitude}');

  final cancelToken = ref.cancelToken();
  final query = PlaceDirectionsQuery(
    origin: myLocation,
    destination: targetLocation,
  );

  debugPrint('🧭 Fetching directions from Google API...');
  try {
    final result = await ref
        .watch(mapRepoProvider)
        .getPlaceDirections(query, cancelToken: cancelToken);
    debugPrint(
        '🧭 ✅ Got ${result.polylinePoints.length} polyline points, distance: ${result.distance}m');
    return result;
  } catch (e, st) {
    debugPrint('🧭 ❌ Error fetching directions: $e');
    debugPrint('🧭 Stack trace: $st');
    rethrow;
  }
}

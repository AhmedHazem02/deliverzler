import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/presentation/utils/fp_framework.dart';
import '../../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../domain/place_directions.dart';
import '../../helpers/map_coordinates_helper.dart';
import '../is_arrived_target_location_provider.dart';
import '../target_location_providers/target_location_directions_provider.dart';

part 'map_polylines_provider.g.dart';

@riverpod
class MapPolylines extends _$MapPolylines {
  @override
  Set<Polyline> build() {
    debugPrint('🛤️ MapPolylines build() called');
    state = {};

    // FIX: Hide polyline when arrived (< 200m) to show map details clearly
    final isArrived = ref.watch(isArrivedTargetLocationProvider);
    if (isArrived) {
      debugPrint(
          '🛤️ ✅ Arrived at destination - Hiding polyline for better visibility');
      return {};
    }

    ref.listen<Option<PlaceDirections>>(
      targetLocationDirectionsProvider,
      (previous, next) {
        debugPrint('🛤️ Directions changed: ${next is Some ? "Some" : "None"}');
        next.fold(
          () {
            debugPrint('🛤️ No directions available yet');
          },
          _addPolylineFromDirections,
        );
      },
      fireImmediately: true,
    );
    return state;
  }

  void _addPolylineFromDirections(PlaceDirections placeDirections) {
    debugPrint(
        '🛤️ Adding polyline with ${placeDirections.polylinePoints.length} points');

    final polyline = MapCoordinatesHelper.getPolylineFromRouteCoordinates(
      polylinePoints: placeDirections.polylinePoints,
    );

    debugPrint('🛤️ Created polyline: ${polyline.polylineId.value}');
    debugPrint('🛤️ Polyline points: ${polyline.points.length}');
    debugPrint('🛤️ Polyline color: ${polyline.color}');
    debugPrint('🛤️ Polyline width: ${polyline.width}');

    final mapPolylines = Set<Polyline>.from(state);
    //If mapPolylines already has polyline with same id,
    //remove it first to avoid adding duplicate polylines and replace it instead.
    mapPolylines.removeWhere((p) => p.polylineId == polyline.polylineId);
    mapPolylines.add(polyline);

    state = mapPolylines;
    debugPrint('🛤️ ✅ State updated with ${state.length} polylines');
  }
}

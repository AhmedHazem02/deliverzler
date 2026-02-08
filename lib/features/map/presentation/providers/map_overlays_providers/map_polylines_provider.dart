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
    state = {};

    // Hide polyline when arrived (< 200m) to show map details clearly
    final isArrived = ref.watch(isArrivedTargetLocationProvider);
    if (isArrived) return {};

    ref.listen<Option<PlaceDirections>>(
      targetLocationDirectionsProvider,
      (previous, next) {
        next.fold(
          () {},
          _addPolylineFromDirections,
        );
      },
      fireImmediately: true,
    );
    return state;
  }

  void _addPolylineFromDirections(PlaceDirections placeDirections) {
    final polyline = MapCoordinatesHelper.getPolylineFromRouteCoordinates(
      polylinePoints: placeDirections.polylinePoints,
    );

    final mapPolylines = Set<Polyline>.from(state);
    mapPolylines.removeWhere((p) => p.polylineId == polyline.polylineId);
    mapPolylines.add(polyline);

    state = mapPolylines;
  }
}

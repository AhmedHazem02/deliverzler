import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/presentation/utils/fp_framework.dart';
import '../../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../home/presentation/providers/selected_order_provider.dart';
import '../../helpers/map_style_helper.dart';
import '../place_details_provider.dart';
import 'target_location_camera_position_provider.dart';
import 'target_location_geo_point_provider.dart';

part 'target_location_marker_provider.g.dart';

@riverpod
Marker targetLocationMarker(Ref ref) {
  final cameraTarget = ref.watch(
    targetLocationCameraPositionProvider.select((camera) => camera.target),
  );

  // First check if user searched for a place, otherwise use order address
  final searchedPlaceDescription = ref.watch(
    selectedPlaceAutocompleteProvider.select(
      (value) => value.match(() => null, (p) => p.description),
    ),
  );

  // Get order address as fallback
  final orderAddress = ref.watch(
    selectedOrderProvider.select(
      (order) => order.match(
        () => null,
        (o) {
          if (o.address != null) {
            // Build address string from order
            final parts = <String>[];
            if (o.address!.street.isNotEmpty) parts.add(o.address!.street);
            if (o.address!.city.isNotEmpty) parts.add(o.address!.city);
            if (o.address!.state.isNotEmpty) parts.add(o.address!.state);
            return parts.isNotEmpty ? parts.join(', ') : 'عنوان التوصيل';
          }
          return null;
        },
      ),
    ),
  );

  // Use searched place description if available, otherwise order address
  final targetDescription =
      searchedPlaceDescription ?? orderAddress ?? 'User Location';

  final targetMarker = MapStyleHelper.getSelectedPlaceMarker(
    position: cameraTarget,
    description: targetDescription,
    onDragEnd: (newPosition) {
      final position =
          Some(GeoPoint(newPosition.latitude, newPosition.longitude));
      ref
          .watch(targetLocationGeoPointProvider.notifier)
          .update((_) => position);
    },
  );
  return targetMarker;
}

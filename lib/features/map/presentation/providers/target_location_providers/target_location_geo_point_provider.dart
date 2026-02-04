import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/presentation/providers/provider_utils.dart';
import '../../../../../core/presentation/utils/fp_framework.dart';
import '../../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../home/presentation/providers/selected_order_provider.dart';
import '../place_details_provider.dart';

part 'target_location_geo_point_provider.g.dart';

@riverpod
class TargetLocationGeoPoint extends _$TargetLocationGeoPoint {
  @override
  Option<GeoPoint> build() {
    final currentPlaceDetails = ref.watch(currentPlaceDetailsProvider);

    return currentPlaceDetails.match(
      () => ref.watch(
        selectedOrderProvider.select(
          (order) => order.flatMap(
            (o) {
              print('🔍 [TargetLocation] Processing Order ID: ${o.id}');
              print('🔍 [TargetLocation] Address present: ${o.address != null}');
              print('🔍 [TargetLocation] GeoPoint present: ${o.address?.geoPoint != null}');
              if (o.address?.geoPoint != null) {
                  print('🔍 [TargetLocation] Lat: ${o.address?.geoPoint?.latitude}, Lng: ${o.address?.geoPoint?.longitude}');
              } else {
                  print('🔍 [TargetLocation] GeoPoint is NULL!');
                  print('🔍 [TargetLocation] Fallback DeliveryGeoPoint: ${o.deliveryGeoPoint != null}');
              }
              return Option<GeoPoint>.fromNullable(o.address?.geoPoint);
            },
          ),
        ),
      ),
      (placeDetails) => Some(placeDetails.geoPoint),
    );
  }

  void update(Option<GeoPoint> Function(Option<GeoPoint> state) fn) =>
      state = fn(state);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/json_converters/geo_point_converter.dart';

part 'route_point.freezed.dart';
part 'route_point.g.dart';

/// Represents a single point in the delivery route history
/// Used to track the actual path taken by the delivery person
@freezed
class RoutePoint with _$RoutePoint {
  const factory RoutePoint({
    @GeoPointConverter() required GeoPoint geoPoint,
    required double heading,
    required double speed,
    required double accuracy,
    required int timestamp,
    @Default(false) bool isMocked,
  }) = _RoutePoint;

  factory RoutePoint.fromJson(Map<String, dynamic> json) =>
      _$RoutePointFromJson(json);
}

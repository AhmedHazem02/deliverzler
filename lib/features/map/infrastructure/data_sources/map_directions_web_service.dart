import 'dart:async';
// ignore: deprecated_member_use
import 'dart:js' as js;

import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show LatLng, LatLngBounds;

import '../../domain/place_directions.dart';

/// Web-specific DirectionsService using Google Maps JavaScript API
/// This is required because the REST API doesn't support CORS for web browsers
class MapDirectionsWebService {
  static final MapDirectionsWebService _instance =
      MapDirectionsWebService._internal();
  factory MapDirectionsWebService() => _instance;
  MapDirectionsWebService._internal();

  js.JsObject? _directionsService;

  void _ensureInitialized() {
    if (_directionsService == null && js.context.hasProperty('google')) {
      final googleMaps = js.context['google']['maps'];
      final directionsServiceConstructor =
          googleMaps['DirectionsService'] as js.JsFunction;
      _directionsService = js.JsObject(directionsServiceConstructor, []);
      debugPrint('🌐 Web DirectionsService initialized');
    }
  }

  /// Get directions using JavaScript DirectionsService
  Future<PlaceDirections> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    _ensureInitialized();

    if (_directionsService == null) {
      throw Exception('Google Maps JavaScript API not available');
    }

    final completer = Completer<PlaceDirections>();

    try {
      debugPrint(
          '🌐 Requesting directions from (${origin.latitude}, ${origin.longitude}) to (${destination.latitude}, ${destination.longitude})');

      final googleMaps = js.context['google']['maps'];

      final request = js.JsObject.jsify({
        'origin': {
          'lat': origin.latitude,
          'lng': origin.longitude,
        },
        'destination': {
          'lat': destination.latitude,
          'lng': destination.longitude,
        },
        'travelMode': 'DRIVING',
        'unitSystem': googleMaps['UnitSystem']['METRIC'],
      });

      // Create callback - use Function type that JS interop accepts
      void handleResponse(dynamic response, dynamic status) {
        final statusStr = status.toString();
        debugPrint('🌐 DirectionsService response status: $statusStr');

        if (statusStr == 'OK') {
          try {
            final jsResponse = response as js.JsObject;
            final directions = _parseDirectionsResponse(jsResponse);
            completer.complete(directions);
          } catch (e) {
            debugPrint('🌐 Error parsing directions: $e');
            completer.completeError(e);
          }
        } else {
          debugPrint('🌐 DirectionsService failed: $statusStr');
          completer.completeError(
              Exception('Directions request failed: $statusStr'));
        }
      }

      _directionsService!.callMethod('route', [request, handleResponse]);
    } catch (e) {
      debugPrint('🌐 Error calling DirectionsService: $e');
      completer.completeError(e);
    }

    return completer.future;
  }

  PlaceDirections _parseDirectionsResponse(js.JsObject response) {
    try {
      // Get the first route - use js.JsArray for proper array access
      final routesArray = response['routes'] as js.JsArray;
      if (routesArray.length == 0) {
        throw Exception('No routes found');
      }

      final route = routesArray[0] as js.JsObject;
      final legsArray = route['legs'] as js.JsArray;
      if (legsArray.length == 0) {
        throw Exception('No legs found');
      }

      final leg = legsArray[0] as js.JsObject;

      // Get distance (in meters) and duration
      final distance = leg['distance'] as js.JsObject;
      final duration = leg['duration'] as js.JsObject;

      final distanceValue = (distance['value'] as num).toInt();
      final durationText = duration['text'] as String;

      debugPrint('🌐 Distance: $distanceValue meters, Duration: $durationText');

      // Get encoded polyline - the structure varies, so handle different cases
      final overviewPolylineRaw = route['overview_polyline'];
      debugPrint(
          '🌐 overview_polyline type: ${overviewPolylineRaw.runtimeType}');

      String points;
      if (overviewPolylineRaw is String) {
        // Direct string (already encoded points)
        points = overviewPolylineRaw;
      } else if (overviewPolylineRaw is js.JsObject) {
        // JsObject with 'points' property
        final pointsRaw = overviewPolylineRaw['points'];
        if (pointsRaw is String) {
          points = pointsRaw;
        } else {
          points = pointsRaw.toString();
        }
      } else {
        // Try to convert to string
        points = overviewPolylineRaw.toString();
      }

      debugPrint('🌐 Polyline points: $points');
      debugPrint('🌐 Polyline points length: ${points.length}');

      // Decode polyline
      final polylinePoints = PolylinePoints.decodePolyline(points);
      debugPrint('🌐 Decoded ${polylinePoints.length} points');

      // Get bounds
      final bounds = route['bounds'] as js.JsObject;
      final northeast = bounds.callMethod('getNorthEast') as js.JsObject;
      final southwest = bounds.callMethod('getSouthWest') as js.JsObject;

      final neLat = (northeast.callMethod('lat') as num).toDouble();
      final neLng = (northeast.callMethod('lng') as num).toDouble();
      final swLat = (southwest.callMethod('lat') as num).toDouble();
      final swLng = (southwest.callMethod('lng') as num).toDouble();

      debugPrint('🌐 Bounds: NE($neLat, $neLng), SW($swLat, $swLng)');

      return PlaceDirections(
        bounds: LatLngBounds(
          northeast: LatLng(neLat, neLng),
          southwest: LatLng(swLat, swLng),
        ),
        polylinePoints: polylinePoints,
        distance: distanceValue,
        duration: durationText,
      );
    } catch (e) {
      debugPrint('🌐 Error in _parseDirectionsResponse: $e');
      rethrow;
    }
  }
}

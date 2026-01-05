import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show Marker, Circle, Polyline;

import '../../../../core/core_features/theme/presentation/providers/current_app_theme_provider.dart';
import '../../../../core/core_features/theme/presentation/utils/app_theme.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../providers/my_location_providers/my_location_camera_position_provider.dart';
import '../providers/map_overlays_providers/map_markers_providers.dart';
import '../providers/map_overlays_providers/map_circles_providers.dart';
import '../providers/map_overlays_providers/map_polylines_provider.dart';

class GoogleMapWebComponent extends ConsumerStatefulWidget {
  const GoogleMapWebComponent({super.key});

  @override
  ConsumerState<GoogleMapWebComponent> createState() =>
      _GoogleMapWebComponentState();
}

class _GoogleMapWebComponentState extends ConsumerState<GoogleMapWebComponent> {
  final String _mapDivId =
      'google-map-web-${DateTime.now().millisecondsSinceEpoch}';
  js.JsObject? _map;
  final Map<String, js.JsObject> _markers = {};
  final Map<String, js.JsObject> _circles = {};
  final Map<String, js.JsObject> _polylines = {};

  @override
  void initState() {
    super.initState();
    _registerMapView();
  }

  void _registerMapView() {
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      _mapDivId,
      (int viewId) {
        // Get initial position
        final cameraPosition = ref.read(myLocationCameraPositionProvider);
        final lat = cameraPosition.target.latitude;
        final lng = cameraPosition.target.longitude;

        // Create div for the map
        final mapDiv = html.DivElement()
          ..id = _mapDivId
          ..style.width = '100%'
          ..style.height = '100%';

        // Initialize Google Maps using JavaScript API
        Future.delayed(const Duration(milliseconds: 200), () {
          try {
            // Get theme
            final isDark =
                ref.read(currentAppThemeModeProvider) == AppThemeMode.dark;

            // Create map using Google Maps JavaScript API
            final result = js.context.callMethod('eval', [
              '''
              (function() {
                var mapDiv = document.getElementById('$_mapDivId');
                if (mapDiv && window.google && window.google.maps) {
                  var map = new google.maps.Map(mapDiv, {
                    center: {lat: $lat, lng: $lng},
                    zoom: 15,
                    zoomControl: true,
                    mapTypeControl: false,
                    streetViewControl: false,
                    fullscreenControl: false,
                    styles: ${isDark ? _getDarkMapStyle() : '[]'}
                  });
                  return map;
                }
                return null;
              })();
              '''
            ]);

            if (result != null) {
              _map = result as js.JsObject;
              _updateOverlays();
            }
          } catch (e) {
            print('Error initializing map: $e');
          }
        });

        return mapDiv;
      },
    );
  }

  String _getDarkMapStyle() {
    // Dark map style for Google Maps
    return '''[
      {"elementType": "geometry", "stylers": [{"color": "#242f3e"}]},
      {"elementType": "labels.text.stroke", "stylers": [{"color": "#242f3e"}]},
      {"elementType": "labels.text.fill", "stylers": [{"color": "#746855"}]},
      {"featureType": "administrative.locality", "elementType": "labels.text.fill", "stylers": [{"color": "#d59563"}]},
      {"featureType": "poi", "elementType": "labels.text.fill", "stylers": [{"color": "#d59563"}]},
      {"featureType": "poi.park", "elementType": "geometry", "stylers": [{"color": "#263c3f"}]},
      {"featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [{"color": "#6b9a76"}]},
      {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#38414e"}]},
      {"featureType": "road", "elementType": "geometry.stroke", "stylers": [{"color": "#212a37"}]},
      {"featureType": "road", "elementType": "labels.text.fill", "stylers": [{"color": "#9ca5b3"}]},
      {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#746855"}]},
      {"featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [{"color": "#1f2835"}]},
      {"featureType": "road.highway", "elementType": "labels.text.fill", "stylers": [{"color": "#f3d19c"}]},
      {"featureType": "transit", "elementType": "geometry", "stylers": [{"color": "#2f3948"}]},
      {"featureType": "transit.station", "elementType": "labels.text.fill", "stylers": [{"color": "#d59563"}]},
      {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#17263c"}]},
      {"featureType": "water", "elementType": "labels.text.fill", "stylers": [{"color": "#515c6d"}]},
      {"featureType": "water", "elementType": "labels.text.stroke", "stylers": [{"color": "#17263c"}]}
    ]''';
  }

  void _updateOverlays() {
    if (_map == null) return;

    // Update markers
    _updateMarkers(ref.read(mapMarkersProvider));

    // Update circles
    _updateCircles(ref.read(mapCirclesProvider));

    // Update polylines
    _updatePolylines(ref.read(mapPolylinesProvider));
  }

  void _updateMarkers(Set<Marker> markers) {
    if (_map == null) return;

    // Clear existing markers
    _markers.forEach((key, marker) {
      marker.callMethod('setMap', [null]);
    });
    _markers.clear();

    // Add new markers
    for (final marker in markers) {
      try {
        final markerConstructor = js.context['google']['maps']['Marker'];
        final jsMarker = js.JsObject(markerConstructor, [
          js.JsObject.jsify({
            'position': {
              'lat': marker.position.latitude,
              'lng': marker.position.longitude
            },
            'map': _map,
            'title': marker.markerId.value,
          })
        ]);
        _markers[marker.markerId.value] = jsMarker;
      } catch (e) {
        print('Error creating marker: $e');
      }
    }
  }

  void _updateCircles(Set<Circle> circles) {
    if (_map == null) return;

    // Clear existing circles
    _circles.forEach((key, circle) {
      circle.callMethod('setMap', [null]);
    });
    _circles.clear();

    // Add new circles
    for (final circle in circles) {
      try {
        final circleConstructor = js.context['google']['maps']['Circle'];
        final jsCircle = js.JsObject(circleConstructor, [
          js.JsObject.jsify({
            'center': {
              'lat': circle.center.latitude,
              'lng': circle.center.longitude
            },
            'radius': circle.radius,
            'fillColor':
                '#${circle.fillColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
            'fillOpacity': circle.fillColor.opacity,
            'strokeColor':
                '#${circle.strokeColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
            'strokeOpacity': circle.strokeColor.opacity,
            'strokeWeight': circle.strokeWidth,
            'map': _map,
          })
        ]);
        _circles[circle.circleId.value] = jsCircle;
      } catch (e) {
        print('Error creating circle: $e');
      }
    }
  }

  void _updatePolylines(Set<Polyline> polylines) {
    if (_map == null) return;

    // Clear existing polylines
    _polylines.forEach((key, polyline) {
      polyline.callMethod('setMap', [null]);
    });
    _polylines.clear();

    // Add new polylines
    for (final polyline in polylines) {
      try {
        final path = polyline.points.map((point) {
          return {'lat': point.latitude, 'lng': point.longitude};
        }).toList();

        final polylineConstructor = js.context['google']['maps']['Polyline'];
        final jsPolyline = js.JsObject(polylineConstructor, [
          js.JsObject.jsify({
            'path': path,
            'strokeColor':
                '#${polyline.color.value.toRadixString(16).padLeft(8, '0').substring(2)}',
            'strokeOpacity': polyline.color.opacity,
            'strokeWeight': polyline.width,
            'map': _map,
          })
        ]);
        _polylines[polyline.polylineId.value] = jsPolyline;
      } catch (e) {
        print('Error creating polyline: $e');
      }
    }
  }

  void _panToLocation(double lat, double lng) {
    if (_map == null) return;
    try {
      _map!.callMethod('panTo', [
        js.JsObject.jsify({'lat': lat, 'lng': lng})
      ]);
    } catch (e) {
      print('Error panning map: $e');
    }
  }

  void _updateMapStyle(bool isDark) {
    if (_map == null) return;
    try {
      final styles = isDark
          ? js.context.callMethod('eval', ['(${_getDarkMapStyle()})'])
          : js.JsArray();
      _map!.callMethod('setOptions', [
        js.JsObject.jsify({'styles': styles})
      ]);
    } catch (e) {
      print('Error updating map style: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to markers changes
    ref.listen(mapMarkersProvider, (previous, next) {
      _updateMarkers(next);
    });

    // Listen to circles changes
    ref.listen(mapCirclesProvider, (previous, next) {
      _updateCircles(next);
    });

    // Listen to polylines changes
    ref.listen(mapPolylinesProvider, (previous, next) {
      _updatePolylines(next);
    });

    // Listen to location changes
    ref.listen(myLocationCameraPositionProvider, (previous, next) {
      _panToLocation(next.target.latitude, next.target.longitude);
    });

    // Listen to theme changes
    ref.listen(currentAppThemeModeProvider, (previous, next) {
      _updateMapStyle(next == AppThemeMode.dark);
    });

    return HtmlElementView(
      viewType: _mapDivId,
    );
  }

  @override
  void dispose() {
    // Clean up markers, circles, and polylines
    _markers.forEach((key, marker) {
      marker.callMethod('setMap', [null]);
    });
    _circles.forEach((key, circle) {
      circle.callMethod('setMap', [null]);
    });
    _polylines.forEach((key, polyline) {
      polyline.callMethod('setMap', [null]);
    });
    super.dispose();
  }
}

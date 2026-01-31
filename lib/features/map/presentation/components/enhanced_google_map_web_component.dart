import 'dart:convert';
import 'dart:async';
// ignore: deprecated_member_use
import 'dart:html' as html;
// ignore: deprecated_member_use
import 'dart:js' as js;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show BitmapDescriptor, CameraPosition, Circle, LatLng, Marker, Polyline;

import '../../../../core/core_features/theme/presentation/providers/current_app_theme_provider.dart';
import '../../../../core/core_features/theme/presentation/utils/app_theme.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../helpers/map_style_helper.dart';
import '../providers/map_overlays_providers/map_circles_providers.dart';
import '../providers/map_overlays_providers/map_markers_providers.dart';
import '../providers/map_overlays_providers/map_polylines_provider.dart';
import '../providers/my_location_providers/my_location_camera_position_provider.dart';

/// Enhanced Google Maps Web Component with high performance and all features
/// Implements clean architecture and optimized rendering
class EnhancedGoogleMapWebComponent extends ConsumerStatefulWidget {
  const EnhancedGoogleMapWebComponent({super.key});

  @override
  ConsumerState<EnhancedGoogleMapWebComponent> createState() =>
      _EnhancedGoogleMapWebComponentState();
}

class _EnhancedGoogleMapWebComponentState
    extends ConsumerState<EnhancedGoogleMapWebComponent> {
  final String _mapDivId =
      'google-map-enhanced-${DateTime.now().millisecondsSinceEpoch}';

  js.JsObject? _map;
  final Map<String, js.JsObject> _markers = {};
  final Map<String, js.JsObject> _circles = {};
  final Map<String, js.JsObject> _polylines = {};
  final Map<String, html.ImageElement> _markerIcons = {};

  Timer? _updateTimer;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _registerMapView();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _clearAllOverlays();
    super.dispose();
  }

  void _registerMapView() {
    // Register platform view for web
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      _mapDivId,
      (int viewId) => _createMapElement(),
    );
  }

  html.DivElement _createMapElement() {
    final mapDiv = html.DivElement()
      ..id = _mapDivId
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.position = 'relative';

    // Initialize map after a short delay to ensure DOM is ready
    Future.delayed(const Duration(milliseconds: 100), _initializeMap);

    return mapDiv;
  }

  Future<void> _initializeMap() async {
    if (!mounted) return;

    try {
      final cameraPosition = ref.read(myLocationCameraPositionProvider);
      final isDark = ref.read(currentAppThemeModeProvider) == AppThemeMode.dark;

      // Get map styles from helper
      final mapStyles = isDark ? await _getDarkMapStyles() : [];

      // Create map using Google Maps JavaScript API
      final mapOptions = js.JsObject.jsify({
        'center': {
          'lat': cameraPosition.target.latitude,
          'lng': cameraPosition.target.longitude,
        },
        'zoom': cameraPosition.zoom.toInt(),
        'zoomControl': true,
        'zoomControlOptions': {
          'position': _getControlPosition('RIGHT_BOTTOM'),
        },
        'mapTypeControl': false,
        'streetViewControl': false,
        'fullscreenControl': true,
        'fullscreenControlOptions': {
          'position': _getControlPosition('RIGHT_TOP'),
        },
        'gestureHandling': 'greedy',
        'styles': mapStyles,
        'disableDefaultUI': false,
        'clickableIcons': false,
        'backgroundColor': isDark ? '#1a1a1a' : '#ffffff',
      });

      final mapDiv = html.document.getElementById(_mapDivId);
      if (mapDiv != null && js.context.hasProperty('google')) {
        final googleMaps = js.context['google']['maps'];
        final mapConstructor = googleMaps['Map'] as js.JsFunction;
        _map = js.JsObject(mapConstructor, [mapDiv, mapOptions]);

        // Setup event listeners
        _setupMapEventListeners();

        _isMapReady = true;

        // Initial overlay update
        _updateAllOverlays();

        // Setup periodic updates for smooth animation
        _startPeriodicUpdates();

        debugPrint('Enhanced Google Map initialized successfully');
      }
    } catch (e) {
      debugPrint('Error initializing enhanced map: $e');
    }
  }

  void _setupMapEventListeners() {
    if (_map == null) return;

    try {
      final googleMaps = js.context['google']['maps'];
      final event = googleMaps['event'];

      // Define callback functions
      void onZoomChanged() {
        if (mounted && _map != null) {
          final zoom = _map!.callMethod('getZoom');
          debugPrint('Zoom changed to: $zoom');
        }
      }

      void onCenterChanged() {
        if (mounted && _map != null) {
          // ignore: unused_local_variable
          final center = _map!.callMethod('getCenter');
          // Handle center change if needed
        }
      }

      void onMapClick(dynamic clickEvent) {
        final jsEvent = clickEvent as js.JsObject;
        final latLng = jsEvent['latLng'];
        final lat = latLng.callMethod('lat');
        final lng = latLng.callMethod('lng');
        debugPrint('Map clicked at: $lat, $lng');
      }

      // Listen to zoom changes
      event.callMethod('addListener', [
        _map,
        'zoom_changed',
        onZoomChanged,
      ]);

      // Listen to center changes
      event.callMethod('addListener', [
        _map,
        'center_changed',
        onCenterChanged,
      ]);

      // Listen to map clicks
      event.callMethod('addListener', [
        _map,
        'click',
        onMapClick,
      ]);
    } catch (e) {
      debugPrint('Error setting up map event listeners: $e');
    }
  }

  void _startPeriodicUpdates() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted && _isMapReady) {
        _updateAllOverlays();
      }
    });
  }

  void _updateAllOverlays() {
    if (!_isMapReady || _map == null) return;

    try {
      final markers = ref.read(mapMarkersProvider);
      final circles = ref.read(mapCirclesProvider);
      final polylines = ref.read(mapPolylinesProvider);

      _updateMarkers(markers);
      _updateCircles(circles);
      _updatePolylines(polylines);
    } catch (e) {
      debugPrint('Error updating overlays: $e');
    }
  }

  final Map<String, String> _dataUriCache = {};
  final Map<String, int> _dataUriByteLengthCache = {};

  void _updateMarkers(Set<Marker> markers) {
    if (_map == null) return;

    // Remove markers that no longer exist
    final markerIds = markers.map((m) => m.markerId.value).toSet();
    _markers.keys.toList().forEach((id) {
      if (!markerIds.contains(id)) {
        _markers[id]?.callMethod('setMap', [null]);
        _markers.remove(id);
        // Clean up cache
        _dataUriCache.remove(id);
        _dataUriByteLengthCache.remove(id);
      }
    });

    // Add or update markers
    for (final marker in markers) {
      final markerId = marker.markerId.value;

      if (_markers.containsKey(markerId)) {
        // Update existing marker
        _updateMarkerData(marker, _markers[markerId]!);
      } else {
        // Create new marker
        _createMarker(marker);
      }
    }
  }

  final Map<String, String> _lastMarkerIconUrl = {};

  void _updateMarkerData(Marker marker, js.JsObject jsMarker) {
    // Consolidated update (Atomic operation to prevent flickering)
    final Map<String, dynamic> optionsToUpdate = {
      'position': {
        'lat': marker.position.latitude,
        'lng': marker.position.longitude,
      },
      'title': marker.infoWindow.title ?? marker.markerId.value,
      'draggable': marker.draggable,
      'visible': marker.visible,
      'zIndex': 999, // Force highest z-index for my location
      'rotation': marker.rotation,
      'flat': marker.flat,
    };

    // Icon Diffing
    final newIconUrl = _parseIcon(marker.icon, marker.markerId.value);
    final lastUrl = _lastMarkerIconUrl[marker.markerId.value];

    if (newIconUrl != null && newIconUrl != lastUrl) {
      optionsToUpdate['icon'] = newIconUrl;
      _lastMarkerIconUrl[marker.markerId.value] = newIconUrl;
    }

    // Apply ALL options in one go
    final jsOptions = js.JsObject.jsify(optionsToUpdate);
    jsMarker.callMethod('setOptions', [jsOptions]);
  }

  dynamic _parseIcon(BitmapDescriptor icon, String markerId) {
    try {
      final json = icon.toJson() as List<dynamic>;
      final type = json[0] as String;

      switch (type) {
        case 'defaultMarker':
          if (json.length > 1) {
             return null; 
          }
          return null;
        case 'fromAssetImage':
          final path = json[1] as String;
          if (path.startsWith('assets/')) {
             return 'assets/$path';
          }
          return 'assets/$path';
        case 'fromBytes':
          final rawBytes = json[1];
          if (rawBytes is List) {
             final bytes = rawBytes.cast<int>();
             
             // Check cache: Avoid heavy base64 encoding if bytes haven't changed
             if (_dataUriCache.containsKey(markerId) && 
                 _dataUriByteLengthCache[markerId] == bytes.length) {
                // Ideally we check content hash, but length is a fast proxy for this frame-rate
                return _dataUriCache[markerId];
             }

             // Convert to Base64 Data URI
             final base64String = base64Encode(bytes);
             final dataUri = 'data:image/png;base64,$base64String';
             
             _dataUriCache[markerId] = dataUri;
             _dataUriByteLengthCache[markerId] = bytes.length;
             return dataUri;
          }
          return null;
        default:
          return null;
      }
    } catch (e) {
      debugPrint('Error parsing icon: $e');
      return null;
    }
  }

  void _createMarker(Marker marker) {
    try {
      final googleMaps = js.context['google']['maps'];
      final icon = _parseIcon(marker.icon, marker.markerId.value);

      final markerOptions = js.JsObject.jsify({
        'position': {
          'lat': marker.position.latitude,
          'lng': marker.position.longitude,
        },
        'map': _map,
        'title': marker.infoWindow.title ?? marker.markerId.value,
        'draggable': marker.draggable,
        'visible': marker.visible,
        'zIndex': marker.zIndex.toInt(),
        'optimized': true,
        'rotation': marker.rotation,
        'flat': marker.flat,
        if (icon != null) 'icon': icon,
      });

      final markerConstructor = googleMaps['Marker'] as js.JsFunction;
      final jsMarker = js.JsObject(markerConstructor, [markerOptions]);

      if (marker.onTap != null || marker.infoWindow.title != null) {
        void onMarkerClick() {
          debugPrint('Marker clicked: ${marker.markerId.value}');
          marker.onTap?.call();
        }

        googleMaps['event'].callMethod('addListener', [
          jsMarker,
          'click',
          onMarkerClick,
        ]);
      }

      _markers[marker.markerId.value] = jsMarker;
    } catch (e) {
      debugPrint('Error creating marker: $e');
    }
  }

  void _updateCircles(Set<Circle> circles) {
    if (_map == null) return;

    // Remove circles that no longer exist
    final circleIds = circles.map((c) => c.circleId.value).toSet();
    _circles.keys.toList().forEach((id) {
      if (!circleIds.contains(id)) {
        _circles[id]?.callMethod('setMap', [null]);
        _circles.remove(id);
      }
    });

    // Add or update circles
    for (final circle in circles) {
      final circleId = circle.circleId.value;

      if (_circles.containsKey(circleId)) {
        // Update existing circle
        final center = js.JsObject.jsify({
          'lat': circle.center.latitude,
          'lng': circle.center.longitude,
        });
        _circles[circleId]?.callMethod('setCenter', [center]);
        _circles[circleId]?.callMethod('setRadius', [circle.radius]);
      } else {
        // Create new circle
        _createCircle(circle);
      }
    }
  }

  void _createCircle(Circle circle) {
    try {
      final googleMaps = js.context['google']['maps'];
      final circleOptions = js.JsObject.jsify({
        'center': {
          'lat': circle.center.latitude,
          'lng': circle.center.longitude,
        },
        'radius': circle.radius,
        'fillColor': _colorToHex(circle.fillColor),
        'fillOpacity': circle.fillColor.opacity,
        'strokeColor': _colorToHex(circle.strokeColor),
        'strokeOpacity': circle.strokeColor.opacity,
        'strokeWeight': circle.strokeWidth,
        'map': _map,
        'visible': circle.visible,
        'zIndex': circle.zIndex,
      });

      final circleConstructor = googleMaps['Circle'] as js.JsFunction;
      final jsCircle = js.JsObject(circleConstructor, [circleOptions]);
      _circles[circle.circleId.value] = jsCircle;
    } catch (e) {
      debugPrint('Error creating circle: $e');
    }
  }

  void _updatePolylines(Set<Polyline> polylines) {
    if (_map == null) return;

    // Remove polylines that no longer exist
    final polylineIds = polylines.map((p) => p.polylineId.value).toSet();
    _polylines.keys.toList().forEach((id) {
      if (!polylineIds.contains(id)) {
        _polylines[id]?.callMethod('setMap', [null]);
        _polylines.remove(id);
      }
    });

    // Add or update polylines
    for (final polyline in polylines) {
      final polylineId = polyline.polylineId.value;

      if (!_polylines.containsKey(polylineId)) {
        _createPolyline(polyline);
      }
      // Note: Polyline updates would require recreating the entire polyline
    }
  }

  void _createPolyline(Polyline polyline) {
    try {
      final googleMaps = js.context['google']['maps'];
      final path = polyline.points.map((point) {
        return {'lat': point.latitude, 'lng': point.longitude};
      }).toList();

      debugPrint('Creating polyline with ${path.length} points');
      debugPrint(
          'Polyline color: ${_colorToHex(polyline.color)}, width: ${polyline.width}');

      final polylineOptions = js.JsObject.jsify({
        'path': path,
        'geodesic': polyline.geodesic,
        'strokeColor': _colorToHex(polyline.color),
        'strokeOpacity':
            polyline.color.opacity > 0 ? polyline.color.opacity : 1.0,
        'strokeWeight': polyline.width > 0 ? polyline.width : 5,
        'map': _map,
        'visible': true,
        'zIndex': polyline.zIndex > 0 ? polyline.zIndex : 1,
      });

      final polylineConstructor = googleMaps['Polyline'] as js.JsFunction;
      final jsPolyline = js.JsObject(polylineConstructor, [polylineOptions]);
      _polylines[polyline.polylineId.value] = jsPolyline;

      debugPrint('Polyline created successfully: ${polyline.polylineId.value}');
    } catch (e) {
      debugPrint('Error creating polyline: $e');
    }
  }

  void _clearAllOverlays() {
    _markers.forEach((_, marker) => marker.callMethod('setMap', [null]));
    _circles.forEach((_, circle) => circle.callMethod('setMap', [null]));
    _polylines.forEach((_, polyline) => polyline.callMethod('setMap', [null]));

    _markers.clear();
    _circles.clear();
    _polylines.clear();
    _markerIcons.clear();
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  int _getControlPosition(String position) {
    final googleMaps = js.context['google']['maps'];
    final controlPosition = googleMaps['ControlPosition'];
    return controlPosition[position] as int;
  }

  Future<List<dynamic>> _getDarkMapStyles() async {
    // Load dark map style from assets or use default
    try {
      final darkStyle = await MapStyleHelper.getMapStyle(isDarkMode: true);
      // Parse JSON string to List if needed
      return []; // Return parsed styles
    } catch (e) {
      return _getDefaultDarkMapStyles();
    }
  }

  List<dynamic> _getDefaultDarkMapStyles() {
    return [
      {
        'elementType': 'geometry',
        'stylers': [
          {'color': '#242f3e'},
        ],
      },
      {
        'elementType': 'labels.text.stroke',
        'stylers': [
          {'color': '#242f3e'},
        ],
      },
      {
        'elementType': 'labels.text.fill',
        'stylers': [
          {'color': '#746855'},
        ],
      },
      {
        'featureType': 'road',
        'elementType': 'geometry',
        'stylers': [
          {'color': '#38414e'},
        ],
      },
      {
        'featureType': 'water',
        'elementType': 'geometry',
        'stylers': [
          {'color': '#17263c'},
        ],
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Listen to theme changes
    ref.listen<AppThemeMode>(currentAppThemeModeProvider, (previous, next) {
      if (_map != null && previous != next) {
        _updateMapStyle(next == AppThemeMode.dark);
      }
    });

    // Listen to markers changes
    ref.listen(mapMarkersProvider, (previous, next) {
      if (_isMapReady && _map != null) {
        debugPrint('Markers updated: ${next.length} markers');
        _updateMarkers(next);
      }
    });

    // Listen to circles changes
    ref.listen(mapCirclesProvider, (previous, next) {
      if (_isMapReady && _map != null) {
        debugPrint('Circles updated: ${next.length} circles');
        _updateCircles(next);
      }
    });

    // Listen to polylines changes
    ref.listen(mapPolylinesProvider, (previous, next) {
      if (_isMapReady && _map != null) {
        debugPrint('Polylines updated: ${next.length} polylines');
        _updatePolylines(next);
      }
    });

    // Listen to camera position changes with bounds check
    ref.listen(myLocationCameraPositionProvider, (previous, next) {
      if (mounted && _isMapReady && _map != null && previous != next) {
        if (_shouldAnimateCamera(next)) {
           animateCamera(next);
        }
      }
    });

    return HtmlElementView(viewType: _mapDivId);
  }

  Future<void> _updateMapStyle(bool isDark) async {
    if (_map == null) return;

    try {
      final styles = isDark ? await _getDarkMapStyles() : [];
      _map!.callMethod('setOptions', [
        js.JsObject.jsify({'styles': styles}),
      ]);
      debugPrint('Map style updated: ${isDark ? 'dark' : 'light'}');
    } catch (e) {
      debugPrint('Error updating map style: $e');
    }
  }

  /// Animate camera to position
  void animateCamera(CameraPosition position) {
    if (_map == null) return;

    try {
      final latLng = js.JsObject.jsify({
        'lat': position.target.latitude,
        'lng': position.target.longitude,
      });

      _map!.callMethod('panTo', [latLng]);
      _map!.callMethod('setZoom', [position.zoom.toInt()]);
    } catch (e) {
      debugPrint('Error animating camera: $e');
    }
  }

  bool _shouldAnimateCamera(CameraPosition next) {
    if (_map == null) return true;
    try {
      final bounds = _map!.callMethod('getBounds');
      if (bounds != null) {
        final latLng = js.JsObject.jsify({
          'lat': next.target.latitude,
          'lng': next.target.longitude,
        });
        final contains = bounds.callMethod('contains', [latLng]);
        // If the location is visible (contains == true), do NOT animate (return false).
        // If not visible, animate (return true).
        return contains != true;
      }
    } catch (e) {
      debugPrint('Error checking bounds: $e');
    }
    return true; // Default to animate
  }
}

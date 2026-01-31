import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/presentation/utils/fp_framework.dart';
import '../../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../home/presentation/providers/location_stream_provider.dart';
import '../../helpers/map_style_helper.dart';
import 'my_location_camera_position_provider.dart';

part 'my_location_marker_provider.g.dart';

/// Cached icon bytes to prevent regeneration
Uint8List? _cachedIconBytes;

@riverpod
class MyLocationMarker extends _$MyLocationMarker {
  double _lastRotation = 0;

  @override
  Option<Marker> build() {
    final markerIconAsync = ref.watch(myLocationMarkerIconProvider);
    final markerIcon = markerIconAsync.valueOrNull;

    final locationState = ref.watch(locationStreamProvider);
    final currentLocation = locationState.valueOrNull;

    if (currentLocation == null) return const None();

    // Fix Rotation: Allow updates at lower speeds (0.5 m/s)
    // The LocationStreamProvider now calculates heading for us if missing.
    final double currentSpeed = currentLocation.speed;
    if (currentSpeed > 0.5) {
      _lastRotation = currentLocation.heading;
      debugPrint('📍 UI MARKER: Rotation Updated To -> $_lastRotation');
    }

    // Use default marker while custom icon is loading
    final effectiveIcon = markerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);

    final myMarker = MapStyleHelper.getMyLocationMarker(
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
      rotation: _lastRotation, 
      markerIcon: effectiveIcon,
    );
    
    return Some<Marker>(myMarker);
  }
}

@riverpod
Future<BitmapDescriptor> myLocationMarkerIcon(Ref ref) async {
  // Keep alive to prevent regeneration
  ref.keepAlive();
  
  try {
    // Use cached bytes if available (prevents flickering)
    if (_cachedIconBytes != null) {
      return BitmapDescriptor.fromBytes(_cachedIconBytes!);
    }
    
    // Load the motorcycle with driver image
    final bytes = await _loadAndResizeAsset(
      'assets/icons/moto_driver.png', 
      75, // Optimized size for performance and look
    );
    
    // Cache the bytes
    _cachedIconBytes = bytes;
    
    return BitmapDescriptor.fromBytes(bytes);
  } catch (e) {
    debugPrint('❌ Error loading motorcycle icon: $e');
    // Fallback to default marker
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  }
}

/// Load an asset image and resize it for optimal map marker display
Future<Uint8List> _loadAndResizeAsset(String assetPath, int targetWidth) async {
  // Load the asset
  final ByteData data = await rootBundle.load(assetPath);
  final Uint8List originalBytes = data.buffer.asUint8List();
  
  // Decode and resize
  final ui.Codec codec = await ui.instantiateImageCodec(
    originalBytes,
    targetWidth: targetWidth,
  );
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  
  // Convert to PNG bytes (preserves transparency)
  final ByteData? pngData = await frameInfo.image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  
  return pngData!.buffer.asUint8List();
}
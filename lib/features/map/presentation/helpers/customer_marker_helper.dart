import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// SVG-based customer delivery marker for reliable web rendering.
///
/// Uses inline SVG (like [StoreMarkerHelper]) instead of Canvas,
/// which fails silently on Flutter Web.
class CustomerMarkerHelper {
  CustomerMarkerHelper._();

  static BitmapDescriptor? _cachedIcon;

  /// Creates a custom customer delivery marker icon.
  static Future<BitmapDescriptor> createCustomerMarkerIcon() async {
    if (_cachedIcon != null) return _cachedIcon!;

    try {
      final svg = _buildCustomerSvg();
      final bytes = Uint8List.fromList(utf8.encode(svg));
      final descriptor = BitmapDescriptor.bytes(bytes);
      _cachedIcon = descriptor;
      return descriptor;
    } catch (e) {
      debugPrint('📍 CustomerMarkerHelper: SVG failed ($e), using fallback');
      final fallback =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      _cachedIcon = fallback;
      return fallback;
    }
  }

  /// Clears the marker cache.
  static void clearCache() => _cachedIcon = null;

  /// Builds an SVG string for the customer delivery marker.
  /// Red teardrop pin with a house/home icon inside.
  static String _buildCustomerSvg() {
    const primary = '#C62828';
    const secondary = '#EF5350';
    const lightAccent = '#FFCDD2';

    return '<svg xmlns="http://www.w3.org/2000/svg" '
        'width="48" height="62" viewBox="0 0 48 62">'
        '<defs>'
        '<linearGradient id="pg" x1="0" y1="0" x2="0" y2="1">'
        '<stop offset="0%" stop-color="$secondary"/>'
        '<stop offset="100%" stop-color="$primary"/>'
        '</linearGradient>'
        '</defs>'
        // Drop shadow
        '<ellipse cx="24" cy="59" rx="8" ry="2.5" fill="black" opacity="0.15"/>'
        // Teardrop pin
        '<path d="M24 58 C19 46 3 36 3 21 '
        'A21 21 0 1 1 45 21 C45 36 29 46 24 58 Z" '
        'fill="url(#pg)"/>'
        '<path d="M24 58 C19 46 3 36 3 21 '
        'A21 21 0 1 1 45 21 C45 36 29 46 24 58 Z" '
        'fill="none" stroke="$primary" stroke-width="0.5" opacity="0.4"/>'
        // White inner circle
        '<circle cx="24" cy="21" r="15" fill="white"/>'
        '<circle cx="24" cy="21" r="15" fill="none" '
        'stroke="$primary" stroke-width="0.3" opacity="0.15"/>'
        // House icon — roof
        '<path d="M24 11 L13 20 L35 20 Z" fill="$primary"/>'
        // House icon — body
        '<rect x="15" y="20" width="18" height="10" fill="$secondary"/>'
        // Door
        '<rect x="21" y="23" width="6" height="7" rx="0.5" fill="$lightAccent"/>'
        // Window
        '<rect x="16.5" y="22" width="4" height="3.5" rx="0.5" fill="$lightAccent"/>'
        '<rect x="27.5" y="22" width="4" height="3.5" rx="0.5" fill="$lightAccent"/>'
        '</svg>';
  }
}

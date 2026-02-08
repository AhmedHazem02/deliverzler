import 'dart:convert';
import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Helper class to create custom store markers using **inline SVG**.
///
/// Canvas-based `picture.toImage()` fails silently on Flutter Web,
/// so we build SVG strings → UTF-8 bytes → [BitmapDescriptor.bytes].
/// The web component detects the SVG MIME type and creates a proper
/// `data:image/svg+xml;base64,…` data-URI that Google Maps JS API
/// renders natively in the browser.
class StoreMarkerHelper {
  StoreMarkerHelper._();

  static final Map<String, BitmapDescriptor> _cache = {};

  /// Creates a custom store marker icon.
  ///
  /// - [index]: Optional 1-based number for multi-store orders.
  /// - [isPickedUp]: If true, marker turns green (completed).
  /// - [isCurrentStop]: If true, marker has a glow ring.
  static Future<BitmapDescriptor> createStoreMarkerIcon({
    int? index,
    bool isPickedUp = false,
    bool isCurrentStop = false,
  }) async {
    final cacheKey = 'store_svg_${index ?? "s"}_${isPickedUp}_$isCurrentStop';
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey]!;

    try {
      final svg = _buildStoreSvg(
        index: index,
        isPickedUp: isPickedUp,
        isCurrentStop: isCurrentStop,
      );
      final bytes = Uint8List.fromList(utf8.encode(svg));
      final descriptor = BitmapDescriptor.bytes(bytes);
      _cache[cacheKey] = descriptor;
      return descriptor;
    } catch (e) {
      print('🏪 StoreMarkerHelper: SVG failed ($e), using fallback');
      final fallback = _getFallbackIcon(
        isPickedUp: isPickedUp,
        isCurrentStop: isCurrentStop,
      );
      _cache[cacheKey] = fallback;
      return fallback;
    }
  }

  static BitmapDescriptor _getFallbackIcon({
    bool isPickedUp = false,
    bool isCurrentStop = false,
  }) {
    if (isPickedUp) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    } else if (isCurrentStop) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    }
  }

  /// Clears the marker cache.
  static void clearCache() => _cache.clear();

  // ─────────────────────────────────────────────────────────────
  //  SVG builder
  // ─────────────────────────────────────────────────────────────

  static String _buildStoreSvg({
    int? index,
    bool isPickedUp = false,
    bool isCurrentStop = false,
  }) {
    // ── Colour theme ──
    String primary, secondary, lightAccent;
    if (isPickedUp) {
      primary = '#2E7D32';
      secondary = '#43A047';
      lightAccent = '#A5D6A7';
    } else if (isCurrentStop) {
      primary = '#E65100';
      secondary = '#F57C00';
      lightAccent = '#FFE0B2';
    } else {
      primary = '#6A1B9A';
      secondary = '#8E24AA';
      lightAccent = '#CE93D8';
    }

    final hasIndex = index != null;
    // Extra width for the number badge circle
    final totalW = hasIndex ? 64 : 52;

    final sb = StringBuffer()
      ..write('<svg xmlns="http://www.w3.org/2000/svg" '
          'width="$totalW" height="66" viewBox="0 0 $totalW 66">');

    // ── Defs ──
    sb.write('<defs>'
        '<linearGradient id="pg" x1="0" y1="0" x2="0" y2="1">'
        '<stop offset="0%" stop-color="$secondary"/>'
        '<stop offset="100%" stop-color="$primary"/>'
        '</linearGradient>'
        '</defs>');

    // ── Glow rings (current stop) ──
    if (isCurrentStop) {
      sb.write('<circle cx="26" cy="23" r="32" fill="none" '
          'stroke="$lightAccent" stroke-width="3" opacity="0.3"/>');
      sb.write('<circle cx="26" cy="23" r="28" fill="none" '
          'stroke="$lightAccent" stroke-width="2" opacity="0.5"/>');
    }

    // ── Drop shadow ──
    sb.write('<ellipse cx="26" cy="63" rx="9" ry="2.5" '
        'fill="black" opacity="0.15"/>');

    // ── Teardrop pin body ──
    sb.write('<path d="M26 62 C21 48 4 38 4 23 '
        'A22 22 0 1 1 48 23 C48 38 31 48 26 62 Z" '
        'fill="url(#pg)"/>');
    sb.write('<path d="M26 62 C21 48 4 38 4 23 '
        'A22 22 0 1 1 48 23 C48 38 31 48 26 62 Z" '
        'fill="none" stroke="$primary" stroke-width="0.5" opacity="0.4"/>');

    // ── White inner circle ──
    sb.write('<circle cx="26" cy="23" r="17" fill="white"/>');
    sb.write('<circle cx="26" cy="23" r="17" fill="none" '
        'stroke="$primary" stroke-width="0.3" opacity="0.15"/>');

    // ── Storefront icon (inside white circle) ──
    _appendStoreIcon(sb, primary, secondary, lightAccent);

    // ── Number badge (top-right, multi-store) ──
    if (hasIndex) {
      final badgeColor = isPickedUp ? '#2E7D32' : secondary;
      sb.write('<circle cx="50" cy="12" r="11" '
          'fill="$badgeColor" stroke="white" stroke-width="2"/>');
      sb.write('<text x="50" y="16.5" text-anchor="middle" '
          'font-family="Arial,Helvetica,sans-serif" font-size="14" '
          'font-weight="bold" fill="white">$index</text>');
    }

    // ── Picked-up checkmark (single-store only) ──
    if (isPickedUp && !hasIndex) {
      sb.write('<circle cx="42" cy="8" r="9" '
          'fill="#2E7D32" stroke="white" stroke-width="2"/>');
      sb.write('<path d="M37 8 L40 11 L47 4" '
          'fill="none" stroke="white" stroke-width="2.5" '
          'stroke-linecap="round" stroke-linejoin="round"/>');
    }

    sb.write('</svg>');
    return sb.toString();
  }

  /// Appends storefront icon SVG elements.
  /// Centered at (26, 23) within the r=17 white circle.
  static void _appendStoreIcon(
    StringBuffer sb,
    String primary,
    String secondary,
    String lightAccent,
  ) {
    // ── Awning (colourful canopy — the distinctive store element) ──
    sb.write('<rect x="13" y="15" width="26" height="4" '
        'rx="1" fill="$secondary"/>');

    // ── Scalloped awning edge (3 waves) ──
    sb.write('<path d="M13 19 '
        'Q17.3 24 21.7 19 '
        'Q26 24 30.3 19 '
        'Q34.7 24 39 19" '
        'fill="none" stroke="$primary" stroke-width="1.3" '
        'stroke-linecap="round"/>');

    // ── Building body ──
    sb.write('<rect x="14" y="19" width="24" height="12" '
        'rx="0.5" fill="none" stroke="$primary" stroke-width="1.2"/>');

    // ── Door ──
    sb.write('<rect x="23" y="24" width="6" height="7" '
        'rx="0.8" fill="$primary"/>');
    sb.write('<circle cx="27.5" cy="27.5" r="0.7" fill="white"/>');

    // ── Left window ──
    sb.write('<rect x="15.5" y="21.5" width="5.5" height="4.5" '
        'rx="0.7" fill="$lightAccent"/>');
    sb.write('<line x1="18.25" y1="21.5" x2="18.25" y2="26" '
        'stroke="$primary" stroke-width="0.4" opacity="0.3"/>');

    // ── Right window ──
    sb.write('<rect x="31" y="21.5" width="5.5" height="4.5" '
        'rx="0.7" fill="$lightAccent"/>');
    sb.write('<line x1="33.75" y1="21.5" x2="33.75" y2="26" '
        'stroke="$primary" stroke-width="0.4" opacity="0.3"/>');
  }
}

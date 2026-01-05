import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'google_map_component.dart';
import 'google_map_web_component.dart';

/// Platform-aware map component that switches between native and web implementations
/// Uses JavaScript API directly on web to avoid platform detection issues
class PlatformAwareMapComponent extends StatelessWidget {
  const PlatformAwareMapComponent({super.key});

  @override
  Widget build(BuildContext context) {
    // Use web-specific component on web platform
    // google_maps_flutter has issues detecting web on Windows
    if (kIsWeb) {
      return const GoogleMapWebComponent();
    }
    // Use native google_maps_flutter on mobile platforms
    return const GoogleMapComponent();
  }
}

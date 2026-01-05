import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'enhanced_google_map_web_component.dart';
import 'google_map_component.dart';

/// Platform-aware map component with full feature support on all platforms
/// Uses enhanced web implementation with high performance
class PlatformAwareMapComponent extends StatelessWidget {
  const PlatformAwareMapComponent({super.key});

  @override
  Widget build(BuildContext context) {
    // Use enhanced web component on web platform with full features
    if (kIsWeb) {
      return const EnhancedGoogleMapWebComponent();
    }
    // Use native google_maps_flutter on mobile platforms
    return const GoogleMapComponent();
  }
}

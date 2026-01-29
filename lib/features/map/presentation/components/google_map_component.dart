import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/core_features/theme/presentation/providers/current_app_theme_provider.dart';
import '../../../../core/core_features/theme/presentation/utils/app_theme.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../helpers/map_style_helper.dart';
import '../providers/map_controller_provider.dart';
import '../providers/map_overlays_providers/map_circles_providers.dart';
import '../providers/map_overlays_providers/map_markers_providers.dart';
import '../providers/map_overlays_providers/map_polylines_provider.dart';
import '../providers/my_location_providers/my_location_camera_position_provider.dart';
import '../providers/optimized_map_loading_provider.dart';

class GoogleMapComponent extends StatefulHookConsumerWidget {
  const GoogleMapComponent({super.key});

  @override
  ConsumerState<GoogleMapComponent> createState() => _GoogleMapComponentState();
}

class _GoogleMapComponentState extends ConsumerState<GoogleMapComponent> {
  late final sub =
      ref.listenManual(myLocationCameraPositionProvider, (prev, next) {});

  @override
  Widget build(BuildContext context) {
    final mapLoading = ref.watch(optimizedMapLoadingProvider);
    final mapLoadingNotifier = ref.watch(optimizedMapLoadingProvider.notifier);

    ref.listen<GoogleMapController?>(
      mapControllerProvider,
      (previous, next) {},
    );

    return GoogleMap(
      initialCameraPosition: sub.read(),
      // تحميل الـ Overlays فقط عند الحاجة (lazy loading)
      markers: mapLoading.isOverlaysLoaded ? ref.watch(mapMarkersProvider) : {},
      circles: mapLoading.isOverlaysLoaded ? ref.watch(mapCirclesProvider) : {},
      polylines:
          mapLoading.isOverlaysLoaded ? ref.watch(mapPolylinesProvider) : {},
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (controller) async {
        // إشارة بأن الـ Map جاهزة
        mapLoadingNotifier.setMapReady(true);

        ref
            .read(currentMapControllerProvider.notifier)
            .update((_) => controller);

        // تطبيق نمط الـ Map بشكل غير متزامن
        Future.microtask(() async {
          final isDark =
              ref.read(currentAppThemeModeProvider) == AppThemeMode.dark;
          final mapStyle = await MapStyleHelper.getMapStyle(isDarkMode: isDark);
          await controller.setMapStyle(mapStyle);
        });
      },
    );
  }
}

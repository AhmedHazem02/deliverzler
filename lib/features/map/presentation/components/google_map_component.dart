import 'dart:async';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/core_features/theme/presentation/providers/current_app_theme_provider.dart';
import '../../../../core/core_features/theme/presentation/utils/app_theme.dart';
import '../../../../core/presentation/utils/fp_framework.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../helpers/map_style_helper.dart';
import '../providers/map_controller_provider.dart';
import '../providers/place_details_provider.dart';
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

class _GoogleMapComponentState extends ConsumerState<GoogleMapComponent>
    with SingleTickerProviderStateMixin {
  late final sub =
      ref.listenManual(myLocationCameraPositionProvider, (prev, next) {
    // Update target when location changes
    _targetPosition = next.target;
    _startDamping(); // Restart animation when target changes
  });

  // Smooth Camera State
  late AnimationController _dampController;
  LatLng? _currentPosition;
  LatLng? _targetPosition;
  bool _isUserInteracting = false;
  bool _isAnimating = false;
  Timer? _resumeTimer;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _dampController = AnimationController(
      vsync: this,
      duration: const Duration(hours: 1),
    )..addListener(_onTick);
    // Don't start repeating immediately — only when target changes
  }

  @override
  void dispose() {
    _dampController.dispose();
    _resumeTimer?.cancel();
    sub.close();
    super.dispose();
  }

  /// Start damping animation only when needed
  void _startDamping() {
    if (!_isAnimating) {
      _isAnimating = true;
      _dampController.repeat();
    }
  }

  /// Stop damping animation when converged to save CPU
  void _stopDamping() {
    if (_isAnimating) {
      _isAnimating = false;
      _dampController.stop();
    }
  }

  void _onTick() {
    // 1. Check if we have a target place (Route Move) active
    final hasTarget = ref.read(currentPlaceDetailsProvider).isSome();

    // 2. If user interaction, map not ready, no position, OR showing route -> Skip Damping
    if (_isUserInteracting ||
        _mapController == null ||
        _targetPosition == null ||
        hasTarget) return;

    // Use current camera pos as start if not set
    _currentPosition ??= _targetPosition;

    // Damp Logic: current = current + (target - current) * dampFactor
    // Factor 0.05 provides the "Heavy/Elastic" feel
    final dampFactor = 0.05;
    final lat = _currentPosition!.latitude +
        (_targetPosition!.latitude - _currentPosition!.latitude) * dampFactor;
    final lng = _currentPosition!.longitude +
        (_targetPosition!.longitude - _currentPosition!.longitude) * dampFactor;

    // Check if we are close enough to stop updating (performance optimization)
    if ((lat - _targetPosition!.latitude).abs() < 0.000001 &&
        (lng - _targetPosition!.longitude).abs() < 0.000001) {
      _stopDamping(); // Stop the 60fps loop when converged
      return;
    }

    _currentPosition = LatLng(lat, lng);
    _mapController?.moveCamera(CameraUpdate.newLatLng(_currentPosition!));
  }

  void _onUserInteraction() {
    _isUserInteracting = true;
    _resumeTimer?.cancel();
    // Resume follow after 3 seconds of idleness
    _resumeTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isUserInteracting = false;
          // Reset current pos to where the user left it so we lerp from there
          // We can sync this by reading camera pos, but relying on visual continuity is usually fine.
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapLoading = ref.watch(optimizedMapLoadingProvider);
    final mapLoadingNotifier = ref.watch(optimizedMapLoadingProvider.notifier);

    ref.listen<GoogleMapController?>(
      mapControllerProvider,
      (previous, next) {},
    );

    return Listener(
      onPointerDown: (_) => _onUserInteraction(),
      child: GoogleMap(
        initialCameraPosition: sub.read(),
        // تحميل الـ Overlays فقط عند الحاجة (lazy loading)
        markers:
            mapLoading.isOverlaysLoaded ? ref.watch(mapMarkersProvider) : {},
        circles:
            mapLoading.isOverlaysLoaded ? ref.watch(mapCirclesProvider) : {},
        polylines:
            mapLoading.isOverlaysLoaded ? ref.watch(mapPolylinesProvider) : {},
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        onMapCreated: (controller) async {
          _mapController = controller;
          // إشارة بأن الـ Map جاهزة
          mapLoadingNotifier.setMapReady(true);

          ref
              .read(currentMapControllerProvider.notifier)
              .update((_) => controller);

          // تطبيق نمط الـ Map بشكل غير متزامن
          Future.microtask(() async {
            final isDark =
                ref.read(currentAppThemeModeProvider) == AppThemeMode.dark;
            final mapStyle =
                await MapStyleHelper.getMapStyle(isDarkMode: isDark);
            await controller.setMapStyle(mapStyle);
          });
        },
      ),
    );
  }
}

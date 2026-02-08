import 'package:geolocator/geolocator.dart';

import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../infrastructure/data_sources/map_remote_data_source.dart';
import '../helpers/map_style_helper.dart';

/// حالة تحميل الـ Map المحسّنة
class OptimizedMapLoadingState {
  final bool isMapReady;
  final bool isLocationLoaded;
  final bool isOverlaysLoaded;
  final Position? currentLocation;
  final String? mapStyle;

  const OptimizedMapLoadingState({
    this.isMapReady = false,
    this.isLocationLoaded = false,
    this.isOverlaysLoaded = false,
    this.currentLocation,
    this.mapStyle,
  });

  OptimizedMapLoadingState copyWith({
    bool? isMapReady,
    bool? isLocationLoaded,
    bool? isOverlaysLoaded,
    Position? currentLocation,
    String? mapStyle,
  }) {
    return OptimizedMapLoadingState(
      isMapReady: isMapReady ?? this.isMapReady,
      isLocationLoaded: isLocationLoaded ?? this.isLocationLoaded,
      isOverlaysLoaded: isOverlaysLoaded ?? this.isOverlaysLoaded,
      currentLocation: currentLocation ?? this.currentLocation,
      mapStyle: mapStyle ?? this.mapStyle,
    );
  }

  /// هل الـ Map جاهز للعرض
  bool get canShowMap => isLocationLoaded && isMapReady;

  /// هل يتم تحميل كل شيء
  bool get isFullyLoaded => isMapReady && isLocationLoaded && isOverlaysLoaded;
}

/// معالج حالة تحميل الـ Map
class OptimizedMapLoadingNotifier
    extends StateNotifier<OptimizedMapLoadingState> {
  OptimizedMapLoadingNotifier() : super(const OptimizedMapLoadingState());

  /// تحديث حالة الـ Map
  void setMapReady(bool isReady) {
    state = state.copyWith(isMapReady: isReady);
  }

  /// تحديث حالة الـ Location
  void setLocationLoaded(Position location) {
    state = state.copyWith(
      isLocationLoaded: true,
      currentLocation: location,
    );
  }

  /// تحديث حالة الـ Overlays
  void setOverlaysLoaded(bool isLoaded) {
    state = state.copyWith(isOverlaysLoaded: isLoaded);
  }

  /// تعيين نمط الـ Map
  Future<void> loadMapStyle(bool isDarkMode) async {
    try {
      final style = await MapStyleHelper.getMapStyle(isDarkMode: isDarkMode);
      state = state.copyWith(mapStyle: style);
    } catch (e) {
      // Map style loading failed — will use default
    }
  }

  /// إعادة تعيين الحالة
  void reset() {
    state = const OptimizedMapLoadingState();
  }
}

/// موفر تحميل الـ Map المحسّن
final optimizedMapLoadingProvider = StateNotifierProvider<
    OptimizedMapLoadingNotifier, OptimizedMapLoadingState>(
  (ref) => OptimizedMapLoadingNotifier(),
);

/// موفر تحميل الـ Overlays بشكل كسول (lazy loading)
final lazyLoadMapOverlaysProvider = FutureProvider<void>((ref) async {
  final mapLoading = ref.watch(optimizedMapLoadingProvider.notifier);

  try {
    // تأخير بسيط للسماح للـ Map بالظهور أولاً
    await Future.delayed(const Duration(milliseconds: 500));

    mapLoading.setOverlaysLoaded(true);
  } catch (e) {
    // Overlay loading failed
  }
});

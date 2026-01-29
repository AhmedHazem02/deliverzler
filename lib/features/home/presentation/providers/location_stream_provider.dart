import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/infrastructure/services/location_service.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../utils/location_error.dart';

part 'location_stream_provider.g.dart';

@riverpod
Stream<Position> locationStream(
  Ref ref,
) async* {
  final locationService = ref.watch(locationServiceProvider);

  // تحميل الصلاحيات بالتوازي (بدون انتظار متسلسل)
  try {
    // طلب الصلاحيات مع timeout قصير
    await Future.wait([
      ref
          .watch(enableLocationProvider(locationService).future)
          .timeout(const Duration(seconds: 5), onTimeout: () async => null),
      ref
          .watch(requestLocationPermissionProvider(locationService).future)
          .timeout(const Duration(seconds: 5), onTimeout: () async => null),
    ], eagerError: false);
  } catch (e) {
    debugPrint('⚠️ warning في طلب الصلاحيات: $e');
    // متابعة حتى لو فشلت الصلاحيات
  }

  // الحصول على الـ location stream بدون تأخير
  yield* locationService
      .getLocationStream(
        intervalSeconds: AppLocationSettings.locationChangeInterval,
      )
      .throttleTime(const Duration(seconds: 3))
      .handleError(
    (Object err, StackTrace st) {
      if (kIsWeb) {
        print('⚠️ Web location error: $err');
      }
      Error.throwWithStackTrace(LocationError.getLocationTimeout, st);
    },
  );
}

@riverpod
Future<void> enableLocation(
  Ref ref,
  LocationService locationService,
) async {
  final enabled = await locationService.enableLocationService();
  if (!enabled) {
    Error.throwWithStackTrace(
      LocationError.notEnabledLocation,
      StackTrace.current,
    );
  }
}

@riverpod
Future<void> requestLocationPermission(
  Ref ref,
  LocationService locationService,
) async {
  final whileInUseGranted = await locationService.requestWhileInUsePermission();
  if (!whileInUseGranted) {
    Error.throwWithStackTrace(
      LocationError.notGrantedLocationPermission,
      StackTrace.current,
    );
  }

  // Request always permission on mobile (not Web)
  if (!kIsWeb) {
    final alwaysGranted = await locationService.requestAlwaysPermission();
    if (!alwaysGranted) {
      Error.throwWithStackTrace(
        LocationError.notGrantedLocationPermission,
        StackTrace.current,
      );
    }
  }
}

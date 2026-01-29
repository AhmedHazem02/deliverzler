import 'package:cloud_firestore/cloud_firestore.dart';

/// التحقق من صحة GeoPoint
class GeoPointValidator {
  /// التحقق من صحة الإحداثيات
  static bool isValidGeoPoint(GeoPoint? geoPoint) {
    if (geoPoint == null) return false;

    const minLat = -90.0;
    const maxLat = 90.0;
    const minLng = -180.0;
    const maxLng = 180.0;

    final isValidLatitude = geoPoint.latitude >= minLat &&
        geoPoint.latitude <= maxLat &&
        geoPoint.latitude.isFinite;

    final isValidLongitude = geoPoint.longitude >= minLng &&
        geoPoint.longitude <= maxLng &&
        geoPoint.longitude.isFinite;

    return isValidLatitude && isValidLongitude;
  }

  /// إنشاء GeoPoint آمن
  static GeoPoint? createSafeGeoPoint(double? latitude, double? longitude) {
    if (latitude == null || longitude == null) return null;

    try {
      final geoPoint = GeoPoint(latitude, longitude);
      return isValidGeoPoint(geoPoint) ? geoPoint : null;
    } catch (e) {
      return null;
    }
  }

  /// الحصول على رسالة خطأ للإحداثيات غير الصحيحة
  static String? getValidationError(GeoPoint? geoPoint) {
    if (geoPoint == null) {
      return 'الموقع غير متوفر';
    }

    if (geoPoint.latitude < -90 || geoPoint.latitude > 90) {
      return 'خط العرض غير صحيح';
    }

    if (geoPoint.longitude < -180 || geoPoint.longitude > 180) {
      return 'خط الطول غير صحيح';
    }

    if (!geoPoint.latitude.isFinite || !geoPoint.longitude.isFinite) {
      return 'إحداثيات غير صالحة';
    }

    return null;
  }
}

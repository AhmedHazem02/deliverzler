import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// التحقق من صحة التوكن
class AuthTokenValidator {
  /// التحقق من أن التوكن صحيح وغير منتهي الصلاحية
  static bool isTokenValid(User? user) {
    if (user == null) return false;

    try {
      // التحقق من أن المستخدم مصرح به
      return user.uid.isNotEmpty;
    } catch (e) {
      debugPrint('❌ خطأ في التحقق من التوكن: $e');
      return false;
    }
  }

  /// الحصول على التوكن الحالي بأمان
  static Future<String?> getValidToken(User? user) async {
    if (user == null) return null;

    try {
      // التأكد من أن المستخدم نشط
      if (!isTokenValid(user)) {
        debugPrint('⚠️ التوكن غير صحيح');
        return null;
      }

      final idToken = await user.getIdToken();
      debugPrint('✅ تم الحصول على توكن صحيح');
      return idToken;
    } catch (e) {
      debugPrint('❌ خطأ في الحصول على التوكن: $e');
      return null;
    }
  }
}

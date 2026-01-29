import 'dart:async';
import 'platform_exceptions.dart';
import 'package:firebase_core/firebase_core.dart';

/// استراتيجية إعادة محاولة خاصة بالشبكة
class NetworkRetryStrategy {
  /// هل يجب إعادة المحاولة للخطأ المعطى
  static bool shouldRetry(Exception exception) {
    // Firebase errors
    if (exception is FirebaseException) {
      switch (exception.code) {
        // errors يجب إعادة المحاولة لها
        case 'DEADLINE_EXCEEDED':
        case 'INTERNAL':
        case 'RESOURCE_EXHAUSTED':
        case 'UNAVAILABLE':
        case 'UNAUTHENTICATED':
          return true;

        // errors لا يجب إعادة محاولة لها
        case 'PERMISSION_DENIED':
        case 'NOT_FOUND':
        case 'INVALID_ARGUMENT':
          return false;

        default:
          return false;
      }
    }

    // Timeout errors
    if (exception is SocketException || exception is TimeoutException) {
      return true;
    }

    return false;
  }

  /// عدد محاولات آمن للشبكة
  static const int safeRetryCount = 3;

  /// تأخير آمن بين المحاولات
  static const Duration safeInitialDelay = Duration(milliseconds: 100);
}

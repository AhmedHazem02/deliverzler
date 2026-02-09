import 'package:flutter/foundation.dart';

/// استراتيجية إعادة المحاولة مع exponential backoff
class RetryUtility {
  /// تنفيذ عملية مع إعادة محاولة ذكية
  static Future<T> retry<T>({
    required Future<T> Function() operation,
    int maxRetries = 3,
    Duration initialDelay = const Duration(milliseconds: 100),
    Duration maxDelay = const Duration(seconds: 10),
    double backoffMultiplier = 2.0,
    bool Function(Exception)? retryIf,
  }) async {
    assert(maxRetries > 0, 'maxRetries must be > 0');
    assert(backoffMultiplier >= 1, 'backoffMultiplier must be >= 1');

    var delay = initialDelay;
    late Exception lastException;

    for (var attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        return await operation();
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());

        if (attempt == maxRetries) {
          debugPrint('❌ فشلت بعد ${attempt + 1} محاولات');
          rethrow;
        }

        if (retryIf != null && !retryIf(lastException)) {
          debugPrint('⏹️ إيقاف إعادة المحاولة');
          rethrow;
        }

        debugPrint('⏳ انتظار ${delay.inMilliseconds}ms...');
        await Future<void>.delayed(delay);

        delay = Duration(
          milliseconds: (delay.inMilliseconds * backoffMultiplier).ceil(),
        );

        if (delay > maxDelay) {
          delay = maxDelay;
        }
      }
    }

    throw lastException;
  }
}

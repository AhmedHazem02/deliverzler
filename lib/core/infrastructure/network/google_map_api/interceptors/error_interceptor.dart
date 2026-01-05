// ignore_for_file: avoid_dynamic_calls

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

@visibleForTesting
class RejectError implements Exception {}

class ErrorInterceptor extends Interceptor {
  //This is needed if your api use statusCode 200 for business errors.
  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    print('📥 ErrorInterceptor.onResponse: ${response.statusCode}');
    print('📥 Response data: ${response.data}');
    final data = response.data as Map<dynamic, dynamic>;

    if (data['status'] != 'OK') {
      print('📥 ❌ API status not OK: ${data['status']}');
      print('📥 Error message: ${data['error_message']}');
      final error = DioError(
        response: response,
        requestOptions: response.requestOptions,
        error: RejectError(),
      );
      return handler.reject(error, true);
    }

    print('📥 ✅ API status OK');
    return handler.next(response);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    print('📥 ❌ ErrorInterceptor.onError: ${err.message}');
    print('📥 ❌ Error type: ${err.type}');
    print('📥 ❌ Response: ${err.response?.data}');
    if (err.response?.statusCode == 400 || err.error is RejectError) {
      final response = err.response!;
      final data = response.data as Map<dynamic, dynamic>;
      final error = data['error_message'] ?? data['status'];
      final newErr = err.copyWith(
        response: Response(
          statusCode: 400,
          data: data,
          requestOptions: response.requestOptions,
          statusMessage: response.statusMessage,
          isRedirect: response.isRedirect,
          redirects: response.redirects,
          extra: response.extra,
          headers: response.headers,
        ),
        error: error,
        type: DioErrorType.badResponse,
      );
      return handler.reject(newErr);
    }

    return handler.next(err);
  }
}

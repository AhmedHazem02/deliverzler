import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../google_map_api_config.dart';

class ApiKeyInterceptor extends QueuedInterceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final apiKey = GoogleMapApiConfig.googleMapAPIKey;
    debugPrint('🔑 ApiKeyInterceptor: Adding API key to request');
    debugPrint(
      '🔑 API Key: ${apiKey.substring(0, 10)}...${apiKey.substring(apiKey.length - 4)}',
    );
    debugPrint('🔑 Full URL: ${options.uri}');
    options.queryParameters[GoogleMapApiConfig.googleMapAPIParamKey] = apiKey;
    debugPrint('🔑 Final URL with key: ${options.uri}');
    return handler.next(options);
  }
}

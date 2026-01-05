import 'package:dio/dio.dart';

import '../google_map_api_config.dart';

class ApiKeyInterceptor extends QueuedInterceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final apiKey = GoogleMapApiConfig.googleMapAPIKey;
    print('🔑 ApiKeyInterceptor: Adding API key to request');
    print(
        '🔑 API Key: ${apiKey.substring(0, 10)}...${apiKey.substring(apiKey.length - 4)}');
    print('🔑 Full URL: ${options.uri}');
    options.queryParameters[GoogleMapApiConfig.googleMapAPIParamKey] = apiKey;
    print('🔑 Final URL with key: ${options.uri}');
    return handler.next(options);
  }
}

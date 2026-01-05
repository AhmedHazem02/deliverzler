import 'package:dio/dio.dart';

import '../../../../core/infrastructure/network/google_map_api/api_callers/google_map_api_facade.dart';
import '../../../../core/infrastructure/network/google_map_api/google_map_api_config.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../dtos/place_autocomplete_dto.dart';
import '../dtos/place_details_dto.dart';
import '../dtos/place_directions_dto.dart';

part 'map_remote_data_source.g.dart';

@Riverpod(keepAlive: true)
MapRemoteDataSource mapRemoteDataSource(MapRemoteDataSourceRef ref) {
  return MapRemoteDataSource(
    ref,
    googleMapApi: ref.watch(googleMapApiFacadeProvider),
  );
}

class MapRemoteDataSource {
  MapRemoteDataSource(
    this.ref, {
    required this.googleMapApi,
  });

  final Ref ref;
  final GoogleMapApiFacade googleMapApi;

  static const String googleMapAutoCompletePath = '/place/autocomplete/json';
  static const String googleMapPlaceDetailsPath = '/place/details/json';
  static const String googleMapDirectionsPath = '/directions/json';

  Future<List<PlaceAutocompleteDto>> getPlaceAutocomplete(
    String placeName, {
    required CancelToken? cancelToken,
  }) async {
    final response = await googleMapApi.getData<Map<String, dynamic>>(
      path: googleMapAutoCompletePath,
      queryParameters: {
        'types': '(cities)',
        //Add countries you desire for search suggestions.
        'components': 'country:eg',
        'input': placeName,
      },
      options: Options(
        extra: {GoogleMapApiConfig.withSessionTokenExtraKey: true},
      ),
      cancelToken: cancelToken,
    );
    return PlaceAutocompleteDto.parseListOfMap(
        response.data!['predictions'] as List<dynamic>);
  }

  Future<PlaceDetailsDto> getPlaceDetails(
    String placeId, {
    required CancelToken? cancelToken,
  }) async {
    final response = await googleMapApi.getData<Map<String, dynamic>>(
      path: googleMapPlaceDetailsPath,
      queryParameters: {
        'fields': 'geometry', //Specify wanted fields to lower billing rate
        'place_id': placeId,
      },
      options: Options(
        extra: {GoogleMapApiConfig.withSessionTokenExtraKey: true},
      ),
      cancelToken: cancelToken,
    );
    return PlaceDetailsDto.fromJson(
        response.data!['result'] as Map<String, dynamic>);
  }

  Future<PlaceDirectionsDto> getPlaceDirections(
    PlaceDirectionsQueryDto query, {
    required CancelToken? cancelToken,
  }) async {
    print('🌐 MapRemoteDataSource.getPlaceDirections called');
    print('🌐 Query params: ${query.toJson()}');
    try {
      final response = await googleMapApi.getData<Map<String, dynamic>>(
        path: googleMapDirectionsPath,
        queryParameters: query.toJson(),
        cancelToken: cancelToken,
      );
      print('🌐 API Response status: ${response.statusCode}');
      print('🌐 API Response data keys: ${response.data?.keys}');
      print(
          '🌐 Routes count: ${(response.data?['routes'] as List?)?.length ?? 0}');
      if ((response.data?['routes'] as List?)?.isEmpty ?? true) {
        print('🌐 ❌ No routes in response! Full response: ${response.data}');
      }
      // ignore: avoid_dynamic_calls
      return PlaceDirectionsDto.fromJson(
          response.data!['routes'][0] as Map<String, dynamic>);
    } catch (e, stack) {
      print('🌐 ❌ API Error: $e');
      print('🌐 Stack: $stack');
      rethrow;
    }
  }
}

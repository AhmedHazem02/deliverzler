import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/place_autocomplete.dart';
import '../../domain/place_details.dart';
import '../../domain/place_directions.dart';
import '../data_sources/map_remote_data_source.dart';
import '../data_sources/map_directions_web_service.dart';
import '../dtos/place_directions_dto.dart';

part 'map_repo.g.dart';

@Riverpod(keepAlive: true)
MapRepo mapRepo(MapRepoRef ref) {
  return MapRepo(
    remoteDataSource: ref.watch(mapRemoteDataSourceProvider),
  );
}

class MapRepo {
  MapRepo({
    required this.remoteDataSource,
  });

  final MapRemoteDataSource remoteDataSource;
  final MapDirectionsWebService _webDirectionsService =
      MapDirectionsWebService();

  Future<List<PlaceAutocomplete>> getPlaceAutocomplete(
    String placeName, {
    CancelToken? cancelToken,
  }) async {
    final autocomplete = await remoteDataSource.getPlaceAutocomplete(placeName,
        cancelToken: cancelToken);
    return autocomplete.map((item) => item.toDomain()).toList();
  }

  Future<PlaceDetails> getPlaceDetails(
    String placeId, {
    CancelToken? cancelToken,
  }) async {
    final placeDetails = await remoteDataSource.getPlaceDetails(placeId,
        cancelToken: cancelToken);
    return placeDetails.toDomain();
  }

  Future<PlaceDirections> getPlaceDirections(
    PlaceDirectionsQuery query, {
    CancelToken? cancelToken,
  }) async {
    print('📍 MapRepo.getPlaceDirections called');
    print('📍 Origin: ${query.origin.latitude}, ${query.origin.longitude}');
    print(
        '📍 Destination: ${query.destination.latitude}, ${query.destination.longitude}');

    // Use JavaScript DirectionsService on web (REST API doesn't support CORS)
    if (kIsWeb) {
      print('📍 Using Web DirectionsService (JavaScript API)');
      try {
        final directions = await _webDirectionsService.getDirections(
          origin: LatLng(query.origin.latitude, query.origin.longitude),
          destination:
              LatLng(query.destination.latitude, query.destination.longitude),
        );
        print('📍 ✅ Directions received from Web DirectionsService');
        return directions;
      } catch (e, stack) {
        print('📍 ❌ Web DirectionsService error: $e');
        print('📍 Stack: $stack');
        rethrow;
      }
    }

    // Use REST API for mobile platforms
    print('📍 Using REST API for mobile');
    try {
      final dto = PlaceDirectionsQueryDto.fromDomain(query);
      print('📍 Calling remote data source...');
      final directions = await remoteDataSource.getPlaceDirections(dto,
          cancelToken: cancelToken);
      print('📍 ✅ Directions received from API');
      return directions.toDomain();
    } catch (e, stack) {
      print('📍 ❌ Error getting directions: $e');
      print('📍 Stack: $stack');
      rethrow;
    }
  }
}

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
MapRepo mapRepo(Ref ref) {
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
    debugPrint('📍 MapRepo.getPlaceDirections called');
    debugPrint(
        '📍 Origin: ${query.origin.latitude}, ${query.origin.longitude}');
    debugPrint(
        '📍 Destination: ${query.destination.latitude}, ${query.destination.longitude}');

    // Use JavaScript DirectionsService on web (REST API doesn't support CORS)
    if (kIsWeb) {
      debugPrint('📍 Using Web DirectionsService (JavaScript API)');
      try {
        final directions = await _webDirectionsService.getDirections(
          origin: LatLng(query.origin.latitude, query.origin.longitude),
          destination:
              LatLng(query.destination.latitude, query.destination.longitude),
        );
        debugPrint('📍 ✅ Directions received from Web DirectionsService');
        return directions;
      } catch (e, stack) {
        debugPrint('📍 ❌ Web DirectionsService error: $e');
        debugPrint('📍 Stack: $stack');
        rethrow;
      }
    }

    // Use REST API for mobile platforms
    debugPrint('📍 Using REST API for mobile');
    try {
      final dto = PlaceDirectionsQueryDto.fromDomain(query);
      debugPrint('📍 Calling remote data source...');
      final directions = await remoteDataSource.getPlaceDirections(dto,
          cancelToken: cancelToken);
      debugPrint('📍 ✅ Directions received from API');
      return directions.toDomain();
    } catch (e, stack) {
      debugPrint('📍 ❌ Error getting directions: $e');
      debugPrint('📍 Stack: $stack');
      rethrow;
    }
  }
}


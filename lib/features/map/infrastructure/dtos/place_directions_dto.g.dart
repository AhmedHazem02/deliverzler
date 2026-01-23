// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_directions_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceDirectionsDtoImpl _$$PlaceDirectionsDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PlaceDirectionsDtoImpl(
      bounds: _fromJsonBounds(json['bounds'] as Map<String, dynamic>),
      polylinePoints: _fromJsonPolylinePoints(
          json['overview_polyline'] as Map<String, dynamic>),
      distance: (_readDistance(json, 'distance') as num).toInt(),
      duration: _readDuration(json, 'duration') as String,
    );

Map<String, dynamic> _$$PlaceDirectionsQueryDtoImplToJson(
        _$PlaceDirectionsQueryDtoImpl instance) =>
    <String, dynamic>{
      'origin': _toJsonOrigin(instance.origin),
      'destination': _toJsonDestination(instance.destination),
    };

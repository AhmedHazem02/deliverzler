// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoutePointImpl _$$RoutePointImplFromJson(Map<String, dynamic> json) =>
    _$RoutePointImpl(
      geoPoint:
          const GeoPointConverter().fromJson(json['geoPoint'] as GeoPoint),
      heading: (json['heading'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
      timestamp: (json['timestamp'] as num).toInt(),
      isMocked: json['isMocked'] as bool? ?? false,
    );

Map<String, dynamic> _$$RoutePointImplToJson(_$RoutePointImpl instance) =>
    <String, dynamic>{
      'geoPoint': const GeoPointConverter().toJson(instance.geoPoint),
      'heading': instance.heading,
      'speed': instance.speed,
      'accuracy': instance.accuracy,
      'timestamp': instance.timestamp,
      'isMocked': instance.isMocked,
    };

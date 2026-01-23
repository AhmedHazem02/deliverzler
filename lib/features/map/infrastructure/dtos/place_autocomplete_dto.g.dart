// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_autocomplete_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceAutocompleteDtoImpl _$$PlaceAutocompleteDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PlaceAutocompleteDtoImpl(
      placeId: json['place_id'] as String,
      description: json['description'] as String,
      mainText: _readMainText(json, 'mainText') as String,
      secondaryText: _readSecondaryText(json, 'secondaryText') as String,
    );

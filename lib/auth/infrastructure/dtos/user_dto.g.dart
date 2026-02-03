// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDtoImpl _$$UserDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserDtoImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      image: json['image'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
      lastActiveAt: _timestampFromJson(json['lastActiveAt']),
      rejectionsCounter: (json['rejectionsCounter'] as num?)?.toInt() ?? 0,
      currentOrdersCount: (json['currentOrdersCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserDtoImplToJson(_$UserDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'image': instance.image,
      'isOnline': instance.isOnline,
      'lastActiveAt': _timestampToJson(instance.lastActiveAt),
      'rejectionsCounter': instance.rejectionsCounter,
      'currentOrdersCount': instance.currentOrdersCount,
    };

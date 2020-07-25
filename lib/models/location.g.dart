// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location()
    ..city = json['city'] as String
    ..province = json['province'] as String
    ..detailAddress = json['detailAddress'] as String;
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'city': instance.city,
      'province': instance.province,
      'detailAddress': instance.detailAddress
    };

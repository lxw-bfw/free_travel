/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-03 11:01:09
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-03 11:05:18
 */ 
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    .._id = json['_id'] as String
    ..birthday = json['birthday'] as String
    ..nickname = json['nickname'] as String
    ..introduce = json['introduce'] as String
    ..phone = json['phone'] as String
    ..password = json['password'] as String
    ..email = json['email'] as String
    ..sex = json['sex'] as String
    ..address = json['address'] as String
    ..headerUrl = json['headerUrl'] as String
    ..openid = json['openid'] as String
    ..countrys = (json['countrys'] as List)?.map((e) => e as String)?.toList()
    ..cities = (json['cities'] as List)?.map((e) => e as String)?.toList()
    ..collectionTravel =
        (json['collectionTravel'] as List)?.map((e) => e as String)?.toList()
    ..collectionstrategyids = (json['collectionstrategyids'] as List)
        ?.map((e) => e as String)
        ?.toList()
    ..friendids = (json['friendids'] as List)?.map((e) => e as String)?.toList()
    ..collectiongoodids =
        (json['collectiongoodids'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance._id,
      'birthday': instance.birthday,
      'nickname': instance.nickname,
      'introduce': instance.introduce,
      'phone': instance.phone,
      'password': instance.password,
      'email': instance.email,
      'sex': instance.sex,
      'address': instance.address,
      'headerUrl': instance.headerUrl,
      'openid': instance.openid,
      'countrys': instance.countrys,
      'cities': instance.cities,
      'collectionTravel': instance.collectionTravel,
      'collectionstrategyids': instance.collectionstrategyids,
      'friendids': instance.friendids,
      'collectiongoodids': instance.collectiongoodids
    };

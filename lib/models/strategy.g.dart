/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-03 11:01:09
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-03 14:13:38
 */ 
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Strategy _$StrategyFromJson(Map<String, dynamic> json) {
  return Strategy()
    ..placename = json['placename'] as String
    ..city = json['city'] as String
    ..title = json['title'] as String
    ..tags = (json['tags'] as List)?.map((e) => e as String)?.toList()
    ..puhlishid = json['puhlishid'] as String
    ..userHeader = json['userHeader'] as String
    ..author = json['author'] as String
    ..goodsid = json['goodsid'] as String
    ..startids = (json['startids'] as List)?.map((e) => e as String)?.toList()
    ..collectionsids = json['collectionsids'] as String
    ..commentids = json['commentids'] as String
    ..type = json['type'] as String
    ..imgs = (json['imgs'] as List)?.map((e) => e as String)?.toList()
    ..pendingState = json['pendingState'] as String;
}

Map<String, dynamic> _$StrategyToJson(Strategy instance) => <String, dynamic>{
      'placename': instance.placename,
      'city': instance.city,
      'title': instance.title,
      'tags': instance.tags,
      'puhlishid': instance.puhlishid,
      'userHeader': instance.userHeader,
      'author': instance.author,
      'goodsid': instance.goodsid,
      'startids': instance.startids,
      'collectionsids': instance.collectionsids,
      'commentids': instance.commentids,
      'type': instance.type,
      'imgs': instance.imgs,
      'pendingState': instance.pendingState
    };

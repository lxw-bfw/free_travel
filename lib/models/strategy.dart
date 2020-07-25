/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-03 11:00:34
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-03 14:12:53
 */ 
import 'package:json_annotation/json_annotation.dart';

part 'strategy.g.dart';

@JsonSerializable()
class Strategy {
    Strategy();

    String placename;
    String city;
    String title;
    List<String> tags;
    String puhlishid;
    String userHeader;
    String author;
    String goodsid;
    List<String> startids;
    String collectionsids;
    String commentids;
    String type;
    List<String> imgs;
    String pendingState;
    
    factory Strategy.fromJson(Map<String,dynamic> json) => _$StrategyFromJson(json);
    Map<String, dynamic> toJson() => _$StrategyToJson(this);
}

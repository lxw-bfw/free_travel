/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-02 12:14:25
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-03 11:04:15
 */ 
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
    User();
    String _id;
    String birthday;
    String nickname;
    String introduce;
    String phone;
    String password;
    String email;
    String sex;
    String address;
    String headerUrl;
    String openid;
    List<String> countrys;
    List<String> cities;
    List<String> collectionTravel;
    List<String> collectionstrategyids;
    List<String> friendids;
    List<String> collectiongoodids;
    
    factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
    Map<String, dynamic> toJson() => _$UserToJson(this);

    get id => _id;
}

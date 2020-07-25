/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-01 14:14:57
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-03 22:50:04
 */
// 维护全局变量和持久化操作，同时这里的变量也共provider使用和管理实现全局状态管理
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_mfw/models/location.dart';
import 'package:flutter_mfw/models/user.dart';

class Global {
  static SharedPreferences _prefs;

  static Location location = Location();

  static User user = User();

  static bool isLogin;

  // 全局baseUrl
  static String baserUrl = 'http://192.168.43.98:8081/FreeTravel/';

  // 初始化数据方法：从缓存中判断和获取数据，由于是sharde获取异步操作
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var _location = _prefs.getString('location');
    var _user = _prefs.getString('user');
    if (_location != null) {
      try {
        location = Location.fromJson(jsonDecode(_location));
      } catch (e) {
        print(e);
      }
    }
    if (_user != null) {
      try {
        isLogin = true;
        user = User.fromJson(jsonDecode(_user));
      } catch (e) {
        isLogin = false;
        print(e);
      }
    } else {
      isLogin = false;
    }
  }

  // 持久化
  static saveLocation() =>
      _prefs.setString('location', jsonEncode(location.toJson()));
  static saveUser() =>
      _prefs.setString('user', jsonEncode(user.toJson()));
static clearUser() =>
      _prefs.setString('user', null);
      

}

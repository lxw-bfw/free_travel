/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-05-22 12:33:07
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-03 12:29:12
 */ 
import 'package:flutter/material.dart';
import 'package:flutter_mfw/pages/other/topic_content.dart';
import 'package:flutter_mfw/tabbar/tabbar_page.dart';
import 'package:flutter_mfw/pages/detail/travel_detail_widget.dart';
import 'package:flutter_mfw/pages/other/topic_content.dart';
import 'package:flutter_mfw/pages/other/user_deail.dart';
import 'package:flutter_mfw/pages/login/widget/sing_up_page.dart';
final routers = {
  "/": (context) => TabbarPage(),
  // "/":(context) => SignInPage(),
   "/user_detail": (context,{arguments}) => UserDetail(param: arguments),
  "/travel_detail_widget":(context,{arguments}) => TravelDetailWidget(param: arguments,),
  "/topic_content_widget":(context,{arguments}) => TopicContent(param: arguments),
  // "/person_info_wid"
};


var onGenerateRoute = (RouteSettings settings) {

  final String name = settings.name;
  final Function pageContentBuilder = routers[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      print(settings.arguments);
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {

      final Route route =
      MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
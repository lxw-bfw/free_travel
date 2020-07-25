/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-01 11:09:41
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-01 15:02:33
 */ 
import 'package:flutter/material.dart';
import 'package:flutter_mfw/routers/router.dart';
import 'package:flutter_mfw/common/global.dart';
void main() =>  Global.init().then((e) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute:"/",
        onGenerateRoute: onGenerateRoute,
      theme: ThemeData(primaryColor: Colors.white),
    );
  }
}

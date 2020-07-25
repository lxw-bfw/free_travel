/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-05 11:18:01
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-05 11:25:11
 */
import 'package:flutter/material.dart';
import 'package:flutter_mfw/pages/other/user_stratetgy_list.dart';
import 'package:flutter_mfw/common/global.dart';

class MyStrategy extends StatefulWidget {
  MyStrategy({Key key}) : super(key: key);

  _MyStrategyState createState() => _MyStrategyState();
}

class _MyStrategyState extends State<MyStrategy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('查看我的攻略'),
        centerTitle: true,
      ),
      body: Container(
        child: UserStrategyList(
            id: 55, // 58是游记
            strId: Global.user.id,
            hoteList: null,
            animation: false),
      ),
    );
  }
}

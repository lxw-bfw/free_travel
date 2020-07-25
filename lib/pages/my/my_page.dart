/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-05-22 12:33:07
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-02 01:42:32
 */
import 'package:flutter/material.dart';
import 'package:flutter_mfw/screen_adapter.dart';
import 'package:flutter_mfw/pages/my/widget/my_navbar_widget.dart';
import 'package:flutter_mfw/pages/my/widget/my_logout_widget.dart';

import 'package:flutter_mfw/pages/my/widget/my_get_honey_widget.dart';
import 'package:flutter_mfw/pages/my/widget/my_travel_widget.dart';
import 'package:flutter_mfw/pages/my/widget/my_service_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mfw/common/global.dart';
import 'package:flutter_mfw/common/InfoNotify.dart';
import 'package:flutter_mfw/models/user.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  UserModel userModel = new UserModel();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return ChangeNotifierProvider<UserModel>(
      builder: (_) => userModel,
      child: Scaffold(
          backgroundColor: Color.fromRGBO(242, 242, 242, 1.0),
          body: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: ScreenAdapter.setHeight(88)),
                child: ListView(
                  children: <Widget>[
                    MyLogoutWidget(),
                    // MyGetHoneyWidget(),
                    MyTravelWidget(),
                    MyServiceCardWidget()
                  ],
                ),
              ),
              Positioned(top: 0, left: 0, right: 0, child: MyNavbarWidget()),
            ],
          )),
    );
  }
}

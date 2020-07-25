/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-05-22 12:33:07
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-02 21:53:35
 */
import 'package:flutter/material.dart';
import 'package:flutter_mfw/screen_adapter.dart';
import 'package:flutter_mfw/pages/my/widget/my_items_widget.dart';
import 'package:flutter_mfw/pages/login/login_registe.dart';
import 'package:jhtoast/jhtoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mfw/common/global.dart';
import 'package:flutter_mfw/common/InfoNotify.dart';
import 'package:flutter_mfw/models/user.dart';

class MyLogoutWidget extends StatefulWidget {
  @override
  _MyLogoutWidgetState createState() => _MyLogoutWidgetState();
}

class _MyLogoutWidgetState extends State<MyLogoutWidget> {
  // 用于实现响应更新和设置默认值TODO:
  UserModel userModel = UserModel();

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    //    MyItemsWidget(),
    return ChangeNotifierProvider<UserModel>(
      builder: (_) => userModel,
      child: Container(
        height: ScreenAdapter.setHeight(530),
        child: Stack(
          children: <Widget>[
            _unLog(),
            Positioned(bottom: 10, left: 0, right: 0, child: MyItemsWidget())
          ],
        ),
      ),
    );
  }

  Widget _unLog() {
    return Container(
      child: Container(
        alignment: Alignment.topLeft,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
        height: ScreenAdapter.setHeight(400),
        color: Color.fromRGBO(254, 217, 49, 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 0),
                child: Consumer<UserModel>(builder: (_, userInfo, __) {
                  return Text(
                      userInfo.isLogin
                          ? 'Hi~' + userInfo.user.nickname + '欢迎来到随心游'
                          : 'Hi~欢迎来到随心游',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.w700));
                })),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 30),
              child: Text("愿每一个旅行愿望得以达成"),
            ),
            Container(
                alignment: Alignment.center,
                width: ScreenAdapter.setWidth(260),
                height: ScreenAdapter.setWidth(90),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromRGBO(36, 38, 41, 1.0)),
                child: GestureDetector(onTap: () {
                  if (userModel.isLogin) {
                    // 注销登录
                    userModel.logout();
                    JhToast.showInfo(context, msg: '账号已注销，可以重新登录');
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }));
                  }
                }, child: Consumer<UserModel>(builder: (_, user, __) {
                  return user.isLogin
                      ? Text("注销/账号",
                          style: TextStyle(
                              color: Color.fromRGBO(248, 215, 62, 1.0),
                              fontSize: 16,
                              fontWeight: FontWeight.w500))
                      : Text("登录/注册",
                          style: TextStyle(
                              color: Color.fromRGBO(248, 215, 62, 1.0),
                              fontSize: 16,
                              fontWeight: FontWeight.w500));
                })))
          ],
        ),
      ),
    );
  }
}

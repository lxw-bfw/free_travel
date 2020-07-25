import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_mfw/pages/login/widget/theme.dart' as theme;
import 'package:flutter_mfw/models/user.dart';
import 'package:flutter_mfw/common/Http.dart';
import 'package:jhtoast/jhtoast.dart';

/**
 * 注册界面
 */
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> registeKey = GlobalKey<FormState>();

  User user = new User();

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.only(top: 23),
        child: new Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            new Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white,
                ),
                width: 300,
                height: 360,
                child: buildSignUpTextForm()),
            new Positioned(
              child: new Center(
                child: new GestureDetector(
                  onTap: () {
                    save();
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 42, right: 42),
                    decoration: new BoxDecoration(
                      gradient: theme.Theme.primaryGradient,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: new Text(
                      "注册",
                      style: new TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
              ),
              top: 340,
            )
          ],
        ));
  }

  void save() async {
    //读取当前 Form 状态
    var registeForm = registeKey.currentState;
    //验证 Form表单
    registeForm.save();
    print(user.nickname);
    var data = jsonEncode(user);
    var url = 'user/add';
    var lodingHide = JhToast.showLoadingText(context,msg: '注册中...');
    Http.postData(
        url,
        (result) {
          print(result);
          lodingHide();
        },
        params: jsonDecode(data),
        errorCallBack: (error) {
          print(error);
          lodingHide();
        });
    // print('userName：' + userName);
  }

  Widget buildSignUpTextForm() {
    return new Form(
        key: registeKey,
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            //用户名字
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: new TextFormField(
                  decoration: new InputDecoration(
                      icon: new Icon(
                        FontAwesomeIcons.user,
                        color: Colors.black,
                      ),
                      hintText: "昵称",
                      border: InputBorder.none),
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  onSaved: (value) {
                    user.nickname = value;
                  },
                ),
              ),
            ),
            new Container(
              height: 1,
              width: 250,
              color: Colors.grey[400],
            ),
            //邮箱
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: new TextFormField(
                  decoration: new InputDecoration(
                      icon: new Icon(
                        Icons.phone_android,
                        color: Colors.black,
                      ),
                      hintText: "手机号",
                      border: InputBorder.none),
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  onSaved: (value) {
                    user.phone = value;
                  },
                ),
              ),
            ),
            new Container(
              height: 1,
              width: 250,
              color: Colors.grey[400],
            ),
            //密码
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: new TextFormField(
                  decoration: new InputDecoration(
                    icon: new Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    hintText: "密码",
                    border: InputBorder.none,
                    suffixIcon: new IconButton(
                        icon: new Icon(
                          Icons.remove_red_eye,
                          color: Colors.black,
                        ),
                        onPressed: () {}),
                  ),
                  obscureText: true,
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  onSaved: (value) {
                    user.password = value;
                  },
                ),
              ),
            ),
            new Container(
              height: 1,
              width: 250,
              color: Colors.grey[400],
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: new TextFormField(
                  decoration: new InputDecoration(
                    icon: new Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    hintText: "确认密码",
                    border: InputBorder.none,
                    suffixIcon: new IconButton(
                        icon: new Icon(
                          Icons.remove_red_eye,
                          color: Colors.black,
                        ),
                        onPressed: () {}),
                  ),
                  obscureText: true,
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ));
  }
}

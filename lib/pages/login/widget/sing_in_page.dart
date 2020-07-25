import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_mfw/pages/login/widget/theme.dart' as theme;
import 'package:jhtoast/jhtoast.dart';
import 'package:flutter_mfw/pages/login/bindPhone.dart';
import 'package:flutter_mfw/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mfw/common/InfoNotify.dart';
import 'package:flutter_mfw/common/Http.dart';
// import 'package:fluwx/fluwx.dart';
// import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:dio/dio.dart';

/**
 *注册界面
 */
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => new _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  /**
   * 利用FocusNode和FocusScopeNode来控制焦点
   * 可以通过FocusNode.of(context)来获取widget树中默认的FocusScopeNode
   */
  FocusNode emailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  FocusScopeNode focusScopeNode = new FocusScopeNode();

  GlobalKey<FormState> _SignInFormKey = new GlobalKey();

  bool isShowPassWord = false;

  UserModel userModel = UserModel();

  User user = new User();

  String _result;

  @override
  void initState() {
    super.initState();
    _initFluwx();
  }

  _initFluwx() async {
    await fluwx.register(appId: "wxd90d2284ee06b0b3");
    var result = await fluwx.isWeChatInstalled();
    print("is installed $result");
    JhToast.showInfo(context,msg:'is installed $result' );
    Future.delayed(Duration(seconds: 1), () {
      fluwx.responseFromAuth.listen((data) {
        if (mounted) {}
        // 这里返回结果，errCode=1为微信用户授权成功的标志，其他看微信官方开发文档
        setState(() {
          _result = "initState ======   ${data.errCode}  --- ${data.code}";
          print('授权结果是${_result}');
          int errCode = data.errCode;
          // 近二日code为0的时候有效。code有效
          if (data.errCode == 0) {
            String code = data.code;
            print('code  $code');
            //TODO:成功获取code之后和获取去请求access_token和open_id，再通过access_token获取到微信用户信息等。
            getWeChatAccessToken(code);
          } else if (data.errCode == -4) {
            JhToast.showError(context, msg: '用户拒绝授权');
          } else if (data.errCode == -2) {
            JhToast.showError(context, msg: '用户已取消');
          } 
          else {
            JhToast.showError(context, msg: '用户拒绝授权');
          }
          print('aaaa ====== >   $_result');
        });
      });
    });

    // await fluwx.share();
  }

  // 根据code调用接口获取access_token
  void getWeChatAccessToken(code) async {
    print('code是是${code}');
    var dio = new Dio();
    var result = await dio.get(
        'https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxd90d2284ee06b0b3&secret=ab250b6b644982745c93336b9a261e73&code=${code}&grant_type=authorization_code');
    print('返回结果${result}');
    JhToast.showError(context,msg: '签名授权secret失效');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModel>(
      builder: (_) => userModel,
      child: Container(
        padding: EdgeInsets.only(top: 23),
        child: new Stack(
          alignment: Alignment.center,
//        /**
//         * 注意这里要设置溢出如何处理，设置为visible的话，可以看到孩子，
//         * 设置为clip的话，若溢出会进行裁剪
//         */
//        overflow: Overflow.visible,
          children: <Widget>[
            new Column(
              children: <Widget>[
                //创建表单
                buildSignInTextForm(),

                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: new Text(
                    "忘记密码?",
                    style: new TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        decoration: TextDecoration.underline),
                  ),
                ),

                /**
               * Or所在的一行
               */
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: new Row(
//                          mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        height: 1,
                        width: 100,
                        decoration: BoxDecoration(
                            gradient: new LinearGradient(colors: [
                          Colors.white10,
                          Colors.white,
                        ])),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: new Text(
                          "第三方",
                          style:
                              new TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      new Container(
                        height: 1,
                        width: 100,
                        decoration: BoxDecoration(
                            gradient: new LinearGradient(colors: [
                          Colors.white,
                          Colors.white10,
                        ])),
                      ),
                    ],
                  ),
                ),

                /**
               * 显示第三方登录的按钮
               */
                new SizedBox(
                  height: 10,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new GestureDetector(
                      onTap: () async {
                        //TODO:微信登录：逻辑：第一次登录没有记录（用户表没有记录）
                        // 微信登录需要一个单独的接口，但是不需要额外的表，微信关键只是方便登录，共享的信息不多，只是一个昵称还有头像，
                        // 也就是调用微信登录接口把openid给我，我去查user表，查询之后如果返回code位= 0 你就需要跳转到绑定手机号设置密码页面此时调用的是
                        // 注册接口只是你需要把微信账号获取到的某些字段赋值给用户表字段
                        //  这样实现至始至终用户信息都只是从用户表获取。后期重复微信登录仅仅只是登录而已。

                        try {
                          var data = await fluwx.sendAuth(
                              scope: 'snsapi_userinfo',
                              state: "wechat_sdk_demo_test");
                          print('------------------=--');
                          print(data);
                        } catch (e) {
                          print(e);
                          JhToast.showError(context, msg: '失败');
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BindPhone();
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: new IconButton(
                            icon: Icon(
                              FontAwesomeIcons.weixin,
                              color: Color(0xFF44b549),
                            ),
                            onPressed: null),
                      ),
                    )
                  ],
                )
              ],
            ),
            new Positioned(
              child: buildSignInButton(),
              top: 170,
            )
          ],
        ),
      ),
    );
  }

  /**
   * 点击控制密码是否显示
   */
  void showPassWord() {
    setState(() {
      isShowPassWord = !isShowPassWord;
    });
  }

  /**
   * 创建登录界面的TextForm
   */
  Widget buildSignInTextForm() {
    return new Container(
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      width: 300,
      height: 190,
      /**
       * Flutter提供了一个Form widget，它可以对输入框进行分组，
       * 然后进行一些统一操作，如输入内容校验、输入框重置以及输入内容保存。
       */
      child: new Form(
        key: _SignInFormKey,
        //开启自动检验输入内容，最好还是自己手动检验，不然每次修改子孩子的TextFormField的时候，其他TextFormField也会被检验，感觉不是很好
//        autovalidate: true,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: new TextFormField(
                  //关联焦点
                  focusNode: emailFocusNode,
                  onEditingComplete: () {
                    if (focusScopeNode == null) {
                      focusScopeNode = FocusScope.of(context);
                    }
                    focusScopeNode.requestFocus(passwordFocusNode);
                  },

                  decoration: new InputDecoration(
                      icon: new Icon(
                        Icons.phone_android,
                        color: Colors.black,
                      ),
                      hintText: "手机号",
                      border: InputBorder.none),
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  //验证
                  validator: (value) {
                    if (value.isEmpty) {
                      return "手机号不能为空!";
                    }
                  },
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
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: new TextFormField(
                  focusNode: passwordFocusNode,
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
                          onPressed: showPassWord)),
                  //输入密码，需要用*****显示
                  obscureText: !isShowPassWord,
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return "密码长度至少6位";
                    }
                  },
                  onSaved: (value) {
                    user.password = value;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   * 创建登录界面的按钮
   */
  Widget buildSignInButton() {
    return new GestureDetector(
      child: new Container(
        padding: EdgeInsets.only(left: 42, right: 42, top: 10, bottom: 10),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          gradient: theme.Theme.primaryGradient,
        ),
        child: new Text(
          "登录",
          style: new TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      onTap: () {
        /**利用key来获取widget的状态FormState
              可以用过FormState对Form的子孙FromField进行统一的操作
           */
        if (_SignInFormKey.currentState.validate()) {
          //如果输入都检验通过，则进行登录操作

          //调用所有自孩子的save回调，保存表单内容
          _SignInFormKey.currentState.save();

          var loadingHide = JhToast.showLoadingText(context, msg: '登录中...');
          var url = 'login/userLogin';
          Http.postData(
              url,
              (result) {
                loadingHide();
                User user1 = User.fromJson(result['data']);
                userModel.login(user1);
                Navigator.pushNamed(context, "/");
                // print(result)
              },
              params: {"phone": user.phone, "password": user.password},
              errorCallBack: (err) {
                loadingHide();
                print(err);
              });

          // 登录成功关闭登录页面
          // Navigator.pop(context);
        }
//          debugDumpApp();
      },
    );
  }
}

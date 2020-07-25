import 'package:flutter/material.dart';
import 'package:flutter_mfw/pages/login/widget/sing_in_page.dart';
import 'package:random_pk/random_pk.dart';
import 'package:flutter_mfw/pages/login/widget/theme.dart' as theme;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_mfw/pages/login/widget/sing_up_page.dart';

class BindPhone extends StatefulWidget {
  BindPhone({Key key}) : super(key: key);

  @override
  _BindPhoneState createState() => new _BindPhoneState();
}

class _BindPhoneState extends State<BindPhone> with TickerProviderStateMixin {
  PageController _pageController;
  PageView _pageView;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
    _pageView = new PageView(
      controller: _pageController,
      children: <Widget>[
        // new SignInPage(),
        new SignUpPage(),
      ],
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      /**
       * SafeArea，让内容显示在安全的可见区域
       * SafeArea，可以避免一些屏幕有刘海或者凹槽的问题
       */
      body: new SingleChildScrollView(
          /**
             * 用SingleChildScrollView+Column，避免弹出键盘的时候，出现overFlow现象
             */
          child: new Container(
              /**这里要手动设置container的高度和宽度，不然显示不了
                 * 利用MediaQuery可以获取到跟屏幕信息有关的数据
                 */
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              //设置渐变的背景
              decoration: new BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/login_bg2.jpg'),
                fit: BoxFit.cover,
              )),
              child: new Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new SizedBox(
                    height: 45,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                        size: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '绑定手机号',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  new SizedBox(
                    height: 15,
                  ),
                  /**
                       * 可以用SizeBox这种写法代替Padding：在Row或者Column中单独设置一个方向的间距的时候
                       */
//                    new Padding(padding: EdgeInsets.only(top: 75)),

                  //顶部图片

                  // new Image(
                  //     width: 250,
                  //     height: 191,
                  //     image: new AssetImage("assets/login_logo.png")),
                  new SizedBox(
                    height: 191,
                  ),

                  //中间的Indicator指示器

//                      new SignInPage(),
//                      new SignUpPage(),
                  new Expanded(child: _pageView),
                ],
              ))),
    );
  }
}

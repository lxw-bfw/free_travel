import 'package:flutter/material.dart';

import 'package:flutter_mfw/screen_adapter.dart';
import 'package:flutter_mfw/pages/detail/detail_appbar_widget.dart';
import 'package:flutter_mfw/pages/detail/detail_carousel_widget.dart';
import 'package:flutter_mfw/dao/travel_detail_dao.dart';
import 'package:flutter_mfw/model/travel_detail_model.dart';
import 'package:flutter_mfw/pages/detail/detail_title_widget.dart';
import 'package:flutter_mfw/pages/detail/detail_content_widget.dart';
import 'package:flutter_mfw/pages/detail/detail_remind_widget.dart';
import 'package:flutter_mfw/pages/detail/detail_reply_widget.dart';
import 'package:flutter_mfw/pages/detail/detail_recommend_title_widget.dart';
import 'package:flutter_mfw/pages/home/home_waterfall_page.dart';

import 'package:flutter_mfw/dao/home_dao.dart';

import 'package:flutter_mfw/model/waterfall_model.dart';

import 'package:flutter_mfw/pages/detail/detail_bottom_bar_widget.dart';

import 'package:jhtoast/jhtoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_mfw/model/travel_detail_model.dart';
import 'package:flutter_mfw/pages/other/user_deail.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

/*
**  与H5端规定好的js回调flutter的方法名常量类，这里涉及到都h5页面调用flutter业务是：页面点赞按钮，需要调用flutter，判断是否登录，以及在flutter 实现的点赞接口访问
*/
class JSFunctionName {
  static const String JS_Love = 'LoveStrategy'; // 方法名与H5端规定好——表示点赞功能
  static const String JS_Jump = 'PageJump'; // h5页面跳转
}

class TravelHomeDetail extends StatefulWidget {
  var animation = false;
  TravelHomeDetail({Key key, this.animation, this.param}) : super(key: key);
  final Map<String, dynamic> param;

  @override
  _TravelHomeDetailState createState() => _TravelHomeDetailState();
}

class _TravelHomeDetailState extends State<TravelHomeDetail> {
  TravelDetailModel _travelDetailModel;

  WebViewController _controller; // web控制器
  String _webTitle; // 网页标题
  var isLoading = true;

  OwnerModel owner = new OwnerModel();

  var _waterfallList = <WaterFallItemModel>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    _getWaterFallData();
    _initFluwx();
  }

  _initFluwx() async {
    await fluwx.register(appId: "wxd90d2284ee06b0b3");
    var result = await fluwx.isWeChatInstalled();
    print("is installed $result");
    JhToast.showInfo(context, msg: 'is installed $result');
    Future.delayed(Duration(seconds: 1), () {
      fluwx.responseFromAuth.listen((data) {
        if (mounted) {}
        // 这里返回结果，errCode=1为微信用户授权成功的标志，其他看微信官方开发文档
        setState(() {
          var _result = "initState ======   ${data.errCode}  --- ${data.code}";
          print('授权结果是${_result}');
          int errCode = data.errCode;
          // 近二日code为0的时候有效。code有效
          if (data.errCode == 0) {
            String code = data.code;
            print('code  $code');
            //TODO:成功获取code之后和获取去请求access_token和open_id，再通过access_token获取到微信用户信息等。
            // getWeChatAccessToken(code);
          } else if (data.errCode == -4) {
            JhToast.showError(context, msg: '用户拒绝授权');
          } else if (data.errCode == -2) {
            JhToast.showError(context, msg: '用户已取消');
          } else {
            JhToast.showError(context, msg: '用户拒绝授权');
          }
          print('aaaa ====== >   $_result');
        });
      });
    });

    // await fluwx.share();
  }

  void _getData() {
    
  }

  void _getWaterFallData() {
    WaterFallDao.fetch().then((result) {
      setState(() {
        _waterfallList = result.list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Icon(
                  Icons.keyboard_arrow_left,
                  size: 35,
                ),
              )),
          title: GestureDetector(
              onTap: () {
                
              },
              child: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    children: <Widget>[
                      ClipOval(
                        child: Image.asset(
                                'assets/deheader.jpeg',
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                              )
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Nike'),
                      )
                    ],
                  ))),
          elevation: 4,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                // 弹出分享
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return _showNomalWid(context);
                    });
              },
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 0),
                  child: Icon(Icons.more_horiz)),
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            // 底部nav
            WebView(
              initialUrl: 'http://192.168.43.98:8082/#/travelDetail/123', //动态查询
              // 加载的网页
              // initialUrl: 'https://site.sonicmoving.cn/extension-templates/views/brand.html?id=01ff9194-76ab-4080-9460-4a1412f75e64&rootTemplateId=2&__soundbusmanagerid__=5b8e4bfe36a80a00062ecd17&merchantId=80d7b2d627de45759fe754aba507a3f0&__soundbusoptions__=%257b%2522surprise%2522%253atrue%257d&__x=c2b40a6d-0914-4b88-8880-1b47d35cc914&__soundbusts__=b179adbcb4510012a376beebd07d18ae&__soundbusapp__=com.soundbus.sharebus&__soundbusudf__=5c90480602cfc60006f3705b&__soundbusno__=27BE346D04DE17C5471BA80EA58F02B3CBC48A82&__soundbusyx__=24.479710,118.166144&__soundbusuid__=5c90480602cfc60006f3705b',
              // 允许js执行
              javascriptMode: JavascriptMode.unrestricted,
              /*
        **  拦截，webview开始访问网页url的时候触发，可以在这里监听、拦截网页url的变化实现js访问flutter webview
        **  也可以作为webview开始加载网页的回调。简单说当前加载的网页url包括在网页的操作改变了url都会触发这里。
        */
              navigationDelegate: (NavigationRequest request) {
                setState(() {
                  isLoading = true;
                });

                // 下面对改变url的行为进行拦截，因为现在在app，不是在浏览器
                // 这里是在h5页面准备跳转到攻略详情页面。
                // if (request.url
                //     .contains("blog")) {
                //   JhToast.showInfo(context, msg: '现在是在app');
                //   return NavigationDecision.prevent; // 阻止路由替换
                // }
                // 放行。也就是允许路由
                return NavigationDecision.navigate;
              },
              /*
        **  js调用flutter（例如iOS：类似iOS的js调用原生，通过注册与webview端沟通好的方法‘postStatus’,onMessageReceived中执行响应）
        */
              javascriptChannels: <JavascriptChannel>[
                JavascriptChannel(
                  name: JSFunctionName.JS_Love,
                  onMessageReceived: (JavascriptMessage message) {
                    // 如果webview的 h5端调用了规定的名字的方法就会触发这里的回调，也就是JS_Love常量保存的LoveStrategy方法名，js端调用这个方法
                    JhToast.showInfo(context, msg: message.message);
                  },
                ),
                JavascriptChannel(
                  name: JSFunctionName.JS_Jump,
                  onMessageReceived: (JavascriptMessage message) {
                    // 如果webview的 h5端调用了规定的名字的方法就会触发这里的回调，也就是JS_Love常量保存的LoveStrategy方法名，js端调用这个方法
                    JhToast.showInfo(context, msg: message.message);
                  },
                ),
                // 如果还有其他方法。。。
                // JavascriptChannel(
                //   name: JSFunctionName.JS_otherFunction,
                //   onMessageReceived: (JavascriptMessage message){
                //     print(message);
                //   },
                // ),
              ].toSet(),
              /*
        **  flutter调用js（例如iOS：监听网页的title）
        */
              // 页面创建完成
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              // 页面加载结束
              onPageFinished: (url) {
                _controller.evaluateJavascript("document.title").then((result) {
                  setState(() {
                    print(result);
                    isLoading = false;
                    // _webTitle = result;
                  });
                });
              },
            ),
            // 加载中...
            isLoading
                ? Center(
                    child: SpinKitSpinningCircle(
                      color: Color(0xffffde33),
                      size: 60.0,
                    ),
                  )
                : Container(),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: DetailBottomBarWidget(
                commentClick: () {
                  // 进入评论页面
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return _showComlWid(context);
                      });
                },
                loveClick: () {
                  print(0);
                },
                collectClick: () {
                  print(0);
                },
                tuijianClick: () {
                  print(0);
                },
              ),
            )
          ],
        ));
  }

  Widget _showNomalWid(BuildContext context) {
    // 需要的空间和名称
    // var ItemList  = List();// 不限定长度，不限定类型，可添加任意类型的数据
    var urlItems = ['wx', 'wxpyq', 'qqkojian', 'wb', 'download', 'conect'];
    var nameItems = ['微信', '朋友圈', 'QQ空间', '微博', '下载', '链接'];

    return new Container(
      height: 280.0,
      padding: EdgeInsets.only(top: 15),
      //  color: Colors.greenAccent,
      child: new GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 5.0, childAspectRatio: 1.0),
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              new GestureDetector(
                onTap: () async {
                  if (index == 0) {
                    // JhToast.showInfo(context, msg: "该分享功能暂未实现");
                    await fluwx.share(fluwx.WeChatShareWebPageModel(
                        webPage: 'http://192.168.43.98:8082/#/travelDetail/123',
                        transaction: 'hehe',
                        title: '随心游分享',
                        description: '点击连接打开h5页面',
                        scene: fluwx.WeChatScene.SESSION,
                        thumbnail:
                            'https://n1-q.mafengwo.net/s15/M00/41/2F/CoUBGV4YAxCAMrflAAXDfaFMzlQ15.jpeg?imageMogr2%2Fthumbnail%2F%21476x268r%2Fgravity%2FCenter%2Fcrop%2F%21476x268%2Fquality%2F100'));
                  } else if (index == 1) {
                    await fluwx.share(fluwx.WeChatShareWebPageModel(
                        webPage: 'http://192.168.43.98:8082/#/travelDetail/123',
                        transaction: 'hehe',
                        title: '随心游分享',
                        description: '点击连接打开h5页面',
                        scene: fluwx.WeChatScene.TIMELINE,
                        thumbnail:
                            'https://n1-q.mafengwo.net/s15/M00/41/2F/CoUBGV4YAxCAMrflAAXDfaFMzlQ15.jpeg?imageMogr2%2Fthumbnail%2F%21476x268r%2Fgravity%2FCenter%2Fcrop%2F%21476x268%2Fquality%2F100'));
                  } else if (index == 5) {
                    // 赋值链接
                    Clipboard.setData(ClipboardData(text: '链接'));

                    JhToast.showSuccess(context, msg: '复制成功');
                  } else {
                    JhToast.showInfo(context, msg: '其他分享暂未实现');
                  }
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
                  child: new Image.asset(
                    'assets/shares/${urlItems[index]}.png',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              new Text(nameItems[index])
            ],
          );
        },
        itemCount: nameItems.length,
      ),
    );
  }

  Widget _showComlWid(BuildContext context) {
    return ListView(
      children: <Widget>[
        DetailReplyWidget(
          replies: _travelDetailModel.weng.replies,
        ),
      ],
    );
  }
}

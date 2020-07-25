/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-05-23 19:35:17
 * @LastEditors: lxw

  Map<String, int> param;
 * @LastEditTime: 2020-05-31 15:19:34
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:jhtoast/jhtoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/*
**  与H5端规定好的js回调flutter的方法名常量类，这里涉及到都h5页面调用flutter业务是：页面点赞按钮，需要调用flutter，判断是否登录，以及在flutter 实现的点赞接口访问
*/
class JSFunctionName {
  static const String JS_Love = 'LoveStrategy'; // 方法名与H5端规定好——表示点赞功能
  static const String JS_Jump = 'PageJump'; // h5页面跳转时
}

// webview
class TopicContent extends StatefulWidget {
  TopicContent({this.param});
  final Map<String, dynamic> param;//保存相关id字段要传递给通过url(这里是h5页面是vue-router动态路由参数)

  @override
  State<StatefulWidget> createState() {
    return TopicContentState();
  }
}

class TopicContentState extends State<TopicContent> {
  WebViewController _controller; // web控制器
  String _webTitle; // 网页标题
  var isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    _webTitle = widget.param['tagName'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: Text(_webTitle),// 报错
          title: Text('$_webTitle'), // 正常运行
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              size: 35,
            ),
          ),
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
                padding: EdgeInsets.only(right: 15.0),
                child: Icon(Icons.share),
              ),
            )
          ],
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: 'http://192.168.43.98:8082/#/topicStrategy/'+widget.param['id'].toString(),//动态查询
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
                : Container()
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
                onTap: () {
                  if (index != 5) {
                    JhToast.showInfo(context, msg: "该分享功能暂未实现");
                  } else {
                    // 赋值链接
                    Clipboard.setData(ClipboardData(text: '链接'));
                    JhToast.showSuccess(context, msg: '复制成功');
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
}

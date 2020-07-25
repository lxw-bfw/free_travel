/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-05-31 07:53:06
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-05 14:44:04
 */
// 好友或者是其他用户的个人中心页面
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jhtoast/jhtoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_mfw/pages/other/user_stratetgy_list.dart';
import 'package:flutter_mfw/common/Http.dart';
import 'package:flutter_mfw/common/global.dart';
import 'package:flutter_mfw/pages/chat/chat_easy.dart';

class UserDetail extends StatefulWidget {
  UserDetail({this.param, this.id});
  final Map<String, dynamic> param;
  final String id;

  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  var tabInd = 0;

  var userheader = '';
  var username = '';
  var age = '';
  var city = '';
  var guanzhuNum = 0;
  var introduce = '个人简介';
  var fensiNum = 0;
  var fensiList = [];
  String state1 = '关注';

  void getUserInfo() {
    var url = 'user/${widget.id}';
    Http.getData(url, (result) {
      setState(() {
        print(result);
        var data = result['data'];
        userheader = data['headerUrl'];
        username = data['nickname'];
        city = data['address'].substring(0, 3);
        guanzhuNum = data['friendids'] == null ? 0 : data['friendids'].length;
        introduce = data['introduce'] == null ? introduce : data['introduce'];
        fensiList = data['fensiIds'] == null ? [] : data['fensiIds'];
        fensiNum = data['fensiIds'] == null ? 0 : data['fensiIds'].length;
      });
      // var resultList = result['data']['data'];
      // setState(() {
      //   tags = [];
      //   for (var i = 0; i < resultList.length; i++) {
      //     tags.add(
      //         {'isSelect': 'false', 'content': resultList[i]['content']});
      //   }
      // });
    }, errorCallBack: (err) {
      print(err);
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/usbg1.jpg'),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
            backgroundColor: Colors.transparent, //把scaffold的背景色改成透明
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.keyboard_arrow_left,
                  size: 35,
                  color: Colors.white,
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
                    child: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
              backgroundColor: Colors.transparent, //把appbar的背景色改成透明
              // elevation: 0,//appbar的阴影
            ),
            body: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text.rich(TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "1",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 35)),
                                    TextSpan(
                                      text: "个国家",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text.rich(TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "4",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 35)),
                                    TextSpan(
                                      text: "座城市",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                              ),
                            ],
                          )
                        ],
                      ),
                      Stack(
                        children: <Widget>[
                          // 主体内容
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            width: double.infinity,
                            // height: 600,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xfff0f0f0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        RaisedButton.icon(
                                          icon: Icon(Icons.send),
                                          label: Text("消息"),
                                          onPressed: () {
                                             Navigator.push( context,
           MaterialPageRoute(builder: (context) {
              return ChatEasy();
           }));
                                          },
                                        ),
                                        OutlineButton.icon(
                                          splashColor: Color(0xffffdb26),
                                          icon: Icon(Icons.add),
                                          label: Text(state1),
                                          onPressed: () {
                                            if (state1 == '关注') {
                                              var url = 'user/${widget.id}';
                                              fensiList.add(Global.user.id);
                                              var data = {
                                                'fensiIds': fensiList
                                              };
                                              Http.putData(
                                                  url,
                                                  (result) {
                                                    // print(result);
                                                    JhToast.showSuccess(context,
                                                        msg: '关注成功');
                                                    setState(() {
                                                      state1 = '取关';
                                                      fensiNum = fensiNum + 1;
                                                    });
                                                    // var resultList = result['data']['data'];
                                                    // setState(() {
                                                    //   tags = [];
                                                    //   for (var i = 0; i < resultList.length; i++) {
                                                    //     tags.add(
                                                    //         {'isSelect': 'false', 'content': resultList[i]['content']});
                                                    //   }
                                                    // });
                                                  },
                                                  params: data,
                                                  errorCallBack: (err) {
                                                    print(err);
                                                  });
                                            } else {
                                              var url = 'user/${widget.id}';
                                              fensiList.remove(Global.user.id);
                                              var data = {
                                                'fensiIds': fensiList
                                              };
                                              Http.putData(
                                                  url,
                                                  (result) {
                                                    // print(result);
                                                    JhToast.showSuccess(context,
                                                        msg: '取关成功');
                                                    setState(() {
                                                      state1 = '关注';
                                                      fensiNum = fensiNum - 1 ;
                                                    });
                                                    // var resultList = result['data']['data'];
                                                    // setState(() {
                                                    //   tags = [];
                                                    //   for (var i = 0; i < resultList.length; i++) {
                                                    //     tags.add(
                                                    //         {'isSelect': 'false', 'content': resultList[i]['content']});
                                                    //   }
                                                    // });
                                                  },
                                                  params: data,
                                                  errorCallBack: (err) {
                                                    print(err);
                                                  });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              username == '' ? '无名氏' : username,
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                              width: 30,
                                              margin: EdgeInsets.only(left: 5),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Color(0xffffdb26)),
                                              child: Text(
                                                'LV1',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Image(
                                                image: AssetImage(
                                                    "assets/girl.png"),
                                                width: 25.0),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text(
                                                age == '' ? '无年龄' : age,
                                                style: TextStyle(
                                                    color: Color(0xff474747)),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text(
                                                '|',
                                                style: TextStyle(
                                                    color: Color(0xff474747)),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text(
                                                city == '' ? '无城市' : city,
                                                style: TextStyle(
                                                    color: Color(0xff474747)),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text(
                                                '|',
                                                style: TextStyle(
                                                    color: Color(0xff474747)),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text(
                                                '${guanzhuNum}关注',
                                                style: TextStyle(
                                                    color: Color(0xff474747)),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text(
                                                '|',
                                                style: TextStyle(
                                                    color: Color(0xff474747)),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text(
                                                '${fensiNum}粉丝',
                                                style: TextStyle(
                                                    color: Color(0xff474747)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              introduce,
                                              style: TextStyle(
                                                  color: Color(0xff474747)),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // nav
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    width: double.infinity,
                                    padding: EdgeInsets.only(top: 10),
                                    height: 60,
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                '攻略',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color(0xff000000),
                                                    fontWeight: tabInd == 0
                                                        ? FontWeight.bold
                                                        : null),
                                              ),
                                              tabInd == 0
                                                  ? Container(
                                                      width: 40,
                                                      height: 3,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffffdb26),
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                          onTap: () {
                                            setState(() {
                                              tabInd = 0;
                                            });
                                          },
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              tabInd = 1;
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                '游记',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color(0xff000000),
                                                    fontWeight: tabInd == 1
                                                        ? FontWeight.bold
                                                        : null),
                                              ),
                                              tabInd == 1
                                                  ? Container(
                                                      width: 40,
                                                      height: 3,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffffdb26),
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              tabInd = 2;
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                '视频',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color(0xff000000),
                                                    fontWeight: tabInd == 2
                                                        ? FontWeight.bold
                                                        : null),
                                              ),
                                              tabInd == 2
                                                  ? Container(
                                                      width: 40,
                                                      height: 3,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffffdb26),
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 内容列表7
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: UserStrategyList(
                                        id: 55, // 58是游记
                                        strId: widget.id,
                                        hoteList: null,
                                        animation: false),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            padding: EdgeInsets.all(5),
                            width: 86,
                            height: 86,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(43),
                              color: Colors.white,
                            ),
                            child: ClipOval(
                              child: userheader == ''
                                  ? Image.asset(
                                      'assets/deheader.jpeg',
                                      width: 85.0,
                                      height: 85.0,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      userheader,
                                      width: 85.0,
                                      height: 85.0,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )));
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

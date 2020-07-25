import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_mfw/pages/home/home_page.dart';
import 'package:flutter_mfw/pages/location/location_page.dart';
import 'package:flutter_mfw/pages/travel/travel_page.dart';
import 'package:flutter_mfw/pages/my/my_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mfw/common/InfoNotify.dart';

import 'package:flutter_mfw/screen_adapter.dart';

import 'package:flutter_mfw/pages/login/login_registe.dart';
import 'package:flutter_mfw/pages/publish/strategy/add_strategy.dart';

class TabbarPage extends StatefulWidget {
  @override
  _TabbarPageState createState() => _TabbarPageState();
}

class _TabbarPageState extends State<TabbarPage> {
  UserModel userModel = UserModel();

  var _currentIndex = 0;

  var _pageController;

  var _tabNavList = [
    {
      "title": "首页",
      "selectImage": "assets/tabicons/home_select.png",
      "normalImage": "assets/tabicons/home.png",
    },
    {
      "title": "云旅行",
      "selectImage": "assets/tabicons/colud_select.png",
      "normalImage": "assets/tabicons/cloud.png",
    },
    {
      "title": "发布",
      "selectImage": "assets/images/tab_destination_selected.png",
      "normalImage": "assets/images/tab_destination_normal.png",
    },
    {
      "title": "服务",
      "selectImage": "assets/tabicons/goods_select.png", //goods_select
      "normalImage": "assets/tabicons/goods.png",
    },
    {
      "title": "我的",
      "selectImage": "assets/tabicons/my_selset.png",
      "normalImage": "assets/tabicons/my.png",
    }
  ];

  var _pages = [HomePage(), LocationPage(), Text(""), TravelPage(), MyPage()];

  void _handleTap() {
    // 某个GestureDetector的事件

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => actionSheet(),
    ).then((value) {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    var _index = 0;
    return ChangeNotifierProvider<UserModel>(
      builder: (_) => userModel,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(246, 246, 246, 1.0),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: _pages,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(top: 8),
          width: ScreenAdapter.setWidth(110),
          height: ScreenAdapter.setHeight(110),
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ScreenAdapter.setWidth(55)),
              color: Color.fromRGBO(246, 246, 246, 1.0)),
          child: Consumer<UserModel>(
            builder: (_, userM1, __) {
              return FloatingActionButton(
                elevation: 0,
                focusElevation: 0,
                onPressed: () {
                  if (userM1.isLogin) {
                    print("发布视频");

                    _handleTap();
                  } else {
                    // 跳转到登录页面
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }));
                  }
                },
                child: Icon(
                  Icons.add,
                  size: 25,
                  color: Colors.black,
                ),
                backgroundColor: Color.fromRGBO(253, 219, 69, 1.0),
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              if (index == 2) {
                // 发布或创建攻略,判断是否登录，弹出选择攻略还是游记

              } else {
                setState(() {
                  _currentIndex = index;
                  _pageController.jumpToPage(index);
                });
              }
            },

            ///用于修复tabbar的item 过多出现的问题
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color.fromRGBO(70, 70, 70, 1.0),
            items: _tabNavList.map((item) {
              var bavItem = BottomNavigationBarItem(
                  icon: _barItemIcon(
                      _index, item["selectImage"], item["normalImage"]),
                  title: Text(item["title"]));

              _index++;
              return bavItem;
            }).toList()),
      ),
    );
  }

  Widget _barItemIcon(index, selectedImage, normalImage) {
    return Image.asset(
      "${index == _currentIndex ? selectedImage : normalImage}",
      width: ScreenAdapter.setWidth(50),
      height: ScreenAdapter.setHeight(50),
    );
  }

  // 底部弹出菜单actionSheet
  Widget actionSheet() {
    return new CupertinoActionSheet(
      title: new Text(
        '选择类型',
        // style: descriptiveTextStyle,
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text(
            '发布攻略',
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'PingFangRegular',
            ),
          ),
          onPressed: () {
            // 关闭菜单
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddStrategy();
            }));
            //
          },
        ),
        CupertinoActionSheetAction(
          child: const Text(
            '发布游记',
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'PingFangRegular',
            ),
          ),
          onPressed: () {
            // 关闭菜单
            Navigator.of(context).pop();
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: new Text(
          '取消',
          style: TextStyle(
            fontSize: 13.0,
            fontFamily: 'PingFangRegular',
            color: const Color(0xFF666666),
          ),
        ),
        onPressed: () {
          // 关闭菜单
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

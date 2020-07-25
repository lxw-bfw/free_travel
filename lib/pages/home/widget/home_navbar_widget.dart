/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-05-22 12:33:07
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-03 08:33:32
 */
import 'package:flutter/material.dart';
import 'package:flutter_mfw/screen_adapter.dart';
import 'package:badges/badges.dart';
import 'package:flutter_mfw/pages/other/content_search.dart';
import 'package:flutter_mfw/pages/other/cities_select.dart';
import 'package:flutter_mfw/common/InfoNotify.dart';
import 'package:provider/provider.dart';
import 'package:amap_location/amap_location.dart'; //高德地图
// import 'package:simple_permissions/simple_permissions.dart';
import 'package:jhtoast/jhtoast.dart';
import 'package:flutter_mfw/models/location.dart';
import 'package:flutter_mfw/common/global.dart';

class HomeNavbarWidget extends StatefulWidget {
  @override
  _HomeNavbarWidgetState createState() => _HomeNavbarWidgetState();
}

class _HomeNavbarWidgetState extends State<HomeNavbarWidget> {
  LocsProvider locsProvider = new LocsProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

// 启动高德定位插件
  runAmap() async {
    await AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
  }

  // 方式一、直接获取定位信息
  getLocation() async {
    await runAmap();
    var locatioInfo = await AMapLocationClient.getLocation(true);
    print('获取定位成功'+ locatioInfo.formattedAddress);
    //更新城市provider
    Location location = Global.location;
    location.city = locatioInfo.city;
    location.province = locatioInfo.province;
    location.detailAddress = locatioInfo.formattedAddress;
    locsProvider.changeLoc(location);
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    //TODO:位置数据全局状态管理 provider
    return ChangeNotifierProvider<LocsProvider>(
      builder: (_) => locsProvider,
      child: Column(
        children: <Widget>[
          // Container(
          //   height: ScreenAdapter.getStatusBarHeight(),
          //   decoration:BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
          // ),
          //
          Container(
            width: double.infinity,
            height: ScreenAdapter.setHeight(
                167 + ScreenAdapter.getStatusBarHeight()),
            padding: EdgeInsets.fromLTRB(0, 27, 0, 10),
            child: SafeArea(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _selectCityWidget(),
                  _searchWidget(),
                  _messageWidget()
                ],
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(),
              image: DecorationImage(
                  image: AssetImage('assets/headerbg1.jpg'), fit: BoxFit.cover),
            ),
          )
        ],
      ),
    );
  }

  Widget _searchWidget() {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          //点击进入使用 searchDelegate实现的搜索页面
          // showSearch(context: context, delegate: SearchBarDelegate());
          showSearch(context: context, delegate: SearchBarDelegate());
        },
        child: Container(
          margin: EdgeInsets.only(left: 5.0),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 4.0),
          height: 38.0,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.search,
                color: Colors.grey,
              ),
              Text(
                '搜索优质真实旅游信息攻略',
                style: TextStyle(color: Colors.grey, fontSize: 14.0),
              )
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
        ),
      ),
    );
  }

  Widget _messageWidget() {
    return Padding(
        padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
        child: Badge(
          badgeContent: Text('3', style: TextStyle(color: Colors.white)),
          child: Icon(
            Icons.email,
            size: 30.0,
            color: Colors.white,
          ),
          showBadge: true, //控制是否显示
        ));
  }

  Widget _selectCityWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CitySelectPage('广州');
          }));
        },
        child: Row(
          children: <Widget>[
            // 局部小空间更新使用consumer消费者模式，减小。。。。
            Consumer<LocsProvider>(
              builder: (_, locs, __) {
                return Text(
                  locs.loc.city==null || locs.loc.city=="" ? '定位中...' :  locs.loc.city, //TODO城市。使用provider管理位置
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                );
              },
            ),

            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 25,
            )
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
     //注意这里关闭，页面销毁后关闭高德地图插件
    AMapLocationClient.shutdown();
    super.dispose();
  }
}

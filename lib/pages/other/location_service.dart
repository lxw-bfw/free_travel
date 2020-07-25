import 'package:flutter/material.dart';

import 'package:amap_location/amap_location.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter_mfw/screen_adapter.dart';
import 'package:jhtoast/jhtoast.dart';
import 'package:flutter_mfw/pages/other/map_search.dart';

//高德地图获取地理位置
//
class LocationPage extends StatefulWidget {
  LocationPage({Key key}) : super(key: key);
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  double longitude = 0.0;
  double latitude = 0.0;

  @override
  void initState() {
    super.initState();
    this._getLocation();
  }

  _getLocation() async {
    //启动一下
    await AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyBest));
    // 直接获取定位
    // var result = await AMapLocationClient.getLocation(true);
    // setState(() {
    //   this.longitude = result.longitude;   //经度
    //   this.latitude = result.latitude;   //纬度
    // });

    //获取地理位置（监听定位改变，同时位置改变自动更新）
    AMapLocationClient.onLocationUpate.listen((AMapLocation loc) {
      if (!mounted) return;
      setState(() {
        this.latitude = loc.latitude;
        this.longitude = loc.longitude;
        print('就是范德萨范德萨法大师傅大师傅');
      });
    });
    AMapLocationClient.startLocation();
  }

  @override
  void dispose() {
    //停止监听定位、销毁定位
    AMapLocationClient.stopLocation();
    AMapLocationClient.shutdown();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("查看地图"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 10),
          ),
          //显示地图
          Container(
            width: double.infinity,
            height: ScreenAdapter.setHeight(1000.0),
            child: Stack(
              children: <Widget>[
                AmapView(
                  mapType: MapType.Standard,
                  showZoomControl: false,
                  zoomLevel: 15,
                  centerCoordinate: LatLng(this.latitude, this.longitude),
                  onMapCreated: (controller) async {
                    await controller.showMyLocation(true);
                  },
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_searching),
        onPressed: () {
          // 有时候定位会出错或者是无法自动监听
          JhToast.showSuccess(context, msg: '进入周边查询页面');
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SelectLocationFromMapPage();
          }));
        },
      ),
    );
  }

  Widget LocationSearch() {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        //移除抽屉菜单顶部默认留白
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('哈哈哈'),
                  ),
                  Text(
                    "Wendux",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add account'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Manage accounts'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

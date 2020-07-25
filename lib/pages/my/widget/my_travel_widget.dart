/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-01 11:09:41
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-02 22:45:44
 */
import 'package:flutter_mfw/pages/my/widget/my_travel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mfw/screen_adapter.dart';
import 'package:amap_location/amap_location.dart'; //高德地图
// import 'package:simple_permissions/simple_permissions.dart';
import 'package:jhtoast/jhtoast.dart';
import 'package:flutter_mfw/pages/other/location_service.dart';


class MyTravelWidget extends StatefulWidget {
  @override
  _MyTravelWidgetState createState() => _MyTravelWidgetState();
}

class _MyTravelWidgetState extends State<MyTravelWidget> {
  var _loc = null;

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
    setState(() {
      _loc = locatioInfo.formattedAddress;
    });
    print('获取定位成功sssss' + locatioInfo.formattedAddress);
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      height: ScreenAdapter.setHeight(400),
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Stack(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                heightFactor: 2.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Ink(
                      child: InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          width: ScreenAdapter.setWidth(410),
                          height: ScreenAdapter.setHeight(118),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      // 重新定位
                                      setState(() {
                                        _loc = '                 重新定位中..';
                                        getLocation();
                                      });
                                    },
                                    child: Text(
                                      _loc == null ? '           定位中...' : _loc,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                            ],
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color.fromRGBO(254, 234, 128, 1.0)),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          child: Text(
                            "查看地图",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(0, 137, 251, 1.0)),
                          ),
                          onTap: () {
                            //
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return LocationPage();
                              
                            }));
                          },
                        )),
                  ],
                ),
              )),
          Positioned(
              left: 10,
              top: 10,
              child: Text("当前旅行足迹",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
        ],
      ),
    );
  }
}

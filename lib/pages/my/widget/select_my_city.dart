import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:amap_location/amap_location.dart'; //高德地图
// import 'package:simple_permissions/simple_permissions.dart';
import 'package:jhtoast/jhtoast.dart';
import 'package:flutter_mfw/common/InfoNotify.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mfw/common/global.dart';
import 'package:flutter_mfw/models/location.dart';
import 'package:flutter_mfw/pages/my/widget/search_my_address.dart';

class CityInfo extends ISuspensionBean {
  String name;
  String tagIndex;
  String namePinyin;

  CityInfo({
    this.name,
    this.tagIndex,
    this.namePinyin,
  });

  CityInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'] == null ? "" : json['name'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'tagIndex': tagIndex,
        'namePinyin': namePinyin,
        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex;

  @override
  String toString() => "CityBean {" + " \"name\":\"" + name + "\"" + '}';
}

class SelectMyCityPage extends StatefulWidget {

  String selectAddress ;
  

  @override
  State<StatefulWidget> createState() {
    return new _SelectMyCityPageState();
  }
}

class _SelectMyCityPageState extends State<SelectMyCityPage> {
  List<CityInfo> _cityList = List();
  List<CityInfo> _hotCityList = List();

  // 位置变量
  AMapLocation _loc; //初始化为null
  LocsProvider locsProvider = new LocsProvider();

  int _suspensionHeight = 40;
  int _itemHeight = 50;
  String _suspensionTag = "";

  @override
  void initState() {
    super.initState();
    loadData();
    // _checkPersmission();ss
    getLocation();
  }

  // 启动高德地图

  runAmap() async {
    await AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
  }

  // 方式一、直接获取定位信息
  getLocation() async {
    await runAmap();
    var locatioInfo = await AMapLocationClient.getLocation(true);
    print(locatioInfo.formattedAddress);
    //更新城市provider
    Location location = Global.location;
    location.city = locatioInfo.city;
    location.province = locatioInfo.province;
    location.detailAddress = locatioInfo.formattedAddress;
    locsProvider.changeLoc(location);
  }

  // 安卓6以后需要引导用户开启定位权限,开启后才可以使用定位功能
//  void _checkPersmission() async {
//     bool hasPermission =
//         await SimplePermissions.checkPermission(Permission.WhenInUseLocation);
//     if (!hasPermission) {
//       PermissionStatus requestPermissionResult =
//           await SimplePermissions.requestPermission(
//               Permission.WhenInUseLocation);
//       if (requestPermissionResult != PermissionStatus.authorized) {
//         JhToast.showError(context,msg: '获取定位权限失败');
//         return;
//       }
//     }
//     AMapLocation loc = await AMapLocationClient.getLocation(true);
//     setState(() {
//       _loc = loc;
//       print('定位成功:${_loc.formattedAddress}');
//     });
//   }

  void loadData() async {
    //加载城市列表
    rootBundle.loadString('assets/data/china.json').then((value) {
      Map countyMap = json.decode(value);
      List list = countyMap['china'];
      list.forEach((value) {
        _cityList.add(CityInfo(name: value['name']));
      });
      _handleList(_cityList);

      _hotCityList.add(CityInfo(name: "北京市", tagIndex: "热门"));
      _hotCityList.add(CityInfo(name: "广州市", tagIndex: "热门"));
      _hotCityList.add(CityInfo(name: "成都市", tagIndex: "热门"));
      _hotCityList.add(CityInfo(name: "深圳市", tagIndex: "热门"));
      _hotCityList.add(CityInfo(name: "杭州市", tagIndex: "热门"));
      _hotCityList.add(CityInfo(name: "武汉市", tagIndex: "热门"));

      setState(() {
        _suspensionTag = _hotCityList[0].getSuspensionTag();
      });
    });
  }

  void _handleList(List<CityInfo> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    SuspensionUtil.sortListBySuspensionTag(list);
  }

  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  ///构建悬停Widget.
  Widget _buildSusWidget(String susTag) {
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  ///构建列表 item Widget.
  Widget _buildListItem(CityInfo model) {
    return Column(
      children: <Widget>[
        Offstage(
          offstage: !(model.isShowSuspension == true),
          child: _buildSusWidget(model.getSuspensionTag()),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: ListTile(
            title: Text(model.name),
            onTap: () async{
              LogUtil.e("OnItemClick: $model");
              // 选择了LogUtil.e("OnItemClick: $model");
              // 选择了要查询的城市
              //更新城市provider
              // Location location = Global.location;
              // location.city = model.name;
              // locsProvider.changeLoc(location);
              // Location lModel = locsProvider.loc
              // 选择后进入具体的搜索页面
              // Navigator.pop(context, model);
             var result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchMyAddress(
                  selectCity: model.name,
                );
              }));
              print('我是返回值$result');
              Navigator.pop(context,result);
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocsProvider>(
      builder: (_) => locsProvider,
      child: Scaffold(
          appBar: new AppBar(
            title: new Text('选择城市'),
            centerTitle: true,
          ),
          body: new Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      height: 50.0,
                      child: Consumer<LocsProvider>(
                        builder: (_, locs, __) {
                          return Text("当前城市:${locs.loc.city}");
                        },
                      ),
                    ),
                    Ink(
                      height: 40,
                      width: 100,
                      // color: Colors.white,
                      child: InkWell(
                          // splashColor: Colors.greenAccent,
                          onTap: () async {
                            await getLocation();
                            JhToast.showSuccess(context, msg: '定位成功');
                          },
                          child: Center(
                            child: Text(
                              '重新定位',
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: new AzListView(
                    data: _cityList,
                    topData: _hotCityList,
                    itemBuilder: (context, model) => _buildListItem(model),
                    suspensionWidget: _buildSusWidget(_suspensionTag),
                    isUseRealIndex: true,
                    itemHeight: _itemHeight,
                    suspensionHeight: _suspensionHeight,
                    onSusTagChanged: _onSusTagChanged,
                  ))
            ],
          )),
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

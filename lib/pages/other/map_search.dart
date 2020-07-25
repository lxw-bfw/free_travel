import 'package:amap_map_fluttify/amap_map_fluttify.dart';

import 'package:flutter/material.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:jhtoast/jhtoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:amap_location/amap_location.dart';
import 'package:flutter/services.dart';
// import 'package:demo/resources/custom_text_style.dart';
// import 'package:demo/utils/misc.dart';

// import 'package:demo/widgets/network_state/page_loading.dart';

// 集成高德地图fluttter三款插件实现：定位当前城市，搜索周边POI比如搜索必胜客，酒店等。还有就是地图显示位置。

class SelectLocationFromMapPage extends StatefulWidget {
  @override
  _SelectLocationFromMapPageState createState() =>
      _SelectLocationFromMapPageState();
}

class _SelectLocationFromMapPageState extends State<SelectLocationFromMapPage> {
  // 位置变量，每次进入获取当前位置
  AMapLocation _loc; //初始化为null
  double longitude = 0.0;
  double latitude = 0.0;
  AmapController _controller;
  List<Poi> poiList;
  static List<PoiModel> list = new List();
  static List<PoiModel> searchlist = new List();
  PoiModel poiModel;
  String keyword = "";
  String address = "";
  bool isloading = true;

  @override
  void initState() {
    super.initState();
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
        _loc = loc;
        print('就是范德萨范德萨法大师傅大师傅');
      });
    });
    AMapLocationClient.startLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, //防止底部布局被顶起
      appBar: AppBar(
        title: Text(
          '查询周边位置信息',
          // style: CustomTextStyle.appBarTitleTextStyle,
        ),
        elevation: 0.0,
        centerTitle: true,
      ),

      body: Column(
        children: <Widget>[
          Theme(
            data: new ThemeData(
                primaryColor: Color(0xFFFFCA28), hintColor: Color(0xFFFFCA28)),
            child: Container(
              color: Color(0xFFFFCA28),
              padding: EdgeInsets.all(5),
              child: Container(
                height: 36,
                margin: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: TextField(
                  style: TextStyle(fontSize: 16, letterSpacing: 1.0),
                  controller: TextEditingController.fromValue(TextEditingValue(
                    // 设置内容
                    text: keyword,
                    selection: TextSelection.fromPosition(TextPosition(
                        affinity: TextAffinity.downstream,
                        offset: keyword?.length ?? 0)),
                    // 保持光标在最后
                  )),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    hintText: '输入关键字比如必胜客',
                    hintStyle:
                        TextStyle(color: Color(0xFFBEBEBE), fontSize: 14),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 1),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        keyword = "";
                        setState(() {});
                      },
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),

                  inputFormatters: [],
                  //内容改变的回调
                  onChanged: (text) {
                    print('change $text');
                    keyword = text;
                  },
                  //内容提交(按回车)的回调
                  onSubmitted: (text) {
                    print('submit $text');
                    // 触发关闭弹出来的键盘。
                    keyword = text;
                    setState(() {
                      isloading = true;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });

                    searchAroundAddress(text.toString());
                  },
                  //按回车时调用
                  onEditingComplete: () {
                    print('onEditingComplete');
                  },
                ),
              ),
            ),
          ),
          Container(
            height: 300,
            child: Stack(
              children: <Widget>[
                AmapView(
                  mapType: MapType.Standard,
                  showZoomControl: false,
                  centerCoordinate: LatLng(this.latitude, this.longitude),
                  maskDelay: Duration(milliseconds: 500),
                  zoomLevel: 16,
                  onMapCreated: (controller) async {
                    _controller = controller;
                    await controller.showMyLocation(true);
                    // if (await requestPermission()) {
                    //   await controller.showMyLocation(true);
                    //   await controller?.showLocateControl(true);
                    //   final latLng = await _controller?.getLocation(
                    //       delay: Duration(seconds: 2));
                    //   await enableFluttifyLog(false); // 关闭log
                    //   _loadData(latLng);
                    // }
                  },
                  onMapMoveEnd: (MapMove move) async {
                    _loadData(move.latLng);
                  },
                ),
                _loc == null
                    ? Center(
                        child: Icon(
                          Icons.place,
                          size: 36.0,
                          color: Color(0xFFFF0000),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Visibility(
              visible: !isloading,
              maintainSize: false,
              maintainSemantics: false,
              maintainInteractivity: false,
              replacement: Center(
                child: SpinKitSpinningCircle(
                  color: Color(0xffffde33),
                  size: 60.0,
                ),
              ),
              // replacement: PageLoading(),
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int position) {
                    print("itemBuilder" + list.length.toString());
                    PoiModel item = list[position];
                    return InkWell(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(top: 8, bottom: 5, left: 10),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.place,
                                  size: 20.0,
                                  color: position == 0
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                Text(item.title,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: position == 0
                                            ? Colors.green
                                            : Color(0xFF787878)))
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 5, bottom: 5, left: 18),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item.address,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF646464),
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                          )
                        ],
                      ),
                      onTap: () async {
                        // TODO: 点击之后弹出框，可以分享地址也可以直接复制地址。
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return _showNomalWid(context,item.address);
                            });
                        await _controller.setCenterCoordinate(
                            item.latLng.latitude, item.latLng.longitude,
                            zoomLevel: 16);
                        // Navigator.pop(context, {
                        //   'address': item.address,
                        // });
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void _loadData(LatLng latLng) async {
    setState(() {
      isloading = true;
    });

    /// 逆地理编码（坐标转地址）
    ReGeocode reGeocodeList = await AmapSearch.searchReGeocode(
      latLng,
    );

    print(await reGeocodeList.toFutureString());
    address = await reGeocodeList.formatAddress;

    final poiList = await AmapSearch.searchKeyword(
      address.toString(),
      city: _loc == null ? '广州' : _loc.city,
    );

    poiModel = new PoiModel("当前位置", address, latLng);
    list.clear();
    list.add(poiModel);
    for (var poi in poiList) {
      String title = await poi.title;
      String cityName = await poi.cityName;
      String provinceName = await poi.provinceName;
      String address = await poi.address;
      LatLng latLng = await poi.latLng;

      list.add(new PoiModel(
          title.toString(),
          provinceName.toString() + cityName.toString() + address.toString(),
          latLng));
    }

    setState(() {
      isloading = false;
    });
  }

  void searchAroundAddress(String text) async {
    //TODO: 搜索框搜索、POI搜索，比如输入必胜客或者是其他内容。搜索周边的POI
    final poiList = await AmapSearch.searchKeyword(
      text,
      city: _loc == null ? '广州' : _loc.city,
    );

    list.clear();
    list.add(poiModel);
    for (var poi in poiList) {
      String title = await poi.title;
      LatLng latLng = await poi.latLng;
      String cityName = await poi.cityName;
      String provinceName = await poi.provinceName;
      String address = await poi.address;
      list.add(new PoiModel(
          title.toString(),
          provinceName.toString() + cityName.toString() + address.toString(),
          latLng));
    }
    setState(() {
      isloading = false;
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  //
  @override
  void dispose() {
    // TODO: implement dispose
    AMapLocationClient.stopLocation();
    AMapLocationClient.shutdown();
    super.dispose();
  }

  Widget _showNomalWid(BuildContext context,String addressInfo) {
    // 需要的空间和名称
    // var ItemList  = List();// 不限定长度，不限定类型，可添加任意类型的数据
    var urlItems = ['wx', 'wxpyq',  'conect'];
    var nameItems = ['微信', '朋友圈', '复制地址'];

    return new Container(
      // alignment: Alignment.center,
      height: 150.0,
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
                  if (index != 2) {
                    JhToast.showInfo(context, msg: "该分享功能暂未实现");
                  } else {
                    // 赋值链接
                    Clipboard.setData(ClipboardData(text: addressInfo));
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

class PoiModel {
  LatLng latLng;
  String title;
  String address;

  PoiModel(this.title, this.address, this.latLng);
}

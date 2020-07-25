/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-03 12:52:22
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-04 10:20:47
 */
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mfw/models/strategy.dart';
import 'package:flutter/cupertino.dart';
import 'package:jhtoast/jhtoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_mfw/common/global.dart';
import 'package:amap_location/amap_location.dart'; //高德地图
import 'package:flutter_mfw/common/Http.dart';
import 'package:flutter_mfw/pages/other/cities_select.dart';
import 'package:flutter_mfw/pages/my/widget/search_my_address.dart';
import 'package:flutter_mfw/pages/publish/strategy/add_easy_article.dart';
import 'package:flutter_mfw/pages/publish/strategy/add_rich_article.dart';
import 'package:flutter_mfw/pages/publish/strategy/add_strategy_video.dart';

class AddStrategy extends StatefulWidget {
  AddStrategy({Key key}) : super(key: key);

  _AddStrategyState createState() => _AddStrategyState();
}

class _AddStrategyState extends State<AddStrategy> {
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  var _curentStep = 0;
  Strategy strategy = new Strategy();
  String _cameraImage;

  var tags = [
    {'isSelect': '0', 'content': '夏日主题'},
    {'isSelect': '0', 'content': '夏日主题'},
    {'isSelect': '0', 'content': '夏日主题'},
    {'isSelect': '0', 'content': '夏日主题'},
    {'isSelect': '0', 'content': '夏日主题'},
    {'isSelect': '0', 'content': '夏日主题'}
  ];

  var _cityController = new TextEditingController();
  var _placeController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    strategy.imgs = [];
    strategy.tags = [];
    super.initState();
    getTags();
  }

  // 查询主题标签
  void getTags() {
    var url = 'tag/findAll';
    var query = {'pageNum': 1, 'pageSize': 1000};
    Http.patchData(
        url,
        (result) {
          print(result['data']['data'].length);
          var resultList = result['data']['data'];
          setState(() {
            tags = [];
            for (var i = 0; i < resultList.length; i++) {
              tags.add(
                  {'isSelect': 'false', 'content': resultList[i]['content']});
            }
          });
        },
        params: query,
        errorCallBack: (err) {
          print(err);
        });
  }

  // 启动高德地图

  runAmap() async {
    await AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
  }

  // 方式一、直接获取定位信息，每次拍照上传进行一次定位，判断是否与你当前填写的攻略城市位置符合
  getLocation() async {
    await runAmap();
    var locatioInfo = await AMapLocationClient.getLocation(true);
    print(locatioInfo.formattedAddress);
    var adderssInfo = locatioInfo.formattedAddress;

    strategy.city =
        strategy.city == null || strategy.city == '' ? 'none' : strategy.city;
    print('成格式${strategy.city}');
    if (!adderssInfo.contains(strategy.city)) {
      return false;
    } else {
      return true;
    }
  }

  void nextStep() {
    print(_curentStep);

    if (_curentStep == 0) {
      if (loginKey.currentState.validate()) {
        setState(() {
          _curentStep = _curentStep + 1;
        });
        loginKey.currentState.save();
      }
    } else {
      if (_curentStep <= 1) {
        setState(() {
          _curentStep = _curentStep + 1;
        });
      }
    }
  }

  void _handleTap() {
    // 某个GestureDetector的事件

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => actionSheet(),
    ).then((value) {});
  }

  void _selectType() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => actionSheetSelectType(),
    ).then((value) {});
  }

  Future _getCameraImage() async {
    print('调用了: 打开相机');
    var image = await ImagePicker.pickImage(source: ImageSource.camera); // 使用相机

    setState(() {
      _uploadPic(image);
    });
  }

  Future _getGalleryImage() async {
    print('调用了: 打开相册');
    var image =
        await ImagePicker.pickImage(source: ImageSource.gallery); // 使用图库

    setState(() {
      _uploadPic(image);
    });
  }

  void _uploadPic(File imgfile) async {
    var loadingHide = JhToast.showLoadingText(context, msg: '上传中，请稍等...');

    FormData formData = new FormData.from({
      "name": "header",
      'file': new UploadFileInfo(imgfile, "imageFileName.jpg")
    });
    try {
      var url = Global.baserUrl + 'upload/uploadPic';
      var response = await Dio().post(url, data: formData);
      // 关闭
      loadingHide();
      JhToast.showSuccess(context, msg: '上传成功');
      print(jsonDecode(response.toString())['imgSrc']);
      setState(() {
        strategy.imgs.add(jsonDecode(response.toString())['imgSrc']);
      });
    } catch (e) {
      loadingHide();
      JhToast.showError(context, msg: '上传失败，请检查网络环境后稍后再试试');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.orange, //用于导航栏、FloatingActionButton的背景色等
        // iconTheme: IconThemeData(color: _themeColor) //用于Icon颜色
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('创建一个攻略'),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 15, 0),
                child: GestureDetector(
                  child: Text(
                    '下一步',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    // 弹出选择类型，保存攻略进入文章编辑
                    
                    _selectType();
                  },
                ))
          ],
        ),
        body: Stepper(
          currentStep: _curentStep, // <-- 激活的下标
          onStepContinue: nextStep,
          steps: <Step>[
            new Step(
              title: new Text('攻略基本信息'),
              content: StrategyFrom(),
              state: _curentStep == 0 ? StepState.editing : StepState.complete,
              isActive: _curentStep == 0,
              // subtitle: new Text('第一步小标题'),
            ),
            new Step(
                title: new Text('上传图片'),
                content: StrategyPic(),
                subtitle: Text('拍照上传的话会进行定位验证'),
                state:
                    _curentStep == 1 ? StepState.editing : StepState.complete,
                isActive: _curentStep == 1),
            new Step(
                title: new Text('选择主题标签'),
                content: selectTags(),
                state:
                    _curentStep == 2 ? StepState.editing : StepState.complete,
                isActive: _curentStep == 2),
          ],
        ),
      ),
    );
  }

  Widget StrategyFrom() {
    return Form(
      key: loginKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              // labelText: '请输入昵称',
              hintText: "攻略标题",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.fromLTRB(10, 13, 0, 0),
                child: Text(
                  '标 题:',
                  style: TextStyle(color: Color(0xffcccccc)),
                ),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "标题不能为空!";
              }
            },
            //当 Form 表单调用保存方法 Save时回调的函数。
            onSaved: (value) {
              strategy.title = value;
            },
            // 当用户确定已经完成编辑时触发
            onFieldSubmitted: (value) {},
          ),
          TextFormField(
            controller: _cityController,
            onTap: () async {
              //
              var result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return CitySelectPage('广州');
              }));
              print(result);
              _cityController.text = result;
              strategy.city = result;
            },
            decoration: InputDecoration(
              // labelText: '请输入昵称',
              hintText: "城市名称",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.fromLTRB(10, 13, 0, 0),
                child: Text(
                  '城 市:',
                  style: TextStyle(color: Color(0xffcccccc)),
                ),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "城市名称不能为空!";
              }
            },
            //当 Form 表单调用保存方法 Save时回调的函数。
            onSaved: (value) {
              strategy.city = value;
            },
            // 当用户确定已经完成编辑时触发
            onFieldSubmitted: (value) {},
          ),
          TextFormField(
            controller: _placeController,
            onTap: () async {
              //
              var result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return SearchMyAddress(
                  selectCity: strategy.city == '' || strategy.city == null
                      ? '广州'
                      : strategy.city,
                );
              }));
              print(result);
              _placeController.text = result;
            },
            decoration: InputDecoration(
              // labelText: '请输入昵称',
              hintText: "景点名称",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.fromLTRB(10, 13, 0, 0),
                child: Text(
                  '景 点:',
                  style: TextStyle(color: Color(0xffcccccc)),
                ),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "景点名称不能为空!";
              }
            },
            //当 Form 表单调用保存方法 Save时回调的函数。
            onSaved: (value) {
              strategy.placename = value;
            },
            // 当用户确定已经完成编辑时触发
            onFieldSubmitted: (value) {},
          ),
        ],
      ),
    );
  }

  Widget StrategyPic() {
    return Column(
      children: <Widget>[
        Column(children: picList()),
        RaisedButton.icon(
          icon: Icon(Icons.cloud_upload),
          label: Text("上传"),
          onPressed: () {
            _handleTap();
          },
        ),
      ],
    );
  }

  Widget selectTags() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisSpacing: 10.0, //水平子 Widget 之间间距
      mainAxisSpacing: 0.0, //垂直子 Widget 之间间距
      // padding: EdgeInsets.all(10),
      crossAxisCount: 3, //一行的 Widget 数量
      // childAspectRatio:0.7,  //宽度和高度的比例
      children: getListData(),
    );
  }

  List<Widget> getListData() {
    List<Widget> widgetList = [];
    for (var i = 0; i < tags.length; i++) {
      widgetList.add(ActionChip(
        backgroundColor:
            tags[i]['isSelect'] == 'true' ? Color(0xffff9d00) : null,
        label: Text(
          tags[i]['content'],
          style: TextStyle(
              color: tags[i]['isSelect'] == 'true' ? Color(0xffffffff) : null),
        ),
        onPressed: () {
          setState(() {
            if (tags[i]['isSelect'] == 'true') {
              tags[i]['isSelect'] = 'false';
              strategy.tags.remove(tags[i]['content']);
            } else {
              tags[i]['isSelect'] = 'true';
              strategy.tags.add(tags[i]['content']);
            }
          });
        },
      ));
    }
    return widgetList;
  }

  List<Widget> picList() {
    List<Widget> widgetList = [];
    for (var i = 0; i < strategy.imgs.length; i++) {
      widgetList.add(Container(
          child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 10),
              width: 300,
              height: 190,
              child: Image(
                image: NetworkImage(strategy.imgs[i]),
                fit: BoxFit.cover,
              )),
        ],
      )));
    }
    return widgetList;
  }

  Widget actionSheet() {
    return new CupertinoActionSheet(
      title: new Text(
        '选择图片',
        // style: descriptiveTextStyle,
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text(
            '打开相机拍照',
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'PingFangRegular',
            ),
          ),
          onPressed: () async {
            // 打开相机拍照
            var loadingHide = JhToast.showLoadingText(context, msg: '定位中...');
            var result = await getLocation();
            if (result) {
              loadingHide();
              _getCameraImage();
            } else {
              loadingHide();
              JhToast.showError(context,
                  msg: '当前拍照位置与填写信息不符合，请重新填写', closeTime: 2000);
            }

            // 关闭菜单
            Navigator.of(context).pop();
          },
        ),
        CupertinoActionSheetAction(
          child: const Text(
            '打开相册，选取照片',
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'PingFangRegular',
            ),
          ),
          onPressed: () {
            // 打开相册，选取照片
            _getGalleryImage();
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

  Widget actionSheetSelectType() {
    return new CupertinoActionSheet(
      title: new Text(
        '选择内容形式',
        // style: descriptiveTextStyle,
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text(
            '普通文本',
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'PingFangRegular',
            ),
          ),
          onPressed: () async {
            // 关闭菜单
            Navigator.of(context).pop();
            strategy.author = Global.user.nickname;
            strategy.puhlishid = Global.user.id;
            strategy.userHeader = Global.user.headerUrl;
            strategy.pendingState = '0';
            strategy.type = '1'; //表示文章
            // print(strategy.toJson());
            var lodingHide = JhToast.showLoadingText(context, msg: '创建攻略中...');
            var data = jsonEncode(strategy);
            var url = 'strategy/add';
            Http.postData(
                url,
                (result) {
                  lodingHide();
                  //TODO: 创建攻略成功进入文章页面最终文章创建好了才是真正攻略创建完成，此时往message表插入一条记录审核消息记录，管理员登录可以查看到
                  // 进入普通文章编辑页面

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddEasyArticle(
                      strategyId: result['data']['_id'],
                    );
                  }));
                },
                params: jsonDecode(data),
                errorCallBack: (error) {
                  print(error);
                  lodingHide();
                });
          },
        ),
        CupertinoActionSheetAction(
          child: const Text(
            '图文文章',
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'PingFangRegular',
            ),
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            strategy.author = Global.user.nickname;
            strategy.puhlishid = Global.user.id;
            strategy.userHeader = Global.user.headerUrl;
            strategy.pendingState = '0';
            strategy.type = '1'; //表示文章
            // print(strategy.toJson());
            var lodingHide = JhToast.showLoadingText(context, msg: '创建攻略中...');
            var data = jsonEncode(strategy);
            var url = 'strategy/add';
            Http.postData(
                url,
                (result) {
                  lodingHide();
                  //TODO: 创建攻略成功进入文章页面最终文章创建好了才是真正攻略创建完成，此时往message表插入一条记录审核消息记录，管理员登录可以查看到
                  // 进入普通文章编辑页面

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddRichArticle(
                      strategyId: result['data']['_id'],
                    );
                  }));
                },
                params: jsonDecode(data),
                errorCallBack: (error) {
                  print(error);
                  lodingHide();
                });
          },
        ),
        CupertinoActionSheetAction(
          child: const Text(
            '视频形式',
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'PingFangRegular',
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            strategy.author = Global.user.nickname;
            strategy.puhlishid = Global.user.id;
            strategy.userHeader = Global.user.headerUrl;
            strategy.pendingState = '0';
            strategy.type = '2'; //表示视频
            // print(strategy.toJson());
            var lodingHide = JhToast.showLoadingText(context, msg: '创建攻略中...');
            var data = jsonEncode(strategy);
            var url = 'strategy/add';
            Http.postData(
                url,
                (result) {
                  lodingHide();
                  //TODO: 创建攻略成功进入文章页面最终文章创建好了才是真正攻略创建完成，此时往message表插入一条记录审核消息记录，管理员登录可以查看到
                  // 进入普通文章编辑页面

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddStrategyVideo(
                      strategyId: result['data']['_id'],
                    );
                  }));
                },
                params: jsonDecode(data),
                errorCallBack: (error) {
                  print(error);
                  lodingHide();
                });
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

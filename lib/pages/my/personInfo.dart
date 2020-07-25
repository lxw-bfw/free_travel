/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-02 01:38:19
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-03 14:07:04
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:jhtoast/jhtoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_mfw/common/global.dart';
import 'package:flutter_mfw/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mfw/common/InfoNotify.dart';
import 'package:flutter_mfw/pages/my/widget/select_my_city.dart';
import 'package:flutter_mfw/common/Http.dart';

class PersonInfo extends StatefulWidget {
  PersonInfo({Key key}) : super(key: key);

  _PersonInfoState createState() => _PersonInfoState();
}

class _PersonInfoState extends State<PersonInfo> {
  // 声明一个list，存放image Widget

  // 用于实现响应更新和设置默认值TODO:
  UserModel userModel = UserModel();

  List<Widget> imageList = List();
  List<String> _imgUrls = []; // 存放图片路径
  String _imgurl; // 上传成功后返回图片访问路径，保存按钮点击后更新头像TODO:
  //全局 Key 用来获取 Form 表单组件
  DateTime selectedDate = DateTime.now();
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  //TODO:  默认值： 从状态管理h获取，更新成功后调用provider全局更新状态。
  // TOOD部分数使用表单把保存获取，部分不是
  var _nickNameController = new TextEditingController();
  var _sexController = new TextEditingController();
  var _birthdayeController = new TextEditingController();
  var _addressController = new TextEditingController();
  var _introduceController = new TextEditingController();
  var _accountController = new TextEditingController();

  // 创建一个对应的实体类,对应表单修改后保存内容
  User user = new User();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imgurl = userModel.user.headerUrl;
    _nickNameController.text = userModel.user.nickname;
    _sexController.text = userModel.user.sex;
    _birthdayeController.text = userModel.user.birthday;
    _addressController.text = userModel.user.address;
    _introduceController.text = userModel.user.introduce;
    _accountController.text =
        userModel.user.openid == '' || userModel.user.openid == null
            ? '未绑定'
            : '已绑定';

    user = userModel.user;
  }

  Future<void> _selectDate() async //异步

  {
    print('kkk');
    final DateTime date = await showDatePicker(
      //等待异步处理的结果
      //等待返回
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date == null) return; //点击DatePicker的cancel

    setState(() {
      //点击DatePicker的OK
      selectedDate = date;
      _birthdayeController.text = date.toString();
      user.birthday = date.toString();
      print(selectedDate);
    });
  }

  void save() {
    //读取当前 Form 状态
    var loginForm = loginKey.currentState;
    //验证 Form表单
    loginForm.save();
    // print('userName：' + userName);
    print(user.address);
    var data = {
      'headerUrl': user.headerUrl,
      'nickname': user.nickname,
      'sex': user.sex,
      'birthday': user.birthday,
      'address': user.address,
      'introduce': user.introduce
    };
    var url = 'user/' + userModel.user.id;
    // userModel._id
    var loadingHide = JhToast.showLoadingText(context, msg: '保存中...');
    Http.putData(
        url,
        (result) {
          loadingHide();
          print(result);
          JhToast.showSuccess(context,msg: '保存成功');
          // User user1 = User.fromJson(result['data']);
          // userModel.login(user1);
          // Navigator.pop(context);
          // print(result)
        },
        params: data,
        errorCallBack: (err) {
          loadingHide();
          print(err);
        });
  }

  File _cameraImage;
  File _galleryImage;

//相关操作

// 使用CupertinoActionSheet底部弹出...
// 从底部弹出CupertinoActionSheet使用showCupertinoModalPopup
  void _handleTap() {
    // 某个GestureDetector的事件

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => actionSheet(),
    ).then((value) {});
  }

  Future _getCameraImage() async {
    print('调用了: 打开相机');
    var image = await ImagePicker.pickImage(source: ImageSource.camera); // 使用相机

    setState(() {
      _cameraImage = image;
      print('_cameraImage: ' + _cameraImage.toString());
      _uploadPic(_cameraImage);
    });
  }

  Future _getGalleryImage() async {
    print('调用了: 打开相册');
    var image =
        await ImagePicker.pickImage(source: ImageSource.gallery); // 使用图库

    setState(() {
      _galleryImage = image;
      print('_galleryImage: ' + _galleryImage.toString());
      _uploadPic(_galleryImage);
    });
  }

  // 上传图片
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
      user.headerUrl = jsonDecode(response.toString())['imgSrc'];
      setState(() {
        _imgurl = jsonDecode(response.toString())['imgSrc'];
      });
    } catch (e) {
      loadingHide();
      JhToast.showError(context, msg: '上传失败，请检查网络环境后稍后再试试');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModel>(
      builder: (_) => userModel,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.keyboard_arrow_left, size: 40),
          ),
          title: Text(
            '设置个人信息',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                save();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  '保存',
                  style: TextStyle(color: Color(0xffcccccc), fontSize: 20),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                height: 220,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/usbg1.jpg'),
                        fit: BoxFit.cover)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _handleTap();
                      },
                      child: ClipOval(
                        child: _imgurl == '' || _imgurl == null
                            ? Image.asset(
                                'assets/deheader.jpeg',
                                width: 85.0,
                                height: 85.0,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                _imgurl,
                                width: 85.0,
                                height: 85.0,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                    )
                  ],
                )),
            Container(
              // height: 500,
              child: Form(
                key: loginKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _nickNameController,
                      decoration: InputDecoration(
                        // labelText: '请输入昵称',
                        hintText: "用户昵称",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(10, 13, 0, 0),
                          child: Text(
                            '昵 称:',
                            style: TextStyle(color: Color(0xffcccccc)),
                          ),
                        ),
                      ),

                      //当 Form 表单调用保存方法 Save时回调的函数。
                      onSaved: (value) {
                        user.nickname = value;
                      },
                      // 当用户确定已经完成编辑时触发
                      onFieldSubmitted: (value) {},
                    ),
                    TextFormField(
                      controller: _sexController,
                      decoration: InputDecoration(
                        // labelText: '请输入昵称',
                        hintText: "用户性别",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(10, 13, 0, 0),
                          child: Text(
                            '性 别:',
                            style: TextStyle(color: Color(0xffcccccc)),
                          ),
                        ),
                      ),

                      //当 Form 表单调用保存方法 Save时回调的函数。
                      onSaved: (value) {
                        user.sex = value;
                      },
                      // 当用户确定已经完成编辑时触发
                      onFieldSubmitted: (value) {},
                    ),
                    TextFormField(
                      onTap: _selectDate,
                      // enabled: false,
                      controller: _birthdayeController,
                      decoration: InputDecoration(
                        // labelText: '请输入昵称',
                        hintText: "用户生日",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(10, 13, 0, 0),
                          child: Text(
                            '省 日:',
                            style: TextStyle(color: Color(0xffcccccc)),
                          ),
                        ),
                      ),

                      //当 Form 表单调用保存方法 Save时回调的函数。
                      onSaved: (value) {
                        // user.sex = value;
                      },
                      // 当用户确定已经完成编辑时触发
                      onFieldSubmitted: (value) {},
                    ),
                    TextFormField(
                      onTap: () async {
                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SelectMyCityPage();
                            },
                          ),
                        );
                        //输出`TipRoute`路由返回结果
                        print("路由返回值: $result");
                        _addressController.text = result;
                        user.address = result;
                      },
                      // enabled: false,
                      controller: _addressController,
                      decoration: InputDecoration(
                        // labelText: '请输入昵称',
                        hintText: "用户常住地",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(10, 13, 0, 0),
                          child: Text(
                            '常住地:',
                            style: TextStyle(color: Color(0xffcccccc)),
                          ),
                        ),
                      ),

                      //当 Form 表单调用保存方法 Save时回调的函数。
                      onSaved: (value) {
                        // user.sex = value;
                      },
                      // 当用户确定已经完成编辑时触发
                      onFieldSubmitted: (value) {},
                    ),
                    TextFormField(
                      // enabled: false,
                      controller: _introduceController,
                      decoration: InputDecoration(
                        // labelText: '请输入昵称',
                        hintText: "用户简介",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(10, 13, 0, 0),
                          child: Text(
                            '简 介:',
                            style: TextStyle(color: Color(0xffcccccc)),
                          ),
                        ),
                      ),

                      //当 Form 表单调用保存方法 Save时回调的函数。
                      onSaved: (value) {
                        // user.sex = value;
                      },
                      // 当用户确定已经完成编辑时触发
                      onFieldSubmitted: (value) {},
                    ),
                    //TODO:第三方绑定：根据是否存在openbid进行判断
                    TextFormField(
                      enabled: false,
                      controller: _accountController,
                      decoration: InputDecoration(
                        // labelText: '请输入昵称',
                        hintText: "未绑定",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(10, 13, 0, 0),
                          child: Text(
                            '第三方账号:',
                            style: TextStyle(color: Color(0xffcccccc)),
                          ),
                        ),
                      ),

                      //当 Form 表单调用保存方法 Save时回调的函数。
                      onSaved: (value) {
                        // user.sex = value;
                      },
                      // 当用户确定已经完成编辑时触发
                      onFieldSubmitted: (value) {},
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 底部弹出菜单actionSheet
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
          onPressed: () {
            // 打开相机拍照
            _getCameraImage();
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
}

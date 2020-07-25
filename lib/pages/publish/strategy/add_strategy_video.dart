/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-04 01:53:20
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-05 09:15:24
 */
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:jhtoast/jhtoast.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_mfw/common/global.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_mfw/common/Http.dart';
import 'package:flutter_mfw/pages/publish/strategy/success_info.dart';
// import '';

class AddStrategyVideo extends StatefulWidget {
  AddStrategyVideo({Key key, this.strategyId}) : super(key: key);
  final String strategyId;
  _AddStrategyVideoState createState() => _AddStrategyVideoState();
}

class _AddStrategyVideoState extends State<AddStrategyVideo> {
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  String title;
  String videoSrc = '';
  bool _isPlaying = false;
  VideoPlayerController _controller;
  //  PermissionGroup permission;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void setOrInitvideo() {
    _controller = VideoPlayerController.network(this.videoSrc)
      // 播放状态
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      // 在初始化完成后必须更新界面
      ..initialize().then((_) {
        setState(() {});
      });
  }

  void _handleTap() {
    // 某个GestureDetector的事件

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => actionSheet(),
    ).then((value) {});
  }

/*选取视频*/
  _getVideo() async {
    var image = await ImagePicker.pickVideo(source: ImageSource.gallery);
    print('选取视频：' + image.toString());
    setState(() {
      _uploadPic(image);
    });
  }

/*拍摄视频*/
  _takeVideo() async {
    var image = await ImagePicker.pickVideo(source: ImageSource.camera);
    print('拍摄视频：' + image.toString());
    _uploadPic(image);
  }

  void _uploadPic(File imgfile) async {
    var loadingHide = JhToast.showLoadingText(context, msg: '上传中，请稍等...');

    FormData formData = new FormData.from({
      "name": "video",
      'file': new UploadFileInfo(imgfile, "imageFileName.mp3")
    });
    try {
      var url = Global.baserUrl + 'upload/uploadVideo';
      var response = await Dio().post(url, data: formData);
      // 关闭
      loadingHide();
      JhToast.showSuccess(context, msg: '上传成功');
      print(response);
      print(jsonDecode(response.toString())['videoSrc']);
      setState(() {
        this.videoSrc = jsonDecode(response.toString())['videoSrc'];
        setOrInitvideo();
      });
    } catch (e) {
      loadingHide();
      JhToast.showError(context, msg: '上传失败，请检查网络环境后稍后再试试');
    }
  }

  Future _openAlertDialog() async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false, //// user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('是否发布?'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context, 'cancel');
              },
            ),
            FlatButton(
              child: Text('确认'),
              onPressed: () {
                Navigator.pop(context, 'ok');
              },
            ),
          ],
        );
      },
    );
    print(action);
    if (action == 'ok') {
      if (loginKey.currentState.validate()) {
        loginKey.currentState.save();
        print(title);
        var data = {
          'title': title=='' ||  title == null? '无题' : title,
          'url': this.videoSrc,
          'strategyid': widget.strategyId
        };
        var url = 'video/add';
        var loadinHide = JhToast.showLoadingText(context, msg: '发布中...');
        Http.postData(
            url,
            (result) {
              // 给系统管理员发送消息
              var mData = {
                'receiverType': 1,
                'publishId': Global.user.id,
                'publisher': Global.user.nickname,
                'title': '用户攻略审核',
                'content': '用户端发布了一个视频攻略'
              };
              var url = 'message/add';
              Http.postData(
                  url,
                  (result1) {
                    loadinHide();
                    print(result1);
                    // 进入提示页面
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SuccseeInfo();
                    }));
                  },
                  params: mData,
                  errorCallBack: (err) {
                    loadinHide();
                    print(err);
                  });
            },
            params: data,
            errorCallBack: (err) {
              print(err);
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('上传视频'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: ActionChip(
              backgroundColor: Color(0xffff9d00),
              onPressed: () {
                // 确认框
                _openAlertDialog();
              },
              label: Text(
                '发布',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Form(
              key: loginKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      // labelText: '请输入昵称',
                      hintText: "添加视频标题，观看视频的时候更明确(选填)",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                    //当 Form 表单调用保存方法 Save时回调的函数。
                    onSaved: (value) {
                      title = value;
                    },
                    // 当用户确定已经完成编辑时触发
                    onFieldSubmitted: (value) {},
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            videoSrc == ''
                ? Container()
                : Center(
                    child: _controller.value.initialized
                        ? new GestureDetector(
                            onTap: () {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            },
                            child: Container(
                              height: 600,
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              ),
                            ))
                        : Container())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          //悬浮按钮
          child: Icon(Icons.video_library),
          onPressed: () async {
            _handleTap();
          }),
    );
  }

  Widget actionSheet() {
    return new CupertinoActionSheet(
      title: new Text(
        '选择视频',
        // style: descriptiveTextStyle,
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text(
            '拍摄视频',
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'PingFangRegular',
            ),
          ),
          onPressed: () async {
            // 打开相机拍照
            var loadingHide = JhToast.showLoadingText(context, msg: '定位中...');
            Future.delayed(Duration(seconds: 1), () {
              loadingHide();
              _takeVideo();
            });

            // 关闭菜单
            Navigator.of(context).pop();
          },
        ),
        CupertinoActionSheetAction(
          child: const Text(
            '打开文件夹，选取视频',
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'PingFangRegular',
            ),
          ),
          onPressed: () {
            // 打开相册，选取照片

            _getVideo();
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

/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-03 17:54:00
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-03 21:16:29
 */
import 'package:flutter/material.dart';
import 'package:flutter_mfw/common/Http.dart';
import 'package:flutter_mfw/common/global.dart';
import 'package:jhtoast/jhtoast.dart';
import 'package:flutter_mfw/pages/publish/strategy/success_info.dart';

class AddEasyArticle extends StatefulWidget {
  AddEasyArticle({Key key, this.strategyId}) : super(key: key);

  final String strategyId;

  _AddEasyArticleState createState() => _AddEasyArticleState();
}

class _AddEasyArticleState extends State<AddEasyArticle> {
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  String title;
  String content;

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
          'title': title,
          'content': content,
          'strategyid': widget.strategyId
        };
        var url = 'article/add';
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
                'content': '用户端发布了一个攻略'
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
        title: Text('编辑攻略文章'),
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
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Form(
              key: loginKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      // labelText: '请输入昵称',
                      hintText: "添加文章标题，观看文章的时候更明确(选填)",
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
                  TextFormField(
                    maxLines: 500,
                    decoration: InputDecoration(
                      // labelText: '请输入昵称',
                      hintText: "文章主体内容(不限制字数、不带格式~)",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "文章内容不能为空!";
                      }
                    },
                    //当 Form 表单调用保存方法 Save时回调的函数。
                    onSaved: (value) {
                      content = value;
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
    );
  }
}

/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-03 21:13:19
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-04 14:15:35
 */
import 'package:flutter/material.dart';

class SuccseeInfo extends StatefulWidget {
  SuccseeInfo({Key key}) : super(key: key);

  _SuccseeInfoState createState() => _SuccseeInfoState();
}

class _SuccseeInfoState extends State<SuccseeInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.book), Text('发布成功，请等待管理员审核...')],
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: OutlineButton(
                      child: Text("返回首页"),
                      onPressed: () {
                        Navigator.pushNamed(context, "/");
                      },
                    ))
              ],
            )));
  }
}

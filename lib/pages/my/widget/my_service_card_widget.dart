/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-01 11:09:41
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-05 11:40:49
 */ 
import 'package:flutter/material.dart';
import 'package:flutter_mfw/screen_adapter.dart';

import 'package:flutter_mfw/dao/my_dao.dart';

import 'package:flutter_mfw/model/my_channel_model.dart';

import 'package:flutter_mfw/pages/my/my_strategy.dart';
import 'package:flutter_mfw/pages/my/widget/travel_time_line.dart';
class MyServiceCardWidget extends StatefulWidget {
  @override
  _MyServiceCardWidgetState createState() => _MyServiceCardWidgetState();
}

class _MyServiceCardWidgetState extends State<MyServiceCardWidget> {

  var _list = <MyChannelModelDataNormalChannel>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getListData();
  }

  void _getListData(){

    MyChannelDao.fetch().then((result){
      setState(() {
        _list = result.data.normalChannels;
      });

    }).catchError((error){
      print(error);
    });
  }


  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    if(_list.length == 0){
      return Center(
        child:  Text("正在加载"),
      );
    }
    return Container(
      height:  ScreenAdapter.setHeight(650),
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
       Padding(
         padding: EdgeInsets.only(top: 10,left: 10,bottom: 20),
         child: Text("其他内容",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
       ),

      Container(


        height: ScreenAdapter.setHeight(520),

        child: _gridService()
       )
        ],
      ),
    );
  }

  Widget _gridService(){
    var list = ['我的攻略','我的游记','我的足迹','我的商品','我的订单','暂无开放','暂无开放','暂无开放','暂无开放','暂无开放','暂无开放','暂无开放'];

    return GridView.count(
        crossAxisCount: 4,
      physics: NeverScrollableScrollPhysics(),
      children: list.map((item){

        return _itemService(item);
      }).toList()
    );
  }

  Widget _itemService(String item){
    return GestureDetector(
      onTap: (){
        if (item == '我的攻略') {
            Navigator.push( context,
           MaterialPageRoute(builder: (context) {
              return MyStrategy();
           }));
        } else if(item == '我的足迹') {
            Navigator.push( context,
           MaterialPageRoute(builder: (context) {
              return TimeLinePage();
           }));
        }
      },
      child: Column(
      children: <Widget>[
        Icon(Icons.history,color: Colors.orangeAccent,size: 40,),
        
        Text(item)
      ],
    ),
    );
  }
}

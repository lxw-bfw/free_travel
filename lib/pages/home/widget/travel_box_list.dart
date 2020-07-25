/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-05-31 16:30:22
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-04 18:17:20
 */
import 'package:flutter/material.dart';
import 'package:jhtoast/jhtoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_mfw/pages/detail/travel_home_detail.dart';

class TravelBoxList extends StatefulWidget {
  TravelBoxList({Key key}) : super(key: key);

  _TravelBoxListState createState() => _TravelBoxListState();
}

class _TravelBoxListState extends State<TravelBoxList> {
  static const loadingTag = "##loading##"; //表尾标记
  var _words = [];
  var isLoad = true;

  @override
  void initState() {
    // TODO: implement initState
    _retrieveData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _words.length,
      itemBuilder: (context, index) {
        return boxItem(index);
      },
      separatorBuilder: (context, index) => Divider(height: 1),
    );
  }

  void _retrieveData() {
    Future.delayed(Duration(seconds: 3)).then((e) {
      setState(() {
        //重新构建列表
        isLoad = false;
        for (var i = 0; i < 20; i++) {
          _words.insert(i, '随机字母');
        }
      });
    });
  }

  Widget boxItem(int index) {
    return isLoad
        ? Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: SpinKitSpinningCircle(
                color: Color(0xffffde33),
                size: 60.0,
              ),
            ),
          )
        : _words.length == 0
            ? Container(
                width: double.infinity,
                height: double.infinity,
                child: Center(child: Text('没有搜到结果，看看别的吧')),
              )
            : InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  //TODO:
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TravelHomeDetail();
                  }));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  height: 180,
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 30),
                                  child: Text(
                                    '二刷泸沽湖，贩卖星空，从“绕道”重庆开始fdsfs',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    ClipOval(
                                      child: new Image.asset(
                                        'assets/deheader.jpeg',
                                        width: 40.0,
                                        height: 40.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 5),
                                      child: Text(
                                        '海贼王',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                      child: Text(
                                        '在广州',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: new Image.asset(
                                  'assets/travelBox.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text('星级游记'),
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xffcccccc),
                                              width: .5),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      padding: EdgeInsets.all(2),
                                      child: Text('适合多刷的旅行地'),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xffcccccc),
                                              width: .5),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                    )
                                  ],
                                ),
                              )),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.remove_red_eye),
                                      Text('100')
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.message),
                                    Text('80')
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
  }
}

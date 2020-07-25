/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-05 11:35:55
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-05 11:51:36
 */
import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

class TimeLinePage extends StatefulWidget {
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的旅行足迹'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 2.0,
          vertical: 10.0,
        ),
        child: ListView(
          children: <Widget>[
            Calendar(
              onSelectedRangeChange: (range) =>
                  print("Range is ${range.item1}, ${range.item2}"),
              onDateSelected: (date) => handleNewDate(date),
            ),
            Divider(
              height: 50.0,
            ),
            _buildTimeLine('汕头-2020/03/10'),
            _buildTimeLine('广州-2020/03/10'),
            _buildTimeLine('潮州-2020/03/10'),
            _buildTimeLine('湛江-2020/03/10'),
          ],
        ),
      ),
    );
  }

  /// handle new date selected event
  void handleNewDate(date) {}

  Widget _buildTimeLine(String message) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Card(
            margin: EdgeInsets.all(20.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              width: double.infinity,
              child: Text(message),
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          bottom: 0.0,
          left: 35.0,
          child: Container(
            height: double.infinity,
            width: 2.0,
            color: Colors.blue,
          ),
        ),
        Positioned(
          top: 13.0,
          left: 22.5,
          child: Container(
            height: 26.0,
            width: 26.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.lightGreen,
            ),
            child: Container(
              margin: EdgeInsets.all(3.0),
              height: 26.0,
              width: 26.0,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            ),
          ),
        )
      ],
    );
  }
}

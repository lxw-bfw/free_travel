/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-05-22 12:33:07
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-04 21:56:32
 */
import 'package:flutter/material.dart';
import 'package:flutter_mfw/screen_adapter.dart';

class DetailBottomBarWidget extends StatefulWidget {
  DetailBottomBarWidget(
      {this.commentClick,
      this.loveClick,
      this.collectClick,
      this.tuijianClick,
      this.startNum,
      this.isLove,
      this.isColect,
      this.collectNum});
  Function commentClick, loveClick, collectClick, tuijianClick;
  int startNum;
  bool isLove;
  bool isColect;
  int collectNum;

  @override
  _DetailBottomBarWidgetState createState() => _DetailBottomBarWidgetState();
}

class _DetailBottomBarWidgetState extends State<DetailBottomBarWidget> {
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(249, 249, 249, 1.0),
          offset: Offset(0, -5), //阴影xy轴偏移量
          blurRadius: 1.0, //
        ),
      ]),
      height: ScreenAdapter.setHeight(120),
      child: _bottom(),
    );
  }

  Widget _bottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.message,),
              Text(
                '10',
                style: TextStyle(fontWeight: FontWeight.w600),
              )
            ],
          ),
          onTap: () {
            widget.commentClick();
          },
        ),
        GestureDetector(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.isLove?
              Icon(Icons.favorite_border,color:  Color(0xffff9d00))
              :Icon(Icons.favorite_border,),
              Text(
                widget.startNum.toString(),
                style: TextStyle(fontWeight: FontWeight.w600),
              )
            ],
          ),
          onTap: () {
            widget.loveClick();
          },
        ),
        GestureDetector(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.isColect?
              Icon(Icons.star_border,color:  Color(0xffff9d00))
              :Icon(Icons.star_border,),
              Text(
                '1',
                style: TextStyle(fontWeight: FontWeight.w600),
              )
            ],
          ),
          onTap: () {
            widget.collectClick();
          },
        ),
        GestureDetector(
          child: _button(),
          onTap: () {
            widget.tuijianClick();
          },
        ),
      ],
    );
  }

  Widget _button() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
      decoration: BoxDecoration(
          color: Colors.yellow, borderRadius: BorderRadius.circular(30)),
      child: Text(
        "相关推荐",
        style: TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _icon(icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon),
        Text(
          widget.startNum.toString(),
          style: TextStyle(fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}

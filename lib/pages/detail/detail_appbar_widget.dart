/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-05-22 12:33:07
 * @LastEditors: lxw
 * @LastEditTime: 2020-05-31 13:22:25
 */
import 'package:flutter/material.dart';
import 'package:flutter_mfw/screen_adapter.dart';
import 'package:flutter_mfw/model/travel_detail_model.dart';

class DetailAppbarWidget extends StatefulWidget {
  OwnerModel owner;
  DetailAppbarWidget({Key key, this.owner}) : super(key: key);
  @override
  _DetailAppbarWidgetState createState() => _DetailAppbarWidgetState();
}

class _DetailAppbarWidgetState extends State<DetailAppbarWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.owner == null) {
      return Text("");
    }
    ScreenAdapter.init(context);

    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
// TODO:进入到用户主页，使用sliverapp
            Navigator.of(context)
                .pushNamed("/user_detail",arguments: {'id':123});
          },
          child: ClipRRect(
              borderRadius: BorderRadius.circular(ScreenAdapter.setWidth(30)),
              child: Image.network(
                "${widget.owner.logo}",
                width: ScreenAdapter.setWidth(60),
                height: ScreenAdapter.setHeight(60),
              )),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "${widget.owner.name}",
            style: TextStyle(fontSize: 16),
          ),
        ),
        // Container(
        //   margin: EdgeInsets.only(left: 10),
        //   padding: EdgeInsets.only(right: 5),
        //   decoration: BoxDecoration(
        //       color: Color.fromRGBO(221, 224, 243, 1.0),
        //       borderRadius: BorderRadius.circular(10)),
        //   child: Row(
        //     children: <Widget>[
        //       Image.network(
        //         "${widget.owner.footprint_asset_tag.icon}",
        //         width: ScreenAdapter.setWidth(40),
        //         height: ScreenAdapter.setHeight(40),
        //       ),
        //       Text("${widget.owner.footprint_asset_tag.text}",
        //           style: TextStyle(
        //               fontSize: 12, color: Color.fromRGBO(99, 100, 159, 1.0)))
        //     ],
        //   ),
        // )
      ],
    );
  }
}

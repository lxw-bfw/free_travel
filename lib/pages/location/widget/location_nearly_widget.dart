import 'package:flutter/material.dart';
import 'package:flutter_mfw/screen_adapter.dart';
import 'package:flutter_mfw/model/location_model.dart';
class LocationNearlyWidget extends StatefulWidget {

  DataNavModel nearlyNavModel;


  LocationNearlyWidget({Key key,this.nearlyNavModel}) : super(key:key);


  @override
  _LocationNearlyWidgetState createState() => _LocationNearlyWidgetState();
}

class _LocationNearlyWidgetState extends State<LocationNearlyWidget> {
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    if(widget.nearlyNavModel == null || widget.nearlyNavModel.title == null){
      return Text("");
    }
    return Container(
      width: double.infinity,
  
      height: ScreenAdapter.setHeight(530),
      child: Container(
        child: Column(
                children: <Widget>[
                  _titleWidget(),
                  _nearlyListWidget(),
                  _nearlyPeopleWidget()
                ],
        ),
        margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
        decoration: BoxDecoration(
          
          boxShadow: [
            BoxShadow(
              color:Color.fromRGBO(224, 224, 224, 1.0),
              offset: Offset(0, 2), //阴影xy轴偏移量
              blurRadius: 2.0, //阴影模糊程度

            )
          ],
          color: Color.fromRGBO(251, 251, 251, 1.0),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Color.fromRGBO(224, 224, 224, 1.0),width: 0.2)
        ),
      ),
    );
  }


  //5792人也在附近
  Widget _nearlyPeopleWidget(){

    return Container(
    height: ScreenAdapter.setHeight(160),
    color: Color.fromRGBO(249, 249, 249, 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _nearlyLeftPerson(),
            _nearlyLookButton()
          ],
      ),
    );
  }

  Widget _nearlyLeftPerson(){

    return Row(
        children: <Widget>[
          _nearlyAnimation(),
          _nearlyText()
        ],
    );

  }

  Widget _nearlyAnimation(){

    return  Stack(
      children: <Widget>[
    Container(
       alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      width: ScreenAdapter.setWidth(150),
      height: ScreenAdapter.setHeight(150),
      decoration: BoxDecoration(
          color: Color.fromRGBO(243, 245, 250, 0.5),
          borderRadius: BorderRadius.circular( ScreenAdapter.setWidth(75))
      ),
      child:  Container(
        width: ScreenAdapter.setWidth(100),
        height: ScreenAdapter.setHeight(100),
        decoration: BoxDecoration(
            color: Color.fromRGBO(235, 245, 251, 0.7),
            borderRadius: BorderRadius.circular( ScreenAdapter.setWidth(50))
        ),
      ),
    )

      ],
    );
  }
  Widget _nearlyText(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: Text("${widget.nearlyNavModel.wengInfo.title}",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
        ),
        Text("${widget.nearlyNavModel.wengInfo.subtitle}",style: TextStyle(color:Color.fromRGBO(156, 156, 156, 1.0),fontSize: 12 ))
      ],
    );

  }
  Widget _nearlyLookButton(){

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
     // width: ScreenAdapter.setWidth(140),
        height: ScreenAdapter.setHeight(60),
        child: Text("去看看",style: TextStyle(color: Color.fromRGBO(81, 153, 251, 1.0))),
        decoration: BoxDecoration(
          color: Colors.white,
         border: Border.all(color: Color.fromRGBO(227, 227, 227, 1.0),width: 0.5),
          borderRadius: BorderRadius.circular(30)
        ),
      
    );
  }
  //附近景点
  Widget _nearlyListWidget(){

    var index = 0;
    return Container(
      margin: EdgeInsets.only(top: 5),
      height: ScreenAdapter.setHeight(225),
      width: double.infinity,
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        scrollDirection: Axis.horizontal,
        children: widget.nearlyNavModel.listNavModel.map((item){
          index++;

          return  _nearlyItemWidget(index,item.title,item.subtitle,item.desc,item.thumbnail);

        }).toList()
      ),

    );
  }

  //每一个景点选项
  Widget _nearlyItemWidget(index,title,subTitle,desc,thumbnail){
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network("${thumbnail}",
                width: ScreenAdapter.setWidth(186),
                height: ScreenAdapter.setHeight(135),
                fit:BoxFit.cover,),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(2, 2, 4, 2),
             decoration: BoxDecoration(

               color: index == 1 ? Color.fromRGBO(254, 217, 63, 1.0) : Color.fromRGBO(0, 0, 0, 0.5),
               borderRadius: BorderRadius.only(topLeft:Radius.circular(5),bottomRight:Radius.circular(8))
             ),
              child: Text("${desc}",style: TextStyle(fontSize: 10,color: index == 1 ? Colors.black : Colors.white)),
            )
          ],
        ),
        Padding(
            padding: EdgeInsets.only(top: 2),
            child: LimitedBox(
              maxWidth:  ScreenAdapter.setWidth(186),
              child: Text("${title}",textAlign:TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,

              ),
            )
        ),
        Text("${subTitle}",style: TextStyle(fontSize: 10,color: Color.fromRGBO(151, 151, 151, 1.0)),)
      ],
    ));
  }

  //查看更多
  Widget _checkMoreItemWidget(){
    return Container(
      width: ScreenAdapter.setWidth(186),
      height: ScreenAdapter.setHeight(40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromRGBO(245, 246, 248, 1.0)
        ),
    );
  }

  //我的附近 地图
  Widget _titleWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text("${widget.nearlyNavModel.title}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600)),
        ),

        Container(
          width: ScreenAdapter.setWidth(120),
          height: ScreenAdapter.setHeight(50),
          margin: EdgeInsets.only(right: 10),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
          ),
          child:  Row(
            children: <Widget>[
             Padding(padding:EdgeInsets.only(left: 10),child: Icon(Icons.local_library,size: 15)),
              Text("${widget.nearlyNavModel.navTitle}",style: TextStyle(fontSize: 10))
            ],
          ),
        )
      ],
    );
  }
}

/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-05-22 12:33:07
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-04 17:35:44
 */
import 'package:flutter/material.dart';
import 'package:flutter_mfw/screen_adapter.dart';

import 'package:flutter_mfw/dao/home_dao.dart';
import 'package:flutter_mfw/model/home_main_icon_model.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_mfw/common/Http.dart';

class HomeTopNavWidget extends StatefulWidget {
  @override
  _HomeTopNavWidgetState createState() => _HomeTopNavWidgetState();
}

class _HomeTopNavWidgetState extends State<HomeTopNavWidget> {
  // List swiperDataList = [
  //   "https://dss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3478651888,3887713748&fm=26&gp=0.jpg",
  //   "http://p1-q.mafengwo.net/s11/M00/26/3C/wKgBEFtqc3OANigWAAKO5iLzoHY14.jpeg?imageMogr2%2Fthumbnail%2F%21440x260r%2Fgravity%2FCenter%2Fcrop%2F%21440x260%2Fquality%2F100",
  //   "https://dss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=112580528,877439551&fm=26&gp=0.jpg"
  // ];

  List<dynamic> swiperDataList = [];

  // 查询轮播模块，现在默认点赞数最高的3个攻略

  void searchCarous() async {
    var url = 'strategy/findByOrder';
    var query = {'pageNum': 1, 'pageSize': 3};
    Http.patchData(
        url,
        (result) {
          // print(result);
          
          setState(() {
            swiperDataList = result['data']['data'];
            print(swiperDataList[0]['imgs']);
          });
          // var resultList = result['data']['data'];
          // setState(() {
          //   tags = [];
          //   for (var i = 0; i < resultList.length; i++) {
          //     tags.add(
          //         {'isSelect': 'false', 'content': resultList[i]['content']});
          //   }
          // });
        },
        params: query,
        errorCallBack: (err) {
          print(err);
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchCarous();
    // _getData();
  }
  // _getData(){
  //   MainIconDao.fetch().then((result){
  //     setState(() {
  //       // _list = result.data.mainIcons.listWithColor;
  //     });

  //   }).catchError((error){

  //   });
  // }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Stack(
      children: <Widget>[
        Container(
          height: ScreenAdapter.setHeight(280),
          width: double.infinity,
          child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: SwiperWidget()),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 1,
          child: Container(
            color: Color.fromRGBO(245, 247, 248, 1),
          ),
        )
      ],
    );
  }

  // Widget _navRowWidget(){

  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,

  //     children: _list.map((item){

  //       return  _navItemWidget(item.icon,item.title);
  //     }).toList()
  //   );
  // }

  Widget _navItemWidget(String image, String title) {
    return Column(
      children: <Widget>[
        Image.network(image,
            width: ScreenAdapter.setWidth(100),
            height: ScreenAdapter.setHeight(100)),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text("${title}",
              style: TextStyle(
                  fontSize: 13, color: Color.fromRGBO(120, 120, 120, 1.0))),
        )
      ],
    );
  }

  //封装轮播控件类
  Widget SwiperWidget() {
    return Container(
      height: 140,
      //圆角效果
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black12, offset: Offset(0.0, 4.0), blurRadius: 4.0),
        ],
        borderRadius: BorderRadius.circular(8.0), //3像素圆角
      ),
      child: Swiper(
          itemCount: swiperDataList.length,
          itemBuilder: _swiperBuilder,
          //分页指示器
          pagination: SwiperPagination(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 10),
              builder: DotSwiperPaginationBuilder(
                  color: Colors.white70,
                  activeColor: Color.fromRGBO(253, 219, 69, 1.0),
                  space: 2,
                  activeSize: 12)),
          controller: SwiperController(),
          scrollDirection: Axis.horizontal,
          autoplay: true,
          onTap: (index) {
            print(swiperDataList[index]);
            Navigator.of(context).pushNamed("/travel_detail_widget",
                arguments: swiperDataList[index]);
          }),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    //对轮播的图片组件进行美化：圆角边框加阴影
    return Container(
      child: Stack(
        children: <Widget>[
          FadeInImage(
            width: double.infinity,
            placeholder: AssetImage('assets/placehold1.png'),
            image: NetworkImage(swiperDataList[index]['imgs'][0]),
            fit: BoxFit.cover,
          ),
          Container(
            alignment: Alignment.bottomLeft,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
              child: Text(
                swiperDataList[index]['title'],
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      )),
    );
    // Container(
    //   alignment: Alignment.bottomLeft,
    //   decoration: BoxDecoration(
    //     image: DecorationImage(
    //         image: NetworkImage(swiperDataList[index]), fit: BoxFit.cover),
    //     borderRadius: BorderRadius.all(
    //       Radius.circular(8.0),
    //     ),
    //   ),
    //   child: Padding(
    //     padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
    //     child: Text('长隆一日游',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
    //   )
    // );
  }
}

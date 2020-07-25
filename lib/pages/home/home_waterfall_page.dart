import 'package:flutter/material.dart';

import 'package:flutter_mfw/dao/home_dao.dart';
import 'package:flutter_mfw/model/hote_model.dart';
import 'package:flutter_mfw/model/waterfall_model.dart';
import 'package:flutter_mfw/pages/home/widget/travel_box_list.dart';
import 'package:flutter_mfw/pages/home/waterfall_widget/water_fallItem_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutter_mfw/pages/home/widget/home_hote_topic_widget.dart';
import 'package:flutter_mfw/screen_adapter.dart';
import 'package:flutter_mfw/pages/detail/travel_detail_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_mfw/common/Http.dart';
import 'package:flutter_mfw/pages/detail/strategy_vide.dart';

//  根据分类查询显示的内容瀑布流布局页面，比如查询当地周边的攻略和游记。

class HomeWaterfallPage extends StatefulWidget {
  var id;

//  话题标签，只有点击推荐栏目的时候会查询出所有的话题标签
  var hoteList = <HoteItemModel>[];

  //  id 57 54 55 都查询推荐攻略，也就是分页查询攻略按点赞数目进行排序

  var animation = false;

  final String strId;

  HomeWaterfallPage(
      {Key key, this.id, this.hoteList, this.animation, this.strId})
      : super(key: key);

  @override
  _HomeWaterfallPageState createState() => _HomeWaterfallPageState();
}

class _HomeWaterfallPageState extends State<HomeWaterfallPage>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  List<dynamic> StrategyDataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getWaterFallData();
  }

  //根据地点和点赞排序等进行查询
  void _getWaterFallData() {
    var url = 'strategy/findByOrder';
    var query = {'pageNum': 1, 'pageSize': 1000};
    Http.patchData(
        url,
        (result) {
          // print(result);

          setState(() {
            StrategyDataList = result['data']['data'];
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

  // 攻略数据

  // 下拉刷新执行
  Future<Null> _refresh() async {
    print('刷新。。。');
    _getWaterFallData();
  }

//TODO:标记
  @override
  Widget build(BuildContext context) {
    if (StrategyDataList.length == 0 && widget.id != "58") {
      //TODO:处于查询中状态或者是无结果
      return Container(
        height: 450,
        child: SpinKitSpinningCircle(
          color: Color(0xffffde33),
          size: 60.0,
        ),
      );
    }

    ScreenAdapter.init(context);
    return Stack(
      children: <Widget>[
        //TODO:这里如果是攻略采用瀑布流布局，如果是游记采用图文列表，左边文字右边图片。
        widget.id == "58"
            ? TravelBoxList()
            : RefreshIndicator(
                onRefresh: _refresh,
                backgroundColor: Colors.white,
                color: Color.fromRGBO(253, 219, 69, 1.0),
                child: StaggeredGridView.countBuilder(
                  physics: ClampingScrollPhysics(),
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  primary: true,
                  itemCount: StrategyDataList.length,
                  itemBuilder: (context, index) => _waterfallItem(index),
                  staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                ),
              ),

        widget.id == "55"
            ? HomeHoteTopicWidget(hoteList: widget.hoteList)
            : Text("")
      ],
    );
  }

  Widget _waterfallItem(index) {
    return GestureDetector(
        onTap: () {
          // 进入到文章攻略或视频详情页面TODO:
          if (widget.animation == false) {
            // 判断是视频类型还是文字类型攻略
            if (StrategyDataList[index]['type'] == '1') {
              Navigator.of(context).pushNamed("/travel_detail_widget",
                  arguments: StrategyDataList[index]);
            } else {
              var url = 'video/findValug';
              var query = {
                'strategyid': StrategyDataList[index]['_id'],
                'pageNum': 1,
                'pageSize': 1000
              };
              Http.patchData(
                  url,
                  (result) {
                    // print(result);
                    print(result);
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                      return StrategyVideo(
                        param: StrategyDataList[index],
                        src: result['data']['data'][0]['url'],
                      );
                    }));
                  },
                  params: query,
                  errorCallBack: (err) {
                    print(err);
                  });
            }

            return;
          }

          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return TravelDetailWidget(
              param: {'id': '123'},
            );
          }));
        },
        child: _heroAnimation(index));
  }

  Widget _heroAnimation(index) {
    if (widget.animation == false) {
      return WaterfallItemWidget(
        item: StrategyDataList[index],
      );
    }
    return Hero(
      tag: "waterfall",
      child: WaterfallItemWidget(
        item: StrategyDataList[index],
      ),
    );
  }
}

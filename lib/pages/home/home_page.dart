import 'package:flutter/material.dart';
import 'package:flutter_mfw/model/tabar_model.dart';
import 'package:flutter_mfw/model/hote_model.dart';
import 'package:flutter_mfw/screen_adapter.dart';

import 'package:flutter_mfw/model/waterfall_model.dart';
import 'package:flutter_mfw/dao/home_dao.dart';
import 'package:flutter_mfw/pages/home/widget/home_navbar_widget.dart';
import 'package:flutter_mfw/pages/home/widget/home_top_nav.widget.dart';
import 'package:flutter_mfw/pages/home/widget/home_tabbar_widget.dart';
import 'package:flutter_mfw/pages/home/home_waterfall_page.dart';



class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{


  var _tabbarList = <TabItemModel>[];
  var _hoteList = <HoteItemModel>[];

  // 固定分类
   List<String> varyList = ['关注','推荐', '周边', '攻略','游记','商品'];


  var _pageController;

  var _currentId = "55";

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(
      initialPage:1,

    );

    _getTabrData();
    _getHoteData();

  }

  void _animateToPage(index){


    _pageController.jumpToPage(index);

  }



  //热门话题
  void _getHoteData(){

    HoteListDao.fetch().then((result){

      setState(() {
        _hoteList = result.list;

      });

    }).catchError((error){
      print(error);
    });
  }

  List<TabItemModel> getVary(){
    var resultVaryList = <TabItemModel>[];
    for (var i = 0; i < varyList.length; i++) {
       var item = TabItemModel();
       var ind = 54 + i;
      item.id = ind.toString() ;
      item.name =  varyList[i];
      resultVaryList.insert(i, item);
    }
    return resultVaryList;   
  
  }

  //tabbar 数据
  void _getTabrData(){
    TabbarListDao.fetch().then((result){

      setState(() {
        _tabbarList = getVary();
      });

    }).catchError((error){
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _pageNestedScrollViewWidget();
  }



  Widget _pageNestedScrollViewWidget(){

   

    return NestedScrollView(
      headerSliverBuilder: (context,inner){
        return [
          
          SliverPersistentHeader(
            pinned: true,
            delegate: StickyNavBarDelegate(child: HomeNavbarWidget()),
          ),

        // 轮播图展示区域，不固定
          SliverToBoxAdapter(
            child: HomeTopNavWidget(),
          ),

       // 分类列表：关注、推荐、当地周边、 游记、攻略、商品
          SliverPersistentHeader(
            pinned: true,
            delegate: StickyTabbarDelegate(
                child: HomeTabbarWidget(

                    onTap: (item){
                      

                      var index = 0;
                      print(_currentId);
                      for(var i in _tabbarList){
                        index ++;
                        print(i.toString());
                        if(i.id == item.id){
                          _animateToPage(index);
                          break;
                        }
                      }
                      setState(() {
                        _currentId = item.id;
                      });
                    },
                    currentId: _currentId,
                    tabbarList: _tabbarList
                )
            ),
          ),


        ];
      },

      body: PageView(


          controller: _pageController,
          onPageChanged: (index){
            setState(() {
              _currentId = _tabbarList[index].id;
            });
          },
          children: _tabbarList.map((item){
            return HomeWaterfallPage(id: _currentId,hoteList: _hoteList,animation: false);

          }).toList()
      ),
    );
  }
}


class StickyTabbarDelegate extends SliverPersistentHeaderDelegate {

  final HomeTabbarWidget child;


  StickyTabbarDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    ScreenAdapter.init(context);
    return this.child;
  }

  @override
  double get maxExtent => ScreenAdapter.setHeight(84);

  @override
  double get minExtent => ScreenAdapter.setHeight(84);

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}

class StickyNavBarDelegate extends SliverPersistentHeaderDelegate {
  final HomeNavbarWidget child;


  StickyNavBarDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    ScreenAdapter.init(context);
    return this.child;
  }

  @override
  double get maxExtent => ScreenAdapter.setHeight(145)+ScreenAdapter.getStatusBarHeight() ;

  @override
  double get minExtent => ScreenAdapter.setHeight(145)+ScreenAdapter.getStatusBarHeight();

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}

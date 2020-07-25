//使用SearchDelegate封装的一个搜索页面：这里是用于课程搜索
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:jhtoast/jhtoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

typedef SearchItemCall = void Function(String item);

class SearchBarDelegate extends SearchDelegate<String> {
  @override
  // TODO: implement query
  String get query => super.query;

  @override
  List<Widget> buildActions(BuildContext context) {
    //右侧显示内容 这里放清除按钮
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //左侧显示内容 这里放了返回按钮
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = "";
          showSuggestions(context);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //TODO:点击了搜索，获取数据后显示查询到结果的页面
    //带下拉刷新，上拉加载的。不过listview的长度要加2，一个是第一行显示共加载多少条数据的，一个是最后一行显示加载更多的
    //这里我使用一个新的带自己状态的widget
    return searchResult(
      keywords: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //点击了搜索窗显示的页面
    print(query);
    return SearchContentView(
      fback: (val) {
        query = val;
        print(query);
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context);
  }
}

class SearchContentView extends StatefulWidget {
  SearchContentView({Key key, this.fback}) : super(key: key);

  Function fback;

  @override
  _SearchContentViewState createState() => _SearchContentViewState();
}

// 自定义进入到的查询界面
class _SearchContentViewState extends State<SearchContentView> {
  List<String> items = [
    '广州',
    '潮州',
    '深圳',
    '汕头',
    '湛江',
    '苏州',
    '上海',
    '浙江',
  ];
  List<String> topics = ['六一旅游', '端午龙舟'];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              '推荐城市',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            child: Wrap(
                spacing: 10,
                // runSpacing: 0,
                children: items.map((item) {
                  return Container(
                    child: InkWell(
                      child: Chip(
                        label: Text(item),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onTap: () {
                        //点击历史搜索或者是大家都在搜到item，把对应的字段赋值给query，点击搜索就可以搜索了
                        widget.fback(item);
                      },
                    ),
                    color: Colors.white,
                  );
                }).toList()),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              '推荐话题',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            child: Wrap(
                spacing: 10,
                // runSpacing: 0,
                children: topics.map((item) {
                  return Container(
                    child: InkWell(
                      child: Chip(
                        label: Text(item),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onTap: () {
                        //点击历史搜索或者是大家都在搜到item，把对应的字段赋值给query，点击搜索就可以搜索了
                        widget.fback(item);
                      },
                    ),
                    color: Colors.white,
                  );
                }).toList()),
          )
        ],
      ),
    );
  }
}

//查询结果显示
class searchResult extends StatefulWidget {
  //传如搜索关键词
  searchResult({Key key, this.keywords}) : super(key: key);
  final String keywords;
  @override
  _searchResultState createState() => _searchResultState();
}

class _searchResultState extends State<searchResult> {
  //创建滚动监听控制器，赋值给可滚动的组件controle属性就可以监听滚动了
  ScrollController _scrollController = new ScrollController();
  // 数据源
  var _dataSource = [];
  // 当前加载的页数
  int _pageSize = 1;
  int totalPage = 1;
  var isLoad = true; // 是否正在加载，取代刷新控件

  // 加载更多
  // Future<Null> _loadMoreData() {
  //   return Future.delayed(Duration(seconds: 1), () {
  //     print("正在加载更多...");
  //     setState(() {
  //       _pageSize++;
  //       _loadData(_pageSize);
  //     });
  //   });
  // }

  @override
  void initState() {
    //初始化数据：显示下拉刷新控件 + 获取数据
    getCourseByName();
    print(widget.keywords);
    //!这里已经没用了
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _loadMoreData();
    //   }
    // });
    super.initState();
  }

  //根据获取到的搜索关键词进程课程的模糊查询
  getCourseByName() {
    Future.delayed(Duration(seconds: 2), () {
      for (var i = 0; i < 20; i++) {
        _dataSource.insert(0, 'name');
      }
      setState(() {
        isLoad = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: new AlwaysScrollableScrollPhysics(),
      itemCount: _dataSource.isEmpty ? 1 : _dataSource.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return items(context, index);
      },
      separatorBuilder: (context, index) => Divider(height: 1),
    );
  }

  //TODO:需要判断真实数据为空和不为空的情况。
  Widget items(context, index) {
    return isLoad
        ? Container(
            width: double.infinity,
            // height: double.infinity,
            child: Center(
              child: SpinKitSpinningCircle(
                color: Color(0xffffde33),
                size: 60.0,
              ),
            ),
          )
        : _dataSource.length == 0
            ? Container(
                width: double.infinity,
                // height: double.infinity,
                child: Center(child: Text('没有搜到结果，看看别的吧')),
              )
            : InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  //TODO:进入游记页面，与攻略同一个页面，只是id不同，加载的webview页面也不同
                  var pageUrl =
                      'http://192.168.31.8:8082/#/travelDetail/' + '123';
                  Navigator.of(context).pushNamed("/travel_detail_widget",
                      arguments: {'url': pageUrl});
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
//课程章节 实体类

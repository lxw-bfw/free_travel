/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-05 08:43:49
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-05 11:01:41
 */
import 'package:flutter/material.dart';
import 'package:flutter_mfw/screen_adapter.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_mfw/pages/publish/strategy/widget/strategy_video_botoom.dart';
import 'package:jhtoast/jhtoast.dart';
import 'package:flutter_mfw/common/Http.dart';
import 'package:flutter_mfw/common/global.dart';
import 'package:flutter_mfw/pages/detail/detail_reply_widget.dart';

class StrategyVideo extends StatefulWidget {
  StrategyVideo({Key key, this.param, this.src}) : super(key: key);
  final Map<String, dynamic> param;
  final String src;
  _StrategyVideoState createState() => _StrategyVideoState();
}

class _StrategyVideoState extends State<StrategyVideo> {
  String videoSrc = '';
  bool _isPlaying = false;
  VideoPlayerController _controller;
  var isSttart = false;
  var isColect = false;
  var collist;

  @override
  void initState() {
    // TODO: implement initState
    videoSrc = widget.src;
    collist = widget.param['collectionsids'] == null
        ? []
        : widget.param['collectionsids'];
    super.initState();
    setOrInitvideo();
  }

  void setOrInitvideo() {
    _controller = VideoPlayerController.network(this.videoSrc)
      // 播放状态
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      // 在初始化完成后必须更新界面
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   centerTitle: true,
      //   leading: GestureDetector(
      //       onTap: () {
      //         Navigator.pop(context);
      //       },
      //       child: Padding(
      //         padding: EdgeInsets.only(top: 15),
      //         child: Icon(
      //           Icons.keyboard_arrow_left,
      //           size: 35,
      //         ),
      //       )),
      //   title: GestureDetector(
      //       onTap: () {
      //         // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //         //   return UserDetail(
      //         //     id: widget.param['puhlishid'],
      //         //   );
      //         // }));
      //       },
      //       child: Padding(
      //           padding: EdgeInsets.only(top: 15),
      //           child: Row(
      //             children: <Widget>[
      //               ClipOval(
      //                 child: widget.param['userHeader'] == null
      //                     ? Image.asset(
      //                         'assets/deheader.jpeg',
      //                         width: 30.0,
      //                         height: 30.0,
      //                         fit: BoxFit.cover,
      //                       )
      //                     : new Image.network(
      //                         widget.param['userHeader'],
      //                         width: 30.0,
      //                         height: 30.0,
      //                         fit: BoxFit.cover,
      //                       ),
      //               ),
      //               Padding(
      //                 padding: EdgeInsets.only(left: 10),
      //                 child: Text(widget.param['author']),
      //               )
      //             ],
      //           ))),
      //   elevation: 4,
      //   actions: <Widget>[
      //     GestureDetector(
      //       onTap: () {
      //         // 弹出分享
      //         showModalBottomSheet(
      //             context: context,
      //             builder: (BuildContext context) {
      //               // return _showNomalWid(context);
      //             });
      //       },
      //       child: Padding(
      //           padding: EdgeInsets.fromLTRB(0, 15, 10, 0),
      //           child: Icon(Icons.more_horiz)),
      //     )
      //   ],
      // ),
      body: Stack(
        children: <Widget>[
          videoSrc == ''
              ? Container(
                  height: double.infinity,
                  decoration: BoxDecoration(color: Colors.black),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: ScreenAdapter.getStatusBarHeight()),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.white,
                              size: 45,
                            ),
                            ClipOval(
                              child: widget.param['userHeader'] == null
                                  ? Image.asset(
                                      'assets/deheader.jpeg',
                                      width: 30.0,
                                      height: 30.0,
                                      fit: BoxFit.cover,
                                    )
                                  : new Image.network(
                                      widget.param['userHeader'],
                                      width: 30.0,
                                      height: 30.0,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ),
                      Container(
                        height: ScreenAdapter.setHeight(1300),
                        alignment: Alignment.center,
                        child: SpinKitSpinningCircle(
                          color: Color(0xffffde33),
                          size: 60.0,
                        ),
                      )
                    ],
                  ))
              : Container(
                  child: _controller.value.initialized
                      ? new GestureDetector(
                          onTap: () {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          },
                          child: Container(
                            height: ScreenAdapter.getScreenHeight(),
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          ))
                      : Container()),
          // 覆盖视频上面的头部
          Positioned(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10, vertical: ScreenAdapter.getStatusBarHeight()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                    size: 45,
                  ),
                  ClipOval(
                    child: widget.param['userHeader'] == null
                        ? Image.asset(
                            'assets/deheader.jpeg',
                            width: 30.0,
                            height: 30.0,
                            fit: BoxFit.cover,
                          )
                        : new Image.network(
                            widget.param['userHeader'],
                            width: 30.0,
                            height: 30.0,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.share,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            right: 20,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.comment,
                          color: Colors.white,
                          size: 35,
                        ),
                        Text(
                          '10',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return _showComlWid(context);
                        });
                  },
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: GestureDetector(
                      onTap: () {
                        if (!isSttart) {
                          print(widget.param['startnum']);
                          var url = 'strategy/${widget.param['_id']}';
                          var data = {'startnum': widget.param['startnum'] + 1};
                          Http.putData(
                              url,
                              (result) {
                                // print(result);
                                JhToast.showSuccess(context, msg: '点赞成功');
                                setState(() {
                                  widget.param['startnum'] =
                                      widget.param['startnum'] + 1;
                                  isSttart = true;
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
                              params: data,
                              errorCallBack: (err) {
                                print(err);
                              });
                        } else {
                          print(widget.param['startnum']);
                          var url = 'strategy/${widget.param['_id']}';
                          var data = {'startnum': widget.param['startnum'] - 1};
                          Http.putData(
                              url,
                              (result) {
                                // print(result);
                                JhToast.showSuccess(context, msg: '取消点赞成功');
                                setState(() {
                                  widget.param['startnum'] =
                                      widget.param['startnum'] - 1;
                                  isSttart = false;
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
                              params: data,
                              errorCallBack: (err) {
                                print(err);
                              });
                        }
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.favorite_border,
                            color: isSttart ? Color(0xffff9d00) : Colors.white,
                            size: 35,
                          ),
                          Text(
                            widget.param['startnum'].toString(),
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    )),
                GestureDetector(
                  onTap: () {
                    if (!isColect) {
                      setState(() {
                        collist.add(Global.user.id);
                        isColect = true;
                      });
                      var url = 'strategy/${widget.param['_id']}';
                      var data = {'collectionsids': collist};
                      Http.putData(
                          url,
                          (result) {
                            // print(result);
                            JhToast.showSuccess(context, msg: '收藏成功');

                            // var resultList = result['data']['data'];
                            // setState(() {
                            //   tags = [];
                            //   for (var i = 0; i < resultList.length; i++) {
                            //     tags.add(
                            //         {'isSelect': 'false', 'content': resultList[i]['content']});
                            //   }
                            // });
                          },
                          params: data,
                          errorCallBack: (err) {
                            print(err);
                          });
                    } else {
                      setState(() {
                        collist.remove(Global.user.id);
                        isColect = false;
                      });
                      var url = 'strategy/${widget.param['_id']}';
                      var data = {'collectionsids': collist};
                      Http.putData(
                          url,
                          (result) {
                            // print(result);
                            JhToast.showSuccess(context, msg: '取消收藏成功');

                            // var resultList = result['data']['data'];
                            // setState(() {
                            //   tags = [];
                            //   for (var i = 0; i < resultList.length; i++) {
                            //     tags.add(
                            //         {'isSelect': 'false', 'content': resultList[i]['content']});
                            //   }
                            // });
                          },
                          params: data,
                          errorCallBack: (err) {
                            print(err);
                          });
                    }
                  },
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 25),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.star_border,
                            color: isColect ? Color(0xffff9d00) : Colors.white,
                            size: 35,
                          ),
                          Text(
                            collist.length.toString(),
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 50,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Text('城市:',style: TextStyle(color: Colors.white,fontSize: 15),),
                  ),
                   Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Text(widget.param['city'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Text('景点名称:',style: TextStyle(color: Colors.white,fontSize: 15),),
                  ),
                   Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Text(widget.param['placename'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                  )
                ],
              )
             ],
           ),
          ),
          //Positioned布局与视频上面。
        ],
      ),
    );
  }

  Widget _showComlWid(BuildContext context) {
    return ListView(
      children: <Widget>[
        DetailReplyWidget(),
      ],
    );
  }
}

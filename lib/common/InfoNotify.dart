/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-01 12:11:28
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-02 20:41:27
 */
// import 'dart:math';

import 'package:flutter/widgets.dart';
// import 'package:projectpractice/common/Global.dart';
// import 'package:projectpractice/models/index.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_mfw/model/location.dart';
import 'package:flutter_mfw/models/location.dart';
import 'package:flutter_mfw/common/global.dart';
import 'package:flutter_mfw/models/user.dart';

/**
 * 管理app共享的状态的数据
 */

// 用户以及用户登录信息：登录用户信息的共享。
class UserModel with ChangeNotifier {
  // user单例：登录用户信息,userInfo，还有主题字段
  User _user = Global.user;

  //访问器属性:本身是一个方法
  User get user => _user;

  //!登录标识,登录成功之后获取到userInof，如果为null就是没有登录
  bool get isLogin => Global.isLogin;

  //!修改用户信息，触发重新更新wiget，修改user单例里面的所有字段。就要触发更新和数据持久化
  void changeUserInfo(User user) {
    Global.user = user;
    // 每次更新用户信息成功后，调用下面的持久化用户信息，下次进入app维持维护登录状态相关信息
    Global.saveUser();
    _user = user;
    notifyListeners();
  }

  void login(User user) {
    Global.user = user;
    // 每次更新用户信息成功后，调用下面的持久化用户信息，下次进入app维持维护登录状态相关信息
    Global.saveUser();
    _user = user;
    Global.isLogin = true;
    notifyListeners();
  }

  // 注销登录状态
  void logout() {
    Global.isLogin = false;
    Global.clearUser();
    // 清除缓存
    notifyListeners();
  }
}

// app主题状态管理:由于主题是保存再用户下的，所以我们继承usermodel，更新的主题的时候夜更新用户信息

// 如果我把界面的当前主题颜色字段theme放在了user字段里面的话，那么我的状态管理，我只要管理user就行了吧，
//比如主题，provider获取usermodel里面的_user，更新信息的话，先获取_user再对更新的字段进行设置再调用里面的set User...Global

// 全局shared_preference实例

class LocsProvider with ChangeNotifier {
  Location _loc = Global.location;
  get loc => _loc;
  changeLoc(Location loInfo) {
    Global.location = loInfo;
    //持久化操作
    Global.saveLocation();
    _loc = loInfo;
    notifyListeners();
  }
}

//管理带有单选框、复选框，删除的逻辑状态
class CheceBox with ChangeNotifier {
  bool _isShowDelete = false;
  get isShowDelete => _isShowDelete;
  List<int> _deleteIds = [];
  get deleteIds => _deleteIds;

  toggleShow(bool show) {
    _isShowDelete = show;
    notifyListeners();
  }

  changeDeleteIds(List<int> list) {
    _deleteIds = list;
    notifyListeners();
  }
}

// 视频播放页面部分信息跨组件共享
class VideoInfoProfider with ChangeNotifier {
  String _title = '视频状态管理';
  get title => _title;

  changeTitle(String title) {
    _title = title;
    notifyListeners();
  }
}

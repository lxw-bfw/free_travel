<!--
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-05-22 12:33:07
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-04 10:07:47
--> 



#### 安装包和启动

```dart
flutter packages get
    
 flutter run
```

#### 踩坑记录

1. 调试的时候使用mumu等模拟器打开白屏闪退
```
flutter run --enable-software-rendering
```
2. flutter 中的webview控件，你要注意它可以被放置于上面组件内部

4. dart对象私有属性标志是加下划线，使用get访问


5. dio发送cookie问题

6. 方法文件超过64k
[link](https://blog.csdn.net/weixin_30693683/article/details/98463821)

7. flutter webview 无法加载网页报net:ERR_CLEARTEXT_NOT_PERMITTED问题

```
从Android 9.0（API级别28）开始，默认情况下禁用明文支持。因此http的url均无法在webview中加载,
解决方法：在AndroidManifest.xml的applaction节点中添加android:usesCleartextTraffic="true" 即可（害我找了半天）

如：

    <application
        android:name="io.flutter.app.FlutterApplication"
        android:label="flutter_test"
        android:usesCleartextTraffic="true"
        android:icon="@mipmap/ic_launcher">
		<!-- ... another configure -->
	</application>
	

```

webview与js通信机制

1. 使用url query
2. 使用webview提供的两种方式通道和拦截链接。
#### 集成高德地图定位插件，实现定位功能[link](https://pub.dev/packages/amap_location) [具体使用和注意](https://blog.csdn.net/Gemini_Kanon/article/details/104628500?utm_medium=distribute.pc_relevant.none-task-blog-baidujs-1)

- 用户打开app后获取权限进行定位，持久化定位信息
- 用户拍照上传的时候会重新刷新定位，自动获取景点地址。
- 其他需要获取当前地理位置等功能，这里有两个地方提供定位、附近以及其他城市POI搜索、根据地图点击显示具体地址信息等功能的页面
- 还有一个功能地址填写功能，和地址分享功能：地址填写和地址分享都跳转到那个页面：map_search.dart
```
// 集成高德地图fluttter三款插件实现：定位当前城市，搜索周边POI比如搜索必胜客，酒店等。还有就是地图显示位置。
```

```
两种定位的获取方式，
一种是监听方式获取定位，一种是通过调用api直接获取定位，具体代码在插件文档example都有说明。

```

[flutter动态申请权限](https://blog.csdn.net/u013425527/article/details/98938611)
[AndroinMainfet.xm配置权限大全](https://www.cnblogs.com/duwaiweb/archive/2012/09/01/2666215.html)

#### 一些业务的记录

1. 城市选择器和定位城市搜索
> 使用provider管理城市实体：里面有当前定位的城市、定位成功后获取到成功数据使用provider更新字段，此时页面不做成自动更新，而是下拉刷新重新根据新的城市进行
查询攻略或或者是游记信息。
2. 关于使用到的定位的几个地方
- 自动定位城市获取首页攻略
- 修改地址自动获取
- 发布攻略拍照上传的时候重新获取位置。
- 自动记录旅行足迹，并将到过的城市记录到用户的足迹字段。
3. 关于第三个tabview页面：属于一个服务页面提供酒店或者是飞机票这些的查询但是只是做好了页面，没有真正对接接口，然后下面一些图文数据都是基于第三方的爬虫接口获取的。，用于提供一些酒店用于专门提供旅游商品页面：服务于商家入驻模块，没有给都是一个商家发布的商品，点击之后进入商品详情页面，但是时间问题，目前这些还没有真正对接后台，数据都是基于第三方爬虫获取的。

#### 数据状态管理方案

1. provider + shared_preferences实现全局状态管理和数据持久话，目前是粗略封装，部分全局状态更新后需要持久化操作同全局变量管理文件Global存放在一起了。
2. json字符串与dart model类（class）的相互转换。最好的方法是利用json格式的后台vo文件生成对应的model类，这个model类具有两个方法一个是把map变成model类还有一个是把model类变成map
```
user是一个model类
jsonDecode(_user)，是把一个json字符串转成map类型。
User.fromJson(jsonDecode(_user))把map转成一个model类。

user.toJson()是一个model类变成map类型。
jsonEncode(user.toJson()) 是把map类型变成json字符串。

```
3. 自动根据接送文件来生成。json_model插件，自动根据json文件生成我们需要的dart类[官方文档](https://javascript.ctolib.com/flutterchina-json_model.html)   [link](https://www.jianshu.com/p/b852f9baa43e)
```
命令：
flutter packages pub run json_model
```

#### 核心修改页面

1. TODO:瀑布流布局页面home_waterfall_page.dart，基本上只要把数据接口换一下就行了，这里是统一封装的，其他地方也可以直接使用瀑布流列表。
2. 加载图片使用了懒加载占位符组件——[flutter加载网络图片的几种形式](https://www.jianshu.com/p/63d1a4b36e15)
3. TODO:flutter加载 图片支持gif的，所以如果是视频可以使用gif图片。
```
有默认占位图和淡入效果
在图片加载过程中，给用户展示一张默认的图片，能提高用户体验。
使用FadeInImage组件来达到这个功能。FadeInImage能处理内存中，App资源或者网络上的图片
```

### 美化
1. 水波纹效果 [link](https://blog.csdn.net/qq_33635385/article/details/102912836)    [link](https://www.jb51.net/article/165557.htm)


### 一些页面记录，方便快速索引
1. 攻略详情页面：detail/travel_detailxxxx
2. 评论列表：detail_replyxxx
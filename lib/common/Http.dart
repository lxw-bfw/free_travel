/*
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2020-06-02 16:21:12
 * @LastEditors: lxw
 * @LastEditTime: 2020-06-03 22:49:00
 */ 
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart' as prefix0;
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as prefix1;

// import 'package:flutter/material.dart';



/**
 * http请求插件：dio
 * http封装类：基于dio的http请求封装：请求方法：get与post
 * baseUrl:http://localhost:8088
 */

class Http {

  static void _request(String url, Function successCallback,
      {String method,
      Map<String, dynamic> params,
      Function errorCallBack}) async {
    print("url = $url");
    String errorMsg = "";
    int statusCode;
    try {
      Response response;
      BaseOptions baseOptions = new BaseOptions(
        baseUrl:'http://192.168.43.98:8081/FreeTravel/',
        connectTimeout: 5000,
        receiveTimeout: 3000,
      );
      // dio库中默认将请求数据序列化为json，此处可根据后台情况自行修改
//      contentType:new ContentType('application', 'x-www-form-urlencoded',charset: 'utf-8')
      Options options = new Options(
        connectTimeout: 5000,
        receiveTimeout: 3000,
        sendTimeout: 3000,
      );
      Dio dio = new Dio(baseOptions);
      
      dio.interceptors.add(prefix1.CookieManager(CookieJar()));
      if (method == 'get') {
        print('get');
        //get方式一般是url加键值对的方式，但是这里运行params通过json对象的方式传递数据
        response =
            await dio.get(url, queryParameters: params, options: options);
      } else if(method == 'post') {
           print('post');
        response =
            await dio.post(url, data: params, options: options);
      } else if(method == 'put'){
        response = await dio.put(url, data: params, options: options);
      } else if(method == 'patch'){
         response =
            await dio.patch(url, queryParameters: params, options: options);
      }
      statusCode = response.statusCode;
      if (statusCode != HttpStatus.ok) {
        errorMsg = "网络请求错误,状态码:" + statusCode.toString();
        // _handError(errorCallBack, errorMsg);
        errorCallBack(errorMsg);
      } else {
        if (successCallback != null) {
          var data = json.decode(response.toString()); //对数据进行Json转化
          if (data['code'] == 0 ) {
            successCallback(data);
          } else {
            errorCallBack(data);
          }
          
          print("data = " + data);
        }
      }
    } catch (exception) {
      // _handError(errorCallBack, exception.toString());
      errorCallBack(exception.toString());
    }
  }
 
  /**
   * get请求
   */
  static getData(String url, Function successCallback,
      {Map<String, dynamic> params, Function errorCallBack}) async {
    _request(url, successCallback,
        method:'get', params: params, errorCallBack: errorCallBack);
  }

  static patchData(String url, Function successCallback,
      {Map<String, dynamic> params, Function errorCallBack}) async {
    _request(url, successCallback,
        method:'patch', params: params, errorCallBack: errorCallBack);
  }

   /**
   * Post请求
   */
  static postData(String url, Function successCallback,
      {Map<String, dynamic> params, Function errorCallBack}) async {
    _request(url, successCallback,
        method: 'post', params: params, errorCallBack: errorCallBack);
  }

  static putData(String url, Function successCallback,
      {Map<String, dynamic> params, Function errorCallBack}) async {
    _request(url, successCallback,
        method: 'put', params: params, errorCallBack: errorCallBack);
  }

  
}

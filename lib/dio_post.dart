import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DioPost extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DioPostState();
  }

}

class _DioPostState extends State<DioPost>{

  Dio dio;

  String _resInfo = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dio = new Dio();

    // 设置全局Header
    dio.options.baseUrl = 'http://139.9.155.44:8111';
    dio.options.connectTimeout = 5 * 1000;
    dio.options.sendTimeout = 5 * 1000;
    dio.options.receiveTimeout = 3 * 1000;

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 200),
          ),
          Text(_resInfo),

          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: RaisedButton(
              onPressed: (){
                login().then((res){
                  debugPrint('res headers are ${res.headers}, res data is ${res.data}');
                  setState(() {
                    _resInfo = res.data.toString();
                  });
                });
              },
              child: Text('post request'),
            ),
          ),
        ],
      ),
    );
  }


  Map<String, dynamic> getLoginHeader(){
    Map<String, dynamic> headers = new Map();
    headers['Content-Type'] = "application/x-www-form-urlencoded";
    headers['app'] = 'angel_clothes';
    headers['version'] = '1.0.0';
    headers['timeZone'] = 8;
    headers['platform'] = 'A';
    return headers;
  }

  Future<Response> login() async{

    return  await dio.post('/api/v1/user/register', data: {
      "Phone": '15852947232',
      "Zone": '86',
      "Code": '677635',
    },
        //在这设置contentType类型，系统会主动把这个请求设置为表单提交
        options: Options(headers: getLoginHeader(),contentType: "application/x-www-form-urlencoded")
    );}


}
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'myApp.dart';


void main(){
  runApp(_widgetForRoute(window.defaultRouteName));
  // 修改系统顶部导航栏颜色
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Color.fromRGBO(35, 38, 66, 1.0));
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

Widget _widgetForRoute(String route) {
  switch (route) {
    case 'route1':
      return MyApp();
    default:
      return Center(
        child: Text('Unknown route: $route', textDirection: TextDirection.ltr),
      );
  }
}
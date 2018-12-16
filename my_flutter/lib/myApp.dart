import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// 屏幕自适应插件
import 'package:flutter_screenutil/flutter_screenutil.dart';

import './views/smartHome/smartHome.dart';
import './views/skillCenter/skillCenter.dart';
import './views/contentRecommend/contentRecommend.dart';
import './views/userCenter/userCenter.dart';

import './views/houseManagement/house.dart';


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '融合 APP',
      theme: ThemeData(
        canvasColor: Color.fromRGBO(35, 38, 66, 1.0),
        primaryColor: Color.fromRGBO(35, 38, 66, 1.0),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final _widgetOptions = <Widget>[
    new SmartHome(),
    new SkillCenter(),
    new ContentRecommend(),
    new UserCenter()
  ];

  final _labelStyle = TextStyle(color: Colors.white30);
  final _activeColor = Color.fromRGBO(120, 251, 255, 1.0);
  @override
  Widget build(BuildContext context) {
    ///Set the fit size (fill in the screen size of the device in the design) If the design is based on the size of the iPhone6 ​​(iPhone6 ​​750*1334)
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    print('Device width:${ScreenUtil.screenWidth}'); //Device width
    print('Device height:${ScreenUtil.screenHeight}'); //Device height
    print(
        'Device pixel density:${ScreenUtil.pixelRatio}'); //Device pixel density
    print(
        'Bottom safe zone distance:${ScreenUtil.bottomBarHeight}'); //Bottom safe zone distance，suitable for buttons with full screen
    print(
        'Status bar height:${ScreenUtil.statusBarHeight}px'); //Status bar height , Notch will be higher Unit px
    print(
        'Ratio of actual width dp to design draft px:${ScreenUtil().scaleWidth}');
    print(
        'Ratio of actual height dp to design draft px:${ScreenUtil().scaleHeight}');
    print(
        'The ratio of font and width to the size of the design:${ScreenUtil().scaleWidth * ScreenUtil.pixelRatio}');
    print(
        'The ratio of  height width to the size of the design:${ScreenUtil().scaleHeight * ScreenUtil.pixelRatio}');

    return Scaffold(
        body: Container(child: _widgetOptions.elementAt(_selectedIndex)),
        bottomNavigationBar: Material(
          // color: Color.fromRGBO(35, 38, 66, 1.0),
          // type: MaterialType.canvas,
          child: new BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.white30),
                  title: Text("智能家居", style: _labelStyle),
                  backgroundColor: Colors.blueGrey),
              BottomNavigationBarItem(
                  icon: Icon(Icons.cake, color: Colors.white30),
                  title: Text("技能中心", style: _labelStyle),
                  backgroundColor: Colors.blue),
              BottomNavigationBarItem(
                  icon: Icon(Icons.beach_access, color: Colors.white30),
                  title: Text("内容推荐", style: _labelStyle),
                  backgroundColor: Colors.purple),
              BottomNavigationBarItem(
                  icon: Icon(Icons.kitchen, color: Colors.white30),
                  title: Text("我的", style: _labelStyle),
                  backgroundColor: Colors.orangeAccent)
            ],
            type: BottomNavigationBarType.fixed,
            fixedColor: _activeColor,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            iconSize: ScreenUtil().setSp(52),
          ),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

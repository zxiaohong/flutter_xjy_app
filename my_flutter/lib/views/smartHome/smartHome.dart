import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import './device.dart';
import './scenes.dart';

import '../houseManagement/house.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class SmartHome extends StatefulWidget {
  @override
  SmartHomeState createState() => new SmartHomeState();
}

class SmartHomeState extends State<SmartHome>
    with SingleTickerProviderStateMixin {
  TabController controller;
  final _activeColor = Color.fromRGBO(120, 251, 255, 1.0);

  int houseId;
  String houseName = "我的家";
  int roomCnt = 0;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _getHousesAndRooms();
    controller = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
  void _getHousesAndRooms() async{
    print('smartHome');
    String url = "https://easy-mock.com/mock/5c1362e3bb577d1fbc488206/s/service/getHousesAndRooms";
    final response = await http.get(url);
    if(response.statusCode == HttpStatus.ok){
      var result = json.decode(response.body);
      var house = result["data"][0];
      setState(() {
        houseId = house["house_id"];
        houseName =  house["house_name"];
        roomCnt  = house["rooms"].length;
        _loading = false;
      });
    }
  }


  Widget _pageView() {
    return new Scaffold(
        appBar: AppBar(
            centerTitle: false,
            title: GestureDetector(
              child: Container(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
                child: Row(
                  children: <Widget>[
                    Text(houseName , style: TextStyle(fontSize: ScreenUtil().setSp(32, false))),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
              onTap: _homeManagement,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add, color: _activeColor),
                iconSize: ScreenUtil().setSp(56),
                tooltip: 'add',
                onPressed: _addDevice,
              ),
            ],
            bottom: new PreferredSize(
              preferredSize: Size(double.infinity, 50.0),
              child: new Theme(
                data: new ThemeData(
                  splashColor: Color.fromRGBO(35, 38, 66, 0.0),
                  highlightColor: Color.fromRGBO(35, 38, 66, 0.0),
                ),
                child: TabBar(
                  controller: controller,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
                  indicatorColor: _activeColor,
                  tabs: <Widget>[new Tab(text: "设备"), new Tab(text: "场景")],
                ),
              ),
            )),
        body: new TabBarView(
          controller: controller,
          children: <Widget>[new DeviceCard(), new Scenes()],
        ));
  }
  Widget _loadingView(){
    return new Scaffold(
      body: Center(
      child: new CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    ),
    );

  }
  @override
  Widget build(BuildContext context) {
    return _loading ? _loadingView() : _pageView();
  }

  void _addDevice() {}
  void _homeManagement() {
    // Navigator.of(context).pushNamed('/house');

    Navigator.of(context).push(
      new PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return new HouseManagement(houseId, houseName, roomCnt);
          },
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return new FadeTransition(
              opacity: animation,
              child: new SlideTransition(
                position:
                    new Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
                        .animate(animation),
                child: child,
              ),
            );
          }),
    );
  }
}

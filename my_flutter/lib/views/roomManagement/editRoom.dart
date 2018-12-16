import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'dart:convert';

import './roomName.dart';
import './animationtest.dart';

double _horizontalMargin = ScreenUtil().setWidth(20);
double _verticalMargin20 = ScreenUtil().setHeight(20);
EdgeInsets allMargin20 = EdgeInsets.fromLTRB(_horizontalMargin , _verticalMargin20, _horizontalMargin, _verticalMargin20);


class EditRoom extends StatelessWidget {
  final String roomName;
  final int roomId;
  EditRoom(this.roomName, this.roomId);

  @override
  Widget build(BuildContext context) {
    print("room_id is $roomId");
    return Scaffold(
      backgroundColor: Color(0Xff3B426B),
      appBar: AppBar(
        title: Text(
          roomId == -2 ? '添加房间' : '编辑房间',
          style: TextStyle(fontSize: ScreenUtil().setSp(36, false)),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(right: _horizontalMargin),
              alignment: Alignment.center,
              child: Text("保存",
                  style: TextStyle(
                      color: Color(0xff78FBFF),
                      fontSize: ScreenUtil().setSp(28, false))),
            ),
            onTap: null,
          )
        ],
      ),
      body: Center(
        child: RoomsInfo(roomName, roomId),
      ),
    );
  }
}

class RoomsInfo extends StatefulWidget {
  final String roomName;
  final int roomId;
  RoomsInfo(this.roomName, this.roomId);
  @override
  RoomsInfoState createState() => RoomsInfoState(roomName, roomId);
}

class RoomsInfoState extends State<RoomsInfo> with TickerProviderStateMixin {
  // final GlobalKey<AnimatedListState> _listKey =
  //     new GlobalKey<AnimatedListState>();

  // // AnimationController _controller;
  // Animation<double> _enlargeAnimation;
  // Animation<double> _shrinkAnimation;
  final String roomName;
  final int roomId;
  RoomsInfoState(this.roomName, this.roomId);
  final _fontStyle = TextStyle(
      fontSize: ScreenUtil().setSp(28, false), color: Color(0xffDEDFE8));
  var _curRooms = [];
  var _rooms = [];
  var _defaultRooms = [];
  var _otherRooms = [];
  var _allOtherRooms = [];
  int _deviceCount = 0;
  var curRoom = [];
  var otherRooms = [];
  var allOtherRooms = [];
  var defaultRooms = [];
  int deviceCount = 0;
  String _roomName;
  bool _devicesLoading = true;

  @override
  void initState() {
    super.initState();
    _roomName = roomName;
    // _controller =
    //     AnimationController(vsync: this, duration: Duration(seconds: 3));
    // _enlargeAnimation = new Tween(begin: 0.8, end: 1.0).animate(_controller);
    // _shrinkAnimation = new Tween(begin: 0.8, end: 1.0).animate(_controller);
    // print(_enlargeAnimation);
    _getDevices();
    // _controller.forward(from: 1.0);
  }

  _getDevices() async {
    var httpClient = new HttpClient();
    var uri = "https://easy-mock.com/mock/5c1362e3bb577d1fbc488206/s/service/getAllDevicesByHouseForAlphaApp";
    var result;
    try {
      var request = await httpClient.getUrl(Uri.parse(uri));
      var response = await request.close();
      // print(response.statusCode);
      // print(HttpStatus.ok);
      if (response.statusCode == HttpStatus.ok) {
        var responseBody = await response.transform(utf8.decoder).join();
        // print(responseBody);
        result = json.decode(responseBody);
        // print(result);
        print(result["data"]["rooms"]);
        var allRooms = result["data"]["rooms"];
        // 为每个设备标记原始房间id 和 name
        for (var room in allRooms) {
          for (var device in room['devices']) {
            device['room_id'] = room['room_id'];
            device['room_name'] = room['room_name'];
          }
        }

        for (var item in allRooms) {
          if (item['room_id'] == roomId) {
            print("hello");
            curRoom.add(item);
          } else if (item['room_id'] == null) {
            defaultRooms.add(item);
            allOtherRooms.add(item);
            deviceCount += item["devices"].length;
          } else {
            otherRooms.add(item);
            allOtherRooms.add(item);
            deviceCount += item["devices"].length;
          }
        }
        // print(curRoom);
        // print(otherRooms);
        // print(defaultRooms);
        print(deviceCount);
        if (!mounted) return;
        setState(() {
          _rooms = allRooms;
          _curRooms = curRoom;
          _otherRooms = otherRooms;
          _allOtherRooms = allOtherRooms;
          _defaultRooms = defaultRooms;
          _deviceCount = deviceCount;
          _devicesLoading = false;
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return _devicesLoading ? Center(
      child: CircularProgressIndicator(),
    )
    :CustomScrollView(
      slivers: <Widget>[
        // 家庭名称
        SliverToBoxAdapter(
            child: Container(
                margin: allMargin20,
                decoration: BoxDecoration(
                    color: Color(0xff5C628D),
                    borderRadius: BorderRadius.circular(4.0)),
                child: ListTile(
                  dense: true,
                  title: Text("房间名称", style: _fontStyle),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(_roomName, style: _fontStyle),
                      Icon(Icons.keyboard_arrow_right, color: Color(0xffDEDFE8))
                    ],
                  ),
                  onTap: () => _editRoomName(roomId, roomName),
                ))),
        // 当前房间的设备 文本描述
        SliverToBoxAdapter(
            child: new Padding(
          padding: allMargin20,
          child: Text("当前房间的设备",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(26, false),
                  color: Color(0xff7D80A2))),
        )),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Container(
                child: singleRoomDevides(_curRooms[index], 'current'));
          }, childCount: _curRooms.length),
        ),
        // 其他房间的设备
        SliverToBoxAdapter(
            child: Padding(
          padding: allMargin20,
          child: Text("其他房间的设备",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(26, false),
                  color: Color(0xff7D80A2))),
        )),
        _deviceCount > 0
            ? SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _defaultRooms
                            .map((room) => singleRoomDevides(room, 'default'))
                            .toList()),
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _otherRooms
                            .map((room) => singleRoomDevides(room, 'other'))
                            .toList())
                  ],
                ),
              )
            : SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(left: _horizontalMargin, right: _horizontalMargin),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(4.0, 4.0),
                        topRight: Radius.elliptical(4.0, 4.0)),
                    color: Color(0xff43486F),
                  ),
                  width: ScreenUtil().setWidth(710),
                  height: ScreenUtil().setHeight(320),
                  child: Image(
                    image: AssetImage('./images/kong_2.png'),
                  ),
                ),
              ),
      ],
    );
  }

  Widget singleRoomDevides(room, signal) {
    print("________________________________");
    print(room['room_id']);
    return room['devices'] != null && room['devices'].length> 0 ? Container(
        padding: EdgeInsets.only(left: _horizontalMargin),
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(room['room_name'],
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(26, false),
                      color: Color(0xff7D80A2))),
            ),
            Wrap(
              spacing: _horizontalMargin,
              children: room['devices']
                  .map<Widget>((device) =>
                      _singleDeviceCard(room['room_id'], device, signal))
                  .toList(),

            ),
          ],
        )): Container(
          height: 0.0,
        );
  }

  Widget _singleDeviceCard(curRoomId, device, signal) {
    return Container(
      width: ScreenUtil().setWidth(345),
      height: ScreenUtil().setHeight(256),
      margin: EdgeInsets.only(bottom: 10.0),
      child:
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: <Widget>[
            // 产品图片
            Container(
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(4.0, 4.0),
                    topRight: Radius.elliptical(4.0, 4.0)),
                color: Color(0xff43486F),
              ),
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(6),
                  bottom: ScreenUtil().setHeight(100)
                ),
              child: Image(
                image: NetworkImage(device["app_pic_url"]
                    // "https://img10.360buyimg.com/n5/s54x54_jfs/t1/1325/27/9916/31986/5bc946c9E748626df/79850cb5c7d8a7f0.jpg"
                    ),
                width: 150.0,
                height: 150.0,
              ),
            ),
            // 产品信息
            Container(
              height: ScreenUtil().setHeight(100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(4.0, 4.0),
                    bottomRight: Radius.elliptical(4.0, 4.0)),
                color: Color(0xff43486F),
              ),
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              child: new Row(children: <Widget>[
                new Expanded(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                        child: Text(device["device_name"],
                            style: TextStyle(color: Color(0xffffffff))),
                      ),
                      Text(device["category_name"],
                          style: TextStyle(
                              color: Color(0xffFFF091),
                              fontSize: ScreenUtil().setSp(24)))
                    ],
                  ),
                )
              ]),
            ),
            // 按钮
            Positioned(
                top: -5.0,
                right: -5.0,
                child: Theme(
                  data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  child: signal == 'current'
                      ? IconButton(
                          padding: EdgeInsets.all(0.0),
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: Color(0xffFF6262),
                          ),
                          onPressed: () => _removeDevice(device),
                        )
                      : IconButton(
                          padding: EdgeInsets.all(0.0),
                          icon: Icon(
                            Icons.add_circle,
                            color: Color(0xff78FBFF),
                          ),
                          onPressed: () => _addToCurRoom(device, signal),
                        ),
                ))
          ],
        ),
    );
  }

  void _removeDevice(device) {
    print(device);
    curRoom[0]['devices'].remove(device);
    if (device['room_id'] == roomId || device['room_id'] == null) {
      defaultRooms[0]['devices'].insert(0, device);
    } else {
      for (var item in otherRooms) {
        if (item['room_id'] == device['room_id']) {
          item['devices'].insert(0, device);
        }
      }
    }
    setState(() {
      _defaultRooms = defaultRooms;
      _curRooms = curRoom;
    });
    // _shrinkAnimation = new Tween(begin: 1.0, end: 0.8).animate(_controller);

    // _controller.forward();
  }

  void _addToCurRoom(device, signal) {
    print(device);
    curRoom[0]['devices'].add(device);
    if (signal == 'default') {
      defaultRooms[0]['devices'].remove(device);
    } else {
      for (var item in otherRooms) {
        if (item['room_id'] == device['room_id']) {
          item['devices'].remove(device);
        }
      }
    }
    setState(() {
      _defaultRooms = defaultRooms;
      _curRooms = curRoom;
    });
    // _controller.forward();
  }

  void _editRoomName(roomId, roomName) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return
          // new AnimatedListSample();
          new RoomName(roomId, roomName);
    })).then((result){
      setState(() {
        _roomName = result;
            });
    });
  }
}

class SingleDeviceCard extends StatefulWidget {
  final curRoomId;
  final device;
  final String signal;
  final onRemove;
  final onAdd;
  SingleDeviceCard(
      {Key key,
      @required this.curRoomId,
      @required this.device,
      @required this.signal,
      @required this.onRemove,
      @required this.onAdd});
  SingleDeviceCardState createState() => SingleDeviceCardState(
      curRoomId: curRoomId,
      device: device,
      signal: signal,
      onRemove: onRemove,
      onAdd: onAdd);
}

class SingleDeviceCardState extends State<SingleDeviceCard>
    with TickerProviderStateMixin {
  final curRoomId;
  final device;
  final String signal;
  final onRemove;
  final onAdd;
  SingleDeviceCardState(
      {Key key,
      @required this.curRoomId,
      @required this.device,
      @required this.signal,
      @required this.onRemove,
      @required this.onAdd});

  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(345),
      height: ScreenUtil().setHeight(256),
      margin: EdgeInsets.only(bottom: 10.0),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: <Widget>[
            Container(
              // height: ScreenUtil().setHeight(150),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(4.0, 4.0),
                    topRight: Radius.elliptical(4.0, 4.0)),
                color: Color(0xff43486F),
              ),
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(6),
                  bottom: ScreenUtil().setHeight(130)),
              child: Image(
                image: NetworkImage(device["app_pic_url"]
                    // "https://img10.360buyimg.com/n5/s54x54_jfs/t1/1325/27/9916/31986/5bc946c9E748626df/79850cb5c7d8a7f0.jpg"
                    ),
                width: 150.0,
                height: 150.0,
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(4.0, 4.0),
                    bottomRight: Radius.elliptical(4.0, 4.0)),
                color: Color(0xff43486F),
              ),
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(6)),
              child: new Row(children: <Widget>[
                new Expanded(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(device["device_name"],
                            style: TextStyle(color: Color(0xffffffff))),
                      ),
                      Text(device["category_name"],
                          style: TextStyle(
                              color: Color(0xffFFF091),
                              fontSize: ScreenUtil().setSp(24)))
                    ],
                  ),
                )
              ]),
            ),
            Positioned(
                top: -5.0,
                right: -5.0,
                child: Theme(
                  data: ThemeData(splashColor: Colors.transparent),
                  child: signal == 'current'
                      ? IconButton(
                          padding: EdgeInsets.all(0.0),
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: Color(0xffFF6262),
                          ),
                          onPressed: () => onRemove(device),
                        )
                      : IconButton(
                          padding: EdgeInsets.all(0.0),
                          icon: Icon(
                            Icons.add_circle,
                            color: Color(0xff78FBFF),
                          ),
                          onPressed: () => onAdd(device, signal),
                        ),
                ))
          ],
        ),
      ),
    );
  }
}

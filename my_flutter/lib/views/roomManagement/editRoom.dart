import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'dart:convert';

import './roomName.dart';
import '../../model/allRoomDevicesModel.dart';
import '../../customWidgets/animated_grid.dart';


double _horizontalMargin = ScreenUtil().setWidth(20);
double _verticalMargin20 = ScreenUtil().setHeight(20);

EdgeInsets allMargin20 = EdgeInsets.fromLTRB(
    _horizontalMargin, _verticalMargin20, _horizontalMargin, _verticalMargin20);

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
  // final GlobalKey<animatedGridState> _listKey =
  //     new GlobalKey<animatedGridState>();
  GlobalKey<AnimatedGridState> _curListKey = GlobalKey();
  Map<String, GlobalKey<AnimatedGridState>> _globalKeys = {};
  // AnimationController controller;
  // Animation<double> animation;

  final String roomName;
  final int roomId;
  RoomsInfoState(this.roomName, this.roomId);
  final _fontStyle = TextStyle(
      fontSize: ScreenUtil().setSp(28, false), color: Color(0xffDEDFE8));
  List<Room> _curRooms = [];
  List<Room> _rooms = [];
  List<Room> _defaultRooms = [];
  List<Room> _otherRooms = [];
  List<Room> _allOtherRooms = [];
  int _deviceCount = 0;
  List<Room> curRoom = [];
  List<Room> otherRooms = [];
  List<Room> allOtherRooms = [];
  List<Room> defaultRooms = [];
  int deviceCount = 0;
  String _roomName;
  bool _devicesLoading = true;

  @override
  void initState() {
    super.initState();
    _roomName = roomName;
    _getDevices();
    // controller = new AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    // animation = new Tween(begin: 0.8, end: 1.0).animate(controller);
  }

  _getDevices() async {
    var httpClient = new HttpClient();
    var uri =
        "https://easy-mock.com/mock/5c1362e3bb577d1fbc488206/s/service/getAllDevicesByHouseForAlphaApp";
    try {
      var request = await httpClient.getUrl(Uri.parse(uri));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var responseBody = await response.transform(utf8.decoder).join();
        // print(responseBody);
        Map result = json.decode(responseBody);
        AllRoomDevices allRoomDevices = new AllRoomDevices.fromJson(result);

        List<Room> allRooms = allRoomDevices.rooms;
        // 为每个设备标记原始房间id 和 name
        for (var room in allRooms) {
          for (var device in room.devices) {
            device.roomId = room.roomId;
            device.roomName = room.roomName;
          }
        }

        for (var item in allRooms) {
          if (item.roomId == roomId) {
            print("hello");
            curRoom.add(item);
          } else if (item.roomId == null) {
            defaultRooms.add(item);
            deviceCount += item.devices.length;
            _globalKeys["${item.roomId.toString()}ListKey"] = GlobalKey();
          } else {
            otherRooms.add(item);
            _globalKeys["${item.roomId.toString()}ListKey"] = GlobalKey();
            deviceCount += item.devices.length;
          }
        }

        allOtherRooms.addAll(defaultRooms);
        allOtherRooms.addAll(otherRooms);
        // print(curRoom);
        // print(otherRooms);
        print("第一个房间:${allOtherRooms[0].roomName}");
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
    return _devicesLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : CustomScrollView(
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
                            Icon(Icons.keyboard_arrow_right,
                                color: Color(0xffDEDFE8))
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
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Container(
                      child:
                          curRoomDevides(_curRooms[index], 'current', context));
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
                  ? SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return  otherRoomDevides(_allOtherRooms[index], 'other', context);
                    },childCount: _allOtherRooms.length),
              ):
              SliverToBoxAdapter(
                child: NoDevices()
              )
            ]);
  }

  Widget curRoomDevides(Room room, String signal, BuildContext context) {
    // print("roomdevicelength:${room.devices.length}");
    return room.devices != null && room.devices.length > 0
        ? Container(
            key: UniqueKey(),
            padding: EdgeInsets.only(
                left: _horizontalMargin, right: _horizontalMargin),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(room.roomName,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(26, false),
                          color: Color(0xff7D80A2))),
                ),
                AnimatedGrid(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: ScreenUtil().setWidth(30),
                      childAspectRatio: 1.32,
                      mainAxisSpacing: 10.0),
                  key: _curListKey,
                  initialItemCount: room.devices.length,
                  itemBuilder:
                      (BuildContext context, int index, Animation animation) {
                    return ScaleTransition(
                      scale: Tween(begin: 0.8, end: 1.0).animate(animation),
                      child: _singleDeviceCard(room.roomId, room.devices[index],
                          index, signal),
                    );
                  },
                ),

                // Wrap(
                //   spacing: _horizontalMargin,
                //   children: room.devices
                //       .map<Widget>((device) => _singleDeviceCard(
                //           room.roomId, device, signal, context))
                //       .toList(),
                // ),
              ],
            ))
        : NoDevices();
  }

  Widget otherRoomDevides(Room room, String signal, BuildContext context) {
    // print("${room.roomId.toString()}ListKey");
    // print(_globalKeys);

    return room.devices != null && room.devices.length > 0
        ? Container(
            key: UniqueKey(),
            padding: EdgeInsets.only(
                left: _horizontalMargin, right: _horizontalMargin),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(room.roomName,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(26, false),
                          color: Color(0xff7D80A2))),
                ),
                AnimatedGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: ScreenUtil().setWidth(30),
                      childAspectRatio: 1.32,
                      mainAxisSpacing: 10.0),
                  shrinkWrap: true,
                  key: _globalKeys["${room.roomId.toString()}ListKey"],
                  initialItemCount: room.devices.length,
                  itemBuilder:
                      (BuildContext context, int index, Animation animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: _singleDeviceCard(room.roomId, room.devices[index],
                          index, signal),
                    );
                  },
                )
              ],
            ))
        : SizedBox(
            height: 0.0,
          );
  }

  Widget _singleDeviceCard(int curRoomId, Device device, int index,
      String signal) {
        print("device.deviceId:${device.deviceId}");
    return Container(
      key: ValueKey(device.deviceId),
      width: ScreenUtil().setWidth(345),
      height: ScreenUtil().setHeight(260),
      margin: EdgeInsets.only(bottom: 10.0),
      child: Stack(
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
                bottom: ScreenUtil().setHeight(100)),
            child: Image(
              image: NetworkImage(device.appPicUrl
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
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(5)),
            child: new Row(children: <Widget>[
              new Expanded(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                      child: Text(device.deviceName,
                          style: TextStyle(color: Color(0xffffffff))),
                    ),
                    Text(device.categoryName,
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
                data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent),
                child: signal == 'current'
                    ? IconButton(
                        padding: EdgeInsets.all(0.0),
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Color(0xffFF6262),
                        ),
                        onPressed: () => _removeDevice(curRoomId, device, index),
                      )
                    : IconButton(
                        padding: EdgeInsets.all(0.0),
                        icon: Icon(
                          Icons.add_circle,
                          color: Color(0xff78FBFF),
                        ),
                        onPressed: () => _addToCurRoom(
                            curRoomId, device, index),
                      ),
              ))
        ],
      ),
    );
  }

  void _removeDevice(curRoomId, device, index) {
    print("_curListKey: $_curListKey");
    print("_curListKeyType: ${_curListKey.runtimeType}");
    print("_curListKeyState: ${_curListKey.currentState}");
    print("_globalKeys: $_globalKeys");

    print("_nullListKey: ${_globalKeys["nullListKey"]}");
    print("_nullListKeyType: ${_globalKeys["nullListKey"].runtimeType}");
    print("_nullListKeyState: ${_globalKeys["nullListKey"].currentState}");
    if (device.roomId == roomId || device.roomId == null) {
      _allOtherRooms[0].devices.insert(0, device);

      _globalKeys["nullListKey"].currentState
          .insertItem(0, duration: Duration(microseconds: 2000));
    } else {
      for (var item in _allOtherRooms) {
        if (item.roomId == device.roomId) {
          item.devices.insert(0, device);
          _globalKeys["${item.roomId.toString()}ListKey"].currentState.insertItem(0, duration: Duration(microseconds: 2000));
        }
      }
    }
     _curRooms[0].devices.remove(device);
     _curListKey.currentState.removeItem(
        index,
        (BuildContext context, Animation<double> animation) {
          return FadeTransition(
            opacity:
                CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
            child: ScaleTransition(
              scale:
                  CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
              child:
                  _singleDeviceCard(curRoomId, device, index, 'other'),
            ),
          );
        },
        duration: Duration(milliseconds: 2000),
      );

      setState(() {
        _curRooms= _curRooms;
        _allOtherRooms = _allOtherRooms;
      });
  }

  void _addToCurRoom(curRoomId, device, index) {
    if (curRoomId == null) {// 默认房间的设备
      int addIndex = _curRooms[0].devices.length;

      setState(() {
         _curRooms[0].devices.add(device);
        _allOtherRooms[0].devices.remove(device);
      });

      _curListKey.currentState
          .insertItem(addIndex, duration: Duration(microseconds: 2000));
      _globalKeys["nullListKey"].currentState.removeItem(
        index,
        (BuildContext context, Animation<double> animation) {
          return FadeTransition(
            opacity:
                CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
            child: ScaleTransition(
              scale:
                  CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
              child:
                  _singleDeviceCard(curRoomId, device, index, 'other'),
            ),
          );
        },
        duration: Duration(milliseconds: 2000),
      );
    } else { //其他房间
      _showDialog(curRoomId, device, index);
    }
  }

  _showDialog(curRoomId, device,index) {
    TextStyle _contextStyle = TextStyle(
        fontSize: ScreenUtil().setSp(28, false), color: Color(0xff666666));
    TextStyle _buttonStyle = TextStyle(
        fontSize: ScreenUtil().setSp(32, false), color: Color(0xff637EF8));
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            contentPadding: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
            content: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xffD7D9EB))),
                ),
                height: ScreenUtil().setHeight(225),
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(120),
                    right: ScreenUtil().setWidth(120)),
                alignment: Alignment.center,
                child: Text(
                  "您要把“主卧-格力空调移动到当前房间吗？",
                  style: _contextStyle,
                  softWrap: true,
                  textAlign: TextAlign.center,
                )),
            actions: <Widget>[
              Container(
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    FlatButton(
                      child: Text('取消', style: _buttonStyle),
                      onPressed: () => _cancelAdd(context),
                    ),
                    FlatButton(
                      child: Text('移动', style: _buttonStyle),
                      onPressed: () => _confirmAdd(curRoomId, device, index),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  _cancelAdd(context) {
    Navigator.pop(context);
  }

  _confirmAdd(curRoomId, device,index) {
    int addIndex = _curRooms[0].devices.length;
    _curRooms[0].devices.add(device);
    _curListKey.currentState
        .insertItem(addIndex, duration: Duration(microseconds: 2000));

    for (var item in _allOtherRooms) {
      if (item.roomId == device.roomId) {
        item.devices.remove(device);
        _globalKeys["${item.roomId.toString()}ListKey"].currentState.removeItem(
          index,
          (BuildContext context, Animation<double> animation) {
            return FadeTransition(
              opacity:
                  CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
              child: ScaleTransition(
                scale:
                    CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
                child:
                    _singleDeviceCard(curRoomId, device, index, 'other'),
              ),
            );
          },
          duration: Duration(milliseconds: 2000)
        );
      }
    }
    setState(() {
      _curRooms = _curRooms;
      _allOtherRooms = _allOtherRooms;
    });
    Navigator.pop(context);
  }

  void _editRoomName(roomId, roomName) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return
          // new animatedGridSample();
          new RoomName(roomId, roomName);
    })).then((result) {
      setState(() {
        _roomName = result;
      });
    });
  }
}

class NoDevices extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.only(
          left: _horizontalMargin, right: _horizontalMargin),
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
    );
  }
}

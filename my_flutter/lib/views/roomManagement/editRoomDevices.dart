import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'dart:convert';

import './roomName.dart';
import '../../model/allRoomDevicesModel.dart';

double _horizontalMargin = ScreenUtil().setWidth(20);
double _verticalMargin20 = ScreenUtil().setHeight(20);
EdgeInsets allMargin20 = EdgeInsets.fromLTRB(
    _horizontalMargin, _verticalMargin20, _horizontalMargin, _verticalMargin20);

class EditRoomDevice extends StatelessWidget {
  final String roomName;
  final int roomId;
  EditRoomDevice(this.roomName, this.roomId);

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
      body: RoomsInfo(roomName, roomId),
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
  final String roomName;
  final int roomId;
  RoomsInfoState(this.roomName, this.roomId);

  final _fontStyle = TextStyle(
      fontSize: ScreenUtil().setSp(28, false), color: Color(0xffDEDFE8));
  List<Room> _curRooms = [];
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
          } else {
            otherRooms.add(item);
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
    print('1111111111111111');
    return _devicesLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : CustomScrollView(slivers: <Widget>[
            SliverToBoxAdapter(
                // 家庭名称
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
                          Text(roomName, style: _fontStyle),
                          Icon(Icons.keyboard_arrow_right,
                              color: Color(0xffDEDFE8))
                        ],
                      ),
                      onTap: () => _editRoomName(),
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
                return RoomDevides(
                    room: _curRooms[index],
                    signal: 'current',
                    onAdd: _addToCurRoom,
                    onRemove: _removeDevice);
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
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return RoomDevides(
                    room: _allOtherRooms[index],
                    signal: 'other',
                    onAdd: _addToCurRoom,
                    onRemove: _removeDevice);
              }, childCount: _allOtherRooms.length),
            )
          ]);
  }

  void _removeDevice(int curRoomId, Device device) {
    if (device.roomId == roomId || device.roomId == null) {
      setState(() {
        _allOtherRooms[0].devices.insert(0, device);
      });
    } else {
      for (var item in _allOtherRooms) {
        if (item.roomId == device.roomId) {
          item.devices.insert(0, device);
        }
      }
    }
    setState(() {
      _curRooms[0].devices.remove(device);
      _allOtherRooms = _allOtherRooms;
    });
  }

  void _addToCurRoom(int curRoomId, Device device) {
    print("curRoomId: $curRoomId");
    print("devicesssss: ${device.deviceId}");
    if (curRoomId == null) {
      // 默认房间的设备
      setState(() {
        _curRooms[0].devices.add(device);
        _allOtherRooms[0].devices.remove(device);
      });
    } else {
      //其他房间
      for (var item in _allOtherRooms) {
        if (item.roomId == device.roomId) {
          item.devices.remove(device);
        }
      }
      _curRooms[0].devices.add(device);
      setState(() {
        _curRooms = _curRooms;
        _allOtherRooms = _allOtherRooms;
      });
    }
  }

  void _editRoomName() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return
          // new animatedGridSample();
          new RoomName(roomId, _roomName);
    })).then((result) {
      setState(() {
        _roomName = result;
      });
    });
  }
}

class RoomDevides extends StatefulWidget {
  final Room room;
  final String signal;
  final Function onAdd;
  final Function onRemove;
  RoomDevides(
      {Key key,
      @required this.room,
      @required this.signal,
      @required this.onAdd,
      @required this.onRemove})
      : super(key: key);

  @override
  RoomDevidesState createState() => RoomDevidesState(
      room: room, signal: signal, onAdd: onAdd, onRemove: onRemove);
}

class RoomDevidesState extends State<RoomDevides> {
  final Room room;
  final String signal;
  final Function onAdd;
  final Function onRemove;
  RoomDevidesState(
      {Key key,
      @required this.room,
      @required this.signal,
      @required this.onAdd,
      @required this.onRemove});

  bool roomInit;

  @override
  void initState() {
    super.initState();
    roomInit= true;
    print('initState');
  }
  @override
  void didUpdateWidget(RoomDevides oldWidget){
    super.didUpdateWidget(oldWidget);
    roomInit = false;
    print('didUpdateWidget');
  }


  @override
  Widget build(BuildContext context) {
     print('roomInit:$roomInit');
    return room.devices != null && room.devices.length > 0
        ? Container(
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
                Wrap(
                  spacing: _horizontalMargin,
                  children: //getChildren()
                  room.devices
                      .map<Widget>((device) => Container(
                          key: Key(device.deviceId),
                          child: SingleDeviceCard(
                            curRoomId: room.roomId,
                            device: device,
                            signal: signal,
                            onAdd: onAdd,
                            onRemove: onRemove,
                            roomInit: roomInit)
                      )
                      )
                      .toList(),
                ),
              ],
            ))
        : SizedBox(
            height: 0.0,
          );
  }

  List<Widget> getChildren() {
    var childrenList = new List<Widget>();
    for (var device in room.devices) {
      childrenList.add(Container(
          key: ValueKey(device.deviceId),
          child: SingleDeviceCard(
              curRoomId: room.roomId,
              device: device,
              signal: signal,
              onAdd: onAdd,
              onRemove: onRemove,
              roomInit: roomInit,)));
    }
    return childrenList;
  }
}

class SingleDeviceCard extends StatefulWidget {
  final int curRoomId;
  final Device device;
  final String signal;
  final Function onAdd;
  final Function onRemove;
  final bool roomInit;

  SingleDeviceCard(
      {Key key,
      @required this.curRoomId,
      @required this.device,
      @required this.signal,
      @required this.onAdd,
      @required this.onRemove,
      @required this.roomInit,
      });
  SingleDeviceCardState createState() => SingleDeviceCardState(
      curRoomId: curRoomId,
      device: device,
      signal: signal,
      onAdd: onAdd,
      onRemove: onRemove,
      roomInit: roomInit);
}

class SingleDeviceCardState extends State<SingleDeviceCard>
    with TickerProviderStateMixin {
  final int curRoomId;
  final Device device;
  final String signal;
  final Function onAdd;
  final Function onRemove;
  final bool roomInit;

  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _opacityAnimation;

  SingleDeviceCardState(
      {Key key,
      @required this.curRoomId,
      @required this.device,
      @required this.signal,
      @required this.onAdd,
      @required this.onRemove,
      @required this.roomInit,});

  @override
  void initState() {
    super.initState();
    print(6666666);
    _controller =
        new AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _scaleAnimation = new Tween(begin: 1.0, end: 0.8).animate(_controller);
    _opacityAnimation = new Tween(begin: 1.0, end: 0.0).animate(_controller);

    // _animation.addListener((){
    //   setState(() {

    //   });
    // });

    if(roomInit == false){
      print('singleCardRoomInit:$roomInit');
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _removeCurRoomDevice() {
    print("delDeviceId: ${device.deviceId}");
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onRemove(curRoomId, device);
      }
    });
  }

  void _addDeviceToCurRoom() {
    print("addDeviceId: ${device.deviceId}");
    if (curRoomId == null) {
      _controller.forward();
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          onAdd(curRoomId, device);
        }
      });
    } else {
      //其他房间
      _showDialog(curRoomId, device, context);
    }
  }

  _showDialog(curRoomId, device, context) {
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
                      onPressed: () => _confirmAdd(curRoomId, device, context),
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

  _confirmAdd(curRoomId, device, context) {
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onAdd(curRoomId, device);
      }
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print("deviceId:${device.deviceId}");
    return FadeTransition(
        // key: UniqueKey(),
        opacity: _opacityAnimation,
        child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              // key: UniqueKey(),
              width: ScreenUtil().setWidth(345),
              height: ScreenUtil().setHeight(235),
              margin: EdgeInsets.only(bottom: 10.0),
              child:  Stack(
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
                      // padding: EdgeInsets.only(
                      //     top: ScreenUtil().setHeight(6),
                      //     // bottom: ScreenUtil().setHeight(100)
                      //     ),
                      child: Image(
                        image: NetworkImage(device.appPicUrl
                            // "https://img10.360buyimg.com/n5/s54x54_jfs/t1/1325/27/9916/31986/5bc946c9E748626df/79850cb5c7d8a7f0.jpg"
                            ),
                        width: ScreenUtil().setWidth(150),
                        height: ScreenUtil().setHeight(150),
                      ),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(80),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(4.0, 4.0),
                            bottomRight: Radius.elliptical(4.0, 4.0)),
                        color: Color(0xff43486F),
                      ),
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(6)),
                      child: new Row(children: <Widget>[
                        new Expanded(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
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
                                  onPressed: _removeCurRoomDevice,
                                )
                              : IconButton(
                                  padding: EdgeInsets.all(0.0),
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Color(0xff78FBFF),
                                  ),
                                  onPressed: _addDeviceToCurRoom,
                                ),
                        ))
                  ],
                ),
              ),
            ));
  }
}

class NoDevices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(left: _horizontalMargin, right: _horizontalMargin),
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

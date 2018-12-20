import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'dart:io';

import './editRoom.dart';

import '../../model/RoomsModel.dart';

class RoomList extends StatefulWidget {
  final houseId;
  RoomList(this.houseId);
  @override
  RoomListState createState() => new RoomListState(houseId);
}

class RoomListState extends State<RoomList> {
  final houseId;
  RoomListState(this.houseId);
  bool _editing = false;
  bool _isLoading = true;

  List<Room> _rooms;
  Room _defaultRoom;

  final TextStyle _fontStyle = TextStyle(
      fontSize: ScreenUtil().setSp(28, false), color: Color(0xffDEDFE8));

  @override
  void initState() {
    super.initState();
    _getList(houseId);
  }

  //  获取房间类表
  _getList(String houseId) async {
    var httpClient = new HttpClient();
    String uri =
        "https://easy-mock.com/mock/5c1362e3bb577d1fbc488206/s/service/getRoomsByHouse";


    try {
      var request = await httpClient.getUrl(Uri.parse(uri));
      var response = await request.close();
      String  responseBody = await response.transform(utf8.decoder).join();
      Map result = json.decode(responseBody);
      print(result["data"]["rooms"]);
      Rooms rooms = new Rooms.fromJson(result['data']);
      List<Room> roomList = rooms.rooms;
      Room defaultRoom;
      for (var item in roomList) {
        if (item.roomId == null) {
          defaultRoom = item;
        }
      }
      print(defaultRoom.deviceCnt);
      if (!mounted) return;
      setState(() {
        _rooms = roomList;
        _defaultRoom = defaultRoom;
        _isLoading = false;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0Xff3B426B),
        appBar: AppBar(
          title: Text(
            "房间管理",
            style: TextStyle(fontSize: ScreenUtil().setSp(36, false)),
          ),
          actions: <Widget>[
            GestureDetector(
              child: Container(
                padding: EdgeInsets.only(right: 10.0),
                alignment: Alignment.center,
                child: Text("添加房间",
                    style: TextStyle(
                        color: Color(0xff78FBFF),
                        fontSize: ScreenUtil().setSp(28, false))),
              ),
              onTap: () => _goEditRoom("未填写", 2),
            )
          ],
        ),
        body: _isLoading ? _listLoading() : _listShow());
  }

  Widget _listLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _listShow() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("有${_rooms.length}个房间",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(24, false),
                        color: Color(0xff7D80A2))),
                GestureDetector(
                  child: Text(_editing ? "完成" : "编辑",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(24, false),
                          color: Color(0xff78FBFF))),
                  onTap: _changeEditStatus,
                )
              ],
            ),
          ),
          // _otherRoomList(_editing, _rooms),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            decoration: BoxDecoration(
                color: Color(0xff5C628D),
                borderRadius: BorderRadius.circular(4.0)),
            child: Column(
              children:
                  _rooms.map((room) => _roomItem(_editing, room)).toList(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            decoration: BoxDecoration(
                color: Color(0xff5C628D),
                borderRadius: BorderRadius.circular(4.0)),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              title: Text("默认房间", style: _fontStyle),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _defaultRoom.deviceCnt == 0
                          ? Text("暂无设备",
                              style: TextStyle(color: Color(0xffADB0C6)))
                          : Text("有${_defaultRoom.deviceCnt}个设备",
                              style: _fontStyle),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Color(0xffADB0C6),
                  )
                ],
              ),
              onTap: () => _goEditRoom("默认房间", null),
            ),
          )
        ],
      ),
    );
  }

//  点击 编辑/完成
  void _changeEditStatus() {
    setState(() {
      _editing = !_editing;
    });
  }

  // 房间列表项
  Widget _roomItem(bool _editing, Room room) {
    final _fontStyle = TextStyle(
        fontSize: ScreenUtil().setSp(28, false), color: Color(0xffDEDFE8));
    print(room.roomId);

    return Container(
      padding: EdgeInsets.only(left: 5.0),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1.0, color: Color(0Xff3B426B)))),
      child: room.deviceCnt == null
          ? null
          : ListTile(
              // 判断是否是默认房间
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              leading: _editing
                  ? IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: Color(0xffFF6262),
                        size: 18.0,
                      ),
                      onPressed: null,
                    )
                  : null,
              title: Text(room.roomName, style: _fontStyle),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _editing
                      ? Text("")
                      : room.deviceCnt == 0
                          ? Text("暂无设备",
                              style: TextStyle(color: Color(0xffADB0C6)))
                          : Text("有${room.deviceCnt}个设备",
                              style: _fontStyle),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Color(0xffADB0C6),
                  )
                ],
              ),
              onTap: _editing
                  ? null
                  : () => _goEditRoom(room.roomName, room.roomId),
            ),
    );
  }

// 进入编辑房间页面
  void _goEditRoom(String roomName, int roomId) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return new
          // FilterAnimationGoogleIOTutorial();
          EditRoom(roomName, roomId);
    }));
  }

//  使用 ListView ListView 必须放在一个 Flex 类里 如 Expanded, Flexible 等
  Widget _otherRoomList(_editing, _rooms) {
    final _fontStyle = TextStyle(fontSize: 14.0, color: Color(0xffDEDFE8));
    return Container(
        constraints: BoxConstraints(maxHeight: 470.0),
        margin: EdgeInsets.only(top: 20.0),
        decoration: BoxDecoration(
            color: Color(0xff5C628D), borderRadius: BorderRadius.circular(4.0)),
        child: Column(children: <Widget>[
          Flexible(
            // fit: FlexFit.tight,
            child: Container(
                child: ListView.separated(
                    itemCount: _rooms.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        leading: _editing
                            ? IconButton(
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Color(0xffFF6262),
                                  size: 18.0,
                                ),
                                onPressed: null,
                              )
                            : null,
                        title:
                            Text(_rooms[index]["room_name"], style: _fontStyle),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("有${_rooms[index]["device_cnt"]}个设备",
                                style: _fontStyle),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Color(0xffDEDFE8),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 1.0,
                        color: Color(0Xff3B426B),
                      );
                    })),
          )
        ]));
  }
}

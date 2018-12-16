import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import './houseName.dart';
import '../roomManagement/roomList.dart';

class HouseManagement extends StatelessWidget {
  final int houseId;
  final String houseName;
  final int roomCnt;
  HouseManagement(this.houseId, this.houseName, this.roomCnt);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0Xff3B426B),
      appBar: AppBar(
        title: Text("家庭管理", style: TextStyle(fontSize: ScreenUtil().setSp(36, false))),
      ),
      body: HouseRoomInfo(houseId, houseName, this.roomCnt),
    );
  }
}

class HouseRoomInfo extends StatefulWidget {
  final int houseId;
  final String houseName;
  final int roomCnt;
  HouseRoomInfo(this.houseId, this.houseName, this.roomCnt);
  @override
  HouseRoomInfoState createState() => new HouseRoomInfoState(houseId, houseName, roomCnt);
}

class HouseRoomInfoState extends State<HouseRoomInfo> {
  final int houseId;
  final String houseName;
  final int roomCnt;
  HouseRoomInfoState(this.houseId, this.houseName, this.roomCnt);

  final _fontStyle = TextStyle(
    fontSize: ScreenUtil().setSp(28,false),
    fontWeight: FontWeight.normal,
    color: Colors.white
  );

  @override
  Widget build(BuildContext context) {
    print("roomCnt: $roomCnt ");
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 52.0,
            padding: EdgeInsets.only(left: 15.0, right: 7.5),
            margin: EdgeInsets.only(bottom: 1.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color(0xff5C628D),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(4.0, 4.0),
                    topRight: Radius.elliptical(4.0, 4.0))),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("家庭名称", style: _fontStyle),
                GestureDetector(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("我的家", style: _fontStyle),
                      Icon(Icons.keyboard_arrow_right, color: Colors.white)
                    ],
                  ),
                  onTap: () => _houseName(houseId,houseName),
                )
              ],
            ),
          ),
          Container(
            height: 52.0,
            padding: EdgeInsets.only(left: 15.0, right: 7.5),
            margin: EdgeInsets.only(bottom: 1.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color(0xff5C628D),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(4.0, 4.0),
                    bottomRight: Radius.elliptical(4.0, 4.0))),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("房间管理", style: _fontStyle),
                GestureDetector(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("有 $roomCnt 个房间", style: _fontStyle),
                      Icon(Icons.keyboard_arrow_right, color: Colors.white)
                    ],
                  ),
                  onTap: () => _goRoomList("123"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _houseName(int id, String name){
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (context){
        return new HouseName(id, name);
      }
    ));
  }

  void _goRoomList(String houseId){
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (context){
        return new RoomList(houseId);
      }
    ));
  }
}

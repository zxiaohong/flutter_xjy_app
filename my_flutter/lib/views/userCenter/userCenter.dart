import "package:flutter/material.dart";

import 'package:flutter_screenutil/flutter_screenutil.dart';


class UserCenter extends StatefulWidget{

  @override
  UserCenterState createState() =>  new UserCenterState();

}

class UserCenterState extends State<UserCenter>{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      backgroundColor: Color(0Xff3B426B),
      appBar: AppBar(title: new Text("我的")),
      body:  Center(
          child: new Text(
            "我的",
            style: new TextStyle(
                fontSize: ScreenUtil().setSp(24),
                fontWeight: FontWeight.w500,
                fontFamily: "Georgia",
                color: Colors.white),
          ),
        ),
    );
  }
}
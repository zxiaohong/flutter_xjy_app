import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';


class SkillCenter extends StatefulWidget{
  @override
  SkillCenterState createState() => new SkillCenterState();
}

class SkillCenterState extends State<SkillCenter>{

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      backgroundColor: Color(0Xff3B426B),
      appBar: AppBar(title: new Text("技能中心")),
      body:  Center(
          child: new Text(
            "技能中心",
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
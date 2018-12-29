import 'package:flutter/material.dart';


import '../roomManagement/editRoomDevices.dart';


class SkillCenter extends StatefulWidget{
  @override
  SkillCenterState createState() => new SkillCenterState();
}

class SkillCenterState extends State<SkillCenter>{

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      backgroundColor: Color(0Xff3B426B),
      body: EditRoomDevice('次卧', 2),
    );
  }
}
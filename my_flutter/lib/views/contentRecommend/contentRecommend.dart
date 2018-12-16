import "package:flutter/material.dart";

import 'package:flutter_screenutil/flutter_screenutil.dart';


class ContentRecommend extends StatefulWidget {
  @override
  ContentRecommendState createState() => new ContentRecommendState();
}

class ContentRecommendState extends State<ContentRecommend> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0Xff3B426B),
      appBar: AppBar(title: new Text("内容推荐")),
      body:  Center(
          child: new Text(
            "内容推荐",
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

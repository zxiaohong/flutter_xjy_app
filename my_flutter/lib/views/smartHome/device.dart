import 'dart:io';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';

class DeviceCard extends StatefulWidget {
  @override
  DeviceCardState createState() => new DeviceCardState();
}

class DeviceCardState extends State<DeviceCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0Xff3B426B),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: DeviceCardView(),
      ),
    );
  }
}

class DeviceCardView extends StatefulWidget {
  @override
  DeviceCardViewState createState() => new DeviceCardViewState();
}

class DeviceCardViewState extends State<DeviceCardView> {
  var _devices = [];

  @override
  void initState() {
    super.initState();
    _getDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(40)),
      child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: ScreenUtil().setWidth(30),
        childAspectRatio: 1,
        mainAxisSpacing: ScreenUtil().setHeight(20)
      ),
      itemCount: _devices.length,
      itemBuilder: _singleDeviceCardBuilder,
    ),
    );


  }

  _getDevices() async {
    print('devices');
    var httpClient = new HttpClient();
    var uri = "https://easy-mock.com/mock/5c1362e3bb577d1fbc488206/s/service/getAllDevicesByHouseForAlphaApp";
    var result;
    try {
      var request = await httpClient.getUrl(Uri.parse(uri));
      var response = await request.close();
      print(response.statusCode);
      // print(HttpStatus.ok);
      if (response.statusCode == HttpStatus.ok) {
        var responseBody = await response.transform(utf8.decoder).join();
        print(responseBody);
        result = json.decode(responseBody);
        print(result);
        print(result["data"]["rooms"][0]["devices"][0]["app_pic_url"]);
        if(!mounted) return;
        setState(() {
          _devices = result["data"]["rooms"][0]["devices"] as List<dynamic>;
        });
      }
    } catch (e) {}
  }

  Widget _singleDeviceCardBuilder(BuildContext context, int index){
    return new Container(
        width: ScreenUtil().setWidth(320),
        height: ScreenUtil().setHeight(250),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: ScreenUtil().setHeight(160),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.elliptical(4.0, 4.0), topRight: Radius.elliptical(4.0, 4.0)),
                color: Color(0xffBABCDA),
              ),
              alignment: Alignment.topCenter,
              child: Image(
                  image: NetworkImage(
                    _devices[index]["app_pic_url"]
                    ),
                  width: ScreenUtil().setHeight(150),
                  height: ScreenUtil().setWidth(150),
                  ),
            ),
            Container(
              // height: ScreenUtil().setHeight(90),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(4.0, 4.0), bottomRight: Radius.elliptical(4.0, 4.0)),
                color: Color(0xffE9E9F4),
              ),
              padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
              child: new Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child:
                            Text(_devices[index]["device_name"], style: TextStyle(color: Color(0xff272B4A), fontSize: ScreenUtil().setSp(24, false))),
                      ),
                      Text(_devices[index]["is_weilian"] == "1" ? "电源开" :"电源关", style: TextStyle(color: Colors.grey[500], fontSize: ScreenUtil().setSp(20, false)))
                    ],
                  ),
                  Positioned(
                    right: 5.0,
                    top: 6.0,
                    child: new Icon(Icons.keyboard_arrow_right, color: Color(0xff62679C),size: 24.0,),
                  )
                ],
              )
            )
          ],
        ),
      );
  }

}


class SingleDeviceCard extends StatelessWidget{
  // final String imgUrl;
  // final String label;
  // final String status;
  final Map device;

  // SingleDeviceCard(this.imgUrl, this.label, this.status);
  SingleDeviceCard(this.device);
  @override
  Widget build(BuildContext context){
    return new Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.elliptical(4.0, 4.0), topRight: Radius.elliptical(4.0, 4.0)),
                color: Color(0xffBABCDA),
              ),
              padding: EdgeInsets.only(top: 15.0, bottom: 20.0),

              alignment: Alignment.topCenter,
              child: Image(
                  image: NetworkImage(
                    device["app_pic_url"]
                    ),
                  height: 150.0,
                  width: 150.0,
                  ),
            ),
            Container(
              height: ScreenUtil().scaleHeight(200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(4.0, 4.0), bottomRight: Radius.elliptical(4.0, 4.0)),
                color: Color(0xffE9E9F4),
              ),
              padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
              child: new Row(children: <Widget>[
                new Expanded(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(device['device_name'], style: TextStyle(color: Color(0xff272B4A))),
                      ),
                      Text(device["is_weilian"] == "1" ? "电源开" :"电源关", style: TextStyle(color: Colors.grey[500], fontSize: 10.0))
                    ],
                  ),
                ),
                // new Icon(Icons.keyboard_arrow_right, color: Color(0xff62679C))s
              ]),
            )
          ],
        ),
      );
  }
}

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';


class HouseName extends StatefulWidget {
  final String houseName;
  final int id;
  HouseName(this.id, this.houseName);
  @override
  HouseNameState createState() => new HouseNameState(id, houseName);
}

class HouseNameState extends State<HouseName> {
  String houseName;
  final int id;
  HouseNameState(this.id, this.houseName);

  final _fontStyle = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white);

  final TextEditingController _controller = new TextEditingController();
  @override
  String name;
  void initState() {
      // TODO: implement initState
      super.initState();
      name = houseName;
      _controller.text = houseName;
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0Xff3B426B),
      appBar: AppBar(
        title: Text("家庭名称", style: TextStyle(fontSize: 18.0)),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(right: 10.0),
              alignment: Alignment.center,
              child: Text("确定",
                  style: TextStyle(color: Color(0xff78FBFF), fontSize: 14.0)),
            ),
            onTap: _saveHouseName,
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: 52.0,
                padding: EdgeInsets.only(left: 15.0),
                margin: EdgeInsets.only(bottom: 10.0),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Color(0xff5C628D),
                    borderRadius: BorderRadius.circular(4.0)),
                child:
                  TextField(
                    keyboardAppearance: Brightness.light,
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    controller: _controller,
                    onChanged: _houseNameChange,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: GestureDetector(
                        child: Icon(Icons.close, size: 18.0, color: Color(0xffADB0C6)),
                        onTap: _clearValue,
                      ),
                      hintText: '请输入家庭名称',
                      hintStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Color(0xffADB0C6)),
                      // border:  UnderlineInputBorder(borderSide: BorderSide(width: 0.0, color: Colors.transparent))
                    ),
                    style: _fontStyle,
                ),
              ),
              Text(
                "       名称仅支持数字和汉字，最多8个汉字",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color(0xff7D80A2),
                ),
              )
            ],
          )),
    );
  }

  // 获取用户输入
  void _houseNameChange(String val) {
    setState(() {
      name = val;
    });
  }
  // 清除用户输入
  void _clearValue(){
    print(name);
    setState(() {
      name = "";
      _controller.text = "";
    });
  }

  //  保存家庭名称
  void _saveHouseName() async{
    Dio dio = new Dio();
    Response response;
    response= await dio.post("https://easy-mock.com/mock/5c1362e3bb577d1fbc488206/s/service/saveHouseName",data:{"id":id,"name":name});
    print(response.data['data']);
    Navigator.of(context).pop();
  }
}

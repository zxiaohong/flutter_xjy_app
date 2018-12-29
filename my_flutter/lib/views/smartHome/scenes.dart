import 'package:flutter/material.dart';

class Scenes extends StatefulWidget {
  @override
  ScenesState createState() => new ScenesState();
}

class ScenesState extends State<Scenes> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  VoidCallback _showBottomSheetCallback;
  PersistentBottomSheetController _controller;
  @override
  void initState() {
    super.initState();
    _showBottomSheetCallback = _showBottomSheet;
  }

  void _showBottomSheet() {
    // setState(() {
    //   _showBottomSheetCallback = null;
    // });
    if(_controller == null){
    _controller = _scaffoldKey.currentState.showBottomSheet((BuildContext context) {
      final ThemeData themeData = Theme.of(context);
      return new Container(
          decoration: new BoxDecoration(
              border: new Border(
                  top: new BorderSide(color: themeData.disabledColor))),
          child: new Padding(
              padding: const EdgeInsets.all(32.0),
              child: new Text('这是一个持久性的底部面板，向下拖动即可将其关闭',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      color: themeData.accentColor, fontSize: 24.0
                  )
              )
          )
      );
    });
    // .closed.whenComplete((){
    //   if(mounted){
    //     setState(() {
    //       // 重新启用按钮
    //       _showBottomSheetCallback = _showBottomSheet;
    //     });
    //   }
    // });
    }else{
      _controller.close();
      _controller = null;
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0Xff3B426B),
      body: Center(
        child: RaisedButton(
          child: Text('打开底部面板'),
          onPressed: _showBottomSheetCallback,
        ),
      ),
    );
  }
}

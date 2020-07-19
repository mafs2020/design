import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:iot_cel/utils/session.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // final session = new Session();

  @override
  void initState() {
    super.initState();
    this.setData();
  }

  setData() async {
    print('inicio');
    // si no encuentra nada regresara nullo
    // final data = await session.set('token', 'val');
    // final data1 = await session.set('user', 'val');
    // if(data != null){
    //   print('es true');
    //   Navigator.pushNamed(context, 'home', arguments: data1);
    // } else {
    //   print('es false');
    //   Navigator.pushNamed(context, 'login');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(child: CupertinoActivityIndicator(radius: 15.0),),
    );
  }
}
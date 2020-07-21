import 'package:diseno/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:iot_cel/utils/session.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final StorageMio storageMio = StorageMio();

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() async {
    final id = await storageMio.getteridUsuario();
    print('inicio $id');
    await Future.delayed( Duration(milliseconds: 500));
    if(id != null){
      // para que no regrese al login
      Navigator.pushReplacementNamed(context, 'home');
      return;
    }
    Navigator.pushNamed(context, 'login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(child: CupertinoActivityIndicator(radius: 15.0),),
    );
  }
}
import 'package:flutter/material.dart';

import 'package:diseno/pages/HomePage.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
      ),
      initialRoute: 'home',
      routes: <String, WidgetBuilder>{
        'home': (_) => HomePage(),
      },
    );
  }
}
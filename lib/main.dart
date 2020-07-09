import 'package:flutter/material.dart';

import 'package:diseno/pages/HomePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:diseno/utils/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ArgumentoProvider>(create: (_) => ArgumentoProvider(),),
      ],
    child: MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme()
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
      ),
      initialRoute: 'home',
      routes: <String, WidgetBuilder>{
        'home': (_) => HomePage(),
      },
    )
    );
  }
}
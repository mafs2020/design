import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:diseno/utils/provider.dart';
 
import 'package:diseno/pages/HomePage.dart';
import 'package:diseno/pages/Administrar_page.dart';
import 'package:diseno/pages/loginPages.dart';
import 'package:diseno/pages/administrarDevice.dart';


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
      initialRoute: 'administrar',
      routes: <String, WidgetBuilder>{
        'home': (_) => HomePage(),
        'administrar': (_) => AdministrarPage(),
        'admindevice': (_) => AdminDevices(),
        'login': (_) => LoginPage(),
      },
    )
    );
  }
}
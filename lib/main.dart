import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:diseno/utils/provider.dart';
import 'package:diseno/provider/push_notification_provider.dart';
 
import 'package:diseno/pages/splahPage.dart';
import 'package:diseno/pages/HomePage.dart';
import 'package:diseno/pages/Administrar_page.dart';
import 'package:diseno/pages/loginPages.dart';
import 'package:diseno/pages/administrarDevice.dart';

import 'pages/agregarUsuarioPage.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    final PushNotificationProvider _pushNotificationProvider = PushNotificationProvider();
    _pushNotificationProvider.initNotifications();
    _pushNotificationProvider.mensajesStream.listen((event) { 
      print('este es el main');
      // _navigatorKey.currentState.pushNamed('addUser');
     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ArgumentoProvider>(create: (_) => ArgumentoProvider(),),
      ],
    child: MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Material App',

      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      // theme: ThemeData(
      //   textTheme: GoogleFonts.poppinsTextTheme()
      //   the
      // ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
      ),
      initialRoute: 'splash',
      routes: <String, WidgetBuilder>{
        'home': (_) => HomePage(),
        'administrar': (_) => AdministrarPage(),
        'admindevice': (_) => AdminDevices(),
        'login': (_) => LoginPage(),
        'splash': (_) => SplashPage(),
        'addUser': (_) => AddUSerPAge(),
      },
    )
    );
  }
}

// dDV4rucajww:APA91bHB90o3Pj_BtVVfKpeBhgq7noUnN3gfIKG8we4_CaYbS2Xq6qvAGiB7qZHrf26XSdJw3IQlNVj6VAMmp7n-6T6CO2w1yc5sTVfw0ncgDDjsp7X1nf_zFgybSUvDjVEF9jB9Z72Y
import 'dart:async';

import 'package:diseno/models/envioModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  StreamController<String> _mensajesController = StreamController<String>.broadcast();
  Stream<String> get mensajesStream => _mensajesController.stream;

  static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) {
    print('====onBackgroundMessage====');
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

  }

  initNotifications() async {
    await _firebaseMessaging.requestNotificationPermissions();
    final _token = await _firebaseMessaging.getToken();
    print(_token);
    _firebaseMessaging.configure(
      onMessage: onMessage,
      onBackgroundMessage: onBackgroundMessage,
      onLaunch: onLaunch,
      onResume: onResume,
    );
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) {
    print('=====onMessage=====');
    print('message $message');
    // print('message ${message['data']}');
    // _mensajesController.sink.add(message['data']['lugar'] ?? '');
    // print('dddddddddddddddddd $d');
    if (message.containsKey('data')) {
      // Handle data message
      print('dataaaaa ${message['data']}');
      
      
      final fk_id_casa = int.parse(message['data']['fk_id_casa']);
      final id_device = int.parse(message['data']['id_device']);
      final estado = message['data']['estado'];
      final gpio = message['data']['gpio'];
      final nombre = message['data']['nombre'];
      final lugar = message['data']['lugar'];
      final fgfg = ItemNuevo(
        fkIdCasa: fk_id_casa,
        estado: estado,
        gpio: gpio,
        nombre: nombre,
        lugar: lugar,
        idDevice: id_device
        );
        print(fgfg);
      // final h = ItemNuevo(
        // estado: message['data']['estado'] ? true : false,
        // idDevice: message['data']['id_device'],
        // nombre: message['data']['nombre'],
        // gpio: message['data']['gpio'],
        // lugar: message['data']['lugar'],
        // fkIdCasa: message['data']['fk_id_casa']
      // );
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      print('notification ${message['notification']}');
      final dynamic notification = message['notification'];
      print(notification);
    }

  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) {
    print('=====onLaunch=====');
    print('message $message');
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

  }

  Future<dynamic> onResume(Map<String, dynamic> message) {
    print('=====onResume=====');
    print('message $message');
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

  }

  dispose(){
    _mensajesController?.close();
  }

}

// ecZT7yOXQn2FEeQBqDHACY:APA91bHAntCB6Nyl376N42fUwrQbG9zm-a-8-OW9zIlQ-CvUtMwLXKICV_mqwv7KvVAnK8HMTPY3pCLBua4ishj9UnP_kJVPdM-7Epw9w4pozfdwduaItCy7hA4xb-GVbEUeFkFQx2f9
// click_action: FLUTTER_NOTIFICATION_CLICK
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/foundation.dart';
import 'package:diseno/models/envioModel.dart';
// import 'package:diseno/models/envioModel.dart';
// import 'package:diseno/utils/provider.dart';
import 'package:diseno/utils/strems.dart';

class SocketCliente {
  final SocketIOManager _manager = SocketIOManager();
  final StremsMio stremsMio = StremsMio();
  // final ArgumentoProvider _argumentoProvider = ArgumentoProvider();
  ValueNotifier<List<ItemNuevo>> miValueListenable = ValueNotifier(null);
  List<ItemNuevo> datos = [];
  SocketIO _socket;

  // singleton
  static final SocketCliente _singleton = new SocketCliente._internal();
  factory SocketCliente() => _singleton;
  SocketCliente._internal();
  // singleton

  final _uri = "http://192.168.0.2:4000/";
  iniciarSocket() async {

    _socket = await _manager.createInstance(SocketOptions(_uri));
    _socket.connect();
    _socket.on('connected', (data) {
      print('===============conectado=============');
      print(data.toString());
    });

    _socket.onError((error){
      print('errorrrrr $error');
    });

    _socket.onConnectError((error){
      print('error');
      print('onConnectError $error');
    });

    _socket.onConnecting((data){
      print('===============onConnecting=============');
    });

    _socket.onReconnecting((data) {
      print('reconectando');
      print(data);
    });

    _socket.onDisconnect((data){
      print('===========onDisconnect=========== $data');
    });

    _socket.onReconnect((data){
      print('=============onReconnect=========== $data');
    });

    _socket.onConnect((data){
      print("============connected...=============");
      print('se conecto al socket');
      _socket.emit('unirSala', [{'id_casa':'4'}]);
    });

    _socket.on('backend', (data) {
      print('============0backend==========');
      print(data);
    });

    
    _socket.on('seActualizoExitosamente', (data) {
      // este es el que se utiliza
      print('seActualizoExitosamente');
      final d = ItemNuevo.fromJson(data['device']);
      for (var item in datos) {
        if(d.idDevice == item.idDevice){
          item.estado = d.estado;
          break;
        }
      }
      miValueListenable.value = datos;
      miValueListenable.notifyListeners();
      print('seActualizoExitosamente');
    });

    _socket.on('ocurrioUnError', (data) {
      // todo hacer que salga un error
    });

    _socket.on('emitir', (data) {
      print('============backend==========');
      // print( data.runtimeType);
      // stremss.input.add();
      // stremsMio.incrementar = f;
      // _argumentoProvider.counter = data['sumar'];
      // _argumentoProvider.incrementar(f);
      // stremsMio.input.add(f);
// data['sumar']
      // stremsMio.input.add(data['sumar']);
      for (final _item in data['sumar']) {
        final ItemNuevo d = ItemNuevo.fromJson(_item);
        datos.add(d);
      }
      miValueListenable.value = datos;
      
    });
  }

  disconnect() async {
    await _manager?.clearInstance(_socket);
  }

  enviar( ItemNuevo item ) {
    print('${itemNuevoToJson(item)} este es el valorrrrrrr');
    _socket.emit('angular', [{'device': itemNuevoToJson(item)}]);
  }



  cambiarIotModel( ItemNuevo iot ){
    print('patriarca $iot');
    enviar(iot);
    // miValueListenable.value = datos;
    // miValueListenable.notifyListeners();
  }

  agregarTodos(List<ItemNuevo> f ){
    datos = f;
  }
  
}
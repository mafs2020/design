import 'dart:convert';

import 'package:diseno/models/usuarioModel.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:diseno/models/envioModel.dart';
import 'package:diseno/socket/socket.dart';
// import 'package:realtime/utils/datos_DB.dart';

final SocketCliente socketCliente = SocketCliente();
// final Informacion informacion = Informacion();
class UsuarioProvider {
  final url = 'http://192.168.0.6:4000';
  ValueNotifier<List<UsuarioModel>> miValueListenable = ValueNotifier(null);

  Future<List<ItemNuevo>> login(String nombre, String password) async {
    try {
      final _data = await http.post('$url/usuario/login', body: {'nombre': nombre, 'password': password});
       if (_data.statusCode == 200) {
         List<ItemNuevo> _datos = [];
        final _response = jsonDecode(_data.body);
        for (final item in _response['devices']) {
          final d = ItemNuevo.fromJson(item);
          _datos.add(d);
        }
        socketCliente.datos = _datos;
        // print('cambiaste algoooooooo en usuario_provider 26');
        // socketCliente.agregarTodos(_datos);
        return _datos;
       }
    } catch (e) {
      print(e);
      return null;
    }
    return [];
  }

  Future<List<UsuarioModel>> usuarioPorCasa(int idCasa) async {
    try {
      final resp = await http.get('$url/usuario/$idCasa');
      List<UsuarioModel> _usuarios = [];
        final _response = jsonDecode(resp.body);
        for (final item in _response['usuarios']) {
          final d = UsuarioModel.fromJson(item);
          _usuarios.add(d);
        }
        miValueListenable.value = _usuarios;
        return _usuarios;

    } catch (e) {
      print(e);
      return null;
    }
  }

}
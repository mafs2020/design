import 'dart:convert';

import 'package:diseno/models/usuarioModel.dart';
import 'package:diseno/utils/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:diseno/models/envioModel.dart';
import 'package:diseno/socket/socket.dart';

final SocketCliente socketCliente = SocketCliente();
// final Informacion informacion = Informacion();
final StorageMio storageMio = StorageMio();
class UsuarioProvider {

  final url = 'http://192.168.0.7:4000';
  ValueNotifier<List<UsuarioModel>> miValueListenable = ValueNotifier(null);

  Future<List<ItemNuevo>> login(String nombre, String password) async {
    try {
      final _data = await http.post('$url/usuario/login', body: {'nombre': nombre, 'password': password});
       if (_data.statusCode == 200) {
          List<ItemNuevo> _datos = [];
          final _response = jsonDecode(_data.body);
          storageMio.guardarIdUsuario(_response['usuario']['id_usuario']);
          storageMio.guardarIdCasa(_response['devices'][0]['fk_id_casa']);
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
    return null;
  }

  Future<List<UsuarioModel>> usuarioPorCasa(String idCasa) async {
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

  Future<List<ItemNuevo>> usuarioDevices() async {
    // todo hacerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
    // final _idUsuario = await storageMio.getteridUsuario();
    final _idUsuario = await storageMio.getterguardarIdUsuarioOtro();
    print('llenar bote $_idUsuario');
    final _idCasa = await storageMio.getterIdCasa();
    try {
      final resp = await http.get('$url/usuario/device/$_idUsuario/$_idCasa');
      List<ItemNuevo> devices = [];
      final _response = jsonDecode(resp.body);
      for (final item in _response['devices']) {
        final d = ItemNuevo.fromJson(item);
        devices.add(d);
      }
      return devices;
    } catch (e) {
      print('ocurrio un error 76 usuarioprovider $e');
      return null;
    }
    // return null;
  }

  Future<int> getRol() async {
    final id = await storageMio.getterguardarIdUsuarioOtro();
    try {
      final response = await http.post('$url/rol/$id');
      final data = jsonDecode(response.body);
      // print(data['rol']['fk_id_rol']);
      // todo error
      // storageMio.guardarIdUsuarioOtro(data['rol']['fk_id_rol']);
      // todo error
      return data['rol']['fk_id_rol'];
    } catch (e) {
      print('ocurrio un error en usuario provoder 91 $e');
      return null;
    }
    // buscarRoles
  }

  Future<bool> actualizarUsuario(List<int>idDevices, int rol) async {
    print('idDevices $idDevices rol $rol');
    final id = await storageMio.getterguardarIdUsuarioOtro();
    // application/x-www-form-urlencoded
    
    final _idCasa = await storageMio.getterIdCasa();
    print('rol ${rol.toString()}, "id_casa": ${_idCasa.toString()}, "idDevices": ${idDevices.toString()}');
    // return true;
    try {
      http.put('$url/usuario/usuario/$id', body: {"rol": rol.toString(), "id_casa": _idCasa.toString(), "idDevices": idDevices.toString()});
      return true;
    } catch (e) {
      return false;
    }
  }
}
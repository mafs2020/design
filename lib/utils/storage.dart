import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageMio {
  // Create storage
  final _storage = new FlutterSecureStorage();

  guardarIdUsuario(int id) async {
    
    await _storage.write(key: 'idUsuario', value: id.toString());
  }

  getteridUsuario() async {
     final _idUsuario = await _storage.read(key: 'idUsuario');
     print('_idUsuario $_idUsuario getteridUsuario este es el usuario principal');
     return _idUsuario;
  }

  guardarIdCasa(int id) async {
    await _storage.write(key: 'idCasa', value: id.toString());
  }
  getterIdCasa() async {
     final _idCasa = await _storage.read(key: 'idCasa');
     print('id de la casa $_idCasa getterIdCasa');
     return _idCasa;
  }

  borrarIdUsuario() async {
    await _storage.delete(key: 'idUsuario');
    print('se borro id usuario');
  }

  borrarIdCasa() async {
    await _storage.delete(key: 'idCasa');
    print('se borro id casa');
  }

  guardarIdUsuarioOtro(int id) async {
    print('idddddddddddddddddddddddd $id');
    await _storage.write(key: 'idUsuarioOtro', value: id.toString());
  }

  getterguardarIdUsuarioOtro() async {
     final _idCasa = await _storage.read(key: 'idUsuarioOtro');
     print('$_idCasa getterguardarIdUsuarioOtro este es el usuarioseleccionado');
     return _idCasa;
  }

}
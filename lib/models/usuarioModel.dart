import 'package:meta/meta.dart';

// To parse this JSON data, do
//
//     final itemNuevo = itemNuevoFromJson(jsonString);

import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) => UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
    UsuarioModel({
      @required this.idUsuario,
      // @required this.fkIdCasa,
      @required this.nombre,
      this.rol,
      this.password,
      // @required this.lugar,
      // @required this.gpio,
      // @required this.estado,
    });

  int idUsuario;
  String nombre, password, rol;

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
    idUsuario: json["id_usuario"],
    nombre: json["nombre"],
    password: json["password"],
    rol: json['rol']
  );

  Map<String, dynamic> toJson() => {
    "id_usuario": idUsuario,
    "nombre": nombre,
    "password": password,
    "rol": rol
  };

}
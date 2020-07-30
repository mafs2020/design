import 'package:meta/meta.dart';

// To parse this JSON data, do
//
//     final itemNuevo = itemNuevoFromJson(jsonString);

import 'dart:convert';

ItemNuevo itemNuevoFromJson(String str) => ItemNuevo.fromJson(json.decode(str));

String itemNuevoToJson(ItemNuevo data) => json.encode(data.toJson());

class ItemNuevo {
    ItemNuevo({
      @required this.idDevice,
      @required this.fkIdCasa,
      @required this.nombre,
      @required this.lugar,
      @required this.gpio,
      @required this.estado,
    });

  int idDevice, fkIdCasa;
  String nombre, lugar, gpio;
  bool estado;

    // print(json);
    // print('llegoooo');
  factory ItemNuevo.fromJson(Map<String, dynamic> json) => ItemNuevo(
    idDevice: json["id_device"],
    fkIdCasa: json["fk_id_casa"],
    nombre: json["nombre"],
    lugar: json["lugar"],
    gpio: json["gpio"],
    estado : json['estado'] == 1 ? true : false
  );

  Map<String, dynamic> toJson() => {
    "id_device": idDevice,
    "fk_id_casa": fkIdCasa,
    "nombre": nombre,
    "lugar": lugar,
    "gpio": gpio,
    "estado": estado
  };

}
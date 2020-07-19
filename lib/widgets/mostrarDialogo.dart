import 'package:flutter/material.dart';

mostrarDialogo(BuildContext context, String titulo, String contenido){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titulo, style: TextStyle()),
        content: Text(contenido),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.close),
            onPressed: () => Navigator.pop(context)
          )
        ],
      );
    }
  );
}
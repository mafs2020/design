import 'package:flutter/material.dart';

// final InputDecoration decoradorInput = InputDecoration(
//   labelText: 'Usuario',
//   hintText: 'Usuario',
//   hoverColor: Colors.deepPurple,
//   focusColor: Colors.deepPurple,
//   border: OutlineInputBorder(
//     borderRadius: BorderRadius.circular(15)
//   )
// );

InputDecoration regresarDecorador(String campo){
  final InputDecoration decoradorInput = InputDecoration(
    labelText: campo,
    hintText: campo,
    hoverColor: Colors.deepPurple,
    focusColor: Colors.deepPurple,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15)
    )
  );
  return decoradorInput;
}
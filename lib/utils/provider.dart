import 'package:flutter/material.dart';

class ArgumentoProvider extends ChangeNotifier {
  int _i = 5;
  int get counter => _i;

  set counter(int i) {
    print('este es el provider $i');
    _i = i;
    notifyListeners();
  }

  incrementar(int derecha) => this.counter = _i + derecha;

  decrementar() => counter = _i - 1;
  
}
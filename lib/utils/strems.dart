import 'dart:async';

import 'package:diseno/utils/provider.dart';

final ArgumentoProvider argumentoProvider = ArgumentoProvider();

class StremsMio {
  StreamController<int> strems = StreamController<int>();

  Sink<int> get input => strems.sink;

  Stream<int> get outpu => strems.stream;

  set incrementar(int _stremHelp){
    argumentoProvider.counter = _stremHelp;
    print('_strem__strem_ $_stremHelp');

    strems.add(_stremHelp);
    strems.sink.add(_stremHelp);
    strems.add(_stremHelp);
    outpu.listen((event) { print('$event listen'); });

  }
  cerrar() => strems?.close();
}
import 'package:flutter/material.dart';

import 'package:diseno/utils/storage.dart';
import 'package:diseno/models/envioModel.dart';
// import 'package:provider/provider.dart';
import 'package:diseno/usuarioProvider/usuario_provider.dart';
// import 'package:diseno/utils/provider.dart';
// import 'package:diseno/utils/strems.dart';
import '../socket/socket.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final StremsMio stremss = StremsMio();
  final UsuarioProvider usuarioProvider = UsuarioProvider();
  final SocketCliente socketCliente = SocketCliente();
  final StorageMio storageMio = StorageMio();
  int _rol;
  @override
  void initState() {
    iniciar();
    super.initState();
  }
  iniciar() async {
    socketCliente.iniciarSocket();
    // final res = await usuarioProvider.login('henry', '123456');
    // socketCliente.miValueListenable.value = res;
    await usuarioProvider.milistaDevice();
    final _roll = await storageMio.getterRol();
    _rol = int.parse(_roll);
    setState(() { });
    
    // socketCliente.miValueListenable.value = _devices;
  }

  @override
  void dispose() {
    socketCliente.disconnect();
    // stremss?.cerrar();
    super.dispose();
  }

  emitirEvento(ItemNuevo data) {
    print('home page 48');
    socketCliente.cambiarIotModel(data);
  }

  void cerrarSesion(){
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('usuario', style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('cerrar sesion'),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.done_outline),
            onPressed: () {
              Navigator.pop(context);
              storageMio.limpiarTodo();
              Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
            }
          ),
          FlatButton(
            child: Icon(Icons.close),
            onPressed: () => Navigator.pop(context)
          )
        ],
      );
    }
  );
  }

  @override
  Widget build(BuildContext context) {
    // final ArgumentoProvider argumentoProvider = Provider.of<ArgumentoProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        drawerEnableOpenDragGesture: _rol == 1 ? true : false,
        drawer: (_rol == 1) ? Drawer(
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () => Navigator.pushNamed(context, 'administrar'),
                title: Text('Actualizar usuario'),
              ),
              ListTile(
                onTap: () => Navigator.pushNamed(context, 'addUser'),
                title: Text('Agregar usuario'),
              )
            ]
          ),
        ) : null,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black38,
          title: Text('RealTime'),
          actions: <Widget>[ Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(icon: Icon(Icons.account_circle), onPressed: cerrarSesion)
          ) ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(10.0),
          child: 
          ValueListenableBuilder(
            valueListenable: socketCliente.miValueListenable,
            builder: (BuildContext context, List<ItemNuevo> value, _) {
              print('estees el valor $value');
              if(value == null) return Center(child: CircularProgressIndicator());
                return GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 8.0,
                padding: EdgeInsets.all(5.0),
                children: contenedor(value)
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> contenedor(List<ItemNuevo> datos) {
    return datos.map((ItemNuevo e) => InkWell(
      onTap: () => emitirEvento(e),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: e.estado ? Colors.lightBlue[200] : Colors.grey[200],
            borderRadius: BorderRadius.circular(25)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Opacity(
              //   opacity: e.estado ? 0.7 : 0.4,
              //   child: Icon(Icons.lightbulb_outline, color: e.estado ? Colors.yellow[400] : Colors.white30, size: 40.0,)
              // ),
              Icon(
                Icons.lightbulb_outline,
                size: 32.0,
                color: e.estado ? Colors.yellow[400] : Colors.grey[500]
              ),
              SizedBox(height: 8),
              Text(
                e.lugar,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: e.estado ? Colors.white : Colors.grey[500], fontSize: 22.0, fontWeight: FontWeight.w500),
              )
              // Container(child: Text(e.lugar, overflow: TextOverflow.ellipsis, style: TextStyle(color: e.estado ? Colors.white : Colors.white30, fontSize: 22.0, fontWeight: FontWeight.w500))),
            ]
          )
        ),
      )
    )).toList();
  }

}


// AspectRatio(
//   aspectRatio: 1.0,
//   child: Container(
//     decoration: BoxDecoration(
//       color: Colors.grey[200],
//       borderRadius: BorderRadius.circular(25)
//     ),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Icon(
//           Icons.lightbulb_outline,
//           size: 32.0,
//           color: Colors.grey[500],
//         ),
//         SizedBox(height: 8),
//         Text(
//           'menu option',
//           style: TextStyle(
//             color: Colors.grey[500],
//             fontSize: 18.0
//           ),
//         )
//       ],
//     ),
//   ),
// );




class MiStrem extends StatelessWidget {
  final AsyncSnapshot<int> data;
  MiStrem({this.data});
  @override
  Widget build(BuildContext context) {
switch (data.connectionState) {
      case ConnectionState.none:
        return Text('ocurrio un error');
        break;
      case ConnectionState.waiting:
        return Container(
          decoration: BoxDecoration(
            color: Colors.greenAccent
          ),
          child: Text('esperando'),
        ); 
        break;
      case ConnectionState.active:
        return Container(
          decoration: BoxDecoration(
            color: Colors.red
          ),
          child: Text('${data.data}'),
        );
        break;
      case ConnectionState.done:
        return Text('acabo el ciclo');
      break;
      default: return CircularProgressIndicator();
    }
  }
}

// floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           FloatingActionButton.extended(
//             onPressed: () => { 
//               stremss.input.add(i--)
//               },
//             label: Text('restar'),
//             icon: Icon(Icons.thumb_up),
//             backgroundColor: Colors.pink
//           ),
//           FloatingActionButton.extended(
//             onPressed: () => { 
//               stremss.input.add(i++)
//               },
//             label: Text('Sumar'),
//             icon: Icon(Icons.thumb_up),
//             backgroundColor: Colors.pink
//           ),
//         ],
//       )

// PROVIDER
// Container(
//   child: Center(
//     child: Text(argumentoProvider.counter.toString(), style: TextStyle(fontSize: 25.0, color: Colors.white)),
//   )
// ),

// STREMS
// StreamBuilder<int>(
//   stream: stremss.outpu,
//   builder: (BuildContext context, AsyncSnapshot<int> snapshot){
//     print('snapshot.data ${snapshot.data}');
//     return MiStrem(data: snapshot);
//   }
// ),

// BottomNavigationBar(
//           currentIndex: 1,
//           onTap: (int i) => print(i.toString()),
//           iconSize: 22.0,
//           items: <BottomNavigationBarItem>[
//             BottomNavigationBarItem(icon: Icon(Icons.add_to_queue), title: Text('uno'), backgroundColor: Colors.red),
//             BottomNavigationBarItem(icon: Icon(Icons.airplanemode_active), title: Text('dos'))
//           ]
//         ),
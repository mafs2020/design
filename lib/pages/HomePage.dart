import 'package:flutter/material.dart';

import 'package:diseno/utils/storage.dart';
import 'package:diseno/models/envioModel.dart';
import 'package:diseno/usuarioProvider/usuario_provider.dart';
import '../socket/socket.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UsuarioProvider usuarioProvider = UsuarioProvider();
  final SocketCliente socketCliente = SocketCliente();
  final StorageMio storageMio = StorageMio();
  final List<String> cuartos = ['cuarto', 'cuarto 2', 'cuarto 3', 'cuarto 4', 'cocina','baño','sala','comedor','cocina','cuarto principal','cuarto secundario', 'jardin'];
  int seleccionado = 0;
  int _rol;

  @override
  void initState() {
    iniciar();
    super.initState();
  }

  iniciar() async {
    socketCliente.iniciarSocket();
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

  void cambiar(int i, String ubicacion) async {
    setState(() { seleccionado = i; });
    ubicacion = ubicacion ?? 'cuarto';
    await usuarioProvider.ubicacion(ubicacion);
  }

  @override
  Widget build(BuildContext context) {
    // final ArgumentoProvider argumentoProvider = Provider.of<ArgumentoProvider>(context);
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.black38,
        drawerEnableOpenDragGesture: _rol == 1 ? true : false,
        drawer: _rol == 1 ? _buildDrawer(context) : null,
        appBar: _buildAppBar(),
        body: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.1,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.only(
              //     bottomRight: Radius.circular(20),
              //     bottomLeft: Radius.circular(20),
              //   ),
                // border: Border.all(width: 3,color: Colors.green,style: BorderStyle.solid)
              // ),
              child: buildListView(),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.white,
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     begin: AlignmentDirectional.bottomEnd,
                //     colors: <Color>[
                //     Color.fromRGBO(40, 138, 143, 0.5),
                //     Color.fromRGBO(10, 138, 93, 0.5)
                //     // Color.fromRGBO(200, 200, 180, 0.5),
                //   ])
                // ),
                child: ValueListenableBuilder(
                  valueListenable: socketCliente.miValueListenable,
                  builder: (BuildContext context, List<ItemNuevo> value, _) {
                    // print('estees el valor $value');
                    if(value == null) return Center(child: CircularProgressIndicator());
                      return GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 8.0,
                      padding: EdgeInsets.all(5.0),
                      children: contenedor(value)
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: cuartos.length,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int i) {
        final String nombre = cuartos[i];
        return InkWell(
          onTap: () => cambiar(i, nombre),
          child: Container(
            decoration: BoxDecoration(
              color: i == seleccionado ? Colors.orangeAccent : Colors.transparent,
              borderRadius: BorderRadius.circular(15.0)
            ),
            padding: EdgeInsets.all(20.0),
            child: Text(nombre.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w500 ), overflow: TextOverflow.ellipsis)
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        centerTitle: true,
        backgroundColor: Colors.black38,
        title: Text('RealTime'),
        actions: <Widget>[ Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(icon: Icon(Icons.account_circle), onPressed: cerrarSesion)
        ) ],
      );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Container(),
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage(''),
                //   fit: BoxFit.cover
                // )
              ),
            ),
            // DrawerController(child: null, alignment: null)
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
      );
  }

  List<Widget> contenedor(List<ItemNuevo> datos) {
    
    return datos.map((ItemNuevo e) => GestureDetector(
      onTap: () => emitirEvento(e),
      child: Container(
        decoration: BoxDecoration(
          color: e.estado ? Colors.lightBlue[200] : Colors.black12,
          // color: e.estado ? Colors.lightBlue[200] : Colors.grey[200],
          borderRadius: BorderRadius.circular(25)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.lightbulb_outline,
              size: 35.0,
              color: e.estado ? Colors.yellow[400] : Colors.grey[500]
            ),
            Text(
              e.lugar,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: e.estado ? Colors.white : Colors.grey[500], fontSize: 22.0, fontWeight: FontWeight.w500)
            )
          ]
        )
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



// ==================== ORIGINAL =====================
// Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: AlignmentDirectional.bottomEnd,
//               colors: <Color>[
//               Color.fromRGBO(40, 138, 143, 0.5),
//               Color.fromRGBO(10, 138, 93, 0.5),
//               // Color.fromRGBO(200, 200, 180, 0.5),
//             ])
//           ),
//           padding: EdgeInsets.all(10.0),
//           child: ValueListenableBuilder(
//             valueListenable: socketCliente.miValueListenable,
//             builder: (BuildContext context, List<ItemNuevo> value, _) {
//               // print('estees el valor $value');
//               if(value == null) return Center(child: CircularProgressIndicator());
//                 return GridView.count(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 20.0,
//                 crossAxisSpacing: 8.0,
//                 padding: EdgeInsets.all(5.0),
//                 children: contenedor(value)
//               );
//             },
//           ),
//         ),
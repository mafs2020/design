import 'package:diseno/models/usuarioModel.dart';
import 'package:diseno/usuarioProvider/usuario_provider.dart';
import 'package:diseno/utils/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdministrarPage extends StatefulWidget {
  @override
  _AdministrarPageState createState() => _AdministrarPageState();
}

class _AdministrarPageState extends State<AdministrarPage> {

  // final _formKey = GlobalKey<FormState>();
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  final UsuarioProvider usuarioProvider = UsuarioProvider();

  List<UsuarioModel> usuarios = [];
  StorageMio storageMio = StorageMio();

  // void enviar(){
  //   if (_formKey.currentState.validate()) {
  //     print('es valido');
  //   } else {
  //     print('no es valido');
  //   }
  // }

  void navegar(UsuarioModel usuario) async {
    print('este es el id del usuario ${usuario.idUsuario}');
    await storageMio.guardarIdUsuarioOtro( usuario.idUsuario );
    Navigator.pushReplacementNamed(context, 'admindevice');
  }

  @override
  void initState() {
    obtenerUsuarios();
    super.initState();
  }

  obtenerUsuarios() async {
    // id casa
    final id = await storageMio.getterIdCasa();
    usuarios = await usuarioProvider.usuarioPorCasa(id);
    // setState(() { });
    if(usuarios != null){
      
    }else {
      print('ocurrio un error');
      // Scaffold
      //     .of(context)
      //     .showSnackBar(SnackBar(content: Text('Processing Data')));
    }
  }

  Future<bool> eliminarUsuario(UsuarioModel user) async {
    print(user.idUsuario);
    return await showCupertinoDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Text("Deseas eliminar el usuario ${user.nombre}"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Ok"),
              onPressed: () async {
                try {
                  final isTrue = await usuarioProvider.eliminarUsuario(user.idUsuario.toString());
                  if(isTrue){
                    usuarios.remove(user);
                    return Navigator.of(context).pop(true);
                  }
                  return Navigator.of(context).pop(false);
                } catch (e) {
                  return Navigator.of(context).pop(false);
                }
              },
            ),
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                return Navigator.of(context).pop(false);
              },
            )
          ],
        ),
      );
    //   _scaffoldKey.currentState
    //     .showSnackBar(
    //       SnackBar(
    //         content: Text("$action. Do you want to undo?"),
    //         duration: Duration(seconds: 5),
    //         action: SnackBarAction(
    //             label: "Undo",
    //             textColor: Colors.yellow,
    //             onPressed: () {
    //               // Deep copy the email
    //               final copiedEmail = Email.copy(swipedEmail);
    //               // Insert it at swiped position and set state
    //               setState(() => items.insert(index, copiedEmail));
    //             }),
    //       ),
    //     )
    //     .closed
    //     .then((reason) {
    //   if (reason != SnackBarClosedReason.action) {
    //     // The SnackBar was dismissed by some other means
    //     // that's not clicking of action button
    //     // Make API call to backend
        
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        // key: _scaffoldKey,
      appBar: AppBar(centerTitle: true, title: Text('Administrar Usuario')),
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
            valueListenable:  usuarioProvider.miValueListenable,
            builder: (BuildContext context, List<UsuarioModel> value, Widget _) {
              if(value == null) return Center(child:CircularProgressIndicator());
              return Column(
                children: regresar(value)
              );
            }
          ),
        ),
      )
    );

  }

  List<Widget> regresar(List<UsuarioModel> usuarioss) {
    List<dynamic> _checks = usuarioss.map((e) =>
      Dismissible(
        // confirmDismiss: ,
        direction: DismissDirection.endToStart,
        // se ejecuta hasta eliminar algo
        onResize: () => print('se hizo mas chico'),
        // onDismissed: (DismissDirection d) => print('este es el $d'),
        confirmDismiss: (DismissDirection direccion) => eliminarUsuario(e),
          // DismissDirectio,
        // dragStartBehavior: DragStartBehavior.down,
        dismissThresholds: {
          // DismissDirection.startToEnd: 0.1,
          DismissDirection.endToStart: 0.5
        },
        // key: Key(e.idUsuario.toString()),
        key: UniqueKey(),
        // key: ValueKey(e),
        background: Container(
          color: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: AlignmentDirectional.centerEnd,
          child: Icon(Icons.delete, color: Colors.white),
        ),
        child: Padding(
          padding: const EdgeInsets.only( top: 20.0, right: 15.0, left: 15.0 ),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: ListTile(
                  title: Text(e.nombre),
                  subtitle: Text(e.rol),
                  onTap: () => navegar(e),
                  trailing: Icon( Icons.arrow_right, color: Colors.blue, size: 40.0)
                )
              ),
              Divider(height: 5.0)
            ]
          ),
        ),
      )
    ).toList();
    return _checks;
  }

}
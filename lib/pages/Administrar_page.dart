import 'package:diseno/models/usuarioModel.dart';
import 'package:diseno/pages/administrarDevice.dart';
import 'package:diseno/usuarioProvider/usuario_provider.dart';
import 'package:diseno/utils/storage.dart';
import 'package:flutter/material.dart';

class AdministrarPage extends StatefulWidget {
  @override
  _AdministrarPageState createState() => _AdministrarPageState();
}

class _AdministrarPageState extends State<AdministrarPage> {

  // final _formKey = GlobalKey<FormState>();
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
    // Navigator.popAndPushNamed(context, 'admindevice');
    // Navigator.popUntil(context, ModalRoute.withName('admindevice'));
    // Navigator.of(context).pop();
    // Navigator.pushReplacementNamed(context, 'admindevice');
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AdminDevices( usuario: usuario ),
    //   ),
    // );
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

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
            valueListenable:  usuarioProvider.miValueListenable,
            builder: (BuildContext context, List<UsuarioModel> value, Widget _) {
              if(value == null) return Center(child: CircularProgressIndicator());
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
      Padding(
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
                trailing: Icon( Icons.arrow_right, color: Colors.blue, size: 30.0)
              )
            ),
            Divider(height: 5.0)
          ]
        ),
      )
    ).toList();
    return _checks;
  }

}
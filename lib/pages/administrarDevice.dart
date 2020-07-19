import 'package:diseno/models/envioModel.dart';
import 'package:diseno/models/usuarioModel.dart';
import 'package:diseno/usuarioProvider/usuario_provider.dart';
import 'package:diseno/utils/storage.dart';
import 'package:diseno/widgets/mostrarDialogo.dart';
import 'package:flutter/material.dart';

class AdminDevices extends StatefulWidget {
  AdminDevices({Key key}) : super(key: key);

  @override
  _AdminDevicesState createState() => _AdminDevicesState();
}

final UsuarioProvider usuarioProvider = UsuarioProvider();
final StorageMio storageMio = StorageMio();
List<ItemNuevo> devices = [];
int _cambio;
List<int> _idDevices = [];

class _AdminDevicesState extends State<AdminDevices> {

  @override
  void initState() {
    dispositivos();
    super.initState();
  }
  @override
  void dispose() { 
    devices?.clear();
    _idDevices?.clear();
    super.dispose();
  }

  dispositivos() async {
    // final storageMio.getIdUsuarioDevice();
    devices = await usuarioProvider.usuarioDevices();
    // todo bien hasta aqui
    _cambio = await usuarioProvider.getRol();
    if(_cambio == 1){
      agregarDevicesForAdmin();
    }
    // devices.forEach((element) {  print('${element.idDevice} : ${element.estado}');});
    setState(() {});
  }
  agregarDevicesForAdmin(){
    devices.forEach((e) => _idDevices.add(e.idDevice));
      devices = devices.map((e) {
        e.estado = true;
        return e;
      }).toList();
  }

  cambiarRadio(int valor) {
    if(valor == 1){
      agregarDevicesForAdmin();
    } else {
      _idDevices?.clear();
      devices = devices.map((e) {
        e.estado = false;
        return e;
      }).toList();
    }
    setState(() => _cambio = valor);
  }

  void cambiarEstado(ItemNuevo device){

    final index = devices.indexOf(device);
    devices[index].estado = !devices[index].estado;
    if(_idDevices.contains(device.idDevice)){
      _idDevices.remove(device.idDevice);
    } else {
      _idDevices.add(device.idDevice);
    }
    _idDevices.map((e) => print(e));
    setState(() {});
  }
  actualizarUsuario() async {
    // print('$_idDevices, $_cambio es aqui');
    if(_idDevices.isEmpty){
      return;
    }

    final isTrue = await usuarioProvider.actualizarUsuario(_idDevices, _cambio);
    if(isTrue){
      
      Navigator.pushNamed(context, 'administrar');
      
      // Navigator.of(context).pushNamed('administrar');
      mostrarDialogo(context, 'Actualizacion', 'se actualizo con exito');
    }else {
      print('ocurrio un error');
    }

  }

  @override
  Widget build(BuildContext context) {
  
    // final UsuarioModel args = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(children: listaDevices()),
                Divider(),
                RadioListTile(value: 1, groupValue: _cambio, onChanged: cambiarRadio, title: Text('Administrador')),
                Divider(),
                RadioListTile(value: 2, groupValue: _cambio, onChanged: cambiarRadio, title: Text('Usuario')),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton.icon(color: Colors.deepPurple, onPressed: actualizarUsuario, icon: Icon(Icons.send, color: Colors.white,), label: Text('actualizar', style: TextStyle(color: Colors.white))),
                ),
              ]
            )
          ),
        ),
      ),
    );
  }

  List<Widget> listaDevices() {
    final f = devices.map(( ItemNuevo e) => CheckboxListTile(value: e.estado, onChanged: (_cambio != 1) ? (estado) => cambiarEstado(e) : null, title: Text(e.lugar))).toList();
    return f;
  }

}
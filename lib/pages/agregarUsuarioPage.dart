import 'package:diseno/models/envioModel.dart';
import 'package:diseno/usuarioProvider/usuario_provider.dart';
import 'package:diseno/utils/decoradorInput.dart';
import 'package:diseno/utils/storage.dart';
import 'package:diseno/widgets/mostrarDialogo.dart';
import 'package:flutter/material.dart';

class AddUSerPAge extends StatefulWidget {
  @override
  _AddUSerPAgeState createState() => _AddUSerPAgeState();
}

final StorageMio storageMio = StorageMio();
final UsuarioProvider usuarioProvider = UsuarioProvider();
List<ItemNuevo> devices = [];
int _cambio;
List<int> _idDevices = [];
final _formKey = GlobalKey<FormState>();
final TextEditingController nameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPAsswordController = TextEditingController();


class _AddUSerPAgeState extends State<AddUSerPAge> {

  dispositivos() async {
  devices = await usuarioProvider.devicesPorCasa();
  if( devices.length > 0 ) {
    setState(() { });
  } else {
    print('ocurrio un error agregarUsuarioPAge 23');
  }
}

void agregarDevicesForAdmin(){
  _idDevices?.clear();
    devices.forEach((e) => _idDevices.add(e.idDevice));
      devices = devices.map((e) {
        e.estado = true;
        return e;
      }).toList();
  }

  void cambiarRadio(int valor) {
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

  void enviar() async {
    print('==================');
    print(nameController.text);
    print(passwordController.text);
    print(_idDevices);

    if (_formKey.currentState.validate()) {
      final isTrue = await usuarioProvider.agregarUsuario(nameController.text, confirmPAsswordController.text, _cambio, _idDevices);
      if(isTrue){
        // await Future.delayed(Duration(milliseconds: 500));
        Navigator.pushNamed(context, 'home');
        mostrarDialogo(context, 'usuario', 'se agrego el usuario');
      }else {
        mostrarDialogo(context, 'Error', 'ocurrio un error al agregar el usuario');
      }
    } else {
      // Scaffold
      //     .of(context)
      //     .showSnackBar(SnackBar(content: Text('ocurrio un error')));
    }
  }

  @override
  void initState() { 
    dispositivos();
    super.initState();
  }
  @override
  void dispose() {
    nameController?.dispose();
    passwordController?.dispose();
    confirmPAsswordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: InkWell(
          onTap: () => FocusScope.of(context).requestFocus( FocusNode() ),
          child: Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:14.0, horizontal: 10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: regresarDecorador('Usuario'),
                        controller: nameController,
                        validator: (String data) {
                          if(data.isEmpty){
                            return 'campo vacio';
                          }
                          return null;
                        },
                        ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        obscureText: true,
                        decoration: regresarDecorador('Password'),
                        controller: passwordController,
                        validator: (String valor){
                          if(valor.isEmpty){
                            return 'campo vacio';
                          }
                          return null;
                        }),
                        SizedBox(height: 10.0),
                      TextFormField(
                        obscureText: true,
                        decoration: regresarDecorador('Confirm password'),
                        controller: confirmPAsswordController,
                        validator: (String valor) {
                          if(valor != passwordController.text){
                            return 'las contraseñas no son iguales';
                          }
                          if(valor.isEmpty){
                            return 'campo vacio';
                          }
                          return null;
                          
                        },
                        ),
                        SizedBox(height: 10.0),
                      (devices.length > 0) ? Container() : Center( child: CircularProgressIndicator()),
                      Column(children: dispositivosDevices()),
                      Divider(),
                      RadioListTile(value: 1, groupValue: _cambio, onChanged: cambiarRadio, title: Text('Administrador')),
                      Divider(),
                      RadioListTile(value: 2, groupValue: _cambio, onChanged: cambiarRadio, title: Text('Usuario')),
                      Divider(),
                      // FlatButton(onPressed: () {}, child: Text('Agregar')),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton.icon(
                          onPressed: enviar,
                          label: Text('Agregar'),
                          shape: OutlineInputBorder(                        
                            borderRadius: BorderRadius.circular(15.0)
                          ),
                          icon: Icon( Icons.account_circle, color: Colors.blueAccent)
                        ),
                      ),
                  ]),
                ),
              ),
            )
          ),
        ),
      ),
    );
  }

  List<Widget> dispositivosDevices() {
    return devices.map((e) => CheckboxListTile(
          title: Text(e.nombre ?? ''),
          onChanged: (bool valor) => cambiarEstado(e),
          value: e.estado
        )
    ).toList();
  }


}
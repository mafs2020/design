import 'package:diseno/usuarioProvider/usuario_provider.dart';
import 'package:diseno/widgets/mostrarDialogo.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _keyform = GlobalKey<FormState>();
  
  TextEditingController nombreController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final UsuarioProvider usuarioProvider = UsuarioProvider();
  
   @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nombreController?.dispose();
    passwordController?.dispose();
    super.dispose();
  }

  enviar() async {
    print( nombreController.text );
    print( passwordController.text );
    if(_keyform.currentState.validate()) {
      final d = await usuarioProvider.login(nombreController.text, passwordController.text);
      if(d != null){
        Navigator.pushNamed(context, 'home');
      } else {
        mostrarDialogo(context, 'Error', 'contraseña o usuario esta erroneo');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    nombreController.text = 'mama';
    passwordController.text = '123456';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('LOGIN'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus( FocusNode() ),
          child: Container(
            height: double.infinity,
            margin: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  Form(
                      key: _keyform,
                      child: Container(
                        height: 500.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              validator: (String val) {
                                if(val.length < 4 || val.isEmpty){
                                  return 'el nombre debe ser mayor a 4';
                                }
                                return null;
                              },
                              controller: nombreController,
                              decoration: InputDecoration(
                                labelText: 'Usuario',
                                hintText: 'Usuario',
                                hoverColor: Colors.deepPurple,
                                focusColor: Colors.deepPurple,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)
                                )
                              ),
                              cursorColor: Colors.deepPurple,
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              validator: (String val){
                                if(val.isEmpty){
                                  return 'el campo debe ser llenado';
                                }
                                return null;
                              },
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Password',
                                hoverColor: Colors.deepPurple,
                                focusColor: Colors.deepPurple,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)
                                )
                              ),
                              cursorColor: Colors.deepPurple,
                            ),
                            SizedBox(height: 20.0),
                            RaisedButton.icon(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.deepPurple,
                              icon: Icon(Icons.send, color: Colors.white),
                              label: Text('Entrar', style: TextStyle(color: Colors.white)),
                              onPressed: enviar
                            ),
                            SizedBox(height: 20.0),
                            FlatButton(
                              child: Text('No tienes cuenta'),
                              onPressed: () => Navigator.pushNamed(context, 'register'),
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
          ),
        ),
    );
  }
}
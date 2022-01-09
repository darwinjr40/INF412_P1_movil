import 'package:flutter/material.dart';
import 'package:gestor/models/models.dart';
import 'package:gestor/ui/input_decorations.dart';
import 'package:gestor/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:gestor/services/services.dart';
import 'dart:convert';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 250,
          ),
          CardContainer(
            child: Column(
              children: [
                SizedBox(height: 10),
                Text('Login', style: Theme.of(context).textTheme.headline4),
                SizedBox(height: 30),
                _LoginForm()
              ],
            ),
          ),
          SizedBox(height: 50),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'register'),
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(Colors.indigo.withOpacity(0.1))),
            child: Text(
              'Crear una nueva cuenta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  TextEditingController textNameController = new TextEditingController();
  TextEditingController texPasswordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          children: [
            TextField(
              controller: textNameController,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Username',
                labelText: 'Nombre de usuario',
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: texPasswordController,
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'password',
                labelText: 'Ingrese su contraseña',
              ),
            ),
            SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.blueAccent,
              onPressed: () async {
                FocusScope.of(context).unfocus();
                if (textNameController.text == '' ||
                    texPasswordController == '') {
                  return showDialog(
                    context: context,
                    builder: (_) => _DialogoAlerta(
                      mensaje: "Contraseña incorrecta",
                    ),
                  );
                }
                final authService =
                    Provider.of<AuthService>(context, listen: false);

                // final String
                final String respuesta = await authService.login(
                    textNameController.text, texPasswordController.text);

                print(respuesta);
                //if(respuesta.)
                if (respuesta.contains('name')) {
                  print('si tiene ');
                }
                if (respuesta.contains('name')) {
                  Map<String, dynamic> userMap = jsonDecode(respuesta);
                  User user = User.fromMap(userMap);
                  Navigator.pushNamed(context, 'home', arguments: user);
                } else {
                  return showDialog(
                    context: context,
                    builder: (_) => _DialogoAlerta(
                      mensaje: "Contraseña incorrecta",
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                child: Text(
                  'Ingresar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _DialogoAlerta extends StatelessWidget {
  final String mensaje;

  const _DialogoAlerta({@required this.mensaje});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error'),
      content: Text(this.mensaje),
    );
  }
}

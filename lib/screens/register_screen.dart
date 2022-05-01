import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestor/models/models.dart';
import 'package:gestor/services/services.dart';
import 'package:gestor/ui/input_decorations.dart';
import 'package:gestor/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
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
                Text('Register', style: Theme.of(context).textTheme.headline4),
                SizedBox(height: 30),
                _LoginForm()
              ],
            ),
          ),
          SizedBox(height: 50),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(Colors.indigo.withOpacity(0.1))),
            child: Text(
              'Ya tengo una cuenta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class _LoginForm extends StatefulWidget {
  @override
  __LoginFormState createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  TextEditingController textUserNameController = new TextEditingController();

  TextEditingController textNombreController = new TextEditingController();

  TextEditingController textTelefonoController = new TextEditingController();

  TextEditingController textCiController = new TextEditingController();

  TextEditingController textEmailController = new TextEditingController();

  TextEditingController textPasswordController = new TextEditingController();

  TextEditingController textConfirmedPasswordController =
      new TextEditingController();

  String _generoSeleccionado = 'masculino';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          children: [
            TextField(
              controller: textUserNameController,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Username',
                labelText: 'Nombre de usuario',
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: textNombreController,
              autocorrect: false,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Nombre',
                labelText: 'Nombre completo',
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: textCiController,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Ci',
                labelText: 'Carnet de identidad',
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: textTelefonoController,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'telefono',
                labelText: 'telefono',
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: textEmailController,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'email',
                labelText: 'email',
              ),
            ),
            SizedBox(height: 30),
            generoInput(),
            SizedBox(height: 30),
            TextField(
              // controller: _inputFieldDateController,
              //autofocus: true,
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                hintText: 'Fecha de nacimiento',
                labelText: 'fecha de nacimiento',
                suffixIcon: Icon(Icons.perm_contact_calendar),
                icon: Icon(Icons.calendar_today),
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                // _selectDate(context);
              },
            ),
            TextField(
              controller: textPasswordController,
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'password',
                labelText: 'Ingrese su contraseña',
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: textConfirmedPasswordController,
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'password',
                labelText: 'Confirme su contraseña',
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  bool camposValidos() {
    if (textUserNameController.text == '' ||
        textNombreController.text == '' ||
        textTelefonoController.text == '' ||
        textCiController.text == '' ||
        textEmailController.text == '' ||
        textPasswordController.text == '' ||
        textConfirmedPasswordController.text == '') {
      return false;
    }
    if (textPasswordController.text != textConfirmedPasswordController.text) {
      return false;
    }
    return true;
  }

  Widget generoInput() {
    List<DropdownMenuItem<String>> generos = [];
    generos.add(DropdownMenuItem(
      child: Text('masculino'),
      value: 'masculino',
    ));
    generos.add(DropdownMenuItem(
      child: Text('femenino'),
      value: 'femenino',
    ));
    return DropdownButton(
      value: _generoSeleccionado,
      items: generos,
      onChanged: (genero) {
        setState(() {
          _generoSeleccionado = genero;
        });
      },
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

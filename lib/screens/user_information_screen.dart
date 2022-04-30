import 'package:flutter/material.dart';
import 'package:gestor/models/models.dart';

class UserInformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: Text('Información del usuario'),
      ),
      body: Container(
        margin: EdgeInsets.all(40.0),
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white30,
        ),
        child: Column(
          children: [
            fila('Username', user.name),
            fila('nombre', user.nombre),
            // fila('ci', user.ci),
            fila('telefono', user.telefono),
            fila('genero', user.sexo),
            fila('email', user.email),
            fila(
                'Tipo',
                (user.tipo == 'P')//1
                    ? 'Abogado'
                    : (user.tipo == 'D')//2
                        ? 'Procurador'
                        : 'Juez'), //'A3
          ],
        ),
      ),
    );
  }

  Widget fila(String titulo, String dato) {
    return Row(
      children: [
        Text(
          titulo,
          style: TextStyle(fontSize: 20.0, color: Colors.blue),
        ),
        Text(' : '),
        Text(
          dato,
          style: TextStyle(fontSize: 20.0),
        ),
      ],
    );
  }
}

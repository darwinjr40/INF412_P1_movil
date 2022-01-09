import 'package:flutter/material.dart';
import 'package:gestor/models/models.dart';
import 'package:gestor/services/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  List<Proceso> procesos = [];

  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context, listen: false);
    final User user = ModalRoute.of(context).settings.arguments as User;

    // List<Proceso> procesos = ;
    return Scaffold(
      appBar: AppBar(
        title: Text('Procesos user: ${user.name}'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, 'user_information', arguments: user);
            },
          ),
        ],
      ),
      body: listarProcesos(user),
      floatingActionButton: FloatingActionButton(
        onPressed: () => cargarProcesos(user),
      ),
      // body:
    );
  }

  Widget listarProcesos(User user) {
    return FutureBuilder(
      future: cargarProcesos(user),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        print(snapshot);
        if (!snapshot.hasData) {
          return Container(
            child: ListTile(
              title: Text('No hay procesos'),
            ),
          );
        }
        return ListView(
          children: listaProcesos(snapshot.data, context),
        );
      },
    );
  }

  List<Widget> listaProcesos(List<dynamic> data, BuildContext context) {
    final List<Widget> lista = [];
    procesos = [];
    data.forEach((opt) {
      print(opt.nombre);
      //Proceso proceso = Proceso.fromJson(opt);
      final widgetTemp = ListTile(
        title: Text(opt.nombre),
        onTap: () {
          Navigator.pushNamed(context, 'proceso', arguments: opt);
        },
      );
      lista.add(widgetTemp);
      lista.add(Divider());
    });
    return lista;
  }

  Future<List<dynamic>> cargarProcesos(User user) async {
    var response;
    if (user.tipoId == 3) {
      //es juez
      /* response = await http.get(Uri.parse(
          'http://192.168.0.10/GestorDocumento/public/api/procesos/juez/${user.id}')); */
      response = await http.get(Uri.parse(
          'https://gestordocumento.herokuapp.com/api/procesos/juez/${user.id}'));
    }
    if (user.tipoId == 2) {
      //es procurador
      /* response = await http.get(Uri.parse(
          'http://192.168.0.10/GestorDocumento/public/api/procesos/${user.id}')); */
      response = await http.get(Uri.parse(
          'https://gestordocumento.herokuapp.com/api/procesos/${user.id}'));
    }
    // print(response.body);
    var jsonResponse = convert.jsonDecode(response.body);
    for (var item in jsonResponse) {
      Proceso proceso = Proceso.fromMap(item);
      // print(proceso.nombre);
      // print('object');
      procesos.add(proceso);
    }
    // print(procesos);
    return procesos;
  }
}

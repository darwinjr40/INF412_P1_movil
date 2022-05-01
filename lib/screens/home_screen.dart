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
  List<Inquiry> procesos = [];

  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context, listen: false);
    final User user = ModalRoute.of(context).settings.arguments as User;

    // List<Proceso> procesos = ;
    return Scaffold(
      appBar: AppBar(
        title: Text('Nombre de usuario: ${user.name}'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, 'user_information', arguments: user);
            },
          ),
        ],
      ),
      body: listarInquiries(user),
      floatingActionButton: FloatingActionButton(
        onPressed: () => cargarInquiries(user),
      ),
    );
  }

  Widget listarInquiries(User user) {
    return FutureBuilder(
      future: cargarInquiries(user),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        // print(snapshot);
        if (!snapshot.hasData) {
          return Container(
            child: ListTile(
              title: Text('No hay Consultas'),
            ),
          );
        }
        return ListView(
          children: listaInquiries(snapshot.data, context),
        );
      },
    );
  }

  List<Widget> listaInquiries(List<dynamic> data, BuildContext context) {
    final List<Widget> lista = [];
    procesos = [];
    data.forEach((opt) {
      // print(opt);
      //Proceso proceso = Proceso.fromJson(opt);
      final widgetTemp = ListTile(
        title: Text(opt.specialty_nombre),
        onTap: () {
          Navigator.pushNamed(context, 'proceso', arguments: opt);
        },
      );
      lista.add(widgetTemp);
      lista.add(Divider());
    });
    return lista;
  }

  Future<List<dynamic>> cargarInquiries(User user) async {
    var response;
    if (user.tipo == 'P') {
      //es PACIENTE
      // response = await http.get(Uri.parse(
      //     'http://192.168.1.2:8080/clinica/public/api/inquiries/${user.id}'));
       response = await http.get(Uri.parse(
          'http://193.123.99.38/api/inquiries/${user.id}')); 
    }
    // print(response.body);
    var jsonResponse = convert.jsonDecode(response.body);
    for (var item in jsonResponse) {
      Inquiry proceso = Inquiry.fromMap(item);
      // print(proceso.nombre);
      // print('object');
      procesos.add(proceso);
    }
    // print(procesos);
    return procesos;
  }
}

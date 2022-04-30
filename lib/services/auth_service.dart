// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestor/models/models.dart';
import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;

class AuthService extends ChangeNotifier {
  User user;
  //function to call login post api
  Future<String> loginA(String name, String password) async {
    var response = await http.post(
        Uri.parse('http://192.168.0.10/GestorDocumento/public/api/login'),
        body: ({
          'name': name,
          'password': password,
        }));
    //print(response.body);
    if (response.body.contains('name')) {
      user = User.fromJson(response.body);
    }
    return response.body;
  }

  Future<String> login(String email, String password) async {
    var response = await http.post(
        Uri.parse('http://192.168.1.2:8080/clinica/public/api/login'),
        body: ({
          'email': email,
          'password': password,
        })
    );
    // print(response.body);
    if (response.body.contains('email')) {
       user = User.fromJson(response.body);
    }
    return response.body;
  }

  Future<String> registerProcuradorA(String name, String nombre, String ci,
      String telefono, String email, String genero, String password) async {
    var response = await http.post(
        Uri.parse(
            'http://192.168.0.10/GestorDocumento/public/api/registerProcurador'),
        body: ({
          'name': name,
          'nombre': nombre,
          'ci': ci,
          'telefono': telefono,
          'email': email,
          'genero': genero,
          'password': password,
        }));
    // print(response.body);
    if (response.body.contains('name')) {
      user = User.fromJson(response.body);
    }
    return response.body;
  }

  Future<String> registerProcurador(String name, String nombre, String ci,
      String telefono, String email, String genero, String password) async {
    var response = await http.post(
        Uri.parse(
            'https://gestordocumento.herokuapp.com/api/registerProcurador'),
        body: ({
          'name': name,
          'nombre': nombre,
          'ci': ci,
          'telefono': telefono,
          'email': email,
          'genero': genero,
          'password': password,
        }));
    // print(response.body);
    if (response.body.contains('name')) {
      user = User.fromJson(response.body);
    }
    return response.body;
  }
}

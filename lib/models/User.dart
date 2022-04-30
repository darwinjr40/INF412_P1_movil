import 'package:flutter/material.dart';
import 'dart:convert';

class User {
  int id;
  String name;
  String nombre;
  String tipo;
  String telefono;
  String email;
  String sexo;
  // List<String> tipos;

  User({
    this.id,
    this.name,
    this.nombre,
    this.tipo,
    this.telefono,
    this.email,
    this.sexo,
    // this.tipos,
  });
  
  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        nombre: json["nombre"],
        tipo: json["tipo"],
        telefono: json["telefono"],
        email: json["email"],
        sexo: json["sexo"],
      );
}

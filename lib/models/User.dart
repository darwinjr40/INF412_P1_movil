import 'package:flutter/material.dart';
import 'dart:convert';

class User {
  int id;
  String name;
  String nombre;
  String ci;
  String telefono;
  String email;
  String genero;
  int tipoId;
  // List<String> tipos;

  User({
    this.id,
    this.name,
    this.nombre,
    this.ci,
    this.telefono,
    this.email,
    this.genero,
    this.tipoId,
    // this.tipos,
  });
  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        nombre: json["nombre"],
        ci: json["ci"],
        telefono: json["telefono"],
        email: json["email"],
        genero: json["genero"],
        tipoId: json['tipoId'],
      );
}

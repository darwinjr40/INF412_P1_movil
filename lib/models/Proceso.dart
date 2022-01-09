import 'package:flutter/material.dart';
import 'dart:convert';

class Proceso {
  int id;
  String nombre;
  String caratula;
  String jurisdiccion;
  String tipo;
  String objeto;
  String year;
  String numeroCausa;
  String tribunal;
  String estado;
  int idJuez;

  Proceso({
    this.id,
    this.nombre,
    this.caratula,
    this.jurisdiccion,
    this.tipo,
    this.objeto,
    this.year,
    this.numeroCausa,
    this.tribunal,
    this.estado,
    this.idJuez,
  });
  factory Proceso.fromJson(String str) => Proceso.fromMap(json.decode(str));

  factory Proceso.fromMap(Map<String, dynamic> json) => Proceso(
        id: json["id"],
        nombre: json["nombre"],
        caratula: json["caratula"],
        jurisdiccion: json["jurisdiccion"],
        tipo: json["tipo"],
        objeto: json["objeto"],
        year: json["year"],
        numeroCausa: json['numeroCausa'],
        tribunal: json['tribunal'],
        estado: json['estado'],
        idJuez: json['userJuezId'],
      );
}

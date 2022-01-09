import 'package:flutter/material.dart';
import 'dart:convert';

class Actuacion {
  int id;
  String titulo;
  String path;
  String tipo;
  String tipoArchivo;
  String fecha;
  String importante;
  int procesoId;

  Actuacion({
    this.id,
    this.titulo,
    this.path,
    this.tipo,
    this.tipoArchivo,
    this.fecha,
    this.importante,
    this.procesoId,
  });

  factory Actuacion.fromJson(String str) => Actuacion.fromMap(json.decode(str));

  factory Actuacion.fromMap(Map<String, dynamic> json) => Actuacion(
        id: json["id"],
        titulo: json["titulo"],
        path: json["path"],
        tipo: json["tipo"],
        tipoArchivo: json['tipoArchivo'],
        fecha: json['created_at'],
        importante: json['importante'],
        procesoId: json["procesoId"],
      );
}

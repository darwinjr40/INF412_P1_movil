import 'package:flutter/material.dart';
import 'dart:convert';

class Actuacion {
  int id;
  int patient_id;
  String path;
  String name_file;
  String fecha_file;

  Actuacion({
    this.id,
    this.patient_id,
    this.path,
    this.name_file,
    this.fecha_file,
  });

  factory Actuacion.fromJson(String str) => Actuacion.fromMap(json.decode(str));

  factory Actuacion.fromMap(Map<String, dynamic> json) => Actuacion(
        id: json["id"],
        patient_id: json["patient_id"],
        path: json["path"],
        name_file: json["name_file"],
        fecha_file: json['fecha_file'],
      );
}

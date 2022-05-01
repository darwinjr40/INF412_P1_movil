import 'package:flutter/material.dart';
import 'dart:convert';

class Inquiry {
  int id;
  int patient_id;
  int doctor_id;
  int specialty_id;
  String descripcion;
  String path;
  String pathLocal;
  String fecha;
  String tipo;
  String doctor_nombre;
  String specialty_nombre;

  Inquiry({
    this.id,
    this.patient_id,
    this.doctor_id,
    this.specialty_id,
    this.descripcion,
    this.path,
    this.pathLocal,
    this.fecha,
    this.tipo,
    this.doctor_nombre,
    this.specialty_nombre,      
  });

  factory Inquiry.fromJson(String str) => Inquiry.fromMap(json.decode(str));

  factory Inquiry.fromMap(Map<String, dynamic> json) => Inquiry(
      id: json["id"],
      doctor_id: json["doctor_id"],
      patient_id: json["patient_id"],
      specialty_id: json["specialty_id"],
      descripcion: json["descripcion"],
      path: json["path"],
      pathLocal: json["pathLocal"],
      fecha: json["fecha"],
      tipo: json["tipo"],
      doctor_nombre: json["doctor_nombre"],
      specialty_nombre: json["specialty_nombre"],
  );
}

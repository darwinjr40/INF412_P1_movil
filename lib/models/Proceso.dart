import 'package:flutter/material.dart';
import 'dart:convert';

class Proceso {
  int id;
  int patient_id;
  int doctor_id;
  int specialty_id;
  String descripcion;
  String url;
  String fecha;
  String tipo;
  String doctor_nombre;
  String specialty_nombre;
  Proceso({
    this.id,
    this.patient_id,
    this.doctor_id,
    this.specialty_id,
    this.descripcion,
    this.url,
    this.fecha,
    this.tipo,
    this.doctor_nombre,
    this.specialty_nombre,
      
  });

  factory Proceso.fromJson(String str) => Proceso.fromMap(json.decode(str));

  factory Proceso.fromMap(Map<String, dynamic> json) => Proceso(
      id: json["id"],
      doctor_id: json["doctor_id"],
      patient_id: json["patient_id"],
      specialty_id: json["specialty_id"],
      descripcion: json["descripcion"],
      url: json["url"],
      fecha: json["fecha"],
      tipo: json["tipo"],
      doctor_nombre: json["doctor_nombre"],
      specialty_nombre: json["specialty_nombre"],
  );
}

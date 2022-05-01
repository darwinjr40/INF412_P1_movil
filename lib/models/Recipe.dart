import 'package:flutter/material.dart';
import 'dart:convert';

class Recipe {
  int id;
  int patient_id;
  String path;
  String name_file;
  String fecha_file;

  Recipe({
    this.id,
    this.patient_id,
    this.path,
    this.name_file,
    this.fecha_file,
  });

  factory Recipe.fromJson(String str) => Recipe.fromMap(json.decode(str));

  factory Recipe.fromMap(Map<String, dynamic> json) => Recipe(
        id: json["id"],
        patient_id: json["patient_id"],
        path: json["path"],
        name_file: json["name_file"],
        fecha_file: json['fecha_file'],
      );
}

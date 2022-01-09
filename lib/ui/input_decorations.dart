import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    @required String hintText,
    @required String labelText,
  }) {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blueAccent,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blueAccent,
          width: 2,
        ),
      ),
      hintText: hintText,
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey),
    );
  }
}

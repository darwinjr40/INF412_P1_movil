import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gestor/models/Recipe.dart';
import 'package:gestor/screens/pdf_viewer_screen.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ViewArchivoPDF extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Recipe actuacion =
        ModalRoute.of(context).settings.arguments as Recipe;
    String tipo = actuacion.name_file;

    return Scaffold(
      appBar: AppBar(
        title: Text(actuacion.name_file),
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_full),
            onPressed: () async {
              final url = actuacion.path;
              final file = await loadNetword(url);
              openPDF(context, file);
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(30.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  // fila('titulo', actuacion.patient_id),
                  fila('tipo', actuacion.name_file),
                  fila('formato', "PDF"),
                  fila('fecha', actuacion.fecha_file),
                ],
              ),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () async {
                  // if (actuacion.tipoArchivo == 'documento') {
                  final url = actuacion.path;
                  final file = await loadNetword(url);
                  openPDF(context, file);
                  // }
                  // if (actuacion.tipoArchivo == 'imagen') {
                  //   print('imagen');
                  //   Navigator.pushNamed(context, 'image_view',
                  //       arguments: actuacion.path);
                  // }
                },
                child: Text('Abrir Archivo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fila(String titulo, String dato) {
    return FittedBox(
      child: Row(
        children: [
          Text(
            titulo,
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          Text(' : '),
          Text(
            dato,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Future<File> loadNetword(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return _storeFile(url, bytes);
  }

  Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)));
}

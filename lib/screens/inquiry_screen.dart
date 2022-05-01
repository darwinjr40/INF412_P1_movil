import 'package:flutter/material.dart';
import 'package:gestor/models/models.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:image_picker/image_picker.dart';

class InquiryScreen extends StatefulWidget {
  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  List<Recipe> listaActuaciones = [];
  @override
  Widget build(BuildContext context) {
    final Inquiry proceso =
        ModalRoute.of(context).settings.arguments as Inquiry;
    return Scaffold(
      appBar: AppBar(
        title: Text('Servicio: ${proceso.specialty_nombre}'),
        actions: [IconButton(icon: Icon(Icons.replay), onPressed: () {})],
      ),
      body: ListView(
        children: [
          datos(proceso),
          SizedBox(
            height: 20.0,
          ),
          Text('ARCHIVOS DE CONSULTAS'),
          SizedBox(
            height: 20.0,
          ),
          cargarDataTable(proceso.id),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget datos(Inquiry proceso) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
        color: Colors.blue,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Column(
        children: [
          filaDato('Servicio: ', proceso.specialty_nombre),
          filaDato('Doctor: ', proceso.doctor_nombre),
          filaDato('descripcion: ', proceso.descripcion),
          filaDato('Tipo: ', proceso.tipo),
          filaDato('fecha: ', proceso.fecha),
        ],
      ),
    );
  }

  Widget filaDato(String label, String dato) {
    return Row(
      children: [
        Text(
          '$label',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            // decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.wavy,
          ),
        ),
        Text(
          '$dato',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            // decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.wavy,
          ),
        ),
      ],
    );
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  Widget cargarDataTable(int id) {
    return FutureBuilder(
      future: cargarRecipes(id),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Text('No hay archivos parar mostrar'),
          );
        }
        return DataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text('Nro')),
            DataColumn(label: Text('tipo')),
            DataColumn(label: Text('formato')),
            // DataColumn(label: Text('fecha')),
          ],
          rows: dataRowsRecipes(),
        );
      },
    );
  }

  Future<List<dynamic>> cargarRecipes(int id) async {
    // var response = await http.get(
    //     Uri.parse('http://192.168.1.2:8080/clinica/public/api/getRecipe/$id'));
    var response =
        await http.get(Uri.parse('http://193.123.99.38/api/getRecipe/$id'));
    var jsonResponse = convert.jsonDecode(response.body);
    for (var item in jsonResponse) {
      Recipe actuacion = Recipe.fromMap(item);
      listaActuaciones.add(actuacion);
    }
    return listaActuaciones;
  }

  List<DataRow> dataRowsRecipes() {
    List<DataRow> lista = [];
    for (var actuacion in listaActuaciones) {
      var row = DataRow(
        cells: [
          DataCell(Text(actuacion.id.toString(),
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)
              // style: (actuacion.importante == 'si')
              //     ? TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)
              //     : TextStyle(),
              )),
          DataCell(Text(actuacion.name_file)),
          DataCell(
            (actuacion.name_file == 'imagen')
                ? Icon(
                    Icons.image_outlined,
                    color: Colors.blue,
                  )
                : Icon(
                    Icons.picture_as_pdf_outlined,
                    color: Colors.redAccent,
                  ),
          ),
          // DataCell(Text(actuacion.fecha)),
        ],
        onSelectChanged: (bool selected) {
          // print('${actuacion.name_file}');
          Navigator.pushNamed(context, 'view_archivopdf', arguments: actuacion);
        },
      );
      lista.add(row);
    }
    listaActuaciones = [];
    return lista;
  }
}

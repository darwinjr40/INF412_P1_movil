import 'package:flutter/material.dart';
import 'package:gestor/models/models.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:image_picker/image_picker.dart';

class ProcesoScreen extends StatefulWidget {
  @override
  _ProcesoScreenState createState() => _ProcesoScreenState();
}

class _ProcesoScreenState extends State<ProcesoScreen> {
  List<Actuacion> listaActuaciones = [];
  @override
  Widget build(BuildContext context) {
    final Proceso proceso =
        ModalRoute.of(context).settings.arguments as Proceso;
    return Scaffold(
      appBar: AppBar(
        title: Text('Proceso: ${proceso.nombre}'),
        actions: [IconButton(icon: Icon(Icons.replay), onPressed: () {})],
      ),
      body: ListView(
        children: [
          datos(proceso),
          SizedBox(
            height: 20.0,
          ),
          Text('ARCHIVOS DEL PROCESO'),
          Container(
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(context, 'subir_archivo',
                    arguments: proceso);
              },
              child: Text('Subir Presentación'),
            ),
            padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
          ),
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

  Widget datos(Proceso proceso) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
        color: Colors.blue,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Column(
        children: [
          filaDato('Nombre: ', proceso.nombre),
          filaDato('Caratula: ', proceso.caratula),
          filaDato('Jurisdiccion: ', proceso.jurisdiccion),
          filaDato('Tipo: ', proceso.tipo),
          filaDato('Objeto: ', proceso.objeto),
          filaDato('Year: ', proceso.year),
          filaDato('Año: ', proceso.year),
          filaDato('Número: ', proceso.numeroCausa),
          filaDato('Tribunal: ', proceso.tribunal),
          filaDato('Estado: ', proceso.estado),
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
      future: cargarActuaciones(id),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Text('No hay archivos parar mostrar'),
          );
        }
        return DataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text('Tiutlo')),
            DataColumn(label: Text('tipo')),
            DataColumn(label: Text('formato')),
            // DataColumn(label: Text('fecha')),
          ],
          rows: dataRowsActuaciones(),
        );
      },
    );
  }

  Future<List<dynamic>> cargarActuaciones(int id) async {
    /* var response = await http.get(Uri.parse(
        'http://192.168.0.10/GestorDocumento/public/api/getActuaciones/$id')); */
    var response = await http.get(Uri.parse(
        'https://gestordocumento.herokuapp.com/api/getActuaciones/$id'));
    var jsonResponse = convert.jsonDecode(response.body);
    for (var item in jsonResponse) {
      Actuacion actuacion = Actuacion.fromMap(item);
      listaActuaciones.add(actuacion);
    }
    //print(listaActuaciones);
    return listaActuaciones;
  }

  List<DataRow> dataRowsActuaciones() {
    List<DataRow> lista = [];
    for (var actuacion in listaActuaciones) {
      var row = DataRow(
        cells: [
          DataCell(Text(
            actuacion.titulo,
            style: (actuacion.importante == 'si')
                ? TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)
                : TextStyle(),
          )),
          DataCell(Text(actuacion.tipo)),
          DataCell(
            (actuacion.tipoArchivo == 'imagen')
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
          print('${actuacion.titulo}');
          String path = actuacion.path;
          Navigator.pushNamed(context, 'view_archivopdf', arguments: actuacion);
        },
      );
      lista.add(row);
    }
    listaActuaciones = [];
    return lista;
  }
}

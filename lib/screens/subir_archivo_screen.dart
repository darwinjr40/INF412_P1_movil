import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:gestor/models/models.dart';
import 'package:gestor/services/services.dart';
import 'package:gestor/ui/input_decorations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gestor/widgets/card_Swiper.dart';
import 'package:open_file/open_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SubirArchivoScreen extends StatefulWidget {
  @override
  _SubirArchivoScreenState createState() => _SubirArchivoScreenState();
}

class _SubirArchivoScreenState extends State<SubirArchivoScreen> {
  TextEditingController textTituloController = new TextEditingController();
  String tipoSeleccionado = 'ofrecimientos de pruebas';
  String tipoArchivo = '';
  String archivoSeleccionadoPath;
  String archivoSeleccionadoNombre;
  String imagen64;
  List<XFile> listaFotos = []; //para mostarlo en al cardSwiper
  List<File> listaImagenFile =
      []; //lista de archivos (fotos) para convertir a un pdf
  var pdfFinal = pw.Document();
  String pdfFinalPath = '';
  String direccion = '';

  @override
  void initState() {
    super.initState();
    borrarSeleccionado();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final Proceso proceso =
        ModalRoute.of(context).settings.arguments as Proceso;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () {
                createPDF();
                savePDF();
              }),
          IconButton(icon: Icon(Icons.delete), onPressed: borrarSeleccionado),
        ],
        title: Text('Subir Archivo'),
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    controller: textTituloController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Título de presentación',
                      labelText: 'Título',
                    ),
                  ),
                  tipoInput(),
                ],
              ),
            ),
            SizedBox(height: 30),
            SizedBox(height: 30),
            Container(
              // color: Colors.red,
              padding: EdgeInsets.only(left: 50.0, right: 50.0),
              width: 200.0,
              child: ElevatedButton(
                onPressed: () async {
                  final result =
                      await FilePicker.platform.pickFiles(allowMultiple: false);
                  if (result == null) return;

                  archivoSeleccionadoPath = result.paths.elementAt(0);
                  archivoSeleccionadoNombre = result.names.elementAt(0);
                  tipoArchivo = 'documento';
                  actualizarWidget();
                },
                child: Text('Abrir el explorador de archivos'),
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.only(left: 50.0, right: 50.0),
              child: ElevatedButton(
                onPressed: () async {
                  final picker = new ImagePicker();
                  final XFile photo = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 50,
                  );
                  if (photo == null) {
                    print('no se tomó la foto');
                    return;
                  }
                  listaFotos.add(photo);
                  listaImagenFile.add(new File(photo.path));
                  archivoSeleccionadoPath = photo.path;
                  archivoSeleccionadoNombre = photo.name;
                  tipoArchivo = 'imagen';
                  actualizarWidget();
                },
                child: Text('Abrir la cámara'),
              ),
            ),
            SizedBox(height: 30),
            Container(
              // height: 100.0,

              child: archivoSeleccionadoPath == ''
                  ? Text('Ningún archivo seleccionado')
                  : (listaFotos.length != 0)
                      ? CardSwiper(
                          photos: listaFotos,
                        )
                      : Text(
                          '1 archivo seleccionado'), //Image.file(File(archivoSeleccionadoPath)),

              margin: EdgeInsets.only(left: 50.0, right: 50.0),
              decoration: BoxDecoration(
                  /* border: Border.all(
                  color: Colors.grey,
                  width: 5.0,
                ), */
                  ),
            ),
            Container(
              padding: EdgeInsets.only(left: 50.0, right: 50.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                onPressed: () async {
                  if (archivoSeleccionadoPath == "" ||
                      textTituloController.text == '') {
                    return showDialog(
                      context: context,
                      builder: (_) => _DialogoAlerta(
                        mensaje: "campos no válidos",
                      ),
                    );
                  }

                  // await verificarArchivos();
                  // File aa = File('$direccion/${textTituloController.text}.pdf');
                  // File aa = File('$direccion/conversion79.pdf');
                  // print(aa.path);
                  createPDF();
                  await savePDF();
                  if (listaImagenFile.length > 1) {
                    archivoSeleccionadoPath = pdfFinalPath;
                    tipoArchivo = 'documento';
                  }
                  String idUser = authService.user.id.toString();
                  if (authService.user == null) {
                    idUser = '1';
                  }

                  String respuesta = await fileUpload(
                      new File(archivoSeleccionadoPath),
                      proceso.id.toString(),
                      idUser);

                  if (respuesta.contains('mensaje')) {
                    listaFotos = [];
                    listaImagenFile = [];
                    actualizarWidget();
                    return showDialog(
                      context: context,
                      builder: (_) => _DialogoAlerta(
                        mensaje: "Archivo subido con éxito",
                      ),
                    );
                  }
                },
                child: Text('Subir presentación'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void actualizarWidget() {
    setState(() {});
  }

  void createPDF() {
    for (var img in listaImagenFile) {
      final image = pw.MemoryImage(img.readAsBytesSync());
      pdfFinal.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(image));
          },
        ),
      );
    }
  }

  Future<void> savePDF() async {
    try {
      final dir = await getExternalStorageDirectory();
      direccion = dir.path;
      final file = File('${dir.path}/${textTituloController.text}.pdf');
      await file.writeAsBytes(await pdfFinal.save());
      pdfFinalPath = file.path;
      print('conversión exitosa');
    } catch (e) {
      print('no se pudo convertir');
    }
  }

  void verificarArchivos() {
    if (listaImagenFile.length > 1) {
      createPDF();
      savePDF();
      archivoSeleccionadoPath =
          new File('$direccion/${textTituloController.text}.pdf').path;
    }
  }

  Future<String> fileUpload(File file, String id, String userId) async {
    //create multipart request for POST or PATCH method
    /* var request = http.MultipartRequest("POST",
        Uri.parse("http://192.168.0.10/GestorDocumento/public/api/subirFile")); */
    var request = http.MultipartRequest("POST",
        Uri.parse("https://gestordocumento.herokuapp.com/api/subirFile"));
    //add text fields
    request.fields["titulo"] = textTituloController.text;
    request.fields["tipo"] = tipoSeleccionado;
    request.fields["path"] = archivoSeleccionadoPath;
    request.fields["tipoArchivo"] = tipoArchivo;
    request.fields["procesoId"] = id;
    request.fields["userId"] = userId;

    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("file", file.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    return responseString;
  }

  Widget tipoInput() {
    List<DropdownMenuItem<String>> tipos = [];
    tipos.add(DropdownMenuItem(
      child: Text('presentacion de documentos requeridos'),
      value: 'presentacion de documentos requeridos',
    ));
    tipos.add(DropdownMenuItem(
      child: Text('Presentacion de la accion'),
      value: 'Presentacion de la accion',
    ));
    tipos.add(DropdownMenuItem(
      child: Text('ofrecimientos de pruebas'),
      value: 'ofrecimientos de pruebas',
    ));
    tipos.add(DropdownMenuItem(
      child: Text('pedido de admision de pruebas'),
      value: 'pedido de admision de pruebas',
    ));
    tipos.add(DropdownMenuItem(
      child: Text('pedido de inicio de juicio ejecutivo'),
      value: 'pedido de inicio de juicio ejecutivo',
    ));
    tipos.add(DropdownMenuItem(
      child: Text('pedido de modificacion de la demanda'),
      value: 'pedido de modificacion de la demanda',
    ));
    tipos.add(DropdownMenuItem(
      child: Text('pedido de reiteracion de informe'),
      value: 'pedido de reiteracion de informe',
    ));
    tipos.add(DropdownMenuItem(
      child: Text('pedido de sentencia de remate'),
      value: 'pedido de sentencia de remate',
    ));
    tipos.add(DropdownMenuItem(
      child: Text('pedido de subrogracion de derechos y acciones'),
      value: 'pedido de subrogracion de derechos y acciones',
    ));
    tipos.add(DropdownMenuItem(
      child: Text('pedido de suspension de audiencia'),
      value: 'pedido de suspension de audiencia',
    ));

    return DropdownButton(
      value: tipoSeleccionado,
      items: tipos,
      onChanged: (tipo) {
        setState(() {
          tipoSeleccionado = tipo;
        });
      },
    );
  }

  void borrarSeleccionado() {
    setState(() {
      listaFotos.clear();
      listaImagenFile.clear();
      archivoSeleccionadoNombre = '';
      archivoSeleccionadoPath = '';
      pdfFinalPath = '';
      pdfFinal = pw.Document();
    });
  }
}

class _DialogoAlerta extends StatelessWidget {
  final String mensaje;

  const _DialogoAlerta({@required this.mensaje});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(''),
      content: Text(this.mensaje),
    );
  }
}

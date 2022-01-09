import 'package:flutter/material.dart';
import 'package:gestor/screens/subir_archivo_screen.dart';
import 'package:gestor/services/services.dart';
import 'package:provider/provider.dart';
import 'package:gestor/screens/screens.dart';

void main() => runApp(AppState());

class AppState extends StatefulWidget {
  @override
  _AppStateState createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestor Documental',
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginScreen(),
        'home': (_) => HomeScreen(),
        'register': (_) => RegisterScreen(),
        'proceso': (_) => ProcesoScreen(),
        'subir_archivo': (_) => SubirArchivoScreen(),
        'user_information': (_) => UserInformationScreen(),
        'view_archivopdf': (_) => ViewArchivoPDF(),
        'image_view': (_) => ImageViewScreen(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
      ),
    );
  }
}

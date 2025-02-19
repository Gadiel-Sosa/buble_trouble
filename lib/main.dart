import 'package:buble_trouble/homepage.dart';
import 'package:flutter/material.dart';

//* función principal que inicia la aplicación.
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //* MaterialApp es el widget raíz de la aplicación
      debugShowCheckedModeBanner: false, //* Se desactiva el banner de "debug"
      home: HomePage(), //* Define la pantalla inicial
    );
  }
}

import 'package:flutter/material.dart';

//* Define una clase llamada 'MyButton'
class MyButton extends StatelessWidget {
  final icon; //*! el ícono que se mostrará en el botón.
  final function; //*! la función que se ejecutará cuando el botón sea presionado.
  MyButton({this.icon, this.function}); //* Constructor

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //*! detecta gestos, como un toque, y ejecuta una función
      onTap:
          function, //*! (Toque) Al tocar el botón, se ejecuta la función proporcionada
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(15), //* define el redondeo de las esquinas
        child: Container(
          color: Colors.grey[100], //* Color del contenedor (botones)
          width: 50, //* Ancho botón
          height: 50, //* Altura del botón
          child: Center(child: Icon(icon)), //* Centra al ícono
        ),
      ),
    );
  }
}

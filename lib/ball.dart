import 'package:flutter/material.dart';

// *Define una clase llamada 'MyBall' que extiende de StatelessWidget
/* 
*Esto significa que el widget no tiene estado, 
*es decir, sus propiedades no cambiarán después de su creación.
*/
class MyBall extends StatelessWidget {
  //* Coordenadas de la pelota en x, y
  final double ballx; //* Posición de la pelota en el eje x
  final double bally; //* Posición de la pelota en el eje y

  // *!Constructor que recibe las coordenadas x y y de la pelota como parámetros.
  MyBall({required this.ballx, required this.bally});

//*! El método build construye y devuelve el widget que se mostrará en la pantalla.
  @override
  Widget build(BuildContext context) {
    return Container(
        // *El widget Container se usa para envolver otros widgets.
        alignment: Alignment(
            ballx, bally), // *Alineación de la pelota en el contenedor.

        //*! Aquí se coloca otro widget Container dentro del primero para representar la pelota.
        child: Container(
            // *Este container define las dimensiones de la pelota
            width: 20, // *!Ancho
            height: 20, // *!Altura
            decoration: BoxDecoration(
                // *Permite aplicar estilos visuales a los widgets
                shape: BoxShape.circle, //* shape define la forma del container
                color: Colors.brown, // *color de la pelota
                border: Border.all(
                    color: Colors.black, width: 2.5))) //*borde de la pelota

        );
  }
}

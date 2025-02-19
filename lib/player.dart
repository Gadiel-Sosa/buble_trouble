import 'package:flutter/material.dart';

// *? Define una clase llamada 'MyPlayer' que extiende StatelessWidget inmutable.
class MyPlayer extends StatelessWidget {
  final playerx; //*! La posición horizontal del jugador
  MyPlayer({this.playerx}); //*! Constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      //* Se usa paea envolver y personalizar widgets
      //*! Alignament: Alineación
      alignment: Alignment(playerx,
          1), //* Coloca al jugador en una posición especificada (playerx)
      child: ClipRRect(
        //*! redondea las esquinas del jugador
        borderRadius:
            BorderRadius.circular(10), //*! define el redondeo de las esquinas
        child: Container(
          decoration: BoxDecoration(
              //*Personaliza al contenedor
              color: Colors.deepPurpleAccent, //* Da un color al contenedor
              border: Border.all(
                //* Borde completo
                color: Colors.deepPurple, //* Color del borde
                width: 3.0, //* El grosor del borde
              )),
          height: 50, //* El alto del jugador
          width: 50, //* El ancho del jugador
        ),
      ),
    ); //hasta aquí mañana continuar 1/feb/25
  }
}

import 'package:flutter/material.dart';

// * Define una clase llamada 'MyMissille' que extiende StatelessWidget.
//*  Este widget representa un misil, y es inmutable una vez que se ha construido.
class MyMissille extends StatelessWidget {
  final missilex; //*! coordenada horizontal (x) del misil en la pantalla
  final height; //*! representa la altura (alto) del misil
//* // Constructor que permite pasar las propiedades 'height' y 'missilex' al widget.
  MyMissille({this.height, this.missilex});

  @override
  Widget build(BuildContext context) {
    return Container(
      // *El widget Container se usa para envolver otros widgets.
      alignment: Alignment(missilex,
          1), //* coloca el misil en la posición horizontal dada por 'missilex'
      child: Container(
        width: 2, // *! El misil tendrá un ancho de 2 píxeles
        height: height, // *!La altura será la que se pase al constructor
        color: Colors.black, // *! Color del misil
      ),
    );
  }
}

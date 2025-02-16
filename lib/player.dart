import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  final playerx;
  MyPlayer({this.playerx});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(playerx, 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              border: Border.all(
                color: Colors.deepPurple,
                width: 3.0,
              )),
          height: 50,
          width: 50,
        ),
      ),
    ); //hasta aquí mañana continuar 1/feb/25
  }
}

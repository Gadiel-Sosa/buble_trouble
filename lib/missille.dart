import 'package:flutter/material.dart';

class MyMissille extends StatelessWidget {
  final missilex;
  final height;

  MyMissille({this.height, this.missilex});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(missilex, 1),
      child: Container(
        width: 2,
        height: height,
        color: Colors.grey,
      ),
    );
  }
}

import 'dart:async';

import 'package:buble_trouble/ball.dart';
import 'package:buble_trouble/button.dart';
import 'package:buble_trouble/missille.dart';
import 'package:buble_trouble/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum direction { LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  int score = 0;
  // Player variables
  static double playerx = 0;
  // missile variables
  double missilex = playerx;

  double missileHeight = 10;
  bool midShot = false;
  // ball variables
  double ballx = 0.5;
  double bally = 1;
  var ballDirection = direction.LEFT;
  void startGame() {
    double time = 0;
    double height = 0;
    double velocity = 60; // how string is
    Timer.periodic(Duration(microseconds: 10), (timer) {
      height = -5 * time * time + velocity * time;
      //if the ball reaches the ground, reset the jump

      if (height < 0) {
        time = 0;
      }
      // update the new ball position
      setState(() {
        bally = heightToPosition(height);
      });

      // if the ball hits the left wall, then change direction to right
      if (ballx - 0.005 < -1) {
        ballDirection = direction.RIGHT;
        //if the ball hits the right wall, then change direction to left
      } else if (ballx + 0.005 > 1) {
        ballDirection = direction.LEFT;
      }
// move the ball in the correct direction
      if (ballDirection == direction.LEFT) {
        setState(() {
          ballx -= 0.005;
        });
      } else if (ballDirection == direction.RIGHT) {
        setState(() {
          ballx += 0.005;

          /// Me quedé en el minuto 23:59 en esta parte fue lo ultimo agregado
        });
      }
      // check if ball hits the player
      if (playerDies()) {
        timer.cancel();
        _showDaialog();
      }
      // keep the time going!
      time += 0.1;
    });
  }

  void resetGame() {
    setState(() {
      // Reiniciar posiciones del jugador y misiles
      score = 0;
      playerx = 0;
      missilex = playerx;
      missileHeight = 10;
      midShot = false;

      // Reiniciar la pelota
      ballx = 0.5;
      bally = 1;
      ballDirection = direction.LEFT;
    });

    // Reiniciar el juego llamando startGame()
    startGame();
  }

  void _showDaialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[700],
            title: Text(
              "¡Perdiste! :(",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  resetGame(); // Reinicia el juego
                  Navigator.of(context).pop(); // Cierra el diálogo
                },
                child: Text("Volver a jugar",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
  }

  void moveLeft() {
    setState(() {
      if (playerx - 0.1 < -1) {
        // do nothing
      } else {
        playerx -= 0.1;
      }
      // only make the x cordinate the same when it isn't in the middle of a shot
      if (!midShot) {
        missilex = playerx;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (playerx + 0.1 > 1) {
        // do nothing
      } else {
        playerx += 0.1;
      }
      missilex = playerx;
    });
  }

  void fireMissile() {
    if (midShot == false) {
      Timer.periodic(Duration(milliseconds: 20), (timer) {
        // shots fired
        midShot = true;
        // misille grows til it hits the top of the screen

        setState(() {
          missileHeight += 10;
        });
        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          resetMissille();
          timer.cancel();

          // stop missile
        }
        // check if missile has hit the ball
        if (bally > heightToPosition(missileHeight) &&
            (ballx - missilex).abs() < 0.03) {
          setState(() {
            score++;
          });
          resetMissille();
          ballx = 0.5;
          bally = 1;
          timer.cancel();
        }
      });
    }
  }

// convert height to a coordinate
  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  void resetMissille() {
    missilex = playerx;
    missileHeight = 0;
    midShot = false;
  }

  bool playerDies() {
    // if the ball position and the player position are the same,
    //then player dies
    if ((ballx - playerx).abs() < 0.05 && bally > 0.95) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
        if (event.isKeyPressed(LogicalKeyboardKey.space)) {
          fireMissile();
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: AnimatedContainer(
              duration: Duration(
                  milliseconds: 300), // Animación cuando cambia el puntaje
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star,
                      color: Colors.yellow[700], size: 35), // Icono amarillo
                  SizedBox(width: 10),
                  Text(
                    "Puntos: $score",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texto blanco sin fondo negro
                      fontFamily: 'Arial',
                      shadows: [
                        Shadow(
                            color: Colors.purple,
                            offset: Offset(2, 2),
                            blurRadius: 3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.purple[300],
              child: Center(
                child: Stack(
                  children: [
                    MyBall(
                      ballx: ballx,
                      bally: bally,
                    ),
                    MyMissille(
                      height: missileHeight,
                      missilex: missilex,
                    ),
                    MyPlayer(
                      playerx: playerx,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    icon: Icons.play_arrow,
                    function: startGame,
                  ),
                  MyButton(
                    icon: Icons.arrow_back,
                    function: moveLeft,
                  ),
                  MyButton(
                    icon: Icons.arrow_upward,
                    function: fireMissile,
                  ),
                  MyButton(
                    icon: Icons.arrow_forward,
                    function: moveRight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

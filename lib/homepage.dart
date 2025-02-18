import 'dart:async';

import 'package:buble_trouble/ball.dart';
import 'package:buble_trouble/button.dart';
import 'package:buble_trouble/missille.dart';
import 'package:buble_trouble/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// *Definición de la clase HomePage, que es un StatefulWidget.
// *StatefulWidget es un widget que puede cambiar su estado durante la ejecución.

class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Constructor de la clase

  @override
  State<HomePage> createState() => _HomePageState();
}

/* 
*Enumeración (enum) define las direcciones 
*posibles para el moviemiento de la pelota */
enum direction { LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  int score = 0; //*Variable para almacenar la puntuación del jugador
  // *Player variables
  static double playerx = 0; // *Posición horizontal del jugador
  // *missile variables
  // *Posición horizontal del misil, inicialmente igual a la del jugador
  double missilex = playerx;

  double missileHeight = 10; // *Altura del misil

  bool midShot = false; // *Indica si el misil está en movimiento
  // ball variables
  double ballx = 0.5; // *Posición horizontal inicial de la pelota.

  double bally = 1; // *Posición vertical inicial de la pelota.

  var ballDirection = direction.LEFT; // *Dirección inicial de la pelota.

  // *Método para iniciar el juego.
  void startGame() {
    double time = 0; // *Tiempo que ha transcurrido desde el inicio del salto.

    double height = 0; // *Altura actual de la pelota.

    double velocity = 80; // how string is // *Velocidad inicial del salto.

    // *Timer que se ejecuta periódicamente cada 5 milisegundos.
    // *!Timer permite ejecutar algo despues de un cierto timepo o ejecutar algo
    // *!de manera repetitiva (periodic).
    Timer.periodic(Duration(milliseconds: 5), (timer) {
      // *Fórmula para calcular la altura
      //*de la pelota en función del tiempo (movimiento parabólico).
      height = -5 * time * time + velocity * time;
      //if the ball reaches the ground, reset the jump
      // *Si la pelota toca el suelo, reiniciar el salto.

      if (height < 0) {
        time = 0;
      }
      // update the new ball position
      // *Actualizar la posición vertical de la pelota.
      setState(() {
        //*!setState notifica a Flutter que el estado ha cambiado
        bally = heightToPosition(height); // *Convertir la altura
        //*a una posición en la pantalla.
      });

      // if the ball hits the left wall, then change direction to right
      // *Si la pelota toca la pared izquierda, cambiar la dirección a la derecha.
      if (ballx - 0.005 < -1) {
        ballDirection = direction.RIGHT;
        //if the ball hits the right wall, then change direction to left
        // *Si la pelota toca la pared derecha, cambiar la dirección a la izquierda.
      } else if (ballx + 0.005 > 1) {
        ballDirection = direction.LEFT;
      }
// move the ball in the correct direction
//*Mover la pelota en la dirección correspondiente.
      if (ballDirection == direction.LEFT) {
        setState(() {
          //*!setState notifica a Flutter que el estado ha cambiado
          ballx -= 0.005; // *Mover la pelota hacia la izquierda.
        });
      } else if (ballDirection == direction.RIGHT) {
        setState(() {
          //*!setState notifica a Flutter que el estado ha cambiado
          ballx += 0.005; // *Mover la pelota hacia la derecha.

          /// Me quedé en el minuto 23:59 en esta parte fue lo ultimo agregado
        });
      }
      // check if ball hits the player
      // *Verificar si la pelota golpea al jugador.
      if (playerDies()) {
        timer.cancel(); // *Detener el timer si el jugador pierde.
        _showDaialog(); // *Mostrar un diálogo si el jugador pierde.
      }
      // keep the time going!
      // *Incrementar el tiempo para el siguiente cálculo de altura.
      time += 0.1;
    });
  }

  // *Método para reiniciar el juego.
  void resetGame() {
    setState(() {
      // *Reiniciar posiciones del jugador y misiles
      score = 0;
      playerx = 0;
      missilex = playerx;
      missileHeight = 10;
      midShot = false;

      // *Reiniciar la pelota
      ballx = 0.5;
      bally = 1;
      ballDirection = direction.LEFT;
    });

    // *Reiniciar el juego llamando startGame()
    startGame();
  }

  // *Método para mostrar un diálogo
  void _showDaialog() {
    showDialog(
        // *!Muestra un diálogo en pantalla
        context: context, // *?context es el contexto actual de la app
        builder: (BuildContext context) {
          /* 
        *?Builder contruye y devuelve el contenido del diálogo
        *?BuildContext es su parámetro */
          return AlertDialog(
            // *!es un cuadro de diálogo predefinido en Flutter.
            backgroundColor: Colors.grey[700], // *!Define el color de fondo
            //*!del diálogo.
            title: Text(
              //*! Título del diálogo Text muestra el mensaje
              "¡Perdiste! :(",
              style: TextStyle(color: Colors.white), //*! Estilo del texto
            ),
            actions: [
              //*!Lista de widgets para los botones en el cuadro de diálogo

              TextButton(
                //*!Un botón de texto que realiza una acción cuando se presiona.

                onPressed: () {
                  //*!Define la acción que se ejecuta cuando se presiona el botón.
                  resetGame(); // *Reinicia el juego
                  Navigator.of(context)
                      .pop(); // *Cierra el diálogo usando Navigator
                },
                //*!child: Define el contenido del botón.
                child: Text("Volver a jugar", //*!Text muestra un texto
                    style: TextStyle(color: Colors.white)), //*!Estilo del texto
              ),
            ],
          );
        });
  }

  // Método para mover al jugador hacia la izquierda.
  void moveLeft() {
    setState(() {
      if (playerx - 0.1 < -1) {
        // do nothing
        // *No hacer nada si el jugador está en el límite izquierdo.
      } else {
        playerx -= 0.1; // Mover al jugador hacia la izquierda.
      }
      // *Solo actualizar la posición del misil si no está en medio de un disparo.
      // only make the x cordinate the same when it isn't in the middle of a shot
      if (!midShot) {
        missilex = playerx;
      }
    });
  }

  // *Método para mover al jugador hacia la derecha.
  void moveRight() {
    setState(() {
      if (playerx + 0.1 > 1) {
        // *No hacer nada si el jugador está en el límite derecho.
        // do nothing
      } else {
        playerx += 0.1; // *Mover al jugador hacia la derecha.
      }
      missilex = playerx; // *Actualizar la posición del misil.
    });
  }

  // Método para disparar un misil.
  void fireMissile() {
    if (midShot == false) {
      Timer.periodic(Duration(milliseconds: 20), (timer) {
        // shots fired
        midShot = true; // *Disparar el misil.
        // misille grows til it hits the top of the screen
        // *Aumentar la altura del misil
        //*hasta que llegue a la parte superior de la pantalla (arriba).
        setState(() {
          missileHeight += 10;
        });
        // *Si el misil alcanza la parte superior de la pantalla, reiniciarlo.
        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          resetMissille();
          timer.cancel();

          // stop missile
        }
        // check if missile has hit the ball
        // *Verificar si el misil ha golpeado la pelota.
        if (bally > heightToPosition(missileHeight) &&
            (ballx - missilex).abs() < 0.03) {
          setState(() {
            score++; // *Incrementar la puntuación.
          });
          resetMissille(); // *Reiniciar el misil.
          ballx = 0.5; // *Reiniciar la posición de la pelota.
          bally = 1;
          timer.cancel(); // *Detener el timer del misil.
        }
      });
    }
  }

// convert height to a coordinate
// *Método para convertir la altura en una posición en la pantalla.
  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    //*!widget que proporciona información sobre la pantalla del dispositivo
    //*!y las preferencias del usuario.
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  // *Método para reiniciar el misil.
  void resetMissille() {
    missilex = playerx;
    missileHeight = 0;
    midShot = false;
  }

  // *Método para verificar si el jugador ha sido golpeado por la pelota.
  bool playerDies() {
    // if the ball position and the player position are the same,
    //then player dies
    // *Si la posición de la pelota y la del
    // *jugador son cercanas, el jugador pierde.
    if ((ballx - playerx).abs() < 0.05 && bally > 0.95) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      //*! widget que permite escuchar eventos de teclado de forma directa
      focusNode: FocusNode(), //*!se utiliza para determinar cuál widget
      //*!debe ser el que reciba la entrada del usuario
      autofocus: true,
      onKey: (event) {
        // *Manejar eventos de teclado.
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft(); //* Mover a la izquierda con la flecha izquierda.
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight(); // *Mover a la derecha con la flecha derecha.
        }
        if (event.isKeyPressed(LogicalKeyboardKey.space)) {
          fireMissile(); // *Disparar un misil con la barra espaciadora.
        }
      },
      child: Column(
        //*!Columna en la que se van agregando widgets
        children: [
          // Barra superior con el puntaje.
          Container(
            //*!es un widget de diseño que te permite proporcionar
            //*!personalizaciones visuales a los widgets.

            color: Colors.purple[300], //*!Color del contenedor

            width:
                double.infinity, //*!define el ancho del contenedor (infinito)
            child: Padding(
              //*!Relleno desde dentro
              padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 5),
              //*!Se usa un symetric para que el relleno se distribuya parejo

              child: AnimatedContainer(
                //*!permite realizar animaciones automáticamente
                duration: Duration(
                    milliseconds: 300), // *!Animación cuando cambia el puntaje
                curve: Curves.easeInOut, //*! La curva de animación
                // *Relleno de 10 en los lados y 5 arriba y abajo
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Stack(
                  // *!Un widget Stack para apilar varios elementos
                  children: [
                    Align(
                      // *!Alinea el icono en la esquina inferior derecha
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    Align(
                      // *!Alinea el icono en la esquina inferior izquierda
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.menu,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    Center(
                      //*!Centra el contenido de la fila
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min, //*!Se utiliza en row o column
                        //*!Para administrar el espacio disponible.
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow[700],
                            size: 35,
                          ), // Icono amarillo
                          SizedBox(
                              width:
                                  10), //*!se utiliza para dar un tamaño fijo a un widget
                          Text(
                            "Puntos: $score",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors.white, // *Texto blanco sin fondo negro
                              fontFamily: 'Arial',
                              shadows: [
                                //*!Sombreado del texto
                                Shadow(
                                    color: Colors.black,
                                    offset: Offset(2, 2), //*!Desplazamiento
                                    blurRadius: 3), //*!Grado de difuminado
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Área de juego.
          Expanded(
            //*Hace que un widget tome todo el espacio disponible
            flex: 3, //*Alineación flexible
            child: Container(
              color: Colors.purple[300],
              child: Center(
                child: Stack(
                  children: [
                    // *Pelota
                    MyBall(
                      ballx: ballx,
                      bally: bally,
                    ),
                    // *Misil
                    MyMissille(
                      height: missileHeight,
                      missilex: missilex,
                    ),
                    //*Jugador
                    MyPlayer(
                      playerx: playerx,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            // Botones de control.
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, //*Alinear los widgets
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

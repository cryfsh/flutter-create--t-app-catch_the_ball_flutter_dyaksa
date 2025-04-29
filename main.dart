
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(CatchTheBallApp());

class CatchTheBallApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GamePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  double ballX = 0.0;
  double paddleX = 0.0;
  int score = 0;
  int lives = 3;
  double ballY = -0.9;
  bool movingDown = true;
  late Timer gameLoop;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    gameLoop = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {
        ballY += 0.03;
        if (ballY >= 0.95) {
          if ((ballX - paddleX).abs() < 0.2) {
            score++;
            resetBall();
          } else {
            lives--;
            if (lives <= 0) {
              gameLoop.cancel();
              showGameOverDialog();
            }
            resetBall();
          }
        }
      });
    });
  }

  void resetBall() {
    ballX = Random().nextDouble() * 2 - 1;
    ballY = -0.9;
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Score: $score'),
        actions: [
          TextButton(
            child: Text('Restart'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                score = 0;
                lives = 3;
                startGame();
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, -0.95),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Score: $score  Lives: $lives',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
          Align(
            alignment: Alignment(ballX, ballY),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            ),
          ),
          Align(
            alignment: Alignment(paddleX, 0.9),
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  paddleX += details.delta.dx / MediaQuery.of(context).size.width * 2;
                  paddleX = paddleX.clamp(-1.0, 1.0);
                });
              },
              child: Container(
                width: 100,
                height: 20,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

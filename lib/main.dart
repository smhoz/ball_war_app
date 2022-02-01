import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'circle_button.dart';
import 'context_extension.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberOfSquares = 700;
  static bool alienGotHit = false;
  bool isStart = false;

  List<int> spaceship = [
    587,
    588,
    589,
    590,
    591,
    592,
    593,
    607,
    608,
    609,
    610,
    611,
    612,
    613
  ];

  List<int> alien = [30, 31, 32, 33, 34, 35, 36, 50, 51, 52, 53, 54, 55, 56];

  void startGame() {
    isStart = true;
    const durationFood = Duration(milliseconds: 700);
    Timer.periodic(
      durationFood,
      (Timer timer) {
        alienMoves();
      },
    );
  }

  String direction = 'left';
  void alienMoves() {
    setState(() {
      if ((alien[0] - 1) % 20 == 0) {
        direction = 'right';
      } else if ((alien.last + 2) % 20 == 0) {
        direction = 'left';
      }

      if (direction == 'right') {
        for (int i = 0; i < alien.length; i++) {
          alien[i] += 1;
        }
      } else {
        for (int i = 0; i < alien.length; i++) {
          alien[i] -= 1;
        }
      }
    });
  }

  void moveLeft() {
    setState(() {
      for (int i = 0; i < spaceship.length; i++) {
        spaceship[i] -= 1;
      }
    });
  }

  void moveRight() {
    setState(() {
      for (int i = 0; i < spaceship.length; i++) {
        spaceship[i] += 1;
      }
    });
  }

  void updateDamage() {
    setState(() {
      if (alien.contains(playerMissileShot)) {
        alien.remove(playerMissileShot);
        playerMissileShot = -1;
        alienGotHit = true;
      }
      if (spaceship.contains(alienMissileShot)) {
        spaceship.remove(alienMissileShot);
        alienMissileShot = alien.first;
      }

      if (playerMissileShot == alienMissileShot) {
        playerMissileShot = -1;
        alienMissileShot = alien.first;
        alienGotHit = true;
      }
    });
  }

  int? playerMissileShot;
  void fireMissile() {
    playerMissileShot = spaceship.length > 3 ? spaceship[3] : spaceship.first;
    alienGotHit = false;
    const durationMissile = Duration(milliseconds: 50);
    Timer.periodic(
      durationMissile,
      (Timer timer) {
        playerMissileShot = playerMissileShot! - 20;
        updateDamage();
        if (alienGotHit || playerMissileShot! < 0) {
          timer.cancel();
        }
      },
    );
  }

  int? alienMissileShot;

  bool timeForNextShot = false;
  void updateAlienMissile() {
    setState(() {
      alienMissileShot = alienMissileShot! + 20;
      if (alienMissileShot! > 760) {
        timeForNextShot = true;
      }
    });
  }

  bool alienGunAtBack = true;
  void alienMissile() {
    alienMissileShot = alien.last;
    alienGunAtBack = !alienGunAtBack;
    if (alienGunAtBack) {
      alienMissileShot = alien.last;
    } else {
      alienMissileShot = alien.first;
    }
    const durationMissile = Duration(milliseconds: 100);
    Timer.periodic(
      durationMissile,
      (Timer timer) {
        updateAlienMissile();
        updateDamage();
        if (timeForNextShot) {
          alienMissileShot = alien.last;
          timeForNextShot = false;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBAE0E0),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: numberOfSquares,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 20),
                    itemBuilder: (BuildContext context, int index) {
                      if (playerMissileShot == index ||
                          (spaceship.length > 3
                                  ? spaceship[3]
                                  : spaceship.first) ==
                              index) {
                        return _cirleGridView(Colors.red);
                      } else if (spaceship.contains(index)) {
                        return _cirleGridView(Colors.white);
                      }

                      if (alien.contains(index) || alienMissileShot == index) {
                        return _cirleGridView(Colors.green);
                      } else {
                        return _cirleGridView(const Color(0xFFdce7f0));
                      }
                    }),
              ),
            ),
            _bottomButton(context)
          ],
        ),
      ),
    );
  }

  Padding _bottomButton(BuildContext context) {
    return Padding(
      padding: context.paddingMedium,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (!isStart) ...[
            GestureDetector(
                onTap: () {
                  alienMissile();
                  startGame();
                },
                child: Container(
                  padding: context.paddingLow,
                  decoration: BoxDecoration(
                      color: const Color(0xFF5FC6FF),
                      borderRadius: BorderRadius.circular(16)),
                  child: const Text(
                    'PLAY!',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                )),
          ],
          CircleButton(
            onTap: () => moveLeft(),
            icon: Icons.arrow_left,
          ),
          CircleButton(
            onTap: () {
              fireMissile();
              HapticFeedback.vibrate();
            },
            icon: Icons.arrow_drop_up,
          ),
          CircleButton(
            onTap: moveRight,
            icon: Icons.arrow_right,
          )
        ],
      ),
    );
  }

  Widget _cirleGridView(Color color) {
    return Container(
      padding: context.paddingGridView,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(color: color)),
    );
  }

  void _showGameOverScreen() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('GAME OVER'),
            content: const Text('You\'re score: '),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Play Again'),
                onPressed: () {
                  startGame();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pacman/constants.dart';
import 'package:pacman/ghost1.dart';
import 'package:pacman/ghost2.dart';
import 'package:pacman/ghost3.dart';
import 'package:pacman/path.dart';
import 'package:pacman/pixel.dart';
import 'package:pacman/player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 16;
  int player = numberInRow * 14 + 1;
  int ghost1 = numberInRow * 2 - 2;
  int ghost2 = numberInRow * 9 - 1;
  int ghost3 = numberInRow * 11 - 2;
  List<int> food = [];
  bool preGame = true;
  bool mouthClosed = false;
  int score = 0;
  bool paused = false;
  AudioPlayer advancedPlayer = AudioPlayer();
  AudioPlayer advancedPlayer2 = AudioPlayer();
  AudioCache audioInGame = AudioCache(prefix: 'assets/');
  AudioCache audioMunch = AudioCache(prefix: 'assets/');
  AudioCache audioDeath = AudioCache(prefix: 'assets/');
  AudioCache audioPaused = AudioCache(prefix: 'assets/');
  String direction = "right";
  String ghostLast = "left";
  String ghost2Last = "left";
  String ghost3Last = "down";

  @override
  void initState() {
    getFood();
    super.initState();
  }

  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!ConstantList.barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: (MediaQuery.of(context).size.height.toInt() * 0.0139).toInt(),
            child: GridView.builder(
              padding:
                  (MediaQuery.of(context).size.height.toInt() * 0.0139)
                          .toInt() >
                      10
                  ? const EdgeInsets.only(top: 80)
                  : const EdgeInsets.only(top: 20),
              itemCount: numberOfSquares,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numberInRow,
              ),
              itemBuilder: (context, index) {
                if (player == index) {
                  return const Player();
                } else if (ghost1 == index) {
                  return const Ghost1();
                } else if (ghost2 == index) {
                  return Ghost2();
                } else if (ghost3 == index) {
                  return Ghost3();
                } else if (ConstantList.barriers.contains(index)) {
                  return Pixel(
                    innerColor: Colors.blue[900],
                    outerColor: Colors.blue[800],
                  );
                } else if (preGame || food.contains(index)) {
                  return MyPath(
                    innerColor: Colors.yellow,
                    outerColor: Colors.black,
                  );
                } else {
                  return Pixel(
                    innerColor: Colors.black,
                    outerColor: Colors.black,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

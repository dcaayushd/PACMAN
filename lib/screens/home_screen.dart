// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:pacman/ghost1.dart';
// import 'package:pacman/ghost2.dart';
// import 'package:pacman/ghost3.dart';
// import 'package:pacman/path.dart';
// import 'package:pacman/pixel.dart';
// import 'package:pacman/player.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   HomeScreenState createState() => HomeScreenState();
// }

// class HomeScreenState extends State<HomeScreen> {
//   static int numberInRow = 11;
//   int numberOfSquares = numberInRow * 16;
//   int player = numberInRow * 14 + 1;
//   int ghost = numberInRow * 2 - 2;
//   int ghost2 = numberInRow * 9 - 1;
//   int ghost3 = numberInRow * 11 - 2;
//   bool preGame = true;
//   bool mouthClosed = false;
//   Timer? controller;
//   int score = 0;
//   bool paused = false;
//   AudioPlayer advancedPlayer = AudioPlayer();
//   AudioPlayer advancedPlayer2 = AudioPlayer();

//   List<int> barriers = [
//     0,
//     1,
//     2,
//     3,
//     4,
//     5,
//     6,
//     7,
//     8,
//     9,
//     10,
//     11,
//     22,
//     33,
//     44,
//     55,
//     66,
//     77,
//     99,
//     110,
//     121,
//     132,
//     143,
//     154,
//     165,
//     166,
//     167,
//     168,
//     169,
//     170,
//     171,
//     172,
//     173,
//     174,
//     175,
//     164,
//     153,
//     142,
//     131,
//     120,
//     109,
//     87,
//     76,
//     65,
//     54,
//     43,
//     32,
//     21,
//     78,
//     79,
//     80,
//     100,
//     101,
//     102,
//     84,
//     85,
//     86,
//     106,
//     107,
//     108,
//     24,
//     35,
//     46,
//     57,
//     30,
//     41,
//     52,
//     63,
//     81,
//     70,
//     59,
//     61,
//     72,
//     83,
//     26,
//     28,
//     37,
//     38,
//     39,
//     123,
//     134,
//     145,
//     129,
//     140,
//     151,
//     103,
//     114,
//     125,
//     105,
//     116,
//     127,
//     147,
//     148,
//     149,
//   ];

//   List<int> food = [];
//   String direction = "right";
//   String ghostLast = "left";
//   String ghostLast2 = "left";
//   String ghostLast3 = "down";

//   void startGame() {
//     if (preGame) {
//       advancedPlayer = AudioPlayer();
//       advancedPlayer2 = AudioPlayer();

//       // Play beginning sound
//       _playSound(advancedPlayer, 'assets/sounds/pacman_beginning.wav');

//       preGame = false;
//       getFood();

//       Timer.periodic(const Duration(milliseconds: 10), (timer) {
//         if (paused) {
//           // Game is paused, do nothing
//         } else {
//           advancedPlayer.resume();
//         }
//         if (player == ghost || player == ghost2 || player == ghost3) {
//           advancedPlayer.stop();
//           _playSound(advancedPlayer, 'assets/sounds/pacman_death.wav');
//           setState(() {
//             player = -1;
//           });
//           showDialog(
//             barrierDismissible: false,
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: const Center(child: Text("Game Over!")),
//                 content: Text("Your Score: $score"),
//                 actions: [
//                   ElevatedButton(
//                     onPressed: () {
//                       _playSound(
//                         advancedPlayer,
//                         'assets/sounds/pacman_beginning.wav',
//                         loop: true,
//                       );
//                       setState(() {
//                         player = numberInRow * 14 + 1;
//                         ghost = numberInRow * 2 - 2;
//                         ghost2 = numberInRow * 9 - 1;
//                         ghost3 = numberInRow * 11 - 2;
//                         paused = false;
//                         preGame = false;
//                         mouthClosed = false;
//                         direction = "right";
//                         food.clear();
//                         getFood();
//                         score = 0;
//                         Navigator.pop(context);
//                       });
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF1976D2),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.all(10.0),
//                     ),
//                     child: const Text('Restart'),
//                   ),
//                 ],
//               );
//             },
//           );
//         }
//       });

//       Timer.periodic(const Duration(milliseconds: 190), (timer) {
//         if (!paused) {
//           moveGhost();
//           moveGhost2();
//           moveGhost3();
//         }
//       });

//       Timer.periodic(const Duration(milliseconds: 170), (timer) {
//         setState(() {
//           mouthClosed = !mouthClosed;
//         });
//         if (food.contains(player)) {
//           _playSound(AudioPlayer(), 'assets/sounds/pacman_chomp.wav');
//           setState(() {
//             food.remove(player);
//           });
//           score++;
//         }

//         switch (direction) {
//           case "left":
//             if (!paused) moveLeft();
//             break;
//           case "right":
//             if (!paused) moveRight();
//             break;
//           case "up":
//             if (!paused) moveUp();
//             break;
//           case "down":
//             if (!paused) moveDown();
//             break;
//         }
//       });
//     }
//   }

//   void _playSound(AudioPlayer player, String path, {bool loop = false}) async {
//     try {
//       if (loop) {
//         await player.setReleaseMode(ReleaseMode.loop);
//       } else {
//         await player.setReleaseMode(ReleaseMode.release);
//       }
//       await player.play(AssetSource(path.replaceAll('assets/sounds/', '')));
//     } catch (e) {
//       // print('Error playing sound: $e');
//     }
//   }

//   void restart() {
//     startGame();
//   }

//   void getFood() {
//     for (int i = 0; i < numberOfSquares; i++) {
//       if (!barriers.contains(i)) {
//         food.add(i);
//       }
//     }
//   }

//   void moveLeft() {
//     if (!barriers.contains(player - 1)) {
//       setState(() {
//         player--;
//       });
//     }
//   }

//   void moveRight() {
//     if (!barriers.contains(player + 1)) {
//       setState(() {
//         player++;
//       });
//     }
//   }

//   void moveUp() {
//     if (!barriers.contains(player - numberInRow)) {
//       setState(() {
//         player -= numberInRow;
//       });
//     }
//   }

//   void moveDown() {
//     if (!barriers.contains(player + numberInRow)) {
//       setState(() {
//         player += numberInRow;
//       });
//     }
//   }

//   void moveGhost() {
//     switch (ghostLast) {
//       case "left":
//         if (!barriers.contains(ghost - 1)) {
//           setState(() {
//             ghost--;
//           });
//         } else {
//           if (!barriers.contains(ghost + numberInRow)) {
//             setState(() {
//               ghost += numberInRow;
//               ghostLast = "down";
//             });
//           } else if (!barriers.contains(ghost + 1)) {
//             setState(() {
//               ghost++;
//               ghostLast = "right";
//             });
//           } else if (!barriers.contains(ghost - numberInRow)) {
//             setState(() {
//               ghost -= numberInRow;
//               ghostLast = "up";
//             });
//           }
//         }
//         break;
//       case "right":
//         if (!barriers.contains(ghost + 1)) {
//           setState(() {
//             ghost++;
//           });
//         } else {
//           if (!barriers.contains(ghost - numberInRow)) {
//             setState(() {
//               ghost -= numberInRow;
//               ghostLast = "up";
//             });
//           } else if (!barriers.contains(ghost + numberInRow)) {
//             setState(() {
//               ghost += numberInRow;
//               ghostLast = "down";
//             });
//           } else if (!barriers.contains(ghost - 1)) {
//             setState(() {
//               ghost--;
//               ghostLast = "left";
//             });
//           }
//         }
//         break;
//       case "up":
//         if (!barriers.contains(ghost - numberInRow)) {
//           setState(() {
//             ghost -= numberInRow;
//             ghostLast = "up";
//           });
//         } else {
//           if (!barriers.contains(ghost + 1)) {
//             setState(() {
//               ghost++;
//               ghostLast = "right";
//             });
//           } else if (!barriers.contains(ghost - 1)) {
//             setState(() {
//               ghost--;
//               ghostLast = "left";
//             });
//           } else if (!barriers.contains(ghost + numberInRow)) {
//             setState(() {
//               ghost += numberInRow;
//               ghostLast = "down";
//             });
//           }
//         }
//         break;
//       case "down":
//         if (!barriers.contains(ghost + numberInRow)) {
//           setState(() {
//             ghost += numberInRow;
//             ghostLast = "down";
//           });
//         } else {
//           if (!barriers.contains(ghost - 1)) {
//             setState(() {
//               ghost--;
//               ghostLast = "left";
//             });
//           } else if (!barriers.contains(ghost + 1)) {
//             setState(() {
//               ghost++;
//               ghostLast = "right";
//             });
//           } else if (!barriers.contains(ghost - numberInRow)) {
//             setState(() {
//               ghost -= numberInRow;
//               ghostLast = "up";
//             });
//           }
//         }
//         break;
//     }
//   }

//   void moveGhost2() {
//     switch (ghostLast2) {
//       case "left":
//         if (!barriers.contains(ghost2 - 1)) {
//           setState(() {
//             ghost2--;
//           });
//         } else {
//           if (!barriers.contains(ghost2 + numberInRow)) {
//             setState(() {
//               ghost2 += numberInRow;
//               ghostLast2 = "down";
//             });
//           } else if (!barriers.contains(ghost2 + 1)) {
//             setState(() {
//               ghost2++;
//               ghostLast2 = "right";
//             });
//           } else if (!barriers.contains(ghost2 - numberInRow)) {
//             setState(() {
//               ghost2 -= numberInRow;
//               ghostLast2 = "up";
//             });
//           }
//         }
//         break;
//       case "right":
//         if (!barriers.contains(ghost2 + 1)) {
//           setState(() {
//             ghost2++;
//           });
//         } else {
//           if (!barriers.contains(ghost2 - numberInRow)) {
//             setState(() {
//               ghost2 -= numberInRow;
//               ghostLast2 = "up";
//             });
//           } else if (!barriers.contains(ghost2 + numberInRow)) {
//             setState(() {
//               ghost2 += numberInRow;
//               ghostLast2 = "down";
//             });
//           } else if (!barriers.contains(ghost2 - 1)) {
//             setState(() {
//               ghost2--;
//               ghostLast2 = "left";
//             });
//           }
//         }
//         break;
//       case "up":
//         if (!barriers.contains(ghost2 - numberInRow)) {
//           setState(() {
//             ghost2 -= numberInRow;
//             ghostLast2 = "up";
//           });
//         } else {
//           if (!barriers.contains(ghost2 + 1)) {
//             setState(() {
//               ghost2++;
//               ghostLast2 = "right";
//             });
//           } else if (!barriers.contains(ghost2 - 1)) {
//             setState(() {
//               ghost2--;
//               ghostLast2 = "left";
//             });
//           } else if (!barriers.contains(ghost2 + numberInRow)) {
//             setState(() {
//               ghost2 += numberInRow;
//               ghostLast2 = "down";
//             });
//           }
//         }
//         break;
//       case "down":
//         if (!barriers.contains(ghost2 + numberInRow)) {
//           setState(() {
//             ghost2 += numberInRow;
//             ghostLast2 = "down";
//           });
//         } else {
//           if (!barriers.contains(ghost2 - 1)) {
//             setState(() {
//               ghost2--;
//               ghostLast2 = "left";
//             });
//           } else if (!barriers.contains(ghost2 + 1)) {
//             setState(() {
//               ghost2++;
//               ghostLast2 = "right";
//             });
//           } else if (!barriers.contains(ghost2 - numberInRow)) {
//             setState(() {
//               ghost2 -= numberInRow;
//               ghostLast2 = "up";
//             });
//           }
//         }
//         break;
//     }
//   }

//   void moveGhost3() {
//     switch (ghostLast3) {
//       case "left":
//         if (!barriers.contains(ghost3 - 1)) {
//           setState(() {
//             ghost3--;
//           });
//         } else {
//           if (!barriers.contains(ghost3 + numberInRow)) {
//             setState(() {
//               ghost3 += numberInRow;
//               ghostLast3 = "down";
//             });
//           } else if (!barriers.contains(ghost3 + 1)) {
//             setState(() {
//               ghost3++;
//               ghostLast3 = "right";
//             });
//           } else if (!barriers.contains(ghost3 - numberInRow)) {
//             setState(() {
//               ghost3 -= numberInRow;
//               ghostLast3 = "up";
//             });
//           }
//         }
//         break;
//       case "right":
//         if (!barriers.contains(ghost3 + 1)) {
//           setState(() {
//             ghost3++;
//           });
//         } else {
//           if (!barriers.contains(ghost3 - numberInRow)) {
//             setState(() {
//               ghost3 -= numberInRow;
//               ghostLast3 = "up";
//             });
//           } else if (!barriers.contains(ghost3 - 1)) {
//             setState(() {
//               ghost3--;
//               ghostLast3 = "left";
//             });
//           } else if (!barriers.contains(ghost3 + numberInRow)) {
//             setState(() {
//               ghost3 += numberInRow;
//               ghostLast3 = "down";
//             });
//           }
//         }
//         break;
//       case "up":
//         if (!barriers.contains(ghost3 - numberInRow)) {
//           setState(() {
//             ghost3 -= numberInRow;
//             ghostLast3 = "up";
//           });
//         } else {
//           if (!barriers.contains(ghost3 + 1)) {
//             setState(() {
//               ghost3++;
//               ghostLast3 = "right";
//             });
//           } else if (!barriers.contains(ghost3 - 1)) {
//             setState(() {
//               ghost3--;
//               ghostLast3 = "left";
//             });
//           } else if (!barriers.contains(ghost3 + numberInRow)) {
//             setState(() {
//               ghost3 += numberInRow;
//               ghostLast3 = "down";
//             });
//           }
//         }
//         break;
//       case "down":
//         if (!barriers.contains(ghost3 + numberInRow)) {
//           setState(() {
//             ghost3 += numberInRow;
//             ghostLast3 = "down";
//           });
//         } else {
//           if (!barriers.contains(ghost3 - 1)) {
//             setState(() {
//               ghost3--;
//               ghostLast3 = "left";
//             });
//           } else if (!barriers.contains(ghost3 + 1)) {
//             setState(() {
//               ghost3++;
//               ghostLast3 = "right";
//             });
//           } else if (!barriers.contains(ghost3 - numberInRow)) {
//             setState(() {
//               ghost3 -= numberInRow;
//               ghostLast3 = "up";
//             });
//           }
//         }
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         children: [
//           Expanded(
//             flex: (MediaQuery.of(context).size.height * 0.0139).toInt(),
//             child: GestureDetector(
//               onVerticalDragUpdate: (details) {
//                 if (details.delta.dy > 0) {
//                   direction = "down";
//                 } else if (details.delta.dy < 0) {
//                   direction = "up";
//                 }
//               },
//               onHorizontalDragUpdate: (details) {
//                 if (details.delta.dx > 0) {
//                   direction = "right";
//                 } else if (details.delta.dx < 0) {
//                   direction = "left";
//                 }
//               },
//               child: GridView.builder(
//                 padding:
//                     (MediaQuery.of(context).size.height * 0.0139).toInt() > 10
//                     ? const EdgeInsets.only(top: 80)
//                     : const EdgeInsets.only(top: 20),
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: numberOfSquares,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: numberInRow,
//                 ),
//                 itemBuilder: (BuildContext context, int index) {
//                   if (mouthClosed && player == index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(4),
//                       child: Container(
//                         decoration: const BoxDecoration(
//                           color: Colors.yellow,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     );
//                   } else if (player == index) {
//                     switch (direction) {
//                       case "left":
//                         return Transform.rotate(
//                           angle: pi,
//                           child: const Player(),
//                         );
//                       case "right":
//                         return const Player();
//                       case "up":
//                         return Transform.rotate(
//                           angle: 3 * pi / 2,
//                           child: const Player(),
//                         );
//                       case "down":
//                         return Transform.rotate(
//                           angle: pi / 2,
//                           child: const Player(),
//                         );
//                       default:
//                         return const Player();
//                     }
//                   } else if (ghost == index) {
//                     return const Ghost1();
//                   } else if (ghost2 == index) {
//                     return Ghost2();
//                   } else if (ghost3 == index) {
//                     return Ghost3();
//                   } else if (barriers.contains(index)) {
//                     return Pixel(
//                       innerColor: Colors.blue[900],
//                       outerColor: Colors.blue[800],
//                     );
//                   } else if (preGame || food.contains(index)) {
//                     return const MyPath(
//                       innerColor: Colors.yellow,
//                       outerColor: Colors.black,
//                     );
//                   } else {
//                     return const MyPath(
//                       innerColor: Colors.black,
//                       outerColor: Colors.black,
//                     );
//                   }
//                 },
//               ),
//             ),
//           ),
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Text(
//                   "Score: $score",
//                   style: const TextStyle(color: Colors.white, fontSize: 23),
//                 ),
//                 GestureDetector(
//                   onTap: startGame,
//                   child: const Text(
//                     "P L A Y",
//                     style: TextStyle(color: Colors.white, fontSize: 23),
//                   ),
//                 ),
//                 GestureDetector(
//                   child: Icon(
//                     paused ? Icons.play_arrow : Icons.pause,
//                     color: Colors.white,
//                   ),
//                   onTap: () {
//                     setState(() {
//                       if (!paused) {
//                         paused = true;
//                         advancedPlayer.pause();
//                         _playSound(
//                           advancedPlayer2,
//                           'assets/sounds/pacman_intermission.wav',
//                         );
//                       } else {
//                         paused = false;
//                         advancedPlayer2.stop();
//                         advancedPlayer.resume();
//                       }
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pacman/barriers.dart';
import 'package:pacman/ghost1.dart';
import 'package:pacman/ghost2.dart';
import 'package:pacman/ghost3.dart';
import 'package:pacman/path.dart';
import 'package:pacman/pixel.dart';
import 'package:pacman/player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 16;
  int player = numberInRow * 14 + 1;
  int ghost = numberInRow * 2 - 2;
  int ghost2 = numberInRow * 9 - 1;
  int ghost3 = numberInRow * 11 - 2;
  bool preGame = true;
  bool mouthClosed = false;
  Timer? controller;
  int score = 0;
  bool paused = false;
  AudioPlayer advancedPlayer = AudioPlayer();
  AudioPlayer advancedPlayer2 = AudioPlayer();

  List<int> food = [];
  String direction = "right";
  String ghostLast = "left";
  String ghostLast2 = "left";
  String ghostLast3 = "down";

  void startGame() {
    if (preGame) {
      advancedPlayer = AudioPlayer();
      advancedPlayer2 = AudioPlayer();

      // Play beginning sound
      _playSound(advancedPlayer, 'assets/sounds/pacman_beginning.wav');

      preGame = false;
      getFood();

      Timer.periodic(const Duration(milliseconds: 10), (timer) {
        if (paused) {
          // Game is paused, do nothing
        } else {
          advancedPlayer.resume();
        }
        if (player == ghost || player == ghost2 || player == ghost3) {
          advancedPlayer.stop();
          _playSound(advancedPlayer, 'assets/sounds/pacman_death.wav');
          setState(() {
            player = -1;
          });
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Center(child: Text("Game Over!")),
                content: Text("Your Score: $score"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      _playSound(
                        advancedPlayer,
                        'assets/sounds/pacman_beginning.wav',
                        loop: true,
                      );
                      setState(() {
                        player = numberInRow * 14 + 1;
                        ghost = numberInRow * 2 - 2;
                        ghost2 = numberInRow * 9 - 1;
                        ghost3 = numberInRow * 11 - 2;
                        paused = false;
                        preGame = false;
                        mouthClosed = false;
                        direction = "right";
                        food.clear();
                        getFood();
                        score = 0;
                        Navigator.pop(context);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(10.0),
                    ),
                    child: const Text('Restart'),
                  ),
                ],
              );
            },
          );
        }
      });

      Timer.periodic(const Duration(milliseconds: 190), (timer) {
        if (!paused) {
          moveGhost();
          moveGhost2();
          moveGhost3();
        }
      });

      Timer.periodic(const Duration(milliseconds: 170), (timer) {
        setState(() {
          mouthClosed = !mouthClosed;
        });
        if (food.contains(player)) {
          _playSound(AudioPlayer(), 'assets/sounds/pacman_chomp.wav');
          setState(() {
            food.remove(player);
          });
          score++;
        }

        switch (direction) {
          case "left":
            if (!paused) moveLeft();
            break;
          case "right":
            if (!paused) moveRight();
            break;
          case "up":
            if (!paused) moveUp();
            break;
          case "down":
            if (!paused) moveDown();
            break;
        }
      });
    }
  }

  void _playSound(AudioPlayer player, String path, {bool loop = false}) async {
    try {
      if (loop) {
        await player.setReleaseMode(ReleaseMode.loop);
      } else {
        await player.setReleaseMode(ReleaseMode.release);
      }
      await player.play(AssetSource(path.replaceAll('assets/sounds/', '')));
    } catch (e) {
      // print('Error playing sound: $e');
    }
  }

  void restart() {
    startGame();
  }

  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!Barriers.barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void moveLeft() {
    if (!Barriers.barriers.contains(player - 1)) {
      setState(() {
        player--;
      });
    }
  }

  void moveRight() {
    if (!Barriers.barriers.contains(player + 1)) {
      setState(() {
        player++;
      });
    }
  }

  void moveUp() {
    if (!Barriers.barriers.contains(player - numberInRow)) {
      setState(() {
        player -= numberInRow;
      });
    }
  }

  void moveDown() {
    if (!Barriers.barriers.contains(player + numberInRow)) {
      setState(() {
        player += numberInRow;
      });
    }
  }

  void moveGhost() {
    switch (ghostLast) {
      case "left":
        if (!Barriers.barriers.contains(ghost - 1)) {
          setState(() {
            ghost--;
          });
        } else {
          if (!Barriers.barriers.contains(ghost + numberInRow)) {
            setState(() {
              ghost += numberInRow;
              ghostLast = "down";
            });
          } else if (!Barriers.barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
              ghostLast = "right";
            });
          } else if (!Barriers.barriers.contains(ghost - numberInRow)) {
            setState(() {
              ghost -= numberInRow;
              ghostLast = "up";
            });
          }
        }
        break;
      case "right":
        if (!Barriers.barriers.contains(ghost + 1)) {
          setState(() {
            ghost++;
          });
        } else {
          if (!Barriers.barriers.contains(ghost - numberInRow)) {
            setState(() {
              ghost -= numberInRow;
              ghostLast = "up";
            });
          } else if (!Barriers.barriers.contains(ghost + numberInRow)) {
            setState(() {
              ghost += numberInRow;
              ghostLast = "down";
            });
          } else if (!Barriers.barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
              ghostLast = "left";
            });
          }
        }
        break;
      case "up":
        if (!Barriers.barriers.contains(ghost - numberInRow)) {
          setState(() {
            ghost -= numberInRow;
            ghostLast = "up";
          });
        } else {
          if (!Barriers.barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
              ghostLast = "right";
            });
          } else if (!Barriers.barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
              ghostLast = "left";
            });
          } else if (!Barriers.barriers.contains(ghost + numberInRow)) {
            setState(() {
              ghost += numberInRow;
              ghostLast = "down";
            });
          }
        }
        break;
      case "down":
        if (!Barriers.barriers.contains(ghost + numberInRow)) {
          setState(() {
            ghost += numberInRow;
            ghostLast = "down";
          });
        } else {
          if (!Barriers.barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
              ghostLast = "left";
            });
          } else if (!Barriers.barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
              ghostLast = "right";
            });
          } else if (!Barriers.barriers.contains(ghost - numberInRow)) {
            setState(() {
              ghost -= numberInRow;
              ghostLast = "up";
            });
          }
        }
        break;
    }
  }

  void moveGhost2() {
    switch (ghostLast2) {
      case "left":
        if (!Barriers.barriers.contains(ghost2 - 1)) {
          setState(() {
            ghost2--;
          });
        } else {
          if (!Barriers.barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          } else if (!Barriers.barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!Barriers.barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          }
        }
        break;
      case "right":
        if (!Barriers.barriers.contains(ghost2 + 1)) {
          setState(() {
            ghost2++;
          });
        } else {
          if (!Barriers.barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          } else if (!Barriers.barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          } else if (!Barriers.barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          }
        }
        break;
      case "up":
        if (!Barriers.barriers.contains(ghost2 - numberInRow)) {
          setState(() {
            ghost2 -= numberInRow;
            ghostLast2 = "up";
          });
        } else {
          if (!Barriers.barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!Barriers.barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          } else if (!Barriers.barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          }
        }
        break;
      case "down":
        if (!Barriers.barriers.contains(ghost2 + numberInRow)) {
          setState(() {
            ghost2 += numberInRow;
            ghostLast2 = "down";
          });
        } else {
          if (!Barriers.barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          } else if (!Barriers.barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!Barriers.barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          }
        }
        break;
    }
  }

  void moveGhost3() {
    switch (ghostLast3) {
      case "left":
        if (!Barriers.barriers.contains(ghost3 - 1)) {
          setState(() {
            ghost3--;
          });
        } else {
          if (!Barriers.barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          } else if (!Barriers.barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!Barriers.barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          }
        }
        break;
      case "right":
        if (!Barriers.barriers.contains(ghost3 + 1)) {
          setState(() {
            ghost3++;
          });
        } else {
          if (!Barriers.barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          } else if (!Barriers.barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!Barriers.barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          }
        }
        break;
      case "up":
        if (!Barriers.barriers.contains(ghost3 - numberInRow)) {
          setState(() {
            ghost3 -= numberInRow;
            ghostLast3 = "up";
          });
        } else {
          if (!Barriers.barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!Barriers.barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!Barriers.barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          }
        }
        break;
      case "down":
        if (!Barriers.barriers.contains(ghost3 + numberInRow)) {
          setState(() {
            ghost3 += numberInRow;
            ghostLast3 = "down";
          });
        } else {
          if (!Barriers.barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!Barriers.barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!Barriers.barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: (MediaQuery.of(context).size.height * 0.0139).toInt(),
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  direction = "down";
                } else if (details.delta.dy < 0) {
                  direction = "up";
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  direction = "right";
                } else if (details.delta.dx < 0) {
                  direction = "left";
                }
              },
              child: GridView.builder(
                padding:
                    (MediaQuery.of(context).size.height * 0.0139).toInt() > 10
                    ? const EdgeInsets.only(top: 80)
                    : const EdgeInsets.only(top: 20),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numberInRow,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (mouthClosed && player == index) {
                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  } else if (player == index) {
                    switch (direction) {
                      case "left":
                        return Transform.rotate(
                          angle: pi,
                          child: const Player(),
                        );
                      case "right":
                        return const Player();
                      case "up":
                        return Transform.rotate(
                          angle: 3 * pi / 2,
                          child: const Player(),
                        );
                      case "down":
                        return Transform.rotate(
                          angle: pi / 2,
                          child: const Player(),
                        );
                      default:
                        return const Player();
                    }
                  } else if (ghost == index) {
                    return const Ghost1();
                  } else if (ghost2 == index) {
                    return Ghost2();
                  } else if (ghost3 == index) {
                    return Ghost3();
                  } else if (Barriers.barriers.contains(index)) {
                    return Pixel(
                      innerColor: Colors.blue[900],
                      outerColor: Colors.blue[800],
                    );
                  } else if (preGame || food.contains(index)) {
                    return const MyPath(
                      innerColor: Colors.yellow,
                      outerColor: Colors.black,
                    );
                  } else {
                    return const MyPath(
                      innerColor: Colors.black,
                      outerColor: Colors.black,
                    );
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Score: $score",
                  style: const TextStyle(color: Colors.white, fontSize: 23),
                ),
                GestureDetector(
                  onTap: startGame,
                  child: const Text(
                    "P L A Y",
                    style: TextStyle(color: Colors.white, fontSize: 23),
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    paused ? Icons.play_arrow : Icons.pause,
                    color: Colors.white,
                  ),
                  onTap: () {
                    setState(() {
                      if (!paused) {
                        paused = true;
                        advancedPlayer.pause();
                        _playSound(
                          advancedPlayer2,
                          'assets/sounds/pacman_intermission.wav',
                        );
                      } else {
                        paused = false;
                        advancedPlayer2.stop();
                        advancedPlayer.resume();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

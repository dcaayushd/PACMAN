import 'package:flutter/material.dart';
import 'package:pacman/constants.dart';
import 'package:pacman/pixel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 16;

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
                if (ConstantList.barriers.contains(index)) {
                  return Pixel(
                    innerColor: Colors.blue[900],
                    outerColor: Colors.blue[800],
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

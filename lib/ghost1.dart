import 'package:flutter/material.dart';

class Ghost1 extends StatelessWidget {
  const Ghost1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Image.asset('assets/images/ghost.png'),
    );
  }
}

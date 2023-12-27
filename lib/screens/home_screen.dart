import 'package:flutter/material.dart';

import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const GameScreen(),
            ),
          );
        },
        child: const Text('Start Game'),
      ),
    );
  }
}

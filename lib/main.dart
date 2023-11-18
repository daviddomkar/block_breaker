import 'package:block_breaker/screens/game_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BlockBreakerApp());
}

class BlockBreakerApp extends StatelessWidget {
  const BlockBreakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Block Breaker',
      home: GameScreen(),
    );
  }
}

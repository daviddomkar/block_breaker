import 'package:flutter/material.dart';

import '../core/engine/game_render_widget.dart';
import '../core/game/block_breaker_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameRenderWidget(
        game: BlockBreakerGame(),
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart' hide Image;

import '../core/engine/widgets/game_widget.dart';
import '../core/game/block_breaker_game.dart';

class GameScreen extends StatefulWidget {
  final Image cellTextureImage;

  final FragmentProgram gridShaderProgram;
  final FragmentProgram bloomShaderProgram;

  const GameScreen({
    super.key,
    required this.cellTextureImage,
    required this.gridShaderProgram,
    required this.bloomShaderProgram,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final BlockBreakerGame _game;

  @override
  void initState() {
    super.initState();

    _game = BlockBreakerGame(
      cellTextureImage: widget.cellTextureImage,
      gridShaderProgram: widget.gridShaderProgram,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: _game,
      ),
    );
  }
}

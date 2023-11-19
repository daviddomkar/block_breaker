import 'package:flutter/material.dart';

import '../core/engine/widgets/game_widget.dart';
import '../core/game/block_breaker_game.dart';
import '../services/asset_manager.dart';

class GameScreen extends StatefulWidget {
  final AssetManager assetManager;

  const GameScreen({
    super.key,
    required this.assetManager,
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
      assetManager: widget.assetManager,
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

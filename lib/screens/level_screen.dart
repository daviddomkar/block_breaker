import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../core/game/block_breaker_game.dart';
import '../core/game/game_state.dart';
import '../core/game/level.dart';
import '../theme.dart';

class LevelScreen extends StatefulWidget {
  final BlockBreakerGame game;

  const LevelScreen({super.key, required this.game});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  late final FocusNode _focusNode;

  BlockBreakerGame get _game => widget.game;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _game.loadLevel(levels.last);
    _game.startLevel(false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _game.notifyListeners();
    });
  }

  @override
  void dispose() {
    _game.reset();

    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) {
          if (event is KeyUpEvent &&
              event.logicalKey == LogicalKeyboardKey.escape) {
            if (_game.state == GameState.paused) {
              _game.resume();
            } else {
              _game.pause();
            }
          }
        },
        child: ListenableBuilder(
          listenable: widget.game,
          builder: (context, child) {
            if (_game.state case GameState.ready || GameState.playing) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Score: ${_game.score}',
                        style: context.textTheme.bodyLarge,
                      ),
                      Text(
                        'Lives: ${widget.game.lives}',
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              );
            }

            if (_game.state == GameState.paused) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Paused',
                    style: context.textTheme.displayMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Score: ${_game.score}',
                    style: context.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _game.resume();
                    },
                    child: const Text('Resume'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('Exit'),
                  ),
                  const SizedBox(
                    height: kPaddleBottomOffset +
                        kPaddleHeight +
                        kBallRadius * 2 +
                        20,
                  )
                ],
              );
            }

            if (_game.state == GameState.won) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'You Won!',
                    style: context.textTheme.displayMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Score: ${_game.score}',
                    style: context.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _game.loadLevel(levels.last);
                      _game.startLevel();
                    },
                    child: const Text('Play Again'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('Exit'),
                  ),
                  const SizedBox(
                    height: kPaddleBottomOffset +
                        kPaddleHeight +
                        kBallRadius * 2 +
                        20,
                  )
                ],
              );
            }

            if (_game.state == GameState.gameOver) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Game Over',
                    style: context.textTheme.displayMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Score: ${_game.score}',
                    style: context.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _game.loadLevel(levels.last);
                      _game.startLevel();
                    },
                    child: const Text('Try Again'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('Exit'),
                  ),
                  const SizedBox(
                    height: kPaddleBottomOffset +
                        kPaddleHeight +
                        kBallRadius * 2 +
                        20,
                  )
                ],
              );
            }

            throw 'Unhandled game state on level screen: ${_game.state}';
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../core/game/block_breaker_game.dart';
import '../core/game/game_state.dart';
import '../core/game/level.dart';
import '../services/progression_store.dart';
import '../theme.dart';
import '../widgets/block_button.dart';

class LevelScreen extends StatefulWidget {
  final ProgressionStore progressionStore;
  final BlockBreakerGame game;
  final int levelIndex;

  const LevelScreen({
    super.key,
    required this.progressionStore,
    required this.game,
    required this.levelIndex,
  });

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  late final FocusNode _focusNode;

  BlockBreakerGame get _game => widget.game;
  ProgressionStore get _progressionStore => widget.progressionStore;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _game.loadLevel(levels[widget.levelIndex]);
    _game.startLevel(false);

    // This needs to be called after the first frame to ensure that the
    // IgnorePointer widget locks the pointer.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _game.notifyListeners();
    });

    _progressionStore.updateLastPlayedLevelIndex(widget.levelIndex);

    _game.addListener(_onGameStateChanged);
  }

  void _onGameStateChanged() {
    if (_game.state == GameState.won) {
      if (_progressionStore.highestLevelIndex < widget.levelIndex + 1) {
        _progressionStore.updateHighestLevelIndex(widget.levelIndex + 1);
      }
    }
  }

  @override
  void dispose() {
    _game.removeListener(_onGameStateChanged);
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
                  Stack(
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
                  BlockButton(
                    onPressed: () {
                      _game.resume();
                    },
                    child: Text(
                      'Resume',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlockButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      'Exit',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: kSafeBottomOffset),
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
                  BlockButton(
                    onPressed: () {
                      context.pop();
                      context.push(
                        '/level/${widget.levelIndex + 2}',
                      );
                    },
                    child: Text(
                      'Next Level',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlockButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      'Exit',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: kSafeBottomOffset),
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
                  BlockButton(
                    onPressed: () {
                      _game.loadLevel(levels[widget.levelIndex]);
                      _game.startLevel();
                    },
                    child: Text(
                      'Try Again',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlockButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      'Exit',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: kSafeBottomOffset),
                ],
              );
            }

            return throw 'Invalid game state: ${_game.state}';
          },
        ),
      ),
    );
  }
}

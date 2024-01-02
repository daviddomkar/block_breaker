import 'package:flutter/material.dart';

import '../game.dart';
import '../mixins/pointer_listener.dart';
import 'game_render_widget.dart';

class GameWidget extends StatelessWidget {
  final Game game;

  const GameWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        if (game is PointerListener) {
          (game as PointerListener).onPointerDown(
            event.transformed(Matrix4.inverted(game.viewport.transform)),
          );
        }
      },
      onPointerUp: (event) {
        if (game is PointerListener) {
          (game as PointerListener).onPointerUp(
            event.transformed(Matrix4.inverted(game.viewport.transform)),
          );
        }
      },
      onPointerMove: (event) {
        if (game is PointerListener) {
          (game as PointerListener).onPointerMove(
            event.transformed(Matrix4.inverted(game.viewport.transform)),
          );
        }
      },
      onPointerHover: (event) {
        if (game is PointerListener) {
          (game as PointerListener).onPointerHover(
            event.transformed(Matrix4.inverted(game.viewport.transform)),
          );
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.none,
        child: GameRenderWidget(game: game),
      ),
    );
  }
}

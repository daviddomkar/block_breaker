import 'package:flutter/material.dart';

import '../game.dart';
import '../mixins/mouse_listener.dart';
import '../mixins/pointer_listener.dart';
import 'game_render_widget.dart';

class GameWidget extends StatelessWidget {
  final Game game;

  const GameWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (event) {
        if (game is PointerListener) {
          (game as PointerListener).onPointerMove(
            event.transformed(Matrix4.inverted(game.viewport.transform)),
          );
        }
      },
      child: MouseRegion(
        onHover: (event) {
          if (game is MouseListener) {
            (game as MouseListener).onMouseHover(
              event.transformed(Matrix4.inverted(game.viewport.transform)),
            );
          }
        },
        child: GameRenderWidget(game: game),
      ),
    );
  }
}

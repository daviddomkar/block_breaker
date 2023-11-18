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
          final viewport = game.viewport;

          if (!viewport.hasWidgetSize) return;

          final transform = viewport.computeViewportTransform();
          final inverse = Matrix4.inverted(transform);

          (game as PointerListener).onPointerMove(event.transformed(inverse));
        }
      },
      child: MouseRegion(
        onHover: (event) {
          if (game is MouseListener) {
            final viewport = game.viewport;

            if (!viewport.hasWidgetSize) return;

            final transform = viewport.computeViewportTransform();
            final inverse = Matrix4.inverted(transform);

            (game as MouseListener).onMouseHover(event.transformed(inverse));
          }
        },
        child: GameRenderWidget(game: game),
      ),
    );
  }
}

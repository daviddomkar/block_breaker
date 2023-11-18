import 'package:flutter/material.dart';

import '../game.dart';
import '../mixins/mouse_listener.dart';
import '../mixins/pointer_listener.dart';
import 'game_render_widget.dart';

class GameWidget extends StatefulWidget {
  final Game game;

  const GameWidget({super.key, required this.game});

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;

        return Listener(
          onPointerMove: (event) {
            if (widget.game is PointerListener) {
              (widget.game as PointerListener).onPointerMove(event, size);
            }
          },
          child: MouseRegion(
            onHover: (event) {
              if (widget.game is MouseListener) {
                (widget.game as MouseListener).onMouseHover(event, size);
              }
            },
            child: GameRenderWidget(game: widget.game),
          ),
        );
      },
    );
  }
}

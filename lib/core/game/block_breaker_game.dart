import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../engine/game.dart';
import '../engine/mixins/mouse_listener.dart';
import '../engine/mixins/pointer_listener.dart';
import '../engine/viewport.dart';

import '../game/entities/paddle.dart';

class BlockBreakerGame extends Game with MouseListener, PointerListener {
  late final Paddle _paddle;

  BlockBreakerGame()
      : super(
          viewport: Viewport(
            size: const Size(
              480,
              double.infinity,
            ),
            offset: const Offset(-240, 0),
            flipY: true,
          ),
        );

  @override
  void init() {
    _paddle = Paddle(
      viewport: viewport,
      x: 0,
      width: 128,
    );
  }

  @override
  void dispose() {}

  @override
  void onPointerMove(PointerMoveEvent event) =>
      _paddle.x = event.localPosition.dx;

  @override
  void onMouseHover(PointerHoverEvent event) =>
      _paddle.x = event.localPosition.dx;

  @override
  void update(double dt) {}

  @override
  void render(Canvas canvas) {
    canvas.drawColor(const Color(0xFF0E1D2F), BlendMode.clear);
    _paddle.render(canvas);
  }
}

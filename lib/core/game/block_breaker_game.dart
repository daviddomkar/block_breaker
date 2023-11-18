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
    _paddle = Paddle(x: 0, width: 128);
  }

  @override
  void dispose() {}

  @override
  void onPointerMove(PointerMoveEvent event) {
    _changePaddleX(event.localPosition.dx);
  }

  @override
  void onMouseHover(PointerHoverEvent event) {
    _changePaddleX(event.localPosition.dx);
  }

  _changePaddleX(double x) {
    _paddle.x = x.clamp(
      -viewport.size.width / 2 + _paddle.width / 2,
      viewport.size.width / 2 - _paddle.width / 2,
    );
  }

  @override
  void update(double dt) {}

  @override
  void render(Canvas canvas) {
    canvas.drawColor(const Color(0xFF000000), BlendMode.clear);
    _paddle.render(canvas, viewport.size);
  }
}

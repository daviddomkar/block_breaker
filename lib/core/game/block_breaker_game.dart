import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart';

import '../engine/game.dart';
import '../engine/mixins/mouse_listener.dart';
import '../engine/mixins/pointer_listener.dart';
import '../engine/viewport.dart';

import '../game/entities/paddle.dart';

class BlockBreakerGame extends Game with MouseListener, PointerListener {
  late final Viewport _viewport;

  late final Paddle _paddle;

  @override
  void init() {
    _viewport = Viewport(
      size: const Size(
        480,
        double.infinity,
      ),
      offset: const Offset(-240, 0),
      flipY: true,
    );

    _paddle = Paddle(x: 0, width: 128);
  }

  @override
  void dispose() {}

  @override
  void onPointerMove(PointerMoveEvent event, Size size) {
    final scaledPosition = _viewport.transformPoint(
      Vector2(event.localPosition.dx, event.localPosition.dy),
      size,
    );

    final scaledSize = _viewport.computeScaledSize(size);

    _changePaddleX(scaledPosition.x, scaledSize);
  }

  @override
  void onMouseHover(PointerHoverEvent event, Size size) {
    final scaledPosition = _viewport.transformPoint(
      Vector2(event.localPosition.dx, event.localPosition.dy),
      size,
    );

    final scaledSize = _viewport.computeScaledSize(size);

    _changePaddleX(scaledPosition.x, scaledSize);
  }

  _changePaddleX(double x, Size size) {
    _paddle.x = x.clamp(
      -size.width / 2 + _paddle.width / 2,
      size.width / 2 - _paddle.width / 2,
    );
  }

  @override
  void update(double dt) {}

  @override
  void render(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFF000000), BlendMode.clear);
    _viewport.render(canvas, size, (canvas, size) {
      _paddle.render(canvas, size);
    });
  }
}

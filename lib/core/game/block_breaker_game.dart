import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../engine/game.dart';
import '../engine/mixins/mouse_listener.dart';
import '../engine/mixins/pointer_listener.dart';
import '../engine/viewport.dart';

import '../game/entities/paddle.dart';

class BlockBreakerGame extends Game with MouseListener, PointerListener {
  final Image _cellTextureImage;
  final FragmentProgram _gridShaderProgram;

  late double _time;

  late final FragmentShader _gridShader;
  late final Paddle _paddle;

  BlockBreakerGame({
    required Image cellTextureImage,
    required FragmentProgram gridShaderProgram,
  })  : _cellTextureImage = cellTextureImage,
        _gridShaderProgram = gridShaderProgram,
        super(
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
    _time = 0;

    _gridShader = _gridShaderProgram.fragmentShader();
    _gridShader.setImageSampler(0, _cellTextureImage);

    _paddle = Paddle(
      viewport: viewport,
      x: 0,
      width: 128,
    );
  }

  @override
  void dispose() {
    _gridShader.dispose();
  }

  @override
  void onPointerMove(PointerMoveEvent event) =>
      _paddle.x = event.localPosition.dx;

  @override
  void onMouseHover(PointerHoverEvent event) =>
      _paddle.x = event.localPosition.dx;

  @override
  void update(double dt) {
    _time += dt;
    _gridShader.setFloat(2, _time);
  }

  @override
  void render(Canvas canvas) {
    _gridShader.setFloat(0, viewport.size.width);
    _gridShader.setFloat(1, viewport.size.height);

    canvas.drawPaint(Paint()..shader = _gridShader);

    _paddle.render(canvas);
  }
}

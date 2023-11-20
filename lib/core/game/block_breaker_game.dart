import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../../services/asset_manager.dart';
import '../engine/game.dart';
import '../engine/mixins/mouse_listener.dart';
import '../engine/mixins/pointer_listener.dart';
import '../engine/viewport.dart';

import '../game/entities/paddle.dart';
import 'entities/board.dart';

class BlockBreakerGame extends Game with MouseListener, PointerListener {
  final AssetManager _assetManager;

  late double _time;

  late final FragmentShader _gridShader;
  late final Board _board;
  late final Paddle _paddle;

  BlockBreakerGame({
    required AssetManager assetManager,
  })  : _assetManager = assetManager,
        super(
          viewport: Viewport(
            minSize: const Size(480, 960),
            maxSize: const Size(double.infinity, double.infinity),
            origin: const Offset(-0.5, 0),
          ),
        );

  @override
  void init() {
    _time = 0;

    _gridShader = _assetManager.gridShaderProgram.fragmentShader();
    _gridShader.setImageSampler(0, _assetManager.boardGridCellImage);
    _gridShader.setFloat(0, 8);

    _board = Board(
      assetManager: _assetManager,
      viewport: viewport,
      size: const Size(480, 800),
    );

    _paddle = Paddle(
      board: _board,
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
    _gridShader.setFloat(1, viewport.minSize.width);

    canvas.drawPaint(Paint()..shader = _gridShader);

    _board.render(canvas);
    _paddle.render(canvas);
  }
}

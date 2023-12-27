import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../../services/asset_manager.dart';
import '../engine/game.dart';
import '../engine/mixins/mouse_listener.dart';
import '../engine/mixins/pointer_listener.dart';
import '../engine/viewport.dart';

import '../game/entities/paddle.dart';
import 'entities/ball.dart';
import 'entities/block.dart';
import 'game_state.dart';
import 'entities/board.dart';

class BlockBreakerGame extends Game with MouseListener, PointerListener {
  final AssetManager _assetManager;

  late GameState _state;
  late double _time;

  late final FragmentShader _gridShader;
  late final Board _board;
  late final Paddle _paddle;
  late final Ball _ball;

  BlockBreakerGame({
    required AssetManager assetManager,
  })  : _assetManager = assetManager,
        super(
          viewport: Viewport(
            minSize: kViewportSize,
            maxSize: const Size(double.infinity, double.infinity),
            origin: const Offset(-0.5, 0),
          ),
        );

  @override
  void init() {
    _state = GameState.notStarted;
    _time = 0;

    _gridShader = _assetManager.gridShaderProgram.fragmentShader();
    _gridShader.setImageSampler(0, _assetManager.boardGridCellImage);
    _gridShader.setFloat(0, 8);

    _board = Board(
      assetManager: _assetManager,
      viewport: viewport,
      size: kBoardSize,
    );

    _paddle = Paddle(
      assetManager: _assetManager,
      board: _board,
      x: 0,
      width: 96,
    );

    _ball = Ball(
      board: _board,
      radius: kBallRadius,
      speed: 256,
      x: 0,
      y: _board.innerBounds.bottom -
          kPaddleBottomOffset -
          kPaddleHeight / 2 -
          kBallRadius,
    );
  }

  @override
  void dispose() {
    _gridShader.dispose();
  }

  @override
  void onPointerMove(PointerMoveEvent event) => _processInput(event);

  @override
  void onMouseHover(PointerHoverEvent event) => _processInput(event);

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
    _ball.render(canvas);

    const columnCount = 5;

    for (int i = 0; i < BlockType.values.length * 5; i++) {
      for (int j = 0; j < columnCount; j++) {
        Block(
          assetManager: _assetManager,
          type: BlockType.values[i % BlockType.values.length],
          x: (columnCount.isEven ? kBlockSize.width / 2 : 0) +
              kBlockSize.width * (j - (columnCount ~/ 2)),
          y: _board.innerBounds.top +
              kBlockSize.height / 2 +
              32 +
              kBlockSize.height * i,
        ).render(canvas);
      }
    }

    canvas.saveLayer(null, Paint()..blendMode = BlendMode.multiply);

    canvas.drawRect(
      Rect.fromLTWH(
        -viewport.size.width / 2,
        0,
        viewport.size.width,
        viewport.size.height,
      ),
      Paint()..color = const Color(0xFF666666),
    );

    canvas.saveLayer(null, Paint()..blendMode = BlendMode.xor);

    canvas.drawRect(
      _board.outerBounds,
      Paint(),
    );

    canvas.restore();

    canvas.restore();
  }

  void _processInput(PointerEvent event) {
    if (_state case GameState.ready || GameState.playing) {
      _paddle.x += event.localDelta.dx;
    }

    if (_state == GameState.ready) {}
  }
}

import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:forge2d/forge2d.dart';

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
  final World _world;
  final List<Block> _blocks;
  final List<Block> _blocksToDispose;

  late GameState _state;
  late double _time;
  late int _lives;

  late final FragmentShader _gridShader;
  late final Board _board;
  late final Paddle _paddle;
  late final Ball _ball;

  BlockBreakerGame({
    required AssetManager assetManager,
  })  : _assetManager = assetManager,
        _world = World(),
        _blocks = [],
        _blocksToDispose = [],
        _state = GameState.notStarted,
        _time = 0,
        _lives = 3,
        super(
          viewport: Viewport(
            minSize: kViewportSize,
            maxSize: const Size(double.infinity, double.infinity),
            origin: const Offset(-0.5, -0.5),
          ),
        ) {
    _board = Board(
      assetManager: _assetManager,
      world: _world,
      viewport: viewport,
      size: kBoardSize,
    );

    _paddle = Paddle(
      assetManager: _assetManager,
      world: _world,
      board: _board,
      x: 0,
      width: 96,
    );

    _ball = Ball(
      world: _world,
      board: _board,
      radius: kBallRadius,
      force: 960,
      x: 0,
      y: _board.innerBounds.bottom -
          kPaddleBottomOffset -
          kPaddleHeight -
          kBallRadius,
    );

    const columnCount = 5;

    for (int i = 0; i < BlockType.values.length * 5; i++) {
      for (int j = 0; j < columnCount; j++) {
        final block = Block(
          assetManager: _assetManager,
          onDestroy: _scheduleBlockDisposal,
          world: _world,
          type: BlockType.values[i % BlockType.values.length],
          x: (columnCount.isEven ? kBlockSize.width / 2 : 0) +
              kBlockSize.width * (j - (columnCount ~/ 2)),
          y: _board.innerBounds.top +
              kBlockSize.height / 2 +
              32 +
              kBlockSize.height * i,
        );

        _blocks.add(block);
      }
    }

    _world.contactManager.contactListener = BlockBreakerContactListener();
  }

  @override
  void init() {
    _gridShader = _assetManager.gridShaderProgram.fragmentShader();
    _gridShader.setImageSampler(0, _assetManager.boardGridCellImage);
    _gridShader.setFloat(0, 8);
  }

  @override
  void dispose() {
    super.dispose();
    _gridShader.dispose();
  }

  @override
  void onPointerUp(PointerUpEvent event) {
    if (_state == GameState.ready) {
      _ball.fire();
      _state = GameState.playing;
    }
  }

  @override
  void onPointerMove(PointerMoveEvent event) => _processMoveInput(event);

  @override
  void onMouseHover(PointerHoverEvent event) => _processMoveInput(event);

  @override
  void update(double dt) {
    _time += dt;
    _gridShader.setFloat(2, _time);

    for (var block in _blocksToDispose) {
      _blocks.remove(block);
      block.dispose();
    }

    _world.stepDt(dt);

    if (_state == GameState.playing) {
      if (_blocks.isEmpty) {
        _won();
      } else if (_ball.y - kBallRadius > _board.innerBounds.bottom) {
        if (_lives > 0) {
          _revive();
        } else {
          _gameOver();
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    _gridShader.setFloat(1, viewport.minSize.width);

    canvas.drawPaint(Paint()..shader = _gridShader);

    for (var block in _blocks) {
      block.render(canvas);
    }

    _ball.render(canvas);
    _board.render(canvas);
    _paddle.render(canvas);

    canvas.saveLayer(null, Paint()..blendMode = BlendMode.multiply);

    canvas.drawRect(
      Rect.fromLTWH(
        -viewport.size.width / 2,
        -viewport.size.height / 2,
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

  GameState get state => _state;

  void _processMoveInput(PointerEvent event) {
    if (_state case GameState.ready || GameState.playing) {
      _paddle.x += event.localDelta.dx;

      if (_state == GameState.ready) {
        _ball.x = _paddle.x;
      }
    }
  }

  void _scheduleBlockDisposal(Block block) {
    _blocksToDispose.add(block);
  }

  void _won() {
    _state = GameState.won;

    _ball.x = 0;
    _ball.y = _board.innerBounds.bottom -
        kPaddleBottomOffset -
        kPaddleHeight -
        kBallRadius;

    _paddle.x = 0;

    notifyListeners();
  }

  void _revive() {
    _lives--;
    _state = GameState.ready;

    _ball.x = 0;
    _ball.y = _board.innerBounds.bottom -
        kPaddleBottomOffset -
        kPaddleHeight -
        kBallRadius;

    _paddle.x = 0;

    notifyListeners();
  }

  void _gameOver() {
    _state = GameState.gameOver;

    _ball.x = 0;
    _ball.y = _board.innerBounds.bottom -
        kPaddleBottomOffset -
        kPaddleHeight -
        kBallRadius;

    _paddle.x = 0;

    notifyListeners();
  }
}

class BlockBreakerContactListener extends ContactListener {
  @override
  void endContact(Contact contact) {
    super.endContact(contact);

    final userDataA = contact.fixtureA.body.userData;
    final userDataB = contact.fixtureB.body.userData;

    if (userDataA is Ball && userDataB is Block) {
      userDataB.destroy();
    } else if (userDataA is Block && userDataB is Ball) {
      userDataA.destroy();
    }
  }
}

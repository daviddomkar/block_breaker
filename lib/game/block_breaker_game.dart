import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:forge2d/forge2d.dart';

import '../constants.dart';
import '../services/asset_manager.dart';
import '../engine/game.dart';
import '../engine/mixins/pointer_listener.dart';
import '../engine/viewport.dart';

import '../game/entities/paddle.dart';
import 'entities/ball.dart';
import 'entities/block.dart';
import 'game_state.dart';
import 'entities/board.dart';
import 'level.dart';

class BlockBreakerGame extends Game with PointerListener {
  final AssetManager _assetManager;
  final World _world;
  final List<Block> _blocks;
  final List<Block> _blocksToDispose;

  GameState _state;
  double _time;
  int _lives;
  int _score;

  GameState? _stateBeforePause;

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
        _score = 0,
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

    _world.contactManager.contactListener = BlockBreakerContactListener(
      onBlockDestroyed: (score) {
        _score += score;
        notifyListeners();
      },
    );
  }

  @override
  void init() {
    _gridShader = _assetManager.gridShaderProgram.fragmentShader();
    _gridShader.setImageSampler(0, _assetManager.boardGridCellImage);
    _gridShader.setFloat(0, 8);
  }

  @override
  void dispose() {
    _gridShader.dispose();

    for (var block in _blocks) {
      _scheduleBlockDisposal(block);
    }

    for (var block in _blocksToDispose) {
      _blocks.remove(block);
      block.dispose();
    }

    _board.dispose();
    _paddle.dispose();
    _ball.dispose();

    super.dispose();
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
  void onPointerHover(PointerHoverEvent event) {
    if (defaultTargetPlatform
        case TargetPlatform.android || TargetPlatform.iOS) {
      return;
    }

    _processMoveInput(event);
  }

  @override
  void update(double dt) {
    _time += dt;
    _gridShader.setFloat(2, _time);

    for (var block in _blocksToDispose) {
      _blocks.remove(block);
      block.dispose();
    }

    if (_state != GameState.paused) {
      _world.stepDt(dt);
    }

    if (_state == GameState.playing) {
      if (_blocks.every((block) => block.type == BlockTier.grey)) {
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

  void loadLevel(Level level) {
    for (var block in _blocks) {
      _scheduleBlockDisposal(block);
    }

    for (var block in _blocksToDispose) {
      _blocks.remove(block);
      block.dispose();
    }

    for (int i = 0; i < level.height; i++) {
      for (int j = 0; j < level.width; j++) {
        if (level.data[i][j] == E) {
          continue;
        }

        final block = Block(
          assetManager: _assetManager,
          onDestroy: _scheduleBlockDisposal,
          world: _world,
          tier: BlockTier.values[level.data[i][j]],
          x: (level.width.isEven ? kBlockSize.width / 2 : 0) +
              kBlockSize.width * (j - (level.width ~/ 2)),
          y: _board.innerBounds.top +
              kBlockSize.height / 2 +
              64 +
              kBlockSize.height * i,
        );

        _blocks.add(block);
      }
    }
  }

  void startLevel([notify = true]) {
    _state = GameState.ready;
    _lives = 3;
    _score = 0;

    _resetEntityPositions();

    if (notify) {
      notifyListeners();
    }
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  void pause() {
    if (_state != GameState.playing && _state != GameState.ready) {
      return;
    }

    _stateBeforePause = _state;
    _state = GameState.paused;
    notifyListeners();
  }

  void resume() {
    if (_state != GameState.paused) {
      return;
    }

    if (_stateBeforePause == null) {
      throw StateError('Cannot resume game without a previous state');
    }

    _state = _stateBeforePause!;
    notifyListeners();
  }

  void reset([notify = true]) {
    for (final block in _blocks) {
      _scheduleBlockDisposal(block);
    }

    for (final block in _blocksToDispose) {
      _blocks.remove(block);
      block.dispose();
    }

    _resetEntityPositions();

    _state = GameState.notStarted;
    _stateBeforePause = null;
    _lives = 3;
    _score = 0;

    if (notify) {
      notifyListeners();
    }
  }

  GameState get state => _state;
  int get lives => _lives;
  int get score => _score;

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

    _resetEntityPositions();

    notifyListeners();
  }

  void _revive() {
    _lives--;
    _state = GameState.ready;

    _resetEntityPositions();

    notifyListeners();
  }

  void _gameOver() {
    _state = GameState.gameOver;

    _resetEntityPositions();

    notifyListeners();
  }

  void _resetEntityPositions() {
    _ball.x = 0;
    _ball.y = _board.innerBounds.bottom -
        kPaddleBottomOffset -
        kPaddleHeight -
        kBallRadius;

    _paddle.x = 0;
  }
}

class BlockBreakerContactListener extends ContactListener {
  final void Function(int) _onBlockDestroyed;

  BlockBreakerContactListener({
    required void Function(int) onBlockDestroyed,
  }) : _onBlockDestroyed = onBlockDestroyed;

  @override
  void endContact(Contact contact) {
    super.endContact(contact);

    final userDataA = contact.fixtureA.body.userData;
    final userDataB = contact.fixtureB.body.userData;

    if (userDataA is Ball && userDataB is Block) {
      _onBlockDestroyed(userDataB.destroy());
    } else if (userDataA is Block && userDataB is Ball) {
      _onBlockDestroyed(userDataA.destroy());
    }
  }
}

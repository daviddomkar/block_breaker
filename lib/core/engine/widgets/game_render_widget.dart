import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../game.dart';
import '../game_loop.dart';

class GameRenderWidget extends LeafRenderObjectWidget {
  final Game game;

  const GameRenderWidget({
    super.key,
    required this.game,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return GameRenderObject(
      game: game,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    GameRenderObject renderObject,
  ) {
    renderObject.game = game;
  }
}

class GameRenderObject extends RenderBox with WidgetsBindingObserver {
  Game _game;

  GameLoop? _gameLoop;

  GameRenderObject({
    required Game game,
  }) : _game = game;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _attachGame();
  }

  @override
  void detach() {
    _detachGame();
    super.detach();
  }

  @override
  void performResize() {
    super.performResize();

    if (_game.viewport.widgetSize == null) {
      _game.viewport.notifyWidgetPerformedResize(size);
      _game.init();
    } else {
      _game.viewport.notifyWidgetPerformedResize(size);
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    context.canvas.translate(offset.dx, offset.dy);

    final transform = game.viewport.computeViewportTransform();

    context.canvas.save();
    context.canvas.transform(transform.storage);

    game.render(context.canvas);

    context.canvas.restore();
    context.canvas.restore();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (attached) {
      switch (state) {
        case AppLifecycleState.resumed:
          _gameLoop?.start();
          break;
        case AppLifecycleState.detached:
        case AppLifecycleState.hidden:
          _gameLoop?.stop();
        default:
          break;
      }
    }
  }

  @override
  bool get sizedByParent => true;

  void _attachGame() {
    final gameLoop = _gameLoop = GameLoop(onUpdate: _onUpdate);
    gameLoop.start();

    _bindLifecycleListener();
  }

  void _detachGame() {
    _unbindLifecycleListener();

    _game.dispose();

    _gameLoop?.dispose();
    _gameLoop = null;
  }

  void _onUpdate(double dt) {
    _game.update(dt);
    markNeedsPaint();
  }

  void _bindLifecycleListener() {
    WidgetsBinding.instance.addObserver(this);
  }

  void _unbindLifecycleListener() {
    WidgetsBinding.instance.removeObserver(this);
  }

  set game(Game game) {
    if (_game == game) {
      return;
    }

    if (attached) {
      _detachGame();
    }

    _game = game;

    if (attached) {
      _attachGame();
    }

    _game = game;
  }

  Game get game => _game;
}

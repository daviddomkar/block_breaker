import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'game.dart';

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

class GameRenderObject extends RenderBox {
  Game _game;

  Ticker? _ticker;
  Duration? _previous;

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
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    context.canvas.translate(offset.dx, offset.dy);
    game.render(context.canvas, size);
    context.canvas.restore();
  }

  @override
  bool get sizedByParent => true;

  void _attachGame() {
    _game.init();

    _previous = Duration.zero;
    final ticker = _ticker = Ticker(_tick);

    if (!ticker.isActive) {
      ticker.start();
    }
  }

  void _detachGame() {
    _ticker?.dispose();

    _ticker = null;
    _previous = null;

    _game.dispose();
  }

  void _tick(Duration duration) {
    if (!attached) {
      return;
    }

    final durationDelta = duration - (_previous ?? Duration.zero);
    final dt = durationDelta.inMicroseconds / Duration.microsecondsPerSecond;
    _previous = duration;

    _game.update(dt);

    markNeedsPaint();
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

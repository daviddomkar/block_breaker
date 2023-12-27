import 'dart:ui';

import 'package:forge2d/forge2d.dart';

import '../../../constants.dart';
import '../../../services/asset_manager.dart';
import 'board.dart';

class Paddle {
  final AssetManager _assetManager;
  final Board _board;

  late final Body _body;
  late final double _width;

  Paddle({
    required AssetManager assetManager,
    required World world,
    required Board board,
    required double x,
    required double width,
  })  : _assetManager = assetManager,
        _board = board {
    final shape = PolygonShape()
      ..setAsBoxXY(
        width / 2 * 0.1,
        kPaddleHeight / 2 * 0.1,
      );

    final fixtureDef = FixtureDef(shape, restitution: 1.0);

    final bodyDef = BodyDef(
      position: Vector2(
          0,
          (-kPaddleHeight / 2 +
                  _board.innerBounds.bottom -
                  kPaddleBottomOffset) *
              0.1),
      type: BodyType.kinematic,
    );

    _width = width * 0.1;

    _body = world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  set x(double x) {
    x = (x * 0.1).clamp(
      -_board.innerBounds.width / 2 * 0.1 + _width / 2,
      _board.innerBounds.width / 2 * 0.1 - _width / 2,
    );

    _body.setTransform(Vector2(x, _body.position.y), _body.angle);
  }

  double get x => _body.position.x * 10;

  void render(Canvas canvas) {
    _assetManager.paddleTexture.render(
      canvas,
      Rect.fromLTWH(
        _body.position.x * 10 - _width / 2 * 10,
        _body.position.y * 10 - kPaddleHeight / 2,
        _width * 10,
        kPaddleHeight,
      ),
    );
  }
}

import 'dart:ui';

import 'package:forge2d/forge2d.dart';

import 'board.dart';

class Ball {
  final Board _board;

  final double _force;

  late final Body _body;

  Ball({
    required World world,
    required Board board,
    required double radius,
    required double force,
    required double x,
    required double y,
  })  : _board = board,
        _force = force * 0.1 {
    final shape = CircleShape()..radius = radius * 0.1;

    final fixtureDef = FixtureDef(shape);

    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(x * 0.1, y * 0.1),
      type: BodyType.dynamic,
    );

    _body = world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  set x(double x) {
    x = (x * 0.1).clamp(
      -_board.innerBounds.width / 2 * 0.1 + _body.fixtures.first.shape.radius,
      _board.innerBounds.width / 2 * 0.1 - _body.fixtures.first.shape.radius,
    );

    _body.setTransform(Vector2(x, _body.position.y), _body.angle);
    _body.linearVelocity = Vector2.zero();
  }

  set y(double y) {
    y = (y * 0.1).clamp(
      -_board.innerBounds.height / 2 * 0.1 + _body.fixtures.first.shape.radius,
      _board.innerBounds.height / 2 * 0.1 - _body.fixtures.first.shape.radius,
    );

    _body.setTransform(Vector2(_body.position.x, y), _body.angle);
    _body.linearVelocity = Vector2.zero();
  }

  double get y => _body.position.y * 10;

  void fire() {
    _body.applyLinearImpulse(
      Vector2(_body.position.x < 0 ? _force : -_force, -_force),
    );
  }

  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset(_body.position.x * 10, _body.position.y * 10),
      _body.fixtures.first.shape.radius * 10,
      Paint()..color = const Color(0xFFFFFFFF),
    );
  }
}

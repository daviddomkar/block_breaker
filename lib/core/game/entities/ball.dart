import 'dart:ui';

import 'board.dart';

class Ball {
  final Board _board;

  final double _radius;
  final double _speed;

  double _x;
  double _y;

  Ball({
    required Board board,
    required double radius,
    required double speed,
    required double x,
    required double y,
  })  : _board = board,
        _radius = radius,
        _speed = speed,
        _x = x,
        _y = y;

  set x(double x) {
    _x = x.clamp(
      -_board.innerBounds.width / 2 + _radius,
      _board.innerBounds.width / 2 - _radius,
    );
  }

  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset(_x, _y),
      _radius,
      Paint()..color = const Color(0xFFFFFFFF),
    );
  }
}

import 'dart:ui';

import 'board.dart';

const _kPaddleHeight = 32.0;
const _kPaddleBottomOffset = 64.0;

class Paddle {
  final Board _board;

  double _x;
  final double _width;

  Paddle({
    required Board board,
    required double x,
    required double width,
  })  : _board = board,
        _x = x,
        _width = width;

  set x(double x) {
    _x = x.clamp(
      -_board.innerBounds.width / 2 + _width / 2,
      _board.innerBounds.width / 2 - _width / 2,
    );
  }

  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(
        -_width / 2 + _x,
        -_kPaddleHeight / 2 + _board.innerBounds.bottom - _kPaddleBottomOffset,
        _width,
        _kPaddleHeight,
      ),
      Paint()..color = const Color(0xFFFA6AA6),
    );
  }
}

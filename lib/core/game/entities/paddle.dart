import 'dart:ui';

import '../../engine/viewport.dart';

const _kPaddleHeight = 32.0;
const _kPaddleBottomOffset = 64.0;

class Paddle {
  final Viewport _viewport;

  double _x;
  final double _width;

  Paddle({
    required Viewport viewport,
    required double x,
    required double width,
  })  : _viewport = viewport,
        _x = x,
        _width = width;

  set x(double x) {
    _x = x.clamp(
      -_viewport.size.width / 2 + _width / 2,
      _viewport.size.width / 2 - _width / 2,
    );
  }

  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(
        -_width / 2 + _x,
        -_kPaddleHeight / 2 + _kPaddleBottomOffset,
        _width,
        _kPaddleHeight,
      ),
      Paint()..color = const Color(0xFFFA6AA6),
    );
  }
}

import 'package:flutter/material.dart';

const _kPaddleHeight = 32.0;
const _kPaddleBottomOffset = 64.0;

class Paddle {
  double _x;
  final double _width;

  Paddle({
    required double x,
    required double width,
  })  : _x = x,
        _width = width;

  set x(double x) => _x = x;

  void render(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(
        -_width / 2 + _x,
        -_kPaddleHeight / 2 + _kPaddleBottomOffset,
        _width,
        _kPaddleHeight,
      ),
      Paint()..color = const Color(0xFFFF0000),
    );
  }

  double get width => _width;
}

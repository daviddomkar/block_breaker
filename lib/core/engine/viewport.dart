import 'dart:ui';
import 'package:vector_math/vector_math_64.dart';

class Viewport {
  final Size _size;

  Viewport({
    required Size size,
  }) : _size = size;

  void render(Canvas canvas, Size size, void Function(Canvas, Size) render) {
    final scale = switch (_size) {
      Size(width: var width, height: var height)
          when width != double.infinity && height != double.infinity =>
        Vector2(size.width / width, size.height / height),
      Size(width: var width, height: var height)
          when width == double.infinity && height != double.infinity =>
        Vector2(size.height / height, size.height / height),
      Size(width: var width, height: var height)
          when width != double.infinity && height == double.infinity =>
        Vector2(size.width / width, size.width / width),
      _ => Vector2.all(1.0),
    };

    canvas.save();
    canvas.scale(scale.x, scale.y);

    render(canvas, Size(size.width / scale.x, size.height / scale.y));

    canvas.restore();
  }

  Size get size => _size;
}

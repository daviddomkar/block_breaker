import 'dart:ui';
import 'package:vector_math/vector_math_64.dart';

class Viewport {
  final Size _size;
  final Offset _offset;
  final bool _flipY;

  Viewport({
    required Size size,
    Offset offset = Offset.zero,
    bool flipY = false,
  })  : _size = size,
        _offset = offset,
        _flipY = flipY;

  void render(Canvas canvas, Size size, void Function(Canvas, Size) render) {
    final transform = computeViewportTransformForSize(size);

    canvas.save();
    canvas.transform(transform.storage);

    final scaledSize = computeScaledSize(size);
    render(canvas, scaledSize);

    canvas.restore();
  }

  Vector2 computeScaleForSize(Size size) {
    return switch (_size) {
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
  }

  Size computeScaledSize(Size size) {
    final scale = computeScaleForSize(size);
    return Size(size.width / scale.x, size.height / scale.y);
  }

  Matrix4 computeViewportTransformForSize(Size size) {
    final scale = computeScaleForSize(size);
    final scaledSize = Size(size.width / scale.x, size.height / scale.y);

    final transform = Matrix4.identity();
    transform.scale(scale.x, scale.y);

    if (_flipY) {
      transform.translate(-_offset.dx, -_offset.dy + scaledSize.height);
      transform.scale(1.0, -1.0);
    } else {
      transform.translate(-_offset.dx, -_offset.dy);
    }

    return transform;
  }

  Vector2 transformPoint(Vector2 point, Size size) {
    final transform = computeViewportTransformForSize(size);
    final inverse = Matrix4.inverted(transform);
    final transformed = inverse.transform3(Vector3(point.x, point.y, 0.0));

    return Vector2(transformed.x, transformed.y);
  }
}

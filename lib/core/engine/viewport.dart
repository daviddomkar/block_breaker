import 'dart:math';
import 'dart:ui';
import 'package:vector_math/vector_math_64.dart';

class Viewport {
  final Offset _origin;
  final Size _minSize;
  final Size _maxSize;

  Size? _widgetSize;

  late Size _scaledSize;
  late Matrix4 _transform;

  Viewport({
    required Size minSize,
    required Size maxSize,
    Offset origin = Offset.zero,
  })  : _minSize = minSize,
        _maxSize = maxSize,
        _origin = origin;

  void notifyWidgetPerformedResize(Size size) {
    _widgetSize = size;

    final scale = switch (_minSize) {
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

    _scaledSize = Size(size.width / scale.x, size.height / scale.y);

    final transform = Matrix4.identity();
    transform.scale(scale.x, scale.y);

    transform.translate(
      -_origin.dx * _scaledSize.width,
      -_origin.dy * _scaledSize.height,
    );

    _transform = transform;
  }

  Size get size => _scaledSize;

  Size? get widgetSize => _widgetSize;

  Matrix4 get transform => _transform;
}

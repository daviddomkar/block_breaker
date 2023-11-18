import 'dart:ui';
import 'package:vector_math/vector_math_64.dart';

class Viewport {
  final Offset _offset;
  final bool _flipY;
  final Size _size;

  Size? _widgetSize;

  late Size _scaledSize;
  late Matrix4 _transform;

  Viewport({
    required Size size,
    Offset offset = Offset.zero,
    bool flipY = false,
  })  : _size = size,
        _offset = offset,
        _flipY = flipY;

  void notifyWidgetPerformedResize(Size size) {
    _widgetSize = size;

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

    _scaledSize = Size(size.width / scale.x, size.height / scale.y);

    final transform = Matrix4.identity();
    transform.scale(scale.x, scale.y);

    if (_flipY) {
      final scaledSize = Size(
        size.width / scale.x,
        size.height / scale.y,
      );
      transform.translate(-_offset.dx, -_offset.dy + scaledSize.height);
      transform.scale(1.0, -1.0);
    } else {
      transform.translate(-_offset.dx, -_offset.dy);
    }

    _transform = transform;
  }

  Size get size => _scaledSize;

  Size? get widgetSize => _widgetSize;

  Matrix4 get transform => _transform;
}

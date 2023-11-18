import 'dart:ui';
import 'package:vector_math/vector_math_64.dart';

class Viewport {
  final Offset _offset;
  final bool _flipY;

  final Size _size;
  Size? _widgetSize;

  Viewport({
    required Size size,
    Offset offset = Offset.zero,
    bool flipY = false,
  })  : _size = size,
        _offset = offset,
        _flipY = flipY;

  void render(Canvas canvas, void Function(Canvas, Size) render) {
    final transform = computeViewportTransform();

    canvas.save();
    canvas.transform(transform.storage);

    final scaledSize = computeScaledSize();
    render(canvas, scaledSize);

    canvas.restore();
  }

  Vector2 computeScale() {
    assert(_widgetSize != null);
    final size = _widgetSize!;

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

  Size computeScaledSize() {
    assert(_widgetSize != null);
    final size = _widgetSize!;

    final scale = computeScale();
    return Size(size.width / scale.x, size.height / scale.y);
  }

  Matrix4 computeViewportTransform() {
    assert(_widgetSize != null);
    final size = _widgetSize!;

    final scale = computeScale();

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

    return transform;
  }

  Offset transformOffset(Offset offset) {
    final transform = computeViewportTransform();
    final inverse = Matrix4.inverted(transform);
    final transformed = inverse.transform3(Vector3(offset.dx, offset.dy, 0.0));

    return Offset(transformed.x, transformed.y);
  }

  void notifyWidgetPerformedResize(Size size) {
    _widgetSize = size;
  }

  Size get size => computeScaledSize();

  bool get hasWidgetSize => _widgetSize != null;
  Size? get widgetSize => _widgetSize;
}

import 'dart:ui';
import 'package:vector_math/vector_math_64.dart';

class Viewport {
  final Offset _origin;
  final Size _minSize;
  final Size _maxSize;

  Size? _widgetSize;

  late Size _scaledMinSize;
  late Size _scaledSize;
  late Matrix4 _transform;

  Viewport({
    required Size minSize,
    Size? maxSize,
    Offset origin = Offset.zero,
  })  : _minSize = minSize,
        _maxSize = maxSize ?? minSize,
        _origin = origin;

  void notifyWidgetPerformedResize(Size size) {
    _widgetSize = size;

    final minScale = switch (_minSize) {
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

    _scaledMinSize = Size(size.width / minScale.x, size.height / minScale.y);

    final maxScale = switch (_maxSize) {
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

    final maxSize = Size(size.width / maxScale.x, size.height / maxScale.y);

    final viewportMinAspectRatio = _scaledMinSize.width / _scaledMinSize.height;
    final viewportMaxAspectRatio = maxSize.width / maxSize.height;

    if (viewportMinAspectRatio > viewportMaxAspectRatio) {
      minScale.y = minScale.x;
    } else if (viewportMinAspectRatio < viewportMaxAspectRatio) {
      minScale.x = minScale.y;
    }

    _scaledSize = Size(size.width / minScale.x, size.height / minScale.y);

    final transform = Matrix4.identity();
    transform.scale(minScale.x, minScale.y);

    transform.translate(
      -_origin.dx * _scaledSize.width,
      -_origin.dy * _scaledSize.height,
    );

    _transform = transform;
  }

  Size get minSize => _scaledMinSize;
  Size get size => _scaledSize;

  Size? get widgetSize => _widgetSize;

  Matrix4 get transform => _transform;
}

import 'dart:ui';

import '../../services/asset_manager.dart';

class NinePatchTexture {
  static final _paint = Paint()
    ..filterQuality = FilterQuality.high
    ..isAntiAlias = true;

  final Image _image;
  final Rect _center;
  final double _scale;

  static Future<NinePatchTexture> load(
    String assetPath, {
    required Rect center,
    double? scale,
  }) async {
    final image = await AssetManager.loadImage(assetPath);

    return NinePatchTexture(
      image: image,
      center: center,
      scale: scale,
    );
  }

  NinePatchTexture({
    required Image image,
    required Rect center,
    double? scale,
  })  : _image = image,
        _center = center,
        _scale = scale ?? 1.0;

  void render(Canvas canvas, Rect rect) {
    canvas.save();

    canvas.scale(1 / _scale);

    canvas.drawImageNine(
      _image,
      _center,
      Rect.fromLTWH(
        rect.left * _scale,
        rect.top * _scale,
        rect.width * _scale,
        rect.height * _scale,
      ),
      _paint,
    );

    canvas.restore();
  }
}

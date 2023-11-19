import 'dart:ui';

import '../../../services/asset_manager.dart';
import '../../engine/viewport.dart';

class Board {
  final AssetManager _assetManager;
  final Viewport _viewport;
  final Size _size;

  Board({
    required AssetManager assetManager,
    required Viewport viewport,
    required Size size,
  })  : _assetManager = assetManager,
        _viewport = viewport,
        _size = size;

  void render(Canvas canvas) {
/*
    canvas.drawRect(
      Rect.fromLTWH(
        -_viewport.size.width / 2 + 32,
        -_viewport.size.width / 2 + 32,
        width,
        height,
      ),
      Paint()..color = const Color(0xFFFA6AA6),
    );
*/

    canvas.save();

    final targetImageRect = Rect.fromLTWH(
      -_size.width / 2 * 3,
      0 * 3,
      _size.width * 3,
      (_viewport.size.height - _size.height) / 2 * 3,
    );

    final imageNineRect = const Rect.fromLTWH(
      222 * 3,
      6 * 3,
      64 * 3,
      8 * 3,
    );

    canvas.scale(1 / 3);

    canvas.drawImageNine(
      _assetManager.boardWallTopImage,
      imageNineRect,
      targetImageRect,
      Paint()
        ..filterQuality = FilterQuality.high
        ..isAntiAlias = true,
    );

    canvas.restore();
/*
    canvas.drawRect(
      imageNineRect,
      Paint()..color = const Color(0xFFFF0000),
    );
    */

    canvas.drawRect(
      innerBounds,
      Paint()..color = const Color(0x44FA6AA6),
    );
  }

  Rect get innerBounds {
    return Rect.fromLTWH(
      -_size.width / 2 + 32,
      (_viewport.size.height - _size.height) / 2 - 32,
      _size.width - 64,
      _size.height,
    );
  }
}

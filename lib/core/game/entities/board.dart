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
    final boardWallTopRect = Rect.fromLTWH(
      -_size.width / 2 - 32,
      0,
      _size.width + 64,
      (_viewport.size.height - _size.height) / 2 + 32,
    );

    _assetManager.boardWallTopTexture.render(canvas, boardWallTopRect);

    final boardWallBottomRect = Rect.fromLTWH(
      -_size.width / 2 - 32,
      _viewport.size.height - (_viewport.size.height - _size.height) / 2,
      _size.width + 64,
      (_viewport.size.height - _size.height) / 2,
    );

    _assetManager.boardWallBottomTexture.render(canvas, boardWallBottomRect);

    final boardWallLeftRect = Rect.fromLTWH(
      -_size.width / 2 - 32,
      (_viewport.size.height - _size.height) / 2 + 32,
      32,
      _viewport.size.height - (_viewport.size.height - _size.height) - 32,
    );

    _assetManager.boardWallLeftTexture.render(canvas, boardWallLeftRect);

    final boardWallRightRect = Rect.fromLTWH(
      _size.width / 2,
      (_viewport.size.height - _size.height) / 2 + 32,
      32,
      _viewport.size.height - (_viewport.size.height - _size.height) - 32,
    );

    _assetManager.boardWallRightTexture.render(canvas, boardWallRightRect);
  }

  Rect get innerBounds {
    return Rect.fromLTWH(
      -_size.width / 2,
      (_viewport.size.height - _size.height) / 2,
      _size.width,
      _size.height,
    );
  }

  Rect get outerBounds {
    return Rect.fromLTWH(
      -_size.width / 2 - 32,
      0,
      _size.width + 64,
      _size.height + (_viewport.size.height - _size.height),
    );
  }
}

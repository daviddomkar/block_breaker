import 'dart:ui';

import '../../../constants.dart';
import '../../../services/asset_manager.dart';
import 'board.dart';

class Paddle {
  final AssetManager _assetManager;
  final Board _board;

  double _x;
  final double _width;

  Paddle({
    required AssetManager assetManager,
    required Board board,
    required double x,
    required double width,
  })  : _assetManager = assetManager,
        _board = board,
        _x = x,
        _width = width;

  set x(double x) {
    _x = x.clamp(
      -_board.innerBounds.width / 2 + _width / 2,
      _board.innerBounds.width / 2 - _width / 2,
    );
  }

  double get x => _x;

  void render(Canvas canvas) {
    _assetManager.paddleTexture.render(
      canvas,
      Rect.fromLTWH(
        -_width / 2 + _x,
        -kPaddleHeight / 2 + _board.innerBounds.bottom - kPaddleBottomOffset,
        _width,
        kPaddleHeight,
      ),
    );
  }
}

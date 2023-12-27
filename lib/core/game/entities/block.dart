import 'dart:ui';

import '../../../constants.dart';
import '../../../services/asset_manager.dart';
import '../../engine/nine_patch_texture.dart';

enum BlockType {
  blue,
  purple,
  pink,
  golden;
}

class Block {
  final AssetManager _assetManager;
  final BlockType _type;

  final double _x;
  final double _y;

  Block({
    required AssetManager assetManager,
    required BlockType type,
    required double x,
    required double y,
  })  : _assetManager = assetManager,
        _type = type,
        _x = x,
        _y = y;

  void render(Canvas canvas) {
    _texture.render(
      canvas,
      Rect.fromLTWH(
        _x - kBlockSize.width / 2,
        _y - kBlockSize.height / 2,
        kBlockSize.width,
        kBlockSize.height,
      ),
    );
  }

  NinePatchTexture get _texture {
    switch (_type) {
      case BlockType.blue:
        return _assetManager.blockBlueTexture;
      case BlockType.pink:
        return _assetManager.blockPinkTexture;
      case BlockType.purple:
        return _assetManager.blockPurpleTexture;
      case BlockType.golden:
        return _assetManager.blockGoldenTexture;
    }
  }
}

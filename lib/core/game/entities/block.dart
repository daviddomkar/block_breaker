import 'dart:ui';

import 'package:forge2d/forge2d.dart';

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
  final void Function(Block) _onDestroy;

  BlockType _type;

  late final Body _body;

  Block({
    required AssetManager assetManager,
    required void Function(Block) onDestroy,
    required World world,
    required BlockType type,
    required double x,
    required double y,
  })  : _assetManager = assetManager,
        _onDestroy = onDestroy,
        _type = type {
    final shape = PolygonShape()
      ..setAsBoxXY(
        kBlockSize.width / 2 * 0.1,
        kBlockSize.height / 2 * 0.1,
      );

    final fixtureDef = FixtureDef(shape, restitution: 1.0);

    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(x * 0.1, y * 0.1),
      type: BodyType.static,
    );

    _body = world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  void render(Canvas canvas) {
    _texture.render(
      canvas,
      Rect.fromLTWH(
        _body.position.x * 10 - kBlockSize.width / 2,
        _body.position.y * 10 - kBlockSize.height / 2,
        kBlockSize.width,
        kBlockSize.height,
      ),
    );
  }

  void destroy() {
    switch (_type) {
      case BlockType.blue:
        _onDestroy(this);
      case BlockType.purple:
        _type = BlockType.blue;
      case BlockType.pink:
        _type = BlockType.purple;
      case BlockType.golden:
        _type = BlockType.pink;
    }
  }

  void dispose() {
    _body.world.destroyBody(_body);
  }

  NinePatchTexture get _texture {
    switch (_type) {
      case BlockType.blue:
        return _assetManager.blockBlueTexture;
      case BlockType.purple:
        return _assetManager.blockPurpleTexture;
      case BlockType.pink:
        return _assetManager.blockPinkTexture;
      case BlockType.golden:
        return _assetManager.blockGoldenTexture;
    }
  }
}

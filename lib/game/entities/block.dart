import 'dart:ui';

import 'package:forge2d/forge2d.dart';

import '../../constants.dart';
import '../../services/asset_manager.dart';
import '../../engine/nine_patch_texture.dart';

enum BlockTier {
  grey,
  blue,
  purple,
  pink,
  golden;
}

class Block {
  final AssetManager _assetManager;
  final void Function(Block) _onDestroy;

  BlockTier _tier;

  late final Body _body;

  Block({
    required AssetManager assetManager,
    required void Function(Block) onDestroy,
    required World world,
    required BlockTier tier,
    required double x,
    required double y,
  })  : _assetManager = assetManager,
        _onDestroy = onDestroy,
        _tier = tier {
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

  int destroy() {
    switch (_tier) {
      case BlockTier.grey:
        return 0;
      case BlockTier.blue:
        _onDestroy(this);
        return 1;
      case BlockTier.purple:
        _tier = BlockTier.blue;
        return 2;
      case BlockTier.pink:
        _tier = BlockTier.purple;
        return 3;
      case BlockTier.golden:
        _tier = BlockTier.pink;
        return 4;
    }
  }

  void dispose() {
    _body.world.destroyBody(_body);
  }

  BlockTier get type => _tier;

  NinePatchTexture get _texture {
    switch (_tier) {
      case BlockTier.grey:
        return _assetManager.blockGreyTexture;
      case BlockTier.blue:
        return _assetManager.blockBlueTexture;
      case BlockTier.purple:
        return _assetManager.blockPurpleTexture;
      case BlockTier.pink:
        return _assetManager.blockPinkTexture;
      case BlockTier.golden:
        return _assetManager.blockGoldenTexture;
    }
  }
}

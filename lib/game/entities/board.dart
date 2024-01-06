import 'dart:ui';

import 'package:forge2d/forge2d.dart';

import '../../services/asset_manager.dart';
import '../../engine/viewport.dart';

class Board {
  final AssetManager _assetManager;
  final Viewport _viewport;
  final Size _size;

  late final Body _body;

  Board({
    required AssetManager assetManager,
    required World world,
    required Viewport viewport,
    required Size size,
  })  : _assetManager = assetManager,
        _viewport = viewport,
        _size = size {
    _body = _createBoundaries(world);
  }

  Body _createBoundaries(World world) {
    final bounds = innerBounds;

    // Top edge
    final topEdge = _createBoundaryEdge(
      world,
      Vector2(bounds.topLeft.dx * 0.1, bounds.topLeft.dy * 0.1),
      Vector2(bounds.topRight.dx * 0.1, bounds.topRight.dy * 0.1),
    );

    // Left edge
    final leftEdge = _createBoundaryEdge(
      world,
      Vector2(bounds.topLeft.dx * 0.1, bounds.topLeft.dy * 0.1),
      Vector2(bounds.bottomLeft.dx * 0.1, bounds.bottomLeft.dy * 0.1),
    );

    // Right edge
    final rightEdge = _createBoundaryEdge(
      world,
      Vector2(bounds.topRight.dx * 0.1, bounds.topRight.dy * 0.1),
      Vector2(bounds.bottomRight.dx * 0.1, bounds.bottomRight.dy * 0.1),
    );

    final bodyDef = BodyDef(
      position: Vector2.zero(),
      type: BodyType.static,
    );

    return world.createBody(bodyDef)
      ..createFixture(topEdge)
      ..createFixture(leftEdge)
      ..createFixture(rightEdge);
  }

  FixtureDef _createBoundaryEdge(World world, Vector2 start, Vector2 end) {
    final edgeShape = EdgeShape()
      ..set(
        start,
        end,
      );

    return FixtureDef(edgeShape, restitution: 1.0);
  }

  void dispose() {
    _body.world.destroyBody(_body);
  }

  void render(Canvas canvas) {
    final boardWallTopRect = Rect.fromLTWH(
      outerBounds.left,
      outerBounds.top,
      outerBounds.width,
      (outerBounds.height - innerBounds.height) / 2 + 32,
    );

    _assetManager.boardWallTopTexture.render(canvas, boardWallTopRect);

    final boardWallBottomRect = Rect.fromLTWH(
      outerBounds.left,
      innerBounds.height / 2,
      innerBounds.width + 64,
      (outerBounds.height - innerBounds.height) / 2,
    );

    _assetManager.boardWallBottomTexture.render(canvas, boardWallBottomRect);

    final boardWallLeftRect = Rect.fromLTWH(
      outerBounds.left,
      innerBounds.top + 32,
      32,
      innerBounds.height - 32,
    );

    _assetManager.boardWallLeftTexture.render(canvas, boardWallLeftRect);

    final boardWallRightRect = Rect.fromLTWH(
      innerBounds.width / 2,
      innerBounds.top + 32,
      32,
      innerBounds.height - 32,
    );

    _assetManager.boardWallRightTexture.render(canvas, boardWallRightRect);
  }

  Rect get innerBounds {
    return Rect.fromLTWH(
      -_size.width / 2,
      -_size.height / 2,
      _size.width,
      _size.height,
    );
  }

  Rect get outerBounds {
    return Rect.fromLTWH(
      -_size.width / 2 - 32,
      -_viewport.size.height / 2,
      _size.width + 64,
      _viewport.size.height,
    );
  }
}

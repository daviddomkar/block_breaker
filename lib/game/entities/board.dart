import 'dart:ui';

import 'package:forge2d/forge2d.dart';

import '../../services/asset_manager.dart';
import '../../engine/viewport.dart';

class Board {
  final AssetManager _assetManager;
  final Viewport _viewport;
  final Size _size;

  Board({
    required AssetManager assetManager,
    required World world,
    required Viewport viewport,
    required Size size,
  })  : _assetManager = assetManager,
        _viewport = viewport,
        _size = size {
    _createBoundaries(world);
  }

  void _createBoundaries(World world) {
    final bounds = innerBounds;

    // Top edge
    _createBoundaryEdge(
      world,
      Vector2(bounds.topLeft.dx * 0.1, bounds.topLeft.dy * 0.1),
      Vector2(bounds.topRight.dx * 0.1, bounds.topRight.dy * 0.1),
    );

    // Left edge
    _createBoundaryEdge(
      world,
      Vector2(bounds.topLeft.dx * 0.1, bounds.topLeft.dy * 0.1),
      Vector2(bounds.bottomLeft.dx * 0.1, bounds.bottomLeft.dy * 0.1),
    );

    // Right edge
    _createBoundaryEdge(
      world,
      Vector2(bounds.topRight.dx * 0.1, bounds.topRight.dy * 0.1),
      Vector2(bounds.bottomRight.dx * 0.1, bounds.bottomRight.dy * 0.1),
    );
  }

  void _createBoundaryEdge(World world, Vector2 start, Vector2 end) {
    final edgeShape = EdgeShape()
      ..set(
        start,
        end,
      );

    final edgeFixtureDef = FixtureDef(edgeShape, restitution: 1.0);

    final edgeBodyDef = BodyDef(
      position: Vector2.zero(),
      type: BodyType.static,
    );

    world.createBody(edgeBodyDef).createFixture(edgeFixtureDef);
  }

  void render(Canvas canvas) {
    final boardWallTopRect = Rect.fromLTWH(
      -_size.width / 2 - 32,
      -_viewport.size.height / 2,
      _size.width + 64,
      (_viewport.size.height - _size.height) / 2 + 32,
    );

    _assetManager.boardWallTopTexture.render(canvas, boardWallTopRect);

    final boardWallBottomRect = Rect.fromLTWH(
      -_size.width / 2 - 32,
      _viewport.size.height / 2 - (_viewport.size.height - _size.height) / 2,
      _size.width + 64,
      (_viewport.size.height - _size.height) / 2,
    );

    _assetManager.boardWallBottomTexture.render(canvas, boardWallBottomRect);

    final boardWallLeftRect = Rect.fromLTWH(
      -_size.width / 2 - 32,
      -_size.height / 2 + 32,
      32,
      _size.height - 32,
    );

    _assetManager.boardWallLeftTexture.render(canvas, boardWallLeftRect);

    final boardWallRightRect = Rect.fromLTWH(
      _size.width / 2,
      -_size.height / 2 + 32,
      32,
      _size.height - 32,
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
      _size.height + (_viewport.size.height - _size.height),
    );
  }
}

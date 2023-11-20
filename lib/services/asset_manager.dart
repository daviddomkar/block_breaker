import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import '../core/engine/nine_patch_texture.dart';

class AssetManager {
  // Textures
  final Image debugRectangleImage;
  final Image boardGridCellImage;

  final NinePatchTexture boardWallTopTexture;
  final NinePatchTexture boardWallBottomTexture;
  final NinePatchTexture boardWallLeftTexture;
  final NinePatchTexture boardWallRightTexture;

  // Shaders
  final FragmentProgram bloomShaderProgram;
  final FragmentProgram gridShaderProgram;

  AssetManager._(
    this.debugRectangleImage,
    this.boardGridCellImage,
    this.boardWallTopTexture,
    this.boardWallBottomTexture,
    this.boardWallLeftTexture,
    this.boardWallRightTexture,
    this.bloomShaderProgram,
    this.gridShaderProgram,
  );

  static Future<Image> loadImage(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    return await decodeImageFromList(Uint8List.view(byteData.buffer));
  }

  static Future<AssetManager> load() async {
    final debugRectangleImage = await loadImage(
      'assets/textures/debug_rectangle.png',
    );

    final boardGridCellImage = await loadImage(
      'assets/textures/board_grid_cell.png',
    );

    final boardWallTopTexture = await NinePatchTexture.load(
      'assets/textures/board_wall_top.png',
      center: const Rect.fromLTWH(
        220 * 3,
        4 * 3,
        68 * 3,
        12 * 3,
      ),
      scale: 3,
    );

    final boardWallBottomTexture = await NinePatchTexture.load(
      'assets/textures/board_wall_bottom.png',
      center: const Rect.fromLTWH(
        20 * 3,
        4 * 3,
        440 * 3,
        40 * 3,
      ),
      scale: 3,
    );

    final boardWallLeftTexture = await NinePatchTexture.load(
      'assets/textures/board_wall_left.png',
      center: const Rect.fromLTWH(
        4 * 3,
        4 * 3,
        12 * 3,
        258 * 3,
      ),
      scale: 3,
    );

    final boardWallRightTexture = await NinePatchTexture.load(
      'assets/textures/board_wall_right.png',
      center: const Rect.fromLTWH(
        16 * 3,
        0 * 3,
        12 * 3,
        210 * 3,
      ),
      scale: 3,
    );

    final bloomShaderProgram = await FragmentProgram.fromAsset(
      'assets/shaders/bloom.frag',
    );

    final gridShaderProgram = await FragmentProgram.fromAsset(
      'assets/shaders/grid.frag',
    );

    return AssetManager._(
      debugRectangleImage,
      boardGridCellImage,
      boardWallTopTexture,
      boardWallBottomTexture,
      boardWallLeftTexture,
      boardWallRightTexture,
      bloomShaderProgram,
      gridShaderProgram,
    );
  }
}

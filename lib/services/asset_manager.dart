import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import '../engine/nine_patch_texture.dart';

class AssetManager {
  // Textures
  final Image boardGridCellImage;

  final NinePatchTexture boardWallTopTexture;
  final NinePatchTexture boardWallBottomTexture;
  final NinePatchTexture boardWallLeftTexture;
  final NinePatchTexture boardWallRightTexture;

  final NinePatchTexture paddleTexture;

  final NinePatchTexture blockGreyTexture;
  final NinePatchTexture blockBlueTexture;
  final NinePatchTexture blockPurpleTexture;
  final NinePatchTexture blockPinkTexture;
  final NinePatchTexture blockGoldenTexture;

  // Shaders
  final FragmentProgram lumaShaderProgram;
  final FragmentProgram gridShaderProgram;

  AssetManager._(
    this.boardGridCellImage,
    this.boardWallTopTexture,
    this.boardWallBottomTexture,
    this.boardWallLeftTexture,
    this.boardWallRightTexture,
    this.paddleTexture,
    this.blockGreyTexture,
    this.blockBlueTexture,
    this.blockPurpleTexture,
    this.blockPinkTexture,
    this.blockGoldenTexture,
    this.lumaShaderProgram,
    this.gridShaderProgram,
  );

  static Future<Image> loadImage(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    return await decodeImageFromList(Uint8List.view(byteData.buffer));
  }

  static Future<AssetManager> load() async {
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

    final paddleTexture = await NinePatchTexture.load(
      'assets/textures/paddle.png',
      center: const Rect.fromLTWH(
        20 * 3,
        8 * 3,
        56 * 3,
        8 * 3,
      ),
      scale: 3,
    );

    const blockCenterRect = Rect.fromLTWH(
      4 * 3,
      8 * 3,
      56 * 3,
      12 * 3,
    );

    final blockGreyTexture = await NinePatchTexture.load(
      'assets/textures/block_grey.png',
      center: blockCenterRect,
      scale: 3,
    );

    final blockBlueTexture = await NinePatchTexture.load(
      'assets/textures/block_blue.png',
      center: blockCenterRect,
      scale: 3,
    );

    final blockPurpleTexture = await NinePatchTexture.load(
      'assets/textures/block_purple.png',
      center: blockCenterRect,
      scale: 3,
    );

    final blockPinkTexture = await NinePatchTexture.load(
      'assets/textures/block_pink.png',
      center: blockCenterRect,
      scale: 3,
    );

    final blockGoldenTexture = await NinePatchTexture.load(
      'assets/textures/block_golden.png',
      center: blockCenterRect,
      scale: 3,
    );

    final lumaShaderProgram = await FragmentProgram.fromAsset(
      'assets/shaders/luma.frag',
    );

    final gridShaderProgram = await FragmentProgram.fromAsset(
      'assets/shaders/grid.frag',
    );

    return AssetManager._(
      boardGridCellImage,
      boardWallTopTexture,
      boardWallBottomTexture,
      boardWallLeftTexture,
      boardWallRightTexture,
      paddleTexture,
      blockGreyTexture,
      blockBlueTexture,
      blockPurpleTexture,
      blockPinkTexture,
      blockGoldenTexture,
      lumaShaderProgram,
      gridShaderProgram,
    );
  }
}

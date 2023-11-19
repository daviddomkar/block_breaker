import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

class AssetManager {
  // Textures
  final Image debugRectangleImage;
  final Image boardGridCellImage;
  final Image boardWallTopImage;

  // Shaders
  final FragmentProgram bloomShaderProgram;
  final FragmentProgram gridShaderProgram;

  AssetManager._(
    this.debugRectangleImage,
    this.boardGridCellImage,
    this.boardWallTopImage,
    this.bloomShaderProgram,
    this.gridShaderProgram,
  );

  static Future<Image> _loadImage(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    return await decodeImageFromList(Uint8List.view(byteData.buffer));
  }

  static Future<AssetManager> load() async {
    final debugRectangleImage = await _loadImage(
      'assets/textures/debug_rectangle.png',
    );

    final boardGridCellImage = await _loadImage(
      'assets/textures/board_grid_cell.png',
    );

    final boardWallTopImage = await _loadImage(
      'assets/textures/board_wall_top.png',
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
      boardWallTopImage,
      bloomShaderProgram,
      gridShaderProgram,
    );
  }
}

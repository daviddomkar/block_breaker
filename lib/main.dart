import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';

import 'screens/game_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cellTextureByteData = await rootBundle.load(
    'assets/textures/cell.png',
  );

  final cellTextureImage = await decodeImageFromList(
    Uint8List.view(cellTextureByteData.buffer),
  );

  final bloomShaderProgram = await FragmentProgram.fromAsset(
    'shaders/bloom.frag',
  );
  final gridShaderProgram = await FragmentProgram.fromAsset(
    'shaders/grid.frag',
  );

  runApp(
    BlockBreakerApp(
      cellTextureImage: cellTextureImage,
      gridShaderProgram: gridShaderProgram,
      bloomShaderProgram: bloomShaderProgram,
    ),
  );
}

class BlockBreakerApp extends StatelessWidget {
  final Image cellTextureImage;

  final FragmentProgram gridShaderProgram;
  final FragmentProgram bloomShaderProgram;

  const BlockBreakerApp({
    super.key,
    required this.cellTextureImage,
    required this.gridShaderProgram,
    required this.bloomShaderProgram,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Block Breaker',
      home: GameScreen(
        cellTextureImage: cellTextureImage,
        gridShaderProgram: gridShaderProgram,
        bloomShaderProgram: bloomShaderProgram,
      ),
    );
  }
}

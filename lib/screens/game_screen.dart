import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_shaders/flutter_shaders.dart';

import '../core/engine/widgets/game_widget.dart';
import '../core/game/block_breaker_game.dart';
import '../services/asset_manager.dart';

class GameScreen extends StatefulWidget {
  final AssetManager assetManager;

  const GameScreen({
    super.key,
    required this.assetManager,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final BlockBreakerGame _game;
  late final FragmentShader _bloomDownsampleShader;
  late final FragmentShader _bloomUpsampleShader;

  @override
  void initState() {
    super.initState();

    _game = BlockBreakerGame(
      assetManager: widget.assetManager,
    );

    _bloomDownsampleShader =
        widget.assetManager.bloomDownsampleShaderProgram.fragmentShader();

    _bloomUpsampleShader =
        widget.assetManager.bloomUpsampleShaderProgram.fragmentShader();
  }

  @override
  void dispose() {
    _bloomUpsampleShader.dispose();
    _bloomDownsampleShader.dispose();
    super.dispose();
  }

  Image downsample(Image image, Size size, int level) {
    _bloomDownsampleShader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setImageSampler(0, image);

    final downsampleRecorder = PictureRecorder();
    final downsampleCanvas = Canvas(downsampleRecorder);

    downsampleCanvas.drawRect(
      Offset.zero & size,
      Paint()..shader = _bloomDownsampleShader,
    );

    final downsamplePicture = downsampleRecorder.endRecording();

    final downsampledImage = downsamplePicture.toImageSync(
      size.width.round(),
      size.height.round(),
    );

    if (level > 0) {
      final image = downsample(downsampledImage, size, level - 1);
      downsampledImage.dispose();
      return image;
    } else {
      return downsampledImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedSampler(
            (image, size, canvas) {
              final downsampledImage = downsample(image, size, 8);

              canvas.drawImage(
                downsampledImage,
                Offset.zero,
                Paint(),
              );

              downsampledImage.dispose();
            },
            child: GameWidget(
              game: _game,
            ),
          ),
        ],
      ),
    );
  }
}

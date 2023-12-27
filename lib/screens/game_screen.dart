import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_shaders/flutter_shaders.dart';

import '../constants.dart';
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
  late final FragmentShader _lumaShader;

  @override
  void initState() {
    super.initState();

    _game = BlockBreakerGame(
      assetManager: widget.assetManager,
    );

    _lumaShader = widget.assetManager.lumaShaderProgram.fragmentShader();
  }

  @override
  void dispose() {
    _lumaShader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedSampler(
            (image, size, canvas) {
              _lumaShader
                ..setFloat(0, 0.5)
                ..setFloat(1, 1.5)
                ..setFloat(2, size.width)
                ..setFloat(3, size.height)
                ..setImageSampler(0, image);

              canvas.drawImage(image, Offset.zero, Paint());

              canvas.saveLayer(
                null,
                Paint()
                  ..blendMode = BlendMode.plus
                  ..imageFilter = ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              );

              canvas.drawRect(
                Offset.zero & size,
                Paint()..shader = _lumaShader,
              );

              canvas.restore();
            },
            child: GameWidget(
              game: _game,
            ),
          ),
          IgnorePointer(
            child: SizedBox.fromSize(
              size: MediaQuery.sizeOf(context),
              child: FittedBox(
                child: SizedBox.fromSize(
                  size: kViewportSize,
                  child: Center(
                    child: SizedBox.fromSize(
                      size: Size(kBoardSize.width, kBoardSize.height),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Score: 1215'),
                              Text('Lives: 3'),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

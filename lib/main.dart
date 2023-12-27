import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'constants.dart';
import 'core/engine/widgets/game_widget.dart';
import 'core/game/block_breaker_game.dart';
import 'core/game/game_state.dart';
import 'screens/home_screen.dart';
import 'services/asset_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final assetManager = await AssetManager.load();

  runApp(
    BlockBreakerApp(
      assetManager: assetManager,
    ),
  );
}

class BlockBreakerApp extends StatefulWidget {
  final AssetManager assetManager;

  const BlockBreakerApp({
    super.key,
    required this.assetManager,
  });

  @override
  State<BlockBreakerApp> createState() => _BlockBreakerAppState();
}

class _BlockBreakerAppState extends State<BlockBreakerApp> {
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
    return MaterialApp(
      title: 'Block Breaker',
      theme: ThemeData.dark(),
      builder: (context, child) {
        return AnimatedSampler(
          (image, size, canvas) {
            _lumaShader
              ..setFloat(0, 0.5)
              ..setFloat(1, 0.7)
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
          child: Scaffold(
            body: Stack(
              children: [
                GameWidget(
                  game: _game,
                ),
                ListenableBuilder(
                  listenable: _game,
                  builder: (context, child) {
                    return IgnorePointer(
                      ignoring: _game.state == GameState.ready ||
                          _game.state == GameState.playing,
                      child: child,
                    );
                  },
                  child: SizedBox.fromSize(
                    size: MediaQuery.sizeOf(context),
                    child: FittedBox(
                      child: SizedBox.fromSize(
                        size: kViewportSize,
                        child: Center(
                          child: SizedBox.fromSize(
                            size: Size(kBoardSize.width, kBoardSize.height),
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      home: const HomeScreen(),
    );
  }
}

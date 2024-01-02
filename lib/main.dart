import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'core/engine/widgets/game_widget.dart';
import 'core/game/block_breaker_game.dart';
import 'core/game/game_state.dart';
import 'screens/level_screen.dart';
import 'screens/home_screen.dart';
import 'screens/level_selection_screen.dart';
import 'services/asset_manager.dart';
import 'services/progression_store.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  GoogleFonts.config.allowRuntimeFetching = false;

  final sharedPreferences = await SharedPreferences.getInstance();

  final assetManager = await AssetManager.load();
  final levelManager = ProgressionStore(prefs: sharedPreferences);

  runApp(
    BlockBreakerApp(
      assetManager: assetManager,
      levelManager: levelManager,
    ),
  );
}

class BlockBreakerApp extends StatefulWidget {
  final AssetManager assetManager;
  final ProgressionStore levelManager;

  const BlockBreakerApp({
    super.key,
    required this.assetManager,
    required this.levelManager,
  });

  @override
  State<BlockBreakerApp> createState() => _BlockBreakerAppState();
}

class _BlockBreakerAppState extends State<BlockBreakerApp> {
  late final RouteObserver<ModalRoute<void>> _routeObserver;

  late final BlockBreakerGame _game;
  late final FragmentShader _lumaShader;

  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _routeObserver = RouteObserver();

    _game = BlockBreakerGame(
      assetManager: widget.assetManager,
    );

    _lumaShader = widget.assetManager.lumaShaderProgram.fragmentShader();

    _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: HomeScreen(),
            );
          },
        ),
        GoRoute(
          path: '/level-selection',
          pageBuilder: (context, state) {
            return NoTransitionPage(
              child: LevelSelectionScreen(
                routeObserver: _routeObserver,
                progressionStore: widget.levelManager,
                game: _game,
              ),
            );
          },
        ),
        GoRoute(
          path: '/level/:index',
          pageBuilder: (context, state) {
            return NoTransitionPage(
              child: LevelScreen(
                game: _game,
                progressionStore: widget.levelManager,
                levelIndex: int.parse(state.pathParameters['index']!) - 1,
              ),
            );
          },
        ),
      ],
      observers: [_routeObserver],
    );
  }

  @override
  void dispose() {
    _lumaShader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Block Breaker',
      theme: buildTheme(),
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
                  child: MouseRegion(
                    cursor: MouseCursor.uncontrolled,
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
                ),
              ],
            ),
          ),
        );
      },
      routerConfig: _router,
    );
  }
}

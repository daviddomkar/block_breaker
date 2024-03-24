import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'engine/widgets/game_widget.dart';
import 'game/block_breaker_game.dart';
import 'game/game_state.dart';
import 'ui/screens/level_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/level_selection_screen.dart';
import 'services/asset_manager.dart';
import 'services/progression_store.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  GoogleFonts.config.allowRuntimeFetching = false;

  final sharedPreferences = await SharedPreferences.getInstance();

  final assetManager = await AssetManager.load();
  final progressionStore = ProgressionStore(prefs: sharedPreferences);

  runApp(
    BlockBreakerApp(
      assetManager: assetManager,
      progressionStore: progressionStore,
    ),
  );
}

class BlockBreakerApp extends StatefulWidget {
  final AssetManager assetManager;
  final ProgressionStore progressionStore;

  const BlockBreakerApp({
    super.key,
    required this.assetManager,
    required this.progressionStore,
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
                progressionStore: widget.progressionStore,
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
                progressionStore: widget.progressionStore,
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
      debugShowCheckedModeBanner: false,
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

            canvas.drawImageRect(
                image,
                Offset.zero &
                    Size(
                      image.width.toDouble(),
                      image.height.toDouble(),
                    ),
                Offset.zero & size,
                Paint());

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
                // Pause button for mobile devices needs to be rendered on top of
                // everything else due to [IgnorePointer] logic. This solution
                // is not ideal but it works for this simple project.
                ListenableBuilder(
                  listenable: _game,
                  builder: (context, child) {
                    return Visibility(
                      visible: _game.state == GameState.ready ||
                          _game.state == GameState.playing,
                      child: child!,
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
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity,
                                  ),
                                  icon: const Icon(
                                    Icons.pause,
                                  ),
                                  onPressed: () {
                                    _game.pause();
                                  },
                                ),
                              ),
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

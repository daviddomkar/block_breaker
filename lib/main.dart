import 'package:flutter/material.dart';
import 'screens/game_screen.dart';
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

class BlockBreakerApp extends StatelessWidget {
  final AssetManager assetManager;

  const BlockBreakerApp({
    super.key,
    required this.assetManager,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Block Breaker',
      home: GameScreen(
        assetManager: assetManager,
      ),
    );
  }
}

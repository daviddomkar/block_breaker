import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'viewport.dart';

abstract class Game extends ChangeNotifier {
  final Viewport _viewport;

  Game({
    required Viewport viewport,
  }) : _viewport = viewport;

  void init() {}
  @mustCallSuper
  @override
  void dispose() {
    super.dispose();
  }

  void update(double dt) {}
  void render(Canvas canvas) {}

  Viewport get viewport => _viewport;
}

import 'dart:ui';

import 'viewport.dart';

abstract class Game {
  final Viewport _viewport;

  Game({
    required Viewport viewport,
  }) : _viewport = viewport;

  void init() {}
  void dispose() {}
  void update(double dt) {}
  void render(Canvas canvas) {}

  Viewport get viewport => _viewport;
}

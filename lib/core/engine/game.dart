import 'dart:ui';

abstract class Game {
  void init() {}
  void dispose() {}
  void update(double dt) {}
  void render(Canvas canvas, Size size) {}
}

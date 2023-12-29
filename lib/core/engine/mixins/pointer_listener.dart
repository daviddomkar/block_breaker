import 'package:flutter/gestures.dart';

import '../game.dart';

mixin PointerListener on Game {
  void onPointerUp(PointerUpEvent event) {}
  void onPointerMove(PointerMoveEvent event) {}
  void onPointerHover(PointerHoverEvent event) {}
}

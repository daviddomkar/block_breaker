import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../game.dart';

mixin PointerListener on Game {
  void onPointerMove(PointerMoveEvent event, Size size) {}
}

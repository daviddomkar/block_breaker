import 'dart:math';
import 'dart:ui';

import '../engine/game.dart';
import '../engine/viewport.dart';

class BlockBreakerGame extends Game {
  late final Viewport _viewport;

  double x = 0;

  @override
  void init() {
    _viewport = Viewport(
      size: const Size(
        480,
        double.infinity,
      ),
    );
  }

  @override
  void dispose() {}

  @override
  void update(double dt) {
    x += dt;
  }

  @override
  void render(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFF000000), BlendMode.clear);
    _viewport.render(canvas, size, (canvas, size) {
      canvas.save();

      // canvas.translate(100, sin(x) * 100);

      canvas.translate(size.width / 2, size.height / 2 + sin(x) * 100);
      canvas.rotate(x);

      canvas.drawRect(
        const Rect.fromLTWH(-100, -100, 200, 200),
        Paint()..color = const Color(0xFFFF0000),
      );

      canvas.restore();
    });
  }
}

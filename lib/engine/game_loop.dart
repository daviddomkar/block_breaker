import 'package:flutter/scheduler.dart';

class GameLoop {
  final void Function(double) _onUpdate;
  late final Ticker _ticker;

  Duration _previousDuration;

  GameLoop({
    required void Function(double) onUpdate,
  })  : _onUpdate = onUpdate,
        _previousDuration = Duration.zero {
    _ticker = Ticker(_tick);
  }

  void start() {
    if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  void stop() {
    _ticker.stop();
    _previousDuration = Duration.zero;
  }

  void dispose() {
    _ticker.dispose();
  }

  void _tick(Duration duration) {
    final durationDelta = duration - _previousDuration;
    final dt = durationDelta.inMicroseconds / Duration.microsecondsPerSecond;
    _previousDuration = duration;
    _onUpdate(dt);
  }
}

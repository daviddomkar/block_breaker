import 'package:flutter/scheduler.dart';

class GameLoop {
  final void Function(double) _onUpdate;
  late final Ticker _ticker;

  Duration _previousFrameDuration;

  GameLoop({
    required void Function(double) onUpdate,
  })  : _onUpdate = onUpdate,
        _previousFrameDuration = Duration.zero {
    _ticker = Ticker(_tick);
  }

  void start() {
    if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  void stop() {
    _ticker.stop();
    _previousFrameDuration = Duration.zero;
  }

  void dispose() {
    _ticker.dispose();
  }

  void _tick(Duration duration) {
    final durationDelta = duration - _previousFrameDuration;
    final dt = durationDelta.inMicroseconds / Duration.microsecondsPerSecond;
    _previousFrameDuration = duration;
    _onUpdate(dt);
  }
}

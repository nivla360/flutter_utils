import 'dart:async';

class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer(this.duration);

  void debounce(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

    /// Notifies if the delayed call is active.
  bool get isRunning => _timer?.isActive ?? false;

  /// Cancel the current delayed call.
  void cancel() => _timer?.cancel();
}
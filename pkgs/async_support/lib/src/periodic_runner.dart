import 'dart:async';

final class PeriodicRunner {
  PeriodicRunner();

  Timer? _timer;

  Future<void> runPeriodically({
    required Future<void> Function() callback,
    required Duration every,
  }) async {
    await callback();

    _timer = Timer.periodic(
      every,
      (_) async => await callback(),
    );
  }

  void stop() {
    _timer?.cancel();
  }
}

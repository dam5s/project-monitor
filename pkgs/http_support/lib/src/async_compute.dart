import 'dart:async';
import 'dart:isolate';

abstract class AsyncCompute {
  Future<R> compute<M, R>(
      FutureOr<R> Function(M message) callback,
      M message, {
        String? debugLabel,
      });
}

class InlineAsyncCompute extends AsyncCompute {
  @override
  Future<R> compute<M, R>(
      FutureOr<R> Function(M message) callback,
      M message, {
        String? debugLabel,
      }) async {
    return callback(message);
  }
}

class IsolateAsyncCompute extends AsyncCompute {
  @override
  Future<R> compute<M, R>(
      FutureOr<R> Function(M message) callback,
      M message, {
        String? debugLabel,
      }) {
    return Isolate.run(() => callback(message), debugName: debugLabel);
  }
}

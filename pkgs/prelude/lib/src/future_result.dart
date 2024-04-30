import 'dart:async';

import 'result.dart';

typedef FutureResult<T, E> = Future<Result<T, E>>;

extension Mappings<T, E> on FutureResult<T, E> {
  Future<E> continueWith(FutureOr<E> Function(T) mapping) async {
    switch (await this) {
      case Ok(:final value):
        return mapping(value);

      case Err(:final error):
        return error;
    }
  }
}

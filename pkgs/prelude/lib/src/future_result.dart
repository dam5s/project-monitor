import 'dart:async';

import 'result.dart';

extension Mappings<T, E> on Future<Result<T, E>> {

  Future<Result<NewT, E>> mapOk<NewT>(FutureOr<NewT> Function(T) mapping) async {
    switch (await this) {
      case Ok(:final value):
        return Ok (await mapping(value));

      case Err(:final error):
        return Err(error);
    }
  }

  Future<Result<NewT, E>> flatMapOk<NewT>(FutureOr<Result<NewT, E>> Function(T) mapping) async {
    switch (await this) {
      case Ok(:final value):
        return await mapping(value);

      case Err(:final error):
        return Err(error);
    }
  }

  Future<Result<T, NewE>> mapErr<NewE>(FutureOr<NewE> Function(E) mapping) async {
    switch (await this) {
      case Ok(:final value):
        return Ok(value);

      case Err(:final error):
        return Err(await mapping(error));
    }
  }

  Future<T> orElse(FutureOr<T> Function(E) mapping) async {
    switch (await this) {
      case Ok(:final value):
        return value;

      case Err(:final error):
        return await mapping(error);
    }
  }
}

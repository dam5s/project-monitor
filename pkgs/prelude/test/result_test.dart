import 'package:prelude/prelude.dart';
import 'package:test/test.dart';

void main() {
  test('mapOk', () {
    final mapped = const Ok(1).mapOk((it) => 'The number was $it');
    expect(mapped.orNull(), 'The number was 1');
  });
}

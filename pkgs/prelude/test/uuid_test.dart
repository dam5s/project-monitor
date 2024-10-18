import 'package:prelude/prelude.dart';
import 'package:test/test.dart';

void main() {
  test('UUID.tryFromString', () {
    var result = UUID.tryFromString('2b0bf6fb-565c-42d4-be77-3a057c5ac121');
    expect(result?.value, equals('2b0bf6fb-565c-42d4-be77-3a057c5ac121'));
  });

  test('UUID.tryFromString from upper case', () {
    var result = UUID.tryFromString('2B0BF6FB-565C-42D4-BE77-3A057C5AC121');
    expect(result?.value, equals('2b0bf6fb-565c-42d4-be77-3a057c5ac121'));
  });

  test('UUID.tryFromString when not a uuid', () {
    const invalidCharacters = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';
    const notV4 = '2b0bf6fb-565c-12d4-be77-3a057c5ac121';
    const tooLong = '2b0bf6fb-565c-42d4-be77-3a057c5ac121a';
    const tooShort = '2b0bf6fb-565c-42d4-be77-3a057c5ac12';

    expect(UUID.tryFromString(invalidCharacters), equals(null));
    expect(UUID.tryFromString(notV4), equals(null));
    expect(UUID.tryFromString(tooLong), equals(null));
    expect(UUID.tryFromString(tooShort), equals(null));
  });
}

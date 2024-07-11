import 'dart:math';

class UUID {
  final String value;

  UUID._(this.value);

  static UUID? tryFromString(String value) {
    final normalizedValue = value.toLowerCase();

    final matches = _v4Format.hasMatch(normalizedValue);
    if (!matches) {
      return null;
    }

    return UUID._(normalizedValue);
  }

  factory UUID.v4() {
    return UUID._(_Generator().generateV4());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UUID && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'UUID{value: $value}';
  }
}

final _v4Format = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}$');

class _Generator {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) => value.toRadixString(16).padLeft(count, '0');
}

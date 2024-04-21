
import 'package:prelude/prelude.dart';
import 'package:test/test.dart';

class IsUUIDStringMatcher implements Matcher {

  @override
  Description describe(Description description) =>
    description.addDescriptionOf(UUID);

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription, Map<dynamic, dynamic> matchState, bool verbose) =>
    mismatchDescription.add('is not a string representing a UUID');

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) {
    if (item is String) return UUID.tryFromString(item) != null;
    return false;
  }
}

Matcher isUUIDString() => IsUUIDStringMatcher();

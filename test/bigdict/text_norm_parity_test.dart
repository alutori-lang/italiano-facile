import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/services/text_norm.dart';

/// The Dart port must give exactly what the Python dictionary builder gives:
/// the phone builds the reverse index with it.
void main() {
  final Map<String, dynamic> fx = jsonDecode(
    File('test/fixtures/norm_cases.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  test('Big dictionary: norm() matches the Python builder', () {
    final Map<String, dynamic> cases = fx['norm'] as Map<String, dynamic>;
    expect(cases, isNotEmpty);
    cases.forEach((String input, dynamic want) {
      expect(TextNorm.norm(input), want, reason: 'norm("$input")');
    });
  });

  test('Big dictionary: romkey() matches the Python builder', () {
    final Map<String, dynamic> cases = fx['romkey'] as Map<String, dynamic>;
    expect(cases, isNotEmpty);
    cases.forEach((String input, dynamic want) {
      expect(TextNorm.romkey(input), want, reason: 'romkey("$input")');
    });
  });

  test('Big dictionary: variants() matches the Python builder', () {
    final Map<String, dynamic>? cases = fx['variants'] as Map<String, dynamic>?;
    if (cases == null) {
      markTestSkipped('fixture has no variants cases (old builder)');
      return;
    }
    cases.forEach((String input, dynamic want) {
      expect(
        TextNorm.variants(input),
        (want as List<dynamic>).cast<String>(),
        reason: 'variants("$input")',
      );
    });
  });

  test('Big dictionary: spelling variants of Roman Urdu collapse', () {
    expect(TextNorm.romkey('piyar'), TextNorm.romkey('pyaar'));
    expect(TextNorm.romkey('fan qie'), TextNorm.romkey('fanqie'));
    expect(TextNorm.hasLatin('piyar'), isTrue);
    expect(TextNorm.hasLatin('پیار'), isFalse);
  });
}

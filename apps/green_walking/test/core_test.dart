import 'package:flutter_test/flutter_test.dart';
import 'package:green_walking/core.dart';

void main() {
  group('truncate() input', () {
    final Map<String, String> tests = <String, String>{
      null: null,
      '1': '1',
      '12': '12',
      '123': '123',
      '1234': '123...',
      '12345': '123...',
    };
    tests.forEach((String input, String expected) {
      test('$input -> $expected', () {
        expect(truncateString(input, 3), equals(expected));
      });
    });
  });

  group('truncate() cutoff', () {
    final Map<int, String> tests = <int, String>{
      null: null,
      -1: null,
      0: null,
      1: '1...',
      2: '12...',
      3: '123...',
    };
    tests.forEach((int input, String expected) {
      test('$input -> $expected', () {
        expect(truncateString('12345', input), equals(expected));
      });
    });
  });
}

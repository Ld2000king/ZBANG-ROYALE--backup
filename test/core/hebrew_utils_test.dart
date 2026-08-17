import 'package:flutter_test/flutter_test.dart';
import 'package:zbang_royale/core/hebrew_utils.dart';

void main() {
  group('normalizeFinals', () {
    test('converts every final letter to its regular form', () {
      expect(normalizeFinals('שלום'), 'שלומ');
      expect(normalizeFinals('לחם'), 'לחמ');
      expect(normalizeFinals('עולם'), 'עולמ');
    });

    test('leaves words without final letters unchanged', () {
      expect(normalizeFinals('בית'), 'בית');
      expect(normalizeFinals('זבאנג'), 'זבאנג');
    });

    test('is a no-op on already-normalized input', () {
      expect(normalizeFinals('שלומ'), 'שלומ');
    });
  });

  group('pointsForWord', () {
    test('scores by length: <5 chars = 100, 4 = 250, 5+ = 500', () {
      expect(pointsForWord('בית'), 100); // 3
      expect(pointsForWord('שלומ'), 250); // 4
      expect(pointsForWord('משפחה'), 500); // 5
      expect(pointsForWord('זבאנג'), 500); // 5+
    });
  });
}

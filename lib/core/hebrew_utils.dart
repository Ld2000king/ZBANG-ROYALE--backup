/// The board is built only from regular (non-final) Hebrew letter forms, so a
/// word spelled with a final letter (שלום, לחם, ...) could never be matched
/// against it. Normalizing final forms to their regular counterparts -
/// dictionary keys, planted words, and dragged words alike - makes those
/// words findable and every comparison apples-to-apples.
const Map<String, String> finalLetterMap = {
  'ך': 'כ',
  'ם': 'מ',
  'ן': 'נ',
  'ף': 'פ',
  'ץ': 'צ',
};

final RegExp _finalLettersPattern = RegExp('[ךםןףץ]');

String normalizeFinals(String value) {
  return value.replaceAllMapped(
    _finalLettersPattern,
    (match) => finalLetterMap[match[0]]!,
  );
}

int pointsForWord(String word) {
  if (word.length >= 5) return 500;
  if (word.length == 4) return 250;
  return 100;
}

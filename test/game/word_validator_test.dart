import 'package:flutter_test/flutter_test.dart';
import 'package:zbang_royale/data/dictionary/dictionary_repository.dart';
import 'package:zbang_royale/game/word_validator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DictionaryRepository dictionary;
  late WordValidator validator;

  setUpAll(() async {
    dictionary = await DictionaryRepository.load();
    validator = WordValidator(dictionary);
  });

  test('rejects words shorter than 3 letters as too short', () {
    final outcome = validator.evaluate('בת', {});
    expect(outcome.type, WordOutcomeType.tooShort);
  });

  test('scores a known word with the dictionary points', () {
    final outcome = validator.evaluate('בית', {});
    expect(outcome.type, WordOutcomeType.scored);
    expect(outcome.points, dictionary.pointsFor('בית'));
  });

  test('normalizes final letters before lookup', () {
    // שלום ends in a final מ (ם); the board and dictionary only ever use the
    // regular form, so the raw dragged word must be normalized first.
    final outcome = validator.evaluate('שלום', {});
    expect(outcome.type, WordOutcomeType.scored);
    expect(outcome.word, 'שלומ');
  });

  test('flags a word already in foundWords as already found', () {
    final outcome = validator.evaluate('בית', {'בית'});
    expect(outcome.type, WordOutcomeType.alreadyFound);
  });

  test('flags a word absent from the dictionary as unknown', () {
    final outcome = validator.evaluate('קשקוש', {});
    if (dictionary.contains('קשקוש')) {
      // If this ever gets added to the dictionary, the test's premise
      // changes; scored is then the correct outcome.
      expect(outcome.type, WordOutcomeType.scored);
    } else {
      expect(outcome.type, WordOutcomeType.unknown);
    }
  });
}

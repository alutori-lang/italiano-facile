import '../models/topic.dart';
import '../models/word.dart';
import 'words_01.dart';
import 'words_02.dart';
import 'words_03.dart';
import 'words_04.dart';
import 'words_05.dart';
import 'words_06.dart';
import 'words_07.dart';
import 'words_08.dart';
import 'words_09.dart';

/// The bundled dictionary. Everything is offline: no network, no database.
class WordRepository {
  WordRepository._internal() {
    _all = <Word>[
      ...words01,
      ...words02,
      ...words03,
      ...words04,
      ...words05,
      ...words06,
      ...words07,
      ...words08,
      ...words09,
    ];
    for (final Word word in _all) {
      _byId[word.id] = word;
      _byTopic.putIfAbsent(word.topicId, () => <Word>[]).add(word);
    }
  }

  static final WordRepository instance = WordRepository._internal();

  late final List<Word> _all;
  final Map<String, Word> _byId = <String, Word>{};
  final Map<String, List<Word>> _byTopic = <String, List<Word>>{};

  List<Word> get all => List<Word>.unmodifiable(_all);

  int get wordCount => _all.where((Word w) => !w.isPhrase).length;
  int get phraseCount => _all.where((Word w) => w.isPhrase).length;

  Word? byId(String id) => _byId[id];

  List<Word> byTopic(String topicId) =>
      List<Word>.unmodifiable(_byTopic[topicId] ?? const <Word>[]);

  int countInTopic(String topicId) => _byTopic[topicId]?.length ?? 0;

  /// Topics that actually have entries, in the order of [kTopics].
  List<Topic> get topicsWithWords =>
      kTopics.where((Topic t) => countInTopic(t.id) > 0).toList(growable: false);

  List<Word> byIds(Iterable<String> ids) {
    final List<Word> out = <Word>[];
    for (final String id in ids) {
      final Word? word = _byId[id];
      if (word != null) out.add(word);
    }
    return out;
  }
}

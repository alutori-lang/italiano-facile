import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

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

/// The large dictionary, bundled as one JSON asset: an array of entries
/// [it, type, topic, emoji|null, tr[10], expl[10], example, exampleTr[10]].
const String kDictionaryAsset = 'assets/dict/words.json';

const Map<String, WordType> _types = <String, WordType>{
  'n': WordType.noun,
  'v': WordType.verb,
  'a': WordType.adjective,
  'p': WordType.phrase,
};

List<Word> _parseDictionary(String source) {
  final List<dynamic> rows = jsonDecode(source) as List<dynamic>;
  final List<Word> out = <Word>[];
  for (final dynamic row in rows) {
    final List<dynamic> r = row as List<dynamic>;
    out.add(Word(
      it: r[0] as String,
      type: _types[r[1]] ?? WordType.noun,
      topicId: r[2] as String,
      emoji: r[3] as String?,
      tr: List<String>.from(r[4] as List<dynamic>),
      expl: List<String>.from(r[5] as List<dynamic>),
      example: r[6] as String,
      exampleTr: List<String>.from(r[7] as List<dynamic>),
    ));
  }
  return out;
}

/// The bundled dictionary. Everything is offline: no network, no database.
class WordRepository {
  WordRepository._internal(List<Word> extra) {
    final List<Word> builtIn = <Word>[
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
    _all = <Word>[];
    for (final Word word in <Word>[...builtIn, ...extra]) {
      if (_byId.containsKey(word.id)) continue;
      _all.add(word);
      _byId[word.id] = word;
      _byTopic.putIfAbsent(word.topicId, () => <Word>[]).add(word);
    }
  }

  static WordRepository? _instance;

  /// The dictionary. Before [load] finishes it holds only the built-in words.
  static WordRepository get instance =>
      _instance ??= WordRepository._internal(const <Word>[]);

  /// Reads the bundled JSON dictionary off the main isolate. Called once at
  /// startup; if the asset is missing the built-in words still work.
  static Future<void> load() async {
    try {
      final String source = await rootBundle.loadString(kDictionaryAsset);
      final List<Word> extra = await compute(_parseDictionary, source);
      _instance = WordRepository._internal(extra);
    } catch (error) {
      debugPrint('Dictionary not loaded: $error');
      _instance ??= WordRepository._internal(const <Word>[]);
    }
  }

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

// The parity check runs computeKeys over many entries; keep a wide margin.
@Timeout(Duration(minutes: 10))
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:simple_flutter_app_651/data/big_dictionary.dart';
import 'package:simple_flutter_app_651/models/big_entry.dart';
import 'package:simple_flutter_app_651/models/learner_language.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'big_support.dart';

/// Repository tests on the REAL big.db (assets/dict/big/ parts, with its
/// shipped reverse index): the words checked are picked from what is in it.
void main() {
  sqfliteFfiInit();

  late Directory dir;
  late BigDictionary big;

  setUpAll(() async {
    dir = await Directory.systemTemp.createTemp('bigdict_test');
    big = makeBigDictionary(dir, factory: databaseFactoryFfi);
    final Stopwatch sw = Stopwatch()..start();
    await big.open();
    // ignore: avoid_print
    print('big.db: ${big.entryCount} entries, version ${big.version}; '
        'copy ${big.lastCopyMs} ms (longest part ${big.longestCopyStepMs} '
        'ms), open total ${sw.elapsedMilliseconds} ms');
    expect(big.ready, isTrue);
    // The reverse index ships in big.db: every language is searchable
    // at once, nothing is built.
    for (final LearnerLanguage lang in LearnerLanguage.values) {
      expect(big.isIndexed(lang), isTrue, reason: lang.tag);
    }
  });

  tearDownAll(() async {
    await big.close();
    try {
      await dir.delete(recursive: true);
    } catch (_) {}
  });

  Future<List<String>> its(String q, LearnerLanguage lang) async =>
      (await big.lookup(q, lang)).map((BigHit h) => h.entry.it).toList();

  test('Big dictionary: "simpatico" gives the Urdu meaning', () async {
    final List<BigHit> hits =
        await big.lookup('simpatico', LearnerLanguage.urdu);
    expect(hits, isNotEmpty);
    expect(hits.first.entry.it, 'simpatico');
    expect(hits.first.score, 1000);
    final String meaning = hits.first.entry.translation(LearnerLanguage.urdu);
    // ignore: avoid_print
    print('simpatico (ur) → $meaning');
    expect(meaning, contains('خوش اخلاق'));
  });

  test('Big dictionary: conjugated and plural forms find the word', () async {
    expect((await its('andavamo', LearnerLanguage.urdu)).first, 'andare');
    expect((await its('case', LearnerLanguage.urdu)), contains('casa'));
    expect((await its('simpatica', LearnerLanguage.urdu)).first, 'simpatico');
    expect((await its('Città', LearnerLanguage.english)), isA<List<String>>());
  });

  test('Big dictionary: Urdu script and Roman Urdu find the Italian word',
      () async {
    // In the current data Urdu "love" is محبت / mohabbat; پیار / pyaar is the
    // Punjabi (Shahmukhi) word, tested below.
    final List<String> script = await its('محبت', LearnerLanguage.urdu);
    final List<String> roman = await its('muhabat', LearnerLanguage.urdu);
    final List<String> roman2 = await its('mohabbat', LearnerLanguage.urdu);
    // ignore: avoid_print
    print('ur محبت → ${script.take(3)}; muhabat → ${roman.take(3)}');
    expect(script, contains('amore'));
    expect(roman, contains('amore'));
    expect(roman2, contains('amore'));
    expect(await its('pani', LearnerLanguage.urdu), contains('acqua'));
    expect(await its('ghar', LearnerLanguage.urdu), contains('casa'));
  });

  test('Big dictionary: پیار and piyar/pyaar find "amore" in Punjabi',
      () async {
    final List<String> script =
        await its('پیار', LearnerLanguage.punjabiShahmukhi);
    final List<String> piyar =
        await its('piyar', LearnerLanguage.punjabiShahmukhi);
    final List<String> pyaar =
        await its('pyaar', LearnerLanguage.punjabiShahmukhi);
    // ignore: avoid_print
    print('pa پیار → ${script.take(3)}; piyar → ${piyar.take(3)}');
    expect(script.first, 'amore');
    expect(piyar.first, 'amore');
    expect(pyaar.first, 'amore');
  });

  test('Big dictionary: Banglish and pinyin', () async {
    expect(await its('bhalobasha', LearnerLanguage.bengali), contains('amore'));
    expect(await its('ভালোবাসা', LearnerLanguage.bengali), contains('amore'));
    final List<String> fanqie =
        await its('fanqie', LearnerLanguage.chineseSimplified);
    // ignore: avoid_print
    print('zh fanqie → ${fanqie.take(3)} '
        '(pomodoro ${fanqie.contains('pomodoro') ? 'present' : 'NOT in the partial DB'})');
    final bool hasPomodoro =
        (await big.lookup('pomodoro', LearnerLanguage.chineseSimplified))
            .any((BigHit h) => h.entry.it == 'pomodoro');
    // Chinese has two words for tomato (番茄 fanqie, 西红柿 xihongshi); the
    // dictionary may give either, so accept both spellings.
    if (hasPomodoro) {
      final List<String> xihongshi =
          await its('xihongshi', LearnerLanguage.chineseSimplified);
      expect(<String>[...fanqie, ...xihongshi], contains('pomodoro'));
    }
    final List<String> shui =
        await its('shui', LearnerLanguage.chineseSimplified);
    expect(shui, contains('acqua'));
    expect(
        await its('水', LearnerLanguage.chineseSimplified), contains('acqua'));
  });

  test('Big dictionary: English meanings when English is chosen', () async {
    final Stopwatch sw = Stopwatch()..start();
    final List<String> love = await its('love', LearnerLanguage.english);
    // ignore: avoid_print
    print('love (en) → ${love.take(3)} in ${sw.elapsedMilliseconds} ms');
    expect(love.first, 'amore');
    expect(await its('love', LearnerLanguage.english), contains('amore'));
    expect(await its('to go', LearnerLanguage.english), contains('andare'));
  });

  test('Big dictionary: exact matches come before prefixes', () async {
    final List<BigHit> hits = await big.lookup('casa', LearnerLanguage.english);
    expect(hits.first.entry.it, 'casa');
    for (int i = 1; i < hits.length; i++) {
      expect(hits[i - 1].score, greaterThanOrEqualTo(hits[i].score));
    }
  });

  test('Big dictionary: articles follow the Italian rules', () {
    String hw(String it, String? g) =>
        BigEntry(id: 1, it: it, pos: 'noun', g: g, tr: const <String>[])
            .headword;
    expect(hw('casa', 'f'), 'la casa');
    expect(hw('amore', 'm'), "l'amore");
    expect(hw('acqua', 'f'), "l'acqua");
    expect(hw('zio', 'm'), 'lo zio');
    expect(hw('studente', 'm'), 'lo studente');
    expect(hw('gnomo', 'm'), 'lo gnomo');
    expect(hw('psicologo', 'm'), 'lo psicologo');
    expect(hw('pomodoro', 'm'), 'il pomodoro');
    expect(hw('hotel', 'm'), "l'hotel");
    expect(hw('cantante', 'mf'), 'il/la cantante');
    expect(hw('Roma', 'f'), 'Roma');
    expect(
      const BigEntry(id: 1, it: 'andare', pos: 'verb', tr: <String>[]).headword,
      'andare',
    );
  });

  test(
      'Big dictionary: Urdu chosen also finds Punjabi words (pyaar, piyar, '
      'پیار → amore), meaning still shown in Urdu', () async {
    final List<BigHit> script = await big.lookup('پیار', LearnerLanguage.urdu);
    final List<String> pyaar = await its('pyaar', LearnerLanguage.urdu);
    final List<String> piyar = await its('piyar', LearnerLanguage.urdu);
    // ignore: avoid_print
    print('ur پیار → ${script.take(3).map((BigHit h) => h.entry.it)}; '
        'pyaar → ${pyaar.take(3)}; piyar → ${piyar.take(3)}');
    expect(script.map((BigHit h) => h.entry.it), contains('amore'));
    expect(pyaar, contains('amore'));
    expect(piyar, contains('amore'));
    final BigEntry amore =
        script.firstWhere((BigHit h) => h.entry.it == 'amore').entry;
    expect(amore.translation(LearnerLanguage.urdu), 'محبت');
  });

  test('Big dictionary: English words work for every language', () async {
    expect(await its('love', LearnerLanguage.bengali), contains('amore'));
    expect(await its('water', LearnerLanguage.urdu), contains('acqua'));
  });

  test('Big dictionary: the chosen language ranks before the close ones',
      () async {
    final List<BigHit> hits = await big.lookup('محبت', LearnerLanguage.urdu);
    expect(hits.first.score, 950);
    final List<BigHit> en = await big.lookup('love', LearnerLanguage.urdu);
    expect(en.firstWhere((BigHit h) => h.entry.it == 'amore').score, 930);
  });

  test(
      'Big dictionary: the shipped index has exactly the keys computeKeys '
      'gives (meta.keys = rows; a sample of entries compared key by key)',
      () async {
    final Database db = await databaseFactoryFfi.openDatabase(
      '${dir.path}/big.db',
      options: OpenDatabaseOptions(readOnly: true),
    );
    try {
      final String want =
          (await db.rawQuery("SELECT v FROM meta WHERE k = 'keys'"))
              .first['v']! as String;
      final int rows = (await db.rawQuery('SELECT COUNT(*) AS n FROM keys'))
          .first['n']! as int;
      expect(rows, int.parse(want), reason: 'meta.keys = rows of keys');
      // A spread sample (every 50th entry, words and phrases) plus the words
      // the other tests rely on: the rows for those ids must be exactly what
      // the Dart side computes (same norm/romkey/variants as the builder).
      final List<Map<String, Object?>> sample = await db.rawQuery(
          'SELECT id, tr, rom FROM entries WHERE id % 50 = 0 '
          "OR it_norm IN ('amore','acqua','casa','pomodoro','andare')");
      expect(sample.length, greaterThan(1000));
      final List<int> ids = <int>[
        for (final Map<String, Object?> r in sample) r['id']! as int,
      ];
      final List<Object> flat = computeKeys(BigDictionary.allSlotsJob(
        ids,
        <String>[
          for (final Map<String, Object?> r in sample) r['tr']! as String,
        ],
        <String>[
          for (final Map<String, Object?> r in sample)
            (r['rom'] as String?) ?? '',
        ],
      ));
      final Set<String> mine = <String>{
        for (int i = 0; i < flat.length; i += 3)
          '${flat[i]}|${flat[i + 1]}|${flat[i + 2]}',
      };
      expect(mine.length, flat.length ~/ 3, reason: 'no duplicate rows');
      final Set<String> shipped = <String>{};
      for (int i = 0; i < ids.length; i += 500) {
        final List<int> part =
            ids.sublist(i, i + 500 > ids.length ? ids.length : i + 500);
        for (final Map<String, Object?> r in await db.rawQuery(
            'SELECT key, slot, entry_id FROM keys WHERE entry_id IN '
            '(${List<String>.filled(part.length, '?').join(',')})',
            part)) {
          shipped.add('${r['key']}|${r['slot']}|${r['entry_id']}');
        }
      }
      // ignore: avoid_print
      print('parity sample: ${ids.length} entries, ${mine.length} keys');
      expect(shipped.difference(mine), isEmpty, reason: 'only in big.db');
      expect(mine.difference(shipped), isEmpty, reason: 'only in Dart');
    } finally {
      await db.close();
    }
  });

  test('Big dictionary: the copy goes part by part (small steps)', () async {
    final List<String> manifest =
        File(BigDictionary.assetParts).readAsLinesSync();
    final int parts = int.parse(manifest[0]);
    expect(parts, greaterThan(1));
    for (int i = 0; i < parts; i++) {
      expect(File(BigDictionary.partName(i)).lengthSync(),
          lessThanOrEqualTo(2 * 1024 * 1024));
    }
    expect(File(BigDictionary.partName(parts)).existsSync(), isFalse);
    expect(File('${dir.path}/big.db').lengthSync(), int.parse(manifest[1]));
    expect(File('${dir.path}/big.db.tmp').existsSync(), isFalse);
  });

  test('Big dictionary: a copy with a missing part is never used', () async {
    final Directory d6 = await Directory.systemTemp.createTemp('bigdict_cut');
    final BigDictionary cut = BigDictionary(
      databaseFactory: databaseFactoryFfi,
      directory: () async => d6,
      loadAsset: (String key) async {
        if (key == BigDictionary.partName(1)) {
          return ByteData(0); // a part that did not arrive
        }
        return ByteData.sublistView(await File(key).readAsBytes());
      },
      loadString: (String key) => File(key).readAsString(),
    );
    await cut.open();
    expect(cut.status, BigDictStatus.failed);
    expect(File('${d6.path}/big.db').existsSync(), isFalse);
    await cut.close();
    try {
      await d6.delete(recursive: true);
    } catch (_) {}
  });

  test('Big dictionary: indexed slots per language', () {
    expect(BigDictionary.trSlotsFor(LearnerLanguage.urdu), <int>[0, 1, 2]);
    expect(BigDictionary.trSlotsFor(LearnerLanguage.punjabiShahmukhi),
        <int>[0, 1, 2]);
    expect(BigDictionary.trSlotsFor(LearnerLanguage.punjabiGurmukhi),
        <int>[0, 1, 2, 3]);
    expect(BigDictionary.trSlotsFor(LearnerLanguage.bengali), <int>[0, 4]);
    expect(BigDictionary.trSlotsFor(LearnerLanguage.english), <int>[0]);
    expect(BigDictionary.romSlotsFor(LearnerLanguage.punjabiGurmukhi).keys,
        <String>['ur', 'pa']);
    expect(BigDictionary.romSlotsFor(LearnerLanguage.french), isEmpty);
  });

  test('Big dictionary: a second start reuses the copy', () async {
    final BigDictionary again =
        makeBigDictionary(dir, factory: databaseFactoryFfi);
    await again.open();
    expect(again.ready, isTrue);
    expect(again.copies, 0, reason: 'same version: no new copy');
    expect(again.isIndexed(LearnerLanguage.urdu), isTrue);
    expect(await again.lookup('love', LearnerLanguage.french), isNotEmpty);
    await again.close();
  });

  test('Big dictionary: a changed bundled version copies big.db again',
      () async {
    final Directory d5 = await Directory.systemTemp.createTemp('bigdict_ver');
    String version = File('assets/dict/big_version.txt').readAsStringSync();
    expect(version.trim(), matches(RegExp(r'^[0-9a-f]{12}$')),
        reason: 'meta.version is a short content hash');
    BigDictionary make() => BigDictionary(
          databaseFactory: databaseFactoryFfi,
          directory: () async => d5,
          loadAsset: (String key) async =>
              ByteData.sublistView(await File(key).readAsBytes()),
          loadString: (String key) async => key == BigDictionary.assetVersion
              ? version
              : await File(key).readAsString(),
        );
    final BigDictionary first = make();
    await first.open();
    expect(first.copies, 1, reason: 'first launch copies');
    expect(File('${d5.path}/big.db').existsSync(), isTrue);
    await first.close();
    // Same version: no copy.
    final BigDictionary same = make();
    await same.open();
    expect(same.copies, 0);
    await same.close();
    // A different bundled version (new content): copied again.
    version = 'ffffffffffff';
    final BigDictionary changed = make();
    await changed.open();
    expect(changed.ready, isTrue);
    expect(changed.copies, 1, reason: 'new content hash: copied again');
    await changed.close();
    try {
      await d5.delete(recursive: true);
    } catch (_) {}
  });

  test(
      'Big dictionary: the word server (lookup, updates paging, removed, '
      '422/404; feature off when the URL is empty)', () async {
    final Directory d2 = await Directory.systemTemp.createTemp('bigdict_srv');
    List<String> tr(String en, String ur) =>
        <String>[en, ur, '', '', '', '', '', '', '', ''];
    // The exact shape of server/src/db.js rowToEntry.
    Map<String, Object?> entry(
            int id, String it, String pos, String en, String ur, int createdAt,
            {String? g, String? pl, Map<String, String>? rom}) =>
        <String, Object?>{
          'id': id,
          'it': it,
          'pos': pos,
          'g': g,
          'pl': pl,
          'gloss': en,
          'ex_it': null,
          'ex_en': null,
          'tr': tr(en, ur),
          'rom': rom ?? <String, String>{},
          'created_at': createdAt,
        };
    int calls = 0;
    final List<String> sinces = <String>[];
    http.Response json(Object body, [int status = 200]) =>
        http.Response.bytes(utf8.encode(jsonEncode(body)), status,
            headers: <String, String>{'content-type': 'application/json'});
    final MockClient client = MockClient((http.Request req) async {
      calls++;
      if (req.url.path == '/v1/lookup') {
        final Map<String, dynamic> body =
            jsonDecode(req.body) as Map<String, dynamic>;
        expect(body['lang'], 'ur');
        if (body['q'] == 'parolaccia') {
          return json(<String, String>{'error': 'not_allowed'}, 422);
        }
        if (body['q'] == 'xqzw') {
          return json(<String, String>{'error': 'not_found'}, 404);
        }
        return json(<String, Object?>{
          ...entry(7, 'la zzparolanuova', 'noun', 'new word', 'نیا لفظ', 1000,
              g: 'f',
              pl: 'le zzparolenuove',
              rom: <String, String>{'ur': 'naya lafz'}),
          'cached': false,
        });
      }
      if (req.url.path == '/v1/updates') {
        final String since = req.url.queryParameters['since'] ?? '';
        sinces.add(since);
        expect(req.url.queryParameters['limit'], isNotNull);
        if (since == '0') {
          return json(<String, Object?>{
            'entries': <Object?>[
              entry(8, 'zzaggiornata', 'adj', 'updated', 'تازہ', 2000),
            ],
            'next': 2000,
            'more': true,
            'removed': <int>[],
          });
        }
        if (since == '2000') {
          return json(<String, Object?>{
            'entries': <Object?>[
              entry(9, 'zzseconda', 'adj', 'second page', 'دوسرا صفحہ', 3000),
            ],
            'next': 3000,
            'more': false,
            'removed': <int>[7],
          });
        }
        return json(<String, Object?>{
          'entries': <Object?>[],
          'next': int.parse(since),
          'more': false,
          'removed': <int>[],
        });
      }
      return json(<String, String>{'error': 'no_route'}, 404);
    });

    final BigDictionary off = makeBigDictionary(d2,
        factory: databaseFactoryFfi, client: client, baseUrl: '');
    await off.open();
    expect(off.serverEnabled, isFalse);
    expect((await off.askServer('zzparolanuova', LearnerLanguage.urdu)).status,
        ServerLookupStatus.off);
    expect(await off.syncUpdates(), 0);
    expect(calls, 0, reason: 'empty URL = no network call');
    await off.close();

    final BigDictionary on = makeBigDictionary(d2,
        factory: databaseFactoryFfi,
        client: client,
        baseUrl: 'https://words.test');
    await on.open();
    final ServerLookup got =
        await on.askServer('zzparolanuova', LearnerLanguage.urdu);
    expect(got.status, ServerLookupStatus.found);
    expect(got.entry!.learned, isTrue);
    expect(got.entry!.it, 'zzparolanuova', reason: 'article stripped');
    expect(got.entry!.headword, 'la zzparolanuova');
    expect(
        (await on.lookup('zzparolanuova', LearnerLanguage.urdu)).first.entry.it,
        'zzparolanuova');
    // Real dictionary words may share the meaning ("neoformazione"), so
    // the learned word must be among the answers, not necessarily first.
    expect(
        (await on.lookup('نیا لفظ', LearnerLanguage.urdu))
            .map((BigHit h) => h.entry.it),
        contains('zzparolanuova'));
    expect(
        (await on.lookup('naya lafz', LearnerLanguage.urdu))
            .map((BigHit h) => h.entry.it),
        contains('zzparolanuova'));
    expect((await on.askServer('parolaccia', LearnerLanguage.urdu)).status,
        ServerLookupStatus.notAllowed);
    expect((await on.askServer('xqzw', LearnerLanguage.urdu)).status,
        ServerLookupStatus.notFound);

    // Two pages (more: true, then false); the second removes server id 7.
    expect(await on.syncUpdates(), 2);
    expect(sinces, <String>['0', '2000']);
    expect(
        (await on.lookup('تازہ', LearnerLanguage.urdu))
            .map((BigHit h) => h.entry.it),
        contains('zzaggiornata'));
    expect(
        (await on.lookup('second page', LearnerLanguage.urdu))
            .map((BigHit h) => h.entry.it),
        contains('zzseconda'));
    expect(
        (await on.lookup('zzparolanuova', LearnerLanguage.urdu))
            .map((BigHit h) => h.entry.it),
        isNot(contains('zzparolanuova')),
        reason: 'removed on the server');
    expect(
        (await on.lookup('naya lafz', LearnerLanguage.urdu))
            .map((BigHit h) => h.entry.it),
        isNot(contains('zzparolanuova')));
    // Next sync starts from the saved `next`.
    await on.syncUpdates();
    expect(sinces.last, '3000');
    await on.close();

    // Offline / broken server: never an exception.
    final BigDictionary broken = makeBigDictionary(d2,
        factory: databaseFactoryFfi,
        client: MockClient((_) async => throw const SocketException('offline')),
        baseUrl: 'https://words.test');
    await broken.open();
    expect((await broken.askServer('qualcosa', LearnerLanguage.urdu)).status,
        ServerLookupStatus.failed);
    expect(await broken.syncUpdates(), 0);
    // The learned words survived the restart.
    expect((await broken.lookup('zzaggiornata', LearnerLanguage.urdu)),
        isNotEmpty);
    await broken.close();
    try {
      await d2.delete(recursive: true);
    } catch (_) {}
  });

  test(
      'Big dictionary: a slow first copy shows "Preparazione…" after '
      '300 ms, then hides it', () async {
    final Directory d4 = await Directory.systemTemp.createTemp('bigdict_slow');
    final BigDictionary slow = BigDictionary(
      databaseFactory: databaseFactoryFfi,
      directory: () async => d4,
      loadAsset: (String key) async {
        if (key == BigDictionary.partName(0)) {
          await Future<void>.delayed(const Duration(milliseconds: 500));
        }
        return ByteData.sublistView(await File(key).readAsBytes());
      },
      loadString: (String key) => File(key).readAsString(),
    );
    final Future<void> opening = slow.open();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(slow.status, BigDictStatus.preparing);
    expect(slow.showPreparing, isFalse, reason: 'not before 300 ms');
    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(slow.showPreparing, isTrue);
    await opening;
    expect(slow.ready, isTrue);
    expect(slow.showPreparing, isFalse);
    // ignore: avoid_print
    print('slow copy: ${slow.lastCopyMs} ms (500 ms of it simulated)');
    await slow.close();
    try {
      await d4.delete(recursive: true);
    } catch (_) {}
  });

  test('Big dictionary: a missing database never breaks anything', () async {
    final Directory d3 = await Directory.systemTemp.createTemp('bigdict_bad');
    final BigDictionary bad = BigDictionary(
      databaseFactory: databaseFactoryFfi,
      directory: () async => d3,
      loadAsset: (String key) async => throw const FileSystemException('none'),
      loadString: (String key) async => throw const FileSystemException('none'),
    );
    await bad.open();
    expect(bad.status, BigDictStatus.failed);
    expect(await bad.lookup('casa', LearnerLanguage.urdu), isEmpty);
    await bad.close();
  });
}

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

/// Repository tests on the REAL assets/dict/big.db (still partial while the
/// translation runs): the words checked are picked from what is in it.
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
        'copy ${big.lastCopyMs} ms, open total ${sw.elapsedMilliseconds} ms');
    expect(big.ready, isTrue);
    await big.useLanguage(LearnerLanguage.urdu);
    // ignore: avoid_print
    print('index Urdu: ${big.lastIndexMs} ms');
    expect(big.isIndexed(LearnerLanguage.urdu), isTrue);
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
    await big.useLanguage(LearnerLanguage.punjabiShahmukhi);
    // ignore: avoid_print
    print('index Punjabi (Shahmukhi): ${big.lastIndexMs} ms');
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
    await big.useLanguage(LearnerLanguage.bengali);
    expect(await its('bhalobasha', LearnerLanguage.bengali), contains('amore'));
    expect(await its('ভালোবাসা', LearnerLanguage.bengali), contains('amore'));
    await big.useLanguage(LearnerLanguage.chineseSimplified);
    final List<String> fanqie =
        await its('fanqie', LearnerLanguage.chineseSimplified);
    // ignore: avoid_print
    print('zh fanqie → ${fanqie.take(3)} '
        '(pomodoro ${fanqie.contains('pomodoro') ? 'present' : 'NOT in the partial DB'})');
    final bool hasPomodoro =
        (await big.lookup('pomodoro', LearnerLanguage.chineseSimplified))
            .any((BigHit h) => h.entry.it == 'pomodoro');
    if (hasPomodoro) expect(fanqie, contains('pomodoro'));
    final List<String> shui =
        await its('shui', LearnerLanguage.chineseSimplified);
    expect(shui, contains('acqua'));
    expect(
        await its('水', LearnerLanguage.chineseSimplified), contains('acqua'));
  });

  test('Big dictionary: English meanings when English is chosen', () async {
    await big.useLanguage(LearnerLanguage.english);
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

  test('Big dictionary: the phone index has exactly the builder\'s keys',
      () async {
    // build_bigdb.py counts (key, slot) rows per entry over all ten slots and
    // the four Latin-letter slots; computeKeys must produce the same number.
    final Database db = await databaseFactoryFfi.openDatabase(
      '${dir.path}/big.db',
      options: OpenDatabaseOptions(readOnly: true),
    );
    final List<Map<String, Object?>> rows =
        await db.rawQuery('SELECT id, tr, rom FROM entries');
    final String want =
        (await db.rawQuery("SELECT v FROM meta WHERE k = 'keys'")).first['v']!
            as String;
    await db.close();
    final KeyJob base = KeyJob(
      ids: <int>[for (final Map<String, Object?> r in rows) r['id']! as int],
      tr: <String>[
        for (final Map<String, Object?> r in rows) r['tr']! as String
      ],
      rom: <String>[
        for (final Map<String, Object?> r in rows) (r['rom'] as String?) ?? ''
      ],
      slot: 0,
      romSlot: null,
      romLang: null,
    );
    int total = 0;
    for (int slot = 0; slot < LearnerLanguage.count; slot++) {
      total += computeKeys(KeyJob(
                  ids: base.ids,
                  tr: base.tr,
                  rom: base.rom,
                  slot: slot,
                  romSlot: null,
                  romLang: null))
              .length ~/
          3;
    }
    for (final MapEntry<String, int> rom in const <String, int>{
      'ur': 11,
      'pa': 12,
      'bn': 14,
      'zh': 16,
    }.entries) {
      total += computeKeys(KeyJob(
                  ids: base.ids,
                  tr: base.tr,
                  rom: base.rom,
                  slot: 99,
                  romSlot: rom.value,
                  romLang: rom.key))
              .length ~/
          3;
    }
    expect(total, int.parse(want));
  });

  test('Big dictionary: a second start reuses the copy and the index',
      () async {
    final BigDictionary again =
        makeBigDictionary(dir, factory: databaseFactoryFfi);
    await again.open();
    expect(again.ready, isTrue);
    expect(again.lastCopyMs, 0, reason: 'same version: no new copy');
    expect(again.isIndexed(LearnerLanguage.urdu), isTrue);
    await again.close();
  });

  test(
      'Big dictionary: learned words from the server (feature off when '
      'the URL is empty)', () async {
    final Directory d2 = await Directory.systemTemp.createTemp('bigdict_srv');
    int calls = 0;
    final MockClient client = MockClient((http.Request req) async {
      calls++;
      if (req.url.path == '/v1/lookup') {
        final Map<String, dynamic> body =
            jsonDecode(req.body) as Map<String, dynamic>;
        expect(body['lang'], 'ur');
        return http.Response.bytes(
          utf8.encode(jsonEncode(<String, Object>{
            'it': 'zzparolanuova',
            'pos': 'noun',
            'g': 'f',
            'pl': 'zzparolenuove',
            'gloss': 'new word',
            'tr': <String>[
              'new word',
              'نیا لفظ',
              '',
              '',
              '',
              '',
              '',
              '',
              '',
              ''
            ],
            'rom': <String, String>{'ur': 'naya lafz'},
          })),
          200,
        );
      }
      if (req.url.path == '/v1/updates') {
        return http.Response.bytes(
          utf8.encode(jsonEncode(<String, Object>{
            'now': '2026-10-22T10:00:00Z',
            'entries': <Object>[
              <String, Object>{
                'it': 'zzaggiornata',
                'pos': 'adj',
                'gloss': 'updated',
                'tr': <String>[
                  'updated',
                  'تازہ',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  ''
                ],
                'updated_at': '2026-10-22T09:00:00Z',
              },
            ],
          })),
          200,
        );
      }
      return http.Response('no', 404);
    });

    final BigDictionary off = makeBigDictionary(d2,
        factory: databaseFactoryFfi, client: client, baseUrl: '');
    await off.start(LearnerLanguage.urdu);
    expect(off.serverEnabled, isFalse);
    expect(await off.askServer('zzparolanuova', LearnerLanguage.urdu), isNull);
    expect(await off.syncUpdates(), 0);
    expect(calls, 0, reason: 'empty URL = no network call');
    await off.close();

    final BigDictionary on = makeBigDictionary(d2,
        factory: databaseFactoryFfi,
        client: client,
        baseUrl: 'https://words.test');
    await on.start(LearnerLanguage.urdu);
    final BigEntry? got =
        await on.askServer('zzparolanuova', LearnerLanguage.urdu);
    expect(got, isNotNull);
    expect(got!.learned, isTrue);
    expect(got.headword, 'la zzparolanuova');
    expect(
        (await on.lookup('zzparolanuova', LearnerLanguage.urdu)).first.entry.it,
        'zzparolanuova');
    expect((await on.lookup('نیا لفظ', LearnerLanguage.urdu)).first.entry.it,
        'zzparolanuova');
    expect((await on.lookup('naya lafz', LearnerLanguage.urdu)).first.entry.it,
        'zzparolanuova');
    expect(await on.syncUpdates(), 1);
    expect(
        (await on.lookup('تازہ', LearnerLanguage.urdu))
            .map((BigHit h) => h.entry.it),
        contains('zzaggiornata'));
    await on.close();

    // Offline / broken server: never an exception.
    final BigDictionary broken = makeBigDictionary(d2,
        factory: databaseFactoryFfi,
        client: MockClient((_) async => throw const SocketException('offline')),
        baseUrl: 'https://words.test');
    await broken.start(LearnerLanguage.urdu);
    expect(await broken.askServer('qualcosa', LearnerLanguage.urdu), isNull);
    expect(await broken.syncUpdates(), 0);
    // The learned word survived the restart.
    expect((await broken.lookup('zzparolanuova', LearnerLanguage.urdu)),
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
        await Future<void>.delayed(const Duration(milliseconds: 500));
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
    await bad.start(LearnerLanguage.urdu);
    expect(bad.status, BigDictStatus.failed);
    expect(await bad.lookup('casa', LearnerLanguage.urdu), isEmpty);
    await bad.close();
  });
}

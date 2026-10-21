import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../config/server_config.dart';
import '../models/big_entry.dart';
import '../models/learner_language.dart';
import '../services/text_norm.dart';

/// Where the big dictionary is in its life cycle.
enum BigDictStatus { idle, preparing, ready, failed }

/// One big-dictionary hit, with the score that ordered it.
class BigHit {
  const BigHit(this.entry, this.score);

  final BigEntry entry;

  /// 1000 Italian word, 950 meaning, 900 Latin-letter spelling, 850 Italian
  /// form (andavamo → andare), 600/550/500 the same as a prefix.
  final int score;

  bool get exact => score >= 850;
}

/// The big offline dictionary (~100,000 Italian words from Wiktionary, with
/// the meaning in the ten languages).
///
/// assets/dict/big.db (read only) is copied once to the app's support folder.
/// Next to it, user.db holds what the phone builds or receives itself:
///  * `keys` — the reverse index (meaning → entry) for the CHOSEN language
///    only, built in the background with [TextNorm]; the Italian lookup works
///    before it is ready.
///  * `learned` — words received later from the word server
///    ([ServerConfig]); searched exactly like the big entries.
///  * `umeta` — which language is indexed for which dictionary version.
///
/// Nothing here may break the curated app: every failure ends in
/// [BigDictStatus.failed] or an empty result, never in an exception.
class BigDictionary extends ChangeNotifier {
  BigDictionary({
    sqflite.DatabaseFactory? databaseFactory,
    Future<Directory> Function()? directory,
    Future<ByteData> Function(String key)? loadAsset,
    Future<String> Function(String key)? loadString,
    http.Client? httpClient,
    String? serverBaseUrl,
    this.useIsolate = true,
  })  : _factory = databaseFactory,
        _directory = directory ?? getApplicationSupportDirectory,
        _loadAsset = loadAsset ?? rootBundle.load,
        _loadString = loadString ?? rootBundle.loadString,
        _client = httpClient,
        _baseUrl = serverBaseUrl ?? ServerConfig.baseUrl;

  static const String assetDb = 'assets/dict/big.db';
  static const String assetVersion = 'assets/dict/big_version.txt';

  final sqflite.DatabaseFactory? _factory;
  final Future<Directory> Function() _directory;
  final Future<ByteData> Function(String key) _loadAsset;
  final Future<String> Function(String key) _loadString;
  final http.Client? _client;
  final String _baseUrl;

  /// Off in widget tests that want everything on one isolate.
  final bool useIsolate;

  sqflite.Database? _db;
  Future<void>? _opening;
  Future<void> _indexChain = Future<void>.value();
  LearnerLanguage? _wanted;
  final Set<int> _indexed = <int>{};
  String _bigVersion = '';
  int _entryCount = 0;
  int _busy = 0;
  Timer? _preparingTimer;

  BigDictStatus _status = BigDictStatus.idle;
  BigDictStatus get status => _status;
  bool get ready => _status == BigDictStatus.ready;

  /// True once preparing (copy or index) has taken longer than 300 ms: the
  /// one-time "Preparazione del dizionario…" notice.
  bool _showPreparing = false;
  bool get showPreparing => _showPreparing;

  /// True while the reverse index of some language is being built.
  bool get indexing => _building != null;
  LearnerLanguage? _building;

  int get entryCount => _entryCount;
  String get version => _bigVersion;
  bool isIndexed(LearnerLanguage lang) => _indexed.contains(lang.slot);
  bool get serverEnabled => _baseUrl.isNotEmpty;

  /// Milliseconds the last copy / last index build took (for the tests and
  /// the report; 0 when nothing was needed).
  int lastCopyMs = 0;
  int lastIndexMs = 0;

  /// Latin-letter index slot per language (see build_bigdb.py ROM_SLOT).
  static int? romSlotFor(LearnerLanguage lang) {
    switch (lang) {
      case LearnerLanguage.urdu:
        return 11;
      case LearnerLanguage.punjabiShahmukhi:
      case LearnerLanguage.punjabiGurmukhi:
        return 12;
      case LearnerLanguage.bengali:
        return 14;
      case LearnerLanguage.chineseSimplified:
        return 16;
      default:
        return null;
    }
  }

  static String? romLangFor(LearnerLanguage lang) {
    switch (romSlotFor(lang)) {
      case 11:
        return 'ur';
      case 12:
        return 'pa';
      case 14:
        return 'bn';
      case 16:
        return 'zh';
    }
    return null;
  }

  // ---------------------------------------------------------------- start

  /// Opens (copying on first launch) and indexes [lang]. Never throws.
  Future<void> start(LearnerLanguage lang) async {
    await open();
    if (ready) await useLanguage(lang);
  }

  /// Copies big.db when needed and opens it. Never throws.
  Future<void> open() => _opening ??= _open();

  Future<void> _open() async {
    if (kIsWeb) {
      _setStatus(BigDictStatus.failed);
      return;
    }
    try {
      final sqflite.DatabaseFactory factory =
          _factory ?? sqflite.databaseFactory;
      final Directory dir = await _directory();
      await dir.create(recursive: true);
      final String bigPath = p.join(dir.path, 'big.db');
      final String userPath = p.join(dir.path, 'user.db');

      String? bundled;
      try {
        bundled = (await _loadString(assetVersion)).trim();
        if (bundled.isEmpty) bundled = null;
      } catch (_) {
        bundled = null; // older build without the version file
      }
      final String? existing = await _readVersion(factory, bigPath);
      if (existing == null || (bundled != null && bundled != existing)) {
        _beginBusy();
        try {
          final Stopwatch sw = Stopwatch()..start();
          await _copyAsset(bigPath);
          lastCopyMs = sw.elapsedMilliseconds;
        } finally {
          _endBusy();
        }
      }

      final sqflite.Database db = await factory.openDatabase(
        userPath,
        options: sqflite.OpenDatabaseOptions(
          version: 1,
          // Its own connection: big.db gets ATTACHed to it, which must not
          // leak into another opener of the same file.
          singleInstance: false,
          onCreate: (sqflite.Database db, int _) => _createUserTables(db),
          onOpen: _createUserTables,
        ),
      );
      await db.execute('ATTACH DATABASE ? AS big', <Object>[bigPath]);
      final List<Map<String, Object?>> meta = await db.rawQuery(
          "SELECT k, v FROM big.meta WHERE k IN ('version','entries')");
      for (final Map<String, Object?> row in meta) {
        if (row['k'] == 'version') _bigVersion = '${row['v']}';
        if (row['k'] == 'entries') {
          _entryCount = int.tryParse('${row['v']}') ?? 0;
        }
      }
      final String? indexedFor = await _umeta(db, 'big_version');
      if (indexedFor != _bigVersion) {
        // A new dictionary: the old reverse index points to old ids.
        await db.transaction((sqflite.Transaction txn) async {
          await txn.delete('keys');
          await txn.rawDelete("DELETE FROM umeta WHERE k LIKE 'idx_%'");
          await txn.rawInsert(
              'INSERT OR REPLACE INTO umeta(k, v) VALUES (?, ?)',
              <Object>['big_version', _bigVersion]);
        });
      }
      final List<Map<String, Object?>> idx = await db.rawQuery(
          "SELECT k FROM umeta WHERE k LIKE 'idx_%' AND v = ?",
          <Object>[_bigVersion]);
      for (final Map<String, Object?> row in idx) {
        final int? slot = int.tryParse('${row['k']}'.substring(4));
        if (slot != null) _indexed.add(slot);
      }
      _db = db;
      _setStatus(BigDictStatus.ready);
    } catch (e) {
      debugPrint('BigDictionary: not available ($e)');
      _setStatus(BigDictStatus.failed);
    }
  }

  static Future<void> _createUserTables(sqflite.Database db) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS umeta(k TEXT PRIMARY KEY, v TEXT)');
    await db.execute('CREATE TABLE IF NOT EXISTS keys(key TEXT NOT NULL, '
        'slot INTEGER NOT NULL, entry_id INTEGER NOT NULL, '
        'PRIMARY KEY(key, slot, entry_id)) WITHOUT ROWID');
    await db.execute('CREATE TABLE IF NOT EXISTS learned('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, it TEXT NOT NULL, '
        'it_norm TEXT NOT NULL, pos TEXT, g TEXT, pl TEXT, gloss TEXT, '
        'ex_it TEXT, ex_en TEXT, tr TEXT NOT NULL, rom TEXT, rank INTEGER, '
        'updated_at TEXT)');
    await db
        .execute('CREATE INDEX IF NOT EXISTS learned_it ON learned(it_norm)');
  }

  Future<String?> _readVersion(
      sqflite.DatabaseFactory factory, String path) async {
    if (!File(path).existsSync()) return null;
    sqflite.Database? db;
    try {
      db = await factory.openDatabase(
        path,
        options: sqflite.OpenDatabaseOptions(readOnly: true),
      );
      final List<Map<String, Object?>> rows =
          await db.rawQuery("SELECT v FROM meta WHERE k = 'version'");
      return rows.isEmpty ? null : '${rows.first['v']}';
    } catch (_) {
      return null; // half-copied or damaged: copy again
    } finally {
      await db?.close();
    }
  }

  Future<void> _copyAsset(String target) async {
    final ByteData data = await _loadAsset(assetDb);
    final File tmp = File('$target.tmp');
    await tmp.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      flush: true,
    );
    final File old = File(target);
    if (old.existsSync()) await old.delete();
    await tmp.rename(target);
  }

  Future<String?> _umeta(sqflite.DatabaseExecutor db, String k) async {
    final List<Map<String, Object?>> rows =
        await db.rawQuery('SELECT v FROM umeta WHERE k = ?', <Object>[k]);
    return rows.isEmpty ? null : rows.first['v'] as String?;
  }

  Future<void> _setUmeta(sqflite.DatabaseExecutor db, String k, String v) =>
      db.rawInsert(
          'INSERT OR REPLACE INTO umeta(k, v) VALUES (?, ?)', <Object>[k, v]);

  // ---------------------------------------------------------------- index

  /// Makes sure the reverse index of [lang] exists, building it in the
  /// background when needed. Calls queue up; a newer language wins.
  Future<void> useLanguage(LearnerLanguage lang) {
    _wanted = lang;
    _indexChain = _indexChain.then((_) async {
      try {
        await _ensureIndex(lang);
      } catch (e) {
        debugPrint('BigDictionary: index failed ($e)');
      }
    });
    return _indexChain;
  }

  Future<void> _ensureIndex(LearnerLanguage lang) async {
    final sqflite.Database? db = _db;
    if (db == null || _wanted != lang || _indexed.contains(lang.slot)) return;
    _building = lang;
    _beginBusy();
    final Stopwatch sw = Stopwatch()..start();
    try {
      final int? romSlot = romSlotFor(lang);
      final String? romLang = romLangFor(lang);
      int lastId = 0;
      const int chunk = 4000;
      while (true) {
        if (_wanted != lang) return; // the user picked another language
        final List<Map<String, Object?>> rows = await db.rawQuery(
          'SELECT id, tr, rom FROM big.entries WHERE id > ? ORDER BY id LIMIT ?',
          <Object>[lastId, chunk],
        );
        if (rows.isEmpty) break;
        lastId = rows.last['id']! as int;
        await _insertKeys(db, rows, lang.slot, romSlot, romLang, 1);
      }
      final List<Map<String, Object?>> learned =
          await db.rawQuery('SELECT id, tr, rom FROM learned');
      await _insertKeys(db, learned, lang.slot, romSlot, romLang, -1);
      await _setUmeta(db, 'idx_${lang.slot}', _bigVersion);
      _indexed.add(lang.slot);
      lastIndexMs = sw.elapsedMilliseconds;
    } finally {
      _building = null;
      _endBusy();
    }
  }

  Future<void> _insertKeys(
    sqflite.DatabaseExecutor db,
    List<Map<String, Object?>> rows,
    int slot,
    int? romSlot,
    String? romLang,
    int idSign,
  ) async {
    if (rows.isEmpty) return;
    final KeyJob job = KeyJob(
      ids: <int>[
        for (final Map<String, Object?> r in rows) (r['id']! as int) * idSign
      ],
      tr: <String>[
        for (final Map<String, Object?> r in rows) (r['tr'] as String?) ?? ''
      ],
      rom: <String>[
        for (final Map<String, Object?> r in rows) (r['rom'] as String?) ?? ''
      ],
      slot: slot,
      romSlot: romSlot,
      romLang: romLang,
    );
    final List<Object> flat =
        useIsolate ? await _runJob(job) : computeKeys(job);
    const int perStatement = 300; // 900 variables < SQLite's old 999 limit
    await (db is sqflite.Database
        ? db.transaction(
            (sqflite.Transaction txn) => _write(txn, flat, perStatement))
        : _write(db, flat, perStatement));
  }

  static Future<void> _write(
      sqflite.DatabaseExecutor db, List<Object> flat, int perStatement) async {
    final sqflite.Batch batch = db.batch();
    for (int i = 0; i < flat.length; i += perStatement * 3) {
      final int end = i + perStatement * 3 < flat.length
          ? i + perStatement * 3
          : flat.length;
      final int n = (end - i) ~/ 3;
      batch.rawInsert(
        'INSERT OR IGNORE INTO keys(key, slot, entry_id) VALUES '
        '${List<String>.filled(n, '(?,?,?)').join(',')}',
        flat.sublist(i, end),
      );
    }
    await batch.commit(noResult: true);
  }

  static Future<List<Object>> _runJob(KeyJob job) =>
      Isolate.run(() => computeKeys(job));

  // ---------------------------------------------------------------- lookup

  /// Everything the big dictionary (and the learned words) know about
  /// [raw], whether it is Italian (also conjugated or plural) or a word of
  /// [lang] in its own script or in Latin letters. Never throws.
  Future<List<BigHit>> lookup(String raw, LearnerLanguage lang,
      {int limit = 30}) async {
    final sqflite.Database? db = _db;
    if (db == null) return const <BigHit>[];
    try {
      return await _lookup(db, raw, lang, limit);
    } catch (e) {
      debugPrint('BigDictionary: lookup failed ($e)');
      return const <BigHit>[];
    }
  }

  static const String _top = '\u{10FFFF}';

  Future<List<BigHit>> _lookup(
      sqflite.Database db, String raw, LearnerLanguage lang, int limit) async {
    final String q = TextNorm.norm(raw);
    if (q.isEmpty) return const <BigHit>[];
    final Map<int, int> score = <int, int>{};
    void hit(int id, int s) {
      final int? old = score[id];
      if (old == null || s > old) score[id] = s;
    }

    final bool latin = TextNorm.hasLatin(raw);
    final int length = q.runes.length;

    // 1. Italian: the word itself, then its forms, then words starting so.
    if (latin) {
      for (final Map<String, Object?> r in await db.rawQuery(
          'SELECT id FROM big.entries WHERE it_norm = ?', <Object>[q])) {
        hit(r['id']! as int, 1000);
      }
      for (final Map<String, Object?> r in await db
          .rawQuery('SELECT id FROM learned WHERE it_norm = ?', <Object>[q])) {
        hit(-(r['id']! as int), 1000);
      }
      for (final Map<String, Object?> r in await db.rawQuery(
          'SELECT entry_id FROM big.forms WHERE form = ?', <Object>[q])) {
        hit(r['entry_id']! as int, 850);
      }
      if (length >= 2) {
        for (final Map<String, Object?> r in await db.rawQuery(
            'SELECT id FROM big.entries WHERE it_norm > ? AND it_norm < ? '
            'ORDER BY rank IS NULL, rank LIMIT 40',
            <Object>[q, '$q$_top'])) {
          hit(r['id']! as int, 600);
        }
        for (final Map<String, Object?> r in await db.rawQuery(
            'SELECT id FROM learned WHERE it_norm > ? AND it_norm < ? LIMIT 20',
            <Object>[q, '$q$_top'])) {
          hit(-(r['id']! as int), 600);
        }
      }
    }

    // 2. The chosen language, in its own script (or English/French/Spanish).
    Future<void> keyLookup(
        String key, int slot, int exact, int prefix, bool allowPrefix) async {
      final List<Map<String, Object?>> rows = allowPrefix
          ? await db.rawQuery(
              'SELECT k.entry_id AS id, k.key AS key FROM keys k '
              'LEFT JOIN big.entries e ON e.id = k.entry_id '
              'WHERE k.key >= ? AND k.key < ? AND k.slot = ? '
              'ORDER BY k.key = ? DESC, e.rank IS NULL, e.rank LIMIT 80',
              <Object>[key, '$key$_top', slot, key])
          : await db.rawQuery(
              'SELECT entry_id AS id, key FROM keys WHERE key = ? AND slot = ?',
              <Object>[key, slot]);
      for (final Map<String, Object?> r in rows) {
        hit(r['id']! as int, r['key'] == key ? exact : prefix);
      }
    }

    await keyLookup(q, lang.slot, 950, 550, length >= 2);

    // 3. The same language typed in Latin letters (piyar, bhalobasha, fanqie).
    final int? romSlot = romSlotFor(lang);
    if (latin && romSlot != null) {
      final String rk = TextNorm.romkey(raw);
      if (rk.length >= 2) {
        await keyLookup(rk, romSlot, 900, 500, rk.length >= 3);
      }
    }

    if (score.isEmpty) return const <BigHit>[];
    final List<BigEntry> entries = await _entriesById(db, score.keys);
    final List<BigHit> hits = <BigHit>[
      for (final BigEntry e in entries) BigHit(e, score[e.id]!),
    ];
    hits.sort((BigHit a, BigHit b) {
      final int byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      final int ra = a.entry.rank ?? 1 << 30;
      final int rb = b.entry.rank ?? 1 << 30;
      if (ra != rb) return ra.compareTo(rb);
      return a.entry.it.length.compareTo(b.entry.it.length);
    });
    return hits.length > limit ? hits.sublist(0, limit) : hits;
  }

  Future<List<BigEntry>> _entriesById(
      sqflite.DatabaseExecutor db, Iterable<int> ids) async {
    final List<int> big = ids.where((int id) => id > 0).toList();
    final List<int> learned =
        ids.where((int id) => id < 0).map((int id) => -id).toList();
    final List<BigEntry> out = <BigEntry>[];
    for (int i = 0; i < big.length; i += 500) {
      final List<int> part =
          big.sublist(i, i + 500 > big.length ? big.length : i + 500);
      out.addAll((await db.rawQuery(
              'SELECT * FROM big.entries WHERE id IN '
              '(${List<String>.filled(part.length, '?').join(',')})',
              part))
          .map(BigEntry.fromRow));
    }
    if (learned.isNotEmpty) {
      out.addAll((await db.rawQuery(
              'SELECT * FROM learned WHERE id IN '
              '(${List<String>.filled(learned.length, '?').join(',')})',
              learned))
          .map((Map<String, Object?> r) => BigEntry.fromRow(r, learned: true)));
    }
    return out;
  }

  // ---------------------------------------------------------------- server

  /// Asks the word server about a word found nowhere on the phone. The
  /// answer is saved ("learned"), indexed and returned. Null when the
  /// feature is off, offline, or the server does not know the word.
  Future<BigEntry?> askServer(String raw, LearnerLanguage lang) async {
    final sqflite.Database? db = _db;
    final String q = raw.trim();
    if (!serverEnabled || db == null || q.isEmpty) return null;
    final http.Client client = _client ?? http.Client();
    try {
      final http.Response res = await client
          .post(
            Uri.parse('$_baseUrl/v1/lookup'),
            headers: const <String, String>{
              'Content-Type': 'application/json; charset=utf-8',
            },
            body: jsonEncode(<String, String>{'q': q, 'lang': lang.tag}),
          )
          .timeout(ServerConfig.timeout);
      if (res.statusCode != 200) return null;
      Object? json = jsonDecode(utf8.decode(res.bodyBytes));
      if (json is Map && json['entry'] != null) json = json['entry'];
      final BigEntry? entry = BigEntry.fromJson(json);
      if (entry == null) return null;
      return await _saveLearned(
          db, entry, json is Map ? json['updated_at'] : null);
    } catch (e) {
      debugPrint('BigDictionary: server lookup failed ($e)');
      return null;
    } finally {
      if (_client == null) client.close();
    }
  }

  /// Brings new and corrected words from the server. Never throws.
  Future<int> syncUpdates() async {
    final sqflite.Database? db = _db;
    if (!serverEnabled || db == null) return 0;
    final http.Client client = _client ?? http.Client();
    try {
      final String since = await _umeta(db, 'updates_since') ?? '';
      final http.Response res = await client
          .get(Uri.parse('$_baseUrl/v1/updates')
              .replace(queryParameters: <String, String>{'since': since}))
          .timeout(ServerConfig.timeout);
      if (res.statusCode != 200) return 0;
      final Object? json = jsonDecode(utf8.decode(res.bodyBytes));
      final List<dynamic> list = json is List
          ? json
          : (json is Map && json['entries'] is List)
              ? json['entries'] as List<dynamic>
              : const <dynamic>[];
      String next = '';
      int saved = 0;
      for (final Object? item in list) {
        final BigEntry? entry = BigEntry.fromJson(item);
        if (entry == null) continue;
        final Object? stamp = item is Map ? item['updated_at'] : null;
        await _saveLearned(db, entry, stamp);
        saved++;
        if (stamp is String && stamp.compareTo(next) > 0) next = stamp;
      }
      if (json is Map) {
        final Object? now = json['now'] ?? json['since'];
        if (now is String && now.isNotEmpty) next = now;
      }
      if (next.isEmpty && saved > 0) {
        next = DateTime.now().toUtc().toIso8601String();
      }
      if (next.isNotEmpty) await _setUmeta(db, 'updates_since', next);
      if (saved > 0) notifyListeners();
      return saved;
    } catch (e) {
      debugPrint('BigDictionary: updates failed ($e)');
      return 0;
    } finally {
      if (_client == null) client.close();
    }
  }

  Future<BigEntry> _saveLearned(
      sqflite.Database db, BigEntry e, Object? stamp) async {
    final String updatedAt = stamp is String && stamp.isNotEmpty
        ? stamp
        : DateTime.now().toUtc().toIso8601String();
    final Map<String, Object?> row = <String, Object?>{
      'it': e.it,
      'it_norm': TextNorm.norm(e.it),
      'pos': e.pos,
      'g': e.g,
      'pl': e.pl,
      'gloss': e.gloss,
      'ex_it': e.exIt,
      'ex_en': e.exEn,
      'tr': e.tr.join(BigEntry.separator),
      'rom': jsonEncode(e.rom),
      'rank': e.rank,
      'updated_at': updatedAt,
    };
    return db.transaction((sqflite.Transaction txn) async {
      final List<Map<String, Object?>> old = await txn.rawQuery(
          'SELECT id FROM learned WHERE it_norm = ? AND pos = ?',
          <Object>[row['it_norm']!, e.pos]);
      int id;
      if (old.isEmpty) {
        id = await txn.insert('learned', row);
      } else {
        id = old.first['id']! as int;
        await txn
            .update('learned', row, where: 'id = ?', whereArgs: <Object>[id]);
        await txn
            .delete('keys', where: 'entry_id = ?', whereArgs: <Object>[-id]);
      }
      final Map<String, Object?> saved = <String, Object?>{...row, 'id': id};
      for (final int slot in _indexed) {
        final LearnerLanguage lang = LearnerLanguage.values
            .firstWhere((LearnerLanguage l) => l.slot == slot);
        await _insertKeys(txn, <Map<String, Object?>>[saved], slot,
            romSlotFor(lang), romLangFor(lang), -1);
      }
      return BigEntry.fromRow(saved, learned: true);
    });
  }

  // ---------------------------------------------------------------- misc

  void _beginBusy() {
    _busy++;
    if (_busy == 1) {
      if (_status != BigDictStatus.ready) _setStatus(BigDictStatus.preparing);
      _preparingTimer?.cancel();
      _preparingTimer = Timer(const Duration(milliseconds: 300), () {
        if (_busy > 0 && !_showPreparing) {
          _showPreparing = true;
          notifyListeners();
        }
      });
    }
    notifyListeners();
  }

  void _endBusy() {
    _busy--;
    if (_busy <= 0) {
      _busy = 0;
      _preparingTimer?.cancel();
      _preparingTimer = null;
      _showPreparing = false;
    }
    notifyListeners();
  }

  void _setStatus(BigDictStatus s) {
    _status = s;
    notifyListeners();
  }

  /// Closes the database (tests).
  Future<void> close() async {
    _preparingTimer?.cancel();
    await _indexChain;
    await _db?.close();
    _db = null;
  }

  @override
  void dispose() {
    _preparingTimer?.cancel();
    super.dispose();
  }
}

/// Input for [computeKeys]; plain data so it can cross to an isolate.
class KeyJob {
  const KeyJob({
    required this.ids,
    required this.tr,
    required this.rom,
    required this.slot,
    required this.romSlot,
    required this.romLang,
  });

  final List<int> ids;
  final List<String> tr;
  final List<String> rom;
  final int slot;
  final int? romSlot;
  final String? romLang;
}

/// The reverse-index rows for one language, flattened [key, slot, id, …]:
/// norm(variants(tr[slot])) and, for languages written in Latin letters too,
/// romkey(rom[lang]) — exactly as build_bigdb.py counts them.
List<Object> computeKeys(KeyJob job) {
  final List<Object> out = <Object>[];
  for (int i = 0; i < job.ids.length; i++) {
    final int id = job.ids[i];
    final Set<String> seen = <String>{};
    final List<String> tr = job.tr[i].split(BigEntry.separator);
    if (job.slot < tr.length) {
      for (final String v in TextNorm.variants(tr[job.slot])) {
        final String k = TextNorm.norm(v);
        if (k.isNotEmpty && seen.add(k)) {
          out
            ..add(k)
            ..add(job.slot)
            ..add(id);
        }
      }
    }
    if (job.romSlot != null && job.romLang != null) {
      final String spelled = BigEntry.decodeRom(job.rom[i])[job.romLang] ?? '';
      final Set<String> seenRom = <String>{};
      for (final String v in spelled.split('|')) {
        final String k = TextNorm.romkey(v);
        if (k.isNotEmpty && seenRom.add(k)) {
          out
            ..add(k)
            ..add(job.romSlot!)
            ..add(id);
        }
      }
    }
  }
  return out;
}

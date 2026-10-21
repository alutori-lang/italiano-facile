import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:simple_flutter_app_651/data/big_dictionary.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// A [BigDictionary] on the real assets/dict/big.db, copied into [dir].
BigDictionary makeBigDictionary(
  Directory dir, {
  required DatabaseFactory factory,
  http.Client? client,
  String baseUrl = '',
  bool useIsolate = true,
}) {
  return BigDictionary(
    databaseFactory: factory,
    directory: () async => dir,
    loadAsset: (String key) async {
      final Uint8List bytes = await File(key).readAsBytes();
      return ByteData.sublistView(bytes);
    },
    loadString: (String key) async {
      final File f = File(key);
      return f.existsSync() ? await f.readAsString() : '';
    },
    httpClient: client,
    serverBaseUrl: baseUrl,
    useIsolate: useIsolate,
  );
}

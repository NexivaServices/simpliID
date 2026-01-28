import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxes {
  static const settings = 'settings';
  static const secure = 'secure';
}

Future<void> initHive() async {
  await Hive.initFlutter();
  await Hive.openBox(HiveBoxes.settings);

  final key = await _getOrCreateHiveEncryptionKey();
  await Hive.openBox(
    HiveBoxes.secure,
    encryptionCipher: HiveAesCipher(key),
  );
}

const _hiveKeyName = 'hive_aes_key_b64';

Future<Uint8List> _getOrCreateHiveEncryptionKey() async {
  const storage = FlutterSecureStorage();
  final existing = await storage.read(key: _hiveKeyName);
  if (existing != null) {
    return Uint8List.fromList(base64Decode(existing));
  }

  final bytes = List<int>.generate(32, (_) => Random.secure().nextInt(256));
  await storage.write(key: _hiveKeyName, value: base64Encode(bytes));
  return Uint8List.fromList(bytes);
}

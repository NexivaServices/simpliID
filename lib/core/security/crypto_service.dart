import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CryptoService {
  CryptoService(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  static const _keyName = 'simpliid_aes_key_b64';

  Future<enc.Key> _getOrCreateKey() async {
    final existing = await _secureStorage.read(key: _keyName);
    if (existing != null) {
      return enc.Key(base64Decode(existing));
    }

    final bytes = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    final key = enc.Key(Uint8List.fromList(bytes));
    await _secureStorage.write(key: _keyName, value: base64Encode(bytes));
    return key;
  }

  Future<String> encryptString(String plaintext) async {
    final key = await _getOrCreateKey();
    final iv = enc.IV.fromSecureRandom(16);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encrypt(plaintext, iv: iv);

    // Store IV + ciphertext
    final payload = {
      'iv': iv.base64,
      'ct': encrypted.base64,
    };
    return jsonEncode(payload);
  }

  Future<String> decryptString(String payloadJson) async {
    final key = await _getOrCreateKey();
    final payload = jsonDecode(payloadJson) as Map<String, dynamic>;

    final iv = enc.IV.fromBase64(payload['iv'] as String);
    final ct = enc.Encrypted.fromBase64(payload['ct'] as String);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

    return encrypter.decrypt(ct, iv: iv);
  }
}

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static const _keyAlias = 'acf_connect_e2ee_key';

  static Future<encrypt.Key> _getOrGenerateKey() async {
    String? storedKey = await _storage.read(key: _keyAlias);
    if (storedKey == null) {
      final newKey = encrypt.Key.fromSecureRandom(32);
      await _storage.write(key: _keyAlias, value: newKey.base64);
      return newKey;
    }
    return encrypt.Key.fromBase64(storedKey);
  }

  static final _iv = encrypt.IV.fromLength(16);

  static Future<String> encryptText(String text) async {
    final key = await _getOrGenerateKey();
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  static Future<String> decryptText(String encryptedBase64) async {
    try {
      final key = await _getOrGenerateKey();
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter.decrypt64(encryptedBase64, iv: _iv);
      return decrypted;
    } catch (e) {
      return "[Decryption Error]";
    }
  }
}

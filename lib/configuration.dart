import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class Configuration {
  static Configuration _instance;
  static Configuration getInstance() {
    if (_instance == null) {
      _instance = Configuration();
    }
    return _instance;
  }

  final cryptor = PlatformStringCryptor();
  int _fridgeId;
  String _encryptionKey;

  Future getFridgeId() async {
    if (_fridgeId == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _fridgeId = prefs.getInt('fridge_id');
    }
    return _fridgeId;
  }

  Future<String> getEncryptionKey() async {
    return 'STbHC6sDeLE1xoFfkIBzVA==:nr8EOH062hz5SrhAV/+KJJ1JadEi9DkYGeNdSV1Uuy4=';
    if (_encryptionKey == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _encryptionKey = prefs.getString('encryption_key') ??
          await cryptor.generateRandomKey();
      prefs.setString('encryption_key', _encryptionKey);
    }
    print(_encryptionKey);
    return _encryptionKey;
  }
}

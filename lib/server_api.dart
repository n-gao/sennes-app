import 'package:http/http.dart' as http;
import 'response.dart';
import 'request.dart';
import 'dart:convert';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'item.dart';

class ServerApi {
  static ServerApi _instance;
  final cryptor = PlatformStringCryptor();
  String key;
  Future _keySetFuture;

  ServerApi() {
    _keySetFuture = setKey();
  }

  static ServerApi getInstance() {
    if (_instance != null) {
      return _instance;
    }
    return _instance = new ServerApi();
  }

  Future setKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    key = prefs.getString('encryption_key') ?? await generateKey();
    prefs.setString('encryption_key', key);
    print(key);
  }

  Future<String> generateKey() async {
    return await cryptor.generateRandomKey();
  }

  Future<Response> fetchRequest(Request request) async {
    if (key == null) {
      await _keySetFuture;
    }
    var url = 'http:localhost:3000/api?request=';
    var reqString = json.encode(request.toJson());
    final response = await http.get(url + reqString);
    if (response.hashCode == 200) {
      return Response.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to access webserver!');
    }
  }
}

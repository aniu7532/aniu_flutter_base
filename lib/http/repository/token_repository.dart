import 'dart:io' show Platform;

import 'package:musico/http/model/token.dart';
import 'package:musico/http/store_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenRepositoryProtocol {
  Future<void> remove();
  Future<void> saveToken(Token token);
  Future<Token?> fetchToken();
}

class TokenModel implements TokenRepositoryProtocol {
  factory TokenModel() => _instance;

  TokenModel._();

  static late final TokenModel _instance = TokenModel._();

  Token? _token;

  @override
  Future<void> remove() async {
    _token = null;

    if (Platform.isIOS || Platform.isAndroid || Platform.isLinux) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(StoreKey.token.toString());
      } on Exception catch (e) {}
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(StoreKey.token.toString());
    }
  }

  @override
  Future<void> saveToken(Token token) async {
    _token = token;
    if (Platform.isIOS || Platform.isAndroid || Platform.isLinux) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(StoreKey.token.toString(), tokenToJson(token));
      } on Exception catch (e) {}
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(StoreKey.token.toString(), tokenToJson(token));
    }
  }

  @override
  Future<Token?> fetchToken() async {
    String? tokenValue;

    if (Platform.isIOS || Platform.isAndroid || Platform.isLinux) {
      final prefs = await SharedPreferences.getInstance();
      tokenValue = prefs.getString(StoreKey.token.toString());
    } else {
      final prefs = await SharedPreferences.getInstance();
      tokenValue = prefs.getString(StoreKey.token.toString());
    }
    try {
      if (tokenValue != null) {
        _token = tokenFromJson(tokenValue);
      }
    } on Exception catch (e) {
      return _token;
    }

    return _token;
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  bool getBool(String key, {bool defaultValue = false}) =>
      _prefs?.getBool(key) ?? defaultValue;

  Future<bool> setBool(String key, bool value) => _prefs!.setBool(key, value);

  String? getString(String key) => _prefs?.getString(key);

  Future<bool> setString(String key, String value) =>
      _prefs!.setString(key, value);

  Future<bool> remove(String key) => _prefs!.remove(key);
}


import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class MyUtils
{
  static Future<Null> saveSharedPreferences(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
    return null;
  }
  static Future<Null> saveSharedPreferencesInt(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(key, value);
    return null;
  }
  static Future<Null> saveSharedPreferencesBool(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(key, value);
    return null;
  }

  static Future<String?> getSharedPreferences(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? value =  preferences.getString(key);
    return value;
  }
  static Future<int?> getSharedPreferencesInt(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final int? value =  preferences.getInt(key);
    return value;
  }
  static Future<bool?> getSharedPreferencesBool(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final bool? value =  preferences.getBool(key) ;
    return value;
  }
}
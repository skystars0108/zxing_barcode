import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/app_store.dart';

late SharedPreferences sharedPreferences;

Future<void> initializePrefs() async {
  sharedPreferences = await SharedPreferences.getInstance();
  final String themeModeString = getPrefString(
    themeModePref,
    defaultValue: appStore.themeMode.toString(),
  );
  await appStore.setThemeMode(
    ThemeMode.values.firstWhere(
        (ThemeMode element) => element.toString() == themeModeString),
  );
  await appStore.setColorSchemeIndex(
    getPrefInt(colorSchemeIndexPref, defaultValue: appStore.colorSchemeIndex),
  );
  await appStore.toggleSoundMode(
    value: getPrefBool(isSoundOnPref, defaultValue: appStore.isSoundOn),
  );
  await appStore.toggleVibrationMode(
    value: getPrefBool(isVibrationOnPref, defaultValue: appStore.isVibrationOn),
  );
  await appStore.setLanguage(
    getPrefString(languagePref, defaultValue: appStore.selectedLanguage),
  );
}

/// Add a value in SharedPref based on their type - Must be a String, int, bool, double, Map<String, dynamic> or StringList
Future<bool> setPrefValue(String key, dynamic value,
    {bool print = true}) async {
  if (value is String) {
    return sharedPreferences.setString(key, value);
  } else if (value is int) {
    return sharedPreferences.setInt(key, value);
  } else if (value is bool) {
    return sharedPreferences.setBool(key, value);
  } else if (value is double) {
    return sharedPreferences.setDouble(key, value);
  } else if (value is Map<String, dynamic>) {
    return sharedPreferences.setString(key, jsonEncode(value));
  } else if (value is List<String>) {
    return sharedPreferences.setStringList(key, value);
  } else {
    throw ArgumentError(
      'Invalid value ${value.runtimeType} - Must be a String, int, bool, double, Map<String, dynamic> or StringList',
    );
  }
}

/// Returns List of Keys that matches with given Key
List<String> getMatchingSharedPrefKeys(String key) {
  final List<String> keys = <String>[];
  sharedPreferences.getKeys().forEach((String element) {
    if (element.contains(key)) {
      keys.add(element);
    }
  });
  return keys;
}

/// Returns a StringList if exists in SharedPref
List<String>? getPrefStringList(String key) =>
    sharedPreferences.getStringList(key);

/// Returns a Bool if exists in SharedPref
bool getPrefBool(String key, {bool defaultValue = false}) =>
    sharedPreferences.getBool(key) ?? defaultValue;

/// Returns a Double if exists in SharedPref
double getPrefDouble(String key, {double defaultValue = 0.0}) =>
    sharedPreferences.getDouble(key) ?? defaultValue;

/// Returns a Int if exists in SharedPref
int getPrefInt(String key, {int defaultValue = 0}) =>
    sharedPreferences.getInt(key) ?? defaultValue;

/// Returns a String if exists in SharedPref
String getPrefString(String key, {String defaultValue = ''}) =>
    sharedPreferences.getString(key) ?? defaultValue;

/// Returns a JSON if exists in SharedPref
Map<String, dynamic> getPrefJSON(String key,
    {Map<String, dynamic>? defaultValue}) {
  if (sharedPreferences.containsKey(key)) {
    return jsonDecode(sharedPreferences.getString(key) ?? '');
  } else {
    return defaultValue ?? <String, dynamic>{};
  }
}

/// remove key from SharedPref
Future<bool> removePrefKey(String key) async => sharedPreferences.remove(key);

/// clear SharedPref
Future<bool> clearSharedPref() async => sharedPreferences.clear();

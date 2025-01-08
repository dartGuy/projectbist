// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class AppCache {
//   ThemeMode? themeMode;
//   String? username;

//   AppCache({this.themeMode = ThemeMode.system, this.username});

//   // Factory constructor to create an instance from a Map
//   factory AppCache.fromJson(Map<String, dynamic> json) {
//     return AppCache(
//       themeMode: _parseThemeMode(json['themeMode']),
//       username: json['username'],
//     );
//   }

//   // Convert the object to a Map
//   Map<String, dynamic> toJson() {
//     return {
//       'themeMode': _themeModeToString(themeMode!),
//       'username': username,
//     };
//   }

//   // Helper method to parse ThemeMode from a String
//   static ThemeMode _parseThemeMode(String themeModeString) {
//     switch (themeModeString) {
//       case 'light':
//         return ThemeMode.light;
//       case 'dark':
//         return ThemeMode.dark;
//       case 'system':
//         return ThemeMode.system;
//       default:
//         return ThemeMode.system;
//     }
//   }

//   // Helper method to convert ThemeMode to String
//   static String _themeModeToString(ThemeMode themeMode) {
//     switch (themeMode) {
//       case ThemeMode.light:
//         return 'light';
//       case ThemeMode.dark:
//         return 'dark';
//       case ThemeMode.system:
//         return 'system';
//     }
//   }
// }

// class StorageService {
//   final _storage = const FlutterSecureStorage();
//   final _appCacheKey = 'appCache';
//   final ValueNotifier<StorageService?> data = ValueNotifier(null);
//   // StorageService() {
//   //   data.value = StorageService();
//   // }
//   Future<void> saveAppCache(AppCache appCache) async {
//     final jsonString = appCache.toJson().toString();
//     await _storage.write(key: _appCacheKey, value: jsonString);
//   }

//   Future<AppCache?> loadAppCache() async {
//     final jsonString = await _storage.read(key: _appCacheKey);
//     if (jsonString != null) {
//       final Map<String, dynamic> jsonMap =
//           Map.castFrom<dynamic, dynamic, String, dynamic>(
//               json.decode(jsonString));

//       return AppCache.fromJson(jsonMap);
//     }
//     return null;
//   }

//   Future<void> clearAppCache() async {
//     await _storage.delete(key: _appCach eKey);
//   }
// }
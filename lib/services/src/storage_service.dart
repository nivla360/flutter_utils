import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage service that provides a high-level API for various storage operations
/// Reduces repetitive SharedPreferences code with type-safe operations
class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._internal();
  
  StorageService._internal();
  
  SharedPreferences? _prefs;
  final Logger _logger = Logger();
  
  /// Initialize the storage service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw StateError('StorageService not initialized. Call initialize() first.');
    }
    return _prefs!;
  }
  
  // String operations
  
  /// Save a string value
  Future<bool> setString(String key, String value) async {
    try {
      return await _preferences.setString(key, value);
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error saving string to storage: $e');
      }
      return false;
    }
  }
  
  /// Get a string value
  String? getString(String key, [String? defaultValue]) {
    try {
      return _preferences.getString(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error getting string from storage: $e');
      }
      return defaultValue;
    }
  }
  
  /// Get a string value with non-null guarantee
  String getStringOrDefault(String key, String defaultValue) {
    return getString(key, defaultValue) ?? defaultValue;
  }
  
  // Integer operations
  
  /// Save an integer value
  Future<bool> setInt(String key, int value) async {
    try {
      return await _preferences.setInt(key, value);
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error saving int to storage: $e');
      }
      return false;
    }
  }
  
  /// Get an integer value
  int? getInt(String key, [int? defaultValue]) {
    try {
      return _preferences.getInt(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error getting int from storage: $e');
      }
      return defaultValue;
    }
  }
  
  /// Get an integer value with non-null guarantee
  int getIntOrDefault(String key, int defaultValue) {
    return getInt(key, defaultValue) ?? defaultValue;
  }
  
  // Double operations
  
  /// Save a double value
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _preferences.setDouble(key, value);
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error saving double to storage: $e');
      }
      return false;
    }
  }
  
  /// Get a double value
  double? getDouble(String key, [double? defaultValue]) {
    try {
      return _preferences.getDouble(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error getting double from storage: $e');
      }
      return defaultValue;
    }
  }
  
  /// Get a double value with non-null guarantee
  double getDoubleOrDefault(String key, double defaultValue) {
    return getDouble(key, defaultValue) ?? defaultValue;
  }
  
  // Boolean operations
  
  /// Save a boolean value
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _preferences.setBool(key, value);
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error saving bool to storage: $e');
      }
      return false;
    }
  }
  
  /// Get a boolean value
  bool? getBool(String key, [bool? defaultValue]) {
    try {
      return _preferences.getBool(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error getting bool from storage: $e');
      }
      return defaultValue;
    }
  }
  
  /// Get a boolean value with non-null guarantee
  bool getBoolOrDefault(String key, bool defaultValue) {
    return getBool(key, defaultValue) ?? defaultValue;
  }
  
  // List operations
  
  /// Save a list of strings
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _preferences.setStringList(key, value);
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error saving string list to storage: $e');
      }
      return false;
    }
  }
  
  /// Get a list of strings
  List<String>? getStringList(String key, [List<String>? defaultValue]) {
    try {
      return _preferences.getStringList(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error getting string list from storage: $e');
      }
      return defaultValue;
    }
  }
  
  /// Get a list of strings with non-null guarantee
  List<String> getStringListOrDefault(String key, List<String> defaultValue) {
    return getStringList(key, defaultValue) ?? defaultValue;
  }
  
  // JSON operations (for complex objects)
  
  /// Save a JSON serializable object
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      return await setString(key, jsonString);
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error saving JSON to storage: $e');
      }
      return false;
    }
  }
  
  /// Get a JSON object as Map
  Map<String, dynamic>? getJson(String key, [Map<String, dynamic>? defaultValue]) {
    try {
      final jsonString = getString(key);
      if (jsonString == null) return defaultValue;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error getting JSON from storage: $e');
      }
      return defaultValue;
    }
  }
  
  /// Get a JSON object with non-null guarantee
  Map<String, dynamic> getJsonOrDefault(String key, Map<String, dynamic> defaultValue) {
    return getJson(key, defaultValue) ?? defaultValue;
  }
  
  /// Save a list of JSON objects
  Future<bool> setJsonList(String key, List<Map<String, dynamic>> value) async {
    try {
      final jsonString = jsonEncode(value);
      return await setString(key, jsonString);
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error saving JSON list to storage: $e');
      }
      return false;
    }
  }
  
  /// Get a list of JSON objects
  List<Map<String, dynamic>>? getJsonList(String key, [List<Map<String, dynamic>>? defaultValue]) {
    try {
      final jsonString = getString(key);
      if (jsonString == null) return defaultValue;
      final decoded = jsonDecode(jsonString) as List;
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error getting JSON list from storage: $e');
      }
      return defaultValue;
    }
  }
  
  /// Get a list of JSON objects with non-null guarantee
  List<Map<String, dynamic>> getJsonListOrDefault(String key, List<Map<String, dynamic>> defaultValue) {
    return getJsonList(key, defaultValue) ?? defaultValue;
  }
  
  // Generic type-safe operations
  
  /// Save any JSON serializable object with type safety
  Future<bool> setObject<T>(String key, T value, T Function(Map<String, dynamic>) fromJson, Map<String, dynamic> Function(T) toJson) async {
    try {
      final json = toJson(value);
      return await setJson(key, json);
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error saving object to storage: $e');
      }
      return false;
    }
  }
  
  /// Get a typed object from storage
  T? getObject<T>(String key, T Function(Map<String, dynamic>) fromJson, [T? defaultValue]) {
    try {
      final json = getJson(key);
      if (json == null) return defaultValue;
      return fromJson(json);
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error getting object from storage: $e');
      }
      return defaultValue;
    }
  }
  
  /// Save a list of typed objects
  Future<bool> setObjectList<T>(String key, List<T> value, Map<String, dynamic> Function(T) toJson) async {
    try {
      final jsonList = value.map((item) => toJson(item)).toList();
      return await setJsonList(key, jsonList);
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error saving object list to storage: $e');
      }
      return false;
    }
  }
  
  /// Get a list of typed objects
  List<T>? getObjectList<T>(String key, T Function(Map<String, dynamic>) fromJson, [List<T>? defaultValue]) {
    try {
      final jsonList = getJsonList(key);
      if (jsonList == null) return defaultValue;
      return jsonList.map((json) => fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error getting object list from storage: $e');
      }
      return defaultValue;
    }
  }
  
  // Utility operations
  
  /// Check if a key exists
  bool hasKey(String key) {
    return _preferences.containsKey(key);
  }
  
  /// Remove a key
  Future<bool> remove(String key) async {
    try {
      return await _preferences.remove(key);
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error removing key from storage: $e');
      }
      return false;
    }
  }
  
  /// Clear all data
  Future<bool> clear() async {
    try {
      return await _preferences.clear();
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error clearing storage: $e');
      }
      return false;
    }
  }
  
  /// Get all keys
  Set<String> getAllKeys() {
    return _preferences.getKeys();
  }
  
  /// Get keys with a specific prefix
  Set<String> getKeysWithPrefix(String prefix) {
    return _preferences.getKeys().where((key) => key.startsWith(prefix)).toSet();
  }
  
  /// Remove all keys with a specific prefix
  Future<bool> removeKeysWithPrefix(String prefix) async {
    try {
      final keysToRemove = getKeysWithPrefix(prefix);
      for (final key in keysToRemove) {
        await _preferences.remove(key);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Error removing keys with prefix: $e');
      }
      return false;
    }
  }
  
  /// Get storage size (approximate, in bytes)
  int getStorageSize() {
    int totalSize = 0;
    for (final key in _preferences.getKeys()) {
      final value = _preferences.get(key);
      if (value != null) {
        totalSize += key.length * 2; // UTF-16 encoding
        if (value is String) {
          totalSize += value.length * 2;
        } else if (value is List<String>) {
          totalSize += value.fold(0, (sum, item) => sum + item.length * 2);
        } else {
          totalSize += 8; // Approximate size for numbers/booleans
        }
      }
    }
    return totalSize;
  }
  
  /// Format storage size in human readable format
  String getFormattedStorageSize() {
    final bytes = getStorageSize();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Convenient extensions for common storage patterns
extension StorageExtensions on StorageService {
  
  /// User preferences namespace
  Future<bool> setUserPreference(String key, dynamic value) async {
    return await _setWithPrefix('user_pref_', key, value);
  }
  
  dynamic getUserPreference(String key, [dynamic defaultValue]) {
    return _getWithPrefix('user_pref_', key, defaultValue);
  }
  
  /// App settings namespace
  Future<bool> setAppSetting(String key, dynamic value) async {
    return await _setWithPrefix('app_setting_', key, value);
  }
  
  dynamic getAppSetting(String key, [dynamic defaultValue]) {
    return _getWithPrefix('app_setting_', key, defaultValue);
  }
  
  /// Cache namespace with TTL support
  Future<bool> setCache(String key, dynamic value, {Duration? ttl}) async {
    final cacheKey = 'cache_$key';
    final success = await _setWithPrefix('cache_', key, value);
    
    if (success && ttl != null) {
      final expiryTime = DateTime.now().add(ttl).millisecondsSinceEpoch;
      await setInt('${cacheKey}_expiry', expiryTime);
    }
    
    return success;
  }
  
  dynamic getCache(String key, [dynamic defaultValue]) {
    final cacheKey = 'cache_$key';
    final expiryTime = getInt('${cacheKey}_expiry');
    
    if (expiryTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now > expiryTime) {
        // Cache expired, remove it
        remove(cacheKey);
        remove('${cacheKey}_expiry');
        return defaultValue;
      }
    }
    
    return _getWithPrefix('cache_', key, defaultValue);
  }
  
  /// Clear expired cache entries
  Future<void> clearExpiredCache() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final expiredKeys = <String>[];
    
    for (final key in getAllKeys()) {
      if (key.endsWith('_expiry')) {
        final expiryTime = getInt(key);
        if (expiryTime != null && now > expiryTime) {
          final cacheKey = key.substring(0, key.length - '_expiry'.length);
          expiredKeys.add(cacheKey);
          expiredKeys.add(key);
        }
      }
    }
    
    for (final key in expiredKeys) {
      await remove(key);
    }
  }
  
  Future<bool> _setWithPrefix(String prefix, String key, dynamic value) async {
    final fullKey = '$prefix$key';
    if (value is String) return await setString(fullKey, value);
    if (value is int) return await setInt(fullKey, value);
    if (value is double) return await setDouble(fullKey, value);
    if (value is bool) return await setBool(fullKey, value);
    if (value is List<String>) return await setStringList(fullKey, value);
    if (value is Map<String, dynamic>) return await setJson(fullKey, value);
    
    // Try to encode as JSON as fallback
    try {
      final json = {'value': value};
      return await setJson(fullKey, json);
    } catch (e) {
      return false;
    }
  }
  
  dynamic _getWithPrefix(String prefix, String key, [dynamic defaultValue]) {
    final fullKey = '$prefix$key';
    
    if (defaultValue is String || defaultValue == null) {
      return getString(fullKey, defaultValue as String?);
    }
    if (defaultValue is int) return getInt(fullKey, defaultValue);
    if (defaultValue is double) return getDouble(fullKey, defaultValue);
    if (defaultValue is bool) return getBool(fullKey, defaultValue);
    if (defaultValue is List<String>) return getStringList(fullKey, defaultValue);
    if (defaultValue is Map<String, dynamic>) return getJson(fullKey, defaultValue);
    
    // Try to decode from JSON as fallback
    try {
      final json = getJson(fullKey);
      return json?['value'] ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }
}
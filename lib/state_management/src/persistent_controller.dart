import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'root_controller.dart';

/// A mixin that provides automatic state persistence capabilities to controllers
/// Automatically saves and restores controller state using SharedPreferences
mixin PersistentStateMixin on RootController {
  /// The unique key used to store this controller's state
  String get persistenceKey;
  
  /// Whether to automatically save state on every notifyListeners call
  bool get autoSave => true;
  
  /// How long to debounce save operations (in milliseconds)
  /// Prevents excessive saves during rapid state changes
  int get saveDebounceMs => 300;
  
  late final SharedPreferences _prefs;
  bool _isInitialized = false;
  String? _debouncerKey;
  
  /// Initialize the persistence system
  /// This should be called in the controller's onInit method
  @protected
  Future<void> initializePersistence() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      await _loadState();
    }
  }
  
  /// Convert the controller state to a JSON-serializable map
  /// Override this method to define what state should be persisted
  Map<String, dynamic> toJson();
  
  /// Restore the controller state from a JSON map
  /// Override this method to define how state should be restored
  void fromJson(Map<String, dynamic> json);
  
  /// Save the current state to persistent storage
  Future<void> saveState() async {
    if (!_isInitialized) return;
    
    try {
      final json = toJson();
      final jsonString = jsonEncode(json);
      await _prefs.setString(persistenceKey, jsonString);
    } catch (e) {
      debugPrint('Failed to save controller state: $e');
    }
  }
  
  /// Load state from persistent storage
  Future<void> _loadState() async {
    try {
      final jsonString = _prefs.getString(persistenceKey);
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        fromJson(json);
      }
    } catch (e) {
      debugPrint('Failed to load controller state: $e');
    }
  }
  
  /// Clear the persisted state
  Future<void> clearPersistedState() async {
    if (_isInitialized) {
      await _prefs.remove(persistenceKey);
    }
  }
  
  /// Save state with debouncing to prevent excessive saves
  void _debouncedSave() {
    final currentKey = DateTime.now().millisecondsSinceEpoch.toString();
    _debouncerKey = currentKey;
    
    Future.delayed(Duration(milliseconds: saveDebounceMs), () {
      if (_debouncerKey == currentKey) {
        saveState();
      }
    });
  }
  
  @override
  void notifyListeners() {
    super.notifyListeners();
    if (autoSave && _isInitialized) {
      _debouncedSave();
    }
  }
}

/// A base class for controllers that need state persistence
/// Combines RootController with automatic state persistence
abstract class PersistentController extends RootController with PersistentStateMixin {
  
  @override
  void onInit() {
    super.onInit();
    // Initialize persistence after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializePersistence();
    });
  }
}

/// A utility class for managing multiple controller states
class ControllerStateManager {
  static final ControllerStateManager _instance = ControllerStateManager._internal();
  factory ControllerStateManager() => _instance;
  ControllerStateManager._internal();
  
  late final SharedPreferences _prefs;
  bool _isInitialized = false;
  
  /// Initialize the state manager
  Future<void> initialize() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }
  
  /// Save state for a specific controller
  Future<void> saveControllerState(String key, Map<String, dynamic> state) async {
    await initialize();
    try {
      final jsonString = jsonEncode(state);
      await _prefs.setString('controller_$key', jsonString);
    } catch (e) {
      debugPrint('Failed to save controller state for $key: $e');
    }
  }
  
  /// Load state for a specific controller
  Future<Map<String, dynamic>?> loadControllerState(String key) async {
    await initialize();
    try {
      final jsonString = _prefs.getString('controller_$key');
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Failed to load controller state for $key: $e');
    }
    return null;
  }
  
  /// Clear state for a specific controller
  Future<void> clearControllerState(String key) async {
    await initialize();
    await _prefs.remove('controller_$key');
  }
  
  /// Clear all controller states
  Future<void> clearAllControllerStates() async {
    await initialize();
    final keys = _prefs.getKeys().where((key) => key.startsWith('controller_'));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
  
  /// Get all controller state keys
  Future<List<String>> getAllControllerKeys() async {
    await initialize();
    return _prefs.getKeys()
        .where((key) => key.startsWith('controller_'))
        .map((key) => key.substring('controller_'.length))
        .toList();
  }
}

/// An extension on RootController that provides quick persistence methods
extension ControllerPersistenceExt on RootController {
  
  /// Save a simple key-value state
  Future<void> saveSimpleState(String key, dynamic value) async {
    final manager = ControllerStateManager();
    await manager.saveControllerState(runtimeType.toString(), {key: value});
  }
  
  /// Load a simple key-value state
  Future<T?> loadSimpleState<T>(String key) async {
    final manager = ControllerStateManager();
    final state = await manager.loadControllerState(runtimeType.toString());
    return state?[key] as T?;
  }
}
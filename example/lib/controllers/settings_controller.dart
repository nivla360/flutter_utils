import 'package:flutter_utils/flutter_utils.dart';

/// Demonstrates PersistentController with app settings
class SettingsController extends PersistentController {
  @override
  String get persistenceKey => 'app_settings';
  
  // Private fields
  bool _isDarkMode = false;
  String _language = 'en';
  bool _notificationsEnabled = true;
  bool _autoSave = true;
  double _fontSize = 16.0;
  String _theme = 'system';
  
  // Getters
  bool get isDarkMode => _isDarkMode;
  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  @override
  bool get autoSave => _autoSave;
  double get fontSize => _fontSize;
  String get theme => _theme;
  
  // Available options
  List<String> get availableLanguages => ['en', 'es', 'fr', 'de', 'it'];
  List<String> get availableThemes => ['system', 'light', 'dark'];
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': _isDarkMode,
      'language': _language,
      'notificationsEnabled': _notificationsEnabled,
      'autoSave': _autoSave,
      'fontSize': _fontSize,
      'theme': _theme,
    };
  }
  
  @override
  void fromJson(Map<String, dynamic> json) {
    _isDarkMode = json['isDarkMode'] as bool? ?? false;
    _language = json['language'] as String? ?? 'en';
    _notificationsEnabled = json['notificationsEnabled'] as bool? ?? true;
    _autoSave = json['autoSave'] as bool? ?? true;
    _fontSize = (json['fontSize'] as num?)?.toDouble() ?? 16.0;
    _theme = json['theme'] as String? ?? 'system';
  }
  
  /// Toggle dark mode
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Auto-saves due to autoSave = true
  }
  
  /// Set language
  void setLanguage(String language) {
    if (availableLanguages.contains(language)) {
      _language = language;
      notifyListeners();
    }
  }
  
  /// Toggle notifications
  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }
  
  /// Toggle auto-save
  void toggleAutoSave() {
    _autoSave = !_autoSave;
    notifyListeners();
  }
  
  /// Set font size
  void setFontSize(double size) {
    if (size >= 12.0 && size <= 24.0) {
      _fontSize = size;
      notifyListeners();
    }
  }
  
  /// Set theme
  void setTheme(String theme) {
    if (availableThemes.contains(theme)) {
      _theme = theme;
      notifyListeners();
    }
  }
  
  /// Reset to defaults
  void resetToDefaults() {
    _isDarkMode = false;
    _language = 'en';
    _notificationsEnabled = true;
    _autoSave = true;
    _fontSize = 16.0;
    _theme = 'system';
    notifyListeners();
  }
  
  /// Get settings summary
  Map<String, dynamic> getSettingsSummary() {
    return {
      'Dark Mode': _isDarkMode ? 'Enabled' : 'Disabled',
      'Language': _getLanguageName(_language),
      'Notifications': _notificationsEnabled ? 'Enabled' : 'Disabled',
      'Auto Save': _autoSave ? 'Enabled' : 'Disabled',
      'Font Size': '${_fontSize.toStringAsFixed(0)}px',
      'Theme': _theme.toUpperCase(),
    };
  }
  
  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French';
      case 'de':
        return 'German';
      case 'it':
        return 'Italian';
      default:
        return 'Unknown';
    }
  }
}
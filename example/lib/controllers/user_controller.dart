import 'package:flutter/foundation.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:example/models/example_models.dart';
import 'package:example/services/example_services.dart';

/// Demonstrates AsyncController usage with user data management
class UserController extends AsyncController<List<User>> {
  final MockApiService _apiService = GetIt.instance<MockApiService>();
  
  List<User> _users = [];
  User? _selectedUser;
  
  List<User> get users => _users;
  User? get selectedUser => _selectedUser;
  
  @override
  void onReady() {
    super.onReady();
    loadUsers(); // Auto-load when ready
  }
  
  /// Load all users with async state management
  Future<void> loadUsers({int limit = 20}) async {
    await executeAsync(
      () async {
        final users = await _apiService.getUsers(limit: limit);
        _users = users;
        return users;
      },
      onSuccess: (users) {
        if (kDebugMode) {
          logInfo('✅ Loaded ${users.length} users successfully');
        }
      },
      onError: (error, stackTrace) {
        if (kDebugMode) {
          logError('❌ Failed to load users: $error');
        }
      },
    );
  }
  
  /// Load more users (pagination example)
  Future<void> loadMoreUsers() async {
    if (isLoading) return; // Prevent multiple calls
    
    final currentPage = (_users.length ~/ 20) + 1;
    
    await executeSilently( // Use executeSilently to not show loading state
      () async {
        final newUsers = await _apiService.getUsers(limit: 20, page: currentPage);
        _users.addAll(newUsers);
        return _users;
      },
      onSuccess: (users) {
        if (kDebugMode) {
          logInfo('✅ Loaded page $currentPage - Total users: ${users.length}');
        }
        notifyListeners(); // Manually notify since we used executeSilently
      },
    );
  }
  
  /// Select a specific user by ID
  Future<void> selectUser(String userId) async {
    await executeAsync(
      () async {
        final user = await _apiService.getUserById(userId);
        _selectedUser = user;
        return user != null ? [user] : <User>[]; // Return as list to match controller type
      },
      onSuccess: (users) {
        if (kDebugMode) {
          logInfo('✅ Selected user: ${_selectedUser?.name}');
        }
      },
    );
  }
  
  /// Search users by name (local search)
  List<User> searchUsers(String query) {
    if (query.isEmpty) return _users;
    
    return _users
        .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
  
  /// Filter users by active status
  List<User> getActiveUsers() {
    return _users.where((user) => user.isActive).toList();
  }
  
  /// Get user statistics
  Map<String, dynamic> getUserStats() {
    final activeCount = _users.where((user) => user.isActive).length;
    final inactiveCount = _users.length - activeCount;
    
    return {
      'total': _users.length,
      'active': activeCount,
      'inactive': inactiveCount,
      'percentage_active': _users.isNotEmpty ? (activeCount / _users.length * 100).round() : 0,
    };
  }
  
  /// Refresh users data
  Future<void> refreshUsers() async {
    _users.clear();
    _selectedUser = null;
    await loadUsers();
  }
  
  /// Clear all user data
  void clearUsers() {
    _users.clear();
    _selectedUser = null;
    reset(); // Reset async state
  }
}
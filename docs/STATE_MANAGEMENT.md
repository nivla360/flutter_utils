# State Management Guide

Flutter Utils provides a modern, powerful state management system that eliminates boilerplate while providing advanced features like async state handling and automatic persistence.

## Table of Contents

- [Quick Start](#quick-start)
- [AsyncController](#asynccontroller)
- [PersistentController](#persistentcontroller)
- [ReactiveWidget](#reactivewidget)
- [AsyncBuilder](#asyncbuilder)
- [Lifecycle Management](#lifecycle-management)
- [Best Practices](#best-practices)

## Quick Start

### Basic Controller Setup

```dart
class UserController extends AsyncController<User> {
  Future<void> loadUser(String userId) async {
    await executeAsync(() => UserService.getUser(userId));
  }
}

// Register with GetIt
final getIt = GetIt.instance;
getIt.registerSingleton(UserController());
```

### Using in Widgets

```dart
// Option 1: AsyncBuilder (Recommended)
AsyncBuilder<UserController>(
  controller: GetIt.instance<UserController>(),
  onLoading: (context, controller) => CircularProgressIndicator(),
  onSuccess: (context, controller) => Text(controller.data?.name ?? ''),
  onError: (context, controller) => Text('Error: ${controller.errorMessage}'),
)

// Option 2: ReactiveWidget
ReactiveWidget<UserController>(
  builder: (context, controller) {
    if (controller.isLoading) return CircularProgressIndicator();
    if (controller.hasError) return Text('Error: ${controller.errorMessage}');
    return Text(controller.data?.name ?? '');
  },
)
```

## AsyncController

The `AsyncController` provides automatic async state management with loading, success, and error states.

### Basic Usage

```dart
class PostsController extends AsyncController<List<Post>> {
  final ApiService _apiService = ApiService();
  
  @override
  void onReady() {
    loadPosts(); // Auto-load when controller is ready
    super.onReady();
  }
  
  Future<void> loadPosts() async {
    await executeAsync(
      () => _apiService.get<List<Post>>('/posts'),
      onSuccess: (posts) => print('Loaded ${posts.length} posts'),
      onError: (error, stackTrace) => print('Failed to load posts: $error'),
    );
  }
  
  Future<void> refreshPosts() async {
    await executeAsync(() => _apiService.get<List<Post>>('/posts'));
  }
  
  Future<void> createPost(Post post) async {
    await executeAsync(() => _apiService.post('/posts', body: post.toJson()));
    if (isSuccess) {
      loadPosts(); // Reload after creation
    }
  }
}
```

### Advanced Features

```dart
class AdvancedController extends AsyncController<Data> {
  
  // Execute without changing loading state (background operations)
  Future<void> backgroundSync() async {
    await executeSilently(
      () => SyncService.syncInBackground(),
      onSuccess: (result) => print('Background sync completed'),
    );
  }
  
  // Manual state management
  void handleCustomLogic() {
    setLoading();
    try {
      // Your custom logic
      final result = performComplexOperation();
      setData(result);
    } catch (e) {
      setError(e);
    }
  }
  
  // Reset state
  void clearData() {
    reset(); // Returns to idle state
  }
}
```

### State Properties

```dart
// State checking
controller.isLoading;    // Currently loading
controller.isSuccess;    // Last operation succeeded
controller.hasError;     // Has error
controller.isIdle;       // No operations performed
controller.hasData;      // Has data

// Data access
controller.data;         // The loaded data (nullable)
controller.error;        // Raw error object
controller.errorMessage; // String error message
controller.stackTrace;   // Error stack trace
```

## PersistentController

Extends `RootController` with automatic state persistence using SharedPreferences.

### Basic Usage

```dart
class SettingsController extends PersistentController {
  @override
  String get persistenceKey => 'app_settings';
  
  bool _isDarkMode = false;
  String _language = 'en';
  
  bool get isDarkMode => _isDarkMode;
  String get language => _language;
  
  @override
  Map<String, dynamic> toJson() => {
    'isDarkMode': _isDarkMode,
    'language': _language,
  };
  
  @override
  void fromJson(Map<String, dynamic> json) {
    _isDarkMode = json['isDarkMode'] ?? false;
    _language = json['language'] ?? 'en';
  }
  
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Auto-saves due to autoSave = true
  }
  
  void setLanguage(String newLanguage) {
    _language = newLanguage;
    notifyListeners();
  }
}
```

### Manual Save/Load

```dart
class ManualPersistenceController extends PersistentController {
  @override
  bool get autoSave => false; // Disable auto-save
  
  @override
  int get saveDebounceMs => 500; // Custom debounce time
  
  // ... implementation
  
  Future<void> saveSettings() async {
    await saveState(); // Manual save
  }
  
  Future<void> resetSettings() async {
    await clearPersistedState(); // Clear saved state
    // Reset to defaults
    _resetToDefaults();
    notifyListeners();
  }
}
```

### Using Mixin with Existing Controllers

```dart
class UserController extends AsyncController<User> with PersistentStateMixin {
  @override
  String get persistenceKey => 'user_controller';
  
  String _selectedUserId = '';
  
  @override
  Map<String, dynamic> toJson() => {
    'selectedUserId': _selectedUserId,
  };
  
  @override
  void fromJson(Map<String, dynamic> json) {
    _selectedUserId = json['selectedUserId'] ?? '';
  }
  
  @override
  void onInit() {
    super.onInit();
    initializePersistence(); // Initialize persistence
  }
}
```

## ReactiveWidget

Rebuilds when the controller notifies listeners.

### Basic Usage

```dart
ReactiveWidget<CounterController>(
  builder: (context, controller) {
    return Column(
      children: [
        Text('Count: ${controller.count}'),
        ElevatedButton(
          onPressed: controller.increment,
          child: Text('Increment'),
        ),
      ],
    );
  },
)
```

### Multiple Controllers

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReactiveWidget<UserController>(
          builder: (context, userController) => Text(userController.username),
        ),
        ReactiveWidget<SettingsController>(
          builder: (context, settingsController) => Switch(
            value: settingsController.isDarkMode,
            onChanged: settingsController.toggleDarkMode,
          ),
        ),
      ],
    );
  }
}
```

## AsyncBuilder

Declarative way to handle async states with different builders for each state.

### Complete Example

```dart
AsyncBuilder<PostsController>(
  controller: GetIt.instance<PostsController>(),
  onIdle: (context, controller) => Text('No posts loaded yet'),
  onLoading: (context, controller) => Column(
    children: List.generate(5, (index) => 
      SkeletonLayouts.listTile(showAvatar: true)
    ),
  ),
  onSuccess: (context, controller) => ListView.builder(
    itemCount: controller.data?.length ?? 0,
    itemBuilder: (context, index) {
      final post = controller.data![index];
      return ListTile(
        title: Text(post.title),
        subtitle: Text(post.excerpt),
        onTap: () => navigateToPost(post),
      );
    },
  ),
  onError: (context, controller) => Column(
    children: [
      Icon(Icons.error, color: Colors.red),
      Text(controller.errorMessage ?? 'Unknown error'),
      ElevatedButton(
        onPressed: controller.retry,
        child: Text('Retry'),
      ),
    ],
  ),
)
```

## Lifecycle Management

### Controller Lifecycle

```dart
class LifecycleController extends RootController {
  @override
  void onInit() {
    super.onInit();
    print('Controller initialized');
    // Setup initial state, listeners, etc.
  }
  
  @override
  void onReady() {
    super.onReady();
    print('Widget tree is built, safe to use context');
    // Perform operations that need the widget tree
    loadInitialData();
  }
  
  @override
  void dispose() {
    print('Controller disposed');
    // Cleanup resources
    super.dispose();
  }
}
```

### App Lifecycle Monitoring

```dart
class AppController extends FullLifeCycleController with FullLifeCycleMixin {
  @override
  void onResumed() => print('App resumed');
  
  @override
  void onPaused() => print('App paused');
  
  @override
  void onInactive() => print('App inactive');
  
  @override
  void onDetached() => print('App detached');
  
  @override
  void onMinimised() => print('App minimized');
}
```

## Best Practices

### 1. Controller Organization

```dart
// Good: Single responsibility
class UserProfileController extends AsyncController<UserProfile> {
  Future<void> loadProfile(String userId) async { /* ... */ }
  Future<void> updateProfile(UserProfile profile) async { /* ... */ }
}

class UserSettingsController extends PersistentController {
  // Handle only user settings
}

// Avoid: Too many responsibilities in one controller
class GodController extends AsyncController<Everything> {
  // Handles users, posts, settings, navigation, etc. (Bad!)
}
```

### 2. Error Handling

```dart
class RobustController extends AsyncController<Data> {
  Future<void> loadData() async {
    await executeAsync(
      () => DataService.getData(),
      onSuccess: (data) {
        // Success handling
        print('Data loaded successfully');
      },
      onError: (error, stackTrace) {
        // Specific error handling
        if (error is NetworkException) {
          // Handle network error
        } else if (error is AuthException) {
          // Handle auth error
        }
        logger.e('Failed to load data', error, stackTrace);
      },
    );
  }
}
```

### 3. Testing Controllers

```dart
class TestableController extends AsyncController<List<Item>> {
  final ApiService apiService;
  
  TestableController({required this.apiService});
  
  Future<void> loadItems() async {
    await executeAsync(() => apiService.getItems());
  }
}

// In tests
void main() {
  group('TestableController', () {
    late TestableController controller;
    late MockApiService mockApiService;
    
    setUp(() {
      mockApiService = MockApiService();
      controller = TestableController(apiService: mockApiService);
    });
    
    test('should load items successfully', () async {
      // Arrange
      when(mockApiService.getItems()).thenAnswer((_) async => [Item()]);
      
      // Act
      await controller.loadItems();
      
      // Assert
      expect(controller.isSuccess, true);
      expect(controller.data?.length, 1);
    });
  });
}
```

### 4. State Management Patterns

```dart
// Good: Use appropriate controller for the task
class LoginController extends AsyncController<User> {
  final AuthService _authService;
  
  LoginController(this._authService);
  
  Future<void> login(String email, String password) async {
    await executeAsync(() => _authService.login(email, password));
  }
}

// Good: Composition over inheritance when needed
class ComplexController extends AsyncController<ComplexData> {
  final SettingsController settingsController;
  final UserController userController;
  
  ComplexController({
    required this.settingsController,
    required this.userController,
  });
  
  // Use other controllers as needed
}
```

### 5. Memory Management

```dart
class MemoryEfficientController extends AsyncController<LargeData> {
  Timer? _refreshTimer;
  
  @override
  void onReady() {
    super.onReady();
    _startPeriodicRefresh();
  }
  
  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(Duration(minutes: 5), (_) {
      if (mounted) { // Check if still mounted
        refreshData();
      }
    });
  }
  
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
```

## Common Patterns

### Loading with Retry

```dart
class RetryableController extends AsyncController<Data> with AsyncOperationsMixin<Data> {
  Future<void> loadDataWithRetry() async {
    await executeWithRetry(() => DataService.getData());
  }
  
  // In widget
  // ElevatedButton(
  //   onPressed: controller.retry, // Built-in retry functionality
  //   child: Text('Retry'),
  // )
}
```

### Pagination

```dart
class PaginatedController extends AsyncController<List<Item>> {
  int _currentPage = 0;
  List<Item> _allItems = [];
  
  Future<void> loadFirstPage() async {
    _currentPage = 0;
    _allItems.clear();
    await executeAsync(() => _loadPage(0));
  }
  
  Future<void> loadNextPage() async {
    if (!isLoading) {
      _currentPage++;
      await executeSilently(() => _loadPage(_currentPage));
    }
  }
  
  Future<List<Item>> _loadPage(int page) async {
    final newItems = await ApiService.getItems(page: page);
    _allItems.addAll(newItems);
    return _allItems;
  }
}
```

This state management system provides a powerful foundation for building maintainable Flutter applications with minimal boilerplate code.
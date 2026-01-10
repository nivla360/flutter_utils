# Services Documentation

Flutter Utils provides a comprehensive service layer that handles common application needs like HTTP requests, data storage, navigation, and dialogs. These services are designed to reduce boilerplate code and provide consistent patterns across your application.

## Table of Contents

- [API Service](#api-service)
- [Storage Service](#storage-service)
- [Navigation Service](#navigation-service)
- [Dialog Service](#dialog-service)
- [Service Integration](#service-integration)
- [Custom Services](#custom-services)

## API Service

A complete HTTP client with built-in retry logic, caching, interceptors, and error handling.

### Basic Setup

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize API service
  await ApiService().initialize(ApiServiceConfig(
    baseUrl: 'https://api.example.com',
    defaultHeaders: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    timeout: Duration(seconds: 30),
    enableLogging: true,
  ));
  
  runApp(MyApp());
}
```

### Simple Usage

```dart
// GET request
final response = await ApiService().get<User>('/users/123');
if (response.isSuccess) {
  final user = response.data;
  print('User: ${user?.name}');
} else {
  print('Error: ${response.error}');
}

// POST request
final createResponse = await ApiService().post<User>(
  '/users',
  body: {
    'name': 'John Doe',
    'email': 'john@example.com',
  },
);

// PUT request with custom headers
final updateResponse = await ApiService().put<User>(
  '/users/123',
  body: updatedUserData,
  headers: {'Authorization': 'Bearer $token'},
);

// DELETE request
final deleteResponse = await ApiService().delete('/users/123');
```

### Advanced Features

#### Automatic Serialization

```dart
// Define your model with fromJson
class User {
  final String id;
  final String name;
  final String email;
  
  User({required this.id, required this.name, required this.email});
  
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}

// API service automatically deserializes
final response = await ApiService().get<User>(
  '/users/123',
  fromJson: (json) => User.fromJson(json),
);

// For lists
final usersResponse = await ApiService().get<List<User>>(
  '/users',
  fromJson: (json) => (json['data'] as List)
    .map((item) => User.fromJson(item))
    .toList(),
);
```

#### Caching Strategies

```dart
enum CacheStrategy {
  networkOnly,     // Always fetch from network
  cacheOnly,       // Only use cached data
  networkFirst,    // Try network, fallback to cache
  cacheFirst,      // Try cache, fallback to network
  staleWhileRevalidate, // Return cache immediately, update in background
}

// Cache-first strategy
final response = await ApiService().get<List<Post>>(
  '/posts',
  cacheStrategy: CacheStrategy.cacheFirst,
  cacheKey: 'posts_list',
  cacheDuration: Duration(minutes: 30),
);

// Stale-while-revalidate for better UX
final response = await ApiService().get<User>(
  '/profile',
  cacheStrategy: CacheStrategy.staleWhileRevalidate,
  cacheKey: 'user_profile',
);
```

#### Request Interceptors

```dart
class AuthInterceptor extends RequestInterceptor {
  @override
  Future<ApiRequest> onRequest(ApiRequest request) async {
    // Add auth token to all requests
    final token = await AuthService.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    return request;
  }
}

class LoggingInterceptor extends RequestInterceptor {
  @override
  Future<ApiRequest> onRequest(ApiRequest request) async {
    print('🚀 ${request.method} ${request.url}');
    return request;
  }
  
  @override
  Future<ApiResponse> onResponse(ApiResponse response) async {
    print('✅ ${response.statusCode} ${response.request.url}');
    return response;
  }
  
  @override
  Future<ApiResponse> onError(ApiError error) async {
    print('❌ ${error.statusCode} ${error.message}');
    return super.onError(error);
  }
}

// Register interceptors
ApiService().addInterceptor(AuthInterceptor());
ApiService().addInterceptor(LoggingInterceptor());
```

#### Error Handling

```dart
final response = await ApiService().get<User>('/users/123');

switch (response.status) {
  case ApiStatus.success:
    handleSuccess(response.data!);
    break;
  case ApiStatus.networkError:
    showNetworkErrorDialog();
    break;
  case ApiStatus.unauthorized:
    redirectToLogin();
    break;
  case ApiStatus.serverError:
    showServerErrorMessage(response.error);
    break;
  case ApiStatus.timeout:
    showTimeoutMessage();
    break;
  case ApiStatus.cancelled:
    // Request was cancelled
    break;
}
```

#### File Upload/Download

```dart
// File upload
final file = File('path/to/image.jpg');
final uploadResponse = await ApiService().uploadFile(
  '/upload',
  file: file,
  fieldName: 'avatar',
  additionalFields: {'userId': '123'},
  onProgress: (sent, total) {
    final progress = sent / total;
    print('Upload progress: ${(progress * 100).toInt()}%');
  },
);

// Multiple file upload
final files = [File('image1.jpg'), File('image2.jpg')];
final multiUploadResponse = await ApiService().uploadFiles(
  '/upload-multiple',
  files: files,
  fieldName: 'images',
);

// File download
final downloadResponse = await ApiService().downloadFile(
  '/files/document.pdf',
  savePath: 'downloads/document.pdf',
  onProgress: (received, total) {
    final progress = received / total;
    print('Download progress: ${(progress * 100).toInt()}%');
  },
);
```

#### Retry Logic

```dart
// Configure retry behavior
final response = await ApiService().get<User>(
  '/users/123',
  retryConfig: RetryConfig(
    maxRetries: 3,
    retryDelay: Duration(seconds: 2),
    retryCondition: (response) {
      // Retry on 5xx errors or network issues
      return response.statusCode >= 500 || response.statusCode == 0;
    },
    onRetry: (attempt, error) {
      print('Retry attempt $attempt: $error');
    },
  ),
);
```

## Storage Service

Type-safe SharedPreferences wrapper with advanced features like TTL cache and namespaces.

### Basic Operations

```dart
// Initialize storage
await StorageService.instance.initialize();

// String operations
await StorageService.instance.setString('username', 'john_doe');
final username = StorageService.instance.getString('username');
final usernameWithDefault = StorageService.instance.getStringOrDefault('username', 'guest');

// Number operations
await StorageService.instance.setInt('userId', 123);
await StorageService.instance.setDouble('rating', 4.5);
final userId = StorageService.instance.getInt('userId');

// Boolean operations
await StorageService.instance.setBool('isDarkMode', true);
final isDarkMode = StorageService.instance.getBoolOrDefault('isDarkMode', false);

// List operations
await StorageService.instance.setStringList('tags', ['flutter', 'dart', 'mobile']);
final tags = StorageService.instance.getStringList('tags');
```

### JSON Objects

```dart
// Save complex objects
final user = User(id: '123', name: 'John', email: 'john@example.com');
await StorageService.instance.setJson('currentUser', user.toJson());

// Retrieve objects
final userData = StorageService.instance.getJson('currentUser');
if (userData != null) {
  final user = User.fromJson(userData);
}

// Type-safe object storage
await StorageService.instance.setObject<User>(
  'user',
  user,
  User.fromJson,
  (user) => user.toJson(),
);

final storedUser = StorageService.instance.getObject<User>(
  'user',
  User.fromJson,
);
```

### Namespaced Storage

```dart
// User preferences namespace
await StorageService.instance.setUserPreference('theme', 'dark');
await StorageService.instance.setUserPreference('language', 'en');
final theme = StorageService.instance.getUserPreference('theme', 'light');

// App settings namespace
await StorageService.instance.setAppSetting('apiUrl', 'https://api.example.com');
final apiUrl = StorageService.instance.getAppSetting('apiUrl');

// Custom namespaces
extension CustomStorage on StorageService {
  Future<bool> setGameSetting(String key, dynamic value) async {
    return await _setWithPrefix('game_', key, value);
  }
  
  dynamic getGameSetting(String key, [dynamic defaultValue]) {
    return _getWithPrefix('game_', key, defaultValue);
  }
}
```

### TTL Cache

```dart
// Cache with time-to-live
await StorageService.instance.setCache(
  'api_response',
  responseData,
  ttl: Duration(hours: 1),
);

// Retrieve cached data (returns null if expired)
final cachedData = StorageService.instance.getCache('api_response');

// Clear expired cache entries
await StorageService.instance.clearExpiredCache();
```

### Utility Operations

```dart
// Check if key exists
final hasUser = StorageService.instance.hasKey('currentUser');

// Remove specific key
await StorageService.instance.remove('tempData');

// Get all keys
final allKeys = StorageService.instance.getAllKeys();

// Get keys with prefix
final userKeys = StorageService.instance.getKeysWithPrefix('user_');

// Remove all keys with prefix
await StorageService.instance.removeKeysWithPrefix('temp_');

// Clear all data
await StorageService.instance.clear();

// Storage size information
final sizeBytes = StorageService.instance.getStorageSize();
final formattedSize = StorageService.instance.getFormattedStorageSize(); // "1.2 MB"
```

## Navigation Service

Centralized navigation management with route handling and type safety.

### Basic Setup

```dart
class AppRouter {
  static final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/profile/:userId',
        builder: (context, state) => ProfileScreen(
          userId: state.pathParameters['userId']!,
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsScreen(),
      ),
    ],
  );
}

// In main.dart
MaterialApp.router(
  routerConfig: AppRouter.router,
)
```

### Navigation Service Usage

```dart
class NavigationService {
  static final _router = AppRouter.router;
  
  // Basic navigation
  static void goToHome() => _router.go('/home');
  static void goToProfile(String userId) => _router.go('/profile/$userId');
  static void goToSettings() => _router.go('/settings');
  
  // Push navigation
  static void pushProfile(String userId) => _router.push('/profile/$userId');
  
  // Pop navigation
  static void pop() => _router.pop();
  static bool canPop() => _router.canPop();
  
  // Replace navigation
  static void replaceWithHome() => _router.replace('/home');
  
  // Clear stack and navigate
  static void goToLoginAndClearStack() {
    while (_router.canPop()) {
      _router.pop();
    }
    _router.go('/login');
  }
}

// Usage in widgets
ElevatedButton(
  onPressed: () => NavigationService.goToProfile('123'),
  child: Text('View Profile'),
)
```

### Type-Safe Routes

```dart
// Define route classes for type safety
abstract class AppRoutes {
  static const home = '/home';
  static const profile = '/profile';
  static const settings = '/settings';
  
  static String profileWithId(String userId) => '/profile/$userId';
}

// Navigation service with type safety
class TypeSafeNavigationService {
  static void goToHome() => context.go(AppRoutes.home);
  static void goToProfile(String userId) => context.go(AppRoutes.profileWithId(userId));
  static void goToSettings() => context.go(AppRoutes.settings);
}
```

### Navigation Guards

```dart
class AuthGuard {
  static bool canAccess(String route) {
    // Check if user is authenticated
    return AuthService.isLoggedIn;
  }
}

// In route configuration
GoRoute(
  path: '/protected',
  builder: (context, state) {
    if (!AuthGuard.canAccess(state.location)) {
      return LoginScreen();
    }
    return ProtectedScreen();
  },
)
```

## Dialog Service

Centralized dialog management with consistent styling and behavior.

### Basic Dialogs

```dart
class DialogService {
  // Confirmation dialog
  static Future<bool> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    ) ?? false;
  }
  
  // Info dialog
  static Future<void> showInfoDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
  
  // Error dialog
  static Future<void> showErrorDialog({
    required BuildContext context,
    required String error,
    String title = 'Error',
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(error),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Usage
final confirmed = await DialogService.showConfirmDialog(
  context: context,
  title: 'Delete Item',
  message: 'Are you sure you want to delete this item?',
);

if (confirmed) {
  // Delete the item
}
```

### Loading Dialogs

```dart
class LoadingDialogService {
  static OverlayEntry? _overlayEntry;
  
  static void show(BuildContext context, {String? message}) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black54,
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  if (message != null) ...[
                    SizedBox(height: 16),
                    Text(message),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
  }
  
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

// Usage
LoadingDialogService.show(context, message: 'Loading...');
await performAsyncOperation();
LoadingDialogService.hide();
```

### Bottom Sheet Service

```dart
class BottomSheetService {
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
  }) async {
    return await showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => child,
    );
  }
  
  static Future<String?> showActionSheet({
    required BuildContext context,
    required String title,
    required List<ActionSheetItem> actions,
  }) async {
    return await showBottomSheet<String>(
      context: context,
      child: ActionSheetWidget(title: title, actions: actions),
    );
  }
}

class ActionSheetItem {
  final String text;
  final String value;
  final IconData? icon;
  final bool isDestructive;
  
  ActionSheetItem({
    required this.text,
    required this.value,
    this.icon,
    this.isDestructive = false,
  });
}
```

## Service Integration

### Dependency Injection

```dart
// Register services with GetIt
void setupServices() {
  // Singletons
  GetIt.instance.registerSingleton<ApiService>(ApiService());
  GetIt.instance.registerSingleton<StorageService>(StorageService.instance);
  
  // Lazy singletons
  GetIt.instance.registerLazySingleton<NavigationService>(() => NavigationService());
  GetIt.instance.registerLazySingleton<DialogService>(() => DialogService());
  
  // Factories (new instance each time)
  GetIt.instance.registerFactory<Logger>(() => Logger());
}

// Usage in widgets or controllers
class UserController extends AsyncController<User> {
  final ApiService _apiService = GetIt.instance<ApiService>();
  final StorageService _storageService = GetIt.instance<StorageService>();
  
  Future<void> loadUser(String userId) async {
    await executeAsync(() => _apiService.get<User>('/users/$userId'));
    
    if (isSuccess && data != null) {
      await _storageService.setJson('currentUser', data!.toJson());
    }
  }
}
```

### Service Communication

```dart
// Event bus for service communication
class EventBus {
  static final _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();
  
  final _eventController = StreamController<AppEvent>.broadcast();
  
  Stream<T> on<T extends AppEvent>() {
    return _eventController.stream.where((event) => event is T).cast<T>();
  }
  
  void emit(AppEvent event) {
    _eventController.add(event);
  }
  
  void dispose() {
    _eventController.close();
  }
}

// Event classes
abstract class AppEvent {}

class UserLoggedIn extends AppEvent {
  final User user;
  UserLoggedIn(this.user);
}

class UserLoggedOut extends AppEvent {}

// Service that listens to events
class AuthService {
  final EventBus _eventBus = EventBus();
  
  void initialize() {
    _eventBus.on<UserLoggedOut>().listen((_) {
      clearAuthToken();
      clearUserData();
    });
  }
  
  Future<void> login(String email, String password) async {
    // Perform login
    final user = await _apiService.login(email, password);
    
    // Emit event
    _eventBus.emit(UserLoggedIn(user));
  }
}
```

## Custom Services

### Creating Custom Services

```dart
// Base service class
abstract class BaseService {
  bool _initialized = false;
  bool get isInitialized => _initialized;
  
  Future<void> initialize() async {
    if (_initialized) return;
    await onInitialize();
    _initialized = true;
  }
  
  Future<void> onInitialize();
  void dispose();
}

// Custom notification service
class NotificationService extends BaseService {
  final List<AppNotification> _notifications = [];
  final StreamController<List<AppNotification>> _notificationController = StreamController.broadcast();
  
  Stream<List<AppNotification>> get notifications => _notificationController.stream;
  List<AppNotification> get currentNotifications => List.unmodifiable(_notifications);
  
  @override
  Future<void> onInitialize() async {
    // Initialize notifications
    await _loadPersistedNotifications();
  }
  
  Future<void> addNotification(AppNotification notification) async {
    _notifications.add(notification);
    _notificationController.add(currentNotifications);
    await _persistNotifications();
  }
  
  Future<void> removeNotification(String id) async {
    _notifications.removeWhere((n) => n.id == id);
    _notificationController.add(currentNotifications);
    await _persistNotifications();
  }
  
  Future<void> markAsRead(String id) async {
    final notification = _notifications.firstWhere((n) => n.id == id);
    notification.isRead = true;
    _notificationController.add(currentNotifications);
    await _persistNotifications();
  }
  
  Future<void> _loadPersistedNotifications() async {
    final data = StorageService.instance.getJsonList('notifications', []);
    _notifications.clear();
    _notifications.addAll(data.map((json) => AppNotification.fromJson(json)));
  }
  
  Future<void> _persistNotifications() async {
    await StorageService.instance.setJsonList(
      'notifications',
      _notifications.map((n) => n.toJson()).toList(),
    );
  }
  
  @override
  void dispose() {
    _notificationController.close();
  }
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  
  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
  
  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: json['id'],
    title: json['title'],
    message: json['message'],
    timestamp: DateTime.parse(json['timestamp']),
    isRead: json['isRead'] ?? false,
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'timestamp': timestamp.toIso8601String(),
    'isRead': isRead,
  };
}
```

### Service Registration

```dart
// Register custom services
void setupCustomServices() {
  GetIt.instance.registerLazySingleton<NotificationService>(() => NotificationService());
  GetIt.instance.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  GetIt.instance.registerLazySingleton<CacheService>(() => CacheService());
}

// Initialize all services
Future<void> initializeServices() async {
  await GetIt.instance<ApiService>().initialize(apiConfig);
  await GetIt.instance<StorageService>().initialize();
  await GetIt.instance<NotificationService>().initialize();
  await GetIt.instance<AnalyticsService>().initialize();
}
```

## Best Practices

### Service Design Principles

```dart
// Good: Single responsibility
class AuthService {
  // Only handles authentication
  Future<User> login(String email, String password) async { /* */ }
  Future<void> logout() async { /* */ }
  Future<void> refreshToken() async { /* */ }
}

class UserService {
  // Only handles user data
  Future<User> getProfile() async { /* */ }
  Future<void> updateProfile(User user) async { /* */ }
}

// Avoid: God service
class MegaService {
  // Too many responsibilities
  Future<void> login() async { /* */ }
  Future<void> saveToDatabase() async { /* */ }
  Future<void> sendNotification() async { /* */ }
  Future<void> uploadFile() async { /* */ }
}
```

### Error Handling

```dart
// Good: Consistent error handling across services
abstract class ServiceResult<T> {
  const ServiceResult();
}

class ServiceSuccess<T> extends ServiceResult<T> {
  final T data;
  const ServiceSuccess(this.data);
}

class ServiceError<T> extends ServiceResult<T> {
  final String message;
  final Exception? exception;
  const ServiceError(this.message, [this.exception]);
}

class UserService {
  Future<ServiceResult<User>> getUser(String id) async {
    try {
      final response = await ApiService().get<User>('/users/$id');
      if (response.isSuccess) {
        return ServiceSuccess(response.data!);
      } else {
        return ServiceError('Failed to load user: ${response.error}');
      }
    } catch (e) {
      return ServiceError('Network error', e as Exception);
    }
  }
}
```

### Testing Services

```dart
// Testable service design
class UserService {
  final ApiService apiService;
  final StorageService storageService;
  
  UserService({
    required this.apiService,
    required this.storageService,
  });
  
  Future<User?> getCurrentUser() async {
    // Try cache first
    final cachedUser = storageService.getJson('currentUser');
    if (cachedUser != null) {
      return User.fromJson(cachedUser);
    }
    
    // Fetch from API
    final response = await apiService.get<User>('/profile');
    if (response.isSuccess) {
      await storageService.setJson('currentUser', response.data!.toJson());
      return response.data;
    }
    
    return null;
  }
}

// In tests
void main() {
  group('UserService', () {
    late UserService userService;
    late MockApiService mockApiService;
    late MockStorageService mockStorageService;
    
    setUp(() {
      mockApiService = MockApiService();
      mockStorageService = MockStorageService();
      userService = UserService(
        apiService: mockApiService,
        storageService: mockStorageService,
      );
    });
    
    test('should return cached user when available', () async {
      // Arrange
      final userData = {'id': '123', 'name': 'John'};
      when(mockStorageService.getJson('currentUser')).thenReturn(userData);
      
      // Act
      final user = await userService.getCurrentUser();
      
      // Assert
      expect(user?.id, '123');
      verifyNever(mockApiService.get(any));
    });
  });
}
```

This service layer provides a robust foundation for building scalable Flutter applications with consistent patterns, proper error handling, and excellent developer experience.
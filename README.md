# Flutter Utils

A comprehensive Flutter utility package that provides modern tools, extensions, widgets, and services to accelerate Flutter development with minimal boilerplate code. Built with 2025 Flutter best practices.

## ✨ What's New (v0.1.0)

- 🎯 **Write 80% Less Code** - High-level widgets and utilities for common patterns
- ⚡ **Modern State Management** - Enhanced controllers with async state and persistence
- 🎨 **Advanced UI Components** - Skeleton loaders, smart forms, quick widgets
- 🌐 **Complete Service Layer** - HTTP client, storage wrapper, and more
- 🔧 **Powerful Extensions** - DateTime, validation, and utility extensions
- 📱 **Material 3 Ready** - Modern design system support

## 🚀 Quick Start

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_utils:
    git:
      url: https://github.com/nivla360/flutter_utils.git
```

### Basic Setup

```dart
import 'package:flutter_utils/flutter_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the package
  FlutterUtil.initialize(
    loaderSmall: const SpinKitCircle(color: Colors.blue),
    loaderMedium: const SpinKitCircle(color: Colors.blue),
    loaderLarge: const SpinKitCircle(color: Colors.blue),
    imagesError: "assets/images/error.png",
    imagesNoInternet: "assets/images/no_internet.png",
    imagesNoResults: "assets/images/no_results.png",
  );
  
  // Initialize services
  await ApiService().initialize(ApiServiceConfig(
    baseUrl: 'https://api.example.com',
  ));
  await StorageService.instance.initialize();
  
  runApp(MyApp());
}
```

## 📱 Core Features

### 1. **Enhanced State Management**

Modern controllers with async state handling and automatic persistence:

```dart
class UserController extends AsyncController<User> {
  @override
  String get persistenceKey => 'user_data';
  
  Future<void> loadUser(String userId) async {
    await executeAsync(() => ApiService().get<User>('/users/$userId'));
  }
}

// In your widget
AsyncBuilder<UserController>(
  controller: GetIt.instance<UserController>(),
  onLoading: (context, controller) => SkeletonShapes.circle(size: 50),
  onSuccess: (context, controller) => Text(controller.data?.name ?? ''),
  onError: (context, controller) => Text(controller.errorMessage ?? ''),
)
```

### 2. **Quick Widgets - Write Less Code**

Replace verbose widget trees with one-liners:

```dart
// Before: 15+ lines of Card with padding, shadow, etc.
QuickCard(
  child: Text('Hello World'),
  onTap: () => print('Tapped'),
)

// Before: Complex ListTile with avatar logic
QuickListTile.avatar(
  title: 'John Doe',
  subtitle: 'Software Engineer',
  avatarUrl: 'https://example.com/avatar.jpg',
  onTap: () => navigateToProfile(),
)

// Before: Multiple ElevatedButton configurations
QuickButton(
  text: 'Login',
  icon: Icons.login,
  style: QuickButtonStyle.primary,
  isLoading: isLoading,
  onPressed: handleLogin,
)
```

### 3. **Smart Form Builder**

Declarative forms with built-in validation:

```dart
SmartFormBuilder(
  fields: [
    FormFieldConfig(
      key: 'email',
      label: 'Email',
      type: FormFieldType.email,
      required: true,
      validators: [EmailValidator(), RequiredValidator()],
    ),
    FormFieldConfig(
      key: 'password',
      label: 'Password',
      type: FormFieldType.password,
      required: true,
      validators: [MinLengthValidator(8)],
    ),
  ],
  onSubmit: (values) => print(values),
  showSubmitButton: true,
)
```

### 4. **Advanced Extensions**

Powerful extensions that eliminate repetitive code:

```dart
// DateTime extensions
final date = DateTime.now();
print(date.smart); // "2 hours ago" or "Today 3:30 PM"
print(date.isToday); // true/false
print(date.nextBusinessDay); // Skips weekends

// Validation extensions
'user@example.com'.isValidEmail; // true
'password123'.isStrongPassword; // false
'+1234567890'.isValidPhone; // true

// Widget extensions
Text('Hello').paddingAll(16).center().onTap(() => print('Tapped'))
```

### 5. **Complete API Service**

HTTP client with retry logic, caching, and interceptors:

```dart
// Simple usage
final response = await ApiService().get<User>('/user/123');
if (response.isSuccess) {
  print(response.data?.name);
}

// With caching and custom config
final posts = await ApiService().get<List<Post>>(
  '/posts',
  cacheStrategy: CacheStrategy.cacheFirst,
  fromJson: (json) => (json['data'] as List)
    .map((item) => Post.fromJson(item))
    .toList(),
);
```

### 6. **Type-Safe Storage**

SharedPreferences wrapper with advanced features:

```dart
// Simple operations
await StorageService.instance.setString('username', 'john_doe');
final username = StorageService.instance.getString('username');

// JSON objects
await StorageService.instance.setJson('user', user.toJson());
final user = StorageService.instance.getJson('user');

// Typed objects with TTL cache
await StorageService.instance.setCache('posts', posts, ttl: Duration(hours: 1));
final cachedPosts = StorageService.instance.getCache('posts');
```

### 7. **Loading States Made Easy**

Modern skeleton loaders and empty states:

```dart
// Skeleton loading
SkeletonLayouts.listTile(showAvatar: true, showSubtitle: true)
SkeletonLayouts.card(imageHeight: 200)
SkeletonShapes.circle(size: 50)

// Empty states
QuickEmptyState(
  title: 'No messages yet',
  subtitle: 'Start a conversation',
  icon: Icons.message,
  action: QuickButton(
    text: 'New Message',
    onPressed: () => createMessage(),
  ),
)
```

## 📚 Detailed Documentation

For comprehensive examples and advanced usage:

- **[State Management Guide](docs/STATE_MANAGEMENT.md)** - Controllers, persistence, lifecycle
- **[Widgets Reference](docs/WIDGETS.md)** - Complete widget catalog with examples
- **[Extensions Guide](docs/EXTENSIONS.md)** - All available extensions and utilities
- **[Services Documentation](docs/SERVICES.md)** - API client, storage, and more
- **[Migration Guide](docs/MIGRATION.md)** - Upgrading from previous versions

## 🎯 Key Benefits

### Write 80% Less Code
- **Before**: 50 lines for a loading list with empty states
- **After**: 5 lines with `QuickListBuilder`

### Smart Defaults
- Material 3 design system integration
- Responsive design out of the box
- Error handling and logging built-in

### Type Safety
- Compile-time validation for forms
- Type-safe storage operations
- Generic async controllers

### Modern Patterns
- Declarative UI approach
- Reactive state management
- Composable utilities

## 📦 What's Included

### State Management
- `AsyncController` - Async state handling
- `PersistentController` - Automatic state persistence
- `ReactiveWidget` - Declarative UI updates
- `AsyncBuilder` - Loading state management

### UI Components
- `QuickCard`, `QuickButton`, `QuickListTile`
- `SmartFormBuilder` - Declarative forms
- `SkeletonLoader` - Modern loading states
- `QuickEmptyState` - Empty state handling

### Extensions
- **DateTime**: 50+ utilities for date operations
- **Validation**: Email, phone, password, credit card validation
- **String**: Color conversion, formatting, sanitization
- **Widget**: Padding, gestures, styling shortcuts

### Services
- **ApiService**: HTTP client with caching and retry logic
- **StorageService**: Type-safe SharedPreferences wrapper
- **Logger**: Consistent logging throughout the app

### Pre-configured Dependencies
- Material 3 design system
- Navigation with `go_router`
- Dependency injection with `get_it`
- Typography with `google_fonts`
- Responsive design with `flutter_screenutil`

## 🤝 Contributing

Contributions are welcome! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- [API Documentation](https://pub.dev/documentation/flutter_utils/latest/)
- [GitHub Repository](https://github.com/nivla360/flutter_utils)
- [Issue Tracker](https://github.com/nivla360/flutter_utils/issues)
- [Changelog](CHANGELOG.md)

---

**Flutter Utils** - Write less, achieve more! 🚀
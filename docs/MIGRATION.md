# Migration Guide

This guide helps you upgrade to the latest version of Flutter Utils and migrate from previous versions or other state management solutions.

## Table of Contents

- [Upgrading to v0.1.0](#upgrading-to-v010)
- [Migrating from Previous Versions](#migrating-from-previous-versions)
- [Migrating from Other Solutions](#migrating-from-other-solutions)
- [Breaking Changes](#breaking-changes)
- [New Features](#new-features)
- [Best Practices](#best-practices)

## Upgrading to v0.1.0

### What's New

Flutter Utils v0.1.0 represents a major overhaul with significant enhancements:

- **Enhanced State Management**: New `AsyncController` and `PersistentController`
- **Complete Service Layer**: HTTP client, storage wrapper, navigation, and dialogs
- **Advanced UI Components**: Skeleton loaders, smart forms, quick widgets
- **Powerful Extensions**: 50+ DateTime utilities, validation, widget shortcuts
- **Material 3 Support**: Modern design system integration
- **Better Developer Experience**: Reduced boilerplate, type safety, smart defaults

### Package Updates

Update your `pubspec.yaml`:

```yaml
dependencies:
  flutter_utils:
    git:
      url: https://github.com/nivla360/flutter_utils.git
      # Remove any version constraints for latest features
```

Updated dependencies in v0.1.0:
- `go_router`: `^16.2.0` (was ^14.3.0)
- `get_it`: `^8.2.0` (was ^8.0.1)
- `google_fonts`: `^6.2.1` (was ^6.1.0)
- `shared_preferences`: `^2.4.1` (was ^2.2.2)
- `flutter_screenutil`: `^5.9.3` (was ^5.9.0)
- `logger`: `^2.5.0` (was ^2.0.2+1)
- **New**: `http`: `^1.5.0`

### Initialization Changes

#### Before (v0.0.x)
```dart
void main() {
  runApp(MyApp());
}
```

#### After (v0.1.0)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Flutter Utils
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

## Migrating from Previous Versions

### State Management Migration

#### From Basic RootController

**Before:**
```dart
class CounterController extends RootController {
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}
```

**After (Enhanced):**
```dart
// Option 1: Keep existing pattern (no changes needed)
class CounterController extends RootController {
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

// Option 2: Add persistence
class CounterController extends PersistentController {
  @override
  String get persistenceKey => 'counter_state';
  
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners(); // Auto-saves due to persistence
  }
  
  @override
  Map<String, dynamic> toJson() => {'count': _count};
  
  @override
  void fromJson(Map<String, dynamic> json) {
    _count = json['count'] ?? 0;
  }
}
```

#### Adding Async Operations

**Before (Manual async handling):**
```dart
class UserController extends RootController {
  User? _user;
  bool _isLoading = false;
  String? _error;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> loadUser(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _user = await UserService.getUser(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

**After (AsyncController):**
```dart
class UserController extends AsyncController<User> {
  Future<void> loadUser(String id) async {
    await executeAsync(() => UserService.getUser(id));
  }
  
  // Built-in properties: isLoading, hasError, data, errorMessage
  // Built-in methods: executeAsync, executeSilently, retry, reset
}
```

### Widget Migration

#### ReactiveWidget Usage

**Before:**
```dart
class CounterView extends StatefulWidget {
  @override
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  late CounterController controller;
  
  @override
  void initState() {
    super.initState();
    controller = GetIt.instance<CounterController>();
    controller.addListener(_onControllerChange);
  }
  
  void _onControllerChange() {
    setState(() {});
  }
  
  @override
  void dispose() {
    controller.removeListener(_onControllerChange);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Text('Count: ${controller.count}');
  }
}
```

**After (Simplified):**
```dart
class CounterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReactiveWidget<CounterController>(
      builder: (context, controller) => Text('Count: ${controller.count}'),
    );
  }
}
```

#### AsyncBuilder for Loading States

**Before (Manual state handling):**
```dart
class UserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReactiveWidget<UserController>(
      builder: (context, controller) {
        if (controller.isLoading) {
          return CircularProgressIndicator();
        }
        if (controller.hasError) {
          return Text('Error: ${controller.error}');
        }
        if (controller.user == null) {
          return Text('No user data');
        }
        return Text('User: ${controller.user!.name}');
      },
    );
  }
}
```

**After (AsyncBuilder):**
```dart
class UserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<UserController>(
      controller: GetIt.instance<UserController>(),
      onLoading: (context, controller) => SkeletonShapes.circle(size: 50),
      onSuccess: (context, controller) => Text('User: ${controller.data!.name}'),
      onError: (context, controller) => Text('Error: ${controller.errorMessage}'),
    );
  }
}
```

## Migrating from Other Solutions

### From Provider

**Before (Provider):**
```dart
// Provider setup
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => CounterNotifier()),
    ChangeNotifierProvider(create: (_) => UserNotifier()),
  ],
  child: MyApp(),
)

class CounterNotifier extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

// Widget usage
Consumer<CounterNotifier>(
  builder: (context, counter, child) => Text('${counter.count}'),
)
```

**After (Flutter Utils):**
```dart
// Setup with GetIt
void setupServices() {
  GetIt.instance.registerSingleton(CounterController());
  GetIt.instance.registerSingleton(UserController());
}

class CounterController extends RootController {
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

// Widget usage
ReactiveWidget<CounterController>(
  builder: (context, controller) => Text('${controller.count}'),
)
```

### From Bloc

**Before (Bloc):**
```dart
// Bloc setup
BlocProvider(
  create: (context) => CounterBloc(),
  child: MyApp(),
)

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterInitial()) {
    on<CounterIncremented>((event, emit) {
      emit(CounterUpdated(state.count + 1));
    });
  }
}

// Widget usage
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    if (state is CounterUpdated) {
      return Text('${state.count}');
    }
    return CircularProgressIndicator();
  },
)
```

**After (Flutter Utils):**
```dart
// Controller
class CounterController extends RootController {
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

// Widget usage
ReactiveWidget<CounterController>(
  builder: (context, controller) => Text('${controller.count}'),
)
```

### From Riverpod

**Before (Riverpod):**
```dart
final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);
  
  void increment() => state++;
}

// Widget usage
Consumer(
  builder: (context, ref, child) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  },
)
```

**After (Flutter Utils):**
```dart
class CounterController extends RootController {
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

// Widget usage
ReactiveWidget<CounterController>(
  builder: (context, controller) => Text('${controller.count}'),
)
```

## Breaking Changes

### Removed Features

1. **Old Widget Names**: Some widget names may have changed for consistency
2. **Deprecated Methods**: Old utility methods replaced with extensions
3. **Configuration Changes**: Initialization process now required

### API Changes

#### Storage Service
**Before:**
```dart
// Direct SharedPreferences usage
final prefs = await SharedPreferences.getInstance();
await prefs.setString('key', 'value');
```

**After:**
```dart
// Unified storage service
await StorageService.instance.setString('key', 'value');
// Or with type safety
await StorageService.instance.setJson('user', user.toJson());
```

#### Extension Names
Some extensions may have been renamed for consistency:

**Before:**
```dart
text.capitalizeFirst();  // Old name
```

**After:**
```dart
text.capitalize;  // New name (property)
```

## New Features

### AsyncController Benefits

1. **Automatic State Management**: No manual loading/error state handling
2. **Built-in Retry Logic**: `controller.retry()` method
3. **Background Operations**: `executeSilently()` for background tasks
4. **State Persistence**: Combine with `PersistentController`

```dart
class DataController extends AsyncController<List<Item>> with PersistentStateMixin {
  @override
  String get persistenceKey => 'cached_data';
  
  Future<void> loadData() async {
    await executeAsync(() => ApiService().get<List<Item>>('/items'));
  }
  
  // Data automatically persisted and restored
}
```

### Service Layer

1. **HTTP Client**: Built-in retry, caching, interceptors
2. **Storage Wrapper**: Type-safe SharedPreferences operations
3. **Navigation Service**: Centralized route management
4. **Dialog Service**: Consistent dialog patterns

```dart
// HTTP with caching
final response = await ApiService().get<User>(
  '/profile',
  cacheStrategy: CacheStrategy.cacheFirst,
);

// Type-safe storage
await StorageService.instance.setObject<User>(
  'user',
  user,
  User.fromJson,
  (user) => user.toJson(),
);
```

### Enhanced Widgets

1. **QuickWidgets**: Reduce 10+ lines to 1-2 lines
2. **SmartFormBuilder**: Declarative forms with validation
3. **SkeletonLoaders**: Modern loading states
4. **AsyncBuilder**: Declarative async state handling

```dart
// Before: 15+ lines
QuickCard(
  title: 'Product',
  child: Text('Description'),
  onTap: () => navigate(),
)

// Form building
SmartFormBuilder(
  fields: [
    FormFieldConfig(
      key: 'email',
      type: FormFieldType.email,
      required: true,
    ),
  ],
  onSubmit: handleSubmit,
)
```

### Extensions

1. **DateTime**: 50+ utilities (`date.smart`, `date.isToday`, etc.)
2. **Validation**: Email, phone, password strength
3. **Widget**: Padding, gestures, styling shortcuts
4. **String**: Formatting, validation, manipulation

```dart
// DateTime extensions
print(DateTime.now().smart);  // "2 hours ago"
print(date.nextBusinessDay);  // Skips weekends

// Validation
'user@email.com'.isValidEmail;  // true
'password123'.isStrongPassword; // false

// Widget extensions
Text('Hello').paddingAll(16).center().onTap(() => {});
```

## Best Practices

### Gradual Migration

1. **Start Small**: Migrate one feature at a time
2. **Test Thoroughly**: Ensure existing functionality works
3. **Use New Features**: Gradually adopt new patterns
4. **Update Dependencies**: Keep packages up to date

### Controller Design

```dart
// Good: Focused responsibility
class UserProfileController extends AsyncController<UserProfile> {
  Future<void> loadProfile() async {
    await executeAsync(() => UserService.getProfile());
  }
  
  Future<void> updateProfile(UserProfile profile) async {
    await executeAsync(() => UserService.updateProfile(profile));
  }
}

// Good: Add persistence when needed
class SettingsController extends PersistentController {
  @override
  String get persistenceKey => 'app_settings';
  
  // Settings automatically persist
}
```

### Service Usage

```dart
// Good: Use dependency injection
class UserController extends AsyncController<User> {
  final ApiService _apiService = GetIt.instance<ApiService>();
  final StorageService _storage = GetIt.instance<StorageService>();
  
  Future<void> loadUser(String id) async {
    await executeAsync(() => _apiService.get<User>('/users/$id'));
    
    if (isSuccess) {
      await _storage.setJson('currentUser', data!.toJson());
    }
  }
}
```

### Widget Patterns

```dart
// Good: Use appropriate widget for the task
class ProductCard extends StatelessWidget {
  final Product product;
  
  @override
  Widget build(BuildContext context) {
    return QuickCard(
      title: product.name,
      subtitle: '\$${product.price}',
      child: Text(product.description),
      onTap: () => navigateToProduct(product),
    );
  }
}

// Good: Use AsyncBuilder for async operations
class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<ProductController>(
      controller: GetIt.instance<ProductController>(),
      onLoading: (context, controller) => SkeletonLayouts.listTile(),
      onSuccess: (context, controller) => ListView.builder(
        itemCount: controller.data?.length ?? 0,
        itemBuilder: (context, index) => ProductCard(controller.data![index]),
      ),
      onError: (context, controller) => QuickEmptyState.error(
        error: controller.errorMessage,
        onRetry: controller.retry,
      ),
    );
  }
}
```

## Migration Checklist

### Pre-Migration
- [ ] Backup your project
- [ ] Update dependencies
- [ ] Read this migration guide
- [ ] Plan migration strategy

### During Migration
- [ ] Initialize Flutter Utils in main.dart
- [ ] Set up services (ApiService, StorageService)
- [ ] Migrate controllers to new patterns
- [ ] Update widget usage
- [ ] Test each migrated feature

### Post-Migration
- [ ] Run full test suite
- [ ] Update documentation
- [ ] Train team on new patterns
- [ ] Monitor for issues

### Performance Testing
- [ ] Test app startup time
- [ ] Verify memory usage
- [ ] Check for any regressions
- [ ] Validate all features work

This migration guide should help you smoothly transition to Flutter Utils v0.1.0 and take advantage of all the new features and improvements!
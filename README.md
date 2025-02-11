<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Flutter Utils

A comprehensive Flutter utility package that provides a collection of helpful tools, extensions, and widgets to accelerate Flutter development. This package includes various utilities for common tasks, making Flutter development more efficient and maintainable.

## Features

- 🛠️ **Utility Functions**

  - File size formatting
  - String manipulation
  - URL handling
  - Clipboard operations
  - Network connectivity checks
  - Number formatting
  - Date formatting
  - Logging utilities
  - And more!

- 🎨 **Extensions**

  - String extensions (color conversion, validation helpers)
  - Number extensions (spacing widgets, duration conversions)
  - BuildContext extensions (responsive design helpers, theme access)
  - And more!

- 📱 **Pre-configured Dependencies**

  - `get_it` for dependency injection
  - `go_router` for navigation
  - `google_fonts` for typography
  - `flutter_spinkit` for loading indicators
  - `ionicons` for icons
  - `flutter_screenutil` for responsive design
  - `flutter_styled_toast` for toast messages

- 🔧 **Common Constants**
  - Border radius presets
  - Padding presets
  - Spacing widgets
  - Dividers
  - Error messages

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_utils:
    git:
      url: https://github.com/nivla360/flutter_utils.git
```

## Usage

### Initialize the Package

```dart
import 'package:flutter_utils/flutter_utils.dart';

void main() {
  FlutterUtil.initialize(
    loaderSmall: const SpinKitCircle(color: Colors.blue),
    loaderMedium: const SpinKitCircle(color: Colors.blue),
    loaderLarge: const SpinKitCircle(color: Colors.blue),
    imagesError: "assets/images/error.png",
    imagesNoInternet: "assets/images/no_internet.png",
    imagesNoResults: "assets/images/no_results.png",
  );
}
```

### Using Utility Functions

```dart
// String utilities
String formattedSize = getHumanReadableFileSize(fileLength: 1024576); // "1.00 MB"
bool isValidEmail = "test@example.com".isValidEmail(); // true

// Network utilities
bool connected = await isConnected();

// Number formatting
String shortened = shortenLargeNumber(1500000); // "1.5M"

// Clipboard operations
await copyText("Text to copy");
```

### Using Extensions

```dart
// Context extensions
context.height;  // screen height
context.width;   // screen width
context.screenIsMobile;  // check if screen is mobile
context.theme;   // get theme data

// Number extensions
10.vs;  // vertical space of 10 logical pixels
20.hs;  // horizontal space of 20 logical pixels
5.seconds;  // Duration of 5 seconds

// String extensions
"#FF0000".toColor();  // converts hex to Color
```

### Using Pre-defined Constants

```dart
// Border radius
borderRadiusFifteen;  // BorderRadius.circular(15)
borderRadiusTen;      // BorderRadius.circular(10)

// Padding
paddingAllTwenty;     // EdgeInsets.all(20)
paddingAllFifteen;    // EdgeInsets.all(15)

// Spacing
verticalSpaceTen;     // SizedBox(height: 10)
horizontalSpaceFive;  // SizedBox(width: 5)
```

### Using State Management

The package provides a custom lightweight state management solution that follows a controller-based pattern with reactive widgets for efficient UI updates.

#### Basic Structure

- `RootController`: Base controller class that provides state management capabilities
- `BaseController`: Extended controller with navigation and utility methods
- `ReactiveWidget`: Widget that rebuilds when controller state changes
- `StatelessView`: Base class for views with typed controller access

#### Setting up Base Controller

The `BaseController` extends `RootController` and provides common functionality for all controllers in your app:

```dart
class BaseController extends RootController {
  // Access to router for navigation
  GoRouter router = AppRoute.router;

  // Get current BuildContext
  BuildContext? getContext() {
    return router.configuration.navigatorKey.currentContext;
  }

  // Add any other common functionality needed across controllers
  // For example:
  // - Common API calls
  // - Shared business logic
  // - Navigation methods
  // - Error handling
}

// Then extend BaseController in your feature controllers
class HomeController extends BaseController {
  // Your controller implementation
}

class ProfileController extends BaseController {
  // Your controller implementation
}
```

For a complete setup with navigation and dependency injection:

```dart
// app_route.dart
class AppRoute {
  static const String initialRoute = '/';
  static const String secondPage = 'secondPage';

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(
        path: initialRoute,
        name: initialRoute,
        builder: (_, __) => const MyHomePage(),
        routes: [
          GoRoute(
            path: secondPage,
            name: secondPage,
            builder: (_, __) => const SecondPage()
          )
        ]
      )
    ]
  );
}

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();
  runApp(const MyApp());
}

Future<void> initServices() async {
  final getIt = GetIt.instance;

  // Register your app's router
  getIt.registerSingleton(AppRoute.router);

  // Register controllers
  getIt.registerSingleton(HomeController());
  getIt.registerSingleton(ProfileController());

  // Set up app flavor (optional)
  AppFlavor().init(AppFlavors.development);

  // Initialize the package
  FlutterUtil.initialize(
    loaderSmall: const SpinKitCircle(color: Colors.blue),
    loaderMedium: const SpinKitCircle(color: Colors.blue),
    loaderLarge: const SpinKitCircle(color: Colors.blue),
    imagesError: "assets/images/error.png",
    imagesNoInternet: "assets/images/no_internet.png",
    imagesNoResults: "assets/images/no_results.png",
  );
}
```

#### Controller Implementation

```dart
class DevotionalController extends BaseController {
  // State variables
  LoadStatus initialStatus = LoadStatus.loading;
  LoadStatus loadMoreStatus = LoadStatus.idle;
  final List<DevotionModel> itemList = [];
  DevotionModel? newest;

  // Lifecycle method - called after initialization
  @override
  void onReady() {
    loadInitial();
    super.onReady();
  }

  // Business Logic
  Future<void> loadInitial() async {
    initialStatus = LoadStatus.loading;
    notifyListeners(); // Trigger UI update

    // API call or data fetching
    final response = await _apiService.getInitial();

    if (response.isSuccess) {
      itemList.clear();
      itemList.addAll(response.data);
      _loadNewest();
    }

    initialStatus = LoadStatus.success;
    notifyListeners(); // Trigger UI update
  }

  // More methods...
}
```

#### View Implementation

There are two ways to implement views:

1. Using `StatelessView`:

```dart
class DevotionPage extends StatelessView<DevotionalController> {
  const DevotionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Reactive section that updates when state changes
          ReactiveWidget<DevotionalController>(
            builder: (context, controller) {
              final latestDevotion = controller.newest;

              return latestDevotion == null
                  ? shrinkedSizedBox
                  : DevotionCard(devotion: latestDevotion);
            }
          ),

          // Another reactive section
          ReactiveWidget<DevotionalController>(
            builder: (context, controller) {
              if (controller.initialStatus == LoadStatus.loading) {
                return LoadingIndicator();
              }
              return DevotionContent(devotion: controller.newest);
            }
          ),
        ],
      ),
    );
  }
}
```

2. Using Regular StatelessWidget with ReactiveWidget:

```dart
class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveWidget<DevotionalController>(
      builder: (context, controller) {
        return LoadMore(
          status: controller.loadMoreStatus,
          onRefresh: controller.loadInitial,
          initialStatus: controller.initialStatus,
          onLoadMore: controller.loadMore,
          child: DevotionList(items: controller.itemList),
        );
      }
    );
  }
}
```

#### State Updates

To update the UI:

1. Modify your state variables
2. Call `notifyListeners()`
3. All `ReactiveWidget`s listening to the controller will rebuild

```dart
class MyController extends BaseController {
  String _message = '';
  String get message => _message;

  void updateMessage(String newMessage) {
    _message = newMessage;
    notifyListeners(); // Triggers rebuild of ReactiveWidgets
  }
}
```

#### Lifecycle Management

Controllers provide lifecycle hooks:

- `onInit`: Called when the controller is first created
- `onReady`: Called after the widget tree is built
- `dispose`: Called when the controller is disposed

For full app lifecycle management, use `FullLifeCycleController`:

```dart
class AppController extends FullLifeCycleController with FullLifeCycleMixin {
  @override
  void onResumed() => print('App in foreground');

  @override
  void onPaused() => print('App in background');

  @override
  void onInactive() => print('App inactive');

  @override
  void onDetached() => print('App detached');

  @override
  void onMinimised() => print('App minimized');
}
```

## Additional Information

### Contributing

Contributions are welcome! If you find a bug or want to add new features, please feel free to open an issue or submit a pull request.

### License

This project is licensed under the MIT License - see the LICENSE file for details.

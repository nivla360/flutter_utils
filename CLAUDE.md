# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter utility package (`flutter_utils`) that provides reusable components, extensions, widgets, and a lightweight state management solution. The package is designed to accelerate Flutter development by providing commonly needed functionality.

## Essential Commands

### Package Development
```bash
# Install dependencies for the main package
flutter pub get

# Analyze code for issues
flutter analyze

# Run tests (if any exist)
flutter test

# Format code
dart format lib/

# Check for outdated dependencies
flutter pub outdated
```

### Example App Development
```bash
# Navigate to example directory
cd example

# Install dependencies
flutter pub get

# Run the example app
flutter run

# Build APK for Android
flutter build apk

# Build for iOS
flutter build ios
```

## Architecture & Key Concepts

### State Management System

The package provides a custom state management solution built around:

1. **RootController** (`lib/state_management/src/root_controller.dart`): Base class extending `ChangeNotifier` that provides:
   - Lifecycle hooks: `onInit()`, `onReady()`, `dispose()`
   - Platform information (width, height, brightness)
   - Mount state tracking

2. **BaseController Pattern**: Projects using this package should extend `RootController` to create a `BaseController` that adds project-specific functionality like navigation access. Example:
   ```dart
   class BaseController extends RootController {
     GoRouter router = AppRoute.router;
     BuildContext? getContext() {
       return router.configuration.navigatorKey.currentContext;
     }
   }
   ```

3. **ReactiveWidget**: Rebuilds when controller state changes via `notifyListeners()`

4. **StatelessView**: Provides typed controller access without manual GetIt lookups

### Package Initialization

The package requires initialization in `main()`:
```dart
FlutterUtil.initialize(
  loaderSmall: Widget,
  loaderMedium: Widget,
  loaderLarge: Widget,
  imagesError: String (path),
  imagesNoInternet: String (path),
  imagesNoResults: String (path),
)
```

These parameters configure global widgets and assets used throughout the package, particularly in dialogs and error views.

### Extension Architecture

Context extensions (`lib/extensions/src/context_ext.dart`) provide dialog methods that depend on the initialized constants:
- `showLoadingDialog()` uses the configured loader widgets
- `showErrorDialog()`, `showSuccessDialog()`, `showNoInternetDialog()` use the configured image paths
- All dialogs follow a consistent pattern with customizable parameters

### Widget Dependencies

The `LoadMore` widget (`lib/widgets/src/load_more.dart`) provides pagination functionality with:
- Initial load status tracking
- Pull-to-refresh support
- Load more on scroll
- Animation support for new items
- Integration with the controller pattern

### Service Layer Structure

Services are meant to be registered with GetIt dependency injection:
- `ApiService`: Base class for API interactions (currently minimal implementation)
- `NavigationService`: Navigation helpers (currently minimal)
- `DialogService`: Dialog management (currently empty, functionality in context extensions)

## Critical Implementation Details

### Dependency Injection Setup
All controllers and services should be registered in GetIt during app initialization:
```dart
final getIt = GetIt.instance;
getIt.registerSingleton(HomeController());
getIt.registerSingleton(AppRoute.router);
```

### Navigation Integration
The package expects projects to use `go_router` with a centralized `AppRoute` class defining all routes. Controllers access navigation through the `BaseController.router` property.

### Error Handling Pattern
The package provides standardized error views and dialogs that expect specific image assets. These must be provided during initialization or the app will fail to display errors properly.

### Responsive Design
The package includes `flutter_screenutil` for responsive design. Initialize it in the main app:
```dart
ScreenUtilInit(
  designSize: ScreenUtil.defaultSize,
  builder: (context, child) => MaterialApp.router(...)
)
```

## Package Dependencies

Core dependencies that consuming projects inherit:
- `go_router`: Navigation
- `get_it`: Dependency injection
- `google_fonts`: Typography
- `flutter_spinkit`: Loading indicators
- `ionicons`: Icon set
- `flutter_screenutil`: Responsive design
- `flutter_styled_toast`: Toast messages
- `logger`: Logging utility
- `shared_preferences`: Local storage
- `flutter_animate`: Animation utilities
- `timeago`: Time formatting
- `intl`: Internationalization

## Publishing & Distribution

Currently distributed via Git dependency. To use in a Flutter project:
```yaml
dependencies:
  flutter_utils:
    git:
      url: https://github.com/nivla360/flutter_utils.git
```

## Testing Approach

The package currently has minimal test coverage. When adding new utilities:
- Test files go in `/test/`
- Run tests with `flutter test`
- Focus on testing utility functions and extensions that have complex logic
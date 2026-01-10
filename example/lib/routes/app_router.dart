import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';
import '../screens/home_screen.dart';
import '../screens/async_demo_screen.dart';
import '../screens/persistent_demo_screen.dart';
import '../screens/widgets_demo_screen.dart';
import '../screens/forms_demo_screen.dart';
import '../screens/extensions_demo_screen.dart';
import '../screens/services_demo_screen.dart';

export '../screens/screens.dart';

class AppRouter {
  static const String home = '/';
  static const String asyncDemo = '/async-demo';
  static const String persistentDemo = '/persistent-demo';
  static const String widgetsDemo = '/widgets-demo';
  static const String formsDemo = '/forms-demo';
  static const String extensionsDemo = '/extensions-demo';
  static const String servicesDemo = '/services-demo';
  
  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: asyncDemo,
        name: 'async-demo',
        builder: (context, state) => const AsyncDemoScreen(),
      ),
      GoRoute(
        path: persistentDemo,
        name: 'persistent-demo',
        builder: (context, state) => const PersistentDemoScreen(),
      ),
      GoRoute(
        path: widgetsDemo,
        name: 'widgets-demo',
        builder: (context, state) => const WidgetsDemoScreen(),
      ),
      GoRoute(
        path: formsDemo,
        name: 'forms-demo',
        builder: (context, state) => const FormsDemoScreen(),
      ),
      GoRoute(
        path: extensionsDemo,
        name: 'extensions-demo',
        builder: (context, state) => const ExtensionsDemoScreen(),
      ),
      GoRoute(
        path: servicesDemo,
        name: 'services-demo',
        builder: (context, state) => const ServicesDemoScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('The requested page "${state.uri}" could not be found.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
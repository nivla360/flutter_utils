import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/widgets/widgets.dart';

import 'main.dart';
import 'second_page.dart';

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
                  builder: (_, __) => const SecondPage())
            ])
      ]);
}

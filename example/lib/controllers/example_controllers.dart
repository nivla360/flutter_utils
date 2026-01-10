import 'package:flutter_utils/flutter_utils.dart';
import 'user_controller.dart';
import 'product_controller.dart';
import 'post_controller.dart';
import 'form_controller.dart';
import 'settings_controller.dart';
import 'counter_controller.dart';

export 'user_controller.dart';
export 'product_controller.dart';
export 'post_controller.dart';
export 'form_controller.dart';
export 'settings_controller.dart';
export 'counter_controller.dart';

class ExampleControllers {
  static void register() {
    final getIt = GetIt.instance;
    
    // Register all controllers as singletons
    getIt.registerLazySingleton<UserController>(() => UserController());
    getIt.registerLazySingleton<ProductController>(() => ProductController());
    getIt.registerLazySingleton<PostController>(() => PostController());
    getIt.registerLazySingleton<FormController>(() => FormController());
    getIt.registerLazySingleton<SettingsController>(() => SettingsController());
    getIt.registerLazySingleton<CounterController>(() => CounterController());
  }
  
  static void dispose() {
    final getIt = GetIt.instance;
    
    // Dispose controllers if needed
    if (getIt.isRegistered<UserController>()) {
      getIt<UserController>().dispose();
      getIt.unregister<UserController>();
    }
    if (getIt.isRegistered<ProductController>()) {
      getIt<ProductController>().dispose();
      getIt.unregister<ProductController>();
    }
    if (getIt.isRegistered<PostController>()) {
      getIt<PostController>().dispose();
      getIt.unregister<PostController>();
    }
    if (getIt.isRegistered<FormController>()) {
      getIt<FormController>().dispose();
      getIt.unregister<FormController>();
    }
    if (getIt.isRegistered<SettingsController>()) {
      getIt<SettingsController>().dispose();
      getIt.unregister<SettingsController>();
    }
    if (getIt.isRegistered<CounterController>()) {
      getIt<CounterController>().dispose();
      getIt.unregister<CounterController>();
    }
  }
}
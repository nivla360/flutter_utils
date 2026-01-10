import 'package:flutter_utils/flutter_utils.dart';
import 'mock_api_service.dart';

export 'mock_api_service.dart';

class ExampleServices {
  static Future<void> initialize() async {
    // Initialize storage service
    await StorageService.instance.initialize();
    
    // Initialize API service with mock configuration
    await ApiService().initialize(ApiServiceConfig(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      defaultHeaders: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      timeout: const Duration(seconds: 30),
      enableLogging: true,
    ));
    
    // Register mock service for examples
    GetIt.instance.registerSingleton<MockApiService>(MockApiService());
  }
}
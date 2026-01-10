import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// HTTP Method enum
enum HttpMethod { get, post, put, patch, delete, head }

/// API Response wrapper
class ApiResponse<T> {
  final T? data;
  final int statusCode;
  final String? message;
  final bool isSuccess;
  final Map<String, String>? headers;

  const ApiResponse({
    this.data,
    required this.statusCode,
    this.message,
    required this.isSuccess,
    this.headers,
  });

  factory ApiResponse.success(T data, int statusCode, {Map<String, String>? headers}) {
    return ApiResponse<T>(
      data: data,
      statusCode: statusCode,
      isSuccess: true,
      headers: headers,
    );
  }

  factory ApiResponse.error(String message, int statusCode, {Map<String, String>? headers}) {
    return ApiResponse<T>(
      message: message,
      statusCode: statusCode,
      isSuccess: false,
      headers: headers,
    );
  }
}

/// API Exception for handling HTTP errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const ApiException(this.message, {this.statusCode, this.originalError});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Request interceptor interface
abstract class RequestInterceptor {
  Future<http.Request> onRequest(http.Request request);
}

/// Response interceptor interface
abstract class ResponseInterceptor {
  Future<http.Response> onResponse(http.Response response);
}

/// Cache strategy enum
enum CacheStrategy {
  noCache,
  cacheFirst,
  networkFirst,
  cacheOnly,
  networkOnly,
}

/// API Service configuration
class ApiServiceConfig {
  final String baseUrl;
  final Map<String, String> defaultHeaders;
  final Duration timeout;
  final int maxRetries;
  final Duration retryDelay;
  final List<int> retryStatusCodes;
  final bool enableLogging;
  final Duration cacheExpiration;

  const ApiServiceConfig({
    required this.baseUrl,
    this.defaultHeaders = const {},
    this.timeout = const Duration(seconds: 30),
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.retryStatusCodes = const [408, 429, 500, 502, 503, 504],
    this.enableLogging = kDebugMode,
    this.cacheExpiration = const Duration(minutes: 5),
  });
}

/// Comprehensive API Service with retry logic, caching, and interceptors
class ApiService {
  late final ApiServiceConfig _config;
  late final http.Client _client;
  late final SharedPreferences _prefs;
  final List<RequestInterceptor> _requestInterceptors = [];
  final List<ResponseInterceptor> _responseInterceptors = [];
  bool _isInitialized = false;

  ApiService._();
  static final ApiService _instance = ApiService._();
  factory ApiService() => _instance;

  /// Initialize the API service
  Future<void> initialize(ApiServiceConfig config) async {
    _config = config;
    _client = http.Client();
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  /// Add a request interceptor
  void addRequestInterceptor(RequestInterceptor interceptor) {
    _requestInterceptors.add(interceptor);
  }

  /// Add a response interceptor
  void addResponseInterceptor(ResponseInterceptor interceptor) {
    _responseInterceptors.add(interceptor);
  }

  /// Make a GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    CacheStrategy cacheStrategy = CacheStrategy.networkFirst,
    Duration? customTimeout,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return _makeRequest<T>(
      HttpMethod.get,
      endpoint,
      headers: headers,
      queryParameters: queryParameters,
      cacheStrategy: cacheStrategy,
      customTimeout: customTimeout,
      fromJson: fromJson,
    );
  }

  /// Make a POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? customTimeout,
  }) async {
    return _makeRequest<T>(
      HttpMethod.post,
      endpoint,
      headers: headers,
      queryParameters: queryParameters,
      body: body,
      fromJson: fromJson,
      customTimeout: customTimeout,
    );
  }

  /// Make a PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? customTimeout,
  }) async {
    return _makeRequest<T>(
      HttpMethod.put,
      endpoint,
      headers: headers,
      queryParameters: queryParameters,
      body: body,
      fromJson: fromJson,
      customTimeout: customTimeout,
    );
  }

  /// Make a PATCH request
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? customTimeout,
  }) async {
    return _makeRequest<T>(
      HttpMethod.patch,
      endpoint,
      headers: headers,
      queryParameters: queryParameters,
      body: body,
      fromJson: fromJson,
      customTimeout: customTimeout,
    );
  }

  /// Make a DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? customTimeout,
  }) async {
    return _makeRequest<T>(
      HttpMethod.delete,
      endpoint,
      headers: headers,
      queryParameters: queryParameters,
      fromJson: fromJson,
      customTimeout: customTimeout,
    );
  }

  /// Internal method to make HTTP requests
  Future<ApiResponse<T>> _makeRequest<T>(
    HttpMethod method,
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    CacheStrategy cacheStrategy = CacheStrategy.networkFirst,
    Duration? customTimeout,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    if (!_isInitialized) {
      throw StateError('ApiService not initialized. Call initialize() first.');
    }

    final uri = _buildUri(endpoint, queryParameters);
    final cacheKey = _buildCacheKey(method, uri, body);

    // Handle cache strategy
    if (cacheStrategy == CacheStrategy.cacheOnly ||
        (cacheStrategy == CacheStrategy.cacheFirst && await _hasValidCache(cacheKey))) {
      final cached = await _getCachedResponse<T>(cacheKey, fromJson);
      if (cached != null) {
        if (_config.enableLogging) {
          debugPrint('🔄 Cache hit for ${method.name.toUpperCase()} $uri');
        }
        return cached;
      }
      if (cacheStrategy == CacheStrategy.cacheOnly) {
        return ApiResponse.error('No cached data available', 404);
      }
    }

    int attempts = 0;
    while (attempts <= _config.maxRetries) {
      try {
        final request = await _buildRequest(method, uri, headers, body);
        
        // Apply request interceptors
        http.Request processedRequest = request;
        for (final interceptor in _requestInterceptors) {
          processedRequest = await interceptor.onRequest(processedRequest);
        }

        if (_config.enableLogging) {
          debugPrint('🌐 ${method.name.toUpperCase()} $uri (Attempt ${attempts + 1})');
        }

        final response = await _client.send(processedRequest).timeout(
          customTimeout ?? _config.timeout,
        );

        final httpResponse = await http.Response.fromStream(response);

        // Apply response interceptors
        http.Response processedResponse = httpResponse;
        for (final interceptor in _responseInterceptors) {
          processedResponse = await interceptor.onResponse(processedResponse);
        }

        if (_shouldRetry(processedResponse.statusCode) && attempts < _config.maxRetries) {
          attempts++;
          await Future.delayed(_config.retryDelay);
          continue;
        }

        final apiResponse = await _handleResponse<T>(processedResponse, fromJson);

        // Cache successful GET requests
        if (method == HttpMethod.get && apiResponse.isSuccess && cacheStrategy != CacheStrategy.noCache) {
          await _cacheResponse(cacheKey, apiResponse);
        }

        return apiResponse;

      } catch (e) {
        if (attempts >= _config.maxRetries) {
          if (_config.enableLogging) {
            debugPrint('❌ Request failed after ${attempts + 1} attempts: $e');
          }
          
          // Try cache as fallback
          if (cacheStrategy != CacheStrategy.networkOnly) {
            final cached = await _getCachedResponse<T>(cacheKey, fromJson);
            if (cached != null) {
              return cached;
            }
          }
          
          return ApiResponse.error(
            _getErrorMessage(e),
            e is ApiException ? e.statusCode ?? 500 : 500,
          );
        }
        attempts++;
        await Future.delayed(_config.retryDelay);
      }
    }

    return ApiResponse.error('Max retry attempts exceeded', 500);
  }

  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParameters) {
    final baseUri = Uri.parse(_config.baseUrl);
    final uri = baseUri.resolve(endpoint);
    
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: {
        ...uri.queryParameters,
        ...queryParameters.map((key, value) => MapEntry(key, value.toString())),
      });
    }
    
    return uri;
  }

  Future<http.Request> _buildRequest(
    HttpMethod method,
    Uri uri,
    Map<String, String>? headers,
    dynamic body,
  ) async {
    final request = http.Request(method.name.toUpperCase(), uri);
    
    // Add default headers
    request.headers.addAll(_config.defaultHeaders);
    
    // Add custom headers
    if (headers != null) {
      request.headers.addAll(headers);
    }
    
    // Add body for applicable methods
    if (body != null && [HttpMethod.post, HttpMethod.put, HttpMethod.patch].contains(method)) {
      if (body is Map || body is List) {
        request.headers['Content-Type'] = 'application/json';
        request.body = jsonEncode(body);
      } else if (body is String) {
        request.body = body;
      }
    }
    
    return request;
  }

  Future<ApiResponse<T>> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) async {
    final headers = response.headers;
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        if (response.body.isEmpty) {
          return ApiResponse.success(null as T, response.statusCode, headers: headers);
        }
        
        final jsonData = jsonDecode(response.body);
        
        if (fromJson != null && jsonData is Map<String, dynamic>) {
          final data = fromJson(jsonData);
          return ApiResponse.success(data, response.statusCode, headers: headers);
        }
        
        return ApiResponse.success(jsonData as T, response.statusCode, headers: headers);
      } catch (e) {
        return ApiResponse.error('Failed to parse response: $e', response.statusCode);
      }
    } else {
      String errorMessage = 'HTTP ${response.statusCode}';
      try {
        final errorData = jsonDecode(response.body);
        if (errorData is Map<String, dynamic>) {
          errorMessage = errorData['message'] ?? errorData['error'] ?? errorMessage;
        }
      } catch (_) {
        errorMessage = response.body.isNotEmpty ? response.body : errorMessage;
      }
      
      return ApiResponse.error(errorMessage, response.statusCode, headers: headers);
    }
  }

  bool _shouldRetry(int statusCode) {
    return _config.retryStatusCodes.contains(statusCode);
  }

  String _getErrorMessage(dynamic error) {
    if (error is SocketException) {
      return 'No internet connection';
    } else if (error is TimeoutException) {
      return 'Request timeout';
    } else if (error is ApiException) {
      return error.message;
    } else {
      return error.toString();
    }
  }

  // Cache methods
  String _buildCacheKey(HttpMethod method, Uri uri, dynamic body) {
    final key = '${method.name}_${uri.toString()}';
    if (body != null) {
      final bodyHash = body.hashCode.toString();
      return '${key}_$bodyHash';
    }
    return key;
  }

  Future<void> _cacheResponse<T>(String key, ApiResponse<T> response) async {
    try {
      final cacheData = {
        'data': response.data,
        'statusCode': response.statusCode,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'headers': response.headers,
      };
      await _prefs.setString('api_cache_$key', jsonEncode(cacheData));
    } catch (e) {
      if (_config.enableLogging) {
        debugPrint('Failed to cache response: $e');
      }
    }
  }

  Future<ApiResponse<T>?> _getCachedResponse<T>(
    String key,
    T Function(Map<String, dynamic>)? fromJson,
  ) async {
    try {
      final cachedString = _prefs.getString('api_cache_$key');
      if (cachedString == null) return null;

      final cacheData = jsonDecode(cachedString) as Map<String, dynamic>;
      final timestamp = cacheData['timestamp'] as int;
      
      if (DateTime.now().millisecondsSinceEpoch - timestamp > _config.cacheExpiration.inMilliseconds) {
        await _prefs.remove('api_cache_$key');
        return null;
      }

      dynamic data = cacheData['data'];
      if (fromJson != null && data is Map<String, dynamic>) {
        data = fromJson(data);
      }

      return ApiResponse.success(
        data as T,
        cacheData['statusCode'] as int,
        headers: (cacheData['headers'] as Map<String, dynamic>?)?.cast<String, String>(),
      );
    } catch (e) {
      if (_config.enableLogging) {
        debugPrint('Failed to get cached response: $e');
      }
      return null;
    }
  }

  Future<bool> _hasValidCache(String key) async {
    try {
      final cachedString = _prefs.getString('api_cache_$key');
      if (cachedString == null) return false;

      final cacheData = jsonDecode(cachedString) as Map<String, dynamic>;
      final timestamp = cacheData['timestamp'] as int;
      
      return DateTime.now().millisecondsSinceEpoch - timestamp <= _config.cacheExpiration.inMilliseconds;
    } catch (e) {
      return false;
    }
  }

  /// Clear all cached responses
  Future<void> clearCache() async {
    final keys = _prefs.getKeys().where((key) => key.startsWith('api_cache_'));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  /// Clear specific cached response
  Future<void> clearCacheForKey(String key) async {
    await _prefs.remove('api_cache_$key');
  }

  /// Dispose resources
  void dispose() {
    _client.close();
    _requestInterceptors.clear();
    _responseInterceptors.clear();
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'root_controller.dart';

/// Enum representing different async operation states
enum AsyncState {
  idle,
  loading, 
  success,
  error,
}

/// A controller that extends RootController with built-in async state management
/// Provides common patterns for handling loading, success, and error states
abstract class AsyncController<T> extends RootController {
  AsyncState _state = AsyncState.idle;
  T? _data;
  String? _errorMessage;
  Object? _error;
  StackTrace? _stackTrace;
  
  /// Current async state
  AsyncState get state => _state;
  
  /// Data from the last successful operation
  T? get data => _data;
  
  /// Error message from the last failed operation
  String? get errorMessage => _errorMessage;
  
  /// Raw error object from the last failed operation
  Object? get error => _error;
  
  /// Stack trace from the last failed operation
  StackTrace? get stackTrace => _stackTrace;
  
  /// Whether the controller is currently loading
  bool get isLoading => _state == AsyncState.loading;
  
  /// Whether the controller has data
  bool get hasData => _data != null;
  
  /// Whether the controller has an error
  bool get hasError => _state == AsyncState.error;
  
  /// Whether the controller is idle (no operations performed)
  bool get isIdle => _state == AsyncState.idle;
  
  /// Whether the operation was successful
  bool get isSuccess => _state == AsyncState.success;

  /// Execute an async operation with automatic state management
  /// 
  /// [operation] - The async function to execute
  /// [onSuccess] - Optional callback called on successful completion
  /// [onError] - Optional callback called on error
  /// [clearPreviousData] - Whether to clear previous data when starting (default: true)
  Future<T?> executeAsync<R>(
    Future<T> Function() operation, {
    Function(T data)? onSuccess,
    Function(Object error, StackTrace stackTrace)? onError,
    bool clearPreviousData = true,
  }) async {
    // Set loading state
    _setState(AsyncState.loading);
    if (clearPreviousData) {
      _data = null;
      _error = null;
      _errorMessage = null;
      _stackTrace = null;
    }
    
    try {
      final result = await operation();
      _data = result;
      _setState(AsyncState.success);
      onSuccess?.call(result);
      return result;
    } catch (error, stackTrace) {
      _error = error;
      _stackTrace = stackTrace;
      _errorMessage = error.toString();
      _setState(AsyncState.error);
      onError?.call(error, stackTrace);
      return null;
    }
  }

  /// Execute an async operation without changing the loading state
  /// Useful for background operations that shouldn't affect the UI loading state
  Future<R?> executeSilently<R>(
    Future<R> Function() operation, {
    Function(R data)? onSuccess,
    Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    try {
      final result = await operation();
      onSuccess?.call(result);
      return result;
    } catch (error, stackTrace) {
      onError?.call(error, stackTrace);
      return null;
    }
  }

  /// Reset the controller to idle state
  void reset() {
    _data = null;
    _error = null;
    _errorMessage = null;
    _stackTrace = null;
    _setState(AsyncState.idle);
  }

  /// Set data directly and mark state as success
  void setData(T data) {
    _data = data;
    _error = null;
    _errorMessage = null;
    _stackTrace = null;
    _setState(AsyncState.success);
  }

  /// Set error directly and mark state as error
  void setError(Object error, {StackTrace? stackTrace, String? message}) {
    _error = error;
    _stackTrace = stackTrace;
    _errorMessage = message ?? error.toString();
    _setState(AsyncState.error);
  }

  /// Set the controller to loading state
  void setLoading() {
    _setState(AsyncState.loading);
  }

  void _setState(AsyncState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _data = null;
    _error = null;
    _errorMessage = null;
    _stackTrace = null;
    super.dispose();
  }
}

/// A widget that builds UI based on AsyncController state
class AsyncBuilder<T extends AsyncController> extends StatelessWidget {
  final T controller;
  final Widget Function(BuildContext context, T controller) onLoading;
  final Widget Function(BuildContext context, T controller) onSuccess;
  final Widget Function(BuildContext context, T controller) onError;
  final Widget Function(BuildContext context, T controller)? onIdle;

  const AsyncBuilder({
    super.key,
    required this.controller,
    required this.onLoading,
    required this.onSuccess,
    required this.onError,
    this.onIdle,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        switch (controller.state) {
          case AsyncState.idle:
            return onIdle?.call(context, controller) ?? const SizedBox.shrink();
          case AsyncState.loading:
            return onLoading(context, controller);
          case AsyncState.success:
            return onSuccess(context, controller);
          case AsyncState.error:
            return onError(context, controller);
        }
      },
    );
  }
}

/// A mixin that provides common async operations for controllers
mixin AsyncOperationsMixin<T> on AsyncController<T> {
  
  /// Retry the last operation
  Future<T?> retry() async {
    if (_lastOperation != null) {
      return executeAsync(_lastOperation!);
    }
    return null;
  }
  
  Future<T> Function()? _lastOperation;
  
  /// Execute an async operation and store it for potential retry
  Future<T?> executeWithRetry(
    Future<T> Function() operation, {
    Function(T data)? onSuccess,
    Function(Object error, StackTrace stackTrace)? onError,
    bool clearPreviousData = true,
  }) async {
    _lastOperation = operation;
    return executeAsync(
      operation,
      onSuccess: onSuccess,
      onError: onError,
      clearPreviousData: clearPreviousData,
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:f35_flight_compensation/core/error/error_handler.dart';

class MockErrorHandler implements ErrorHandler {
  final StreamController<AppError> _errorStreamController = StreamController<AppError>.broadcast();
  List<AppError> handledErrors = [];

  @override
  Stream<AppError> get errorStream => _errorStreamController.stream;

  @override
  void showErrorUI(BuildContext context, AppError error) {
    print('[MockErrorHandler] showErrorUI called with error: ${error.message}');
    // No-op for testing, or add specific mock behavior if needed
  }

  @override
  Future<void> handleError(dynamic error, {StackTrace? stackTrace, Map<String, dynamic>? context}) async {
    print('[MockErrorHandler] handleError called with error: $error');
    AppError appError;
    if (error is AppError) {
      appError = error;
    } else {
      appError = AppError(
        type: ErrorType.unknown,
        message: error.toString(),
        originalError: error,
        stackTrace: stackTrace,
        context: context,
      );
    }
    handledErrors.add(appError);
    _errorStreamController.add(appError); // Optionally emit if tests need to listen
  }

  void dispose() {
    _errorStreamController.close();
  }

  // Allow tests to clear handled errors
  void clearHandledErrors() {
    handledErrors.clear();
  }
}

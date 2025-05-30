import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Types of application errors for categorization
enum ErrorType {
  // Auth errors
  authenticationFailure,
  unauthorized,
  sessionExpired,
  
  // Network errors
  networkUnavailable,
  serverError,
  timeout,
  
  // Data errors
  dataNotFound,
  invalidData,
  
  // Document errors
  documentScanFailed,
  documentFormatUnsupported,
  
  // Flight errors
  flightNotFound,
  compensationCheckFailed,
  
  // Other
  unknown,
}

/// A structured error model for better handling and recovery
class AppError {
  final ErrorType type;
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? context;
  
  AppError({
    required this.type,
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
    this.context,
  });
  
  /// Create an error from a FirebaseAuthException
  factory AppError.fromAuthException(FirebaseAuthException e) {
    ErrorType type;
    String message;
    
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
        type = ErrorType.authenticationFailure;
        message = 'Invalid email or password';
        break;
      case 'requires-recent-login':
        type = ErrorType.sessionExpired;
        message = 'For security reasons, please sign in again to continue';
        break;
      case 'network-request-failed':
        type = ErrorType.networkUnavailable;
        message = 'Network connection problem. Please check your internet connection';
        break;
      default:
        type = ErrorType.authenticationFailure;
        message = 'Authentication error: ${e.message ?? e.code}';
    }
    
    return AppError(
      type: type,
      message: message,
      code: e.code,
      originalError: e,
      stackTrace: StackTrace.current,
    );
  }
  
  /// Create an error from a DioException (network)
  factory AppError.fromDioException(DioException e) {
    ErrorType type;
    String message;
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        type = ErrorType.timeout;
        message = 'Connection timed out. Please try again';
        break;
      case DioExceptionType.connectionError:
        type = ErrorType.networkUnavailable;
        message = 'Network connection problem. Please check your internet connection';
        break;
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          type = ErrorType.unauthorized;
          message = 'You are not authorized to perform this action';
        } else if (e.response?.statusCode == 404) {
          type = ErrorType.dataNotFound;
          message = 'The requested data could not be found';
        } else {
          type = ErrorType.serverError;
          message = 'Server error: ${e.response?.statusCode}';
        }
        break;
      default:
        type = ErrorType.unknown;
        message = 'Network error: ${e.message}';
    }
    
    return AppError(
      type: type,
      message: message,
      code: e.response?.statusCode?.toString(),
      originalError: e,
      stackTrace: StackTrace.current,
      context: {
        'url': e.requestOptions.path,
        'method': e.requestOptions.method,
        'statusCode': e.response?.statusCode,
      },
    );
  }
  
  /// Create generic app error
  factory AppError.generic(String message, {dynamic originalError}) {
    return AppError(
      type: ErrorType.unknown,
      message: message,
      originalError: originalError,
      stackTrace: StackTrace.current,
    );
  }
  
  /// Create network error
  factory AppError.network(String message, {dynamic originalError}) {
    return AppError(
      type: ErrorType.networkUnavailable,
      message: message,
      originalError: originalError,
      stackTrace: StackTrace.current,
    );
  }
  
  /// Create document scanning error
  factory AppError.documentScan(String message, {dynamic originalError}) {
    return AppError(
      type: ErrorType.documentScanFailed,
      message: message,
      originalError: originalError,
      stackTrace: StackTrace.current,
    );
  }
  
  /// Convert to map for logging
  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'message': message,
      'code': code,
      'error': originalError?.toString(),
      'context': context,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  @override
  String toString() => 'AppError: $message (Type: $type, Code: $code)';
}

/// Central error handling service for consistent error management
class ErrorHandler {
  final StreamController<AppError> _errorStreamController = StreamController<AppError>.broadcast();
  
  /// Stream of application errors for global handling
  Stream<AppError> get errorStream => _errorStreamController.stream;
  
  /// Log and handle an error
  Future<void> handleError(dynamic error, {StackTrace? stackTrace, Map<String, dynamic>? context}) async {
    AppError appError;
    
    // Convert to AppError based on error type
    if (error is AppError) {
      appError = error;
    } else if (error is FirebaseAuthException) {
      appError = AppError.fromAuthException(error);
    } else if (error is DioException) {
      appError = AppError.fromDioException(error);
    } else {
      appError = AppError(
        type: ErrorType.unknown,
        message: error.toString(),
        originalError: error,
        stackTrace: stackTrace ?? StackTrace.current,
        context: context,
      );
    }
    
    // Log the error
    _logError(appError);
    
    // Broadcast the error
    _errorStreamController.add(appError);
    
    // Return the error for chaining
    return;
  }
  
  /// Show appropriate UI for an error
  void showErrorUI(BuildContext context, AppError error) {
    // Different UI handling based on error type
    switch (error.type) {
      case ErrorType.networkUnavailable:
      case ErrorType.timeout:
        _showNetworkErrorSnackBar(context, error);
        break;
        
      case ErrorType.authenticationFailure:
      case ErrorType.unauthorized:
      case ErrorType.sessionExpired:
        _showAuthErrorDialog(context, error);
        break;
        
      case ErrorType.dataNotFound:
        _showNotFoundSnackBar(context, error);
        break;
        
      case ErrorType.documentScanFailed:
      case ErrorType.documentFormatUnsupported:
        _showDocumentErrorSnackBar(context, error);
        break;
        
      case ErrorType.flightNotFound:
      case ErrorType.compensationCheckFailed:
        _showFlightErrorDialog(context, error);
        break;
        
      default:
        _showGenericErrorSnackBar(context, error);
    }
  }
  
  /// Log error for analytics and debugging
  void _logError(AppError error) {
    if (kDebugMode) {
      print('🚨 ${error.toString()}');
      if (error.stackTrace != null) {
        print(error.stackTrace);
      }
      print('Context: ${error.context}');
    }
    
    // In a real app, you would send this to a logging service
    // such as Firebase Crashlytics or Sentry
  }
  
  /// Show network error with retry option
  void _showNetworkErrorSnackBar(BuildContext context, AppError error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.message),
        backgroundColor: Colors.red.shade800,
        duration: const Duration(seconds: 8),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () {
            // Retry logic would be handled by the caller
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.of(context).pop(true); // Return true to indicate retry
          },
        ),
      ),
    );
  }
  
  /// Show authentication error dialog
  void _showAuthErrorDialog(BuildContext context, AppError error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Authentication Error'),
        content: Text(error.message),
        actions: [
          if (error.type == ErrorType.sessionExpired)
            TextButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (Route<dynamic> route) => false,
              ),
              child: const Text('Sign In'),
            )
          else
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
        ],
      ),
    );
  }
  
  /// Show not found error
  void _showNotFoundSnackBar(BuildContext context, AppError error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.message),
        backgroundColor: Colors.orange.shade800,
        duration: const Duration(seconds: 5),
      ),
    );
  }
  
  /// Show document scanning error
  void _showDocumentErrorSnackBar(BuildContext context, AppError error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Document Scan Error',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(error.message),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: 'Try Again',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.of(context).pop(true); // Return true to indicate retry
          },
        ),
      ),
    );
  }
  
  /// Show flight-related error dialog
  void _showFlightErrorDialog(BuildContext context, AppError error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          error.type == ErrorType.flightNotFound
              ? 'Flight Not Found'
              : 'Compensation Check Failed',
        ),
        content: Text(error.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
  
  /// Show generic error snackbar
  void _showGenericErrorSnackBar(BuildContext context, AppError error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }
  
  /// Dispose resources
  void dispose() {
    _errorStreamController.close();
  }
}

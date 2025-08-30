import 'package:flutter/foundation.dart';

class ErrorHandlerService {
  static void handleError(Object error, StackTrace stackTrace) {
    // Log the error with full stack trace
    debugPrint('=== ERROR ===');
    debugPrint('Error: $error');
    debugPrint('Stack Trace:');
    debugPrint(stackTrace.toString());
    debugPrint('===============');
    
    // In a production app, you might want to send this to an error reporting service
    // For now, we'll just log it to the console
  }
  
  static void handleAsyncError(Future<void> Function() asyncFunction) {
    try {
      asyncFunction();
    } catch (error, stackTrace) {
      handleError(error, stackTrace);
    }
  }
}

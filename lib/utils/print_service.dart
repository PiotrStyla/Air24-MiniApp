import 'package:flutter/foundation.dart';

// This wrapper class helps avoid build errors with the printing package
// by conditionally importing it only when needed
class PrintService {
  // Flag to enable/disable printing functionality
  static const bool printingEnabled = false; // Set to false for release builds with printing issues
  
  // Method to print a document - returns true if printing is supported
  static bool printDocument() {
    if (!printingEnabled) {
      // Print functionality is disabled in this build to avoid Android resource linking errors
      debugPrint('Printing is disabled in this build. Enable in print_service.dart if needed.');
      return false;
    }
    
    // When enabled, this would use the printing package
    return false;
  }
  
  // Helper method to check if printing is available in this build
  static bool isPrintingAvailable() {
    return printingEnabled;
  }
}

// This file contains temporary build configuration to work around Android resource issues
// Remove this file and its imports after the proper fix is implemented

// Flag to disable printing functionality temporarily
const bool DISABLE_PRINTING = true;

// Use this function to conditionally show/hide printing-related features
bool shouldShowPrintingFeatures() {
  return !DISABLE_PRINTING;
}

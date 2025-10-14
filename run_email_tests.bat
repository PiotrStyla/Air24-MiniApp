@echo off
title Email Collection Tests
color 0A

echo ========================================
echo Running Email Collection Tests
echo ========================================
echo.

cd /d "%~dp0"

echo Running email collection dialog tests...
call flutter test test/email_collection_test.dart
set EMAIL_DIALOG_EXIT=%ERRORLEVEL%

echo.
echo Running World ID detection tests...
call flutter test test/world_id_email_detection_test.dart
set DETECTION_EXIT=%ERRORLEVEL%

echo.
echo ========================================
echo Test Results Summary
echo ========================================

if %EMAIL_DIALOG_EXIT% EQU 0 (
    echo ✓ Email Dialog Tests: PASSED
) else (
    echo ✗ Email Dialog Tests: FAILED
)

if %DETECTION_EXIT% EQU 0 (
    echo ✓ World ID Detection Tests: PASSED
) else (
    echo ✗ World ID Detection Tests: FAILED
)

echo ========================================
echo.

if %EMAIL_DIALOG_EXIT% EQU 0 if %DETECTION_EXIT% EQU 0 (
    echo ALL TESTS PASSED! ✓
    echo.
    echo Email collection feature is working correctly.
    echo Ready for World App Mini App submission.
) else (
    echo SOME TESTS FAILED!
    echo Please review the errors above.
)

echo.
pause

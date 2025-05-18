@echo off
echo Starting AeroDataBox API Hybrid Proxy with Persistent Storage...
echo.

REM Create data directory if it doesn't exist
if not exist "data" mkdir data

REM Kill any existing Python/Uvicorn processes
taskkill /F /IM python.exe > NUL 2>&1
taskkill /F /IM uvicorn.exe > NUL 2>&1

REM Launch the hybrid server
echo Starting server at http://0.0.0.0:8000
echo.
echo Press Ctrl+C to stop the server
echo.

uvicorn hybrid_server:app --host 0.0.0.0 --port 8000 --reload

echo Server stopped.

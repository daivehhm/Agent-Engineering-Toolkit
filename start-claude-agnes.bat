@echo off
setlocal
REM ========================================
REM  Start Claude agnes Provider
REM  Uses the settings file next to this script:
REM  .claude\settings-agnes.json
REM ========================================

set "PROJECT_DIR=D:\need-del\chrome-cache\Agent-Engineering-Toolkit-v1.3-LATEST\Agent-Engineering-Toolkit-v1.3\"
if not "%PROJECT_DIR:~-1%"=="\" (
  echo ERROR: PROJECT_DIR must end with backslash.
  echo        Current:  %PROJECT_DIR%
  echo        Expected: %PROJECT_DIR%\
  pause
  exit /b 1
)
set "SETTINGS_FILE=%PROJECT_DIR%.claude\settings-agnes.json"

if not exist "%SETTINGS_FILE%" (
  echo Settings file not found: "%SETTINGS_FILE%"
  pause
  exit /b 1
)

where claude >nul 2>nul
if errorlevel 1 (
  echo claude command was not found in PATH.
  echo Please make sure Claude Code is installed and available from Command Prompt.
  pause
  exit /b 1
)

pushd "%PROJECT_DIR%" || (
  echo Failed to enter project directory: "%PROJECT_DIR%"
  pause
  exit /b 1
)

claude --settings "%SETTINGS_FILE%"
set "EXIT_CODE=%ERRORLEVEL%"
popd
exit /b %EXIT_CODE%

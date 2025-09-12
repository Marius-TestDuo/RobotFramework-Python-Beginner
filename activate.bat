@echo off
set "VENV_DIR=%~dp0.venv"
set "ACTIVATE=%VENV_DIR%\Scripts\activate.bat"

if not exist "%ACTIVATE%" (
  echo [!] Virtual environment not found at "%VENV_DIR%".
  echo     Run: powershell -ExecutionPolicy Bypass -File .\scripts\setup.ps1
  exit /b 1
)

rem Usage:
rem   activate.bat        -> activate venv in current shell
rem   activate.bat --new  -> open new shell with venv activated

if /I "%1"=="--new" (
  echo Starting new Command Prompt with venv activated...
  cmd /k "%ACTIVATE%"
  goto :eof
)

call "%ACTIVATE%"
echo [OK] Activated virtual environment. To deactivate, run: deactivate

@echo off
setlocal
set "ROOT=%~dp0"

rem Activate venv if available
if exist "%ROOT%\.venv\Scripts\activate.bat" (
  call "%ROOT%\.venv\Scripts\activate.bat" >nul 2>&1
)

set "ARGFILE=%ROOT%\configs\robot\robot.args"
if not exist "%ARGFILE%" (
  echo [!] Argument file not found: %ARGFILE%
  exit /b 1
)

robot --argumentfile "%ARGFILE%" %*
endlocal

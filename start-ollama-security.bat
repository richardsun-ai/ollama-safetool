@echo off
echo ====== Ollama Security Tool ======

REM Check script
if not exist "%~dp0ollama-security-setup.ps1" (
    echo Error: Cannot find ollama-security-setup.ps1
    echo Please check file location
    pause
    exit /b 1
)

REM Run as admin
PowerShell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Start-Process PowerShell -ArgumentList '-NoExit -NoProfile -ExecutionPolicy Bypass -File \"%~dp0ollama-security-setup.ps1\"' -Verb RunAs"

if errorlevel 1 (
    echo Start failed:
    echo 1. Need admin rights
    echo 2. Script error
    echo 3. System error
    pause
    exit /b 1
)

exit 
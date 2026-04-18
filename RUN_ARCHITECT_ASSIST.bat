@echo off
title ARCHITECT_ASSIST - Professional AI Assistant
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo ============================================================
echo      ARCHITECT_ASSIST: Starting System...
echo ============================================================
echo.

:: 1. Check if Virtual Env exists
if not exist "venv\Scripts\python.exe" (
    echo [ERROR] Private workspace not found. 
    echo Please run INSTALL_WINDOWS.bat first.
    pause
    exit
)

:: 2. Check for Data Folder
if not exist "data" mkdir "data"

:: 3. Launch Application using Private Python
echo [System] Launching app in isolated environment...
"venv\Scripts\python.exe" -m streamlit run src/app.py --browser.gatherUsageStats false

:: Keep window open if it crashes
if %errorlevel% neq 0 (
    echo.
    echo [!!! ERROR !!!] Application stopped unexpectedly.
    pause
)

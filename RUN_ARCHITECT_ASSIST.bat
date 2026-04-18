@echo off
title ARCHITECT_ASSIST - Professional AI Assistant
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo ============================================================
echo      ARCHITECT_ASSIST: Starting System...
echo ============================================================
echo.

:: 1. Auto-Update (ถ้ามี Git)
if exist ".git" (
    echo [System] Checking for new features from GitHub...
    git pull origin main --quiet >nul 2>&1
    if %errorlevel% neq 0 (
        echo [Notice] Skipping update check (Offline).
    ) else (
        echo [Success] System is up to date!
    )
)

:: 2. Check if Virtual Env exists
if not exist "venv\Scripts\python.exe" (
    echo [ERROR] Private workspace not found. 
    echo Please run INSTALL_WINDOWS.bat first.
    pause
    exit
)

:: 3. Check for Data Folder
if not exist "data" mkdir "data"

:: 4. Launch Application
echo [System] Launching app...
"venv\Scripts\python.exe" -m streamlit run src/app.py --browser.gatherUsageStats false

:: Keep window open if it crashes
if %errorlevel% neq 0 (
    echo.
    echo [!!! ERROR !!!] Application stopped unexpectedly.
    pause
)

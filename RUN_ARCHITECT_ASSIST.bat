@echo off
title ARCHITECT_ASSIST - Professional AI Assistant
setlocal enabledelayedexpansion

:: 1. Set Working Directory
cd /d "%~dp0"

echo ============================================================
echo      ARCHITECT_ASSIST: Starting System...
echo ============================================================
echo.

:: 2. Check for Requirements
if not exist "src\app.py" (
    echo [ERROR] Application files not found. 
    echo Please make sure you have EXTRACTED the ZIP file.
    pause
    exit
)

:: 3. Check for Data Folder
if not exist "data" mkdir "data"

:: 4. Install/Update Dependencies (Silently)
echo [System] Checking AI Components...
python -m pip install -r requirements.txt --quiet --no-warn-script-location

:: 5. Launch Application
echo.
echo [Success] System is ready! Opening Browser...
echo.

:: Run Streamlit
python -m streamlit run src/app.py --browser.gatherUsageStats false

:: Keep window open if it crashes
if %errorlevel% neq 0 (
    echo.
    echo [!!! ERROR !!!] Application stopped unexpectedly.
    echo Please check the error messages above.
    pause
)

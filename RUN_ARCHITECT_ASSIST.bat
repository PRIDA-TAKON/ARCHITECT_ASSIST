@echo off
title ARCHITECT_ASSIST - Professional AI Assistant
echo ==========================================
echo    🏛️ ARCHITECT_ASSIST: Checking for Updates
echo ==========================================

cd /d %~dp0

:: Check if git is installed and it's a git repo
if exist .git (
    echo Checking for new features from GitHub...
    git pull origin main
) else (
    echo [Notice] Not a git repository. Skipping auto-update.
)

echo.
echo Installing/Updating requirements...
pip install -r requirements.txt --quiet

echo.
echo Starting ARCHITECT_ASSIST...
streamlit run src/app.py

pause

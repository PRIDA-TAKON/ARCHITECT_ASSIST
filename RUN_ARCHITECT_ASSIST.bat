@echo off
title 🏛️ ARCHITECT_ASSIST: Checking for Updates
cd /d "%~dp0"

echo ==========================================
echo    🏛️ ARCHITECT_ASSIST: Auto-Update
echo ==========================================

:: 1. อัปเดตข้อมูลโค้ดใหม่จาก GitHub
echo.
echo [1/2] Checking for new features from GitHub...
git pull origin main

:: 2. อัปเดตไลบรารี (Requirements)
echo.
echo [2/2] Installing/Updating requirements...
"venv\Scripts\python.exe" -m pip install -r requirements.txt --quiet

:: 3. รันโปรแกรม
echo.
echo Starting ARCHITECT_ASSIST...
"venv\Scripts\python.exe" -m streamlit run src/app.py --browser.gatherUsageStats false

pause

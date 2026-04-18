@echo off
title ARCHITECT_ASSIST - Debug Runner
setlocal enabledelayedexpansion

:: 1. ยืนยันตำแหน่งโฟลเดอร์
cd /d "%~dp0"
echo [Debug] Current Directory: %CD%

:: 2. ตรวจสอบว่ามี Python ในห้องทำงานจำลองไหม
if not exist "venv\Scripts\python.exe" (
    echo [ERROR] ไม่พบห้องทำงานจำลอง (venv)
    echo กรุณารันไฟล์ INSTALL_WINDOWS.bat ให้เสร็จสมบูรณ์ก่อนครับ
    pause
    exit
)

:: 3. ตรวจสอบไฟล์โปรแกรม
if not exist "src\app.py" (
    echo [ERROR] ไม่พบไฟล์ src\app.py 
    echo กรุณาตรวจสอบว่าไฟล์อยู่ในโฟลเดอร์ที่ถูกต้องหรือไม่
    pause
    exit
)

:: 4. พยายามอัปเดต (ถ้าทำได้)
if exist ".git" (
    echo [System] Checking for updates...
    git pull origin main
)

:: 5. รันโปรแกรมแบบแสดงรายละเอียด (ไม่ซ่อนหน้าจอ)
echo.
echo [System] Starting Streamlit...
echo ---------------------------------------------------
"venv\Scripts\python.exe" -m streamlit run src/app.py --browser.gatherUsageStats false
echo ---------------------------------------------------
echo.
echo [Debug] Program execution finished.
echo Exit Code: %errorlevel%
echo.
pause

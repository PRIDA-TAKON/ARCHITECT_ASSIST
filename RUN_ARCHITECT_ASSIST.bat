@echo off
setlocal enabledelayedexpansion
title ARCHITECT_ASSIST - Professional AI Assistant

:: 1. กำหนดตำแหน่งโฟลเดอร์ให้แน่นอน
cd /d "%~dp0"

echo ============================================================
echo      🏛️ ARCHITECT_ASSIST: Starting System...
echo ============================================================
echo.

:: 2. ตรวจสอบว่าแตกไฟล์หรือยัง
if not exist "src\app.py" (
    echo [ERROR] กรุณา "แตกไฟล์ (Extract All)" ออกจาก Zip ก่อนใช้งาน!
    echo [ERROR] Please Extract the ZIP file before running.
    echo.
    pause
    exit
)

:: 3. เช็ค Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [System] กำลังเตรียมระบบครั้งแรก (Installing Python)...
    winget install --id Python.Python.3.11 --exact --silent --accept-package-agreements >nul 2>&1
    if %errorlevel% neq 0 (
        echo [Error] ไม่พบ Python ในเครื่อง กรุณาติดตั้งจาก python.org
        pause
        exit
    )
    echo [Success] Python installed. Please RESTART this script.
    pause
    exit
)

:: 4. เช็คและติดตั้ง Requirements
echo [System] ตรวจสอบความพร้อมของ "สมองกล" AI...
python -m pip install -r requirements.txt --quiet --no-warn-script-location

:: 5. ตรวจสอบการอัปเดต (ถ้ามี Git)
if exist ".git" (
    git pull origin main --quiet >nul 2>&1
)

:: 6. รันโปรแกรม (ใช้ python -m streamlit เพื่อความชัวร์)
echo.
echo [Success] ระบบพร้อมใช้งานแล้ว! กำลังเปิดหน้าต่างโปรแกรม...
echo (หากหน้าเว็บไม่เปิดอัตโนมัติ ให้เปิด Browser ไปที่ http://localhost:8501)
echo.

:: รันโปรแกรมและค้างหน้าจอไว้ถ้ามี Error
python -m streamlit run src/app.py --browser.gatherUsageStats false

if %errorlevel% neq 0 (
    echo.
    echo [Error] เกิดข้อผิดพลาดในการรันโปรแกรมข้างต้น
    echo [Error] โปรดตรวจสอบ Error message ด้านบนครับ
    pause
)

exit

@echo off
setlocal enabledelayedexpansion
title ARCHITECT_ASSIST - Professional AI Assistant

:: 1. กำหนดตำแหน่งโฟลเดอร์ให้แน่นอน
cd /d "%~dp0"

echo ============================================================
echo      🏛️ ARCHITECT_ASSIST: Starting System...
echo ============================================================
echo.

:: 2. ตรวจสอบว่าแตกไฟล์หรือยัง (ถ้าอยู่ใน Zip จะหาไฟล์ src\app.py ไม่เจอ)
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
    echo [System] กำลังเตรียมระบบครั้งแรก (Installing Components)...
    :: พยายามใช้เครื่องมือที่มีใน Windows ติดตั้ง Python แบบเงียบ
    winget install --id Python.Python.3.11 --exact --silent --accept-package-agreements >nul 2>&1
    if %errorlevel% neq 0 (
        echo [Error] ไม่พบ Python ในเครื่อง กรุณาติดตั้งจาก python.org
        pause
        exit
    )
)

:: 4. เช็คและติดตั้ง Requirements (ทำแบบเงียบๆ)
echo [System] ตรวจสอบความพร้อมของ "สมองกล" AI...
pip install -r requirements.txt --quiet --no-warn-script-location

:: 5. ตรวจสอบการอัปเดต (ถ้ามี Git)
if exist ".git" (
    git pull origin main --quiet >nul 2>&1
)

:: 6. รันโปรแกรม
echo.
echo [Success] ระบบพร้อมใช้งานแล้ว! กำลังเปิดหน้าต่างโปรแกรม...
echo.

:: รัน Streamlit ในโหมดไม่มีหน้าจอดำค้าง (ถ้าเป็นไปได้)
start /b "" streamlit run src/app.py --browser.gatherUsageStats false

:: ปิดหน้าจอ Command ทิ้งหลังจาก 5 วินาที เพื่อไม่ให้เกะกะ
timeout /t 5 >nul
exit

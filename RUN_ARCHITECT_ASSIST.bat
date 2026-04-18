@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title ARCHITECT_ASSIST - Professional AI Assistant

cd /d "%~dp0"

echo ============================================================
echo      🏛️ ARCHITECT_ASSIST: กำลังเริ่มระบบ...
echo ============================================================
echo.

:: 1. สร้างโฟลเดอร์ data ถ้ายังไม่มี
if not exist "data" (
    echo [System] กำลังสร้างโฟลเดอร์สำหรับเก็บข้อมูล...
    mkdir "data"
)

:: 2. ตรวจสอบไฟล์โปรแกรม
if not exist "src\app.py" (
    echo [ERROR] ไม่พบไฟล์โปรแกรม (src\app.py)
    echo กรุณาแตกไฟล์ ZIP ให้เรียบร้อยก่อนครับ
    pause
    exit
)

:: 3. เช็คและติดตั้งส่วนประกอบที่จำเป็น (แอบทำเงียบๆ)
echo [System] ตรวจสอบความพร้อมของ "สมองกล" AI...
python -m pip install -r requirements.txt --quiet --no-warn-script-location

:: 4. เริ่มรันโปรแกรม
echo.
echo [Success] ระบบพร้อมใช้งานแล้ว! กำลังเปิดหน้าต่างโปรแกรม...
echo.

:: รัน Streamlit และค้างหน้าจอไว้ถ้าพัง
python -m streamlit run src/app.py --browser.gatherUsageStats false

if %errorlevel% neq 0 (
    echo.
    echo [!!! ERROR !!!] โปรแกรมหยุดทำงานกะทันหัน
    echo สาเหตุอาจเกิดจาก:
    echo 1. ยังไม่ได้ต่ออินเทอร์เน็ต
    echo 2. Library บางตัวติดตั้งไม่สมบูรณ์
    echo 3. มีปัญหาในไฟล์ src/app.py
    echo.
    echo --- รายละเอียด Error ด้านบน ---
    pause
)

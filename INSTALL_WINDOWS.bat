@echo off
:: บังคับให้หน้าจออ่านภาษาไทย (UTF-8)
chcp 65001 >nul
setlocal enabledelayedexpansion
title ARCHITECT_ASSIST: Professional Installer

echo ============================================================
echo      🏛️ ARCHITECT_ASSIST: Setup & Installation Wizard
echo ============================================================
echo.

:: 1. ตรวจสอบที่อยู่ไฟล์ (ห้ามรันจาก Temp/Zip)
set "CURRENT_DIR=%~dp0"
echo %CURRENT_DIR% | findstr /I "AppData\Local\Temp Temp1_" >nul
if %errorlevel%==0 (
    echo [!!! ERROR !!!] กรุณา "แตกไฟล์ (Extract All)" ก่อนรันไฟล์นี้ครับ
    pause
    exit /b
)

:: 2. Check for Python
echo [1/4] ตรวจสอบ Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [Notice] ไม่พบ Python กำลังติดตั้งให้ครับ...
    winget install --id Python.Python.3.11 --exact --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo [Error] ติดตั้งอัตโนมัติไม่สำเร็จ กรุณาโหลดจาก python.org
        pause
        exit /b
    )
)

:: 3. ติดตั้ง Library
echo [2/4] ติดตั้งส่วนประกอบ AI...
python -m pip install -r requirements.txt --quiet
python -m pip install Pillow --quiet

:: 4. สร้างไอคอนใหม่ (AA สีฟ้า)
echo [3/4] กำลังสร้างไอคอนหน้าจอ (AA Icon)...
set "SCRIPT_PATH=%~dp0RUN_ARCHITECT_ASSIST.bat"
set "WORKING_DIR=%~dp0"
set "ICON_PATH=%~dp0assets\icon.ico"
set "SHORTCUT_NAME=ARCHITECT_ASSIST"

:: สร้าง VBScript แบบเน้นความชัวร์
(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = oWS.SpecialFolders^("Desktop"^) ^& "\%SHORTCUT_NAME%.lnk"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "%SCRIPT_PATH%"
echo oLink.WorkingDirectory = "%WORKING_DIR%"
echo oLink.IconLocation = "%ICON_PATH%"
echo oLink.Description = "ARCHITECT_ASSIST: Your AI Design Partner"
echo oLink.Save
) > CreateShortcut.vbs

cscript /nologo CreateShortcut.vbs >nul 2>&1
del CreateShortcut.vbs

echo.
echo ============================================================
echo    ✅ การติดตั้งเสร็จสมบูรณ์!
echo ============================================================
echo [Success] สร้างไอคอน "AA สีฟ้า" ไว้ที่หน้าจอแล้ว
echo *หากไอคอนยังเป็นรูปเดิม ให้รีเฟรชหน้าจอ Desktop (กด F5)*
echo.
pause

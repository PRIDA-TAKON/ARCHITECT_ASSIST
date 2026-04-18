@echo off
setlocal enabledelayedexpansion
title ARCHITECT_ASSIST: Professional Installer
echo ============================================================
echo      🏛️ ARCHITECT_ASSIST: Setup & Installation Wizard
echo ============================================================
echo.

:: 1. ตรวจสอบว่ารันจากใน Zip หรือ Temp หรือไม่
set "CURRENT_DIR=%~dp0"
echo %CURRENT_DIR% | findstr /I "AppData\Local\Temp Temp1_" >nul
if %errorlevel%==0 (
    echo [!!! ERROR !!!]
    echo ตรวจพบว่าคุณรันตัวติดตั้งจากในไฟล์ ZIP โดยตรง!
    echo.
    echo วิธีแก้ไข:
    echo 1. ปิดหน้าต่างนี้
    echo 2. คลิกขวาที่ไฟล์ "ARCHITECT_ASSIST.zip"
    echo 3. เลือก "Extract All..." (ถอนการติดตั้งทั้งหมด)
    echo 4. เข้าไปในโฟลเดอร์ที่แตกออกมาแล้วค่อยรันไฟล์ "INSTALL_WINDOWS.bat" อีกครั้ง
    echo.
    pause
    exit /b
)

:: 2. Check for Python
echo [1/4] Checking for Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [Notice] Python not found. Installing Python via winget...
    winget install --id Python.Python.3.11 --exact --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo [Error] Failed to install Python. Please install it manually from python.org
        pause
        exit /b
    )
    echo [Success] Python installed successfully.
) else (
    echo [Success] Python is already installed.
)

:: 3. Check for Git
echo [2/4] Checking for Git...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [Notice] Git not found. Installing Git via winget...
    winget install --id Git.Git --exact --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo [Error] Failed to install Git. Please install it manually from git-scm.com
        pause
        exit /b
    )
    echo [Success] Git installed successfully.
) else (
    echo [Success] Git is already installed.
)

:: 4. Setup Project (No Git check here to keep it simple for downloaded ZIPs)
echo [3/4] Preparing Project Files...
pip install -r requirements.txt --quiet
if %errorlevel% neq 0 (
    python -m pip install -r requirements.txt --quiet
)

:: 5. Create Desktop Shortcut (More robust path handling)
echo [4/4] Creating Desktop Shortcut (AA Blue Icon)...
set "SCRIPT_PATH=%~dp0RUN_ARCHITECT_ASSIST.bat"
set "WORKING_DIR=%~dp0"
set "ICON_PATH=%~dp0assets\icon.ico"
set "SHORTCUT_NAME=ARCHITECT_ASSIST"

:: สร้าง VBScript แบบระบุตำแหน่งไฟล์ที่แน่นอนและมีเครื่องหมายคำพูดครอบคลุม
echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = oWS.SpecialFolders("Desktop") ^& "\%SHORTCUT_NAME%.lnk" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "%SCRIPT_PATH%" >> CreateShortcut.vbs
echo oLink.WorkingDirectory = "%WORKING_DIR%" >> CreateShortcut.vbs
echo oLink.IconLocation = "%ICON_PATH%,0" >> CreateShortcut.vbs
echo oLink.Description = "ARCHITECT_ASSIST: Your AI Design Partner" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs

cscript /nologo CreateShortcut.vbs
del CreateShortcut.vbs

echo.
echo ============================================================
echo    ✅ INSTALLATION COMPLETE!
echo ============================================================
echo.
echo [Success] สร้างไอคอน "AA สีฟ้า" ไว้ที่หน้าจอเรียบร้อย!
echo *หากเคยมีไอคอนเก่าที่ใช้ไม่ได้ ให้ลบทิ้งแล้วใช้ไอคอนใหม่นี้แทนครับ*
echo.
pause

@echo off
setlocal enabledelayedexpansion
title ARCHITECT_ASSIST: Professional Installer
cd /d "%~dp0"

echo ============================================================
echo      ARCHITECT_ASSIST: Setup Wizard (STABLE VERSION)
echo ============================================================
echo.

:: 1. Check Python Version (Must not be 3.14+)
echo [1/3] Checking Python Compatibility...
for /f "tokens=2" %%v in ('python --version 2^>^&1') do set "PY_VER=%%v"
echo Current Python: !PY_VER!

set "IS_INCOMPATIBLE=0"
echo !PY_VER! | findstr "3.14" >nul && set "IS_INCOMPATIBLE=1"
echo !PY_VER! | findstr "3.15" >nul && set "IS_INCOMPATIBLE=1"

if "!IS_INCOMPATIBLE!"=="1" (
    echo.
    echo [⚠️ WARNING] Python 3.14+ is NOT compatible with Google AI libraries.
    echo [System] Attempting to install STABLE Python 3.12 via winget...
    winget install --id Python.Python.3.12 --exact --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo [Error] Please UNINSTALL Python 3.14 and manually install Python 3.12
        pause
        exit /b
    )
    echo [Success] Python 3.12 installed. PLEASE CLOSE THIS WINDOW AND RUN AGAIN.
    pause
    exit /b
)

:: 2. Setup Project
echo [2/3] Preparing AI Components (Stable 3.12)...
python -m pip install --upgrade pip --quiet
python -m pip install -r requirements.txt --no-warn-script-location
python -m pip install Pillow --no-warn-script-location

:: 3. Create Desktop Shortcut (AA ICON)
echo [3/3] Creating Desktop Shortcut (AA BLUE ICON)...
set "SCRIPT_PATH=%~dp0RUN_ARCHITECT_ASSIST.bat"
set "WORKING_DIR=%~dp0"
set "ICON_PATH=%~dp0assets\icon.ico"
set "SHORTCUT_NAME=ARCHITECT_ASSIST"

echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = oWS.SpecialFolders("Desktop") ^& "\%SHORTCUT_NAME%.lnk" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "%SCRIPT_PATH%" >> CreateShortcut.vbs
echo oLink.WorkingDirectory = "%WORKING_DIR%" >> CreateShortcut.vbs
echo oLink.IconLocation = "%ICON_PATH%" >> CreateShortcut.vbs
echo oLink.Description = "ARCHITECT_ASSIST: Your AI Design Partner" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs

cscript /nologo CreateShortcut.vbs >nul 2>&1
del CreateShortcut.vbs

echo.
echo ============================================================
echo    ✅ INSTALLATION COMPLETE!
echo ============================================================
echo.
echo [Success] สร้างไอคอน "AA สีฟ้า" ไว้ที่หน้าจอเรียบร้อย!
echo คุณสามารถปิดหน้าต่างนี้และเริ่มใช้งานได้ทันทีครับ
echo.
pause

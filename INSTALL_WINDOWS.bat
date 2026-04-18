@echo off
setlocal enabledelayedexpansion
title ARCHITECT_ASSIST: Professional Installer
cd /d "%~dp0"

echo ============================================================
echo      ARCHITECT_ASSIST: Setup Wizard (Pro Version)
echo ============================================================
echo.

:: 1. Check for Python
echo [1/4] Checking for Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [Notice] Python not found. Installing Python 3.12...
    winget install --id Python.Python.3.12 --exact --silent --accept-package-agreements --accept-source-agreements
    echo [Success] Please RESTART this installer.
    pause
    exit
)

:: 2. Create Virtual Environment (The "Safe Box")
echo [2/4] Creating a private workspace (Virtual Env)...
if not exist "venv" (
    python -m venv venv
)

:: 3. Install Libraries into the Private Workspace
echo [3/4] Installing AI components into private workspace...
echo [System] This keeps your computer clean and avoids conflicts.
echo.

:: เรียกใช้ pip จากใน venv โดยตรง เพื่อไม่ให้ตีกับระบบหลัก
"venv\Scripts\python.exe" -m pip install --upgrade pip --quiet
"venv\Scripts\python.exe" -m pip install -r requirements.txt --no-warn-script-location
"venv\Scripts\python.exe" -m pip install Pillow --no-warn-script-location

:: 4. Create Desktop Shortcut
echo.
echo [4/4] Creating Desktop Shortcut (AA BLUE ICON)...
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
echo *ตอนนี้โปรแกรมถูกแยกส่วนไว้ใน "โฟลเดอร์ส่วนตัว" ไม่ตีกับใครแน่นอนครับ*
echo.
pause

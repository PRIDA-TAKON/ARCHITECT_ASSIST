@echo off
setlocal enabledelayedexpansion
title ARCHITECT_ASSIST: Professional Installer
cd /d "%~dp0"

echo ============================================================
echo      ARCHITECT_ASSIST: Setup Wizard
echo ============================================================
echo.

:: 1. Check for Temp folder (ZIP running)
echo %~dp0 | findstr /I "AppData\Local\Temp Temp1_" >nul
if %errorlevel%==0 (
    echo [ERROR] PLEASE EXTRACT THE ZIP FILE BEFORE RUNNING!
    pause
    exit /b
)

:: 2. Check for Python
echo [1/3] Checking for Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [Notice] Python not found. Installing via winget...
    winget install --id Python.Python.3.11 --exact --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo [Error] Automatic install failed. Download from python.org
        pause
        exit /b
    )
)

:: 3. Setup Project
echo [2/3] Preparing AI Components (This may take a minute)...
python -m pip install -r requirements.txt --quiet
python -m pip install Pillow --quiet

:: 4. Create Desktop Shortcut (AA ICON)
echo [3/3] Creating Desktop Shortcut (AA BLUE ICON)...
set "SCRIPT_PATH=%~dp0RUN_ARCHITECT_ASSIST.bat"
set "WORKING_DIR=%~dp0"
set "ICON_PATH=%~dp0assets\icon.ico"
set "SHORTCUT_NAME=ARCHITECT_ASSIST"

:: VBScript Creator with double quotes for safety
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
echo [Success] สร้างไอคอน "AA สีฟ้า" ไว้ที่หน้าจอแล้ว!
echo คุณสามารถเริ่มใช้งานได้ทันทีโดยการดับเบิลคลิกที่ไอคอนครับ
echo.
pause

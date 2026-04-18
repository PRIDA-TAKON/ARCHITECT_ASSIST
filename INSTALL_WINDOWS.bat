@echo off
setlocal
title ARCHITECT_ASSIST: Professional Installer
echo ============================================================
echo      🏛️ ARCHITECT_ASSIST: Setup & Installation Wizard
echo ============================================================
echo.

:: 1. Check for Python
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

:: 2. Check for Git
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

:: 3. Setup Project
echo [3/4] Setting up ARCHITECT_ASSIST repository...
if not exist ".git" (
    echo Cloning latest code from GitHub...
    git clone https://github.com/PRIDA-TAKON/ARCHITECT_ASSIST.git .
) else (
    echo Repository already exists. Checking for updates...
    git pull origin main
)

echo Installing required libraries (this may take a minute)...
pip install -r requirements.txt --quiet
if %errorlevel% neq 0 (
    echo [Notice] Retrying pip install...
    python -m pip install -r requirements.txt --quiet
)

:: 4. Create Desktop Shortcut
echo [4/4] Creating Desktop Shortcut...
set SCRIPT_PATH=%~dp0RUN_ARCHITECT_ASSIST.bat
set SHORTCUT_NAME=ARCHITECT_ASSIST
set LOGO_PATH=%~dp0assets\icon.ico

:: Creating VBScript to create shortcut with the new AA Icon
echo set WshShell = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo set oShellLink = WshShell.CreateShortcut(WshShell.SpecialFolders("Desktop") ^& "\%SHORTCUT_NAME%.lnk") >> CreateShortcut.vbs
echo oShellLink.TargetPath = "%SCRIPT_PATH%" >> CreateShortcut.vbs
echo oShellLink.WorkingDirectory = "%~dp0" >> CreateShortcut.vbs
echo oShellLink.IconLocation = "%LOGO_PATH%" >> CreateShortcut.vbs
echo oShellLink.Description = "ARCHITECT_ASSIST: Your AI Design Partner" >> CreateShortcut.vbs
echo oShellLink.Save >> CreateShortcut.vbs

cscript /nologo CreateShortcut.vbs
del CreateShortcut.vbs

echo.
echo ============================================================
echo    ✅ INSTALLATION COMPLETE!
echo ============================================================
echo.
echo [Success] สร้างไอคอน "ARCHITECT_ASSIST" (AA สีฟ้า) ไว้ที่หน้าจอแล้ว!
echo คุณสามารถเริ่มใช้งานได้ทันทีโดยการดับเบิลคลิกที่ไอคอนครับ
echo.
pause

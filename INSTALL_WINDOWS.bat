@echo off
setlocal enabledelayedexpansion
title ARCHITECT_ASSIST: Professional Installer
cd /d "%~dp0"

echo ============================================================
echo      ARCHITECT_ASSIST: Setup Wizard (STABLE 3.11)
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

:: 2. Create Virtual Environment
echo [2/4] Creating a private workspace (Virtual Env)...
if not exist "venv" (
    echo [System] Setting up environment...
    python -m venv venv
)

:: 3. Install Libraries into the Private Workspace
echo [3/4] Installing AI components...
echo [System] Downloading stable components (Please wait)...
echo.

:: อัปเดต pip ก่อน
"venv\Scripts\python.exe" -m pip install --upgrade pip --quiet

:: ติดตั้งทีละตัว (เพื่อไม่ให้พังกลางคัน)
"venv\Scripts\python.exe" -m pip install streamlit pandas openpyxl ezdxf langgraph langchain langchain-google-vertexai langchain-google-genai google-cloud-aiplatform pytest python-dotenv Pillow --no-warn-script-location

:: ตรวจสอบการติดตั้งเบื้องต้น
if not exist "venv\Scripts\streamlit.exe" (
    echo.
    echo [!!! ERROR !!!] Installation failed to complete streamlit component.
    echo Please check your internet and try again.
    pause
    exit
)

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
echo [Success] ทุกอย่างพร้อมใช้งาน 100% แล้วครับ!
echo คุณสามารถรันโปรแกรมผ่านไอคอน "AA สีฟ้า" ที่หน้าจอได้เลย
echo.
pause

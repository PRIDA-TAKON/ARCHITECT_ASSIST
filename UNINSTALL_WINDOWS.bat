@echo off
setlocal
title ARCHITECT_ASSIST: Uninstaller
echo ============================================================
echo      🏛️ ARCHITECT_ASSIST: Uninstallation Wizard
echo ============================================================
echo.
echo This will remove the Desktop Shortcut and clean up the app.
echo Note: This script will NOT uninstall Python or Git as they might be used by other apps.
echo.
set /p confirm="Are you sure you want to uninstall ARCHITECT_ASSIST? (Y/N): "
if /i "%confirm%" neq "Y" exit /b

:: 1. Remove Desktop Shortcut
echo Removing Desktop Shortcut...
set SHORTCUT_NAME=ARCHITECT_ASSIST.lnk
if exist "%USERPROFILE%\Desktop\%SHORTCUT_NAME%" (
    del "%USERPROFILE%\Desktop\%SHORTCUT_NAME%"
    echo [Success] Shortcut removed.
) else (
    echo [Notice] Shortcut not found on Desktop.
)

:: 2. Information about Folder
echo.
echo ------------------------------------------------------------
echo To complete the uninstallation, please manually delete 
echo this entire folder:
echo "%~dp0"
echo ------------------------------------------------------------
echo.
echo Thank you for using ARCHITECT_ASSIST!
pause

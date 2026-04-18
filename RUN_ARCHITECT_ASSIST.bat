@echo off
title ARCHITECT_ASSIST
cd /d "%~dp0"

:: 1. อัปเดตข้อมูลโมเดลใหม่จาก GitHub อัตโนมัติ
git pull origin main --quiet >nul 2>&1

:: 2. รันโปรแกรมทันที (ใช้ตัว Python ในห้องทำงานส่วนตัวที่เราสร้างไว้ตอนติดตั้ง)
"venv\Scripts\python.exe" -m streamlit run src/app.py --browser.gatherUsageStats false

pause

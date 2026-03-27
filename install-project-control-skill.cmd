@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%scripts\install-project-control-skill.ps1" -Action Install
set "EXIT_CODE=%ERRORLEVEL%"

echo.
if not "%EXIT_CODE%"=="0" (
    echo project-control skill 설치에 실패했습니다.
    pause
    exit /b %EXIT_CODE%
)

echo project-control skill 설치가 완료되었습니다.
pause


@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%scripts\install-project-control-skill-claude.ps1" -Action Install
set "EXIT_CODE=%ERRORLEVEL%"

echo.
if not "%EXIT_CODE%"=="0" (
    echo project-control skill (Claude Code) install failed.
    pause
    exit /b %EXIT_CODE%
)

echo project-control skill (Claude Code) install completed.
echo If the skill does not appear, open a new Claude Code session in this workspace.
pause

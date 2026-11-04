@echo off
chcp 65001 >nul
setlocal
title November is Coming - UTN FRBA

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0jugar.ps1"

if errorlevel 1 (
    echo.
    echo El juego se cerro con un error. Revisa el mensaje de arriba.
    pause
)

endlocal

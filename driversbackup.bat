@echo off
title Backup de Drivers do Sistema
color 0A

:: Altera a codificação do CMD para UTF-8
chcp 65001 > nul

echo.
echo ============================================
echo   Iniciando o backup de drivers do sistema
echo ============================================
echo.

:: Define o caminho de destino
set "DESTINO=C:\Drivers-Backup"

:: Cria a pasta se ela não existir
if not exist "%DESTINO%" (
    echo Criando pasta de destino: %DESTINO%
    mkdir "%DESTINO%"
)

:: Executa o PowerShell para exportar os drivers
echo Exportando drivers para %DESTINO%...
powershell -Command "Export-WindowsDriver -Online -Destination '%DESTINO%'"

echo.
echo Backup concluído com sucesso!
pause

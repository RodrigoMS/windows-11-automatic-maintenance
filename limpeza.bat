@echo off
title Limpeza rápida ao iniciar
color 0A

:: Altera a codificacao do CMD para UTF-8 para evitar problemas com acentuacao
chcp 65001 > nul

echo Iniciando limpeza rápida do sistema...
echo.

:: ---------------------------------
:: Limpeza de arquivos temporários
:: ---------------------------------

echo Limpando temporários do usuário...
DEL /F /S /Q %USERPROFILE%\AppData\Local\Temp\*.*

echo Limpando temporários do Windows...
DEL /F /S /Q C:\Windows\Temp\*.*

echo Limpando arquivos de pré-carregamento (Prefetch)...
DEL /F /S /Q C:\Windows\Prefetch\*.*

:: ---------------------------------
:: Limpeza de cache e lixeira
:: ---------------------------------

echo Limpando lixeira...
rd /s /q C:\$Recycle.Bin

echo Limpando cache DNS...
ipconfig /flushdns

echo Limpando cache de miniaturas...
del /f /s /q %LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db

echo Limpando cache de ícones...
ie4uinit.exe -ClearIconCache

:: ---------------------------------
:: Remoção de logs do sistema
:: ---------------------------------

echo Removendo arquivos de log do Windows...
del /s /q C:\Windows\System32\LogFiles\*.log

:: ---------------------------------
:: Remoção de histórico de navegação
:: ---------------------------------

echo Apagando histórico de navegação do Chrome e Edge...

powershell -Command ^
"Get-Process ^| Where-Object { $_.ProcessName -like '*chrome*' -or $_.ProcessName -like '*msedge*' } ^| Stop-Process -Force -ErrorAction SilentlyContinue; ^
$chromeProfiles = Get-ChildItem -Path \"$env:LOCALAPPDATA\Google\Chrome\User Data\" -Directory ^| Where-Object { $_.Name -like 'Default' -or $_.Name -like 'Profile*' }; ^
foreach ($profile in $chromeProfiles) { ^
    $historyPath = Join-Path $profile.FullName 'History'; ^
    if (Test-Path $historyPath) { Remove-Item -Path $historyPath -Force -ErrorAction SilentlyContinue } ^
}; ^
$edgeProfiles = Get-ChildItem -Path \"$env:LOCALAPPDATA\Microsoft\Edge\User Data\" -Directory ^| Where-Object { $_.Name -like 'Default' -or $_.Name -like 'Profile*' }; ^
foreach ($profile in $edgeProfiles) { ^
    $historyPath = Join-Path $profile.FullName 'History'; ^
    if (Test-Path $historyPath) { Remove-Item -Path $historyPath -Force -ErrorAction SilentlyContinue } ^
}"

echo Histórico removido com sucesso (se existente).

echo Limpeza rápida concluída com sucesso!
exit

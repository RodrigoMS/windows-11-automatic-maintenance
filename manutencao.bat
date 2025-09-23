@echo off
title Manutenção e Otimização do Windows 11
color 0A

:: Altera a codificacao do CMD para UTF-8 para evitar problemas com acentuacao
chcp 65001 > nul

echo Iniciando manutenção do sistema...
echo.

:: ---------------------------------
::      Ponto de restauração
:: ---------------------------------

:: echo Limpando pontos de restauração anteriores...
:: powershell -Command "Disable-ComputerRestore -Drive 'C:'; Enable-ComputerRestore -Drive 'C:'"

echo Criando ponto de restauração...
powershell -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'ManutencaoAutomatica_%date%' -RestorePointType 'MODIFY_SETTINGS'"

echo.

:: ---------------------------------
:: Diagnóstico e ajustes do sistema
:: ---------------------------------

:: Verifica a integridade da imagem do sistema (manual)
:: dism.exe /online /cleanup-image /scanhealth

echo Corrigindo imagem do sistema...
dism.exe /online /cleanup-image /restorehealth

echo Verificando arquivos do sistema...
sfc /scannow

echo Limpando componentes antigos...
dism.exe /online /cleanup-image /startcomponentcleanup /resetbase

:: Desfragmentação se for HDD
echo Verificando tipo de disco...
powershell -Command "Get-PhysicalDisk | Where-Object MediaType -eq 'HDD' | ForEach-Object { if ($_ -ne $null) { Write-Host 'Disco HDD detectado. Executando desfragmentação...'; Start-Process defrag -ArgumentList 'C: /U /V' -Wait } else { Write-Host 'SSD detectado. Desfragmentação ignorada.' } }"

echo.
:: ---------------------------------
:: Limpeza do Sistema
:: ---------------------------------

:: Configuração manual do perfil de limpeza
:: cleanmgr /sageset:1

echo Executando limpeza com Cleanmgr...
cleanmgr /sagerun:1

echo Limpando lixeira...
rd /s /q C:\$Recycle.Bin

:: Limpeza da pasta Downloads (manual, risco de perda)
:: forfiles /p "%USERPROFILE%\Downloads" /s /m *.* /c "cmd /c if not @ext==ini del /F /Q @path" /d -30

echo Limpando temporários do usuário...
DEL /F /S /Q %USERPROFILE%\AppData\Local\Temp\*.*

echo Limpando temporários do Windows...
DEL /F /S /Q C:\Windows\Temp\*.*

echo Limpando prefetch...
DEL /F /S /Q C:\Windows\Prefetch\*.*

echo Limpando cache DNS...
ipconfig /flushdns

echo Removendo logs do sistema...
del /s /q C:\Windows\System32\LogFiles\*.log

:: Limpeza da Microsoft Store (manual, instável)
:: wsreset

echo.

:: ---------------------------------
:: Otimizações
:: ---------------------------------

echo Listando drivers instalados...
driverquery /v

:: Gerenciar serviços (manual)
:: services.msc

:: Gerenciar inicialização (manual)
:: taskmgr

:: Atualizar drivers (manual)
:: devmgmt.msc

echo Limpando arquivos de atualização do Windows...
net stop wuauserv
del /q /f /s %windir%\SoftwareDistribution\Download\*.*
net start wuauserv

echo Limpando cache de miniaturas...
del /f /s /q %LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db

echo Limpando cache de ícones...
ie4uinit.exe -ClearIconCache

:: Verificar confiabilidade (manual)
:: perfmon /rel

:: ---------------------------------
:: Passar Anti-virus
:: ---------------------------------

:: Atualizar as definições de ameaças do Windows Defender
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate

:: Verificação de Virus do Windows Defender
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2

:: ---------------------------------
:: Finalização
:: ---------------------------------

:: Apagar o próprio script (opcional e manual)
:: DEL %0

echo Verificando disco rígido (requer reinicialização)...
echo S | chkdsk C: /F /R

echo O sistema será reiniciado em 10 segundos...
shutdown /r /t 10

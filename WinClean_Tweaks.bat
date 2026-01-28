@echo off
chcp 1251 >nul
title Администратор: WinClean - Твики
color 0F
setlocal enabledelayedexpansion

:TWEAKS_MENU
cls
echo ========================================
echo   Администратор: WinClean
echo               Твики
echo ========================================
echo.
echo        Службы и процессы
echo [1]  Оптимизировать процесс svchost
echo [2]  Оптимизировать Планировщик задач
echo [3]  Уменьшить размер и количество системных отчётов
echo [4]  Активировать отложенный запуск автоматических служб
echo.
echo        Системные функции
echo [5]  Отключить GameDVR
echo [6]  Отключить VBS и HVCI
echo [7]  Отключить функцию "Возобновить"
echo [8]  Отключить фоновые приложения
echo [9]  Отключить Удаленный помощник и Удаленный рабочий стол
echo.
echo        Быстродействие
echo [10] Ускорить открытие папок
echo [11] Увеличить размер кэша превью изображений
echo [12] Схема питания "Максимальная производительность"
echo [13] Принудительное закрытие программ при выключении
echo [14] Ускорить запуск программ из автозагрузки
echo.
echo ========================================
echo [0] Назад в Оптимизацию
echo.
set /p choice="Выберите пункт [0-14]: "

if "%choice%"=="0" exit /b
if "%choice%"=="1" goto TWEAK_SVCHOST
if "%choice%"=="2" goto TWEAK_TASK_SCHED
if "%choice%"=="3" goto TWEAK_REPORTS
if "%choice%"=="4" goto TWEAK_DELAYED_START
if "%choice%"=="5" goto TWEAK_GAMEDVR
if "%choice%"=="6" goto TWEAK_VBS_HVCI
if "%choice%"=="7" goto TWEAK_RESUME
if "%choice%"=="8" goto TWEAK_BACKGROUND_APPS
if "%choice%"=="9" goto TWEAK_REMOTE
if "%choice%"=="10" goto TWEAK_FOLDER_OPEN
if "%choice%"=="11" goto TWEAK_THUMB_CACHE
if "%choice%"=="12" goto TWEAK_POWER_SCHEME
if "%choice%"=="13" goto TWEAK_FORCE_CLOSE
if "%choice%"=="14" goto TWEAK_STARTUP_SPEED
goto TWEAKS_MENU

:: --- Службы и процессы ---
:TWEAK_SVCHOST
echo [1] Оптимизация svchost...
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v SvcHostSplitThresholdInKB /t REG_DWORD /d 4194304 /f
echo    -> Максимальный размер группы svchost увеличен.
pause
goto TWEAKS_MENU

:TWEAK_TASK_SCHED
echo [2] Оптимизация Планировщика задач...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Configuration" /v AllowStartOnDemand /t REG_DWORD /d 0 /f
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable 2>nul
schtasks /change /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable 2>nul
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable 2>nul
echo    -> Ненужные системные задачи отключены.
pause
goto TWEAKS_MENU

:TWEAK_REPORTS
echo [3] Уменьшаю системные отчеты...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v ScenarioExecutionEnabled /t REG_DWORD /d 0 /f
wevtutil set-log "Microsoft-Windows-Diagnostics-Performance/Operational" /enabled:false 2>nul
wevtutil set-log "Microsoft-Windows-Kernel-EventTracing/Admin" /enabled:false 2>nul
echo    -> Диагностические журналы отключены.
pause
goto TWEAKS_MENU

:TWEAK_DELAYED_START
echo [4] Включаю отложенный запуск служб...
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f
sc config "SysMain" start= delayed-auto 2>nul
sc config "WSearch" start= delayed-auto 2>nul
sc config "wuauserv" start= delayed-auto 2>nul
echo    -> Ключевые службы переведены на отложенный запуск.
pause
goto TWEAKS_MENU

:: --- Системные функции ---
:TWEAK_GAMEDVR
echo [5] Отключаю GameDVR...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f
echo    -> Запись игр и игровая панель отключены.
pause
goto TWEAKS_MENU

:TWEAK_VBS_HVCI
echo [6] Отключаю VBS и HVCI...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /t REG_DWORD /d 0 /f
bcdedit /set hypervisorlaunchtype off 2>nul
bcdedit /set vsmlaunchtype off 2>nul
echo    -> Виртуализация безопасности отключена.
pause
goto TWEAKS_MENU

:TWEAK_RESUME
echo [7] Отключаю функцию "Возобновить"...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f
echo    -> Быстрый запуск и возобновление работы отключены.
pause
goto TWEAKS_MENU

:TWEAK_BACKGROUND_APPS
echo [8] Отключаю фоновые приложения...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsRunInBackground /t REG_DWORD /d 2 /f
echo    -> Все фоновые приложения отключены.
pause
goto TWEAKS_MENU

:TWEAK_REMOTE
echo [9] Отключаю удаленный доступ...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
sc config TermService start= disabled >nul
sc stop TermService >nul
sc config RemoteRegistry start= disabled >nul
sc stop RemoteRegistry >nul
echo    -> Удаленный рабочий стол, помощник и реестр отключены.
pause
goto TWEAKS_MENU

:: --- Быстродействие ---
:TWEAK_FOLDER_OPEN
echo [10] Ускоряю открытие папок...
reg add "HKCU\Control Panel\Desktop" /v AutoCheckSelect /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRemoteRecursiveEvents /t REG_DWORD /d 1 /f
echo    -> Кэширование эскизов и отключение проверок применено.
pause
goto TWEAKS_MENU

:TWEAK_THUMB_CACHE
echo [11] Увеличиваю кэш превью...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ThumbnailSize /t REG_DWORD /d 512 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ThumbnailCacheSize /t REG_DWORD /d 16384 /f
echo    -> Размер кэша эскизов увеличен до 16 МБ.
pause
goto TWEAKS_MENU

:TWEAK_POWER_SCHEME
echo [12] Включаю максимальную производительность...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>nul
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 2>nul
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>nul
echo    -> Схема "Максимальная производительность" активна.
pause
goto TWEAKS_MENU

:TWEAK_FORCE_CLOSE
echo [13] Принудительное закрытие программ...
reg add "HKCU\Control Panel\Desktop" /v AutoEndTasks /t REG_SZ /d 1 /f
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 1000 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f
echo    -> Таймауты уменьшены, программы будут закрываться принудительно.
pause
goto TWEAKS_MENU

:TWEAK_STARTUP_SPEED
echo [14] Ускоряю запуск из автозагрузки...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f
echo    -> Задержка автозагрузки устранена.
pause
goto TWEAKS_MENU

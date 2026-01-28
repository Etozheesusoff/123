@echo off
chcp 1251 >nul
title Администратор: WinClean
color 0F
setlocal enabledelayedexpansion

:MAIN_MENU
cls
echo ========================================
echo   Администратор: WinClean
echo ========================================
echo.
echo [1] Отключить файл подкачки
echo [2] Отключить файл гибернации
echo [3] Отключить зарезервированное хранилище
echo [4] Отключить точки восстановления
echo [5] Твики
echo.
echo [6] Очистка хранилища Winsxs
echo [7] Сжатие системы
echo [8] Драйверы
echo.
echo ========================================
echo [0] Выход
echo.
set /p choice="Выберите пункт [0-8]: "

if "%choice%"=="1" goto OPT_PAGE_FILE
if "%choice%"=="2" goto OPT_HIBERNATION
if "%choice%"=="3" goto OPT_RESERVED_STORAGE
if "%choice%"=="4" goto OPT_RESTORE_POINTS
if "%choice%"=="5" goto TWEAKS_SUBMENU
if "%choice%"=="6" goto OPT_WINSXS
if "%choice%"=="7" goto OPT_COMPACT
if "%choice%"=="8" goto OPT_DRIVERS
if "%choice%"=="0" exit /b
goto MAIN_MENU

:: --- Пункты меню ---
:OPT_PAGE_FILE
echo.
echo [1] Отключаю файл подкачки...
wmic pagefileset delete 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PagingFiles /t REG_MULTI_SZ /d "" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f
echo    -> Файл подкачки отключен (перезагрузка для полного эффекта).
pause
goto MAIN_MENU

:OPT_HIBERNATION
echo.
echo [2] Отключаю гибернацию...
powercfg -h off
echo    -> Гибернация отключена. Файл hiberfil.sys удален.
pause
goto MAIN_MENU

:OPT_RESERVED_STORAGE
echo.
echo [3] Отключаю зарезервированное хранилище...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v ShippedWithReserves /t REG_DWORD /d 0 /f
DISM /Online /Set-ReservedStorageState /State:Disabled 2>nul
echo    -> Зарезервированное хранилище отключено.
pause
goto MAIN_MENU

:OPT_RESTORE_POINTS
echo.
echo [4] ОТКЛЮЧАЮ ВСЕ ТОЧКИ ВОССТАНОВЛЕНИЯ...
vssadmin delete shadows /all /quiet 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v DisableSR /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\SystemRestore" /v DisableConfig /t REG_DWORD /d 1 /f
echo    -> Точки восстановления УДАЛЕНЫ и функция ОТКЛЮЧЕНА.
pause
goto MAIN_MENU

:TWEAKS_SUBMENU
start "" "WinClean_Tweaks.bat"
goto MAIN_MENU

:OPT_WINSXS
echo.
echo [6] Очищаю хранилище Winsxs...
DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase 2>nul
echo    -> Глубокая очистка Winsxs выполнена.
pause
goto MAIN_MENU

:OPT_COMPACT
echo.
echo [7] Сжимаю системные файлы...
compact /c /i /exe:lzx /s:%windir% 2>nul
echo    -> Системные файлы сжаты алгоритмом LZX.
pause
goto MAIN_MENU

:OPT_DRIVERS
echo.
echo [8] Очищаю кэш драйверов...
pnputil /e > "%temp%\drv_list.txt"
for /f "tokens=1" %%i in ('pnputil /e ^| find "oem"') do pnputil /d %%i 2>nul
echo    -> Неиспользуемые драйверы удалены.
pause
goto MAIN_MENU

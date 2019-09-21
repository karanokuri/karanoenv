@echo off

set PATH=%KARANOENV_APPS_DIR%\dcvm\bin;%PATH%

set DCVM_USE_VERSION=
call :which dcvm && for /f "delims=" %%I in ('dcvm versions') do set DCVM_USE_VERSION=%%I
exit /b 0


:which
for %%I in (%1 %1.com %1.exe %1.bat %1.cmd %1.vbs %1.js %1.wsf) do if exist %%~$path:I exit /b 0
exit /b 1

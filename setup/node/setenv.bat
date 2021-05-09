@echo off

set "NODIST_PREFIX=%KARANOENV_APPS_DIR%\nodist"
set "PATH=%NODIST_PREFIX%\bin;%PATH%"

setlocal
if exist "%KARANOENV_BIN_DIR%\yarn.js" (
  for /f "delims=" %%I in ('yarn global bin') do set "PATH=%%I;%PATH%"
)
endlocal && set "PATH=%PATH%"

set "PATH=.\node_modules\.bin;%PATH%"

exit /b 0

:which
for %%I in (%1 %1.com %1.exe %1.bat %1.cmd %1.vbs %1.js %1.wsf) do (
  if exist %%~$path:I exit /b 0
)
exit /b 1

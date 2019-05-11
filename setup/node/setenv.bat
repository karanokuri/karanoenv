@echo off
setlocal

set PATH=%KARANOENV_APPS_DIR%\yarn\bin;%PATH%

call :which yarn && (
  for /f "delims=" %%I in ('yarn global bin') do set "PATH=%%I;%PATH%"
)

endlocal && set PATH=%PATH%
exit /b 0

:which
for %%I in (%1 %1.com %1.exe %1.bat %1.cmd %1.vbs %1.js %1.wsf) do (
  if exist %%~$path:I exit /b 0
)
exit /b 1

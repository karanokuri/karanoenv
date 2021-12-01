@echo off

set "KARANOENV_FONT_DIR=%KARANOENV_APPS_DIR%\fonts"

call :which font-loader && (
  for /f "delims=" %%I in ('dir /s /b %KARANOENV_FONT_DIR%') do (
    font-loader remove %%I 2>nul
    font-loader add %%I
  )
)
exit /b 0

:which
for %%I in (%1 %1.com %1.exe %1.bat %1.cmd %1.vbs %1.js %1.wsf) do if exist %%~$path:I exit /b 0
exit /b 1

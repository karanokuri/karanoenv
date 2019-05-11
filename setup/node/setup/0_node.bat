@echo off
setlocal

set FILE=node.exe

if "%KARANOENV_ARCH%"=="64" (
  set URL=https://nodejs.org/dist/latest/win-x64/%FILE%
) else (
  set URL=https://nodejs.org/dist/latest/win-x86/%FILE%
)


set DIST=%KARANOENV_BIN_DIR%

rem ###########################################################################

if not exist %DIST% mkdir %DIST%

if exist %DIST%\%FILE% (
  echo node is already exists.
) else (
  echo downloading %URL% ...
  powershell -c "(new-object net.webclient).DownloadFile('%URL%','%DIST%\%FILE%')"
)
endlocal

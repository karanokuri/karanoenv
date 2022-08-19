@echo off
setlocal

set URL=https://github.com/iuchim/zenhan/releases/download/v0.0.1/zenhan.zip

set "DIST=%KARANOENV_BIN_DIR%"

if exist "%DIST%\zenhan.exe" (
  echo zenhan already exists.
  exit /b 0
)

if not exist %DIST% mkdir %DIST%

echo Installing %URL% ...
busybox sh -c "wget -q -O - '%URL%' | unzip -ojq - -d '%DIST%' zenhan/bin%KARANOENV_ARCH%/zenhan.exe" >nul

endlocal

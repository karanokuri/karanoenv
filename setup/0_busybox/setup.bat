@echo off
setlocal

if "%KARANOENV_ARCH%"=="64" (
  set URL=https://frippery.org/files/busybox/busybox64.exe
) else (
  set URL=https://frippery.org/files/busybox/busybox.exe
)

set DIST=%KARANOENV_BIN_DIR%
set FILE=busybox.exe

rem ###########################################################################

if not exist %DIST% mkdir %DIST%

if not exist %DIST%\%FILE% (
  echo downloading %URL% ...
  powershell -c "(new-object net.webclient).DownloadFile('%URL%','%DIST%\%FILE%')"
)

echo generate busybox bat commands
pushd %DIST%
  for /f %%I in ('%FILE% --list') do (
    if not exist %%I.bat echo @%%~dp0%FILE% %%~n0 %%*> %%I.bat
  )
popd

endlocal

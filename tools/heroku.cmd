@echo off
setlocal
if "%KARANOENV_ARCH%"=="64" (
  set URL=https://cli-assets.heroku.com/heroku-win32-x64.tar.xz
) else (
  set URL=https://cli-assets.heroku.com/heroku-win32-x86.tar.gz
)
set "KARANOENV_APPS_HEROKU_DIR=%KARANOENV_APPS_DIR%\heroku"
if not exist "%KARANOENV_APPS_HEROKU_DIR%" (
  >&2 echo installing heroku...
  curl -sS "%URL%" ^
  | 7z x -si -so -txz ^
  | 7z x -si -ttar -y "-o%KARANOENV_APPS_DIR%" "-xr!.bin\" ^
  > nul
  echo;
)
set "LOCALAPPDATA=%KARANOENV_APPS_HEROKU_DIR%\LocalAppData"
"%KARANOENV_APPS_HEROKU_DIR%\bin\heroku.cmd" %*
endlocal

@echo off
setlocal

set DCVM_PATH=%KARANOENV_APPS_DIR%\dcvm

if not exist %DCVM_PATH% (
  echo dcvm is not installed. 1>&2
  exit /b 1
)

if not defined DCVM_USE_VERSION (
  echo DCVM_USE_VERSION is not defined. 1>&2
  exit /b 1
)

if not exist %DCVM_PATH%\dmd\%DCVM_USE_VERSION% (
  echo %DCVM_USE_VERSION% is not found. 1>&2
  exit /b 1
)

call :which dscanner
if ERRORLEVEL 1 (
  echo dscanner is not found. 1>&2
  exit /b 1
)

pushd %DCVM_PATH%\dmd\%DCVM_USE_VERSION%
  for /d %%I in (*) do set SRC_PATH=%%I\src
  if not exist tags (
    dscanner --ctags %SRC_PATH%\phobos %SRC_PATH%\druntime\import > tags
  )
  echo %CD%\tags
popd

endlocal

goto :eof

:which
for %%I in (%1 %1.com %1.exe %1.bat %1.cmd %1.vbs %1.js %1.wsf) do (
  if exist %%~$path:I exit /b 0
)
exit /b 1

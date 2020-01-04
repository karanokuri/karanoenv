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

for /d %%i in (%DCVM_PATH%\dmd\%DCVM_USE_VERSION%\*) do set DC_PATH=%%i

set PATH=%DC_PATH%\windows\bin;%PATH%

%~n0 %*

endlocal

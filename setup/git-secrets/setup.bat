@echo off
setlocal

set "DIST=%KARANOENV_APPS_DIR%\git-secrets"

if exist "%DIST%" (
  git -C "%DIST%" pull --depth 1
) else (
  git clone --depth 1 https://github.com/awslabs/git-secrets.git "%DIST%"
)

endlocal

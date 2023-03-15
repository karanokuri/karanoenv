@echo off

set "PNPM_HOME=%USERPROFILE%\.data\pnpm"

set "PATH=%KARANOENV_APPS_DIR%\volta;%PATH%"
set "PATH=%PNPM_HOME%;%PATH%"
set "PATH=.\node_modules\.bin;%PATH%"

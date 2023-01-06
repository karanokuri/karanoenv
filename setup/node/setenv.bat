@echo off

set "VOLTA_HOME=%USERPROFILE%\.volta"

set "PATH=%KARANOENV_APPS_DIR%\volta;%PATH%"
set "PATH=%VOLTA_HOME%\bin;%PATH%"
set "PATH=.\node_modules\.bin;%PATH%"

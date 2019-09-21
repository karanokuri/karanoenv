@echo off

set GOROOT=%KARANOENV_APPS_DIR%\go
set GOPATH=%USERPROFILE%\go

set PATH=%GOPATH%\bin;%GOROOT%\bin;%PATH%

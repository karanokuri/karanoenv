@echo off

set "PNPM_HOME=%USERPROFILE%\.data\pnpm"

set "PATH=%PNPM_HOME%;%PATH%"
set "PATH=.\node_modules\.bin;%PATH%"

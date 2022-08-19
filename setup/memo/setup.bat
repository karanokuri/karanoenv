@echo off

go install github.com/mattn/memo@latest

if not exist "%APPDATA%\memo" mkdir "%APPDATA%\memo"
if not exist "%APPDATA%\memo\config.toml" (
  copy /y "%~dp0config.toml" "%APPDATA%\memo\config.toml" >nul
)

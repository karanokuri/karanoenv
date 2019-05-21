@echo off

pushd %~dp0
set KARANOENV=%CD%
popd

set KARANOENV_ARCH=32
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set KARANOENV_ARCH=64
if "%PROCESSOR_ARCHITEW6432%"=="AMD64" set KARANOENV_ARCH=64

set KARANOENV_APPS_DIR=%KARANOENV%\apps
set KARANOENV_BIN_DIR=%KARANOENV%\bin

set KARANOENV_DOTFILES=%KARANOENV%\dotfiles

set PATH=%KARANOENV_BIN_DIR%;%PATH%
set PATH=%KARANOENV%\tools;%PATH%

for /d %%D in (%~dp0setup\*) do (
  for %%F in (%%D\setenv.*) do (
    if "x%%~xF"=="x.bat" call %%F
    if "x%%~xF"=="x.ps1" powershell -NoProfile -ExecutionPolicy Unrestricted %%F
    if ERRORLEVEL 1 (>&2 echo setenv: failed %%D && exit /b 1)
  )
)

@echo off
setlocal

for /d %%D in (%KARANOENV_APPS_DIR%\vim*-kaoriya-win%KARANOENV_ARCH%) do set VIM=%%D
set PATH=%VIM%;%PATH%

endlocal && set PATH=%PATH%

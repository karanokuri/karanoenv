@echo off
setlocal

for /f "delims=" %%I in ('dcvm list') do (
  set LATEST=%%I
  goto get_latest
)
:get_latest

(dcvm versions | findstr /x %LATEST%) || dcvm install %LATEST% || exit /b 0

endlocal

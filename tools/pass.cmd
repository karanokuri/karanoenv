@echo off
setlocal

call :which cho || go get github.com/mattn/cho

for /f "delims=;" %%I in ('gopass list -f ^| cho') do set SELECTED=%%I

gopass -c %SELECTED%

endlocal
goto :eof

:which
for %%I in (%1 %1.com %1.exe %1.bat %1.cmd %1.vbs %1.js %1.wsf) do (
  if exist %%~$path:I exit /b 0
)
exit /b 1

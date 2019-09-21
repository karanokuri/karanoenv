@echo off
setlocal
pushd %~dp0

set ARCHIVE=ec58j2w32bin.zip
set URL=http://hp.vector.co.jp/authors/VA025040/ctags/downloads/%ARCHIVE%

set DIST=%KARANOENV_BIN_DIR%

if exist %DIST%\ctags.exe (
  echo ctags is already exists.
  exit /b 0
)

if not exist %DIST% mkdir %DIST%

echo Downloading %URL% ...
powershell -c "(new-object net.webclient).DownloadFile('%URL%','%ARCHIVE%')"

7z e -y %ARCHIVE% -o%DIST% -ir!ctags.exe

del %ARCHIVE%

popd
endlocal

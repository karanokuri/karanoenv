@echo off
setlocal
pushd %~dp0

set ARCHIVE=coffimplib.zip
set URL=http://ftp.digitalmars.com/%ARCHIVE%

set DIST=%KARANOENV_BIN_DIR%

if exist %DIST%\coffimplib.exe (
  echo coffimplib already exists.
  exit /b 0
)

if not exist %DIST% mkdir %DIST%

echo Downloading %URL% ...
powershell -c "(new-object net.webclient).DownloadFile('%URL%','%ARCHIVE%')"

busybox unzip -oq %ARCHIVE% -d %DIST%

del %ARCHIVE%

popd
endlocal

@echo off
setlocal

set FILE=latest.tar.gz
set URL=https://yarnpkg.com/%FILE%

set DIST=%KARANOENV_APPS_DIR%\yarn

rem ###########################################################################

if exist %DIST%\bin\yarn.cmd (
	echo yarn is already exists.
	exit /b 0
)

if not exist %DIST% mkdir %DIST%

echo downloading %URL% ...
powershell -c "[System.Net.ServicePointManager]::SecurityProtocol=[System.Net.SecurityProtocolType]::Tls12;(new-object net.webclient).DownloadFile('%URL%','%FILE%')"

busybox tar zvxf %FILE% -C %DIST% --strip=1 >nul

del %FILE%

endlocal

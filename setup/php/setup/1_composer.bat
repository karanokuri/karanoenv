@echo off
setlocal

set DIST=%KARANOENV_APPS_DIR%

if exist "%DIST%\composer.phar" (
  echo composer.phar already exists.
  exit /b 0
)

php -r "readfile('https://getcomposer.org/installer');" ^
  | php -- --install-dir="%DIST%"

endlocal

@echo off

if exist %KARANOENV_APPS_DIR%\dcvm (
  echo dcvm is already exists.
) else (
  git clone https://github.com/karanokuri/dcvm %KARANOENV_APPS_DIR%\dcvm
)

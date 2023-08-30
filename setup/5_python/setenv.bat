@echo off

set PYTHONIOENCODING=utf-8

set PYENV=%KARANOENV_APPS_DIR%\pyenv
set PYENV_HOME=%PYENV%
set PYENV_ROOT=%PYENV%

set RYE_HOME=%KARANOENV_APPS_DIR%\rye

set PATH=%RYE_HOME%\shims;%PYENV%\pyenv-win\bin;%PYENV%\pyenv-win\shims;%PATH%

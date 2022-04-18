@echo off

set PYTHONIOENCODING=utf-8

set PYENV=%KARANOENV_APPS_DIR%\pyenv
set PYENV_HOME=%PYENV%
set PYENV_ROOT=%PYENV%

set PATH=%PYENV%\pyenv-win\bin;%PYENV%\pyenv-win\shims;%PATH%

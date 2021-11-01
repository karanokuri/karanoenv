@echo off
setlocal

set VERSION2=2.7.18
set VERSION3=3.9.0

if not "%KARANOENV_ARCH%"=="64" (
  set "VERSION2=%VERSION2%-win32"
  set "VERSION3=%VERSION3%-win32"
)

rem ###########################################################################
rem python 2

if not exist "%KARANOENV_APPS_DIR%\pyenv\pyenv-win\versions\neovim-2" (
  if exist "%KARANOENV_APPS_DIR%\pyenv\pyenv-win\versions\%VERSION2%" (
    ren "%KARANOENV_APPS_DIR%\pyenv\pyenv-win\versions\%VERSION2%" "%VERSION2%.orig"
  )

  cmd /c "pyenv install %VERSION2%"

  ren "%KARANOENV_APPS_DIR%\pyenv\pyenv-win\versions\%VERSION2%" "neovim-2"

  if exist "%KARANOENV_APPS_DIR%\pyenv\pyenv-win\versions\%VERSION2%.orig" (
    ren "%KARANOENV_APPS_DIR%\pyenv\pyenv-win\versions\%VERSION2%.orig" "%VERSION2%"
  )
)

pushd %KARANOENV_APPS_DIR%\pyenv\pyenv-win\versions\neovim-2
.\python.exe -m pip install pynvim
popd


rem ###########################################################################
rem python 3

if not exist "%KARANOENV_APPS_DIR%\pyenv\pyenv-win\versions\neovim-3" (
  if exist "%KARANOENV_APPS_DIR%\pyenv\pyenv-win\versions\%VERSION3%" (
    ren "%KARANOENV_APPS_DIR%\pyenv\pyenv-win\versions\%VERSION3%" "%VERSION3%.orig"
  )

  cmd /c "pyenv install %VERSION3%"

  ren "%KARANOENV_APPS_DIR%\pyenv\pyenv-win\versions\%VERSION3%" "neovim-3"

  if exist "%KARANOENV_APPS_DIR%\pyenv\pyenv-win\versions\%VERSION3%.orig" (
    ren "%KARANOENV_APPS_DIR%\pyenv\pyenv-win\versions\%VERSION3%.orig" "%VERSION3%"
  )
)

pushd %KARANOENV_APPS_DIR%\pyenv\pyenv-win\versions\neovim-3
.\python.exe -m pip install pynvim
.\python.exe -m pip install neovim
popd

endlocal

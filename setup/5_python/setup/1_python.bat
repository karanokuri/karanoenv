@echo off

if "%KARANOENV_ARCH%"=="64" (
  for /f %%V in ('pyenv install --list ^| findstr /r "^2.*\.[0-9]*$" ^| tail -n 1') do cmd /c "pyenv install -q %%V"
  for /f %%V in ('pyenv install --list ^| findstr /r "^3.*\.[0-9]*$" ^| tail -n 1') do cmd /c "pyenv install -q %%V"
) else (
  for /f %%V in ('pyenv install --list ^| findstr /r "^2.*\.[0-9]*-win32$" ^| tail -n 1') do cmd /c "pyenv install -q %%V"
  for /f %%V in ('pyenv install --list ^| findstr /r "^3.*\.[0-9]*-win32$" ^| tail -n 1') do cmd /c "pyenv install -q %%V"
)

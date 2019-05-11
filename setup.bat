@echo off
setlocal

for /d %%D in (%~dp0\setup\*) do (
  echo start setup %%~nD ...
  for %%F in (%%D\setup.*) do (
    setlocal
      call %~dp0setenv.bat || exit /b 1
      if "x%%~xF"=="x.bat" call %%F
      if "x%%~xF"=="x.ps1" powershell -NoProfile -ExecutionPolicy Unrestricted %%F
      if ERRORLEVEL 1 (>&2 echo failed %%~nD && exit /b 1) else (echo complete %%~nD)
    endlocal
  )
  if exist %%D\setup\ (
    for %%F in (%%D\setup\*) do (
      setlocal
      call %~dp0setenv.bat || exit /b 1
      echo start %%~nxF
      if "x%%~xF"=="x.bat" call %%F
      if "x%%~xF"=="x.ps1" powershell -NoProfile -ExecutionPolicy Unrestricted %%F
      if ERRORLEVEL 1 (>&2 echo failed %%~nxF && exit /b 1) else (>&2 echo complete %%~nxF)
      endlocal
    )
  )
  echo;
)

endlocal

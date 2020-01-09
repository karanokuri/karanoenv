@echo off
setlocal

if "%KARANOENV_ARCH%"=="64" (
  set ARCH=x86_64-pc-windows-msvc
) else (
  set ARCH=i686-pc-windows-msvc
)

set FILE=rustup-init.exe
set URL=https://static.rust-lang.org/rustup/dist/%ARCH%/%FILE%

if exist %RUSTUP_HOME%\bin\rustup.exe (
  %RUSTUP_HOME%\bin\rustup.exe update
) else (
  echo downloading %URL% ...
  powershell -c "(new-object net.webclient).DownloadFile('%URL%','%FILE%')"

  echo install rustup
  %FILE% -y --no-modify-path

  del %FILE%
)

endlocal

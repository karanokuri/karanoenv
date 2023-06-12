@echo off
setlocal

if "%KARANOENV_ARCH%"=="64" (
  set ARCH=x86_64-pc-windows-msvc
) else (
  set ARCH=i686-pc-windows-msvc
)

set FILE=rustup-init.exe
set RUSTUP=%RUSTUP_HOME%\bin\rustup.exe
set URL=https://static.rust-lang.org/rustup/dist/%ARCH%/%FILE%

if exist %RUSTUP% (
  2>&1 %RUSTUP% update
) else (
  echo downloading %URL% ...
  powershell -c "(new-object net.webclient).DownloadFile('%URL%','%FILE%')"

  echo install rustup
  %FILE% -y --no-modify-path

  del %FILE%
)

echo install rls
%RUSTUP% component add rust-analyzer rust-src

endlocal

@echo off

if not exist %PYENV% mkdir %PYENV%
pushd %PYENV%
if not exist .git (
  git init
  git remote add origin https://github.com/pyenv-win/pyenv-win.git
)
git pull --set-upstream origin master
popd

pyenv update

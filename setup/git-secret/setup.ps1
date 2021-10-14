$ErrorActionPreference = "Stop"

$DIST = Join-Path $Env:KARANOENV_APPS_DIR "git-secret"

if(!(Test-Path $DIST)){ mkdir $DIST | Out-Null }

pushd $DIST

if(!(Join-Path $DIST ".git" | Test-Path))
{
  git init
  git config core.sparsecheckout true
  git remote add origin https://github.com/sobolevn/git-secret.git
  "src" | Set-Content .git\info\sparse-checkout
}

$Branch = git remote show origin         |
            ?{ $_ -match "HEAD branch" } |
            %{ $_.split(" ") }           |
            Select-Object -Last 1        #

git pull --depth 1 origin $Branch

gc "src\version.sh", "src\_utils\*.sh", "src\commands\*.sh", "src\main.sh" |
  sc (Join-Path $Env:KARANOENV_BIN_DIR "git-secret")                       #

popd

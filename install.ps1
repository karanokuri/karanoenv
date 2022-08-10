$ErrorActionPreference = "Stop"

$REPO_URL    = 'https://github.com/karanokuri/karanoenv'
$BRANCH_NAME = 'main'
$DIST        = Join-Path $Env:USERPROFILE '.karanoenv'

if(Test-Path $DIST)
{
  Write-Host 'karanoenv is already installed'
  if($MyInvocation.MyCommand.CommandType -eq 'Script')
  {
    return
  } else
  {
    exit 1
  }
}

$Url = "$REPO_URL/archive/refs/heads/$BRANCH_NAME.zip"
$TmpDir = New-TemporaryFile | ForEach-Object{ Remove-Item $_; mkdir $_ }
$TmpZip = Join-Path $TmpDir "karanoenv.zip"

if(!(Test-Path $DIST))
{
  mkdir $DIST | Out-Null
}

Write-Host 'Downloading ...'
(new-object net.webclient).DownloadFile($Url, $TmpZip)

Write-Host 'Extracting ...'
Expand-Archive $TmpZip $TmpDir
Copy-Item "$TmpDir\*$BRANCH_NAME\*" $DIST -Recurse -Force
Remove-Item $TmpDir -Recurse -Force

Push-Location $DIST
try
{
  .\setup.ps1

  cmd /c ".\setenv.bat && set" | ForEach-Object {
    $EnvName, $EnvValue = $_.split('=')
    Set-Item -Path (Join-Path Env:\ $EnvName) -Value $EnvValue
  }

  git init
  git remote add origin $REPO_URL
  git fetch origin $BRANCH_NAME
} finally
{
  Pop-Location
}

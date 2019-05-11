$ErrorActionPreference = "Stop"

$REPO_URL = "https://github.com/karanokuri/karanoenv"
$DIST     = Join-Path $Env:USERPROFILE '.karanoenv'

if(Test-Path $DIST)
{
  Write-Host "karanoenv is already installed"
  if($MyInvocation.MyCommand.CommandType -eq 'Script')
  {
    return
  }
  else
  {
    exit 1
  }
}

$Url = "$REPO_URL/archive/master.zip"
$TmpDir = New-TemporaryFile | %{ rm $_; mkdir $_ }
$TmpZip = "$TmpDir\karanoenv.zip"

if(!(Test-Path $DIST)) { mkdir $DIST | Out-Null }

Write-Host 'Downloading ...'
(new-object net.webclient).DownloadFile($Url, $TmpZip)

Write-Host 'Extracting ...'
Expand-Archive $TmpZip $TmpDir
cp "$TmpDir\*master\*" $DIST -Recurse -Force

pushd $DIST
  $Clone = "$TmpDir\karanoenv"

  & .\setup.bat
  cmd /c "call setenv.bat && git clone -q $REPO_URL.git $Clone"
  cp "$Clone\*" '.' -Recurse -Force
popd

rmdir $TmpDir -Recurse -Force

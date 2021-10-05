$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/git-lfs/git-lfs/releases/latest"

$ARCH = if($Env:KARANOENV_ARCH -eq '64'){'amd64'}else{'386'}

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
if(Join-Path $DIST 'git-lfs.exe' | Test-Path)
{
  Write-Host "git-lfs already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET           |
         % assets                                            |
         ? name -match "git-lfs-windows-$ARCH-v[0-9.]+\.zip" |
         % browser_download_url

Write-Host "Installing $Url ..."
cmd /c "wget -O - $Url | busybox unzip - git-lfs.exe -d $DIST"

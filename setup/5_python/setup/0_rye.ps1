$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = if($Env:KARANOENV_ARCH -eq '64')
{
  "x86_64"
} else
{
  "x86"
}

$API_URL = "https://api.github.com/repos/mitsuhiko/rye/releases/latest"
$DIST = Join-Path $Env:KARANOENV_BIN_DIR 'rye.exe'

###############################################################################
if(!(Test-Path $DIST))
{
  $Latest = Invoke-RestMethod -Uri $API_URL -Method GET

  $Url = $Latest.assets                                 `
  | Where-Object{ $_.name -eq "rye-$ARCH-windows.exe" } `
  | ForEach-Object browser_download_url                 #

  Write-Host "Installing $Url ..."
  (new-object net.webclient).DownloadFile($Url, $DIST)
}

if(Test-Path $Env:RYE_HOME)
{
  & $DIST self update
} else
{
  & $DIST self install --yes
}

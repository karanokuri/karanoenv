$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/pnpm/pnpm/releases/latest"
$DIST = Join-Path $Env:KARANOENV_BIN_DIR 'pnpm.exe'

###############################################################################
if($Env:KARANOENV_ARCH -ne '64')
{
  Write-Host 'pnpm only support x64'
  exit 0
}

if(!(Test-Path $Env:PNPM_HOME))
{
  mkdir $Env:PNPM_HOME | Out-Null
}

$Version = cmd /c 'pnpm --version 2>nul'

$Latest = Invoke-RestMethod -Uri $API_URL -Method GET

if ("v$Version" -eq $Latest.tag_name)
{
  Write-Host "pnpm is already latest."
  exit 0
}

$Url = $Latest.assets                            `
| Where-Object{ $_.name -eq 'pnpm-win-x64.exe' } `
| ForEach-Object browser_download_url            #

Write-Host "Installing $Url ..."
(new-object net.webclient).DownloadFile($Url, $DIST)

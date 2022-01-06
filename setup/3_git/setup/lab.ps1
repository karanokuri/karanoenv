$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = 'https://api.github.com/repos/zaquestion/lab/releases/latest'

$ARCH = if($Env:KARANOENV_ARCH -eq '64')
{
  'amd64'
} else
{
  '386'
}

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
$Version = cmd /c 'lab --version 2>nul'            `
| Where-Object{ $_ -like 'lab version *' }         `
| ForEach-Object{ $_.replace('lab version ', '') } #

$Latest = Invoke-RestMethod -Uri $API_URL -Method GET

if ("v$Version" -eq $Latest.tag_name)
{
  Write-Host "lab is already latest."
  exit 0
}

if(!(Test-Path $DIST))
{
  mkdir $DIST | Out-Null
}

$Url = $Latest.assets                                               `
| Where-Object{ $_.name -match "lab_[0-9.]+_windows_$ARCH.tar.gz" } `
| ForEach-Object browser_download_url                               #

Write-Host "Installing $Url ..."
cmd /c "%WINDIR%\system32\curl.exe -sSL $Url | %WINDIR%\system32\tar.exe -xJf - -C $DIST lab.exe"

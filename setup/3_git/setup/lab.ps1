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

$ARCHIVE = 'lab.zip'

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

$Url = $Latest.assets                                            `
| Where-Object{ $_.name -match "lab_[0-9.]+_windows_$ARCH.zip" } `
| ForEach-Object browser_download_url                            #

Write-Host "Downloading $Url ..."
(New-Object Net.WebClient).DownloadFile($Url, $ARCHIVE)

7z x -y $ARCHIVE "-o$DIST" "-ir!lab.exe" | Out-Null

Remove-Item $ARCHIVE

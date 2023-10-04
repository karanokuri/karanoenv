$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = 'https://api.github.com/repos/nektos/act/releases/latest'

$ARCH = if($Env:KARANOENV_ARCH -eq '64')
{
  'x86_64'
} else
{
  'i386'
}

$ARCHIVE = 'act.zip'

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
$Version = cmd /c 'act --version 2>nul'            `
| ForEach-Object{ $_.replace('act version ', '') } #

$Latest = Invoke-RestMethod -Uri $API_URL -Method GET

if ("v$Version" -eq $Latest.tag_name)
{
  Write-Host "act is already latest."
  exit 0
}

$Url = $Latest.assets                                    `
| Where-Object{ $_.name -match "act_Windows_$ARCH.zip" } `
| ForEach-Object browser_download_url

Write-Host "Downloading $Url ..."
(New-Object Net.WebClient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path $DIST))
{
  mkdir $DIST | Out-Null
}

7z e -y $ARCHIVE "-o$DIST" "-ir!act.exe" | Out-Null

Remove-Item $ARCHIVE

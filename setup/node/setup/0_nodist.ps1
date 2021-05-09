$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/nullivex/nodist/releases/latest"

$ARCHIVE = "NodistSetup.exe"
$DIST = Join-Path $Env:KARANOENV_APPS_DIR 'nodist'

###############################################################################
if(Test-Path $DIST)
{
  Write-Host "nodist is already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET         |
         % assets                                          |
         ?{ $_.name -match "^NodistSetup-v[0-9.]+\.exe$" } |
         % browser_download_url

Write-Host "Downloading $URL ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

7z x -y $ARCHIVE "-o$DIST"

del $ARCHIVE

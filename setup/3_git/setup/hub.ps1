$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = 'https://api.github.com/repos/github/hub/releases/latest'

$ARCH = if($Env:KARANOENV_ARCH -eq '64'){'amd64'}else{'386'}

$ARCHIVE = 'hub.zip'

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
if(Join-Path $DIST 'hub.exe' | Test-Path)
{
  Write-Host "lab already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET           |
         % assets                                            |
         ?{ $_.name -match "hub-windows-$ARCH-[0-9.]+.zip" } |
         % browser_download_url

Write-Host "Downloading $URL ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Extracting $ARCHIVE ..."
7z e -y $ARCHIVE "-o$DIST" '-ir!hub.exe'

del $ARCHIVE

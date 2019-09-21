$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = if($Env:KARANOENV_ARCH -eq "64"){"x86_64"}else{"x86"}

$API_URL = "https://api.github.com/repos/dlang/dub/releases/latest"

$ARCHIVE = "dub-windows.zip"

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
if(Join-Path $DIST dub.exe | Test-Path)
{
  Write-Host "dub is already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET            |
         % assets                                             |
         ?{ $_.name -match "dub-v[0-9.]+-windows-$ARCH.zip" } |
         % browser_download_url

Write-Host "Downloading $URL ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Extracting $ARCHIVE ..."
7z x -y $ARCHIVE "-o$DIST"

del $ARCHIVE

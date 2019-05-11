$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/spf13/hugo/releases/latest"

$ARCHIVE = "hugo_Windows.zip"

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
if(Join-Path $DIST hugo.exe | Test-Path)
{
  Write-Host "Hugo is already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET                                |
         % assets                                                                 |
         ?{ $_.name -match "hugo_[0-9.]+_Windows-$($Env:KARANOENV_ARCH)bit.zip" } |
         % browser_download_url

Write-Host "Downloading $URL ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Extracting $ARCHIVE ..."
7z x -y $ARCHIVE "-o$DIST" "-ir!hugo.exe"

del $ARCHIVE

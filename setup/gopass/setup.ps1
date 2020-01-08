$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/gopasspw/gopass/releases/latest"

$ARCHIVE = "gopass-windows-amd64.zip"

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
if(Join-Path $DIST gopass.exe | Test-Path)
{
  Write-Host "gopass already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET              |
         % assets                                               |
         ?{ $_.name -match "gopass-[0-9.]+-windows-amd64.zip" } |
         % browser_download_url

Write-Host "Downloading $URL ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Extracting $ARCHIVE ..."
7z e -y $ARCHIVE "-o$DIST" "-ir!gopass.exe"

del $ARCHIVE

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/wixtoolset/wix3/releases/latest"

$ARCHIVE = "wix.zip"

$DIST = Join-Path $Env:KARANOENV_APPS_DIR 'wixtoolset'

###############################################################################
if(Test-Path $DIST)
{
  Write-Host "Wix toolset already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET |
         % assets                                  |
         ?{ $_.name -match "wix\d+-binaries.zip" } |
         % browser_download_url

Write-Host "Downloading $Url ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Extracting $ARCHIVE ..."
busybox unzip -oq $ARCHIVE -d $DIST

del $ARCHIVE

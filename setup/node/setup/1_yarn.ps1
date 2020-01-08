$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/yarnpkg/yarn/releases/latest"

$FILE = "yarn.js"
$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
if(Join-Path $DIST $FILE | Test-Path)
{
  Write-Host "yarn already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET |
         % assets                                  |
         ?{ $_.name -match "^yarn-[0-9.-]+\.js$" } |
         % browser_download_url

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Downloading $URL ..."
(new-object net.webclient).DownloadFile($Url, (Join-Path $DIST $FILE))

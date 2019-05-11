$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/activescott/lessmsi/releases/latest"

$ARCHIVE = "lessmsi.zip"

$DIST = Join-Path $Env:KARANOENV_APPS_DIR "lessmsi"

###############################################################################
if(Join-Path $DIST lessmsi.exe | Test-Path)
{
  Write-Host "lessmsi is already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET   |
         % assets                                    |
         ?{ $_.name -match "lessmsi-v[0-9.-]+.zip" } |
         % browser_download_url

Write-Host "Downloading $Url ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Extracting $ARCHIVE ..."
busybox unzip -oq $ARCHIVE -d $DIST

del $ARCHIVE

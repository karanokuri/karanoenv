$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = if($Env:KARANOENV_ARCH -eq 64)
{
  'x86_64'
} else
{
  'x86'
}

$ARCHIVE = "gcloud.zip"

$DIST = $Env:KARANOENV_APPS_DIR

###############################################################################
$Version = cmd /c 'gcloud --version 2>nul'              `
| Where-Object{ $_ -like 'Google Cloud SDK*' }          `
| ForEach-Object{ $_.replace('Google Cloud SDK ', '') } #

$PageUrl = 'https://cloud.google.com/sdk/docs/downloads-versioned-archives'
$Url = Invoke-WebRequest -Uri $PageUrl                                        `
| ForEach-Object{ $_.Links }                                                  `
| ForEach-Object href                                                         `
| Where-Object{ $_ -match "google-cloud-sdk-([\d.]+)-windows-$ARCH-bundled" } `
| Select-Object -First 1                                                      #

if($Url -like "*-$Version-*")
{
  Write-Host 'gcloud is already latest.'
  exit 0
}

Write-Host "Downloading $Url ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

Write-Host "Extracting $ARCHIVE ..."
& 7z x -y $ARCHIVE "-o$DIST"

Remove-Item $ARCHIVE

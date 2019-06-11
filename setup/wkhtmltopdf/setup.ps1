$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = 'https://api.github.com/repos/wkhtmltopdf/wkhtmltopdf/releases/latest'

$ARCHIVE = 'wkhtmltox.exe'

$DIST = Join-Path $Env:KARANOENV_APPS_DIR 'wkhtmltopdf'

###############################################################################
if(Test-Path $DIST)
{
  Write-Host 'wkhtmltopdf is already exists.'
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET                                       |
         % assets                                                                        |
         ?{ $_.name -match "wkhtmltox-[0-9.-]+\.msvc.+-win$($Env:KARANOENV_ARCH)\.exe" } |
         % browser_download_url

Write-Host "Downloading $Url ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Extracting $ARCHIVE ..."
7z x -y $ARCHIVE "-o$DIST" '-xr!$*' '-xr!uninstall.exe'

del $ARCHIVE

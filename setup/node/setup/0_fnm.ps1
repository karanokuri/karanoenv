$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/Schniz/fnm/releases/latest"
$ARCHIVE = "fnm-windows.zip"
$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
$Version = (cmd /c 'fnm --version 2>nul') -replace 'fnm ', ''

$Latest = Invoke-RestMethod -Uri $API_URL -Method GET

if ("v$Version" -eq $Latest.tag_name)
{
  Write-Host "fnm is already latest."
  exit 0
}

$Url = $Latest.assets                           `
| Where-Object{ $_.name -eq "fnm-windows.zip" } `
| ForEach-Object browser_download_url           #

Write-Host "Downloading $URL ..."
(New-Object Net.WebClient).DownloadFile($Url, $ARCHIVE)

7z x -y $ARCHIVE "-o$DIST"

Remove-Item $ARCHIVE

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/yuru7/HackGen/releases/latest"

$ARCHIVE = "hackgen.zip"

$DIST = $Env:KARANOENV_FONT_DIR

###############################################################################
if(Join-Path $DIST "HackGen35Nerd-Regular.ttf" | Test-Path)
{
  Write-Host "HackGen is already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET           `
| ForEach-Object assets                                      `
| Where-Object{ $_.name -match "HackGenNerd_v[0-9.]*\.zip" } `
| ForEach-Object browser_download_url                        #

if(!(Test-Path($DIST)))
{
  mkdir $DIST | Out-Null
}

Write-Host "Downloading $URL ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

Write-Host "Extracting $ARCHIVE ..."
& 7z e -y $ARCHIVE "-ir!HackGen35Nerd-Regular.ttf" "-o$DIST"

Remove-Item $ARCHIVE

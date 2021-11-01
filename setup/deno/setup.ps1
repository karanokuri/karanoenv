$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/denoland/deno/releases/latest"

$ARCHIVE = "deno.zip"

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
if(Join-Path $DIST "deno.exe" | Test-Path)
{
  Write-Host "deno is already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET          |
         % assets                                           |
         ?{ $_.name -eq "deno-x86_64-pc-windows-msvc.zip" } |
         % browser_download_url

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Downloading $URL ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

Write-Host "Extracting $ARCHIVE ..."
& 7z x -y $ARCHIVE "-o$DIST"

del $ARCHIVE

mkdir $Env:DENO_DIR
mkdir $Env:DENO_INSTALL_ROOT

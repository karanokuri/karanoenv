$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = if($Env:KARANOENV_ARCH -eq 64) { 'x86_64' } else { 'i386' }

$API_URL = "https://api.github.com/repos/commercialhaskell/stack/releases/latest"

$ARCHIVE = "stack-windows.zip"

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
if(Join-Path $DIST stack.exe | Test-Path)
{
  Write-Host "stack is already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET                |
         % assets                                                 |
         ?{ $_.name -match "^stack-[0-9.]+-windows-$ARCH\.zip$" } |
         % browser_download_url

Write-Host "Downloading $Url ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Extracting $ARCHIVE ..."
7z x -y $ARCHIVE "-o$DIST" "-ir!stack.exe"

del $ARCHIVE

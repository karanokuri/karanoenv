$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = if($Env:KARANOENV_ARCH -eq '64'){'x86_64'}else{'i386'}

$API_URL = 'https://api.github.com/repos/jgm/pandoc/releases/latest'

$ARCHIVE = 'pandoc-windows.zip'

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
if(Join-Path $DIST pandoc.exe | Test-Path)
{
  Write-Host 'pandoc is already exists.'
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET               |
         % assets                                                |
         ?{ $_.name -match "pandoc-[0-9.]+-windows-$ARCH\.zip" } |
         % browser_download_url

Write-Host "Downloading $Url ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Extracting $ARCHIVE ..."
7z e -y $ARCHIVE "-o$DIST" '-ir!*.exe'

del $ARCHIVE

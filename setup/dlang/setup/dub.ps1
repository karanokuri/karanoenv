$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = if($Env:KARANOENV_ARCH -eq "64")
{
  "x86_64"
} else
{
  "i686"
}

$VERSION = "1.29.0"
$ARCHIVE_URL = "https://github.com/dlang/dub/releases/download/v$VERSION/dub-v$VERSION-windows-$ARCH.zip"
$ARCHIVE = "dub-windows.zip"

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
if(Join-Path $DIST dub.exe | Test-Path)
{
  Write-Host "dub is already exists."
  exit 0
}

Write-Host "Downloading $ARCHIVE_URL ..."
(New-Object Net.WebClient).DownloadFile($ARCHIVE_URL, $ARCHIVE)

if(!(Test-Path($DIST)))
{
  mkdir $DIST | Out-Null
}

Write-Host "Extracting $ARCHIVE ..."
7z x -y $ARCHIVE "-o$DIST"

Remove-Item $ARCHIVE

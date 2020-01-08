$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = if($Env:KARANOENV_ARCH -eq 64) { "-x64" } else { "" }

$ARCHIVE = "7z$ARCH.msi"
$TMP_DIR = Join-Path $Env:KARANOENV "tmp"

$DIST = Join-Path $Env:KARANOENV_APPS_DIR "7-zip"

###############################################################################
if(Join-Path $DIST 7z.exe | Test-Path)
{
  Write-Host "7-Zip already exists."
  exit 0
}

$Url = Invoke-WebRequest "https://www.7-zip.org/download.html" |
         % Links                                               |
         % href                                                |
         ?{ $_ -match "/7z\d+$ARCH.msi" }                      |
         %{ "https://www.7-zip.org/$_" }                       |
         select -First 1

Write-Host "Downloading $Url ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

$LogFile = Join-Path $TMP_DIR msi.log

if(!(Test-Path($TMP_DIR))){ mkdir $TMP_DIR | Out-Null }

lessmsi x $ARCHIVE (Join-Path $TMP_DIR '\')
Move-Item "tmp\SourceDir\Files\7-Zip" $DIST

del $ARCHIVE
del $TMP_DIR -Recurse

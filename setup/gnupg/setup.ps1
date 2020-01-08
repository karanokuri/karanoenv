$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$PAGE_URL = [Uri]'https://gnupg.org/download/'

$ARCHIVE = 'gnupg-w32.exe'

$DIST = Join-Path $Env:KARANOENV_APPS_DIR 'gnupg'

###############################################################################
if(Test-Path $DIST)
{
  Write-Host 'gnupg already exists.'
  exit 0
}

$Path = Invoke-WebRequest -Uri $PAGE_URL                |
          %{ $_.Links }                                 |
          % href                                        |
          ?{ $_ -match '/gnupg-w32-[0-9.]+_\d+\.exe$' }

$Url = New-Object Uri($PAGE_URL, $Path)

Write-Host "Downloading $Url ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Extracting $ARCHIVE ..."
7z x -y $ARCHIVE "-o$DIST" '-xr!$*' '-xr!gnupg-uninstall.exe.nsis'

del $ARCHIVE

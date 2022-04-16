$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$PAGE_URL = [Uri]'https://gnupg.org/download/'

$ARCHIVE = 'gnupg-w32.exe'

$DIST = Join-Path $Env:KARANOENV_APPS_DIR 'gnupg'

###############################################################################
$Version = cmd /c 'gpg --version 2>nul'            `
| Where-Object{ $_ -like 'gpg (GnuPG) *' }         `
| ForEach-Object{ $_.replace('gpg (GnuPG) ', '') } #

$Path = Invoke-WebRequest -Uri $PAGE_URL                   `
| ForEach-Object{ $_.Links }                               `
| ForEach-Object href                                      `
| Where-Object{ $_ -match '/gnupg-w32-[0-9.]+_\d+\.exe$' } #

if($Path -like "*-${Version}_*")
{
  Write-Host 'gnupg is already latest.'
  exit 0
}

$Url = New-Object Uri($PAGE_URL, $Path)

Write-Host "Downloading $Url ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

Write-Host "Extracting $ARCHIVE ..."
if(Test-Path $DIST)
{
  Remove-Item $DIST -Recurse -Force
}
mkdir $DIST | Out-Null
7z x -y $ARCHIVE "-o$DIST" '-xr!$*' '-xr!gnupg-uninstall.exe.nsis'

Remove-Item $ARCHIVE

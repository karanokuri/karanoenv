$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$URL = 'https://windows.php.net/downloads/releases/'
$ARCHIVE = "php.zip"
$DIST = Join-Path $Env:KARANOENV_APPS_DIR "php"
$USER_AGENT = 'Mozilla/5.0 (Windows NT; Windows NT 10.0; ja-JP) Gecko/20100401 Firefox/4.0'

###############################################################################
if(Test-Path $DIST)
{
  Write-Host "php already exists."
  exit 0
}

$arch = if($Env:KARANOENV_ARCH -eq 64) { 'x64' } else { 'x86' }
$uri = New-Object Uri($URL)

$path = Invoke-WebRequest $uri -UserAgent $USER_AGENT           |
          % Links                                               |
          % href                                                |
          %{ New-Object Uri($uri, $_) }                         |
          % AbsoluteUri                                         |
          ?{ $_ -match "/php-[0-9.]+-Win32-[^-]+-$arch\.zip$" }

if($path -is [Array]){ $path = $path[-1] }

Write-Host "Downloading $path ..."
$wc = New-Object Net.WebClient
$wc.Headers.Add("User-Agent", $USER_AGENT)
$wc.DownloadFile($path, $ARCHIVE)

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Extracting $ARCHIVE ..."
7z x -y $ARCHIVE "-o$DIST"

del $ARCHIVE

$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = if($Env:KARANOENV_ARCH -eq 64) { 'amd64' } else { '386' }

$ARCHIVE = "go-windows-$ARCH.zip"

$DIST = Split-Path -Parent $Env:GOROOT

###############################################################################
if(Test-Path $Env:GOROOT)
{
  Write-Host 'Go is already exists.'
  exit 0
}

$content = (New-Object Net.WebClient).DownloadString('https://golang.org/dl/')
$parsedHtml = New-Object -com 'HTMLFILE'
$parsedHtml.IHTMLDocument2_write($content)
$parsedHtml.Close()

$Url = $parsedHtml.getElementsByTagName('a')     |
         % href                                  |
         ?{ $_ -like '*/go*.windows-amd64.zip' } |
         select -First 1

Write-Host "Downloading $Url ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

Write-Host "Extracting $ARCHIVE ..."
& 7z x -y $ARCHIVE "-o$DIST"

del $ARCHIVE

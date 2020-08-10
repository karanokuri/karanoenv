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

$PageUrl = New-Object Uri('https://golang.org/dl/')
$parsedHtml = Invoke-WebRequest -Uri $PageUrl | % ParsedHtml

$Url = $parsedHtml.getElementsByTagName('a')     |
         % href                                  |
         ?{ $_ -like "*/go*.windows-$ARCH.zip" } |
         select -First 1                         |
         %{ New-Object Uri($_) }                 |
         % LocalPath                             |
         %{ New-Object Uri($PageUrl, $_) }       |
         % AbsoluteUri

Write-Host "Downloading $Url ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

Write-Host "Extracting $ARCHIVE ..."
& 7z x -y $ARCHIVE "-o$DIST"

del $ARCHIVE

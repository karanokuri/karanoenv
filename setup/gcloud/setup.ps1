$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = if($Env:KARANOENV_ARCH -eq 64) { 'x86_64' } else { 'x86' }

$ARCHIVE = "gcloud.zip"

$DIST = $Env:KARANOENV_APPS_DIR

###############################################################################
$Version = cmd /c 'gcloud --version 2>nul'            |
             ?{ $_ -like 'Google Cloud SDK*' }        |
             %{ $_.replace('Google Cloud SDK ', '') } #

$PageUrl = 'https://cloud.google.com/sdk/docs/downloads-versioned-archives'
$ParsedHtml = Invoke-WebRequest -Uri $PageUrl | % ParsedHtml
$Url = $ParsedHtml.getElementsByTagName('a')                              |
         % href                                                           |
         ?{ $_ -match "google-cloud-sdk-([\d.]+)-windows-$ARCH-bundled" } |
         select -First 1                                                  #

if($Url -notlike "*-$Version-*")
{
  Write-Host "Downloading $Url ..."
  (new-object net.webclient).DownloadFile($Url, $ARCHIVE)

  Write-Host "Extracting $ARCHIVE ..."
  & 7z x -y $ARCHIVE "-o$DIST"

  del $ARCHIVE
}

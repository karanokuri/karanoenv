$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/git-for-windows/git/releases/latest"

$ARCHIVE = "PortableGit-$($Env:KARANOENV_ARCH)-bit.7z.exe"

$DIST = Join-Path $Env:KARANOENV_APPS_DIR "PortableGit"

###############################################################################
if(Test-Path $DIST)
{
  Write-Host "PortableGit is already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET                            |
         % assets                                                             |
         ?{ $_.name -like "PortableGit-*-$($Env:KARANOENV_ARCH)-bit.7z.exe" } |
         % browser_download_url

Write-Host "Downloading $URL ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Extracting $ARCHIVE ..."
7z x -y $ARCHIVE "-o$DIST"
& (Join-Path $DIST "post-install.bat")

del $ARCHIVE

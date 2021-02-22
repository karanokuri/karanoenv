$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = "x$($Env:KARANOENV_ARCH)"

$API_URL = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"

$ARCHIVE = "pwsh.zip"

$DIST = Join-Path $Env:KARANOENV_APPS_DIR "pwsh"

###############################################################################
if(Join-Path $DIST pwsh.exe | Test-Path)
{
  Write-Host "powershell is already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET               |
         % assets                                                |
         ?{ $_.name -match "PowerShell-[0-9.]+-win-$ARCH\.zip" } |
         % browser_download_url

Write-Host "Downloading $URL ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

7z x -y $ARCHIVE "-o$DIST"

del $ARCHIVE

$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = 'https://api.github.com/repos/zaquestion/lab/releases/latest'

$ARCH = if($Env:KARANOENV_ARCH -eq '64'){'amd64'}else{'386'}

$ARCHIVE = 'lab.tar.gz'

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
if(Join-Path $DIST 'lab.exe' | Test-Path)
{
  Write-Host "lab already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET              |
         % assets                                               |
         ?{ $_.name -match "lab_[0-9.]+_windows_$ARCH.tar.gz" } |
         % browser_download_url

Write-Host "Downloading $URL ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Extracting $ARCHIVE ..."
tar zxf $ARCHIVE -C $DIST lab.exe

del $ARCHIVE

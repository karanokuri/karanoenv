$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = 'https://api.github.com/repos/cli/cli/releases/latest'

$ARCH = if($Env:KARANOENV_ARCH -eq '64')
{
  'amd64'
} else
{
  '386'
}

$ARCHIVE = 'gh.zip'

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
$Tag = cmd /c 'gh --version 2>nul'                                             `
| Where-Object{ $_ -like 'https://github.com/cli/cli/releases/tag/*' }         `
| ForEach-Object{ $_.replace('https://github.com/cli/cli/releases/tag/', '') } #

$Latest = Invoke-RestMethod -Uri $API_URL -Method GET

if ($Tag -eq $Latest.tag_name)
{
  Write-Host "gh is already latest."
  exit 0
}

$Url = $Latest.assets                                           `
| Where-Object{ $_.name -match "gh_[0-9.]+_windows_$ARCH.zip" } `
| ForEach-Object browser_download_url

Write-Host "Downloading $Url ..."
(New-Object Net.WebClient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path $DIST))
{
  mkdir $DIST | Out-Null
}

7z e -y $ARCHIVE "-o$DIST" "-ir!gh.exe" | Out-Null

Remove-Item $ARCHIVE

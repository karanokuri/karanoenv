$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = if($Env:KARANOENV_ARCH -eq 64)
{
  'x86_64'
} else
{
  'i686'
}

$API_URL = "https://api.github.com/repos/karanokuri/font-loader/releases/latest"

$ARCHIVE = "font-loader.zip"

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
$Version = cmd /c 'font-loader --version 2>nul'    `
| ForEach-Object{ $_.replace('font-loader ', '') } #

$Latest = Invoke-RestMethod -Uri $API_URL -Method GET

if ("v$Version" -eq $Latest.tag_name)
{
  Write-Host "font-loader is already latest."
  exit 0
}

$Url = $Latest.assets                                                 `
| Where-Object{ $_.name -eq "font-loader-$ARCH-pc-windows-msvc.zip" } `
| ForEach-Object browser_download_url                                 #

Write-Host "Downloading $URL ..."
(New-Object Net.WebClient).DownloadFile($Url, $ARCHIVE)

7z x -y $ARCHIVE "-o$DIST"

Remove-Item $ARCHIVE

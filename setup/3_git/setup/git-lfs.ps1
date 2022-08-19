$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/git-lfs/git-lfs/releases/latest"

$ARCH = if($Env:KARANOENV_ARCH -eq '64')
{
  'amd64'
} else
{
  '386'
}

$ARCHIVE = "git-lfs.zip"

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
$Version = cmd /c 'git-lfs version 2>nul'                     `
| ForEach-Object{ $_ -replace '^git-lfs/([0-9._]+)*$', '$1' } #

$Latest = Invoke-RestMethod -Uri $API_URL -Method GET

if ("v$Version" -eq $Latest.tag_name)
{
  Write-Host "git-lfs is already latest."
  exit 0
}

$Url = $Latest.assets                                            `
| Where-Object name -match "git-lfs-windows-$ARCH-v[0-9.]+\.zip" `
| ForEach-Object browser_download_url                            #

Write-Host "Downloading $Url ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

Write-Host "Extracting $ARCHIVE ..."
7z e -y $ARCHIVE "-ir!git-lfs.exe" "-o$DIST" | Out-Null

Remove-Item $ARCHIVE

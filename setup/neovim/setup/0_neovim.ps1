$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = $Env:KARANOENV_ARCH

$API_URL = "https://api.github.com/repos/neovim/neovim/releases/latest"

$ARCHIVE = "nvim.zip"

$DIST = $Env:KARANOENV_APPS_DIR

###############################################################################
$TagName = cmd /c 'nvim --version 2>nul'      `
| Where-Object{ $_ -like 'NVIM ' }            `
| ForEach-Object{ $_.replace('NVIM ', '') }   #

$Latest = Invoke-RestMethod -Uri $API_URL -Method GET

if ($TagName -ne $Latest.tag_name)
{
  $Url = $Latest.assets                             `
  | Where-Object{ $_.name -eq "nvim-win$ARCH.zip" } `
  | ForEach-Object browser_download_url

  Write-Host "Downloading $Url ..."
  (new-object net.webclient).DownloadFile($Url, $ARCHIVE)

  if(!(Test-Path($DIST)))
  {
    mkdir $DIST | Out-Null
  }

  Write-Host "Extracting $ARCHIVE ..."
  busybox unzip -oq $ARCHIVE -d $DIST

  Remove-Item $ARCHIVE
}

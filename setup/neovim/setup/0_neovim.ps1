$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = $Env:KARANOENV_ARCH

$API_URL = "https://api.github.com/repos/neovim/neovim/releases/latest"

$ARCHIVE = "nvim.zip"

$DIST = Join-Path $Env:KARANOENV_APPS_DIR "neovim"

###############################################################################
$TagName = cmd /c 'nvim --version 2>nul'      `
| Where-Object{ $_ -like 'NVIM *' }           `
| ForEach-Object{ $_.replace('NVIM ', '') }   #

$Latest = Invoke-RestMethod -Uri $API_URL -Method GET

if ($TagName -ne $Latest.tag_name)
{
  $Url = $Latest.assets                             `
  | Where-Object{ $_.name -eq "nvim-win$ARCH.zip" } `
  | ForEach-Object browser_download_url

  Write-Host "Downloading $Url ..."
  (new-object net.webclient).DownloadFile($Url, $ARCHIVE)

  Write-Host "Extracting $ARCHIVE ..."
  if(Test-Path $DIST)
  {
    Remove-Item $DIST -Recurse -Force
  }
  mkdir $DIST | Out-Null
  busybox unzip -oq $ARCHIVE -d $DIST
  $ExtractDir = Get-ChildItem $DIST | ForEach-Object FullName
  Get-ChildItem $ExtractDir | Move-Item -Destination $DIST

  Remove-Item $ARCHIVE, $ExtractDir
}

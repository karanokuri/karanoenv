$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/oven-sh/bun/releases/latest"

$ARCHIVE = "bun.zip"

$DIST = $Env:KARANOENV_BIN_DIR

###############################################################################
if(!(Test-Path $DIST))
{
  mkdir $DIST | Out-Null
}
if (!(Test-Path $Env:DENO_DIR))
{
  mkdir $Env:DENO_DIR
}
if (!(Test-Path $Env:DENO_INSTALL_ROOT))
{
  mkdir $Env:DENO_INSTALL_ROOT
}

$Deno = Join-Path $DIST "bun.exe"
$Denox = Join-Path $DIST "bunx.exe"

if(Test-Path $Deno)
{
  & $Deno upgrade
} else
{
  $Url = Invoke-RestMethod -Uri $API_URL -Method GET  `
  | ForEach-Object assets                             `
  | Where-Object{ $_.name -eq "bun-windows-x64.zip" } `
  | ForEach-Object browser_download_url               #

  Write-Host "Downloading $Url ..."
  (New-Object Net.WebClient).DownloadFile($Url, $ARCHIVE)

  7z e -y $ARCHIVE "-o$DIST"
  Remove-Item $ARCHIVE
}

Copy-Item $Deno $Denox -Force

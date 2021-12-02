$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/denoland/deno/releases/latest"

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

$Deno = Join-Path $DIST "deno.exe"

if(Test-Path $Deno)
{
  & $Deno upgrade
} else
{
  $Url = Invoke-RestMethod -Uri $API_URL -Method GET              `
  | ForEach-Object assets                                         `
  | Where-Object{ $_.name -eq "deno-x86_64-pc-windows-msvc.zip" } `
  | ForEach-Object browser_download_url                           #

  Write-Host "Installing deno ..."
  busybox sh -c "wget $Url -O - | unzip -oq - -d '$DIST'" | Out-Null
}

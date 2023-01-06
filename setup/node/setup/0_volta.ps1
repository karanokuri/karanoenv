$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/volta-cli/volta/releases/latest"
$ARCHIVE = "volta-windows.zip"
$DIST = Join-Path $Env:KARANOENV_APPS_DIR volta

###############################################################################
$Version = cmd /c 'volta --help 2>nul' `
| Where-Object{ $_ -match '^[0-9.]$' } #

$Latest = Invoke-RestMethod -Uri $API_URL -Method GET

if ("v$Version" -eq $Latest.tag_name)
{
  Write-Host "volta is already latest."
  exit 0
}

$Url = $Latest.assets                                         `
| Where-Object{ $_.name -match "volta-[0-9.]+-windows\.zip" } `
| ForEach-Object browser_download_url                         #

Write-Host "Installing $Url ..."
if(Test-Path $DIST)
{
  Remove-Item $DIST -Recurse -Force
}
mkdir $DIST | Out-Null
busybox sh -c "wget -q -O - '$Url' | unzip -oq - -d '$DIST'" | Out-Null

Copy-Item (Join-Path $DIST 'volta-shim.exe') (Join-Path $DIST 'node.exe')
Copy-Item (Join-Path $DIST 'volta-shim.exe') (Join-Path $DIST 'npm.exe')
Copy-Item (Join-Path $DIST 'volta-shim.exe') (Join-Path $DIST 'npx.exe')
Copy-Item (Join-Path $DIST 'volta-shim.exe') (Join-Path $DIST 'yarn.exe')
Remove-Item (Join-Path $DIST 'volta-*.exe')

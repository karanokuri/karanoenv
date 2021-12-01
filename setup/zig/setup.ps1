$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = if($Env:KARANOENV_ARCH -eq '64')
{
  "x86_64"
} else
{
  "i386"
}

$API_URL = "https://ziglang.org/download/index.json"

$DIST = Join-Path $Env:KARANOENV_APPS_DIR "zig"

###############################################################################
$Version = cmd /c 'zig version 2>nul'

$Versions = Invoke-RestMethod -Uri $API_URL -Method GET

$Latest = $Versions.PSObject.Properties.Name `
| Where-Object{ $_ -ne 'master' }            `
| Select-Object -First 1                     #

if ($Version -eq $Latest)
{
  Write-Host "zig is already latest."
  exit 0
}

$Url = $Versions.$Latest."$ARCH-windows".tarball

Write-Host "Downloading $Url ..."

if(Test-Path $DIST)
{
  Remove-Item $DIST -Force -Recurse
}

$ParentDir = Split-Path $DIST -Parent

Write-Host "Installing zig $Latest ..."
busybox sh -c "wget $Url -O - | unzip -oq - -d '$ParentDir'" | Out-Null

Join-Path $ParentDir '.\zig-windows-*' `
| Get-ChildItem                        `
| Rename-Item -NewName 'zig'           #

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = if($Env:KARANOENV_ARCH -eq "64")
{
  "amd64"
} else
{
  "386"
}

$API_URL = "https://api.github.com/repos/zetamatta/nyagos/releases/latest"

$DIST = Join-Path $Env:KARANOENV_APPS_DIR "nyagos"

###############################################################################
$Version = cmd /c 'nyagos --help 2>nul'                           `
| Where-Object{ $_ -match '[0-9._]+-windows-' }                   `
| ForEach-Object{ $_ -replace '^.* ([0-9._]+)-windows.*$', '$1' } #

$Latest = Invoke-RestMethod -Uri $API_URL -Method GET

if ("$Version" -ne $Latest.tag_name)
{
  $Url = $Latest.assets                                `
  | Where-Object{ $_.name -like "nyagos-*-$ARCH.zip" } `
  | ForEach-Object browser_download_url                #

  Write-Host "Installing $Url ..."
  if(Test-Path $DIST)
  {
    Remove-Item $DIST -Recurse -Force
  }
  mkdir $DIST | Out-Null
  busybox sh -c "wget -q -O - '$Url' | unzip -oq - -d '$DIST'" | Out-Null
}

'dofile(nyagos.env.KARANOENV_DOTFILES.."\\.nyagos")'    `
| ForEach-Object { [Text.Encoding]::UTF8.GetBytes($_) } `
| Set-Content -Path "$DIST\.nyagos" -Encoding Byte      #

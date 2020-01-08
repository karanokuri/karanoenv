$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$DRIVE = Split-Path $MyInvocation.MyCommand.Path -Qualifier

$ARCH = if($Env:KARANOENV_ARCH -eq "64"){"amd64"}else{"386"}

$API_URL = "https://api.github.com/repos/zetamatta/nyagos/releases/latest"

$ARCHIVE = "nyagos.zip"

$DIST = Join-Path $Env:KARANOENV_APPS_DIR "nyagos"

###############################################################################
if(Join-Path $DIST nyagos.exe | Test-Path)
{
  Write-Host "NYAGOS already exists."
  exit 0
}

mkdir $DIST | Out-Null

$Url = Invoke-RestMethod -Uri $API_URL -Method GET |
         % assets                                  |
         ?{ $_.name -like "nyagos-*-$ARCH.zip" }   |
         % browser_download_url

Write-Host "Downloading $URL ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

7z x -y $ARCHIVE "-o$DIST"

if(!(Test-Path "$Env:USERPROFILE\.nyagos"))
{
  'dofile(nyagos.env.KARANOENV_DOTFILES.."\\nyagos.lua")'       |
    % { [Text.Encoding]::UTF8.GetBytes($_) }                    |
    Set-Content -Path "$Env:USERPROFILE\.nyagos" -Encoding Byte
}

del $ARCHIVE

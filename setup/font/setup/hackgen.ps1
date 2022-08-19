$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/yuru7/HackGen/releases/latest"

$DIST = $Env:KARANOENV_FONT_DIR
$FONT_FILE = "HackGenConsoleNF-Regular.ttf"

###############################################################################
if(Join-Path $DIST $FONT_FILE | Test-Path)
{
  Write-Host "HackGen is already exists."
  exit 0
}

$Latest = Invoke-RestMethod -Uri $API_URL -Method GET

$TagName = $Latest.tag_name

$Url = $Latest.assets                                 `
| Where-Object name -match "HackGen_NF_v[0-9.]*\.zip" `
| ForEach-Object browser_download_url                 #

if(!(Test-Path($DIST)))
{
  mkdir $DIST | Out-Null
}

Write-Host "Installing $Url ..."
cmd /c "%windir%\system32\curl.exe -sSL $Url -o - | %windir%\system32\tar.exe xvf - -C $DIST --strip-components=1 HackGen_NF_$TagName/$FONT_FILE"

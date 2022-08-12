$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = if($Env:KARANOENV_ARCH -eq "64")
{
  "win32-x64"
} else
{
  "win32"
}

$API_URL = 'https://code.visualstudio.com/sha?build=stable'

$ARCHIVE = "vscode.zip"

$DIST = Join-Path $Env:KARANOENV_APPS_DIR "vscode"

###############################################################################
$Code = Join-Path $DIST 'bin/code'
$DataDir = Join-Path $DIST 'data'

$Version = $Code                              `
| Where-Object{ Test-Path $_ }                `
| ForEach-Object{ cmd /c "`"$_`" --version" } `
| Where-Object Length -eq 40                  #

$Latest = Invoke-RestMethod -Uri $API_URL -Method GET `
| ForEach-Object products                             `
| Where-Object{ $_.platform.os -eq "$ARCH-archive" }  #

if ($Version -ne $Latest.version)
{
  $Url = $Latest.url

  Write-Host "Downloading $Url ..."
  (new-object net.webclient).DownloadFile($Url, $ARCHIVE)

  $Hash = Get-FileHash -Algorithm SHA256 $ARCHIVE | ForEach-Object Hash
  if($Hash -ne $Latest.sha256hash)
  {
    throw "File verify failed."
  }

  7z x -y $ARCHIVE "-o$DIST"

  Remove-Item $ARCHIVE
}

if (!(Test-Path $DataDir))
{
  mkdir $DataDir | Out-Null
}

$MyInvocation.MyCommand.Path                                          `
| Split-Path -Parent                                                  `
| Split-Path -Parent                                                  `
| Join-Path -ChildPath extensions.txt                                 `
| Get-Item                                                            `
| Get-Content                                                         `
| ForEach-Object{ cmd /c "`"$Code`" --install-extension $_ --force" } #

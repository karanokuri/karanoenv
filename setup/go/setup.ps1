$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = if($Env:KARANOENV_ARCH -eq 64)
{
  'amd64'
} else
{
  '386'
}

$BASE_URL = 'https://go.dev/dl'

#$DIST = Split-Path -Parent $Env:GOROOT
$DIST = $Env:GOROOT

###############################################################################
$Version = cmd /c 'go version 2>nul'                              `
| ForEach-Object{ $_ -replace '^go version go([0-9.]+) .*', '$1'} #

# [System.Version] $Version
$Json = Invoke-RestMethod -Uri "$BASE_URL/?mode=json" -Method GET

$Latest = $Json                                   `
| Where-Object { $_.stable }                      `
| ForEach-Object { $_.version.replace('go', '') } `
| ForEach-Object { [System.Version] $_ }          `
| Sort-Object -Descending -Unique                 `
| Select-Object -First 1                          #

if ($Version -eq $Latest)
{
  Write-Host "Latest Go $Version is already installed."
  exit 0
}

$Url = $Json                                  `
| Where-Object { $_.version -eq "go$Latest" } `
| ForEach-Object { $_.files }                 `
| Where-Object { $_.os -eq 'windows' }        `
| Where-Object { $_.arch -eq $ARCH }          `
| Where-Object { $_.kind -eq 'archive' }      `
| ForEach-Object { $_.filename }              `
| ForEach-Object { "$BASE_URL/$_" }           #

$TempFile = New-TemporaryFile

Write-Host "Downloading $Url ..."
(New-Object Net.WebClient).DownloadFile($Url, $TempFile)

Write-Host "Extracting $TempFile ..."
if(Test-Path $DIST)
{
  Remove-Item $DIST -Recurse -Force
}
7z x -y $TempFile "-o$(Split-Path -Parent $DIST)"

Remove-Item $TempFile

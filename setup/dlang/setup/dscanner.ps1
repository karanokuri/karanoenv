$ErrorActionPreference = "Stop"

$DIST = $Env:KARANOENV_BIN_DIR

if(Join-Path $DIST dscanner.exe | Test-Path)
{
  Write-Host "dscanner already exists."
  exit 0
}

dub fetch dscanner
dub build -a x86 -b release dscanner
$packageInfo = dub describe dscanner         |
                 ConvertFrom-Json            |
                 % packages                  |
                 ?{ $_.name -eq "dscanner" }

$baseDir        = $packageInfo | % path
$targetDir      = $packageInfo | % targetPath
$targetFileName = $packageInfo | % targetFileName

$targetPath = Join-Path $baseDir $targetDir        |
              Join-Path -ChildPath $targetFileName

copy $targetPath $DIST

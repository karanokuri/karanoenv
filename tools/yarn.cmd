@setlocal enabledelayedexpansion
@set "YARN_PATH=%KARANOENV_BIN_DIR%\yarn.js"
@if not "%~1"=="self-update" (node "%YARN_PATH%" %* & exit /b !ERRORLEVEL!)
@powershell -NoProfile "iex((cat -LiteralPath '%~f0'|?{$_ -notlike '@*'})-join[char]10)"
@exit /b %ERRORLEVEL%

$ErrorActionPreference = "Stop"

$API_URL = "https://api.github.com/repos/yarnpkg/yarn/releases/latest"

$CurVersion = node $Env:YARN_PATH --version

$yarn_js = Invoke-RestMethod -Uri $API_URL -Method GET |
           % assets                                    |
           ?{ $_.name -match "^yarn-[0-9.-]+\.js$" }

$Url  = $yarn_js.browser_download_url
$Name = $yarn_js.name

if ($Name -eq "yarn-$CurVersion.js")
{
  Write-Host "Current version is latest"
}
else
{
  (new-object net.webclient).DownloadFile($Url, $Env:YARN_PATH)

  $NewVersion = node $Env:YARN_PATH --version
  Write-Host "Update from $CurVersion to $NewVersion"
}

# vim:set ft=ps1:

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/wez/wezterm/releases/latest"

$DIST = Join-Path $Env:KARANOENV_APPS_DIR "wezterm"

###############################################################################
$Version = cmd /c 'wezterm --version 2>nul'     `
| Where-Object{ $_ -match '^wezterm ' }         `
| ForEach-Object{ $_ -replace '^wezterm ', '' } #

$Latest = Invoke-RestMethod -Uri $API_URL -Method GET

if ("$Version" -ne $Latest.tag_name)
{
  $Url = $Latest.assets                                   `
  | Where-Object{ $_.name -like "WezTerm-windows-*.zip" } `
  | ForEach-Object browser_download_url                   #

  Write-Host "Installing $Url ..."
  if(Test-Path $DIST)
  {
    Remove-Item $DIST -Recurse -Force
  }
  mkdir $DIST | Out-Null
  busybox sh -c "wget -q -O - '$Url' | unzip -oq - -d '$DIST'" | Out-Null
  Get-ChildItem $DIST | Get-ChildItem | Move-Item -Destination $DIST
  Join-Path $DIST "WezTerm-windows-*" | Remove-Item
}

'dofile(require("wezterm").home_dir.."/.karanoenv/dotfiles/.wezterm.lua")' `
| ForEach-Object { [Text.Encoding]::UTF8.GetBytes($_) }                    `
| Set-Content -Path "$DIST\wezterm.lua" -Encoding Byte                     #

$WsShell = New-Object -ComObject WScript.Shell
$Shortcut = $WsShell.CreateShortcut((Join-Path $Env:KARANOENV 'wezterm.lnk'))
$Shortcut.TargetPath = '%USERPROFILE%\.karanoenv\apps\wezterm\wezterm-gui.exe'
$Shortcut.IconLocation = '%USERPROFILE%\.karanoenv\apps\wezterm\wezterm-gui.exe,0'
$Shortcut.Save()

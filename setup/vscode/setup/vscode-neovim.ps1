$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$SETTINGS_FILE = Join-Path $Env:KARANOENV_APPS_DIR 'vscode\data\user-data\User\settings.json'
$NEOVIM_PATH   = Join-Path $Env:KARANOENV_APPS_DIR 'neovim\bin\nvim.exe'
###############################################################################

$Settings = if (Test-Path $SETTINGS_FILE)
{
  Get-Content $SETTINGS_FILE -Encoding UTF8 -Raw | ConvertFrom-Json
} else
{
  [PSCustomObject]@{}
}

$Settings                                           `
| Add-Member                                        `
  -Force                                            `
  -MemberType NoteProperty                          `
  -Name 'vscode-neovim.neovimExecutablePaths.win32' `
  -Value $NEOVIM_PATH                               #

$Settings                                `
| ConvertTo-Json                         `
| Out-File $SETTINGS_FILE -Encoding UTF8 #

code --install-extension 'asvetliakov.vscode-neovim' --force

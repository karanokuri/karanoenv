$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$SETTINGS_FILE = Join-Path $Env:KARANOENV_APPS_DIR 'vscode\data\user-data\User\settings.json'
$NYAGOS_PATH   = Join-Path $Env:KARANOENV_APPS_DIR 'nyagos\nyagos.exe'
###############################################################################

$Settings = if (Test-Path $SETTINGS_FILE)
{
  Get-Content $SETTINGS_FILE -Encoding UTF8 -Raw | ConvertFrom-Json
} else
{
  [PSCustomObject]@{}
}

$Settings                                            `
| Add-Member                                         `
  -Force                                             `
  -MemberType NoteProperty                           `
  -Name 'terminal.integrated.defaultProfile.windows' `
  -Value 'nyagos'                                    #

$Settings                                      `
| Add-Member                                   `
  -Force                                       `
  -MemberType NoteProperty                     `
  -Name 'terminal.integrated.profiles.windows' `
  -Value @{                                    #
  nyagos = @{                                  #
    path = $NYAGOS_PATH                        #
  }                                            #
}                                              #

$Settings                                `
| ConvertTo-Json                         `
| Out-File $SETTINGS_FILE -Encoding UTF8 #

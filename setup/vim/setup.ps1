$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/koron/vim-kaoriya/releases/latest"

$ARCHIVE = "vim-kaoriya-win.zip"

$DIST = $Env:KARANOENV_APPS_DIR

###############################################################################
if(Join-Path $DIST "vim*-kaoriya-win*" | Test-Path)
{
  Write-Host "Vim-KaoriYa is already exists."
  exit 0
}

$Url = Invoke-RestMethod -Uri $API_URL -Method GET                                   |
         % assets                                                                    |
         ?{ $_.name -match "vim\d+-kaoriya-win$($Env:KARANOENV_ARCH)-[0-9.-]+.zip" } |
         % browser_download_url

Write-Host "Downloading $Url ..."
(new-object net.webclient).DownloadFile($Url, $ARCHIVE)

if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

Write-Host "Extracting $ARCHIVE ..."
busybox unzip -oq $ARCHIVE -d $DIST

if(!(Test-Path "$Env:USERPROFILE\.vimrc"))
{
  'source $KARANOENV/dotfiles/.vimrc'                          |
    % { [Text.Encoding]::UTF8.GetBytes($_) }                   |
    Set-Content -Path "$Env:USERPROFILE\.vimrc" -Encoding Byte
}

del $ARCHIVE

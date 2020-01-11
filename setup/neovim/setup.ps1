$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/neovim/neovim/releases/latest"

$ARCHIVE = "nvim.zip"

$DIST = $Env:KARANOENV_APPS_DIR

###############################################################################
if(!(Join-Path $DIST "Neovim" | Test-Path))
{
  $Url = Invoke-RestMethod -Uri $API_URL -Method GET                 |
           % assets                                                  |
           ?{ $_.name -match "nvim-win$($Env:KARANOENV_ARCH)\.zip" } |
           % browser_download_url

  Write-Host "Downloading $Url ..."
  (new-object net.webclient).DownloadFile($Url, $ARCHIVE)

  if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

  Write-Host "Extracting $ARCHIVE ..."
  busybox unzip -oq $ARCHIVE -d $DIST

  del $ARCHIVE
}

if(!(Test-Path "$Env:LOCALAPPDATA\nvim")) {
  mkdir "$Env:LOCALAPPDATA\nvim" | Out-Null
}

if(!(Test-Path "$Env:LOCALAPPDATA\nvim\init.vim"))
{
  'source $KARANOENV/dotfiles/.config/nvim/init.vim'                          |
    % { [Text.Encoding]::UTF8.GetBytes($_) }                                  |
    Set-Content -Path "$Env:LOCALAPPDATA\nvim\init.vim" -Encoding Byte -Force
}

if(!(Test-Path "$Env:LOCALAPPDATA\nvim\ginit.vim"))
{
  'source $KARANOENV/dotfiles/.config/nvim/ginit.vim'                          |
    % { [Text.Encoding]::UTF8.GetBytes($_) }                                   |
    Set-Content -Path "$Env:LOCALAPPDATA\nvim\ginit.vim" -Encoding Byte -Force
}

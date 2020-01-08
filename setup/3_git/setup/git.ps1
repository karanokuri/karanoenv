$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$API_URL = "https://api.github.com/repos/git-for-windows/git/releases/latest"

$ARCH = $Env:KARANOENV_ARCH

$ARCHIVE = "PortableGit.7z.exe"

$DIST = Join-Path $Env:KARANOENV_APPS_DIR "PortableGit"

###############################################################################
if(!(Test-Path $DIST))
{
  $Url = Invoke-RestMethod -Uri $API_URL -Method GET           |
           % assets                                            |
           ?{ $_.name -like "PortableGit-*-$ARCH-bit.7z.exe" } |
           % browser_download_url

  Write-Host "Downloading $URL ..."
  (new-object net.webclient).DownloadFile($Url, $ARCHIVE)

  if(!(Test-Path($DIST))){ mkdir $DIST | Out-Null }

  Write-Host "Extracting $ARCHIVE ..."
  7z x -y $ARCHIVE "-o$DIST"
  & (Join-Path $DIST "post-install.bat")

  del $ARCHIVE
}

git config --global core.excludesfile | Out-Null
if(!($?))
{
  git config --global core.excludesfile ~/.karanoenv/dotfiles/.gitignore
}

git config --global include.path | Out-Null
if(!($?))
{
  git config --global include.path ~/.karanoenv/dotfiles/.gitconfig
}

$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ARCH = if($Env:KARANOENV_ARCH -eq 64) { 'amd64' } else { 'win32' }

$ARCHIVE = "python-$ARCH.exe"

$DIST = Join-Path $Env:KARANOENV_APPS_DIR 'python3'

###############################################################################
if(!(Test-Path $DIST))
{
  $content = (New-Object Net.WebClient).DownloadString('https://www.python.org/downloads/')
  $PageDir = ([regex]'/downloads/release/python-\d+/').Matches($content) |
               % Value                                                   |
               sort -Descending                                          |
               select -First 1

  $PageUrl = New-Object Uri([Uri]'https://www.python.org', $PageDir)

  $content = (New-Object Net.WebClient).DownloadString($PageUrl)
  $Url = ([regex]"https://.+/python-[0-9.]+-$ARCH.exe").Matches($content) |
          % Value                                                         |
          select -First 1

  Write-Host "Downloading $Url ..."
  (new-object net.webclient).DownloadFile($Url, $ARCHIVE)

  Write-Host "Extracting $ARCHIVE ..."
  dark -nologo -x _tmp $ARCHIVE

  @('launcher.msi', 'path.msi', 'pip.msi') |
    %{ rm "_tmp\AttachedContainer\$_" }
  Get-ChildItem '_tmp\AttachedContainer\*.msi' |
    % FullName                                 |
    %{ lessmsi x $_ '_tmp\' }

  Copy-Item '_tmp\SourceDir' $DIST -Force -Recurse

  del "_tmp", $ARCHIVE -Force -Recurse
}

if(!(Get-Command -Name pip -ErrorAction SilentlyContinue))
{
  Write-Host "Installing pip ..."
  curl.exe -sSkL https://bootstrap.pypa.io/get-pip.py | python
}

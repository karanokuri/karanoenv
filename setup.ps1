$ErrorActionPreference = "Stop"
Set-ExecutionPolicy RemoteSigned -Scope Process
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$setenv = Join-Path $ScriptDir 'setenv.bat'
$pshcmd = 'powershell -NoProfile -ExecutionPolicy Unrestricted'

function StartSetupScript($path) {                     #
  "start $_"                                           #
                                                       #
  cmd /c "call $setenv && $pshcmd $($path.FullName)" | #
    %{ "  $_" }                                        #
                                                       #
  if($?)                                               #
  {                                                    #
    "complete $path."                                  #
  }                                                    #
  else                                                 #
  {                                                    #
    Write-Error "failed $path."                        #
  }                                                    #
}

Get-ChildItem (Join-Path $ScriptDir '.\setup')     |
%{                                                 #
  $name = $_.Name                                  #
  Get-ChildItem (Join-Path $_.FullName 'setup*') | #
  %{                                             # #
    "start setup $name ..."                      # #
    if($_.Mode -like 'd*')                       # #
    {                                            # #
      Get-ChildItem $_           |               # #
       %{ StartSetupScript($_) } |               # #
       %{ "  $_" }                               # #
    }                                            # #
    else                                         # #
    {                                            # #
      StartSetupScript($_) |                     # #
        %{ "  $_" }                              # #
    }                                            # #
                                                 # #
    "complete $name."                            # #
    ""                                           # #
  }                                                #
}

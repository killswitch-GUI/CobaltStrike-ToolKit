# For: Cobalt Stike Admin Checks 
# @Killswitch-GUI
# Ref: http://stackoverflow.com/questions/18674801/administrative-privileges
# http://www.fixitscripts.com/problems/script-to-detect-current-user-and-determine-if-that-user-is-a-local-admin-or-not

function Invoke-LocalAdminCheck { 
<#
        .SYNOPSIS
        Checks to see if current user is the local Admin group and returns a string to console for Cobalt strike to grab. 
        This Allows me to automat Bypass UAC and Getsystem

        .PARAMETER Initial
        Decalre if the commmand was run from the CS terminal or on intial load of agent.
    #>
    [cmdletbinding()]
    param(
        [Parameter(Position=0,ValueFromPipeline=$true)]
        [String[]]
        $Initial
    )
    process {
        $User = [Security.Principal.WindowsIdentity]::GetCurrent()
        $IsAdmin = (New-Object Security.Principal.WindowsPrincipal $User).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
        $SecondCheck = Get-SecondCheck
        If ($IsAdmin -or $SecondCheck)
                {
                If ($Initial)
                    {
                    write-output "[!] Agent-Started-in-LocalAdmin-Context"
                    }
                Else
                    {
                     write-output "[!] Currently-in-LocalAdmin-Context"
                    }

                }
         Else
                {
                write-output "[!] Current-User-Not-LocalAdmin-Context"
                }
    }
}

function Get-SecondCheck { 
<#
        .SYNOPSIS
        Checks to see if current user is the local Admin group and returns a string to console for Cobalt strike to grab. 
        This Allows me to automat Bypass UAC and Getsystem

        .PARAMETER Initial
        Decalre if the commmand was run from the CS terminal or on intial load of agent.
    #>
    process {
        Try {
            $admUsers = @()
            $curUser = $env:username
            $strComputer = "."
            $computer = [ADSI]("WinNT://" + $strComputer + ",computer")
            $Group = $computer.psbase.children.find("Administrators")
            $members= $Group.psbase.invoke("Members") | %{$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}
            ForEach($user in $members) {
                $admUsers += $user
                }
            if(($admUsers -contains $curUser) -eq $True) {
                return $true
            }
            else {
                return $false
            }
        }
        Catch {
            write-output  "Script Check Failed"
        }
    }

}

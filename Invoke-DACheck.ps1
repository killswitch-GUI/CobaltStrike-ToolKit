function Invoke-DACheck { 
<#
        .SYNOPSIS
        Checks to see if current user is in DA Groups and if he is returns a specfic string alerting user that they are DA for Automated purposes.

        .PARAMETER Initial
        Enables a share Anyone can Read/Write to.
    #>
    [cmdletbinding()]
    param(
        [Parameter(Position=0,ValueFromPipeline=$true)]
        [String[]]
        $Initial
    )
    process {
        # Returns list of process owners
        $Users = Get-User
        # Returns list of domain admins
        $DomainAdmins = Get-DomainAdmins
        # Dont know how to loop through each variable
        $Found = ForEach ($User in $Users) {if ($DomainAdmins -contains $User) {Write-Host "[!] Found-DA-User: $User" -ForegroundColor "red"}} 
           }
}

function Get-DomainAdmins { 
<#
        .SYNOPSIS
        Montiotrs the current DA accounts and alerts the desired admin if a change where to take place whithin the group.

        .PARAMETER CheckRate
        Pass me a command in a Variable.

        .PARAMETER EmailAdress
        Pass me a command in a Variable.
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$True)]
        [string]$Command
    )
    process 
        {
        $Ver = $PSVersionTable.PSVersion
        If ($Ver.Major -gt 4)
            {
            $DAobj = Get-ADGroupMember -Identity ‘Domain Admins’
            return $DAobj.name
            }

        Else
            {
            $Recurse = $true
            Add-Type -AssemblyName System.DirectoryServices.AccountManagement
            $ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain
            $group=[System.DirectoryServices.AccountManagement.GroupPrincipal]::FindByIdentity($ct,'Domain Admins')
            $Obj = $group.GetMembers($Recurse) | select SamAccountName
            $DAUsers = foreach($x in $group.GetMembers($Recurse)){$x.SamAccountName}
            return $DAUsers
            }
        }
    }


function Get-User { 
<#
        .SYNOPSIS
        Montiotrs the current DA accounts and alerts the desired admin if a change where to take place whithin the group.
    #>
    process {
        # This retrieves all running processes that are not running as local system and such
		$ProcessOwner = @{}
		Get-WmiObject win32_process | ForEach-Object {$ProcessOwner[$_.handle] = $_.getowner().user}
		$ProcessOwnerList = Get-Process | Select-Object Id,@{l="Owner";e={$ProcessOwner[$_.id.ToString()]}} | Where-Object {!($ProcessOwner[$_.id.ToString()] -match "(?:SYSTEM|(?:LOCAL|NETWORK) SERVICE)")}
        return $ProcessOwnerList.Owner        

        # $User = [Security.Principal.WindowsIdentity]::GetCurrent().Name
        # $User = $User.trimstart([Environment]::UserDomainName)
        # $User = $User.trimstart("\")
        # return $User
    }
}

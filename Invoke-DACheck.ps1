function Invoke-DACheck { 
<#
        .SYNOPSIS
        Checks to see if current user is in DA Groups and if he is returns a specfic string alerting user that they are DA for Automated purposes.
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$True)]
        [string]$Command
    )
    process {
        $User = Get-User
        $DomainAdmins = Get-DomainAdmins
        foreach($DomainUser in $DomainAdmins) 
            {
            if($User -eq $DomainUser)
                {
                Write-Host "Found-DA-User: $User"
                }


            }
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
        $User = [Security.Principal.WindowsIdentity]::GetCurrent().Name
        $User = $User.trimstart([Environment]::UserDomainName)
        $User = $User.trimstart("\")
        return $User
    }
}
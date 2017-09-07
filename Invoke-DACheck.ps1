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
        $User = Get-User
        $DomainAdmins = Get-DomainAdmins
        foreach($DomainUser in $DomainAdmins) 
            {
            if($User -eq $DomainUser)
                {
                If($Initial)
                    {
                    write-output "[!] Found-DA-User: $User"
                    }
                Else
                    {
                    write-output "[!] Currently DA Context"
                    }
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
        $groupname = 'Domain Admins'
        $DAUsers = (New-Object System.DirectoryServices.DirectoryEntry((New-Object System.DirectoryServices.DirectorySearcher("(&(objectCategory=Group)(name=$($groupname)))")).FindOne().GetDirectoryEntry().Path)).member | % { (New-Object System.DirectoryServices.DirectoryEntry("LDAP://"+$_)) } | foreach {$_.sAMAccountName}
        return $DAUsers   
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

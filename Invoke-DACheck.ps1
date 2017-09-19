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
        $User = Get-User
        # Returns list of domain admins
        $DomainAdmins = Get-DomainAdmins
        # Loop through Process Owners
        ForEach ($DomainUser in $DomainAdmins) 
            {
            if($User -match $DomainUser)
                {
                if($Initial)
                    {
                    Write-Output "[!] Found-DA-User: $DomainUser"
                    }
                else
                    {
                    Write-Output "[!] Found-DA-User: $DomainUser"
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
        # This retrieves all running processes that are not running as local system and such
        $ProcessOwner = @{}
        Get-WmiObject win32_process | ForEach-Object {$ProcessOwner[$_.handle] = $_.getowner().user}
        $ProcessOwnerList = Get-Process | Select-Object Id, @{l="Owner";e={$ProcessOwner[$_.id.ToString()]}} | Where-Object {!($ProcessOwner[$_.id.ToString()] -match "(?:SYSTEM|(?:LOCAL|NETWORK) SERVICE)")}
        $Output = $ProcessOwnerList | Select-Object Owner -Unique
        return $Output
        
        
    }
}

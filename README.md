# CobaltStrike-ToolKit

## CheckDA

Currently uses a powershell based check, combined with a aggressor script to check for the intial agent user name.
While using .NET 3.5 to perform Domain Group enumeration. This allows for alerting on Pentest of a DA level beacon.
### Usage
Load up the Script:
```
aggressor> load /root/Tools/CobaltStrike-ToolKit/Initial-DACheck.cna
[+] Load /root/Tools/CobaltStrike-ToolKit/Initial-DACheck.cna
```
When a intial beacon comes in you recive a pop up box and will see:
```
[*] Tasked beacon to import: /root/Tools/CobaltStrike-ToolKit/Invoke-DACheck.ps1
[*] Tasked beacon to run: Invoke-DACheck -Initial True
[+] host called home, sent: 2527 bytes
[+] received output:
Found-DA-User: admin
```
### Indipendent Command:
```
beacon> checkda
[*] Tasked beacon to import: /root/Tools/CobaltStrike-ToolKit/Invoke-DACheck.ps1
[*] Tasked beacon to run: Invoke-DACheck
[+] host called home, sent: 2519 bytes
[+] received output:
[!] Currently DA Context
```



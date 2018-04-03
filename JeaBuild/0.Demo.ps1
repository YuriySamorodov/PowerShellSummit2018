
### Sign in as JAsonNonAdmin and connect to endpoint on DC JEABreakGLASS
Enter-PSSession -Name dc -Credential company\jasonNotAdmin -ConfigurationName JEABreakGlass
Get-UserInfo


### Show Files
New-Item -Path c:\test -ItemType Directory
New-PSRoleCapabilityFile -Path c:\Test\Capability.psrc  # explain extenstion - path must end with file.psrc
New-PSSessionConfigurationFile -Path c:\test\Session.pssc
ISE C:\test\session.pssc
ISE c:\test\Capability.psrc

### JEa Build
Set-Location 'C:\Github\JEA\DSCCamp\JeaBuild'
ISE .\JEABuild.ps1

### JEA Deploy
ISE .\JeaDeploy.ps1

Enter-PSSession -Name dc -Credential company\jimjea -ConfigurationName JEAPrintOperators



#region Notes for Logging
#Turn on detail logging
# 1.	Navigate to "Computer Configuration\Policies\Administrative Templates\Windows Components\Windows PowerShell"
# 1.	Double Click on "Turn on Module Logging"
# 2.	Click "Enabled"
# 3.	In the Options section, click on "Show" next to Module Names
# 4.	Type "*" in the pop up window. This means PowerShell will log commands from all modules.

#endregion

# Logs
Get-Winevent -LogName Microsoft-Windows-WinRM/Operational | Select-Object -First 20 

$Events=Get-Winevent -LogName Microsoft-Windows-WinRM/Operational | 
    Where-Object {$_.ID -eq 193} | Select-Object -first 10 

$events2=Get-Winevent -LogName Microsoft-Windows-PowerShell/Operational | Where-Object {$_.UserID -eq 'S-1-5-94-1468353315' }

#Transcript
ISE C:\ProgramData\JEAConfiguration\Transcripts\JEAPrintOperators

#DSC
# Only configures the endpoint now.
# Still get some changes -- like restrictedRemoteServer
# Can get of Github -- JustEnouphAdministration
Ise .\JEADSC.ps1

#Slides -- Does and Donts


<#
Disclaimer

This example code is provided without copyright and “AS IS”.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>
Break # To prevent accidental execution as a script - Do not remove

#region User for BreakGlass 
# Credentials for user passwords
$credential=(Get-credential).Password

# NEw Users
New-ADUser -Name 'Jason NotAdmin' -SamAccountName 'JasonNotAdmin' -path 'OU=JEA_Operators,DC=Company,DC=Pri' -AccountPassword $credential -Department IT -Enabled $true -PasswordNeverExpires $true 

#New Group
# Point it out -- The group name can have spaces, but not underscores. --
New-ADGroup -Name 'JEA BreakGlass' -Path 'OU=JEA_Operators,DC=Company,DC=Pri' -GroupScope global -GroupCategory Security

#Add Users to correct groups
Add-ADGroupMember -Identity 'JEA BreakGlass' -Members JasonNotAdmin
#endregion

#region Folder for Module and EndPoint Config

$Path = 'C:\JEADev\BreakGlass\Module\JEABreakGlass\RoleCapabilities'

If ((Test-Path -path $Path) -eq $False) {
    Write-Output "Creating directory $Path"
    New-Item -Path $Path -ItemType Directory
}

If ((Test-Path -path 'c:\ProgramData\JEAConfiguration') -eq $False) {
    Write-Output "Creating directory"
    New-Item -Path 'c:\ProgramData\JEAConfiguration' -ItemType Directory
}

#endregion

#region Create BreakGlass Role Capability module

$Path = 'C:\JEADev\BreakGlass\JEABreakGlass\RoleCapabilities'

$BreakGlassRole = @{
    Path = "$Path\BreakGlass.psrc"
    Author = 'Company Admin'
    CompanyName = 'Company'
}

New-PSRoleCapabilityFile @BreakGlassRole

#endregion 

#region Break Glass Session Configuration file (contrained Endpoint)



$BreakGlassSessionConfigParams = @{
    SessionType = 'Default'
    RunAsVirtualAccount = $true
    TranscriptDirectory = 'c:\ProgramData\JEAConfiguration\Transcripts\BreakGlass'
    RoleDefinitions = @{'Company\JEA BreakGlass' = @{ RoleCapabilities = 'BreakGlass' }}
}

New-PSSessionConfigurationFile -Path 'C:\JeaDEv\BreakGlass\JEABreakGlass.pssc' @BreakGlassSessionConfigParams


#endregion

#region Deploy
Copy-Item C:\GitHub\JEA\DSCCamp\BreakGlass\JeaBreakGlassDeploy.ps1 -Destination C:\JEADev\BreakGlass
Copy-Item C:\JEADev\BreakGlass -Recurse -Destination \\dc\c$\JEADev\BreakGlass -Force

Invoke-Command -ComputerName dc {C:\JEADev\BreakGlass\JeaBreakGlassDeploy.ps1}
#Explain error messege -- do to Restart of WinRM

#endregion

#region Test

Enter-PSSession -ComputerName DC -ConfigurationName JEABreakGlass
Get-Module -ListAvailable
Get-SystemInfo
Get-UserInfo
Function Foo {"Hello Foo"}

#endregion

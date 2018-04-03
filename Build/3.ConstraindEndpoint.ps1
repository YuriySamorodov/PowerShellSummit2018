<#
Disclaimer

This example code is provided without copyright and “AS IS”.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>
Break # To prevent accidental execution as a script - Do not remove

# First -- you will need a folder to store the session configurations -- and we have a place for you to do this.
Test-Path -Path "$env:ProgramData\JEAConfiguration"
New-Item -Path "$env:ProgramData\JEAConfiguration" -ItemType Directory

If ((Test-Path -path "$env:ProgramData\JEAConfiguration") -eq $False) {
    Write-Output "Creating directory"
    New-Item -Path "$env:ProgramData\JEAConfiguration" -ItemType Directory
}


# NExt -- check if the endpoint already exists -- if it does, you have to remove it
Get-PSSessionConfiguration -Name PrintOperator

Unregister-PSSessionConfiguration -Name PrintOperator
Restart-service Winrm

# Note: You will not be able to use a virtual account if you are using WMF 5.0 on Windows 7 or Windows Server 2008 R2

$JEAConfigParams = @{
    SessionType = 'RestrictedRemoteServer'
    RunAsVirtualAccount = $true
    RoleDefinitions = @{'Company\JEA Print Operators' = @{ RoleCapabilities = 'PrintOperator' }}
}

ISE C:\test\session.pssc

New-PSSessionConfigurationFile -Path "$env:ProgramData\JEAConfiguration\JEAPrintOperators.pssc" @JEAConfigParams


# Register the session configuration
Register-PSSessionConfiguration -Name PrintOperators -Path "$env:ProgramData\JEAConfiguration\JEAPrintOperators.pssc"
Restart-Service -name Winrm

# If you try to register it again -- you get an error -- so remember to unregister if you need to.
Register-PSSessionConfiguration -Name PrintOperators -Path "$env:ProgramData\JEAConfiguration\JEAPrintOperators.pssc"
Unregister-PSSessionConfiguration -Name PrintOperators

# Display the endpoint
Get-PSSessionConfiguration

############## END



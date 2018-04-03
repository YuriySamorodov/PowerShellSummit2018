<#
Disclaimer

This example code is provided without copyright and “AS IS”.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>
Break # To prevent accidental execution as a script - Do not remove

# Create the folders and module/manifest we need.
# Note - this is being created locally
If ((Test-Path -path "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators") -eq $False) {
    Write-Output "Creating directories"
    New-Item -Path "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators" -ItemType Directory # For module
    New-Item -Path "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators\RoleCapabilities" -ItemType Directory # For role Capability 
    New-Item -Path "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators\JEAPrintOperators.psm1" -ItemType File # Module
    New-ModuleManifest -Path "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators\JEAPrintOperators.psd1" # Manifest
    New-Item -Path "$env:ProgramData\JEAConfiguration" -ItemType Directory # For Session Configuration
}

Explorer "$env:ProgramFiles\WindowsPowerShell\Modules"
Explorer "$env:ProgramData"


# Create the role capability file
$MaintenanceRoleCapabilityCreationParams = @{
    Path = "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators\RoleCapabilities\PrintOperator.psrc"
    Author = 'Company Admin'
    CompanyName = 'Company'
    ModulesToImport = 'PrintManagement'
    VisibleCmdlets = 'Get-Service', @{ Name = 'Restart-Service'; Parameters = @{ Name = 'Name'; ValidateSet = 'Spooler'}},'NetTCPIP\Get-*'
    VisibleFunctions = '*-printer*'
    VisibleExternalCommands = 'C:\Windows\System32\ipconfig.exe'
    FunctionDefinitions = @{ Name = 'Get-UserInfo'; ScriptBlock = { $PSSenderInfo } }
}
New-PSRoleCapabilityFile @MaintenanceRoleCapabilityCreationParams 
# Let's take a look at it.
Code "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators\RoleCapabilities\PrintOperator.psrc"

# Create the Session Configuration file

$JEAConfigParams = @{
    SessionType = 'RestrictedRemoteServer'
    RunAsVirtualAccount = $true
    RoleDefinitions = @{'Company\JEA Print Operators' = @{ RoleCapabilities = 'PrintOperator' }}
}
New-PSSessionConfigurationFile -Path "$env:ProgramData\JEAConfiguration\PrintOperator.pssc" @JEAConfigParams

Code "$env:ProgramData\JEAConfiguration\PrintOperator.pssc"


# Register the endpoint
# NExt -- check if the endpoint already exists -- if it does, you have to remove it
If ((Get-PSSessionConfiguration -name PrintOperator -ErrorAction Silently).exactmatch -eq $true){
    Write-Output -InputObject "Found"
    Unregister-PSSessionConfiguration -Name PrintOperator
    Restart-service -Name Winrm
}Else {
    Write-Output -InputObject "Not Found"
}

If ((Test-Path -path "$env:ProgramData\JEAConfiguration\PrintOperator.pssc") -eq $True){
    Write-Output -InputObject "Found"
    Register-PSSessionConfiguration -Name PrintOperator
    Restart-service -Name Winrm
}

Get-PSSessionConfiguration 

# Test Access
Enter-PSSession -ComputerName Demo -ConfigurationName PrintOperator -Credential Company\JimJea
Get-Command
Get-Command -Module PrintManagement
Get-Command -Module NetTCPIP
Ipconfig
Exit-PSSession




# Cleanup and reset
Unregister-PSSessionConfiguration -Name PrintOperator
Restart-service -Name Winrm
Remove-Item -Path "$env:ProgramData\JEAConfiguration" -Force -Recurse
Remove-Item -Path "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators" -Force -Recurse
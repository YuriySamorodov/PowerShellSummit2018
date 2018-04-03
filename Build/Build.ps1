<#
Disclaimer

This example code is provided without copyright and “AS IS”.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>
Break # To prevent accidental execution as a script - Do not remove


# Note - this is being created locally
New-Item -Path "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators" -ItemType Directory
New-Item -Path "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators\RoleCapabilities" -ItemType Directory 
# You need to create a Module/manifest -- you can put your own functions in the module -- in fact
New-Item -Path "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators\JEAPrintOperators.psm1" -ItemType File
New-ModuleManifest -Path "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators\JEAPrintOperators.psd1"
#Remove-Item -Path "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators" -Force



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

# First -- create a folder.
If ((Test-Path -path "$env:ProgramData\JEAConfiguration") -eq $False) {
    Write-Output "Creating directory"
    New-Item -Path "$env:ProgramData\JEAConfiguration" -ItemType Directory
}

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




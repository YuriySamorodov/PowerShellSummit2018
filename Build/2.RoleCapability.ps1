<#
Disclaimer

This example code is provided without copyright and “AS IS”.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>
Break # To prevent accidental execution as a script - Do not remove


# Note - this is being created locally on the client
New-Item -Path "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators" -ItemType Directory
New-Item -Path "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators\RoleCapabilities" -ItemType Directory 

#Remove-Item -Path "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators" -Force 
# You need to create a manifest -- you could actually have your own module as well -- in fact
 # you will see this for a lot of modules going forward
New-ModuleManifest -Path "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators\PrintOperators.psd1"

# Fields in the role capability
$MaintenanceRoleCapabilityCreationParams = @{
    Path = "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators\RoleCapabilities\PrintOperator.psrc"
    Author = 'Company Admin'
    CompanyName = 'Company'
    VisibleCmdlets = 'Restart-Service'
    FunctionDefinitions = @{ Name = 'Get-UserInfo'; ScriptBlock = { $PSSenderInfo } }
    # $PSSenderInfo is not exposed by default - so we make a function to display that is
}


New-PSRoleCapabilityFile @MaintenanceRoleCapabilityCreationParams 

#Verify the settings

ISE "$env:ProgramFiles\WindowsPowerShell\Modules\JEAPrintOperators\RoleCapabilities\PrintOperator.psrc"

# End Demo
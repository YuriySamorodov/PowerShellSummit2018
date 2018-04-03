

##region Test
#
Get-PSSessionConfiguration
Enter-PSSession -ComputerName Client -ConfigurationName $JEAEndpointName #Fails
Enter-PSSession -ComputerName Client -ConfigurationName $JEAEndpointName -Credential Company\JimJea
Get-Command
Restart-Service bits -ver
Get-UserInfo # Note the virtual account
Function Foo {"Hello Foo"}
exit-Pssession
#endregion

#region JEA Improve

ISE C:\JEADev\JEAPrint\RoleCapabilities\JEAPrintRole.psrc

# I prefer to go back to splatting

$RoleCapability = @{
    Path = 'C:\JEADev\JEAPrint\RoleCapabilities\JEAPrintRole.psrc'
    Author = 'Company Admin'
    CompanyName = 'Company'
    ModulesToImport = 'PrintManagement'
    VisibleCmdlets = 'Get-Service', @{ Name = 'Restart-Service'; Parameters = @{ Name = 'Name'; ValidateSet = 'Spooler'}},'NetTCPIP\Get-*'
    VisibleFunctions = '*-printer*'
    VisibleExternalCommands = 'C:\Windows\System32\ipconfig.exe'
    FunctionDefinitions = @{ Name = 'Get-UserInfo'; ScriptBlock = { $PSSenderInfo } }
}

New-PSRoleCapabilityFile @RoleCapability

Copy-Item C:\JEADev\JEAPrint\RoleCapabilities\JEAPrintRole.psrc -Destination 'C:\Program Files\WindowsPowerShell\Modules\JEAPrint\RoleCapabilities' -Force


#endregion

#region Test Again

Enter-PSSession -ComputerName Client -ConfigurationName $JEAEndpointName -Credential Company\JimJea
Get-Command
Restart-Service bits -ver
Restart-Service Spooler -ver
Ipconfig /ALL
Exit-Pssession
#endregion
#Done
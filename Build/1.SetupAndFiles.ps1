<#
Disclaimer

This example code is provided without copyright and “AS IS”.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>
Break # To prevent accidental execution as a script - Do not remove


####################################################
# Create the OU and Users/Groups for testing

# Credentials for user passwords
$credential=(Get-credential).Password

# New OU
New-ADOrganizationalUnit -Name JEA_Operators -path 'DC=Company,DC=pri' -ProtectedFromAccidentalDeletion $false

# NEw Users
New-ADUser -Name 'Jim Jea' -SamAccountName JimJea -path 'OU=JEA_Operators,DC=Company,DC=Pri' -AccountPassword $credential -Department Accounting -Enabled $true -PasswordNeverExpires $true 
New-ADUser -Name 'Jill Jea' -SamAccountName JillJea -path 'OU=JEA_Operators,DC=Company,DC=Pri' -AccountPassword $credential -Department Accounting -Enabled $true -PasswordNeverExpires $true 

#New Group
# The group name can have spaces, but not underscores.
New-ADGroup -Name 'JEA Print Operators' -Path 'OU=JEA_Operators,DC=Company,DC=Pri' -GroupScope global -GroupCategory Security
New-ADGroup -Name 'JEA Service Operators' -Path 'OU=JEA_Operators,DC=Company,DC=Pri' -GroupScope global -GroupCategory Security

#Add Users to correct groups
Add-ADGroupMember -Identity 'JEA Print Operators' -Members JimJea
Add-ADGroupMember -Identity 'JEA Service Operators' -Members JillJea


#########################################################

# First, the cmdlet
New-Item -Path c:\test -ItemType Directory
New-PSRoleCapabilityFile -Path c:\Test\Capability.psrc  # explain extenstion - path must end with file.psrc
New-PSSessionConfigurationFile -Path c:\test\Session.pssc
ISE C:\test\session.pssc
ISE c:\test\Capability.psrc
Remove-Item C:\test\*

# Now using Parameters
Remove-Item C:\test\*
New-PSRoleCapabilityFile -Path C:\test\Capability.psrc -Author 'Company Admin' -CompanyName 'Company' -VisibleCmdlets Restart-Service  
ISE C:\test\Filename.psrc





#######################################
# Now with Splatting

Get-service -ComputerName dc -Name bits

$Service=@{
    computername = 'dc'
    Name = 'bits'
    }

Get-Service @Service

####################################################################

# Fields in the role capability
$MaintenanceRoleCapabilityCreationParams = @{
    Path = "c:\test\PrintOperator.psrc"
    Author = 'Company Admin'
    CompanyName = 'Company'
    VisibleCmdlets = 'Restart-Service'
    FunctionDefinitions = @{ Name = 'Get-UserInfo'; ScriptBlock = { $PSSenderInfo } }
}


New-PSRoleCapabilityFile @MaintenanceRoleCapabilityCreationParams 


ISE C:\test\PrintOperator.psrc


# End Demo



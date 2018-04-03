<#
Disclaimer

This example code is provided without copyright and “AS IS”.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>
Break # To prevent accidental execution as a script - Do not remove

# Signed in as a regular user
Enter-PSSession -ComputerName dc #Will fail
Enter-PSSession -ComputerName dc -Credential company\DonJ #Works
Invoke-command -ComputerName dc -Credential company\DonJ {Get-Service -name Spooler}

# Session Configuration

Enter-PSSession -ComputerName dc -ConfigurationName # Microsoft.PowerShell

Enter-PSSession -ComputerName dc -Credential company\DonJ
Get-PSSessionConfiguration -Name *
$PSSenderInfo


# END -- This demo

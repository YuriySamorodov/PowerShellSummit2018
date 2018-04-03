<#Disclaimer

This example code is provided without copyright and “AS IS”.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>



# JEADeploy.ps1

# Create directory for session configuration if it doesn't exist
If ((Test-Path -path 'c:\ProgramData\JEAConfiguration') -eq $False) {
    Write-Output "Creating JEAConfiguration directory"
    New-Item -Path 'c:\ProgramData\JEAConfiguration' -ItemType Directory
}

# Copy Session and Modules
Write-Output "Copying Modules and Session Configuration"
Copy-Item -Path 'C:\JEADev\BreakGlass\JEABreakGlass.pssc' -Destination 'c:\ProgramData\JEAConfiguration' -Force
Copy-Item -Path 'C:\JEADev\BreakGlass\JEABreakGlass' -Recurse -Destination 'c:\Program Files\WindowsPowerShell\Modules' -Force

# Register the endpoint

Write-Output " Registering Endpoint"

    if (Get-PSSessionConfiguration -Name JEABreakGlass -ErrorAction SilentlyContinue)
    {
        Unregister-PSSessionConfiguration -Name JEABreakGlass -ErrorAction Stop
        
    }

Register-PSSessionConfiguration -Name JEABreakGlass -Path 'c:\ProgramData\JEAConfiguration\JEABreakGlass.pssc'

# End


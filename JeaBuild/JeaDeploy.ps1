<#Disclaimer

This example code is provided without copyright and “AS IS”.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>

Param (
[String]$JEADevPath = 'c:\JeaDev',
[String]$JEAModuleName = 'JEAPrint',
[String]$JEASessionConfigName = 'JEAPrintConfig', # .pssc will be added later
[String]$JEAEndpointName = 'JEAPrintOperators'
)

# JEADeploy.ps1

$JEAProjectPath = "$JEADevPath\$JEAModuleName"


# Create directory for session configuration if it doesn't exist
If ((Test-Path -path 'c:\ProgramData\JEAConfiguration') -eq $False) {
    Write-Output "Creating JEAConfiguration directory"
    New-Item -Path 'c:\ProgramData\JEAConfiguration' -ItemType Directory
}

# Copy Session and Modules
Write-Output "Copying Modules and Session Configuration"
Copy-Item -Path "$JEAProjectPath\$JEASessionConfigName.pssc" -Destination 'c:\ProgramData\JEAConfiguration' -force
Copy-Item -Path "$JEAProjectPath" -Recurse -Destination 'c:\Program Files\WindowsPowerShell\Modules' -force

# Register the endpoint

Write-Output " Registering Endpoint"

    if (Get-PSSessionConfiguration -Name $JEAEndpointName -ErrorAction SilentlyContinue)
    {
        Unregister-PSSessionConfiguration -Name $JEAEndpointName -ErrorAction Stop
        
    }

Register-PSSessionConfiguration -Name $JEAEndpointName -Path "c:\ProgramData\JEAConfiguration\$JEASessionConfigName.pssc"

# End


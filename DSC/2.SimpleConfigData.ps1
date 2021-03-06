﻿<#
From the Microsoft Docs

DSC provides three special variables that can be used in a configuration script: 
$AllNodes, $Node, and $ConfigurationData.

-$AllNodes refers to the entire collection of nodes defined in ConfigurationData. 
-You can filter the AllNodes collection by using .Where() and .ForEach().
-$Node refers to a particular entry in the AllNodes collection after it is filtered by using .Where() or .ForEach().
-$ConfigurationData refers to the entire hash table that is passed as the parameter when compiling a configuration.
#>

Configuration TestConfig {

    Import-DSCresource -ModuleName PSDesiredStateConfiguration

    node $AllNodes.Where({$true}).NodeName {

        File LogFile {
            DestinationPath = $Node.DestinationPath
        }
            
        Service bits {
            Name= $Node.BitsService
            State=$Node.ServiceState
        }

        WindowsFeature DomainController{
            Name= $Node.DCFeature
            Ensure= $Node.EnsurePresent
        }

        WindowsFeature DNS{
            Name= $Node.DNSFeature
            Ensure= $Node.EnsurePresent
        }
    }
}

TestConfig -OutputPath .\ -ConfigurationData .\2.SimpleConfigData.psd1 # Running the Config and produce mofs in the current directory
<#
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
    }

    node $AllNodes.Where({$_.Role -eq 'DC'}).NodeName {
        WindowsFeature DomainController{
            Name= $Node.Feature
            Ensure= $Node.EnsurePresent
        }
    }

    node $AllNodes.Where({$_.Role -eq 'DNS'}).NodeName {
        WindowsFeature DNS{
            Name= $Node.Feature
            Ensure= $Node.EnsurePresent
        }
    }
}

TestConfig -OutputPath .\ -ConfigurationData .\3.Role-Based.psd1 # Running the Config and produce mofs in the current directory
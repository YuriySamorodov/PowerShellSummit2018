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


    Node $ComputerName {

        File LogFile {
            DestinationPath = $Node.DestinationPath
            #Type = $Node.ObjectType
            Contents = $Node.Contents
        }
         
        
        <#foreach ($Service in ($node.ServiceList)) {
            Service $Service {
                Name = $Service
                State='Running'
            }
        }
        #>
    }
}
<#
        Service bits {
            Name='bits'
            State='running'
        }

        Service bfe {
            Name='bfe'
            State='running'
        }

        WindowsFeature Web{
            Name='Web-server'
            Ensure='Present'
        }

        WindowsFeature DomainController{
            Name='AD-Domain-Services'
            Ensure='Present'
        }

        WindowsFeature DNS{
            Name='DNS'
            Ensure='Present'
        }
    }
}
#>
$computername = 'S1'#,'s2','s3','s4'
TestConfig -OutputPath .\ -ConfigurationData .\2.SimpleConfigData.psd1 
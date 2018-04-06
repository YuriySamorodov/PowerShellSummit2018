<#
From the Microsoft Docs

DSC provides three special variables that can be used in a configuration script: 
$AllNodes, $Node, and $ConfigurationData.

-$AllNodes refers to the entire collection of nodes defined in ConfigurationData. 
-You can filter the AllNodes collection by using .Where() and .ForEach().
-$Node refers to a particular entry in the AllNodes collection after it is filtered by using .Where() or .ForEach().
-$ConfigurationData refers to the entire hash table that is passed as the parameter when compiling a configuration.
#>

@{
    AllNodes = @(
        @{
            # Applys to all Nodes
            NodeName = '*' 
            DestinationPath = 'c:\Log\Logfile.txt'
            ServiceState = 'Running'
            BitsService = 'Bits'
            #DCFeature = 'AD-Domain-Services'
            #DNSFeature = 'DNS'
            EnsurePresent = 'Present'
            EnsureAbsent = 'Absent'
        },

        @{
            NodeName = 'S1'
            Role = 'DC'
            Feature = 'AD-Domain-Services'
        },

        @{
            NodeName = 'S2'
            Role = 'DNS'
            Feature = 'DNS'
        }

        # JASON - add some more
        # Remind everyone, this is normally auto-generated
    );
}


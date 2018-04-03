onfiguration JEAEndPoint {

    Param (
        [Parameter(Mandatory=$true)]
        [string[]]$ComputerName
    )

    
    
    Import-DscResource -ModuleName JustEnoughAdministration 

    Node $ComputerName {
        JeaEndpoint PrintOperators #ResourceName
        {
            EndpointName = 'PrintOperators'
            RoleDefinitions = "@{'Company\JEA Print Operators' = @{ RoleCapabilities = 'PrintOperator' }}"
            #[DependsOn = [string[]]]
            #[GroupManagedServiceAccount = [string]]
            #[MountUserDrive = [bool]]
            #[PsDscRunAsCredential = [PSCredential]]
            #[RequiredGroups = [string]]
            #[RunAsVirtualAccountGroups = [string[]]]
            #[ScriptsToProcess = [string[]]]
            TranscriptDirectory = 'c:\ProgramData\JEAConfiguration\Transcripts'
            #[UserDriveMaximumSize = [Int64]]
        }
    }
}

JEAEndPoint -ComputerName s2 -OutputPath c:\MOF
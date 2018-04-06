Configuration TestConfig {

    Import-DSCresource -ModuleName PSDesiredStateConfiguration
    
    Node $ComputerName {
        File LogFile {
            DestinationPath = 'c:\Log\Logfile.txt'
            Type = 'File'
            Contents = 'This is a logfile'
        }
               
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
$computername = 'S1'#,'s2','s3','s4'
TestConfig -OutputPath .\ # Running the Config and produce mofs in the current directory
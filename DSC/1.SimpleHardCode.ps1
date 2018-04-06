Configuration TestConfig {

    Import-DSCresource -ModuleName PSDesiredStateConfiguration

    File LogFile {
        DestinationPath = 'c:\Log\Logfile.txt'
    }
            
    Service bits {
        Name='bits'
        State='running'
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

TestConfig -InstanceName 's1','s2' -OutputPath .\ # Running the Config and produce mofs in the current directory
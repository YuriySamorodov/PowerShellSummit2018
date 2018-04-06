Configuration ServiceBits{
    Node $ComputerName {
        Service bits {
            Name='bits'
            State='running'
        }

        WindowsFeature Web{
            Name='Web-server'
            Ensure='Present'
        }
    }
}
$computername = 'S1','S2'
ServiceBits -OutputPath c:\DSC\Config
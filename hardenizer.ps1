$Tests = @(
    @{
        # Do not allow the system to shut down without logging in
        # Risk: Process stop possible
        # Weak point: Shutdown option freely accessible
        # Solution: Shutdown only possible after user login
        Name       = "harden_2";
        Registries = @(
            @{
                Path             = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\";
                Key              = "shutdownwithlogon";
                ExpectedKeyValue = 0
            }
        )  
    };
    @{
        # Detect application installation and request elevated rights with User Account Control (UAC) (ref. 4.2)
        # Rischio: gli impiegati con diritti utente possono installare qualsiasi programma desiderino.
        # Punto debole: l'installazione delle applicazioni è possibile anche da parte dell'utente.
        # Soluzione: disattivazione della richiesta di password per i diritti di amministratore.
        Name       = "harden_3"
        Registries = @(
            @{
                Path             = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\";
                Key              = "FilterAdministratorToken";
                ExpectedKeyValue = 1
            };
            @{
                Path             = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\";
                Key              = "ConsentPromptBehaviorUser"
                ExpectedKeyValue = 0
            }
        )  
    };
)


foreach ($Test in $Tests) {
    foreach ($Registry in $Test.Registries) {
        $KeyExists = (Get-Item $Registry.Path).Propriety -contains $Registry.Key
        if ($KeyExists) {
            $CurrentKeyValue = Get-ItemProperty -Path $Registry.Path -Name $Registry.Key
            if ($CurrentKeyValue -ne $Registry.ExpectedKeyValue) {
                Write-Host "Current value not equal to the expected one, setting value to expected one." -ForegroundColor Yellow
                Set-ItemProperty -Path $Registry.Path -Name $Registry.Key -Value $Registry.ExpectedKeyValue
            }
            else {
                Write-Host "Current Value is correct" -ForegroundColor Green 
            }
        }
        else {
            Write-Host 'Empty Value, creating key' -ForegroundColor Yellow 
            New-Item -Path $Registry.Path -Name $Registry.Key
            Set-ItemProperty -Path $Registry.Path -Name $Registry.Key -Value $Registry.ExpectedKeyValue
        } 
    }
}
Write-Host "All keys fixed, resuming install"
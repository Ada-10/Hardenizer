$Tests = @(
    
    @{
        Name       = "Remove Admin";
        Registries = @(
            @{
                Path  = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System";
                Name  = "FilterAdministratorToken";
                Value = 1;
            }
        )
    };
    
    @{
        Name       = "Test builder";
        Registries = @(
            @{
                Path  = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System";
                Name  = "shutdown";
                Value = 0;
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
$Tests = { { .Tests } } 


foreach ($Test in $Tests) {
    foreach ($Registry in $Test.Registries) {
        $KeyExists = (Get-Item $Registry.Path).Propriety -contains $Registry.Key
        if ($KeyExists) {
            $CurrentKeyValue = Get-ItemProperty -Path $Registry.Path -Name $Registry.Key
            if ($CurrentKeyValue -ne $Registry.ExpectedKeyValue) {
                Write-Host "Current value not equal to the expected one, setting value to expected one." -ForegroundColor Yellow
            }
            else {
                Write-Host "Current Value is correct" -ForegroundColor Green 
            }
        }
        else {
            Write-Host 'Empty Value for given key name' -ForegroundColor Red 
        } 
    }
}
Write-Host "All keys tested"
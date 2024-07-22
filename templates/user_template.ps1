Registry::HKU\DefaultUser\…
#This will automatically mount the C:\Users\Default\NTUSER.DAT hive, run your scripts and unmount the hive again. Your scripts will be run before user accounts are created – hence, they will affect all user accounts, including the built-in account Administrator
$Tests = @(
    {{range .}}
    @{
        Name       = "{{.TestName}}";
        Registries = @(
            @{
                Path  = "{{.Path}}";
                Name  = "{{.Name}}";
                Value = {{.Value}};
            }
        )
    };
    {{end}}
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
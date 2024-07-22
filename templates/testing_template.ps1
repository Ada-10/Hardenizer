Registry::HKU\DefaultUser\...
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

$correct_keys = 0
$incorrect_keys = 0
$not_found_keys = 0
$total_keys = 0
foreach ($Test in $Tests) {
    foreach ($Registry in $Test.Registries) {
        $KeyExists = (Get-Item $Registry.Path).Propriety -contains $Registry.Key
        if ($KeyExists) {
            $CurrentKeyValue = Get-ItemProperty -Path $Registry.Path -Name $Registry.Key
            if ($CurrentKeyValue -ne $Registry.ExpectedKeyValue) {
                Write-Host "Current value not equal to the expected one." -ForegroundColor Yellow
                $incorrect_keys += 1
                $total_keys += 1
            }
            else {
                Write-Host "Current Value is correct" -ForegroundColor Green 
                $correct_keys += 1
                $total_keys += 1
            }
        }
        else {
            Write-Host 'Empty Value for given key name' -ForegroundColor Red 
            $not_found_keys += 1
            $total_keys += 1
        } 
    }
}
Write-Host "All keys tested"
Write-Host "Correct keys: " $correct_keys -ForegroundColor Green
Write-Host "Incorrect keys: " $incorrect_keys -ForegroundColor Yellow
Write-Host "Empty keys: " $not_found_keys -ForegroundColor Red
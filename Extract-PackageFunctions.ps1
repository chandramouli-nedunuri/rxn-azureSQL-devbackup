# Extract functions and procedures from the package
$content = Get-Content "NON_EPR\ARS\Source_Oracle\ARS_Packages.sql.sql" -Raw

# Extract from package specification (between 'PACKAGE "ARS"."PKG_PDX_SCHEMA_UPDATER" AS' and first 'END PKG_PDX_SCHEMA_UPDATER;')
$pattern = 'PACKAGE\s+"ARS"\."PKG_PDX_SCHEMA_UPDATER"\s+AS(.*?)END\s+PKG_PDX_SCHEMA_UPDATER;'
$spec_match = [regex]::Match($content, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Singleline -bor [System.Text.RegularExpressions.RegexOptions]::Multiline)

if ($spec_match.Success) {
    $spec = $spec_match.Groups[1].Value
    
    # Extract FUNCTION declarations - capture the function name
    $func_pattern = 'FUNCTION\s+(\w+)\s*(?:\(|RETURN)'
    $func_matches = [regex]::Matches($spec, $func_pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Multiline)
    
    # Extract PROCEDURE declarations - capture the procedure name
    $proc_pattern = 'PROCEDURE\s+(\w+)\s*(?:\(|;|IS)'
    $proc_matches = [regex]::Matches($spec, $proc_pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Multiline)
    
    Write-Host "=== PUBLIC FUNCTIONS ===" -ForegroundColor Cyan
    $func_names = @()
    $func_matches | ForEach-Object { 
        $name = $_.Groups[1].Value
        if ($func_names -notcontains $name) {
            $func_names += $name
            Write-Host ("  {0}" -f $name)
        }
    }
    
    Write-Host ""
    Write-Host "=== PUBLIC PROCEDURES ===" -ForegroundColor Cyan
    $proc_names = @()
    $proc_matches | ForEach-Object { 
        $name = $_.Groups[1].Value
        if ($proc_names -notcontains $name) {
            $proc_names += $name
            Write-Host ("  {0}" -f $name)
        }
    }
    
    Write-Host ""
    Write-Host "SUMMARY:" -ForegroundColor Green
    Write-Host ("  Total Functions: {0}" -f $func_names.Count)
    Write-Host ("  Total Procedures: {0}" -f $proc_names.Count)
} else {
    Write-Host "Could not find package specification" -ForegroundColor Red
}

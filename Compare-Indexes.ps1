# Compare Oracle and Azure indexes
$oracleIndexes = @()
Get-Content "NON_EPR\ARS\Source_Oracle\ARS_Indexes-Ora" | Select-Object -Skip 1 | ForEach-Object {
    $cols = $_ -split "`t"
    if ($cols.Count -ge 3 -and $cols[2] -and $cols[2] -ne '[NULL]') {
        $pair = $cols[1] + '|' + $cols[2]
        if ($oracleIndexes -notcontains $pair) {
            $oracleIndexes += $pair
        }
    }
}

Write-Host ("Total Oracle indexes: {0}" -f $oracleIndexes.Count) -ForegroundColor Cyan
Write-Host ""

# Query Azure
$azureCmd = "SELECT DISTINCT t.name + '|' + i.name AS idx FROM sys.indexes i INNER JOIN sys.tables t ON i.object_id = t.object_id INNER JOIN sys.schemas s ON t.schema_id = s.schema_id WHERE s.name = 'ARS' AND i.name NOT LIKE '%ROWID%' ORDER BY t.name + '|' + i.name;"
$azureOutput = & powershell -ExecutionPolicy Bypass -File scripts\Connect-ToDatabase.ps1 -Query $azureCmd
$azureIndexes = @()
$azureOutput | ForEach-Object {
    if ($_ -match 'idx: (.+)$') {
        $azureIndexes += $Matches[1]
    }
}

Write-Host ("Total Azure indexes: {0}" -f $azureIndexes.Count) -ForegroundColor Cyan
Write-Host ""

# Find missing
$missing = @()
$oracleIndexes | ForEach-Object {
    if ($azureIndexes -notcontains $_) {
        $missing += $_
    }
}

if ($missing.Count -gt 0) {
    Write-Host "MISSING INDEXES (in Oracle but not in Azure):" -ForegroundColor Yellow
    $missing | Sort-Object | ForEach-Object { 
        Write-Host ("  {0}" -f $_) 
    }
} else {
    Write-Host "[SUCCESS] All Oracle indexes are present in Azure!" -ForegroundColor Green
}

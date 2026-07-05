# Get indexes from Azure
$azureIndexes = @()
Get-Content "Azure_Indexes_Full.txt" | Select-Object -Skip 6 | Where-Object { $_ -match 'name:' } | ForEach-Object {
    $name = $_ -replace '^.*name: ', ''
    if ($name -and $name.Trim()) {
        $azureIndexes += $name.Trim()
    }
}

# Get indexes from file
$fileIndexes = @()
Get-Content "NON_EPR\ARS\Target_Azure\ARS_Indexes_Azure" | Select-Object -Skip 1 | ForEach-Object {
    $cols = $_ -split "`t"
    if ($cols.Count -ge 3 -and $cols[2]) {
        if ($fileIndexes -notcontains $cols[2]) {
            $fileIndexes += $cols[2]
        }
    }
}

# Find missing
$missing = @()
$azureIndexes | ForEach-Object {
    if ($fileIndexes -notcontains $_) {
        $missing += $_
    }
}

Write-Host "Indexes in Azure DB but NOT in the file:" -ForegroundColor Yellow
if ($missing.Count -gt 0) {
    $missing | Sort-Object | ForEach-Object { Write-Host ("  {0}" -f $_) }
} else {
    Write-Host "  [NONE]"
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host ("  Azure DB total: {0} indexes" -f ($azureIndexes | Select-Object -Unique).Count)
Write-Host ("  File unique: {0} indexes" -f $fileIndexes.Count)
Write-Host ("  Missing from file: {0}" -f $missing.Count)

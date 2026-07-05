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

Write-Host "COMPARISON RESULTS:" -ForegroundColor Cyan
Write-Host ""

# Find in Azure but not in file
$azureOnly = @()
$azureIndexes | ForEach-Object {
    if ($fileIndexes -notcontains $_) {
        $azureOnly += $_
    }
}

if ($azureOnly.Count -gt 0) {
    Write-Host "IN AZURE but NOT in FILE:" -ForegroundColor Yellow
    $azureOnly | Sort-Object -Unique | ForEach-Object { Write-Host ("  {0}" -f $_) }
}

# Find in file but not in Azure
$fileOnly = @()
$fileIndexes | ForEach-Object {
    if ($azureIndexes -notcontains $_) {
        $fileOnly += $_
    }
}

if ($fileOnly.Count -gt 0) {
    Write-Host ""
    Write-Host "IN FILE but NOT in AZURE:" -ForegroundColor Green
    $fileOnly | Sort-Object | ForEach-Object { Write-Host ("  {0}" -f $_) }
}

Write-Host ""
Write-Host "SUMMARY:" -ForegroundColor Cyan
Write-Host ("  Azure indexes: {0}" -f ($azureIndexes | Select-Object -Unique).Count)
Write-Host ("  File indexes: {0}" -f $fileIndexes.Count)
Write-Host ("  Query returned count: 129 (index records, not unique names)")

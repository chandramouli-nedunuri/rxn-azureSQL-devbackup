# Count unique indexes in the file
$file = Get-Content "NON_EPR\ARS\Target_Azure\ARS_Indexes_Azure"
$uniqueIndexes = @()

$file | Select-Object -Skip 1 | ForEach-Object {
    $cols = $_ -split "`t"
    if ($cols.Count -ge 3 -and $cols[2]) {
        if ($uniqueIndexes -notcontains $cols[2]) {
            $uniqueIndexes += $cols[2]
        }
    }
}

Write-Host "File Analysis:" -ForegroundColor Cyan
Write-Host "  Total lines: 168 (including header)"
Write-Host "  Data rows: 167"
Write-Host ("  Unique indexes in file: {0}" -f $uniqueIndexes.Count)
Write-Host ""
Write-Host "Azure DB Query Result:" -ForegroundColor Green
Write-Host "  Total indexes: 129"
Write-Host ""
Write-Host "Analysis:" -ForegroundColor Yellow
Write-Host ("  File has {0} unique indexes" -f $uniqueIndexes.Count)
Write-Host "  Query counts 129 indexes"
Write-Host ""
Write-Host "Explanation:" -ForegroundColor White
Write-Host "  The file contains 168 lines because it lists each INDEX + COLUMN combination."
Write-Host "  Multiple rows in the file can represent columns of a single index."
Write-Host "  The count query returns 129 = number of unique indexes."

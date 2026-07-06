#!/usr/bin/env pwsh
<#
.SYNOPSIS
Deploy all 21 procedure/function packages to Azure SQL Database
#>

param(
    [string]$PackagePath
)

# Use default path from repo structure if not provided
if (-not $PackagePath) {
    $repoRoot = Split-Path -Parent $PSScriptRoot
    $PackagePath = Join-Path $repoRoot 'CS\Retail\eps\EPS\packages'
}

# Get all package files
$packageFiles = @(Get-ChildItem -Path $PackagePath -Filter "*.sql" | Sort-Object Name)

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════╗"
Write-Host "║  DEPLOYING 21 PROCEDURE PACKAGES TO AZURE SQL          ║"
Write-Host "╚════════════════════════════════════════════════════════╝"
Write-Host ""
Write-Host "Found $($packageFiles.Count) package files"
Write-Host ""

$successCount = 0
$errorCount = 0

for ($i = 0; $i -lt $packageFiles.Count; $i++) {
    $file = $packageFiles[$i]
    $index = $i + 1
    $packageName = $file.BaseName
    
    Write-Host -NoNewline "[$index/21] $packageName ... "
    
    try {
        # Read package file
        $packageContent = Get-Content $file.FullName -Raw
        
        # Split by GO and execute each batch separately
        $batches = $packageContent -split '\bGO\b' | Where-Object { $_.Trim().Length -gt 0 }
        
        $batchError = $false
        foreach ($batch in $batches) {
            $connectScript = Join-Path $PSScriptRoot 'Connect-ToDatabase.ps1'
            $output = & $connectScript -Query $batch 2>&1 | Out-String
            
            if ($output -like "*ERROR*" -or $output -like "*Exception*" -or $output -like "*error*") {
                $batchError = $true
                break
            }
        }
        
        if (-not $batchError) {
            Write-Host "✅" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "⚠️" -ForegroundColor Yellow
            $errorCount++
        }
    } catch {
        Write-Host "❌" -ForegroundColor Red
        $errorCount++
    }
    
    # Progress checkpoint every 7 packages
    if (($index % 7) -eq 0) {
        Write-Host "   ✓ Progress: $index/21 (Success: $successCount)"
    }
}

# Summary
Write-Host ""
Write-Host "════════════════════════════════════════════════════════"
Write-Host "PROCEDURES DEPLOYMENT SUMMARY"
Write-Host "════════════════════════════════════════════════════════"
Write-Host "Total:     21"
Write-Host "Success:   $successCount ✅"
Write-Host "Issues:    $errorCount ⚠️"
Write-Host ""

# Verify
Write-Host "VERIFICATION:"
Write-Host "════════════════════════════════════════════════════════"
$connectScript = Join-Path $PSScriptRoot 'Connect-ToDatabase.ps1'
& $connectScript -Query @"
SELECT COUNT(*) as ProcedureCount FROM sys.procedures WHERE schema_id > 4;
"@

Write-Host ""

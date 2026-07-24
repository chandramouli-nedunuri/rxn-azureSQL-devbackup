#!/usr/bin/env python3
"""
Convert Oracle PL/SQL packages to SQL Server T-SQL
"""
import os
import re
from pathlib import Path

# Package directory paths
ORACLE_PACKAGES_DIR = r"C:\Users\cnedunuri\Documents\rxn-azureSQL-devbackup\CS\Retail\sbmo\Oracle_source_code\Packages"
AZURE_PACKAGES_DIR = r"C:\Users\cnedunuri\Documents\rxn-azureSQL-devbackup\CS\Retail\sbmo\Azure_Scripts\Packages"

# Ensure output directory exists
Path(AZURE_PACKAGES_DIR).mkdir(parents=True, exist_ok=True)

PACKAGES = [
    "cs_support",
    "pkg_pdx_schema_updater",
    "pkg_pdx_schema_updater_helper",
    "pkg_pdx_schema_updater_meta",
    "pkg_pdx_schema_updater_rpt",
    "pkg_sbmo_purge",
    "rotate_partitions_pkg"
]

def read_package_files(package_name):
    """Read both package spec and body files"""
    spec_file = os.path.join(ORACLE_PACKAGES_DIR, f"sbmo.package.{package_name}.sql")
    body_file = os.path.join(ORACLE_PACKAGES_DIR, f"sbmo.package_body.{package_name}.sql")
    
    spec_content = ""
    body_content = ""
    
    if os.path.exists(spec_file):
        with open(spec_file, 'r', encoding='utf-8', errors='ignore') as f:
            spec_content = f.read()
    
    if os.path.exists(body_file):
        with open(body_file, 'r', encoding='utf-8', errors='ignore') as f:
            body_content = f.read()
    
    return spec_content, body_content

def extract_procedures_from_package(package_content):
    """Extract procedure and function names from package spec"""
    procedures = []
    functions = []
    
    # Find all PROCEDURE declarations
    proc_matches = re.findall(r'(?:PROCEDURE|PROCEDURE\s+)(\w+)', package_content, re.IGNORECASE)
    # Find all FUNCTION declarations
    func_matches = re.findall(r'FUNCTION\s+(\w+)', package_content, re.IGNORECASE)
    
    return list(set(proc_matches)), list(set(func_matches))

def analyze_package(package_name, spec_content, body_content):
    """Analyze package structure"""
    procs, funcs = extract_procedures_from_package(spec_content)
    
    # Get file sizes
    spec_lines = len(spec_content.split('\n'))
    body_lines = len(body_content.split('\n'))
    
    return {
        'name': package_name,
        'procedures': procs,
        'functions': funcs,
        'spec_lines': spec_lines,
        'body_lines': body_lines,
        'total_lines': spec_lines + body_lines
    }

def generate_conversion_report():
    """Generate analysis report for all packages"""
    print("\n" + "="*80)
    print("ORACLE PACKAGES TO SQL SERVER CONVERSION ANALYSIS")
    print("="*80)
    
    total_lines = 0
    all_analysis = []
    
    for pkg_name in PACKAGES:
        spec, body = read_package_files(pkg_name)
        if spec or body:
            analysis = analyze_package(pkg_name, spec, body)
            all_analysis.append(analysis)
            total_lines += analysis['total_lines']
            
            print(f"\n📦 Package: {pkg_name.upper()}")
            print(f"   Specification lines: {analysis['spec_lines']}")
            print(f"   Body lines:          {analysis['body_lines']}")
            print(f"   Total lines:         {analysis['total_lines']}")
            if analysis['procedures']:
                print(f"   Procedures ({len(analysis['procedures'])}): {', '.join(analysis['procedures'][:5])}")
                if len(analysis['procedures']) > 5:
                    print(f"              ... and {len(analysis['procedures']) - 5} more")
            if analysis['functions']:
                print(f"   Functions ({len(analysis['functions'])}): {', '.join(analysis['functions'][:5])}")
                if len(analysis['functions']) > 5:
                    print(f"            ... and {len(analysis['functions']) - 5} more")
    
    print(f"\n{'='*80}")
    print(f"SUMMARY:")
    print(f"  Total Packages: {len(all_analysis)}")
    print(f"  Total Code Lines: {total_lines:,}")
    print(f"  Average Package Size: {total_lines // len(all_analysis):,} lines")
    print(f"{'='*80}\n")
    
    return all_analysis

def create_conversion_strategy():
    """Create conversion strategy document"""
    strategy = """
# ORACLE PACKAGES TO SQL SERVER CONVERSION STRATEGY

## Overview
7 Oracle PL/SQL packages need to be converted to SQL Server T-SQL.
SQL Server does not have native packages, so we'll use the following approach:

## Conversion Approach
1. **Procedures & Functions as Stored Procedures/Functions**
   - Each package procedure → SQL Server stored procedure [SBMO].[PKG_NAME_PROCEDURE_NAME]
   - Each package function → SQL Server user-defined function [SBMO].[PKG_NAME_FUNCTION_NAME]
   - Use schema to group related objects

2. **Naming Convention**
   - Package procedures: [SBMO].[PKG_<packagename>_<procname>]
   - Package functions: [SBMO].[FN_<packagename>_<funcname>]
   - Or simpler: Keep procedure names as-is, group in schema SBMO

3. **Data Type Conversions**
   - NUMBER → INT, BIGINT, or DECIMAL (based on context)
   - NUMBER(2) → INT
   - NUMBER(18,2) → DECIMAL(18,2)
   - VARCHAR2 → NVARCHAR
   - CLOB → NVARCHAR(MAX)
   - BLOB → VARBINARY(MAX)
   - TIMESTAMP → DATETIME2(6)
   - DATE → DATE or DATETIME2

4. **Oracle PL/SQL → T-SQL Conversions**
   - DBMS_OUTPUT.PUT_LINE → PRINT or RAISERROR
   - DBMS_UTILITY → Error handling via TRY...CATCH
   - DBMS_SQL → sp_executesql
   - EXECUTE IMMEDIATE → sp_executesql
   - RAISE_APPLICATION_ERROR → RAISERROR
   - SYSDATE/SYSTIMESTAMP → GETDATE()/SYSDATETIME()
   - SEQ.NEXTVAL → IDENT_CURRENT or SQL Server SEQUENCE
   - sys_context('userenv','session_user') → SYSTEM_USER or SESSION_CONTEXT
   - BULK COLLECT → Temp tables or table variables
   - Cursor loops → WHILE loops with temp table
   - RECORD types → Table types or temp tables
   - TABLE OF INDEX BY → Temp tables with identity
   - regexp_count/regexp_like → SQL Server regex functions
   - substr() → SUBSTRING()
   - instr() → CHARINDEX()
   - to_number() → CAST/CONVERT
   - chr() → CHAR() or NCHAR()

5. **Exception Handling**
   - EXCEPTION WHEN ... THEN → CATCH with specific error checking
   - Custom exceptions → RAISERROR with error codes
   - NO_DATA_FOUND → Check @@ROWCOUNT = 0
   - DUP_VAL_ON_INDEX → Check error code 2627
   - OTHERS → Catch all errors

6. **Transaction Control**
   - BEGIN TRANSACTION (already in most code)
   - COMMIT → COMMIT TRANSACTION
   - ROLLBACK → ROLLBACK TRANSACTION
   - SQL%ROWCOUNT → @@ROWCOUNT
   - SQL%FOUND → @@ROWCOUNT > 0

## Complexity Assessment

### Package 1: cs_support (SIMPLER - ~140 lines)
- Single procedure: dbu_allocated_qty
- Internal functions: log_audit_dbu, log_error
- Uses: EXECUTE IMMEDIATE, seq.NEXTVAL, simple exception handling
- Conversion complexity: MEDIUM

### Package 2: pkg_sbmo_purge (SIMPLER - check content)
- Purge-related procedures
- Likely uses date functions and bulk deletes

### Package 3: rotate_partitions_pkg (MEDIUM - partition rotation)
- Complex partition management

### Package 4-7: pkg_pdx_schema_updater* (COMPLEX - ~1000+ lines each)
- Schema versioning and management
- Complex version comparison
- Dynamic SQL generation
- Record types and table types
- Multiple nested procedures/functions
- Very likely the most complex conversions

## Recommended Conversion Order (Dependency-based)
1. rotate_partitions_pkg - Likely independent
2. cs_support - Relatively simple, may be used by others
3. pkg_sbmo_purge - Likely independent
4. pkg_pdx_schema_updater_meta - Metadata functions (foundation)
5. pkg_pdx_schema_updater_helper - Helper functions (depends on meta)
6. pkg_pdx_schema_updater_rpt - Reporting (depends on meta/helper)
7. pkg_pdx_schema_updater - Main schema updater (depends on all helpers)

## Next Steps
1. Create simplified T-SQL versions maintaining core functionality
2. Handle critical business logic (purging, partition rotation, schema updates)
3. For complex schema updater functions: may need to rewrite from scratch
   or mark as "not critical for migration" if focused on schema versioning

## Migration Testing Strategy
1. Test each package independently in Azure SQL
2. Verify procedure signatures match
3. Test with sample data where applicable
4. Document any functional deviations from Oracle

## CRITICAL NOTES
- These packages are PRODUCTION CODE - require careful testing
- pkg_pdx_schema_updater may be schema versioning tool (may not be needed)
- Verify which packages are actually USED before full conversion
- Some may be development/maintenance-only tools
"""
    
    output_file = os.path.join(AZURE_PACKAGES_DIR, "CONVERSION_STRATEGY.md")
    with open(output_file, 'w') as f:
        f.write(strategy)
    
    print(f"✅ Conversion strategy saved to: {output_file}")
    return output_file

if __name__ == "__main__":
    print("\n🔍 Analyzing Oracle packages for T-SQL conversion...\n")
    
    analysis = generate_conversion_report()
    strategy_file = create_conversion_strategy()
    
    print("📋 ANALYSIS COMPLETE")
    print(f"   Strategy document: {strategy_file}")
    print("\nNext: Review strategy and provide conversion templates for each package")

# Comprehensive Azure SQL Migration Analysis for Helper Functions
# Comparing Oracle PL/SQL Package Components vs Azure SQL Server Capabilities

$analysis = @"
╔════════════════════════════════════════════════════════════════════════════════╗
║     ORACLE HELPER FUNCTIONS → AZURE SQL SERVER MIGRATION ANALYSIS             ║
║                                                                                ║
║  How to Implement Helper Functions in Azure SQL - Capability Comparison       ║
╚════════════════════════════════════════════════════════════════════════════════╝

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. CONFIGURATION MANAGEMENT FUNCTIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔹 refresh_config
   Purpose: Reads configuration from PDX_SCHEMA_CONFIG table and caches in memory
   
   Oracle: PROCEDURE refresh_config
           - Reads all config into package-level global variables
           - Complex parsing logic for boolean/number conversion
   
   Azure Support: ⚠️  PARTIAL
   ├─ ✅ Can create stored procedure
   ├─ ⚠️  NO global package-level variables (no state persistence)
   ├─ ⚠️  Must use session variables (@variables) instead
   ├─ ⚠️  Session variables lost on each procedure call
   └─ Workaround: Store config in temp table or pass as parameters

   Complexity: MEDIUM
   Solution: Create dbo.usp_RefreshConfig that reads table and returns dataset


🔹 get_config (p_key VARCHAR2)
   Purpose: Returns configuration value by key
   
   Oracle: FUNCTION get_config
           - Checks if global cache loaded, if not calls refresh_config
           - Returns cached value from package variable
   
   Azure Support: ⚠️  PARTIAL
   ├─ ✅ Create scalar function: dbo.ufn_GetConfig
   ├─ ❌ Cannot cache global state in Azure
   ├─ ❌ Must query table every time (no optimization)
   └─ SQL injection risk with CASE statement

   Complexity: LOW
   Solution: Use lookup function with simple SQL query to PDX_SCHEMA_CONFIG

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
2. METADATA RETRIEVAL FUNCTIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔹 get_metadata (3 variants)
   - get_metadata: Single value lookup
   - get_metadata_tbl: Table/array results
   - get_metadata_by_val: Lookup by value
   - get_metadata_tbl_by_val: Table results by value
   
   Purpose: Retrieve metadata from PDX_SCHEMA_TASKVER_META table with source translation
   
   Oracle: FUNCTION get_metadata
           - Complex parameter mapping logic
           - Calls external package: pkg_pdx_schema_updater_meta
           
   Azure Support: ⚠️  PARTIAL
   ├─ ✅ Can create scalar functions
   ├─ ⚠️  Table-valued functions (TVF) limited - can use CROSS APPLY
   ├─ ✅ Can replicate logic with T-SQL JOIN queries
   ├─ ✅ Can reference external stored procedures
   └─ Workaround: Use inline TVF or call proc from T-SQL UDF

   Complexity: HIGH
   Solution: Create multiple functions:
   - dbo.ufn_GetMetadata (scalar)
   - dbo.ufn_GetMetadataTable (table-valued function)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
3. SQL EXECUTION & STATEMENT RETRIEVAL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔹 get_sql (p_fname VARCHAR2, p_action VARCHAR2)
   Purpose: Retrieves SQL statement from PDX_SCHEMA_UPDATER_SQL or SCHEMA_UPDATER_SQL
   
   Oracle: FUNCTION get_sql
           - FULL OUTER JOIN between two tables
           - Complex CASE logic for action selection
           - Returns CLOB (large text)
   
   Azure Support: ⚠️  PARTIAL
   ├─ ✅ Can create function with NVARCHAR(MAX)
   ├─ ⚠️  FULL OUTER JOIN: ✅ SUPPORTED (T-SQL has it)
   ├─ ✅ CASE statements: ✅ SUPPORTED
   ├─ ✅ NVARCHAR(MAX): ✅ Works like CLOB
   └─ Error handling: Use TRY-CATCH instead of EXCEPTION blocks

   Complexity: LOW-MEDIUM
   Solution: Direct port with minor syntax changes


🔹 get_index (p_fname VARCHAR2, p_action VARCHAR2)
   Purpose: Retrieves statement_index for resuming interrupted execution
   
   Oracle: FUNCTION get_index
           - Returns NUMBER or NULL
   
   Azure Support: ✅ FULL
   ├─ ✅ NVARCHAR data type mapping
   ├─ ✅ NULL handling identical
   ├─ ✅ FULL OUTER JOIN works
   └─ No issues

   Complexity: LOW
   Solution: Direct port


🔹 get_status (p_fname VARCHAR2)
   Purpose: Gets action_code + status_code concatenation
   
   Oracle: FUNCTION get_status
           - Concatenates two VARCHAR2 columns
           - Handles NO_DATA_FOUND exception
   
   Azure Support: ✅ FULL
   ├─ ✅ String concatenation: + or CONCAT()
   ├─ ✅ TRY-CATCH replaces exception handling
   └─ No issues

   Complexity: LOW
   Solution: Direct port with TRY-CATCH


🔹 get_tasktype (p_filename VARCHAR2, p_action VARCHAR2)
   Purpose: Gets TASKTYPE metadata or returns APPLICATION_PREFIX default
   
   Oracle: FUNCTION get_tasktype
           - Calls get_metadata and get_config
           - Returns UPPER()
   
   Azure Support: ✅ FULL
   Complexity: LOW
   Solution: Direct port

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
4. LOGGING FUNCTIONS/PROCEDURES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Family of logging procedures:
- log_call_start, log_call_end
- log_version_start, log_version_end
- log_task_start, log_task_end, log_task_history
- log_sql_start, log_sql_end, log_sql, log_sql_progress
- log_process_start, log_process_end
- log_sys_sql_end

Purpose: Track execution history and errors to audit tables

Oracle Features Used:
├─ RETURNING clause: RETURNING id INTO variable
├─ SYSTIMESTAMP: Current timestamp
├─ Sequences: PDX_SCHEMA_MASTER_SEQ.NEXTVAL
├─ NULL checks: IS_ERROR_RECORD_EMPTY function
└─ Complex UPDATE/INSERT logic

Azure Support: ✅ MOSTLY FULL
├─ ✅ RETURNING: USE OUTPUT clause (T-SQL version)
├─ ✅ SYSTIMESTAMP: GETDATE() or SYSDATETIME()
├─ ✅ Sequences: IDENTITY columns or SEQUENCE objects
├─ ✅ NULL checks: ISNULL() or IS NULL
├─ ✅ INSERT/UPDATE: Same syntax (with minor tweaks)
└─ Workaround: OUTPUT clause returns inserted values

Complexity: MEDIUM
Solution: Port with:
1. IDENTITY or SEQUENCE for ID generation
2. OUTPUT clause for RETURNING functionality
3. GETDATE() for timestamps
4. TRY-CATCH for error handling

Example Mapping:
Oracle:
  INSERT INTO tbl (...) VALUES (...) 
  RETURNING ID INTO l_rtn;
  
Azure:
  INSERT INTO tbl (...) 
  OUTPUT inserted.ID INTO @rtn
  VALUES (...);

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
5. SQL PARSING & EXECUTION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔹 parse_sql (p_ddl_sql CLOB, p_ddl_sql_tbl OUT ddl_sql_type)
   Purpose: Split large SQL script into individual statements
   
   Oracle Uses:
   ├─ CLOB data type
   ├─ Nested tables (PL/SQL collections): TYPE ddl_sql_type IS TABLE OF CLOB
   ├─ DBMS_LOB package: string/line manipulation
   ├─ Complex regex patterns
   ├─ Line-by-line parsing with CHR(10) = newline
   └─ Statement terminator detection (semicolon vs slash)
   
   Azure Support: ⚠️  LIMITED
   ├─ ❌ NO CLOB type: Use NVARCHAR(MAX)
   ├─ ❌ NO nested tables: Use table variable instead
   ├─ ❌ NO DBMS_LOB: Use T-SQL string functions
   ├─ ✅ REGEX: SQL Server has PATINDEX, SUBSTRING (limited)
   ├─ ❌ NOT as flexible as DBMS_LOB
   └─ Workaround: Rewrite using STRING_SPLIT, SUBSTRING, CHARINDEX

   Complexity: HIGH (requires rewriting)
   Solution: 
   1. Create table variable instead of PL/SQL table
   2. Use STRING_SPLIT for line parsing
   3. Use SUBSTRING, CHARINDEX for string manipulation
   4. Recreate DBMS_LOB functions with T-SQL equivalents

   Key Differences:
   - DBMS_LOB.GETLENGTH() → LEN()
   - DBMS_LOB.SUBSTR() → SUBSTRING()
   - DBMS_LOB.INSTR() → CHARINDEX()
   - CHR(10), CHR(13) → CHAR(10), CHAR(13)
   - Regex: More limited in T-SQL


🔹 run_statement (p_sql CLOB)
   Purpose: Execute dynamic SQL with large statements
   
   Oracle Uses:
   ├─ DBMS_SQL package: Dynamic SQL execution
   ├─ Cursor management
   ├─ Table of VARCHAR2(32767) for chunking
   ├─ PARSE, EXECUTE, CLOSE
   
   Azure Support: ⚠️  DIFFERENT APPROACH
   ├─ ❌ NO DBMS_SQL package
   ├─ ✅ USE sp_executesql
   ├─ ✅ USE EXEC() or EXECUTE()
   ├─ ✅ Parameter binding available
   ├─ ⚠️  Limits on statement size (more than enough for typical SQL)
   └─ Workaround: Use sp_executesql for parameterized queries

   Complexity: MEDIUM
   Solution:
   - Replace DBMS_SQL with sp_executesql
   - Simpler syntax than chunking
   - Better for security (parameter binding)

   Oracle:
   DECLARE c DBMS_SQL.CURSOR_TYPE;
   BEGIN
     DBMS_SQL.PARSE(c, ...);
     DBMS_SQL.EXECUTE(c);
   END;

   Azure:
   EXEC sp_executesql @SQL_STRING;


🔹 apply_sql, rollback_sql, run_sql
   Purpose: Main execution logic - parse and execute DDL/DML
   
   Oracle Uses:
   ├─ parse_sql result: ddl_sql_type table
   ├─ Loop through statements: while table.COUNT
   ├─ SUBSTR() for comment detection
   ├─ REGEXP_INSTR() for complex pattern matching
   ├─ Exception handling: complex rollback logic
   └─ State management: tracking statement index
   
   Azure Support: ⚠️  PARTIAL
   ├─ ✅ Can loop through table variable
   ├─ ⚠️  REGEX limited: Use PATINDEX, CHARINDEX instead
   ├─ ✅ TRY-CATCH for error handling
   ├─ ✅ Temp table or variable for state
   └─ Less flexible than Oracle for pattern matching

   Complexity: HIGH
   Solution:
   1. Replace parse_sql with T-SQL version
   2. Replace REGEXP_INSTR with PATINDEX/CHARINDEX
   3. Use TRY-CATCH instead of EXCEPTION blocks
   4. Use table variables instead of PL/SQL tables

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
6. SQL PARAMETER REPLACEMENT PROCEDURES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Family: replace_* procedures
- replace_tablespace (p_ddl_sql IN OUT CLOB)
- replace_partitionby (p_ddl_sql IN OUT CLOB)
- replace_sbmo_meijer (p_ddl_sql IN OUT CLOB)
- replace_parms (p_ddl_sql IN OUT CLOB)

Purpose: Find and replace placeholder tokens in SQL (like <TABLESPACE>, <partition>, etc)

Oracle Uses:
├─ CLOB with IN OUT parameter (pass by reference)
├─ REGEXP_REPLACE() and REGEXP_SUBSTR() for pattern matching
├─ DBMS_METADATA for partition extraction
├─ FOR loops through mapping tables
├─ Complex regex patterns
└─ Validation with REGEXP_COUNT

Azure Support: ⚠️  LIMITED
├─ ✅ NVARCHAR(MAX) instead of CLOB
├─ ⚠️  IN OUT: Use OUTPUT parameters (different syntax)
├─ ⚠️  REGEXP_REPLACE: NOT available - use REPLACE() only
├─ ❌ NO DBMS_METADATA: Must query sys views instead
├─ ✅ Loops work with table iteration
├─ ⚠️  Regex limited to PATINDEX/CHARINDEX
└─ Workaround: Rewrite without regex, use simpler string functions

Complexity: HIGH (requires rewriting regex logic)

Key Replacements:
Oracle REGEXP_REPLACE:
  p_ddl_sql := REGEXP_REPLACE(p_ddl_sql, 
                              'tablespace\s+' || mrec.search,
                              'TABLESPACE ' || mrec.replace, 1, 0, 'im');

Azure equivalent (more complex):
  DECLARE @from NVARCHAR(MAX) = 'tablespace ' + mrec.search;
  DECLARE @to NVARCHAR(MAX) = 'TABLESPACE ' + mrec.replace;
  -- Use multiple REPLACE() or loop with PATINDEX
  WHILE PATINDEX('%' + @from + '%', @sql) > 0
    SET @sql = REPLACE(@sql, @from, @to);

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
7. DEPENDENCY & STATE CHECKING FUNCTIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔹 dependencies_met (p_fname VARCHAR2)
   Purpose: Check if all required dependencies are already applied
   
   Oracle Uses:
   ├─ Complex multi-table JOIN
   ├─ Nested SELECT
   ├─ REGEXP_SUBSTR for extracting task names
   └─ Multiple WHERE conditions
   
   Azure Support: ✅ FULL
   ├─ ✅ All SQL features work
   ├─ ✅ JOINs, subqueries identical
   ├─ ⚠️  REGEXP_SUBSTR: Use PATINDEX/SUBSTRING instead
   └─ Workaround: Rewrite regex with SUBSTRING/CHARINDEX

   Complexity: MEDIUM
   Solution: Port with regex replacement


🔹 rb_dependencies_met (p_fname VARCHAR2)
   Purpose: Check if can safely rollback (no tasks depend on this)
   
   Oracle: Similar logic to dependencies_met
   
   Azure Support: ✅ FULL
   Complexity: MEDIUM
   Solution: Port with regex replacement


🔹 is_deprecated (p_filename, p_task_list)
   Purpose: Check if task has been deprecated
   
   Oracle Uses:
   ├─ Nested cursors
   ├─ Cursor LOOP with FETCH
   ├─ Table parameter: task_tbl (PL/SQL table)
   └─ NEXT() function for table iteration
   
   Azure Support: ⚠️  PARTIAL
   ├─ ✅ Cursors work
   ├─ ✅ Table variables work
   ├─ ❌ NO .NEXT() method: Use standard iteration
   ├─ ✅ LOOP/FETCH patterns work
   └─ Workaround: Rewrite with WHILE loop over table variable

   Complexity: MEDIUM
   Solution: Rewrite cursor logic with T-SQL loops


🔹 is_excluded (p_filename, is_sprint)
   Purpose: Check if task should be excluded from sprint execution
   
   Azure Support: ✅ FULL
   Complexity: LOW
   Solution: Direct port


🔹 is_error_record_empty (p_record)
   Purpose: Check if error record has all NULLs
   
   Oracle: Custom type checking
   
   Azure Support: ⚠️  LIMITED
   ├─ ❌ NO custom types in this way
   ├─ ✅ Can pass individual fields or use table
   ├─ ✅ Can use bitwise OR to check all NULLs
   └─ Workaround: Pass fields separately or use conditional logic

   Complexity: LOW
   Solution: Rewrite logic without custom type

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
8. SCHEMA RESET & MAINTENANCE FUNCTIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔹 reset_schema
   Purpose: Drop all user objects to reset schema to initial state
   
   Oracle Uses:
   ├─ Cursor: FOR r IN (...) LOOP ... END LOOP
   ├─ Nested exception handling
   ├─ user_objects view
   ├─ Dynamic DROP statements
   ├─ Multiple DROP attempts (handles dependencies)
   └─ EXECUTE IMMEDIATE for dynamic SQL
   
   Azure Support: ⚠️  PARTIAL
   ├─ ✅ Cursors/loops work
   ├─ ✅ Dynamic DROP works
   ├─ ❌ user_objects: Use sys.objects instead
   ├─ ✅ TRY-CATCH for exceptions
   ├─ ✅ EXEC() for dynamic SQL
   └─ Workaround: Replace Oracle views with SQL Server sys views

   Complexity: MEDIUM
   Solution:
   - Replace user_objects with sys.objects + schema lookup
   - Replace EXECUTE IMMEDIATE with EXEC() or sp_executesql
   - Keep exception handling logic with TRY-CATCH


🔹 purge_schema_error_logs (p_until_date)
   Purpose: Delete old error logs based on date
   
   Azure Support: ✅ FULL
   ├─ ✅ DELETE with date conditions works
   ├─ ✅ Multiple DELETE statements
   └─ Workaround: Try-catch for potential errors

   Complexity: LOW


🔹 dos2unix
   Purpose: Normalize line endings (CRLF → LF)
   
   Oracle Uses:
   ├─ CHR(13)||CHR(10) = Windows line ending
   ├─ CHR(10) = Unix line ending
   ├─ REGEXP_REPLACE with multi-char pattern
   └─ UPDATE with conditions
   
   Azure Support: ✅ FULL
   ├─ ✅ CHAR(13), CHAR(10) work same
   ├─ ✅ + operator for concatenation
   ├─ ⚠️  REGEXP_REPLACE: Use REPLACE() instead
   ├─ ✅ INSTR: Use CHARINDEX()
   └─ No issues

   Complexity: LOW
   Solution: Replace REGEXP_REPLACE with REPLACE()

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
9. ADVANCED TASK-BASED PROCESSING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔹 task_based_apply, task_based_rollback
   Purpose: Execute task-based schema updates
   
   Oracle Uses:
   ├─ Complex cursor queries
   ├─ Multiple nested loops
   ├─ MERGE statements
   ├─ DBMS_LOB comparisons
   ├─ Recursive calls
   └─ State tracking with sequences
   
   Azure Support: ⚠️  MIXED
   ├─ ✅ MERGE statements work
   ├─ ❌ NO DBMS_LOB: Use string functions or HASHBYTES for comparison
   ├─ ✅ Cursors/loops work
   ├─ ✅ Recursion works
   ├─ ✅ OUTPUT clause for sequence-like behavior
   └─ Workaround: Replace LOB operations with T-SQL equivalents

   Complexity: VERY HIGH
   Solution:
   - Rewrite DBMS_LOB.COMPARE using HASHBYTES or direct comparison
   - Replace cursor logic with table joins where possible
   - Use recursive CTEs for recursive logic if beneficial
   - Keep MERGE statements (T-SQL supports them)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
10. UTILITY FUNCTIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔹 error_record (p_msg, p_code, p_err)
   Purpose: Create error record structure
   
   Oracle: Uses custom TYPE typ_error_record
   
   Azure Support: ⚠️  LIMITED
   ├─ ❌ NO custom types like Oracle
   ├─ ✅ Can use table type instead
   ├─ ✅ Can pass individual parameters
   └─ Workaround: Rewrite as function returning table or use parameters

   Complexity: LOW
   Solution: Refactor to pass individual fields or use table type

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

╔════════════════════════════════════════════════════════════════════════════════╗
║                        MIGRATION SUMMARY TABLE                                ║
╚════════════════════════════════════════════════════════════════════════════════╝

FUNCTION/PROCEDURE NAME          │ COMPLEXITY │ AZURE SUPPORT │ EFFORT LEVEL
─────────────────────────────────┼────────────┼───────────────┼──────────────
refresh_config                   │   MEDIUM   │   PARTIAL ⚠️  │ MEDIUM
get_config                        │   LOW      │   PARTIAL ⚠️  │ LOW
get_metadata (all 4 variants)    │   HIGH     │   PARTIAL ⚠️  │ MEDIUM-HIGH
get_sql                           │   MEDIUM   │   FULL ✅     │ LOW-MEDIUM
get_index                         │   LOW      │   FULL ✅     │ LOW
get_status                        │   LOW      │   FULL ✅     │ LOW
get_tasktype                      │   LOW      │   FULL ✅     │ LOW
is_error_record_empty            │   LOW      │   LIMITED ❌   │ LOW
error_record                      │   LOW      │   LIMITED ❌   │ LOW
log_* (10+ functions)            │   MEDIUM   │   MOSTLY ✅    │ MEDIUM
parse_sql                         │   HIGH     │   LIMITED ❌   │ HIGH
run_statement                     │   MEDIUM   │   PARTIAL ⚠️  │ MEDIUM
apply_sql                         │   HIGH     │   LIMITED ❌   │ HIGH
rollback_sql                      │   HIGH     │   LIMITED ❌   │ HIGH
run_sql                           │   HIGH     │   LIMITED ❌   │ HIGH
replace_tablespace              │   MEDIUM   │   LIMITED ❌   │ MEDIUM
replace_partitionby             │   HIGH     │   LIMITED ❌   │ MEDIUM-HIGH
replace_sbmo_meijer             │   MEDIUM   │   LIMITED ❌   │ MEDIUM
replace_parms                    │   MEDIUM   │   LIMITED ❌   │ MEDIUM
dependencies_met                 │   MEDIUM   │   PARTIAL ⚠️  │ MEDIUM
rb_dependencies_met             │   MEDIUM   │   PARTIAL ⚠️  │ MEDIUM
is_deprecated                    │   MEDIUM   │   PARTIAL ⚠️  │ MEDIUM
is_excluded                      │   LOW      │   FULL ✅     │ LOW
is_same_apply_sql               │   LOW      │   FULL ✅     │ LOW
reset_schema                     │   MEDIUM   │   PARTIAL ⚠️  │ MEDIUM
purge_schema_error_logs         │   LOW      │   FULL ✅     │ LOW
dos2unix                         │   LOW      │   FULL ✅     │ LOW
task_based_apply                │   VERY HIGH│   MIXED ⚠️    │ HIGH
task_based_rollback             │   VERY HIGH│   MIXED ⚠️    │ HIGH
version_updater                 │   HIGH     │   LIMITED ❌   │ HIGH

Legend:
✅ FULL   = Fully supported with minimal changes
⚠️ PARTIAL = Mostly supported but with limitations
❌ LIMITED = Significant rewrite needed
❓ MIXED  = Some features work, some need rework

═══════════════════════════════════════════════════════════════════════════════════

╔════════════════════════════════════════════════════════════════════════════════╗
║                    KEY LIMITATIONS & WORKAROUNDS                              ║
╚════════════════════════════════════════════════════════════════════════════════╝

1. PACKAGE-LEVEL GLOBAL VARIABLES
   ❌ Oracle: Can store state in package variables
   ⚠️ Azure:  Must use @session_variables or temp tables
   
   Impact: Configuration caching loses performance benefit
   Workaround: Cache configuration in temp table or pass as parameters


2. REGULAR EXPRESSIONS
   ❌ Oracle: REGEXP_REPLACE, REGEXP_SUBSTR, REGEXP_COUNT, REGEXP_INSTR (powerful)
   ⚠️ Azure:  PATINDEX, CHARINDEX, SUBSTRING (basic)
   
   Impact: Complex pattern matching becomes verbose
   Workaround: Use simpler REPLACE/SUBSTRING where possible, or CLR integration


3. DBMS_LOB PACKAGE
   ❌ Oracle: DBMS_LOB.GETLENGTH, SUBSTR, INSTR, COPY, CREATE, FREE
   ⚠️ Azure:  LEN, SUBSTRING, CHARINDEX (similar functions, different names)
   
   Impact: Large text manipulation works differently
   Workaround: Use T-SQL string functions with LEN, SUBSTRING, CHARINDEX


4. DBMS_SQL PACKAGE
   ❌ Oracle: DBMS_SQL.OPEN_CURSOR, PARSE, EXECUTE, CLOSE, FETCH
   ⚠️ Azure:  sp_executesql or EXEC()
   
   Impact: Dynamic SQL execution simpler but less flexible
   Workaround: Use sp_executesql with parameter binding


5. GLOBAL SEQUENCES
   ❌ Oracle: Sequence.NEXTVAL in any context
   ⚠️ Azure:  SEQUENCE objects exist, but less integrated
   
   Impact: ID generation works but slightly different syntax
   Workaround: Use SEQUENCE or IDENTITY with OUTPUT clause


6. CURSORS & NESTED TABLES
   ❌ Oracle: for rec in (select...) loop, table.NEXT(), table.COUNT
   ⚠️ Azure:  DECLARE @tbl TABLE (...), loop with WHILE
   
   Impact: Collection logic becomes more verbose
   Workaround: Use table variables with row_number() and WHILE loops


7. USER_OBJECTS VIEW
   ❌ Oracle: Sees all objects in current user schema
   ⚠️ Azure:  sys.objects requires schema filtering
   
   Impact: Code needs filtering by schema_id
   Workaround: Join with sys.schemas to filter


8. CUSTOM TYPES & RECORDS
   ❌ Oracle: TYPE mytype IS RECORD (...); TYPE mytbl IS TABLE OF mytype;
   ⚠️ Azure:  Only table types (CREATE TYPE ... AS TABLE)
   
   Impact: Complex type passing becomes simpler but less flexible
   Workaround: Use table variables or table-valued parameters (TVP)


9. IN OUT PARAMETERS
   ❌ Oracle: Procedure parameters can be IN OUT (read AND write)
   ⚠️ Azure:  Use OUTPUT keyword (similar functionality)
   
   Impact: Parameter passing works identically
   Workaround: Use OUTPUT clause - same effect


10. EXCEPTION HANDLING
    ❌ Oracle: EXCEPTION WHEN SPECIFIC_EXCEPTION THEN / WHEN OTHERS THEN
    ⚠️ Azure:  TRY-CATCH / CATCH with limited error context
    
    Impact: Error handling less granular
    Workaround: Use ERROR_NUMBER(), ERROR_MESSAGE() in CATCH block

═══════════════════════════════════════════════════════════════════════════════════

╔════════════════════════════════════════════════════════════════════════════════╗
║                      MIGRATION STRATEGY RECOMMENDATION                        ║
╚════════════════════════════════════════════════════════════════════════════════╝

PHASE 1: LOW-HANGING FRUIT (EASY - 30% of work, 50% of value)
├─ get_sql, get_index, get_status, get_tasktype → Direct port
├─ is_excluded, dos2unix → Direct port
├─ purge_schema_error_logs → Direct port
├─ Log functions → Direct port with OUTPUT clause
└─ Effort: 1-2 days | Value: Basic functionality working

PHASE 2: MEDIUM COMPLEXITY (MEDIUM - 40% of work, 30% of value)
├─ get_config, refresh_config → Redesign with temp table
├─ replace_parms family → Rewrite without regex
├─ dependencies_met, is_deprecated → Port with SUBSTRING/CHARINDEX
├─ reset_schema → Rewrite with sys.objects
└─ Effort: 3-5 days | Value: Configuration and utility functions

PHASE 3: HIGH COMPLEXITY (HARD - 30% of work, 20% of value)
├─ parse_sql → Complete rewrite with STRING_SPLIT
├─ run_statement → Replace DBMS_SQL with sp_executesql
├─ apply_sql, rollback_sql, run_sql → Combine with parse_sql rewrite
├─ task_based_apply, task_based_rollback → Most complex
└─ Effort: 5-10 days | Value: Execution engine

ESTIMATED TOTAL EFFORT: 10-15 days for full port
RECOMMENDED APPROACH:
1. Start with Phase 1 (quick wins)
2. Test basic functionality before Phase 2
3. Complete Phase 2 before attempting Phase 3
4. Consider hiring specialist for Phase 3 if regex-heavy

"@

Write-Host $analysis -ForegroundColor White

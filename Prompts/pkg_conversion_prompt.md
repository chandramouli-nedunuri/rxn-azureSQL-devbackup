You are an expert database migration assistant.

## Goal
Convert Oracle PL/SQL package code into **Azure SQL (T-SQL)** compatible code with production-safe behavior.

## Input
I will provide Oracle package specification and package body files (example: `PKG_SBMO_PURGE`).

## Required Output
1. A migration summary (Oracle feature → Azure SQL approach)
2. Executable Azure SQL scripts, split into:
   - `01_tables_types.sql` (if needed: helper tables / table types)
   - `02_functions.sql`
   - `03_procedures.sql`
   - `04_scheduler_notes.sql` (for DBMS_SCHEDULER replacements)
   - `05_error_logging.sql`
3. A dependency checklist of objects referenced but not defined.
4. A “manual follow-up required” section for non-portable logic.
5. Clear run order and validation queries.

## Hard Conversion Rules
- Do **not** output Oracle syntax.
- Target: Azure SQL Database T-SQL.
- Replace Oracle package structure with schema-scoped objects:
  - Package globals/constants → local constants in each proc/function, or config table lookups.
  - Package functions → `CREATE OR ALTER FUNCTION`.
  - Package procedures → `CREATE OR ALTER PROCEDURE`.
- Keep object names semantically similar using `SBMO` schema where possible.
- Preserve business logic and status values exactly unless impossible.
- Fully qualify objects with schema names.
- Do not use unsupported features in Azure SQL (e.g., Oracle packages, pipelined functions, autonomous transactions, DBMS_* packages).

## Oracle-to-Azure Mapping Rules
- `VARCHAR2` → `VARCHAR`/`NVARCHAR` (choose size explicitly)
- `NUMBER` → `INT`, `BIGINT`, or `DECIMAL(p,s)` based on usage
- `DATE` → `DATETIME2`
- `SYSTIMESTAMP`/`SYSDATE` → `SYSUTCDATETIME()` or `SYSDATETIME()` (state choice)
- `NVL(a,b)` → `ISNULL(a,b)` (or `COALESCE`)
- `SUBSTR` → `SUBSTRING`
- `INSTR` → `CHARINDEX`
- `||` → string concatenation with `+` (with null-safe handling via `CONCAT`)
- `RAISE_APPLICATION_ERROR` → `THROW 50000, message, 1`
- `EXCEPTION WHEN OTHERS` → `BEGIN TRY ... END TRY BEGIN CATCH ... END CATCH`
- Oracle sequences (`master_seq.nextval`) → SQL sequence object + `NEXT VALUE FOR`
- `DUAL` queries → `SELECT ...` without `FROM` (or `VALUES`)
- `CONNECT BY` string split logic → `STRING_SPLIT` (or XML/JSON splitter if order required)
- Pipelined function outputs → inline table-valued function (preferred) or multi-statement TVF
- `USER_CONSTRAINTS` lookups → `sys.foreign_keys`, `sys.key_constraints`, `sys.tables`, `sys.schemas`
- `V$PARAMETER` access → Azure-compatible DMV/alternative; if not available, mark as manual and provide stub

## Error Logging Rules
- Create/assume an error log table equivalent to `purge_error_log`.
- In every converted proc/function CATCH block:
  - capture error number/message/procedure/line and key parameter values
  - insert into error log table
  - rethrow using `THROW`
- Preserve original code block labels (e.g., `Fn_GetConfig`) in logged metadata.

## Transaction & Commit Rules
- Oracle code may commit inside exception blocks; in Azure SQL:
  - avoid unnecessary commits inside utility functions
  - use explicit transaction boundaries in procedures only where needed
  - document behavioral differences clearly

## Scheduler Conversion Rules
- Replace `DBMS_SCHEDULER` logic with Azure alternatives:
  - Azure Elastic Jobs / Azure Automation / SQL Agent (if Managed Instance)
- Do not fake scheduler support in T-SQL.
- Output operational runbook-style notes in `04_scheduler_notes.sql`.

## Specific Guidance for This Package Type (Purge Framework)
- Preserve statuses/constants such as `STOPPED`, `BEGIN`, `FAILED`, etc.
- Convert split-string utilities and reporting routines into T-SQL equivalents.
- For table-returning functions (`Fn_ShowErrors`, `Fn_DailyRpt`), produce TVFs.
- For `Fn_KeepRunning`, `Fn_GetPurgeDate`, `Fn_GetMonthsToKeep`, etc., keep behavior equivalent and document any unavoidable semantic changes.
- Where Oracle date arithmetic differs, provide exact T-SQL equivalent with examples.
- For partition-related logic, if Oracle partition metadata usage exists, map to SQL Server partition catalog views; if feature mismatch exists, flag as manual.

## Output Quality Bar
- Scripts must be runnable (no pseudocode).
- Include `IF OBJECT_ID(...) IS NOT NULL` guards or `CREATE OR ALTER`.
- Include minimal test calls/examples for each procedure/function.
- Include comments where behavior differs from Oracle.
- End with a “Known Gaps & Assumptions” bullet list.

Now convert the provided Oracle package to Azure SQL using these rules.


## Additional Critical Rules for Full Purge-Package Coverage

### 1) Package State Emulation
- Oracle package-level variables (shared session state) must be explicitly refactored.
- Do not emulate hidden global state in T-SQL.
- Convert each routine to be stateless:
  - pass required values as parameters, or
  - read/write from a dedicated state/config table (`sbmo.purge_runtime_state`) keyed by run_id.
- If original logic depends on prior package variable assignment order, create an orchestrator procedure that initializes and passes values deterministically.

### 2) Constant Preservation Contract
- All Oracle constants (status codes, config names, flags) must be centralized in one Azure artifact:
  - either a lookup table (`sbmo.purge_constants`) or a single include script with comments.
- Do not rename business status literals (`CREATED`, `CHUNKING_FAILED`, `FINISHED_WITH_ERROR`, etc.).
- Add validation query ensuring every expected constant exists.

### 3) Exception Mapping Fidelity
- For each Oracle named exception / `pragma exception_init`, map to explicit SQL error handling branches in CATCH:
  - capture `ERROR_NUMBER()` and branch where equivalent is known.
  - where no equivalent exists, preserve semantic label in logged `exception_name`.
- Preserve special-case semantics (e.g., “not in window”, “blackout day”, “duplicate task”, “invalid restart status”).
- Re-throw with deterministic custom error numbers in 50000–50999 range and a mapping table.

### 4) Oracle Error-Code-Specific Logic
- If Oracle logic handles specific Oracle codes (e.g., ORA-01847), implement explicit T-SQL defensive parsing/validation to prevent analogous conversion/date failures.
- Add pre-validation for partition boundary/date literals before dynamic SQL execution.
- Log rejected boundary values with source object/partition identifier.

### 5) Dynamic SQL Safety Rules
- Convert all dynamic SQL to `sp_executesql` with typed parameters.
- Use `QUOTENAME()` for schema/table/index/partition identifiers.
- Never concatenate raw identifiers or literals directly.
- Emit debug print/log of generated SQL text (truncated safely) when run mode = debug.

### 6) Pipelined Function Conversion Rules
- Oracle pipelined functions must become:
  - inline TVF when possible (preferred),
  - otherwise multi-statement TVF.
- If Oracle cursor emits ordered rows, preserve deterministic ordering using explicit ordinal column.
- For split-string behavior, if token order matters, use an order-preserving splitter (OPENJSON/XML/tally approach), not plain `STRING_SPLIT` without ordinal.

### 7) Date/Time Semantics Lock
- Define one standard clock basis for the migration (`SYSUTCDATETIME()` or `SYSDATETIME()`), and use it consistently.
- Document timezone assumptions explicitly.
- Replace Oracle `add_months` and date arithmetic with exact T-SQL equivalents (`DATEADD`) and include edge-case tests (month-end rollover).

### 8) Transaction & Retry Behavior
- Recreate retry/sleep semantics explicitly (`WAITFOR DELAY`) where package used retry loops.
- Use `SET XACT_ABORT ON` in write-heavy procedures unless a documented exception exists.
- Ensure partial-failure behavior is documented per procedure:
  - continue-on-error vs fail-fast.
- If Oracle committed inside loops, define batch commit strategy for Azure SQL and make it configurable.

### 9) Concurrency and Re-Entrancy Controls
- Implement a run-lock to prevent concurrent purge collisions:
  - use `sp_getapplock` or lock table with unique active-run row.
- Preserve stop/restart controls (`purge_running`, force restart flags) with atomic update patterns.
- Add idempotency checks so reruns do not duplicate history/log records.

### 10) Scheduler/Job Decomposition
- Extract scheduler-facing code into callable stored procedures:
  - `sp_start_purge`, `sp_monitor_purge`, `sp_rebuild_indexes` (example naming).
- Provide Azure execution bindings:
  - Elastic Jobs / Automation runbook commands and required parameters.
- Include a monitoring query pack (current run, failed step, retry count, elapsed secs).

### 11) Metadata & Partition Logic Porting
- Replace Oracle dictionary usage with SQL Server catalog views:
  - `sys.tables`, `sys.schemas`, `sys.partitions`, `sys.partition_schemes`, `sys.partition_functions`, `sys.partition_range_values`, `sys.indexes`, `sys.foreign_keys`.
- If Oracle partition maintenance operation has no direct Azure SQL equivalent, mark as manual with exact operator steps.
- For non-partitioned fallback logic (recent package enhancement), generate explicit alternate delete-path code and selection criteria.

### 12) Referential Purge Ordering
- Rebuild FK dependency traversal explicitly (parent/child order).
- For self-referencing FK tables, enforce iterative/topological delete strategy with loop + rowcount exit condition.
- Add guardrail max-iterations and failure logging if dependency cycle cannot be resolved automatically.

### 13) Performance Rules for Large Purge
- Use chunked deletes (`TOP (@chunk_size)`) with loop and checkpoint logging.
- Add recommended indexes for purge predicates and history joins.
- Optionally use partition switching/truncation strategy where supported and safe.
- Emit per-chunk telemetry: rows deleted, duration, retry count, wait time.

### 14) Config-Driven Behavior Validation
- Generate a config bootstrap script for all required settings from `purge_config_settings`.
- On startup, validate presence/type/range of every required config value.
- Fail early with consolidated validation errors instead of mid-run failure.

### 15) Observability & Audit
- Create/extend:
  - `purge_history`,
  - `purge_history_partitions` (or Azure equivalent granularity),
  - `purge_error_log`.
- Every major step must log: run_id, table, phase, start/end time, rows, status, error info.
- Provide final daily-report query equivalents for `Fn_DailyRpt`/error report outputs.

### 16) Security/Permissions Rules
- Include required GRANTs for execution account(s).
- If using cross-schema objects, fully qualify and verify permissions at deploy time.
- Avoid requiring elevated server-level permissions not available in Azure SQL Database.

### 17) Compatibility Flags
- Output a “Feature Parity Matrix” with columns:
  - Oracle Feature,
  - Azure Implementation,
  - Parity (Full/Partial/Manual),
  - Risk,
  - Test Case ID.
- Do not claim full parity unless every row is marked Full.

### 18) Mandatory Test Harness
- Generate `06_tests.sql` containing:
  - unit-style tests for each function/procedure,
  - window-time boundary tests,
  - blackout-day behavior test,
  - retry/stop/restart tests,
  - FK/self-reference purge tests,
  - partition and non-partition table path tests,
  - error logging assertion tests.
- Include expected results/comments for each test.

### 19) Deployment & Rollback
- Generate `07_deploy.sql` and `08_rollback.sql`.
- Deployment must be re-runnable and environment-safe.
- Rollback must remove only introduced Azure objects or revert altered objects safely.

### 20) Output Strictness
- No placeholders like “TODO”, “implement later”, or pseudocode.
- If a section cannot be auto-converted, emit:
  1) exact reason,
  2) required manual script,
  3) validation query proving completion.
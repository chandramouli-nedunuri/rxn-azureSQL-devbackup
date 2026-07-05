# Oracle Package Helper Functions → Azure SQL Server Migration Guide

## Quick Summary

| Helper Function Group | Complexity | Azure Support | Effort | Status |
|---|---|---|---|---|
| **Configuration** (refresh_config, get_config) | MEDIUM | PARTIAL ⚠️ | MEDIUM | Redesign needed |
| **Metadata Retrieval** (get_metadata*) | HIGH | PARTIAL ⚠️ | MEDIUM-HIGH | Port with changes |
| **SQL Retrieval** (get_sql, get_index, get_status) | MEDIUM | FULL ✅ | LOW-MEDIUM | Direct port |
| **Logging Functions** (log_*) | MEDIUM | MOSTLY ✅ | MEDIUM | Minor syntax changes |
| **SQL Parsing** (parse_sql) | HIGH | LIMITED ❌ | HIGH | Complete rewrite |
| **SQL Execution** (run_statement, apply_sql, rollback_sql) | HIGH | LIMITED ❌ | HIGH | Major rewrite |
| **Parameter Replacement** (replace_*) | MEDIUM | LIMITED ❌ | MEDIUM | Regex rewrite |
| **Dependency Checking** (dependencies_met, is_deprecated) | MEDIUM | PARTIAL ⚠️ | MEDIUM | Regex rewrite |
| **Maintenance** (reset_schema, purge_logs, dos2unix) | MEDIUM | MOSTLY ✅ | MEDIUM | Minor changes |

---

## 10 Key Limitations in Azure SQL Server

### 1. **NO PACKAGE-LEVEL GLOBAL VARIABLES** ❌
- **Oracle**: Store state in package variables (persistent across calls)
- **Azure**: Session variables (@var) lost between calls
- **Impact**: Config caching loses performance benefit
- **Workaround**: Use temp tables or pass as parameters

### 2. **LIMITED REGULAR EXPRESSIONS** ⚠️
- **Oracle**: REGEXP_REPLACE, REGEXP_SUBSTR, REGEXP_COUNT, REGEXP_INSTR
- **Azure**: Only PATINDEX, CHARINDEX, SUBSTRING
- **Impact**: Complex pattern matching becomes verbose
- **Workaround**: Use REPLACE/SUBSTRING or CLR integration

### 3. **NO DBMS_LOB PACKAGE** ❌
- **Oracle**: DBMS_LOB.GETLENGTH(), .SUBSTR(), .INSTR(), .COPY()
- **Azure**: Use LEN(), SUBSTRING(), CHARINDEX() instead
- **Impact**: Slightly different syntax but same functionality
- **Workaround**: Direct T-SQL string functions

### 4. **NO DBMS_SQL PACKAGE** ❌
- **Oracle**: Complex cursor management for dynamic SQL
- **Azure**: Use sp_executesql or EXEC()
- **Impact**: Simpler but less flexible
- **Workaround**: sp_executesql with parameter binding

### 5. **NO SEQUENCE.NEXTVAL INTEGRATION** ⚠️
- **Oracle**: Can use Sequence.NEXTVAL anywhere
- **Azure**: SEQUENCE objects exist but different approach
- **Impact**: ID generation works but requires OUTPUT clause
- **Workaround**: Use SEQUENCE with OUTPUT or IDENTITY

### 6. **LIMITED CURSOR/NESTED TABLES** ⚠️
- **Oracle**: `for rec in (select...) loop`, table.NEXT(), table.COUNT
- **Azure**: Table variables with WHILE loops
- **Impact**: Collection logic more verbose
- **Workaround**: Use table variables and row_number()

### 7. **NO USER_OBJECTS VIEW** ❌
- **Oracle**: Direct access to user objects
- **Azure**: Use sys.objects with schema filtering
- **Impact**: Code needs JOIN with sys.schemas
- **Workaround**: Query sys.objects with SCHEMA_ID()

### 8. **NO CUSTOM RECORD TYPES** ❌
- **Oracle**: `TYPE mytype IS RECORD (...);`
- **Azure**: Only table types exist
- **Impact**: Type passing less flexible
- **Workaround**: Use table-valued parameters (TVP) or individual fields

### 9. **IN OUT PARAMETERS SYNTAX** ⚠️
- **Oracle**: `param IN OUT VARCHAR2`
- **Azure**: `@param NVARCHAR(MAX) OUTPUT`
- **Impact**: Same functionality, different syntax
- **Workaround**: Use OUTPUT keyword

### 10. **LIMITED EXCEPTION HANDLING** ⚠️
- **Oracle**: `EXCEPTION WHEN SPECIFIC_ERROR` then specific handling
- **Azure**: TRY-CATCH with ERROR_NUMBER()
- **Impact**: Less granular error control
- **Workaround**: ERROR_NUMBER(), ERROR_MESSAGE() in CATCH

---

## Function-by-Function Migration Strategy

### PHASE 1: LOW EFFORT, HIGH VALUE (1-2 days)
✅ **Direct Port** - Minimal changes needed
- `get_sql` - FULL OUTER JOIN + CASE work identically
- `get_index` - Simple NULL-safe lookup
- `get_status` - String concatenation
- `get_tasktype` - Simple wrapper function
- `is_excluded` - Simple metadata lookup
- `dos2unix` - Replace REGEXP_REPLACE with REPLACE()
- `purge_schema_error_logs` - Date-based DELETE
- Logging functions (log_*) - Use OUTPUT clause instead of RETURNING

### PHASE 2: MEDIUM EFFORT (3-5 days)
⚠️ **Port with Modifications** - Logic stays same, syntax changes
- `get_config` - Redesign caching with temp table
- `refresh_config` - Load config into temp table
- `get_metadata*` - Rewrite metadata queries
- `replace_parms` - Use REPLACE() loops instead of REGEXP_REPLACE
- `dependencies_met` - Use PATINDEX instead of REGEXP_SUBSTR
- `is_deprecated` - Rewrite cursor logic with WHILE
- `rb_dependencies_met` - Same as dependencies_met
- `reset_schema` - Replace user_objects with sys.objects

### PHASE 3: HIGH EFFORT (5-10 days)
❌ **Complete Rewrite** - Major architectural changes
- `parse_sql` - Split CLOB into statements using STRING_SPLIT
- `run_statement` - Replace DBMS_SQL with sp_executesql
- `apply_sql` - Combine with parse_sql rewrite
- `rollback_sql` - Combine with parse_sql rewrite
- `run_sql` - Main execution orchestrator
- `replace_tablespace` - Rewrite without REGEXP
- `replace_partitionby` - Query sys.partitions instead of DBMS_METADATA
- `replace_sbmo_meijer` - Rewrite pattern detection
- `task_based_apply` - Most complex - heavy regex usage
- `task_based_rollback` - Most complex - heavy regex usage
- `version_updater` - Wrapper for task-based logic

---

## Key Implementation Patterns

### Pattern 1: OUTPUT Clause (Replace RETURNING)
```sql
-- Oracle
INSERT INTO table (id, data) VALUES (seq.NEXTVAL, 'value')
RETURNING id INTO l_id;

-- Azure
DECLARE @ids TABLE (id INT);
INSERT INTO table (data) 
OUTPUT inserted.id INTO @ids
VALUES ('value');
SELECT @id = id FROM @ids;
```

### Pattern 2: Session Variables (Replace Global Package State)
```sql
-- Oracle (package-level)
g_config_record typ_config_record;

-- Azure (session-level)
CREATE TABLE #config (key VARCHAR(50), value VARCHAR(MAX));
-- Populate before use
```

### Pattern 3: Error Handling
```sql
-- Oracle
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    l_var := NULL;
  WHEN OTHERS THEN
    log_error(SQLCODE, SQLERRM);

-- Azure
BEGIN TRY
  SELECT @var = col FROM tbl WHERE id = @id;
  IF @var IS NULL
    SET @var = NULL;
END TRY
BEGIN CATCH
  EXEC usp_LogError;
END CATCH
```

### Pattern 4: Loop Over Collections
```sql
-- Oracle
FOR rec IN (SELECT * FROM table) LOOP
  -- do something
END LOOP;

-- Azure
DECLARE @tbl TABLE (id INT, name VARCHAR(100));
INSERT INTO @tbl SELECT id, name FROM table;

DECLARE @idx INT = 1, @max INT;
SELECT @max = COUNT(*) FROM @tbl;

WHILE @idx <= @max
BEGIN
  -- do something
  SET @idx = @idx + 1;
END;
```

### Pattern 5: Regex Pattern Matching
```sql
-- Oracle
IF REGEXP_INSTR(l_sql, '^\s*CREATE\s+', 1, 1, 0, 'im') > 0 THEN

-- Azure
IF CHARINDEX('CREATE', UPPER(LTRIM(l_sql))) = 1 THEN
  -- Simpler approach
END;
```

---

## Recommended Implementation Order

1. **Start with Phase 1** - Get basic infrastructure working
2. **Test logging** - Verify audit trail captures correctly
3. **Move to Phase 2** - Configuration and metadata
4. **Validate dependencies** - Test dependency checking
5. **Tackle Phase 3** - Execution engine (most complex)
6. **End-to-end testing** - Full workflow validation

---

## Risk Mitigation

### High-Risk Areas
- **parse_sql**: Core engine - test heavily
- **task_based_apply**: Most complex logic
- **replace_partitionby**: Requires DBMS_METADATA replacement

### Testing Strategy
1. Unit test each function individually
2. Integration test function chains
3. Load test with large SQL files
4. Regression test against old Oracle logs

### Fallback Plan
- Keep Oracle package as reference
- Log all conversions for debugging
- Consider CLR procedures for complex regex (advanced option)

---

## Estimated Timeline
- **Phase 1**: 1-2 days (easy wins)
- **Phase 2**: 3-5 days (medium complexity)
- **Phase 3**: 5-10 days (hard problems)
- **Testing & Tuning**: 2-3 days
- **Total**: 10-20 days for full implementation

## Cost-Benefit Analysis
- **Effort**: Medium-High (100-160 dev hours)
- **Value**: Critical infrastructure for schema migrations
- **ROI**: High - enables automated schema updates
- **Maintenance**: Low - stable codebase once complete

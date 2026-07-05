# Partition_Creation_Agent - Multi-Schema Adaptation Guide

**Date:** June 28, 2026  
**Question:** Can the agent handle ARS schema tables?  
**Answer:** ✅ **YES** - But requires schema-specific configuration

---

## Current Agent Scope

### ✅ What the Agent CAN DO (Generic, Reusable)

1. **Partitioning Framework**
   - Drop/recreate primary keys on partition schemes
   - Create RANGE (LEFT/RIGHT) partitions
   - Handle partition functions and schemes
   - Verify partition count and distribution

2. **Foreign Key Management**
   - Identify and drop FKs blocking PK modification
   - Recreate FKs with new PK structure
   - Handle bidirectional FK relationships
   - Validate referential integrity

3. **Data Safety**
   - Preserve all data during PK restructuring
   - Check for duplicate key values
   - Prevent data loss
   - Provide rollback procedures

4. **Documentation & Verification**
   - Generate execution logs
   - Track partition creation status
   - Verify partition counts
   - Provide detailed reports

---

### ❌ What is HARDCODED for EPS

| Element | Current Value | Configurable? |
|---------|---------------|---------------|
| **Schema Name** | `EPS` | ⚠️ Hardcoded in 20+ queries |
| **Partition Key** | `CHAIN_ID` | ⚠️ EPS-specific business logic |
| **Partition Function** | `pf_ChainID_EPS` | ⚠️ Must be recreated per schema |
| **Partition Scheme** | `ps_ChainID_EPS` | ⚠️ Must be recreated per schema |
| **Table Strategy** | PARTITION_STRATEGY_BY_TABLE.md | ⚠️ EPS-specific |
| **FK Column Naming** | EPS patterns (RX_ID, etc.) | ✅ Dynamically handled |

---

## How to Adapt for ARS Schema

### **Step 1: Gather ARS Requirements** (Before Running Agent)

You need to provide:

```
Schema Name:              ARS
Partition Key Column:     [?]  (What column should partition be on?)
Partition Ranges:         [?]  (What boundaries? INT/DATE/DATETIME2?)
Function Name:            [?]  (e.g., pf_ARS_[KEY])
Scheme Name:              [?]  (e.g., ps_ARS_[KEY])
Partition Distribution:   [?]  (How many partitions? 4, 6, 8, 12?)
Total Tables to Partition: [?]  (How many ARS tables need partitioning?)
```

### **Step 2: Prepare ARS Configuration**

**Create:** `DOCUMENTATION/PARTITION_STRATEGY_ARS_SCHEMA.md`

**Include:**
- All ARS tables requiring partitioning (with categories like A1/A2/B)
- Which column is the partition key per table
- Partition boundaries and ranges
- Priority/phasing for execution
- Table dependencies and FK relationships

### **Step 3: Customize the Agent** (4 Changes Required)

#### **Change 1: Create ARS Partition Infrastructure**

```sql
-- One-time setup: Create ARS partition function & scheme
CREATE PARTITION FUNCTION pf_ARS_[PARTITION_KEY] ([DATA_TYPE])
AS RANGE LEFT/RIGHT FOR VALUES ([BOUNDARY1], [BOUNDARY2], ...);

CREATE PARTITION SCHEME ps_ARS_[PARTITION_KEY]
AS PARTITION pf_ARS_[PARTITION_KEY] ALL TO ([PRIMARY]);
```

#### **Change 2: Update Agent Configuration**

Modify agent's `.instructions.md` or `.prompt.md`:
```yaml
Active Schema: ARS
Partition Key: [YOUR_KEY]
Partition Function: pf_ARS_[KEY]
Partition Scheme: ps_ARS_[KEY]
Tables to Partition: [N] tables
Strategy Reference: DOCUMENTATION/PARTITION_STRATEGY_ARS_SCHEMA.md
```

#### **Change 3: Create ARS Execution Prompt**

Create: `DOCUMENTATION/PARTITION_CREATION_PROMPT_ARS.md`

**Copy from:** `DOCUMENTATION/PARTITION_CREATION_PROMPT.md`  
**Change:**
- Schema name: EPS → ARS
- Partition key: CHAIN_ID → [YOUR_ARS_KEY]
- Partition function: pf_ChainID_EPS → pf_ARS_[KEY]
- Partition scheme: ps_ChainID_EPS → ps_ARS_[KEY]
- Test all SQL queries with ARS table structure

#### **Change 4: Create ARS Strategy Reference**

Create: `DOCUMENTATION/PARTITION_STRATEGY_ARS_SCHEMA.md`

**Include:**
```markdown
# ARS Schema Partitioning Strategy

## Overview
- Schema: ARS
- Partition Key: [COLUMN]
- Type: RANGE [LEFT/RIGHT]
- Total Tables: [N]

## Partition Boundaries
- Boundary 1: [VALUE]
- Boundary 2: [VALUE]
- ...
- Expected Partitions: [N] per table

## ARS Category A (High Priority)
| Table Name | Partition Strategy | FK Dependencies |
|-------|-------------|----------|
| TABLE1 | [PARTITION_KEY] | [FK list] |
| TABLE2 | [PARTITION_KEY] | [FK list] |
...

## ARS Category B (Medium Priority)
...

## Implementation Notes
- Pre-flight checks specific to ARS
- Known FK patterns
- Data characteristics
- Risk factors
```

---

## Workflow: Using Agent for ARS

### **Phase 1: Preparation** (1-2 hours)

```
1. Gather ARS table list (use NON_EPR/ARS/ folder)
2. Identify partition key column for each table
3. Analyze FK relationships in ARS
4. Define partition boundaries
5. Create PARTITION_STRATEGY_ARS_SCHEMA.md
6. Create PARTITION_CREATION_PROMPT_ARS.md
7. Set up partition infrastructure (function + scheme)
```

### **Phase 2: Configuration** (30 minutes)

```
1. Update agent configuration (.instructions.md)
2. Point to ARS strategy document
3. Point to ARS execution prompt
4. Verify all references resolve
```

### **Phase 3: Execution** (Per table: 40-50 minutes)

```
1. Select ARS table from strategy
2. Run PARTITION_CREATION_PROMPT_ARS.md Steps 0-9
3. Follow same pattern as EPS tables
4. Document results in ARS_EXECUTION_REPORT.md
5. Move to next table
```

### **Phase 4: Verification** (30 minutes total)

```
1. Run partition verification queries
2. Check all tables have correct partition count
3. Verify FK recreation succeeded
4. Update ARS_DEPLOYMENT_SUMMARY.md
```

---

## SQL Query Adaptation Template

**All hardcoded EPS references change to:**

| Element | EPS (Current) | ARS (New) |
|---------|---|---|
| Schema | `EPS` | `ARS` |
| Partition Key | `CHAIN_ID` | `[YOUR_KEY]` |
| PK Structure | `(CHAIN_ID, [COLS])` | `([YOUR_KEY], [COLS])` |
| Function | `pf_ChainID_EPS` | `pf_ARS_[KEY]` |
| Scheme | `ps_ChainID_EPS` | `ps_ARS_[KEY]` |

**Find & Replace Pattern:**

```powershell
# In all SQL queries:
EPS → ARS
CHAIN_ID → [YOUR_ARS_PARTITION_KEY]
pf_ChainID_EPS → pf_ARS_[PARTITION_KEY]
ps_ChainID_EPS → ps_ARS_[PARTITION_KEY]
```

---

## Estimated Effort for ARS Partitioning

| Task | Time | Effort |
|------|------|--------|
| Gather & analyze ARS tables | 1-2 hours | Medium |
| Create ARS strategy document | 1 hour | Medium |
| Create ARS execution prompt | 30 min | Low |
| Set up partition infrastructure | 15 min | Low |
| Per-table partitioning execution | 40-50 min × N | High |
| Verification & reporting | 1-2 hours | Medium |
| **Total for [N] ARS tables** | **Depends on N** | **High** |

**Example:** 30 ARS tables = 2.5 hours prep + 20-25 hours execution + 2 hours verification = ~24-29 hours

---

## Checklist: Before Starting ARS Partitioning

- [ ] ARS table list gathered (from NON_EPR/ARS/)
- [ ] Partition key column identified for all tables
- [ ] Partition boundaries defined
- [ ] FK relationships mapped
- [ ] PARTITION_STRATEGY_ARS_SCHEMA.md created
- [ ] PARTITION_CREATION_PROMPT_ARS.md created
- [ ] Partition function created
- [ ] Partition scheme created
- [ ] Agent configuration updated
- [ ] All SQL queries tested with ARS schema
- [ ] Verification query suite adapted for ARS
- [ ] Rollback procedure documented

---

## Agent Reusability Assessment

| Aspect | Reusable? | Notes |
|--------|-----------|-------|
| **Core Framework** | ✅ 100% | Can handle any schema |
| **FK Management Logic** | ✅ 100% | Works with all schemas |
| **Verification Patterns** | ✅ 95% | Minor adaptations needed |
| **Error Handling** | ✅ 100% | Generic, no schema dependency |
| **Documentation Template** | ✅ 90% | Adapt for ARS specifics |
| **Execution Playbook** | ⚠️ 50% | Major adaptations needed |
| **Configuration** | ❌ 0% | Must be recreated for ARS |

---

## Conclusion

**The Partition_Creation_Agent is fundamentally reusable for ARS schema partitioning**, but requires:

1. ✅ **New strategy document** (ARS-specific table classification)
2. ✅ **New execution prompt** (ARS SQL patterns)  
3. ✅ **Partition infrastructure** (ARS function + scheme)
4. ✅ **Configuration updates** (ARS metadata in agent config)
5. ✅ **SQL query adaptation** (Search/replace schema names)

Once adapted, the agent will function identically for ARS as it does for EPS.

---

## Next Steps When You're Ready for ARS

1. **Provide:** ARS table list + partition key + boundaries
2. **I'll create:** 
   - PARTITION_STRATEGY_ARS_SCHEMA.md
   - PARTITION_CREATION_PROMPT_ARS.md
   - ARS-adapted verification queries
3. **You'll run:** Agent following same pattern as EPS
4. **Result:** All ARS tables partitioned on schedule

The framework is proven. Only the schema configuration changes.

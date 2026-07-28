
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SBMO"."PKG_PDX_SCHEMA_UPDATER_HELPER" as
DTL_EXCEPTION EXCEPTION;
g_is_release BOOLEAN := NULL;
g_debug_hdr_id NUMBER(38);
g_debug_dtl_id NUMBER(38);
g_debug BOOLEAN := FALSE;  PROCEDURE set_debug(p_value BOOLEAN) IS BEGIN g_debug := p_value; END;
PROCEDURE purge_debug(p_date TIMESTAMP, p_proc VARCHAR2 := NULL) IS
BEGIN
DELETE FROM pdx_schema_upd_helper_debug_d WHERE pdx_schema_upd_hlpr_dbg_h_id IN (SELECT id FROM pdx_schema_upd_helper_debug_h h WHERE h.debug_timestamp < p_date AND (p_proc IS NULL OR p_proc = proc));
DELETE FROM pdx_schema_upd_helper_debug_h h WHERE h.debug_timestamp < p_date AND (p_proc IS NULL OR p_proc = proc);
COMMIT;
END purge_debug;
PROCEDURE debug_hdr (p_proc VARCHAR2, p_parms VARCHAR2) IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
IF g_debug THEN
INSERT INTO pdx_schema_upd_helper_debug_h (id, proc, parms, debug_timestamp) VALUES (pdx_schema_master_seq.nextval, UPPER(p_proc), p_parms, systimestamp) RETURNING id INTO g_debug_hdr_id;
COMMIT;
END IF;
END debug_hdr;
PROCEDURE debug_hdr_success IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
IF g_debug THEN
g_debug_hdr_id := NULL; g_debug_dtl_id := NULL;
END IF;
END debug_hdr_success;
PROCEDURE debug_hdr_error (p_err CLOB) IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
IF g_debug AND g_debug_hdr_id IS NOT NULL THEN
UPDATE pdx_schema_upd_helper_debug_h SET sql_error = p_err WHERE id = g_debug_hdr_id;
g_debug_hdr_id := NULL; g_debug_dtl_id := NULL;
COMMIT;
END IF;
END debug_hdr_error;
PROCEDURE debug_dtl (p_msg VARCHAR2, p_sql CLOB) IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
IF g_debug AND g_debug_hdr_id IS NOT NULL THEN
INSERT INTO pdx_schema_upd_helper_debug_d (id, pdx_schema_upd_hlpr_dbg_h_id, start_timestamp, message, sql) VALUES (pdx_schema_master_seq.nextval, g_debug_hdr_id, SYSTIMESTAMP, p_msg, p_sql) RETURNING id INTO g_debug_dtl_id;
COMMIT;
END IF;
END debug_dtl;
PROCEDURE debug_dtl_success IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
IF g_debug AND g_debug_dtl_id IS NOT NULL THEN
UPDATE pdx_schema_upd_helper_debug_d SET end_timestamp = SYSTIMESTAMP WHERE id = g_debug_dtl_id;
g_debug_dtl_id := NULL;
COMMIT;
END IF;
END debug_dtl_success;
PROCEDURE debug_dtl_error (p_err CLOB) IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
IF g_debug AND g_debug_dtl_id IS NOT NULL THEN
UPDATE pdx_schema_upd_helper_debug_d SET sql_error = p_err WHERE id = g_debug_dtl_id;
g_debug_dtl_id := NULL;
COMMIT;
END IF;
END debug_dtl_error;
FUNCTION get_is_release RETURN BOOLEAN IS
l_tmp VARCHAR2(30);
BEGIN
IF g_is_release IS NULL THEN
SELECT UPPER(value) INTO l_tmp FROM pdx_schema_config WHERE key = 'APPLYTYPE';
g_is_release := l_tmp != 'TASK';
END IF;
RETURN g_is_release;
END get_is_release;
PROCEDURE change_precision_scale (p_table_name VARCHAR2, p_change_list VARCHAR2, p_parallel NUMBER := 0, p_increase_only BOOLEAN := false, p_use_ctas BOOLEAN := false, p_set_unused BOOLEAN := false) IS
TYPE colrec IS RECORD (
data_type              VARCHAR2(15),
data_precision_length  INTEGER,
data_scale             INTEGER,
tmp_renamed            VARCHAR2(1),        -- N (No), Y (Yes)
tmp_type               VARCHAR2(15),
tmp_precision_length   INTEGER,
tmp_scale              INTEGER,
new_renamed            VARCHAR2(1),        -- N (No), C (Column), T (Table)
method                 VARCHAR2(1),        -- N (None), I (In Place), C (Out of Place - Column), T (Out of Place - Table)
action                 VARCHAR2(1)         -- A (Apply), R (Rollback)
);
TYPE coltbl IS TABLE OF colrec INDEX BY VARCHAR2(30);
coldata coltbl;
is_release BOOLEAN;
l_use_ctas BOOLEAN;
FUNCTION get_rename_column_name (p_column VARCHAR2) RETURN VARCHAR2 DETERMINISTIC IS
BEGIN
RETURN SUBSTR(UPPER(p_column),1,25)||'_ORIG';
END get_rename_column_name;
FUNCTION get_temp_table_name (p_table VARCHAR2, p_use_ctas BOOLEAN) RETURN VARCHAR2 DETERMINISTIC IS
BEGIN
RETURN CASE WHEN p_use_ctas THEN SUBSTR(UPPER(p_table),1,26)||'_TMP' ELSE UPPER(p_table) END;
END get_temp_table_name;
FUNCTION get_temp_column_name (p_column VARCHAR2, p_use_ctas BOOLEAN) RETURN VARCHAR2 DETERMINISTIC IS
BEGIN
RETURN CASE WHEN p_use_ctas THEN UPPER(p_column) ELSE SUBSTR(UPPER(p_column),1,25)||'_TMP' END;
END get_temp_column_name;
FUNCTION get_data_type (p_type VARCHAR2, p_prec_len NUMBER, p_scale NUMBER := NULL) RETURN VARCHAR2 DETERMINISTIC IS
l_rtn VARCHAR2(60);
BEGIN
CASE WHEN p_type = 'NUMBER' THEN
l_rtn := 'NUMBER'||CASE WHEN p_prec_len IS NOT NULL THEN '('||p_prec_len||CASE WHEN NVL(p_scale,0) != 0 THEN ','||p_scale END||')' END;
WHEN p_type = 'VARCHAR2' THEN
l_rtn := 'VARCHAR2('||p_prec_len||')';
ELSE
RAISE_APPLICATION_ERROR(-20004,'Unsupported datatype - '||p_type);
END CASE;
RETURN l_rtn;
END get_data_type;
PROCEDURE process_change_list (p_coldata IN OUT coltbl, p_change_list VARCHAR2) IS
l_change_list VARCHAR2(4000) := p_change_list;
l_match       VARCHAR2(60);
l_type        VARCHAR2(15);
l_col         VARCHAR2(30);
l_tmp         VARCHAR2(15);
l_colrow colrec;
BEGIN
p_coldata.DELETE;
FOR ctr IN 1..regexp_count(l_change_list, '(^|,)\s*[A-Za-z0-9_]+\s+[A-Za-z0-9]+\s*([(][0-9 ]*,?[0-9 ]*[)])?\s*') LOOP
l_match := UPPER(regexp_substr(l_change_list, '(^|,)\s*[A-Za-z0-9_]+\s+[A-Za-z0-9]+\s*([(][0-9 ]*,?[0-9 ]*[)])?\s*', 1, 1));
l_type := regexp_substr(l_match, '([A-Za-z0-9_]+)\s*([A-Za-z0-9]+)\s*([(][0-9 ]*,?[0-9 ]*[)])?',1,1,null,2);
IF l_type NOT IN ('NUMBER','VARCHAR2') THEN
RAISE_APPLICATION_ERROR(-20001,'Only datatypes NUMBER and VARCHAR2 are supported.');
END IF;
l_col := regexp_substr(l_match, '([A-Za-z0-9_]+)\s*([A-Za-z0-9]+)\s*([(][0-9 ]*,?[0-9 ]*[)])?',1,1,null,1);
IF p_coldata.EXISTS(l_col) THEN
RAISE_APPLICATION_ERROR(-20001,'Column '||l_col||' was found more than once in change list.');
END IF;
l_tmp    := regexp_substr(l_match, '([A-Za-z0-9_]+)\s*([A-Za-z0-9]+)\s*([(][0-9 ]*,?[0-9 ]*[)])?',1,1,null,3);
l_colrow.data_type := l_type;
l_colrow.data_precision_length := regexp_substr(l_tmp, '[(]([0-9]*),?([0-9]*)?[)]',1,1,null,1);
l_colrow.data_scale := regexp_substr(l_tmp, '[(]([0-9]*),?([0-9]*)?[)]',1,1,null,2);
p_coldata(l_col) := l_colrow;
l_change_list := regexp_replace(l_change_list, REPLACE(REPLACE(l_match,'(','[(]'),')','[)]'), null, 1, 1, 'i');
END LOOP;
IF l_change_list IS NOT NULL THEN
RAISE_APPLICATION_ERROR(-20001,'Unable to process change list: '||l_change_list);
END IF;
END process_change_list;
PROCEDURE set_renamed ( p_coldata IN OUT coltbl, p_table VARCHAR2) IS
l_type      VARCHAR2(15);
l_length    INTEGER;
l_precision INTEGER;
l_scale     INTEGER;
l_column    VARCHAR2(30);
BEGIN
l_column := p_coldata.FIRST;
WHILE l_column IS NOT NULL LOOP
BEGIN
SELECT data_type, data_length, data_precision, data_scale INTO l_type, l_length, l_precision, l_scale FROM user_tab_columns WHERE table_name = UPPER(p_table) and column_name = UPPER(l_column);
IF l_type NOT IN ('NUMBER','VARCHAR2') THEN
RAISE_APPLICATION_ERROR(-20001,'Only datatypes NUMBER and VARCHAR2 are supported.  Column is of invalid type.');
END IF;
p_coldata(l_column).tmp_renamed := 'N';
p_coldata(l_column).tmp_type := l_type;
p_coldata(l_column).tmp_precision_length := CASE WHEN l_type = 'VARCHAR2' THEN l_length ELSE l_precision END;
p_coldata(l_column).tmp_scale := l_scale;
EXCEPTION WHEN NO_DATA_FOUND THEN
DECLARE l_renamed_column VARCHAR2(30) := get_rename_column_name(l_column);
BEGIN
SELECT data_type, data_length, data_precision, data_scale INTO l_type, l_length, l_precision, l_scale FROM user_tab_columns WHERE table_name = UPPER(p_table) and column_name = l_renamed_column;
p_coldata(l_column).tmp_renamed := 'Y';
p_coldata(l_column).tmp_type := l_type;
p_coldata(l_column).tmp_precision_length := CASE WHEN l_type = 'VARCHAR2' THEN l_length ELSE l_precision END;
p_coldata(l_column).tmp_scale := l_scale;
EXCEPTION WHEN NO_DATA_FOUND THEN
RAISE_APPLICATION_ERROR(-20001,'Table '||p_table||' does not contain column '||l_column||', nor the renamed column');
END;
END;
DECLARE l_temp_column VARCHAR2(30) := get_temp_column_name(l_column,false);
BEGIN
SELECT data_type, data_length, data_precision, data_scale INTO l_type, l_length, l_precision, l_scale FROM user_tab_columns WHERE table_name = UPPER(p_table) and column_name = l_temp_column;
IF p_use_ctas THEN
RAISE_APPLICATION_ERROR(-20001,'Requested use of CTAS, but temporary column '||l_temp_column||' exists on table.');
END IF;
p_coldata(l_column).new_renamed := 'C';
EXCEPTION WHEN NO_DATA_FOUND THEN
DECLARE l_temp_table VARCHAR2(30) := get_temp_table_name(p_table,true);
BEGIN
SELECT data_type, data_length, data_precision, data_scale INTO l_type, l_length, l_precision, l_scale FROM user_tab_columns WHERE table_name = l_temp_table and column_name = UPPER(l_column);
IF NOT p_use_ctas THEN
RAISE_APPLICATION_ERROR(-20001,'Requested use of Inline, but temporary table '||l_temp_table||' exists in schema for modified column.');
END IF;
p_coldata(l_column).new_renamed := 'T';
EXCEPTION WHEN NO_DATA_FOUND THEN
p_coldata(l_column).new_renamed := 'N';
END;
END;
l_column := p_coldata.NEXT(l_column);
END LOOP;
END set_renamed;
PROCEDURE set_method(p_coldata IN OUT coltbl, p_table VARCHAR2, p_increase_only BOOLEAN, p_use_ctas BOOLEAN, p_is_release BOOLEAN) IS
l_column     VARCHAR2(30);
l_increasing BOOLEAN;
l_decreasing BOOLEAN;
l_outofplace BOOLEAN;      -- VARCHAR2 can be decreasing and In Place.  Also changing datatype will be neither increasing nor decreasing.
BEGIN
l_column := p_coldata.FIRST;
WHILE l_column IS NOT NULL LOOP
-- data* is what is requested, tmp* is the current _ORIG.
-- It is possible we are restarting from a prior failure and all _ORIG columns have already been resized ... but it should be an all or nothing ordeal.
-- But we could have a mixure of In place and Out of place modifications if multiple columns are provided
l_decreasing := (    (    p_coldata(l_column).data_type = 'NUMBER' AND p_coldata(l_column).tmp_type = 'NUMBER'
AND (   NVL(p_coldata(l_column).data_precision_length,0)-NVL(p_coldata(l_column).data_scale,0) < NVL(p_coldata(l_column).tmp_precision_length,0)-NVL(p_coldata(l_column).tmp_scale,0)
OR NVL(p_coldata(l_column).data_precision_length,0) < NVL(p_coldata(l_column).tmp_precision_length,0)
OR NVL(p_coldata(l_column).data_scale,0) < NVL(p_coldata(l_column).tmp_scale,0)
)
)
OR (    p_coldata(l_column).data_type = 'VARCHAR2' AND p_coldata(l_column).tmp_type = 'VARCHAR2'
AND p_coldata(l_column).data_precision_length < p_coldata(l_column).tmp_precision_length
)
);
l_increasing := NOT l_decreasing
AND (    (    p_coldata(l_column).data_type = 'NUMBER' AND p_coldata(l_column).tmp_type = 'NUMBER'
AND (   NVL(p_coldata(l_column).data_precision_length,0)-NVL(p_coldata(l_column).data_scale,0) > NVL(p_coldata(l_column).tmp_precision_length,0)-NVL(p_coldata(l_column).tmp_scale,0)
OR NVL(p_coldata(l_column).data_precision_length,0) > NVL(p_coldata(l_column).tmp_precision_length,0)
OR NVL(p_coldata(l_column).data_scale,0) > NVL(p_coldata(l_column).tmp_scale,0)
)
)
OR (    p_coldata(l_column).data_type = 'VARCHAR2' AND p_coldata(l_column).tmp_type = 'VARCHAR2'
AND p_coldata(l_column).data_precision_length > p_coldata(l_column).tmp_precision_length
)
);
l_outofplace := (p_coldata(l_column).data_type = 'NUMBER' AND p_coldata(l_column).tmp_type = 'NUMBER'
AND (   NVL(p_coldata(l_column).data_precision_length,0)-NVL(p_coldata(l_column).data_scale,0) < NVL(p_coldata(l_column).tmp_precision_length,0)-NVL(p_coldata(l_column).tmp_scale,0)
OR NVL(p_coldata(l_column).data_precision_length,0) < NVL(p_coldata(l_column).tmp_precision_length,0)
OR NVL(p_coldata(l_column).data_scale,0) < NVL(p_coldata(l_column).tmp_scale,0)
)
)
OR p_coldata(l_column).data_type != p_coldata(l_column).tmp_type;
p_coldata(l_column).action := 'A';         -- Assume we are applying change
IF p_coldata(l_column).tmp_renamed = 'N' AND NOT l_decreasing AND NOT l_increasing AND NOT l_outofplace THEN
-- The column is already at the requested length
IF p_coldata(l_column).new_renamed != 'N' THEN
-- This is an error because if done by package then original column (tmp_renamed) would be renamed
RAISE_APPLICATION_ERROR(-20002,'It appears that column '||l_column||' is already of the requested size, but a temporary column exists.');
END IF;
p_coldata(l_column).method := 'N';
DBMS_OUTPUT.PUT_LINE(l_column||' N - Not renamed and is neither increasing, decreasing, nor changing datatype');
ELSIF p_coldata(l_column).tmp_renamed = 'Y' THEN
IF p_coldata(l_column).new_renamed IN ('C','T') THEN
-- We are either re-attempting or rolling back.
-- It is possible we renamed column, then failed on next step, so if new_renamed = 'N' then we can make no assumptions
DECLARE
l_type       VARCHAR2(15);
l_prec_len   INTEGER;
l_scale      INTEGER;
l_tmp_table  VARCHAR2(30) := get_temp_table_name(p_table,p_use_ctas);
l_tmp_col    VARCHAR2(30) := get_temp_column_name(l_column,p_use_ctas);
BEGIN
DBMS_OUTPUT.PUT_LINE(l_tmp_table||'.'||l_tmp_col);
SELECT data_type, CASE WHEN data_type = 'VARCHAR2' THEN data_length ELSE data_precision END, data_scale INTO l_type, l_prec_len, l_scale FROM user_tab_columns WHERE table_name = l_tmp_table and column_name = l_tmp_col;
IF get_data_type(l_type,l_prec_len,l_scale) != get_data_type(p_coldata(l_column).data_type, p_coldata(l_column).data_precision_length, p_coldata(l_column).data_scale) THEN
p_coldata(l_column).action := 'R';
END IF;
END;
END IF;
IF p_coldata(l_column).new_renamed = 'C' THEN
IF p_use_ctas THEN
RAISE_APPLICATION_ERROR(-20002,'Tmp Column found for '||l_column||', however Tmp Table was requested.');
END IF;
p_coldata(l_column).method := 'C';
DBMS_OUTPUT.PUT_LINE(l_column||' C - column is already renamed and temp column was found'||case when p_coldata(l_column).method = 'R' then ' [rollback]' end);
ELSIF p_coldata(l_column).new_renamed = 'T' THEN
IF NOT p_use_ctas THEN
RAISE_APPLICATION_ERROR(-20002,'Tmp Table found for '||l_column||', however Tmp Column was requested.');
END IF;
p_coldata(l_column).method := 'T';
DBMS_OUTPUT.PUT_LINE(l_column||' T - column is already renamed and temp table was found'||case when p_coldata(l_column).method = 'R' then ' [rollback]' end);
END IF;
END IF;
IF p_coldata(l_column).method IS NULL THEN
-- Do not need to validate new_renamed becuase if it was set, then method is non-null
IF p_is_release AND l_decreasing AND p_increase_only AND p_coldata(l_column).data_type = p_coldata(l_column).tmp_type THEN
-- Requested to decrease length, but only increases to release-based schemas
-- Data Type number <=> varchar2 is always performed
p_coldata(l_column).method := 'N';
DBMS_OUTPUT.PUT_LINE(l_column||' N - decreasing precision, but requested to perform increase-only');
ELSIF l_increasing AND NOT l_outofplace THEN
p_coldata(l_column).method := 'I';
DBMS_OUTPUT.PUT_LINE(l_column||' I - Increasing precision can be done directly');
ELSIF l_decreasing OR l_outofplace THEN
-- VARCHAR2 decrease only requires an update of data and can be done in-line
IF l_outofplace THEN
p_coldata(l_column).method := CASE WHEN p_use_ctas THEN 'T' ELSE 'C' END;
DBMS_OUTPUT.PUT_LINE(l_column||' '||CASE WHEN p_use_ctas THEN 'T' ELSE 'C' END||' - change must be done out of place');
ELSE
p_coldata(l_column).method := 'I';
DBMS_OUTPUT.PUT_LINE(l_column||' I - Assumes VARCHAR2 decrease which can be done directly (after updating column with substr)');
END IF;
ELSIF NOT l_decreasing AND NOT l_increasing AND NOT l_outofplace THEN
-- Means we are resuming from In-Place where we've already modified the datatype, but didn't complete the change
p_coldata(l_column).method := 'I';
DBMS_OUTPUT.PUT_LINE(l_column||' I - Assumes we still have ORIG columns and simply need to rename them');
ELSE
RAISE_APPLICATION_ERROR(-20002,'Logic error - '||l_column||' in validate_data.');
END IF;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
END set_method;
PROCEDURE validate_data (p_coldata coltbl, p_use_ctas BOOLEAN) IS
l_column      VARCHAR2(30);
l_fnd_renamed BOOLEAN := FALSE;
l_all_renamed BOOLEAN := TRUE;
l_fnd_temp    BOOLEAN := FALSE;
l_all_temp    BOOLEAN := TRUE;
l_tc_action   VARCHAR2(1);
BEGIN
-- tmp_renamed could be a mixture as each rename takes place individually.
-- All new_renamed should be the same value.  All N if tmp_renamed is N, otherwise matching the method
-- tmp_renamed            VARCHAR2(1),        -- N (No), Y (Yes)
-- new_renamed            VARCHAR2(1),        -- N (No), C (Column), T (Table)
-- method                 VARCHAR2(1)         -- N (None), I (In Place), C (Out of Place - Column), T (Out of Place - Table)
l_column := p_coldata.FIRST;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method != 'N' AND p_coldata(l_column).tmp_renamed = 'Y' THEN
l_fnd_renamed := TRUE;
ELSIF p_coldata(l_column).method != 'N' AND p_coldata(l_column).tmp_renamed != 'Y' THEN
l_all_renamed := FALSE;
ELSIF p_coldata(l_column).method = 'N' AND p_coldata(l_column).tmp_renamed = 'Y' THEN
RAISE_APPLICATION_ERROR(-20003,l_column||' is not being modified, but is renamed from original.');
END IF;
IF p_coldata(l_column).method IN ('C','T') AND p_coldata(l_column).new_renamed != 'N' THEN
l_fnd_temp := TRUE;
ELSIF p_coldata(l_column).method IN ('C','T') AND p_coldata(l_column).new_renamed = 'N' THEN
l_all_temp := FALSE;
END IF;
IF p_coldata(l_column).method IN ('C','T') THEN
l_tc_action := p_coldata(l_column).action;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
l_column := p_coldata.FIRST;
WHILE l_column IS NOT NULL LOOP
IF l_fnd_renamed AND NOT l_all_renamed AND p_coldata(l_column).new_renamed != 'N' THEN
RAISE_APPLICATION_ERROR(-20003,'No temp table/column should exist unless all modified original columns are renamed.');
END IF;
IF p_coldata(l_column).method = 'C' THEN
IF p_coldata(l_column).new_renamed NOT IN ('N','C') THEN
RAISE_APPLICATION_ERROR(-20003,'Found '||l_column||' In temporary table, but was expecting temporary column.');
END IF;
IF p_use_ctas THEN
RAISE_APPLICATION_ERROR(-20003,l_column||' logic would use CTAS, but CTAS was not requested.');
END IF;
ELSIF p_coldata(l_column).method = 'T' THEN
IF p_coldata(l_column).new_renamed NOT IN ('N','T') THEN
RAISE_APPLICATION_ERROR(-20003,'Found '||l_column||' In temporary column, but was expecting temporary table.');
END IF;
IF NOT p_use_ctas THEN
RAISE_APPLICATION_ERROR(-20003,l_column||' logic would use Temp Columns, but CTAS was requested.');
END IF;
ELSE
IF p_coldata(l_column).new_renamed != 'N' THEN
RAISE_APPLICATION_ERROR(-20003,'Found '||l_column||' In temporary column/table, but was expecting none.');
END IF;
END IF;
IF p_coldata(l_column).method IN ('C','T') AND p_coldata(l_column).action != l_tc_action THEN
RAISE_APPLICATION_ERROR(-20003,'Found a mixture of Apply/Rollback actions, should be only one.');
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
IF l_fnd_temp AND NOT l_all_temp THEN
RAISE_APPLICATION_ERROR(-20003,'Creation of temporary column/table is one operation, but not all are present.');
END IF;
END validate_data;
PROCEDURE create_out_of_place(p_coldata coltbl, p_table VARCHAR2) IS
l_sql CLOB;
l_column VARCHAR2(30);
l_first_column BOOLEAN := TRUE;
l_use_ctas BOOLEAN;
BEGIN
l_column := p_coldata.FIRST;
WHILE l_column IS NOT NULL LOOP
IF l_sql IS NULL THEN
IF p_coldata(l_column).method = 'C' THEN
l_use_ctas := FALSE;
l_sql := 'ALTER TABLE '||p_table||' ADD (';
ELSIF p_coldata(l_column).method = 'T' THEN
-- It is tempting to use NOLOGGING here, but don't!  At some point we will have copied production data to this table and NULLed the original values in the production columns
-- A failure requiring recovery would mean the loss of this table, and thus, production data.
l_use_ctas := TRUE;
l_sql := 'CREATE TABLE '||get_temp_table_name(p_table, l_use_ctas)||' (';
-- What if we are changing the datatype on a Primary Key field?
-- Assumption: It will be increase-only which means we will be in-place, not ctas, for those columns
FOR pk IN (SELECT cc.column_name, tc.data_type, tc.data_length, tc.data_precision, tc.data_scale FROM user_constraints c join user_cons_columns cc on (cc.constraint_name = c.constraint_name) join user_tab_columns tc on (tc.table_name = c.table_name and tc.column_name = cc.column_name) where c.table_name = UPPER(p_table) and c.constraint_type = 'P' order by position) LOOP
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ',' END||pk.column_name||' '||get_data_type(pk.data_type,CASE WHEN pk.data_type = 'VARCHAR2' THEN pk.data_length ELSE pk.data_precision END,pk.data_scale);
l_first_column := FALSE;
END LOOP;
END IF;
END IF;
IF p_coldata(l_column).method IN ('C','T') THEN
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ',' END||get_temp_column_name(l_column,l_use_ctas)||' '||get_data_type(p_coldata(l_column).data_type, p_coldata(l_column).data_precision_length, p_coldata(l_column).data_scale);
l_first_column := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
IF l_sql IS NOT NULL THEN
IF l_use_ctas THEN
l_sql := l_sql||', PRIMARY KEY (';
l_first_column := TRUE;
FOR pk IN (SELECT column_name FROM user_constraints c join user_cons_columns cc on (cc.constraint_name = c.constraint_name) where c.table_name = UPPER(p_table) and c.constraint_type = 'P' order by position) LOOP
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ',' END||pk.column_name;
l_first_column := FALSE;
END LOOP;
l_sql := l_sql||') USING INDEX';
END IF;
l_sql := l_sql||')';
BEGIN
debug_dtl('Create Out Of Place Table/Columns',l_sql);
EXECUTE IMMEDIATE l_sql;
debug_dtl_success;
EXCEPTION WHEN OTHERS THEN
debug_dtl_error(DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RAISE DTL_EXCEPTION;
END;
END IF;
END create_out_of_place;
FUNCTION is_oop_populated(p_coldata coltbl, p_table VARCHAR2, p_use_ctas BOOLEAN) RETURN BOOLEAN IS
l_column       VARCHAR2(30);
l_rtn BOOLEAN;
l_sql CLOB;
l_first_column BOOLEAN := TRUE;
l_dummy VARCHAR2(1);
BEGIN
l_column := p_coldata.FIRST;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method IN ('C','T') THEN
IF l_sql IS NULL THEN
l_sql := 'SELECT '||case when p_parallel > 1 THEN '/*+ parallel(t '||p_parallel||') */ ' end||'NULL FROM '||get_temp_table_name(p_table,p_use_ctas)||' t WHERE ';
END IF;
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ' OR ' END||get_temp_column_name(l_column,p_use_ctas)||' IS NOT NULL';
l_first_column := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
IF l_sql IS NOT NULL THEN
l_sql := l_sql||' AND ROWNUM = 1';
BEGIN
debug_dtl('Querying whether out-of-place columns have been populated',l_sql);
EXECUTE IMMEDIATE l_sql INTO l_dummy;
debug_dtl_success;
l_rtn := TRUE;
EXCEPTION WHEN NO_DATA_FOUND THEN l_rtn := FALSE;
WHEN OTHERS THEN
debug_dtl_error(DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RAISE DTL_EXCEPTION;
END;
ELSE
RAISE_APPLICATION_ERROR(-20004,'Requested to check if Out Of Place Table/Column is populated, but we do not need Out Of Place processing.');
END IF;
RETURN l_rtn;
END is_oop_populated;
PROCEDURE populate_tmp(p_coldata coltbl, p_table VARCHAR2, p_use_ctas BOOLEAN) IS
l_column       VARCHAR2(30);
l_first_column BOOLEAN := TRUE;
l_sql          CLOB;
BEGIN
IF p_use_ctas THEN
l_sql := 'INSERT '||case when p_parallel > 1 THEN '/*+ enable_parallel_dml parallel(t '||ceil(p_parallel/2)||') */ ' end||'INTO '||get_temp_table_name(p_table, p_use_ctas)||' t (';
l_first_column := TRUE;
FOR pk IN (SELECT column_name FROM user_constraints c join user_cons_columns cc on (cc.constraint_name = c.constraint_name) where c.table_name = UPPER(p_table) and c.constraint_type = 'P' order by position) LOOP
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ',' END||pk.column_name;
l_first_column := FALSE;
END LOOP;
l_column := p_coldata.FIRST;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method = 'T' THEN
l_sql := l_sql||','||l_column;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
l_sql := l_sql||') SELECT '||case when p_parallel > 1 THEN '/*+ parallel(s '||ceil(p_parallel/2)||') */ ' end;
l_first_column := TRUE;
FOR pk IN (SELECT column_name FROM user_constraints c join user_cons_columns cc on (cc.constraint_name = c.constraint_name) where c.table_name = UPPER(p_table) and c.constraint_type = 'P' order by position) LOOP
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ',' END||pk.column_name;
l_first_column := FALSE;
END LOOP;
l_column := p_coldata.FIRST;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method = 'T' THEN
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ',' END||get_rename_column_name(l_column);
l_first_column := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
l_sql := l_sql||' FROM '||p_table||' s WHERE ';
l_column := p_coldata.FIRST;
l_first_column := TRUE;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method = 'T' THEN
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ' OR ' END||get_rename_column_name(l_column)||' IS NOT NULL';
l_first_column := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
BEGIN
debug_dtl('Populate Out Of Place Table',l_sql);
EXECUTE IMMEDIATE l_sql;
debug_dtl_success;
EXCEPTION WHEN OTHERS THEN
debug_dtl_error(DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RAISE DTL_EXCEPTION;
END;
ELSE
l_sql := 'UPDATE '||p_table||' SET ';
l_column := p_coldata.FIRST;
l_first_column := TRUE;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method = 'C' THEN
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ',' END||get_temp_column_name(l_column, p_use_ctas)||' = '||get_rename_column_name(l_column);
l_first_column := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
l_sql := l_sql||' WHERE ';
l_column := p_coldata.FIRST;
l_first_column := TRUE;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method = 'C' THEN
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ' OR ' END||get_rename_column_name(l_column)||' IS NOT NULL';
l_first_column := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
BEGIN
debug_dtl('Populate Out Of Place Columns',l_sql);
EXECUTE IMMEDIATE l_sql;
debug_dtl_success;
EXCEPTION WHEN OTHERS THEN
debug_dtl_error(DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RAISE DTL_EXCEPTION;
END;
END IF;
END populate_tmp;
PROCEDURE set_orig_null(p_coldata coltbl, p_table VARCHAR2) IS
l_column       VARCHAR2(30);
l_first_col BOOLEAN := TRUE;
l_sql       CLOB;
BEGIN
l_sql := 'UPDATE '||p_table||' SET ';
l_column := p_coldata.FIRST;
l_first_col := TRUE;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method IN ('C','T') THEN
l_sql := l_sql||CASE l_first_col WHEN FALSE THEN ',' END||get_rename_column_name(l_column)||' = NULL';
l_first_col := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
l_sql := l_sql||' WHERE ';
l_column := p_coldata.FIRST;
l_first_col := TRUE;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method IN ('C','T') THEN
l_sql := l_sql||CASE l_first_col WHEN FALSE THEN ' OR ' END||get_rename_column_name(l_column)||' IS NOT NULL';
l_first_col := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
BEGIN
debug_dtl('Null columns for data type change',l_sql);
EXECUTE IMMEDIATE l_sql;
debug_dtl_success;
EXCEPTION WHEN OTHERS THEN
debug_dtl_error(DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RAISE DTL_EXCEPTION;
END;
END set_orig_null;
PROCEDURE update_decreasing_varchar(p_coldata coltbl, p_table VARCHAR2) IS
l_sql CLOB := NULL;
l_column VARCHAR2(30);
l_first_col BOOLEAN := TRUE;
BEGIN
l_column := p_coldata.FIRST;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).data_type = 'VARCHAR2' AND p_coldata(l_column).method = 'I' AND p_coldata(l_column).data_precision_length < p_coldata(l_column).tmp_precision_length THEN
IF l_first_col THEN
l_sql := 'UPDATE '||p_table||' SET ';
END IF;
l_sql := l_sql||CASE l_first_col WHEN FALSE THEN ',' END||get_rename_column_name(l_column)||' = SUBSTR('||get_rename_column_name(l_column)||',1,'||p_coldata(l_column).data_precision_length||')';
l_first_col := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
l_column := p_coldata.FIRST;
l_first_col := TRUE;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).data_type = 'VARCHAR2' AND p_coldata(l_column).method = 'I' AND p_coldata(l_column).data_precision_length < p_coldata(l_column).tmp_precision_length THEN
IF l_first_col THEN
l_sql := l_sql||' WHERE ';
END IF;
l_sql := l_sql||CASE l_first_col WHEN FALSE THEN ' OR ' END||'LENGTH('||get_rename_column_name(l_column)||') > '||p_coldata(l_column).data_precision_length;
l_first_col := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
IF l_sql IS NOT NULL THEN
BEGIN
debug_dtl('Perform in-place update for decreasing varchar2 length',l_sql);
EXECUTE IMMEDIATE l_sql;
debug_dtl_success;
EXCEPTION WHEN OTHERS THEN
debug_dtl_error(DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RAISE DTL_EXCEPTION;
END;
END IF;
END update_decreasing_varchar;
PROCEDURE modify_precisions(p_coldata coltbl, p_table VARCHAR2) IS
l_sql CLOB := NULL;
l_column VARCHAR2(30);
l_first_col BOOLEAN := TRUE;
BEGIN
l_column := p_coldata.FIRST;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method != 'N' AND get_data_type(p_coldata(l_column).data_type, p_coldata(l_column).data_precision_length, p_coldata(l_column).data_scale) != get_data_type(p_coldata(l_column).tmp_type, p_coldata(l_column).tmp_precision_length, p_coldata(l_column).tmp_scale) THEN
IF l_first_col AND l_sql IS NULL THEN
l_sql := 'ALTER TABLE '||p_table||' MODIFY (';
END IF;
l_sql := l_sql||CASE l_first_col WHEN FALSE THEN ',' END||get_rename_column_name(l_column)||' '||get_data_type(p_coldata(l_column).data_type, p_coldata(l_column).data_precision_length, p_coldata(l_column).data_scale);
l_first_col := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
IF l_sql IS NOT NULL THEN
l_sql := l_sql||')';
BEGIN
debug_dtl('Modify column precisions',l_sql);
EXECUTE IMMEDIATE l_sql;
debug_dtl_success;
EXCEPTION WHEN OTHERS THEN
debug_dtl_error(DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RAISE DTL_EXCEPTION;
END;
END IF;
END modify_precisions;
FUNCTION is_orig_populated(p_coldata coltbl, p_table VARCHAR2) RETURN BOOLEAN IS
l_column       VARCHAR2(30);
l_rtn BOOLEAN;
l_sql CLOB;
l_first_column BOOLEAN := TRUE;
l_dummy VARCHAR2(1);
BEGIN
l_column := p_coldata.FIRST;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method IN ('C','T') THEN
IF l_sql IS NULL THEN
l_sql := 'SELECT '||case when p_parallel > 1 THEN '/*+ parallel(t '||p_parallel||') */ ' end||'NULL FROM '||p_table||' t WHERE ';
END IF;
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ' OR ' END||get_rename_column_name(l_column)||' IS NOT NULL';
l_first_column := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
IF l_sql IS NOT NULL THEN
l_sql := l_sql||' AND ROWNUM = 1';
BEGIN
debug_dtl('Querying whether original columns have been populated',l_sql);
EXECUTE IMMEDIATE l_sql INTO l_dummy;
debug_dtl_success;
l_rtn := TRUE;
EXCEPTION WHEN NO_DATA_FOUND THEN l_rtn := FALSE;
WHEN OTHERS THEN
debug_dtl_error(DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RAISE DTL_EXCEPTION;
END;
ELSE
RAISE_APPLICATION_ERROR(-20004,'Requested to check if Original column(s) are populated, but we do not need Out Of Place processing.');
END IF;
RETURN l_rtn;
END is_orig_populated;
PROCEDURE populate_orig_from_tmp(p_coldata coltbl, p_table VARCHAR2, l_use_ctas BOOLEAN) IS
l_sql CLOB := NULL;
l_column VARCHAR2(30);
l_first_column BOOLEAN := TRUE;
BEGIN
IF l_use_ctas THEN
l_sql := 'UPDATE '||case when p_parallel > 1 THEN '/*+ enable_parallel_dml */ ' end||'(SELECT '||case when p_parallel > 1 THEN '/*+ parallel('||ceil(p_parallel/2)||') */ ' end;
l_column := p_coldata.FIRST;
l_first_column := TRUE;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method = 'T' THEN
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ',' END||'o.'||get_rename_column_name(l_column)||',n.'||get_temp_column_name(l_column, p_use_ctas);
l_first_column := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
l_sql := l_sql||' FROM '||p_table||' o JOIN '||get_temp_table_name(p_table,p_use_ctas)||' n ON (';
l_first_column := TRUE;
FOR pk IN (SELECT column_name FROM user_constraints c join user_cons_columns cc on (cc.constraint_name = c.constraint_name) where c.table_name = UPPER(p_table) and c.constraint_type = 'P' order by position) LOOP
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ' AND ' END||'o.'||pk.column_name||' = n.'||pk.column_name;
l_first_column := FALSE;
END LOOP;
l_sql := l_sql||') ) SET ';
l_column := p_coldata.FIRST;
l_first_column := TRUE;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method = 'T' THEN
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ',' END||get_rename_column_name(l_column)||' = '||get_temp_column_name(l_column, p_use_ctas);
l_first_column := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
BEGIN
debug_dtl('Populate original columns from Out of place table',l_sql);
EXECUTE IMMEDIATE l_sql;
debug_dtl_success;
EXCEPTION WHEN OTHERS THEN
debug_dtl_error(DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RAISE DTL_EXCEPTION;
END;
ELSE
l_sql := 'UPDATE '||p_table||' SET ';
l_column := p_coldata.FIRST;
l_first_column := TRUE;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method = 'C' THEN
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ',' END||get_rename_column_name(l_column)||' = '||get_temp_column_name(l_column, p_use_ctas);
l_first_column := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
l_sql := l_sql||' WHERE ';
l_column := p_coldata.FIRST;
l_first_column := TRUE;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method = 'C' THEN
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ' OR ' END||get_temp_column_name(l_column, p_use_ctas)||' IS NOT NULL';
l_first_column := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
BEGIN
debug_dtl('Populate original columns from Out of place columns',l_sql);
EXECUTE IMMEDIATE l_sql;
debug_dtl_success;
EXCEPTION WHEN OTHERS THEN
debug_dtl_error(DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RAISE DTL_EXCEPTION;
END;
END IF;
END populate_orig_from_tmp;
PROCEDURE drop_tmp(p_coldata coltbl, p_table VARCHAR2, l_use_ctas BOOLEAN, p_set_unused BOOLEAN) IS
l_sql CLOB := NULL;
l_column VARCHAR2(30);
l_first_column BOOLEAN := TRUE;
l_col_list VARCHAR2(4000) := NULL;
l_multi NUMBER;
BEGIN
l_first_column := TRUE;
FOR pk IN (SELECT column_name FROM user_constraints c join user_cons_columns cc on (cc.constraint_name = c.constraint_name) where c.table_name = UPPER(p_table) and c.constraint_type = 'P' order by position) LOOP
l_col_list := l_col_list||CASE l_first_column WHEN FALSE THEN ',' END||pk.column_name;
l_first_column := FALSE;
END LOOP;
l_sql := 'ALTER TABLE '||get_temp_table_name(p_table,l_use_ctas)||' '||CASE WHEN p_set_unused THEN 'SET UNUSED' ELSE 'DROP' END||' (';
l_column := p_coldata.FIRST;
l_first_column := TRUE;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method IN ('C','T') THEN
l_sql := l_sql||CASE l_first_column WHEN FALSE THEN ',' END||get_temp_column_name(l_column,l_use_ctas);
l_col_list := l_col_list||CASE WHEN l_col_list IS NOT NULL THEN ',' END||UPPER(l_column);
l_first_column := FALSE;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
l_sql := l_sql||')';
IF l_use_ctas THEN
DECLARE l_temp_table VARCHAR2(30) := get_temp_table_name(p_table,l_use_ctas);
BEGIN
EXECUTE IMMEDIATE 'LOCK TABLE '||l_temp_table||' IN EXCLUSIVE MODE';
SELECT COUNT(*) INTO l_multi FROM user_tab_columns WHERE table_name = l_temp_table AND ','||l_col_list||',' NOT LIKE '%,'||column_name||',%';
IF l_multi = 0 THEN
BEGIN
debug_dtl('Dropping Out of place table','DROP TABLE '||l_temp_table||' PURGE');
EXECUTE IMMEDIATE 'DROP TABLE '||l_temp_table||' PURGE';
debug_dtl_success;
EXCEPTION WHEN OTHERS THEN
debug_dtl_error(DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RAISE DTL_EXCEPTION;
END;
END IF;
END;
END IF;
IF NOT l_use_ctas OR l_multi > 0 THEN
BEGIN
debug_dtl('Dropping Out of place columns',l_sql);
EXECUTE IMMEDIATE l_sql;
debug_dtl_success;
EXCEPTION WHEN OTHERS THEN
debug_dtl_error(DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RAISE DTL_EXCEPTION;
END;
END IF;
END drop_tmp;
PROCEDURE rename_orig(p_coldata coltbl, p_table VARCHAR2) IS
l_sql CLOB := NULL;
l_column VARCHAR2(30);
BEGIN
l_column := p_coldata.FIRST;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method != 'N' THEN
BEGIN
debug_dtl('Renaming column '||get_rename_column_name(l_column)||'->'||l_column,'ALTER TABLE '||p_table||' RENAME COLUMN '||get_rename_column_name(l_column)||' TO '||l_column);
EXECUTE IMMEDIATE 'ALTER TABLE '||p_table||' RENAME COLUMN '||get_rename_column_name(l_column)||' TO '||l_column;
debug_dtl_success;
EXCEPTION WHEN OTHERS THEN
debug_dtl_error(DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RAISE DTL_EXCEPTION;
END;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
END rename_orig;
PROCEDURE modify_types (p_coldata coltbl, p_table VARCHAR2, p_set_unused BOOLEAN) IS
l_column       VARCHAR2(30);
l_use_out_of_place      BOOLEAN := FALSE;
l_create_out_of_place   BOOLEAN := FALSE;
l_use_ctas              BOOLEAN := FALSE;
l_populate_out_of_place BOOLEAN := TRUE;
l_null_orig             BOOLEAN := FALSE;
l_populate_orig         BOOLEAN := TRUE;
l_action                VARCHAR2(1) := NULL;
BEGIN
-- tmp_renamed            VARCHAR2(1),        -- N (No), Y (Yes)
-- new_renamed            VARCHAR2(1),        -- N (No), C (Column), T (Table)
-- method                 VARCHAR2(1)         -- N (None), I (In Place), C (Out of Place - Column), T (Out of Place - Table)
l_column := p_coldata.FIRST;
WHILE l_column IS NOT NULL LOOP
IF p_coldata(l_column).method != 'N' AND p_coldata(l_column).tmp_renamed != 'Y' THEN
BEGIN
debug_dtl('Renaming column '||l_column||'->'||get_rename_column_name(l_column),'ALTER TABLE '||p_table||' RENAME COLUMN '||l_column||' TO '||get_rename_column_name(l_column));
EXECUTE IMMEDIATE 'ALTER TABLE '||p_table||' RENAME COLUMN '||l_column||' TO '||get_rename_column_name(l_column);
debug_dtl_success;
EXCEPTION WHEN OTHERS THEN
debug_dtl_error(DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RAISE DTL_EXCEPTION;
END;
END IF;
IF p_coldata(l_column).method IN ('C','T') THEN
IF p_coldata(l_column).new_renamed = 'N' THEN
l_create_out_of_place := TRUE;
END IF;
l_use_out_of_place := TRUE;
IF  get_data_type(p_coldata(l_column).data_type, p_coldata(l_column).data_precision_length, p_coldata(l_column).data_scale) != get_data_type(p_coldata(l_column).tmp_type, p_coldata(l_column).tmp_precision_length, p_coldata(l_column).tmp_scale) THEN
l_null_orig := TRUE;
END IF;
IF p_coldata(l_column).method = 'T' THEN l_use_ctas := TRUE; END IF;
END IF;
IF l_action IS NULL AND p_coldata(l_column).method IN ('C','T') THEN
l_action := p_coldata(l_column).action;
END IF;
l_column := p_coldata.NEXT(l_column);
END LOOP;
IF NVL(l_action,'A') = 'A' THEN
IF l_create_out_of_place THEN
create_out_of_place(p_coldata, p_table);
ELSIF l_use_out_of_place THEN
-- This means the out of place table/column had already been created during a prior execution
-- Implying also that all columns were successfully renamed
l_populate_out_of_place := NOT is_oop_populated(p_coldata, p_table, l_use_ctas);
END IF;
	
IF l_use_out_of_place AND l_populate_out_of_place THEN
-- We either just created out-of-place, or it already existed and all values were NULL
populate_tmp(coldata, p_table, l_use_ctas);
END IF;
	
IF l_use_out_of_place AND (l_create_out_of_place OR l_populate_out_of_place OR l_null_orig) THEN
-- If we created or populated the Tmp Tbl/Col then clearly we need to null the original columns
-- But if Tmp was previously populated, and we haven't yet modified the data type, then we will null the columns (same cost to null as to query for values against all nulls)
set_orig_null(coldata, p_table);
ELSIF l_use_out_of_place THEN
-- defaults to TRUE.  The only time we may not need to populate is when out of place was already populated previously, i.e. we didn't just set values to null
l_populate_orig := NOT is_orig_populated(p_coldata, p_table);
END IF;
	
-- These are coded such that if all columns are already the required datatype then they do nothing.
update_decreasing_varchar(coldata, p_table);
modify_precisions(coldata, p_table);
	
IF l_use_out_of_place THEN
IF l_populate_orig THEN
populate_orig_from_tmp(coldata, p_table, l_use_ctas);
END IF;
drop_tmp(coldata, p_table, l_use_ctas, p_set_unused);
END IF;
ELSE
-- Rolling Back
-- Tmp Tables already exist, Columns are already renamed
IF NOT is_orig_populated(p_coldata, p_table) THEN
populate_orig_from_tmp(coldata, p_table, l_use_ctas);
END IF;
IF l_null_orig THEN
-- Means the *_ORIG column datatype is not at the desired specification (meaning it was changed during the prior execution).
update_decreasing_varchar(coldata, p_table);
modify_precisions(coldata, p_table);
END IF;
drop_tmp(coldata, p_table, l_use_ctas, p_set_unused);
END IF;
rename_orig(coldata, p_table);
END modify_types;
BEGIN
debug_hdr('CHANGE_PRECISION_SCALE', 'Table Name: '||p_table_name||'
'          ||'Change List: '||p_change_list||'
'          ||'Increase only: '||CASE WHEN p_increase_only THEN 'True' ELSE 'False' END||', Use CTAS: '||CASE WHEN p_use_ctas THEN 'True' ELSE 'False' END
);
is_release := get_is_release;
IF p_use_ctas THEN
l_use_ctas := TRUE;
DECLARE l_dummy VARCHAR2(1);
BEGIN SELECT NULL INTO l_dummy FROM user_constraints WHERE table_name = UPPER(p_table_name) AND constraint_type = 'P';
EXCEPTION WHEN NO_DATA_FOUND THEN l_use_ctas := FALSE;
END;
ELSE l_use_ctas := FALSE;
END IF;
process_change_list(coldata, p_change_list);
set_renamed(coldata, p_table_name);
set_method(coldata, p_table_name, p_increase_only, l_use_ctas, is_release);
validate_data(coldata, l_use_ctas);
modify_types(coldata, p_table_name, is_release AND p_set_unused);
debug_hdr_success;
EXCEPTION
WHEN DTL_EXCEPTION THEN
debug_hdr_error('See error in pdx_schema_upd_helper_debug_d');
RAISE_APPLICATION_ERROR(-20001,'Error from SQL Execution, Logged in pdx_schema_upd_helper_debug_d');
WHEN OTHERS THEN
debug_hdr_error(DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RAISE_APPLICATION_ERROR(-20001,'Error not involving SQL Execution, Logged in pdx_schema_upd_helper_debug_h');
END change_precision_scale;
PROCEDURE drop_column (p_table_name VARCHAR2, p_drop_list VARCHAR2) IS
is_release BOOLEAN;
BEGIN
is_release := get_is_release;
IF is_release THEN
EXECUTE IMMEDIATE 'ALTER TABLE '||UPPER(p_table_name)||' SET UNUSED ('||p_drop_list||')';
ELSE
EXECUTE IMMEDIATE 'ALTER TABLE '||UPPER(p_table_name)||' DROP ('||p_drop_list||')';
END IF;
END drop_column;
PROCEDURE drop_unused (p_table_name VARCHAR2 := NULL) IS
BEGIN
FOR rec IN (SELECT table_name FROM user_unused_col_tabs WHERE p_table_name IS NULL OR table_name = p_table_name) LOOP
EXECUTE IMMEDIATE 'ALTER TABLE '||rec.table_name||' DROP UNUSED COLUMNS';
END LOOP;
END drop_unused;
end pkg_pdx_schema_updater_helper;

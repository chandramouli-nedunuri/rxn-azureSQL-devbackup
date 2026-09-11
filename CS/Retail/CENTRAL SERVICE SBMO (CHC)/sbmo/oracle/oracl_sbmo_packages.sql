CREATE OR REPLACE PACKAGE SBMO.CS_SUPPORT
IS
PROCEDURE dbu_allocated_qty
(p_allocatedqty   IN NUMBER DEFAULT NULL,
	p_tenantid   IN NUMBER DEFAULT NULL,
	p_ndc   IN NUMBER DEFAULT NULL,
p_inventoryid        IN NUMBER DEFAULT NULL);
END cs_support;

/
CREATE OR REPLACE PACKAGE BODY SBMO.CS_SUPPORT
IS
excp_no_id         EXCEPTION;
excp_rowcount  EXCEPTION;
excp_rowcount_zero EXCEPTION;
excp_no_tenant  EXCEPTION;
excp_no_allocatedqty  EXCEPTION;
	excp_no_ndc EXCEPTION;
	excp_ndc_notnumber EXCEPTION;
	
FUNCTION log_audit_dbu (p_dbu_table varchar2,
p_dbu_parms varchar2,
						p_dbu_rows number,
p_sql_text varchar2) return number
IS
l_id number;
BEGIN
-- *****************************************************************************
-- For compliance and support reasons, log the execution of the DBU
-- *****************************************************************************
insert into audit_dbu_log (id, exec_time_stamp, user_id, dbu_table, dbu_parms, dbu_rows, sql_text)
values (audit_dbu_log_seq.nextval, systimestamp, sys_context('userenv','session_user'), upper(p_dbu_table),
p_dbu_parms, p_dbu_rows, p_sql_text)
returning id into l_id;
commit;
return l_id;
END log_audit_dbu;
PROCEDURE log_error (l_id number, p_error varchar2)
IS
BEGIN
update audit_dbu_log set error_text = p_error where id = l_id;
commit;
END log_error;
PROCEDURE dbu_allocated_qty
(p_allocatedqty   IN NUMBER DEFAULT NULL,
	p_tenantid   IN NUMBER DEFAULT NULL,
	p_ndc   IN NUMBER DEFAULT NULL,
p_inventoryid        IN NUMBER DEFAULT NULL)
	 IS
-- This should update one and only one row per execution
v_rowsexp          NUMBER            := 1;
v_rowsproc         NUMBER;
v_sql              VARCHAR2(2000);
l_id               number;
BEGIN
-- *****************************************************************************
-- A value must be provided for ALLOCATED_QTY
-- *****************************************************************************
IF p_allocatedqty IS NULL THEN
RAISE excp_no_allocatedqty;
END IF;
	
-- *****************************************************************************
-- The tenant id MUST be specified in order for this to execute
-- *****************************************************************************
IF p_tenantid IS NULL THEN
RAISE excp_no_tenant;
END IF;
-- *****************************************************************************
-- The value for ndc must not be null
-- *****************************************************************************
IF p_ndc IS NULL THEN
RAISE excp_no_ndc;
END IF;
	
-- *****************************************************************************
-- The value for ndc must be a number
-- *****************************************************************************
if( regexp_like( p_ndc, '^[[:digit:]]+$') ) then
dbms_output.put_line( p_ndc || ' is numeric' );
else
RAISE excp_ndc_notnumber;
end if;
-- *****************************************************************************
-- The inventory id must also be specified
-- *****************************************************************************
IF p_inventoryid IS NULL THEN
RAISE excp_no_id;
END IF;
-- *****************************************************************************
-- The SQL performs an UPDATE to the ALLOCATED_QTY on the FORMULARY table.
-- *****************************************************************************
v_sql := 'UPDATE FORMULARY set ALLOCATED_QTY=:ALLOCATED_QTY' || ' where tenant_id=:tenant_id and ndc=:ndc and inventory_id=:inventory_id';
l_id := log_audit_dbu (p_dbu_table => 'FORMULARY',
p_dbu_parms => 'ALLOCATED_QTY = '||p_allocatedqty||', tenant_id = '||p_tenantid||', ndc = '||p_ndc||', inventory_id = '||p_inventoryid,
						p_dbu_rows => v_rowsexp,
p_sql_text => v_sql || chr(10) || 'Using: ' || p_allocatedqty || ', ' || p_tenantid || ', ' || p_ndc || ', ' || p_inventoryid);
	EXECUTE IMMEDIATE v_sql USING p_allocatedqty, p_tenantid, p_ndc, p_inventoryid;
-- *****************************************************************************
-- Get the number of rows affected from the update and make sure that it only updates
-- one row.  If not, then ROLLBACK; otherwise COMMIT.
-- *****************************************************************************
v_rowsproc := SQL%ROWCOUNT;
IF v_rowsproc > 1 THEN
ROLLBACK;
RAISE excp_rowcount;
	ELSIF v_rowsproc = 0 THEN
	   RAISE excp_rowcount_zero;
ELSE
DBMS_OUTPUT.PUT_LINE('Processed '||v_rowsproc||' row as expected.');
COMMIT;
END IF;
-- *****************************************************************************
-- Error handling
-- *****************************************************************************
EXCEPTION
WHEN excp_no_tenant THEN
	  log_error (l_id, 'DBU [FORMULARY] Tenant ID must have a value');
RAISE_APPLICATION_ERROR(-20400,'DBU [FORMULARY] Tenant ID must have a value');
WHEN excp_no_id THEN
	  log_error (l_id, 'DBU [FORMULARY] Must input a valid inventory ID');
RAISE_APPLICATION_ERROR(-20401,'DBU [FORMULARY] Must input a valid inventory ID');
WHEN excp_rowcount THEN
	  log_error (l_id, 'DBU [FORMULARY] Affected dataset after UPDATE should only be 1 row');
RAISE_APPLICATION_ERROR(-20402,'DBU [FORMULARY] Affected dataset after UPDATE should only be 1 row');
WHEN excp_rowcount_zero THEN
	  log_error (l_id, 'DBU [FORMULARY] Affected zero rows when one updated row was expected');
RAISE_APPLICATION_ERROR(-20403,'DBU [FORMULARY] Affected zero rows when one updated row was expected');
WHEN excp_no_allocatedqty THEN
	  log_error (l_id, 'DBU [FORMULARY] Allocated Quantity must have a value');
RAISE_APPLICATION_ERROR(-20404,'DBU [FORMULARY] Allocated Quantity must have a value');
	WHEN excp_no_ndc THEN
	  log_error (l_id, 'DBU [FORMULARY] NDC must have a value');
RAISE_APPLICATION_ERROR(-20405,'DBU [FORMULARY] NDC must have a value');
	WHEN excp_ndc_notnumber THEN
	  log_error (l_id, 'DBU [FORMULARY] NDC must be a number');
RAISE_APPLICATION_ERROR(-20406,'DBU [FORMULARY] NDC must be a number');
WHEN OTHERS THEN
log_error (l_id, 'DBU [FORMULARY] unhandled exception encountered:' || chr(10) || DBMS_UTILITY.FORMAT_ERROR_STACK() || chr(10) ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
RAISE_APPLICATION_ERROR(-20407,'DBU [FORMULARY] unhandled exception encountered:' || chr(10) || DBMS_UTILITY.FORMAT_ERROR_STACK() || chr(10) ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
	END dbu_allocated_qty;
END CS_SUPPORT;

/
CREATE OR REPLACE PACKAGE      SBMO.PKG_PDX_SCHEMA_UPDATER AS
-- Upgrades application schema from current_version to target_version
-- p_allow_downgrade will override config.AllowDowngrade.
PROCEDURE update_schema (p_target_version    IN       VARCHAR2,
p_return_code       OUT      NUMBER,
p_allow_downgrade   IN       BOOLEAN := NULL
);
PROCEDURE grant_privs_on_own_objs;
PROCEDURE create_synonyms_on_own_objs;
FUNCTION schema_version RETURN VARCHAR2;
FUNCTION updater_version RETURN VARCHAR2;
-- >1 if p_version1 > p_version2 ; 0 if p_version1 = p_version2 ; <1 if p_version1 < p_version2
FUNCTION compare_versions ( p_version1 VARCHAR2, p_version2 VARCHAR2 ) RETURN NUMBER;
-- The following functions should not be used on a production system
-- They are only intended for development/QA systems
PROCEDURE convert_to_task;
PROCEDURE convert_to_release (p_version VARCHAR2 := NULL);
END PKG_PDX_SCHEMA_UPDATER;

/
CREATE OR REPLACE PACKAGE BODY      SBMO.PKG_PDX_SCHEMA_UPDATER AS
g_version CONSTANT VARCHAR2(4) := '1.03';
TYPE typ_error_record IS RECORD (
ERROR_MESSAGE            VARCHAR2(200),
SQL_ERROR_CODE           VARCHAR2(20),
SQL_ERROR_MESSAGE        VARCHAR2(4000)
);
TYPE typ_config_record IS RECORD (
APPLY_TYPE               VARCHAR2(10),
TASK_VERSION             VARCHAR2(20),
APPLICATION_PREFIX       VARCHAR2(50),
MANAGE_PRIVS             VARCHAR2(1),
MANAGE_SYNONYMS          VARCHAR2(1),
ALLOW_DOWNGRADE          NUMBER(2),
MANAGE_SYNONYMS_FOR      VARCHAR2(255),
AUTO_UNDO                VARCHAR2(1)
);
g_config_record typ_config_record;
TYPE ddl_sql_type IS TABLE OF CLOB INDEX BY BINARY_INTEGER;
TYPE task_tbl IS TABLE OF VARCHAR2(255) INDEX BY VARCHAR2(50);
TYPE ind_tbl IS TABLE OF VARCHAR2(255) INDEX BY BINARY_INTEGER;
FUNCTION schema_version RETURN VARCHAR2 IS
l_rtn VARCHAR2(23);
BEGIN
SELECT target_version
INTO l_rtn
FROM pdx_schema_version_history
WHERE id = (SELECT MAX(id)
FROM pdx_schema_version_history
WHERE status_code = 'S'
);
RETURN l_rtn;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END schema_version;
FUNCTION updater_version RETURN VARCHAR2 IS
BEGIN
RETURN g_version;
END updater_version;
FUNCTION error_record ( p_msg VARCHAR2, p_code VARCHAR2, p_err VARCHAR2 ) RETURN typ_error_record IS
l_rtn typ_error_record;
BEGIN
l_rtn.ERROR_MESSAGE := p_msg;
l_rtn.SQL_ERROR_CODE := p_code;
l_rtn.SQL_ERROR_MESSAGE := p_err;
RETURN l_rtn;
END;
FUNCTION is_error_record_empty ( p_record typ_error_record ) RETURN BOOLEAN IS
BEGIN
RETURN p_record.error_message IS NULL AND p_record.sql_error_code IS NULL AND p_record.sql_error_message IS NULL;
END is_error_record_empty;
PROCEDURE refresh_config IS
FUNCTION get_yn ( p_value VARCHAR2 ) RETURN VARCHAR2 IS
BEGIN
RETURN CASE WHEN regexp_count(p_value,'^\s*(y|yes|t|true)\s*$',1,'i') = 1 THEN 'Y' ELSE 'N' END;
END;
function get_num ( p_val varchar2 ) return number is
invalid_number exception;
pragma exception_init(invalid_number,-6502);
l_rtn number;
begin
IF get_yn(p_val) = 'Y' then l_rtn := -1;
ELSE
BEGIN
l_rtn := to_number(p_val);
exception
when invalid_number then l_rtn := 0;
end;
END IF;
return l_rtn;
end;
FUNCTION get_value ( p_key VARCHAR2 ) RETURN VARCHAR2 IS
l_rtn pdx_schema_config.value%TYPE;
BEGIN
SELECT value INTO l_rtn FROM pdx_schema_config WHERE key = p_key;
RETURN l_rtn;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END;
BEGIN
g_config_record.APPLY_TYPE := UPPER(get_value('APPLYTYPE'));
g_config_record.TASK_VERSION := get_value('TASKVERSION');
g_config_record.APPLICATION_PREFIX := LOWER(get_value('APPLICATIONPREFIX'));
g_config_record.MANAGE_PRIVS := NVL(get_yn(get_value('MANAGEPRIVS')),'N');
g_config_record.MANAGE_SYNONYMS := NVL(get_yn(get_value('MANAGESYNONYMS')),'N');
g_config_record.MANAGE_SYNONYMS_FOR := TRIM(get_value('MANAGESYNONYMSFOR'));
IF g_config_record.MANAGE_SYNONYMS = 'N' OR g_config_record.MANAGE_SYNONYMS_FOR IS NULL THEN
g_config_record.MANAGE_SYNONYMS := 'N';
g_config_record.MANAGE_SYNONYMS_FOR := NULL;
END IF;
g_config_record.ALLOW_DOWNGRADE := NVL(get_num(get_value('ALLOWDOWNGRADE')),0);
g_config_record.AUTO_UNDO := NVL(get_yn(get_value('AUTOUNDO')),'N');
	END refresh_config;
FUNCTION get_config ( p_key VARCHAR2 ) RETURN VARCHAR2 IS
BEGIN
IF g_config_record.APPLY_TYPE IS NULL THEN refresh_config; END IF;
CASE p_key
WHEN 'APPLY_TYPE'           THEN RETURN g_config_record.APPLY_TYPE;
WHEN 'TASK_VERSION'         THEN RETURN g_config_record.TASK_VERSION;
WHEN 'APPLICATION_PREFIX'   THEN RETURN g_config_record.APPLICATION_PREFIX;
WHEN 'MANAGE_PRIVS'         THEN RETURN g_config_record.MANAGE_PRIVS;
WHEN 'MANAGE_SYNONYMS'      THEN RETURN g_config_record.MANAGE_SYNONYMS;
WHEN 'ALLOW_DOWNGRADE'      THEN RETURN g_config_record.ALLOW_DOWNGRADE;
WHEN 'MANAGE_SYNONYMS_FOR'  THEN RETURN g_config_record.MANAGE_SYNONYMS_FOR;
WHEN 'AUTO_UNDO'            THEN RETURN g_config_record.AUTO_UNDO;
ELSE RAISE_APPLICATION_ERROR(-20100,'Invalid Key requested in get_config');
END CASE;
END get_config;
FUNCTION compare_versions (p_version1 VARCHAR2, p_version2 VARCHAR2) RETURN NUMBER IS
l_rtn NUMBER;
BEGIN
IF p_version1 IS NULL AND p_version2 IS NULL THEN l_rtn := 0;
ELSIF p_version1 IS NULL THEN l_rtn := -1;
ELSIF p_version2 IS NULL THEN l_rtn := 1;
ELSE
SELECT NVL(MAX(CASE WHEN version = p_version1 THEN apply_order END),0) - NVL(MAX(CASE WHEN version = p_version2 THEN apply_order END),0)
INTO l_rtn
FROM vw_schema_updater_manifest
WHERE version IN (p_version1, p_version2);
END IF;
RETURN l_rtn;
END compare_versions;
FUNCTION get_metadata ( p_file_or_task VARCHAR2, p_parameter VARCHAR2, p_source VARCHAR2 ) RETURN VARCHAR2 IS
BEGIN
RETURN pkg_pdx_schema_updater_meta.get_metadata(p_file_or_task, p_parameter, CASE p_source WHEN 'U' THEN 'B' WHEN 'A' THEN 'B' WHEN 'D' THEN 'A' WHEN 'R' THEN 'A' ELSE p_source END);
END get_metadata;
FUNCTION get_metadata_tbl ( p_file_or_task VARCHAR2, p_parameter VARCHAR2, p_source VARCHAR2 ) RETURN pkg_pdx_schema_updater_meta.results_tbl IS
BEGIN
RETURN pkg_pdx_schema_updater_meta.get_metadata_tbl(p_file_or_task, p_parameter, CASE p_source WHEN 'U' THEN 'B' WHEN 'A' THEN 'B' WHEN 'D' THEN 'A' WHEN 'R' THEN 'A' ELSE p_source END);
END get_metadata_tbl;
FUNCTION get_metadata_by_val ( p_file_or_task VARCHAR2, p_parameter VARCHAR2, p_source VARCHAR2 ) RETURN VARCHAR2 IS
BEGIN
RETURN pkg_pdx_schema_updater_meta.get_metadata_by_val(p_file_or_task, p_parameter, CASE p_source WHEN 'U' THEN 'B' WHEN 'A' THEN 'B' WHEN 'D' THEN 'A' WHEN 'R' THEN 'A' ELSE p_source END);
END get_metadata_by_val;
FUNCTION get_metadata_tbl_by_val ( p_file_or_task VARCHAR2, p_parameter VARCHAR2, p_source VARCHAR2 ) RETURN pkg_pdx_schema_updater_meta.results_tbl IS
BEGIN
RETURN pkg_pdx_schema_updater_meta.get_metadata_tbl_by_val(p_file_or_task, p_parameter, CASE p_source WHEN 'U' THEN 'B' WHEN 'A' THEN 'B' WHEN 'D' THEN 'A' WHEN 'R' THEN 'A' ELSE p_source END);
END get_metadata_tbl_by_val;
FUNCTION get_tasktype(p_filename VARCHAR2, p_action VARCHAR2) RETURN VARCHAR2 IS
BEGIN
RETURN NVL(UPPER(get_metadata(p_filename,'TASKTYPE',p_action)),UPPER(get_config('APPLICATION_PREFIX')));
END;
	  FUNCTION get_sql ( p_fname VARCHAR2, p_action VARCHAR2 ) RETURN CLOB IS
l_sql CLOB;
BEGIN
SELECT CASE WHEN p_action IN ('R','D') THEN s1.sql
WHEN NVL(status_code,'S') != 'S' THEN s1.sql
ELSE s2.sql
END
INTO l_sql
FROM pdx_schema_updater_sql s1
FULL OUTER JOIN schema_updater_sql s2 USING (file_name)
WHERE file_name = p_fname;
		IF l_sql IS NULL THEN RAISE NO_DATA_FOUND; END IF;
RETURN l_sql;
END get_sql;
FUNCTION get_index ( p_fname VARCHAR2, p_action VARCHAR2 ) RETURN NUMBER IS
l_index NUMBER;
BEGIN
SELECT CASE WHEN p_action IN ('R','D') THEN s1.statement_index
WHEN NVL(status_code,'S') != 'S' THEN s1.statement_index
ELSE NULL
END
INTO l_index
FROM pdx_schema_updater_sql s1
FULL OUTER JOIN schema_updater_sql s2 USING (file_name)
WHERE file_name = p_fname;
RETURN l_index;
END get_index;
FUNCTION get_status ( p_fname VARCHAR2 ) RETURN VARCHAR2 IS
l_status VARCHAR2(2);
BEGIN
BEGIN
SELECT action_code||status_code
INTO l_status
FROM pdx_schema_updater_sql
WHERE file_name = p_fname;
EXCEPTION
WHEN NO_DATA_FOUND THEN l_status := NULL;
END;
RETURN l_status;
END get_status;
FUNCTION log_call_start ( p_target_version IN VARCHAR2 ) RETURN NUMBER IS
l_rtn NUMBER;
BEGIN
INSERT INTO pdx_schema_upd_pkgcall_hist ( ID, TARGET_VERSION, STATUS_CODE, START_DATE )
VALUES ( PDX_SCHEMA_MASTER_SEQ.NEXTVAL, p_target_version, 'I', SYSTIMESTAMP )
RETURNING ID INTO l_rtn;
COMMIT;
RETURN l_rtn;
END log_call_start;
FUNCTION log_call_end ( p_call_id NUMBER, p_rc NUMBER, p_status VARCHAR2, p_error_record typ_error_record ) RETURN NUMBER IS
BEGIN
UPDATE pdx_schema_upd_pkgcall_hist SET status_code = p_status, end_date = SYSTIMESTAMP, return_code = p_rc WHERE id = p_call_id;
IF NOT is_error_record_empty(p_error_record) THEN
INSERT INTO PDX_SCHEMA_UPD_PKGCALL_ERR_LOG ( id, error_message, sql_error_code, sql_error_message )
VALUES ( p_call_id, p_error_record.error_message, p_error_record.sql_error_code, p_error_record.sql_error_message );
END IF;
COMMIT;
RETURN p_rc;
END log_call_end;
FUNCTION log_version_start ( p_call_id NUMBER, p_current_version VARCHAR2, p_target_version VARCHAR2 ) RETURN NUMBER IS
l_rtn NUMBER;
BEGIN
INSERT INTO pdx_schema_version_history ( ID, PDX_SCHEMA_UPD_PKGCALL_HIST_ID, CURRENT_VERSION, TARGET_VERSION, STATUS_CODE, START_DATE )
VALUES ( PDX_SCHEMA_MASTER_SEQ.NEXTVAL, p_call_id, p_current_version, p_target_version, 'I', SYSTIMESTAMP )
RETURNING ID INTO l_rtn;
COMMIT;
RETURN l_rtn;
END log_version_start;
PROCEDURE log_version_end ( p_version_id NUMBER, p_status VARCHAR2, p_error_record typ_error_record ) IS
BEGIN
UPDATE pdx_schema_version_history SET status_code = p_status, end_date = SYSTIMESTAMP WHERE id = p_version_id;
IF NOT is_error_record_empty(p_error_record) THEN
INSERT INTO PDX_SCHEMA_VERSION_ERROR_LOG ( id, error_message, sql_error_code, sql_error_message )
VALUES ( p_version_id, p_error_record.error_message, p_error_record.sql_error_code, p_error_record.sql_error_message );
END IF;
COMMIT;
END log_version_end;
FUNCTION log_task_start ( p_call_id NUMBER, p_version_id NUMBER, p_filename VARCHAR2, p_action VARCHAR2 ) RETURN NUMBER IS
l_rtn NUMBER;
l_task_type VARCHAR2(20) := get_tasktype(p_filename, p_action);
BEGIN
INSERT INTO pdx_schema_task_history ( ID, PDX_SCHEMA_UPD_PKGCALL_HIST_ID, PDX_SCHEMA_VERSION_HISTORY_ID, FILE_NAME, TASK_TYPE, ACTION_CODE, STATUS_CODE, START_DATE )
VALUES ( PDX_SCHEMA_MASTER_SEQ.NEXTVAL, p_call_id, p_version_id, p_filename, l_task_type, p_action, 'I', SYSTIMESTAMP )
RETURNING ID INTO l_rtn;
COMMIT;
RETURN l_rtn;
END log_task_start;
PROCEDURE log_task_end ( p_task_id NUMBER, p_status VARCHAR2, p_error_record typ_error_record, p_action VARCHAR2 := NULL, p_sql_text CLOB := NULL, p_index NUMBER := NULL ) IS
BEGIN
UPDATE pdx_schema_task_history SET status_code = p_status, action_code = NVL(p_action, action_code), end_date = SYSTIMESTAMP WHERE id = p_task_id;
IF NOT is_error_record_empty(p_error_record) THEN
INSERT INTO PDX_SCHEMA_TASK_ERROR_LOG ( id, error_message, sql_error_code, sql_error_message, sql_text, statement_index )
VALUES ( p_task_id, p_error_record.error_message, p_error_record.sql_error_code, p_error_record.sql_error_message, p_sql_text, p_index );
END IF;
COMMIT;
END;
PROCEDURE log_task_history (p_call_id NUMBER, p_version_id NUMBER, p_filename VARCHAR2, p_action VARCHAR2, p_status VARCHAR2, p_error_record typ_error_record, p_sql_text CLOB := NULL, p_index NUMBER := NULL) IS
l_task_id NUMBER;
BEGIN
l_task_id := log_task_start(p_call_id, p_version_id, p_filename, p_action);
log_task_end(l_task_id, p_status, p_error_record, p_action, p_sql_text, p_index);
END log_task_history;
FUNCTION log_sql_start ( p_call_id NUMBER, p_version_id NUMBER, p_filename VARCHAR2, p_action VARCHAR2 ) RETURN NUMBER IS
l_task_id NUMBER;
l_sql_tmp CLOB;
l_index_tmp NUMBER;
BEGIN
IF pkg_pdx_schema_updater_meta.get_filetype(p_filename) != 'R' THEN
l_task_id := log_task_start(p_call_id, p_version_id, p_filename, p_action);
END IF;
l_sql_tmp := get_sql(p_filename, p_action);
l_index_tmp := get_index(p_filename, p_action);
MERGE INTO pdx_schema_updater_sql tgt USING (SELECT p_filename file_name, target_version FROM pdx_schema_version_history WHERE id = p_version_id) src ON (tgt.file_name = src.file_name)
WHEN MATCHED THEN UPDATE SET tgt.version = CASE WHEN p_action IN ('U','A') THEN src.target_version ELSE tgt.version END, tgt.action_code = p_action, tgt.status_code = 'I', tgt.action_date = SYSTIMESTAMP, tgt.sql = l_sql_tmp, tgt.statement_index = l_index_tmp
WHEN NOT MATCHED THEN INSERT (file_name, version, action_code, status_code, action_date, sql, statement_index)
VALUES (src.file_name, src.target_version, p_action, 'I', SYSTIMESTAMP, l_sql_tmp, l_index_tmp);
pkg_pdx_schema_updater_meta.refresh_metadata_apply(p_filename);
IF pkg_pdx_schema_updater_meta.get_filetype(p_filename) = 'R' AND p_action = 'U' THEN
	    MERGE INTO pdx_schema_updater_manifest tgt USING (SELECT target_version version FROM pdx_schema_version_history WHERE id = p_version_id) src ON (src.version = tgt.version)
		  WHEN NOT MATCHED THEN INSERT (file_name, version, apply_order) VALUES (p_filename, src.version, PDX_SCHEMA_MASTER_SEQ.NEXTVAL)
		  WHEN MATCHED THEN UPDATE SET apply_order = PDX_SCHEMA_MASTER_SEQ.NEXTVAL;
END IF;
COMMIT;
RETURN l_task_id;
END log_sql_start;
PROCEDURE log_sql_progress ( p_filename VARCHAR2, p_index NUMBER ) IS
BEGIN
UPDATE pdx_schema_updater_sql SET statement_index = p_index WHERE file_name = p_filename;
COMMIT;
END log_sql_progress;
PROCEDURE log_sql_end ( p_task_id NUMBER, p_filename VARCHAR2, p_status VARCHAR2, p_error_record typ_error_record, p_action VARCHAR2 := NULL, p_sql_text CLOB := NULL, p_index NUMBER := NULL ) IS
l_action VARCHAR2(2);
BEGIN
IF pkg_pdx_schema_updater_meta.get_filetype(p_filename) != 'R' THEN
log_task_end(p_task_id, p_status, p_error_record, p_action, p_sql_text, p_index);
END IF;
UPDATE pdx_schema_updater_sql SET status_code = p_status, action_code = NVL(p_action,action_code), statement_index = CASE WHEN p_status = 'S' THEN NULL else statement_index END WHERE file_name = p_filename RETURNING action_code INTO l_action;
IF pkg_pdx_schema_updater_meta.get_filetype(p_filename) = 'R' AND l_action = 'D' and p_status = 'S' THEN
DELETE FROM pdx_schema_updater_manifest WHERE file_name = p_filename;
END IF;
COMMIT;
END log_sql_end;
PROCEDURE log_sql (p_call_id NUMBER, p_version_id NUMBER, p_filename VARCHAR2, p_action VARCHAR2, p_status VARCHAR2, p_error_record typ_error_record, p_sql_text CLOB := NULL, p_index NUMBER := NULL ) IS
l_task_id NUMBER;
BEGIN
l_task_id := log_sql_start(p_call_id, p_version_id, p_filename, p_action);
log_sql_end(l_task_id, p_filename, p_status, p_error_record, NULL, p_sql_text, p_index);
END log_sql;
PROCEDURE log_sys_sql_end ( p_call_id NUMBER, p_version_id NUMBER, p_task_id NUMBER, p_filename VARCHAR2 ) IS
l_status VARCHAR2(1);
l_error_record typ_error_record;
l_action   VARCHAR2(1);
l_sql_text VARCHAR2(4000);
l_index    NUMBER(38);
BEGIN
--Sprint schemas may Rollback/Apply for same version id, so we need to only look at the last
SELECT status_code
INTO l_status
FROM (SELECT status_code,
id,
max(id) over () max_id
FROM PDXDBA.pdx_dba_task_history
WHERE schema_owner = SYS_CONTEXT('USERENV','CURRENT_SCHEMA')
AND pdx_schema_upd_pkgcall_hist_id = p_call_id
AND pdx_schema_version_history_id = p_version_id
AND file_name = p_filename
)
WHERE id = max_id;
BEGIN
SELECT error_message, sql_error_code, sql_error_message, sql_text, statement_index
INTO l_error_record.error_message, l_error_record.sql_error_code, l_error_record.sql_error_message, l_sql_text, l_index
FROM (SELECT error_message, sql_error_code, sql_error_message, sql_text, statement_index, id, max(id) over () max_id
FROM PDXDBA.pdx_dba_task_history
LEFT OUTER JOIN PDXDBA.pdx_dba_task_error_log USING (ID)
WHERE schema_owner = SYS_CONTEXT('USERENV','CURRENT_SCHEMA')
AND pdx_schema_upd_pkgcall_hist_id = p_call_id
AND pdx_schema_version_history_id = p_version_id
AND file_name = p_filename
)
WHERE id = max_id;
EXCEPTION
WHEN NO_DATA_FOUND THEN l_error_record := NULL; l_sql_text := NULL; l_index := NULL;
END;
log_sql_end ( p_task_id, p_filename, l_status, l_error_record, l_action, l_sql_text, l_index );
END log_sys_sql_end;
FUNCTION log_process_start(p_call_id NUMBER, p_version_id NUMBER, p_process VARCHAR2) RETURN NUMBER IS
l_rtn NUMBER;
BEGIN
INSERT INTO PDX_SCHEMA_PROCESS_HISTORY (ID, PDX_SCHEMA_UPD_PKGCALL_HIST_ID, PDX_SCHEMA_VERSION_HISTORY_ID, PROCESS, START_DATE)
VALUES (PDX_SCHEMA_MASTER_SEQ.NEXTVAL, p_call_id, p_version_id, p_process, SYSTIMESTAMP)
RETURNING ID INTO l_rtn;
COMMIT;
RETURN l_rtn;
END log_process_start;
PROCEDURE log_process_end(p_process_id NUMBER) IS
BEGIN
UPDATE PDX_SCHEMA_PROCESS_HISTORY SET END_DATE = SYSTIMESTAMP WHERE ID = p_process_id;
COMMIT;
END log_process_end;
PROCEDURE dos2unix IS
BEGIN
UPDATE schema_updater_sql
SET sql = regexp_replace(sql,CHR(13)||CHR(10),CHR(10))
WHERE instr(sql,CHR(13)||CHR(10)) > 0;
COMMIT;
END;
PROCEDURE purge_schema_error_logs (p_until_date  DATE) IS
TBL_EXCEPT EXCEPTION;
PRAGMA EXCEPTION_INIT(TBL_EXCEPT,-942);
BEGIN
-- Purge the version error log
DELETE FROM pdx_schema_upd_pkgcall_err_log WHERE id IN (SELECT id FROM pdx_schema_upd_pkgcall_hist WHERE end_date <= p_until_date);
-- Purge the SQL error logs
DELETE FROM pdx_schema_version_error_log WHERE id IN (SELECT id FROM pdx_schema_version_history WHERE end_date <= p_until_date);
DELETE FROM pdx_schema_task_error_log WHERE id IN (SELECT id FROM pdx_schema_task_history WHERE end_date <= p_until_date);
DELETE FROM pdx_schema_process_history WHERE end_date <= p_until_date;
BEGIN
EXECUTE IMMEDIATE 'DELETE FROM PDXDBA.pdx_dba_task_error_log WHERE error_date <= :dte' using p_until_date;
EXCEPTION WHEN TBL_EXCEPT THEN NULL;
END;
END;
FUNCTION rb_dependencies_met ( p_fname VARCHAR2 ) RETURN BOOLEAN IS
l_cnt NUMBER;
BEGIN
SELECT COUNT(*)
INTO l_cnt
FROM pdx_schema_file_taskver f
JOIN pdx_schema_taskver_meta m on (m.meta_tag = 'REQUIRES' AND task_source = 'A' AND UPPER(m.task_version_value) = f.task_version)
JOIN pdx_schema_file_taskver f2 on (f2.task_version = m.task_version)
JOIN pdx_schema_updater_sql s on (s.file_name = f2.file_name)
WHERE (f.file_name = p_fname OR f.task_version = UPPER(p_fname))
AND (s.action_code != 'R' OR s.status_code != 'S');
RETURN l_cnt = 0;
END rb_dependencies_met;
FUNCTION dependencies_met ( p_fname VARCHAR2 ) RETURN BOOLEAN IS
l_cnt NUMBER := 0;
l_app_prefix VARCHAR2(20) := get_config('APPLICATION_PREFIX');
BEGIN
-- Required tasks may be missing from build completely and thus would not exist in pdx_schema_file_taskver
SELECT COUNT(*)
INTO l_cnt
FROM (SELECT UPPER(m.task_version_value)
FROM pdx_schema_file_taskver f
JOIN pdx_schema_taskver_meta m on (m.meta_tag IN ('REQUIRES','ROLLBACK') AND m.task_source = 'B' AND m.task_version = f.task_version)
WHERE (f.file_name = p_fname OR f.task_version = UPPER(p_fname))
AND UPPER(m.task_version_value) NOT IN ('YES','NO','WRAPPED','TRUE','FALSE')  -- We assume any other value is a task reference
MINUS
SELECT UPPER(REGEXP_SUBSTR(file_name,'^'||l_app_prefix||'_(.*?)(_ddl\.sql)$',1,1,'i',1))
FROM pdx_schema_updater_sql
WHERE action_code = 'A'
AND status_code = 'S'
);
RETURN l_cnt = 0;
END dependencies_met;
PROCEDURE create_synonyms_on_own_objs IS
BEGIN
IF get_config('MANAGE_SYNONYMS') = 'Y' THEN
EXECUTE IMMEDIATE 'BEGIN PDXDBA.pkg_pdx_dba_updater.create_synonyms_on_own_objs('''||SYS_CONTEXT('USERENV','CURRENT_SCHEMA')||'''); END;';
END IF;
END;
PROCEDURE grant_privs_on_own_objs IS
CURSOR cur_generate_priv_ddl ( p_tag VARCHAR2, p_user VARCHAR2 ) IS
WITH object_privs AS (
SELECT 'TABLE' object_type_name, 'SELECT' privilege_name FROM DUAL
UNION ALL SELECT 'TABLE' object_type_name, 'INSERT' privilege_name FROM DUAL
UNION ALL SELECT 'TABLE' object_type_name, 'UPDATE' privilege_name FROM DUAL
UNION ALL SELECT 'TABLE' object_type_name, 'DELETE' privilege_name FROM DUAL
UNION ALL SELECT 'VIEW' object_type_name, 'SELECT' privilege_name FROM DUAL
UNION ALL SELECT 'SEQUENCE' object_type_name, 'SELECT' privilege_name FROM DUAL
UNION ALL SELECT 'FUNCTION' object_type_name, 'EXECUTE' privilege_name FROM DUAL
UNION ALL SELECT 'PROCEDURE' object_type_name, 'EXECUTE' privilege_name FROM DUAL
UNION ALL SELECT 'PACKAGE' object_type_name, 'EXECUTE' privilege_name FROM DUAL
), schema_priv AS (
SELECT UPPER(object_type) object_type, UPPER(privilege) privilege, UPPER(grantee) grantee FROM pdx_schema_priv_default
UNION SELECT 'ALL', 'ALL', '<'||'APP_USER'||'>' FROM DUAL
), schema_except AS (
SELECT UPPER(object_type) object_type, UPPER(object_name) object_name, UPPER(privilege) privilege, UPPER(grantee) grantee FROM pdx_schema_priv_exception UNION
SELECT 'TABLE','PDX_SCHEMA_VERSION_HISTORY'    ,'SELECT','<'||'APP_USER'||'>' FROM DUAL UNION
SELECT 'TABLE','PDX_SCHEMA_UPD_PKGCALL_HIST'   ,'SELECT','<'||'APP_USER'||'>' FROM DUAL UNION
SELECT 'TABLE','PDX_SCHEMA_UPD_PKGCALL_ERR_LOG','SELECT','<'||'APP_USER'||'>' FROM DUAL UNION
SELECT 'TABLE','PDX_SCHEMA_UPDATER_SQL'        ,'SELECT','<'||'APP_USER'||'>' FROM DUAL UNION
SELECT 'TABLE','PDX_SCHEMA_UPDATER_MANIFEST'   ,'SELECT','<'||'APP_USER'||'>' FROM DUAL UNION
SELECT 'TABLE','PDX_SCHEMA_TASK_HISTORY'       ,'SELECT','<'||'APP_USER'||'>' FROM DUAL UNION
SELECT 'TABLE','PDX_SCHEMA_TASK_ERROR_LOG'     ,'SELECT','<'||'APP_USER'||'>' FROM DUAL UNION
SELECT 'TABLE','PDX_SCHEMA_TASKVER_META'       ,'SELECT','<'||'APP_USER'||'>' FROM DUAL UNION
SELECT 'TABLE','PDX_SCHEMA_FILE_TASKVER'       ,'SELECT','<'||'APP_USER'||'>' FROM DUAL UNION
SELECT 'TABLE','PDX_SCHEMA_FILE_HASH'          ,'SELECT','<'||'APP_USER'||'>' FROM DUAL
), default_privs AS (
SELECT privilege_name, object_name, grantee
FROM object_privs p
JOIN schema_priv d ON (d.object_type IN ('ALL',object_type_name) AND privilege IN ('ALL',privilege_name))
JOIN user_objects o ON (o.object_type = object_type_name)
), defined_privs as (
SELECT * FROM default_privs where (object_name, p_tag) NOT IN (SELECT object_name, grantee FROM schema_except)
and (object_name, '-ALL-') NOT IN (SELECT object_name, grantee FROM schema_except WHERE grantee = '-ALL-')
UNION ALL -- Will be NONE, ALL, or actual privilege
SELECT p.privilege_name, e.object_name, e.grantee
FROM object_privs p
JOIN schema_except e ON (e.grantee IN (p_tag,'-ALL-') AND e.object_type = p.object_type_name AND e.privilege IN (p.privilege_name,'ALL'))
JOIN user_objects o ON (o.object_type = e.object_type and o.object_name = e.object_name)
), column_types as (
SELECT DISTINCT 'EXECUTE' privilege, referenced_name table_name, p_user grantee
FROM defined_privs p
JOIN user_tables t ON (t.table_name = p.object_name)
JOIN user_dependencies d ON (d.name = t.table_name and d.type = 'TABLE' and d.referenced_type = 'TYPE')
)
SELECT 'GRANT' action,privilege,table_name,grantee
FROM (select privilege_name privilege, object_name table_name, u.username grantee
from defined_privs p
left outer join pdx_schema_mapping m on (m.mapping_type = 'USER' and m.search = p.grantee)
left outer join all_users u on (u.username in (p.grantee, m.replace))
left outer join session_roles r on (r.role in (p.grantee, m.replace))
where (u.username is not null or r.role is not null)
AND p.grantee = p_tag
union
select privilege, table_name, grantee from column_types
minus
select privilege, table_name, grantee from user_tab_privs where grantee = p_user)
WHERE EXISTS (SELECT NULL FROM all_users WHERE username = p_user)
UNION ALL
SELECT 'REVOKE' action,privilege,table_name,grantee
FROM (select privilege, table_name, grantee from user_tab_privs where grantee = p_user and owner = SYS_CONTEXT('USERENV','CURRENT_SCHEMA') and grantor = SYS_CONTEXT('USERENV','CURRENT_SCHEMA')
and (   table_name IN (SELECT object_name FROM user_objects WHERE object_type IN ('TABLE','SEQUENCE','VIEW','PROCEDURE','PACKAGE','FUNCTION'))
or table_name IN (SELECT table_name FROM column_types)
)
minus
select privilege_name privilege, object_name table_name, u.username grantee
from defined_privs p
left outer join pdx_schema_mapping m on (m.mapping_type = 'USER' and m.search = p.grantee)
left outer join all_users u on (u.username in (p.grantee, m.replace))
left outer join session_roles r on (r.role in (p.grantee, m.replace))
where (u.username is not null or r.role is not null)
AND p.grantee = p_tag
minus
select privilege, table_name, grantee from column_types)
WHERE EXISTS (SELECT NULL FROM all_users WHERE username = p_user UNION ALL SELECT NULL FROM session_roles WHERE role = p_user);
PROCEDURE do_grant ( p_sql VARCHAR2 ) IS
INVALID_SP_VW EXCEPTION;
PRAGMA EXCEPTION_INIT(INVALID_SP_VW,-4063);
BEGIN
EXECUTE IMMEDIATE p_sql;
EXCEPTION
WHEN INVALID_SP_VW THEN NULL;
END;
BEGIN
IF get_config('MANAGE_PRIVS') = 'Y' THEN
FOR urec IN (SELECT search, replace FROM pdx_schema_mapping WHERE mapping_type IN ('USER','ROLE')) LOOP
IF urec.replace IS NOT NULL THEN
FOR rec IN cur_generate_priv_ddl(urec.search,urec.replace) LOOP
-- We need to lock down the Schema Updater tables in case they gave ALL to some other user.
IF urec.search!='<'||'APP_USER'||'>' AND (   (rec.TABLE_NAME LIKE 'PDX\_SCHEMA\_%\_SEQ' ESCAPE '\')
OR (rec.TABLE_NAME LIKE 'PKG_PDX_SCHEMA%')
OR (rec.TABLE_NAME LIKE 'PDX\_SCHEMA\_%' ESCAPE '\' AND rec.PRIVILEGE != 'SELECT')
OR (rec.TABLE_NAME LIKE 'SCHEMA\_UPDATER\_%' ESCAPE '\' AND rec.PRIVILEGE != 'SELECT')
) THEN
NULL;
ELSE
do_grant(rec.action||' '||rec.privilege||' ON '||rec.table_name||CASE WHEN rec.action='GRANT' THEN ' TO ' ELSE ' FROM ' END||rec.grantee);
END IF;
END LOOP;
END IF;
END LOOP;
END IF;
END;
-- pdx_schema_updater was called with Target Version = NULL (manually, not by application = deliberate)
PROCEDURE reset_schema IS
l_cnt  NUMBER;
l_done BOOLEAN := FALSE;
l_error BOOLEAN := FALSE;
l_value VARCHAR2(20);
BEGIN
SELECT count(*) INTO l_cnt
from pdx_schema_taskver_meta
join pdx_schema_file_taskver using (task_version)
join pdx_schema_updater_sql using (file_name)
where meta_tag = 'TASKTYPE'
and task_source = 'A'
and task_version_value = 'SYS'
and (action_code != 'R' or status_code != 'S');
IF l_cnt > 0 THEN
RAISE_APPLICATION_ERROR(-20101,'Please contact DBA - There are SYS tasks which can not be rolled back.');
END IF;
BEGIN SELECT value INTO l_value FROM pdx_schema_config WHERE key = 'PREEXISTINGSCHEMA' and source = 'A'; EXCEPTION WHEN NO_DATA_FOUND THEN l_value := NULL; END;
IF NVL(l_value,'Y') = 'N' THEN
update (select t.action_code, t.action_date, t.status_code, t.statement_index, f.file_type
from pdx_schema_updater_sql t
join pdx_schema_file_taskver f using (file_name)
where file_type = 'T'
and (action_code != 'R' or status_code != 'S')
) set action_code = 'R', action_date = systimestamp, status_code = 'S', statement_index = NULL;
WHILE NOT l_done LOOP
l_done := TRUE;
l_error := FALSE;
FOR r IN (SELECT object_type, object_name
FROM user_objects
WHERE object_name NOT LIKE 'PDX_SCHEMA%'
AND object_name NOT LIKE 'SCHEMA_UPDATER%'
AND object_name NOT LIKE 'PKG_PDX_SCHEMA_UPDATER%'
AND object_name NOT LIKE 'VW_SCHEMA_UPDATER%'
AND object_type IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE','SEQUENCE')
				  ) LOOP
BEGIN
EXECUTE IMMEDIATE 'DROP '||r.object_type||' '||r.object_name||CASE WHEN r.object_type = 'TABLE' THEN ' PURGE' END;
l_done := FALSE;
EXCEPTION WHEN OTHERS THEN l_error := TRUE;
END;
END LOOP;
END LOOP;
END IF;
IF l_error THEN
RAISE_APPLICATION_ERROR(-20102,'Please contact DBA - Unable to remove all schema objects.');
END IF;
END reset_schema;
PROCEDURE replace_tablespace (p_ddl_sql  IN OUT CLOB) AS
BEGIN
FOR mrec IN (SELECT search, replace FROM pdx_schema_mapping WHERE mapping_type = 'TABLESPACE') LOOP
IF regexp_count(mrec.search,'^<[A-Z][A-Z0-9_]{1,29}>$',1) != 1 OR regexp_count(mrec.replace,'^[A-Z][A-Z0-9_]{1,29}$',1) != 1 THEN
RAISE_APPLICATION_ERROR(-20100,'Invalid Mapping -- PDX_SCHEMA_MAPPING_TRG should have prevented');
END IF;
p_ddl_sql := REGEXP_REPLACE(p_ddl_sql,'tablespace\s+'||mrec.search,'TABLESPACE '||mrec.replace,1,0,'im');
END LOOP;
END replace_tablespace;
PROCEDURE replace_partitionby (p_ddl_sql  IN OUT CLOB) AS
l_part CLOB;
l_meta VARCHAR2(200);
l_type VARCHAR2(30);
l_owner VARCHAR2(30);
l_obj   VARCHAR2(30);
l_cnt   NUMBER;
l_tmp   CLOB;
BEGIN
l_meta := regexp_substr(p_ddl_sql,'<partition:[^:>]*:[^>.]*[.]?[^>]*>',1,1,'im');
WHILE l_meta IS NOT NULL LOOP
l_type := UPPER(regexp_substr(l_meta,'<partition:([^:>]*):([^>.]*)[.]?([^>]*)>',1,1,'im',1));
l_owner := UPPER(regexp_substr(l_meta,'<partition:([^:>]*):([^>.]*)[.]([^>]*)>',1,1,'im',2));
IF l_owner IS NOT NULL THEN
BEGIN
SELECT u.username INTO l_owner
FROM all_users u
LEFT OUTER JOIN pdx_schema_mapping m ON (m.replace = u.username AND m.mapping_type = 'USER')
WHERE u.username = l_owner OR m.search = '<'||l_owner||'>';
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
l_obj := UPPER(regexp_substr(l_meta,'<partition:([^:>]*):([^>.]*)[.]([^>]*)>',1,1,'im',3));
ELSE
l_owner := SYS_CONTEXT('USERENV','CURRENT_SCHEMA');
l_obj := UPPER(regexp_substr(l_meta,'<partition:([^:>]*):([^>]*)>',1,1,'im',2));
END IF;
SELECT COUNT(*) INTO l_cnt FROM all_objects WHERE owner = l_owner and object_name = l_obj and object_type = l_type;
IF l_cnt = 1 THEN
DBMS_METADATA.SET_TRANSFORM_PARAM (DBMS_METADATA.SESSION_TRANSFORM,'PRETTY',FALSE);
DBMS_METADATA.SET_TRANSFORM_PARAM (DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',FALSE);
DBMS_METADATA.SET_TRANSFORM_PARAM (DBMS_METADATA.SESSION_TRANSFORM,'SEGMENT_ATTRIBUTES',TRUE);
DBMS_METADATA.SET_TRANSFORM_PARAM (DBMS_METADATA.SESSION_TRANSFORM,'STORAGE',FALSE);
DBMS_METADATA.SET_TRANSFORM_PARAM (DBMS_METADATA.SESSION_TRANSFORM,'TABLESPACE',TRUE);
DBMS_METADATA.SET_TRANSFORM_PARAM (DBMS_METADATA.SESSION_TRANSFORM,'CONSTRAINTS',FALSE);
DBMS_METADATA.SET_TRANSFORM_PARAM (DBMS_METADATA.SESSION_TRANSFORM,'REF_CONSTRAINTS',FALSE);
l_part := regexp_replace(regexp_substr(dbms_metadata.get_ddl(l_type, l_obj, l_owner),'(PARTITION BY .*?[(]PARTITION|LOCAL .*?[(]PARTITION) .*[)]( *[^ ]* ROW MOVEMENT| *PARALLEL [^ ]*)* *$',1,1,'n'),'PCTFREE.*? TABLESPACE ','TABLESPACE ',1,0,'m');
DBMS_LOB.CREATETEMPORARY(l_tmp, FALSE);
DBMS_LOB.COPY(l_tmp,p_ddl_sql,instr(p_ddl_sql,l_meta)-1);
IF length(l_part) > 0 THEN
DBMS_LOB.COPY(l_tmp,l_part,length(l_part),length(l_tmp)+1);
END IF;
IF instr(p_ddl_sql,l_meta)+length(l_meta) <= length(p_ddl_sql) THEN
DBMS_LOB.COPY(l_tmp,p_ddl_sql,length(p_ddl_sql)-length(l_meta)-instr(p_ddl_sql,l_meta)+1,length(l_tmp)+1,instr(p_ddl_sql,l_meta)+length(l_meta));
END IF;
p_ddl_sql := l_tmp;
DBMS_LOB.FREETEMPORARY(l_tmp);
ELSE
p_ddl_sql := replace(p_ddl_sql,l_meta,'<partition-object-not-found:'||l_type||':'||l_owner||'.'||l_obj);
END IF;
l_meta := regexp_substr(p_ddl_sql,'<partition:[^:>]*:[^>.]*[.]?[^>]*>',1,1,'im');
END LOOP;
END replace_partitionby;
PROCEDURE replace_sbmo_meijer(p_ddl_sql IN OUT CLOB) AS
l_line varchar2(100);
l_table varchar2(32);
l_action varchar2(10);
l_own varchar2(32) := ''''||SYS_CONTEXT('USERENV','CURRENT_SCHEMA')||'''';
begin
l_line := regexp_substr(p_ddl_sql,'^ *(--\*)? *<sbmo_meijer:[^>]*> *;? *$',1,1,'im');
while l_line IS NOT NULL LOOP
l_table := ''''||regexp_substr(l_line,'<sbmo_meijer:([^:>]*)[:>]',1,1,'im',1)||'''';
l_action := ''''||NVL(regexp_substr(l_line,'<sbmo_meijer:[^:>]*:([^>]*)[>]',1,1,'im',1),'GRANT')||'''';
if regexp_count(l_line,'--\*') = 1 THEN
p_ddl_sql := replace(p_ddl_sql,l_line,'--*begin PDXDBA.pkg_pdx_dba_updater.sbmo_meijer('||l_own||','||l_table||','||l_action||'); end;');
else
p_ddl_sql := replace(p_ddl_sql,l_line,'begin PDXDBA.pkg_pdx_dba_updater.sbmo_meijer('||l_own||','||l_table||','||l_action||'); end;');
end if;
l_line := regexp_substr(p_ddl_sql,'^ *(--\*)? *<sbmo_meijer:[^>]*> *;? *$',1,1,'im');
END LOOP;
END;
PROCEDURE replace_parms (p_ddl_sql   IN OUT CLOB) AS
l_tag VARCHAR2(256);
BEGIN
FOR mrec IN (SELECT search, replace FROM pdx_schema_mapping WHERE mapping_type IN ('USER','ROLE')) LOOP
IF regexp_count(mrec.search,'^<[A-Z][A-Z0-9_]{1,29}>$',1) != 1 OR regexp_count(mrec.replace,'^[A-Z][A-Z0-9_]{1,29}$',1) != 1 THEN
RAISE_APPLICATION_ERROR(-20100,'Invalid Mapping -- PDX_SCHEMA_MAPPING_TRG should have prevented');
END IF;
p_ddl_sql := REGEXP_REPLACE(p_ddl_sql,mrec.search,mrec.replace,1,0,'im');
END LOOP;
replace_tablespace(p_ddl_sql);
replace_partitionby(p_ddl_sql);
replace_sbmo_meijer(p_ddl_sql);
END replace_parms;
-- Technically we don't need p_own_user since that will be the owner of the package
-- We also don't need p_dib_user as that is only used for SYS SQL Files
-- However leaving here so when bugs are found we can copy complete parse_sql between this file and others unchanged
PROCEDURE parse_sql(p_ddl_sql     IN     CLOB,
p_ddl_sql_tbl IN OUT ddl_sql_type) IS
l_table_index                BINARY_INTEGER;
l_start_position             NUMBER;
l_terminator                 VARCHAR2(1);
l_file_length                NUMBER;
l_end_position               NUMBER;
l_input_line                 VARCHAR2(32767);
l_sql                        CLOB;
l_suffix                     VARCHAR2(30);
BEGIN
l_table_index := 1;
l_start_position := 1;
l_terminator := NULL;
l_file_length := DBMS_LOB.GETLENGTH(p_ddl_sql);
-- Process each line in the SQL DDL CLOB by placing each SQL statement into a PL/SQL table once the SQL statement terminator is reached
WHILE l_start_position <> 0 LOOP
-- Determine the end position for the current line
l_end_position := DBMS_LOB.INSTR(lob_loc => p_ddl_sql,
pattern => CHR(10),
offset => l_start_position);
-- If we are not processing the last line
IF l_end_position > 0 THEN
-- Leave some characters (767) for parameter substitution and tablespace name expansion
l_input_line := DBMS_LOB.SUBSTR(lob_loc => p_ddl_sql,
amount => LEAST(l_end_position - l_start_position, 32000),
offset => l_start_position);
-- Mark the new start position
l_start_position := l_end_position + 1;
-- If we are processing the last line
ELSE
l_input_line := DBMS_LOB.SUBSTR(lob_loc => p_ddl_sql, amount => l_file_length - l_start_position + 1, offset => l_start_position);
-- Mark start position as finished
l_start_position := 0;
END IF;
-- Strip off carriage returns and line feeds
l_input_line := REPLACE(REPLACE(l_input_line, CHR(10)), CHR(13));
l_input_line := trim(l_input_line);
-- Skip commented lines
IF l_sql IS NULL                                       AND
l_input_line IS NOT NULL                            AND
SUBSTR(NVL(TRIM(l_input_line), 'Z'), 1, 2) = '--'   AND
SUBSTR(NVL(TRIM(l_input_line), 'Z'), 1, 3) <> '--*' THEN
NULL;
-- Skip rollback lines between SQL statements
ELSIF l_sql IS NULL                        AND
l_input_line IS NOT NULL             AND
TRIM(NVL(l_input_line, 'Z')) = '--*' THEN
NULL;
ELSE
-- Determine the SQL statement terminator
IF l_input_line IS NOT NULL AND
l_terminator IS NULL     THEN
-- The INSTR function will return 0 when string is not found
IF INSTR(UPPER(NVL(l_input_line, 'Z')), 'CREATE OR REPLACE') <> 0 AND
(INSTR(UPPER(NVL(l_input_line, 'Z')), ' FUNCTION ') <> 0       OR
INSTR(UPPER(NVL(l_input_line, 'Z')), ' PACKAGE ') <> 0        OR
INSTR(UPPER(NVL(l_input_line, 'Z')), ' PROCEDURE ') <> 0      OR
INSTR(UPPER(NVL(l_input_line, 'Z')), ' TRIGGER ') <> 0        OR
INSTR(UPPER(NVL(l_input_line, 'Z')), ' TYPE ') <> 0)          THEN
l_terminator := '/';
elsif upper(substr(trim(replace(l_input_line,'--*')), 1, 7)) = 'DECLARE' or
UPPER(SUBSTR(TRIM(replace(l_input_line,'--*')), 1, 5)) = 'BEGIN'   THEN
l_terminator := '/';
ELSE
l_terminator := ';';
END IF;
END IF;
-- Strip off the rollback indicator (--*) for those SQL statements that continue on subsequent lines
IF l_sql IS NOT NULL                                  AND
SUBSTR(TRIM(NVL(l_input_line, 'Z')), 1, 3) = '--*' THEN
l_input_line := SUBSTR(TRIM(l_input_line), 4);
END IF;
-- Determine if the end of the SQL statement has been reached
IF NVL(l_terminator, 'Z') = ';' AND
l_input_line IS NOT NULL     THEN
IF SUBSTR(TRIM(l_input_line), LENGTH(TRIM(l_input_line))) = l_terminator THEN
l_sql := l_sql || SUBSTR(l_input_line, 1, LENGTH(RTRIM(l_input_line)) - 1);
p_ddl_sql_tbl(l_table_index) := trim(l_sql);
l_table_index := l_table_index + 1;
l_sql := NULL;
l_terminator := NULL;
ELSIF regexp_count(l_input_line,'^ *(--\*)? *<sbmo_meijer:[^>]*> *$',1,'im') > 0 AND l_sql IS NULL THEN
p_ddl_sql_tbl(l_table_index) := trim(l_input_line);
l_table_index := l_table_index + 1;
l_terminator := NULL;
ELSE
l_sql := l_sql || l_input_line || CHR(10);
END IF;
ELSIF NVL(l_terminator, 'Z') = '/' AND
l_input_line IS NOT NULL     THEN
IF TRIM(l_input_line) = l_terminator THEN
l_sql := l_sql || REPLACE(l_input_line, l_terminator);
p_ddl_sql_tbl(l_table_index) := trim(l_sql);
l_table_index := l_table_index + 1;
l_sql := NULL;
l_terminator := NULL;
ELSE
l_sql := l_sql || l_input_line || CHR(10);
END IF;
END IF;
END IF;
END LOOP;
END parse_sql;
PROCEDURE run_statement ( p_sql CLOB ) IS
l_sql_statement             DBMS_SQL.VARCHAR2A;  -- Table of VARCHAR2(32767)
l_cursor                    INTEGER;
l_rows                      NUMBER;
l_table_counter             BINARY_INTEGER;
l_offset                    BINARY_INTEGER;
BEGIN
-- Load the SQL statement into a table of 32k chunks
l_offset := 1;
l_table_counter := 1;
LOOP
EXIT WHEN l_offset > LENGTH(p_sql);
l_sql_statement(l_table_counter) := SUBSTR(p_sql, l_offset, 32767);
l_offset := l_offset + 32767;
l_table_counter := l_table_counter + 1;
END LOOP;
-- Parse and execute the SQL statement
l_cursor := DBMS_SQL.OPEN_CURSOR;
DBMS_SQL.PARSE(c             => l_cursor,
statement     => l_sql_statement,
lb            => l_sql_statement.FIRST,
ub            => l_sql_statement.LAST,
lfflg         => FALSE,
language_flag => DBMS_SQL.NATIVE);
l_rows := DBMS_SQL.EXECUTE(l_cursor);
DBMS_SQL.CLOSE_CURSOR(l_cursor);
END run_statement;
-- Apply_SQL assumes that all prerequisite checks have already been completed and SQL is ready to run
FUNCTION apply_sql ( p_call_id   NUMBER,
p_version_id NUMBER,
p_filename  VARCHAR2
) RETURN BOOLEAN AS
l_sql_tbl  ddl_sql_type;
l_sql      CLOB;
l_continue BOOLEAN;
l_task_id  NUMBER;
l_index    NUMBER;
BEGIN
l_task_id := log_sql_start(p_call_id, p_version_id, p_filename, 'A');
l_sql := get_sql(p_filename, 'A');
parse_sql(l_sql, l_sql_tbl);
l_index := NVL(get_index(p_filename, 'A'),1);
l_continue := TRUE;
while l_index <= l_sql_tbl.COUNT AND l_continue LOOP
log_sql_progress(p_filename,l_index);
IF SUBSTR(TRIM(l_sql_tbl(l_index)), 1, 3) != '--*' THEN
l_sql := TRIM(l_sql_tbl(l_index));
IF DBMS_LOB.GETLENGTH(l_sql) > 0 THEN
BEGIN
replace_parms(l_sql);
run_statement(l_sql);
EXCEPTION
WHEN OTHERS THEN
IF regexp_instr(l_sql,'^\s*(execute\s+immediate\s+[''"]\s*)?create\s+(or\s+replace\s+)?(force\s+)?(view|procedure|function|package)\s+',1,1,0,'im') > 0 AND sqlcode IN (-24344) THEN
NULL;
ELSE
l_continue := FALSE;
log_sql_end ( l_task_id, p_filename, 'F', error_record(NULL, SQLCODE, DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE), NULL, l_sql );
END IF;
END;
END IF;
END IF;
l_index := l_index + 1;
END LOOP;
-- If we exited due to index then we completed successfully
-- If we exited due to continue flag then we encountered some error
IF l_continue THEN
-- Apply was successful
log_sql_end(l_task_id, p_filename, 'S', NULL);
END IF;
RETURN l_continue;
END;
-- Rollback_SQL assumes that all prerequisite checks have already been completed and SQL is ready to run
FUNCTION rollback_sql (p_call_id   NUMBER,
p_version_id NUMBER,
p_filename  VARCHAR2
) RETURN BOOLEAN AS
l_sql_tbl  ddl_sql_type;
l_sql      CLOB;
l_continue BOOLEAN;
l_task_id  NUMBER;
l_index    NUMBER;
BEGIN
l_task_id := log_sql_start(p_call_id, p_version_id, p_filename, 'R');
l_sql := get_sql(p_filename, 'R');
parse_sql(l_sql, l_sql_tbl);
l_index := NVL(get_index(p_filename, 'R'),l_sql_tbl.COUNT);
l_continue := TRUE;
WHILE l_index > 0 AND l_continue LOOP
log_sql_progress(p_filename,l_index);
IF SUBSTR(TRIM(l_sql_tbl(l_index)), 1, 3) = '--*' THEN
l_sql := TRIM(SUBSTR(TRIM(l_sql_tbl(l_index)), 4));
IF DBMS_LOB.GETLENGTH(l_sql) > 0 THEN
BEGIN
replace_parms(l_sql);
run_statement(l_sql);
EXCEPTION
WHEN OTHERS THEN
IF regexp_instr(l_sql,'^\s*(execute\s+immediate\s+[''"]\s*)?create\s+(or\s+replace\s+)?(force\s+)?(view|procedure|function|package)\s+',1,1,0,'im') > 0 AND sqlcode IN (-24344) THEN
NULL;
ELSE
l_continue := FALSE;
log_sql_end( l_task_id, p_filename, 'F', error_record(NULL, SQLCODE, DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE), NULL, l_sql );
END IF;
END;
END IF;
END IF;
l_index := l_index - 1;
END LOOP;
IF l_continue THEN
-- Rollback was successful
log_sql_end(l_task_id, p_filename, 'S', NULL);
	END IF;
RETURN l_continue;
END;
FUNCTION run_sql ( p_call_id    NUMBER,
p_version_id NUMBER,
p_filename   VARCHAR2,
p_action     VARCHAR2
) RETURN BOOLEAN IS
l_type_check    VARCHAR2(30);
l_rb_ok    BOOLEAN := TRUE;
l_rb_found BOOLEAN := FALSE;
l_rtn      BOOLEAN := FALSE;
l_sql      CLOB := get_sql(p_filename, p_action);
l_task_id  NUMBER;
BEGIN
l_rb_found := REGEXP_INSTR(l_sql,'^\s*--\*\s*\S',1,1,0,'m') > 0;
--If we don't have the TASKTYPE metadata, then assumed to be sql-based release file executed as tasK
IF pkg_pdx_schema_updater_meta.get_filetype(p_filename) = 'T' THEN
l_rb_ok := UPPER(NVL(get_metadata(p_filename,'ROLLBACK',p_action),'YES')) IN ('TRUE','YES');
ELSE
l_rb_ok := l_rb_found;
END IF;
IF l_rb_ok AND NOT l_rb_found THEN
l_rtn := FALSE;
log_task_history ( p_call_id, p_version_id, p_filename, p_action, 'F', error_record('Requested task has rollback enabled, but no rollback statements',NULL,NULL) );
ELSE
l_type_check := get_tasktype(p_filename,p_action);
IF l_type_check = 'SYS' THEN
l_task_id := log_sql_start ( p_call_id, p_version_id, p_filename, p_action );
l_rtn := PDXDBA.pkg_pdx_dba_updater.run_sql(p_call_id,p_version_id,p_filename,l_sql,p_action,get_index(p_filename, p_action),SYS_CONTEXT('USERENV','CURRENT_SCHEMA'));
log_sys_sql_end ( p_call_id, p_version_id, l_task_id, p_filename );
ELSIF l_type_check = UPPER(get_config('APPLICATION_PREFIX')) THEN
-- If current status is [AR]F then continue where we left off
IF NVL(p_action,'X') = 'A' THEN
l_rtn := apply_sql ( p_call_id, p_version_id, p_filename);
ELSIF NVL(p_action,'X') = 'R' AND l_rb_ok THEN
l_rtn := rollback_sql ( p_call_id, p_version_id, p_filename);
ELSIF NVL(p_action,'X') = 'R' AND NOT l_rb_ok THEN
l_rtn := FALSE;
log_task_history ( p_call_id, p_version_id, p_filename, 'R', 'F', error_record('Requested task rollback, but rollback is not allowed',NULL, NULL) );
ELSE
l_rtn := FALSE;
log_task_history ( p_call_id, p_version_id, p_filename, NVL(p_action,'X'), 'F', error_record('Invalid Action Code: Only A (Apply) and R (Rollback) are accepted',NULL,NULL) );
END IF;
ELSE
l_rtn := FALSE;
log_task_history ( p_call_id, p_version_id, p_filename, NVL(p_action,'X'), 'F', error_record('Invalid Task Type: '||l_type_check,NULL,NULL) );
END IF;
END IF;
RETURN l_rtn;
EXCEPTION
WHEN OTHERS THEN
log_task_history( p_call_id, p_version_id, p_filename, NVL(p_action,'X'), 'F', error_record(NULL, SQLCODE, DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE) );
RETURN FALSE;
END run_sql;
FUNCTION is_deprecated ( p_filename pdx_schema_updater_sql.file_name%TYPE,
p_task_list task_tbl
) RETURN BOOLEAN IS
l_rtn  BOOLEAN := false;
l_file pdx_schema_updater_sql.file_name%TYPE;
CURSOR check_applied_cur IS
SELECT f1.file_name
FROM pdx_schema_updater_sql s
JOIN pdx_schema_file_taskver f1 ON (f1.file_name = s.file_name)
JOIN pdx_schema_taskver_meta m ON (m.meta_tag = 'DEPRECATES' and m.task_source = 'A' and m.task_version = f1.task_version)
JOIN pdx_schema_file_taskver f2 ON (UPPER(m.task_version_value) = UPPER(f2.task_version))
WHERE action_code = 'A'
AND status_code = 'S'
AND (f2.file_name = p_filename or UPPER(f2.task_version) = UPPER(p_filename));
CURSOR check_build_cur IS
SELECT f1.file_name
FROM pdx_schema_file_taskver f1
JOIN pdx_schema_taskver_meta m ON (m.meta_tag = 'DEPRECATES' and m.task_source = 'B' and m.task_version = f1.task_version)
JOIN pdx_schema_file_taskver f2 ON (UPPER(m.task_version_value) = UPPER(f2.task_version))
WHERE (f2.file_name = p_filename or UPPER(f2.task_version) = UPPER(p_filename));
check_rec check_applied_cur%ROWTYPE;
BEGIN
OPEN check_applied_cur;
FETCH check_applied_cur INTO check_rec;
l_rtn := check_applied_cur%FOUND;
CLOSE check_applied_cur;
IF NOT l_rtn THEN
OPEN check_build_cur;
FETCH check_build_cur INTO check_rec;
WHILE NOT l_rtn AND check_build_cur%FOUND LOOP
l_file := p_task_list.FIRST;
WHILE NOT l_rtn AND l_file IS NOT NULL LOOP
l_rtn := l_file = check_rec.file_name;
l_file := p_task_list.NEXT(l_file);
END LOOP;
FETCH check_build_cur INTO check_rec;
END LOOP;
CLOSE check_build_cur;
END IF;
RETURN l_rtn;
END is_deprecated;
FUNCTION is_excluded ( p_filename pdx_schema_updater_sql.file_name%TYPE, is_sprint boolean ) RETURN BOOLEAN IS
l_meta        pkg_pdx_schema_updater_meta.results_tbl := pkg_pdx_schema_updater_meta.results_tbl();
l_idx         NUMBER;
l_rtn         boolean;
l_found       boolean;
BEGIN
l_rtn := is_sprint AND NVL(UPPER(get_metadata(p_filename,'APPLYSPRINT','A')),'YES') IN ('FALSE','NO');
RETURN l_rtn;
END is_excluded;
FUNCTION task_based_apply    ( p_call_id NUMBER, p_version_id NUMBER ) RETURN BOOLEAN IS
CURSOR apply_cur IS
SELECT release_version, t.file_name
FROM (SELECT file_name,
NVL(DBMS_LOB.COMPARE(s1.sql,s2.sql),-1) sql_compare,
action_code,
status_code
FROM pdx_schema_file_taskver f
JOIN schema_updater_sql s1 USING (file_name)
LEFT OUTER JOIN pdx_schema_updater_sql s2 USING (file_name)
WHERE file_type = 'T'
) t
LEFT OUTER JOIN (WITH file_list AS (
SELECT file_name, DECODE(file_type,'R','Release','T','Task') type, task_version info
FROM pdx_schema_file_taskver
WHERE file_type IN ('R','T')
), task_list AS (
SELECT file_name version_file_name,
upper(task_version_value) task
FROM pdx_schema_taskver_meta
JOIN pdx_schema_file_taskver using (task_version)
WHERE meta_tag = 'RELEASETASK'
AND task_source = 'B'
)
SELECT t.file_name, min(v.info) release_version
FROM task_list l
JOIN file_list t ON (t.type = 'Task' AND l.task = t.info)
JOIN file_list v ON (v.type = 'Release' AND v.file_name = l.version_file_name)
GROUP BY t.file_name
) v ON (v.file_name = t.file_name)
LEFT OUTER JOIN vw_schema_updater_manifest m ON (m.version = release_version)
WHERE (NVL(action_code,'R') != 'A' OR NVL(status_code,'S') != 'S')
ORDER BY m.apply_order;
task_list task_tbl;
task_ver  task_tbl;
task_proc ind_tbl;
task_proc_ind NUMBER(3);
l_processed  BOOLEAN;
l_skipped    BOOLEAN;
l_result     BOOLEAN;
l_task       VARCHAR2(50);
l_ver        VARCHAR2(25);
l_rtn        BOOLEAN := true;
BEGIN
task_list.DELETE;
task_ver.DELETE;
task_proc.DELETE;
FOR apply_rec IN apply_cur LOOP
task_list(apply_rec.file_name) := task_proc.COUNT+1;
task_ver(apply_rec.file_name) := apply_rec.release_version;
task_proc(task_proc.COUNT+1) := apply_rec.file_name;
END LOOP;
task_proc_ind := task_proc.FIRST;
IF task_proc_ind IS NOT NULL THEN
l_task := task_proc(task_proc_ind);
END IF;
FOR ctr IN 1..task_list.COUNT LOOP
IF is_deprecated(l_task,task_list) THEN
IF NVL(get_status(l_task),'RS') IN ('RS','RD') THEN
log_sql(p_call_id, p_version_id, l_task, 'A', 'D',error_record('Task has been deprecated and will not be applied',NULL,NULL) );
END IF;
task_list.DELETE(l_task);
task_ver.DELETE(l_task);
task_proc.DELETE(task_proc_ind);
ELSIF is_excluded(l_task,true) THEN
IF NVL(get_status(l_task),'RS') = 'RS' THEN
log_sql(p_call_id, p_version_id,l_task,'A','X',error_record('Task has been excluded and will not be applied',NULL,NULL) );
END IF;
task_list.DELETE(l_task);
task_ver.DELETE(l_task);
task_proc.DELETE(task_proc_ind);
ELSE
DECLARE
l_task_type   pdx_schema_task_history.task_type%TYPE;
l_key         VARCHAR2(255);
l_value       VARCHAR2(255);
l_attribcheck pkg_pdx_schema_updater_meta.results_tbl;
l_idx         NUMBER;
l_excluded    BOOLEAN := false;
BEGIN
l_attribcheck := get_metadata_tbl(l_task,'ATTRIBCHECK','A');
l_idx := l_attribcheck.FIRST;
FOR ctr IN 1..l_attribcheck.COUNT LOOP
l_key := TRIM(regexp_substr(l_attribcheck(l_idx),'^([^:]*):',1,1,NULL,1));
l_value := TRIM(regexp_substr(l_attribcheck(l_idx),'^[^:]*:[   ]*(.*)$',1,1,NULL,1));
CASE UPPER(l_key)
WHEN NULL THEN NULL;   -- No ATTRIBCHECKs are supported currently
ELSE
l_rtn := false;
log_sql(p_call_id, p_version_id,l_task, 'A','F',error_record('Task contains invalid metadata ATTRIBCHECK: '||l_key,NULL,NULL) );
task_list.DELETE(l_task);
task_ver.DELETE(l_task);
task_proc.DELETE(task_proc_ind);
END CASE;
EXIT WHEN (NOT l_rtn) or l_excluded;
l_idx := l_attribcheck.NEXT(l_idx);
END LOOP;
END;
END IF;
task_proc_ind := task_proc.NEXT(task_proc_ind);
EXIT WHEN task_proc_ind IS NULL;
l_task := task_proc(task_proc_ind);
END LOOP;
l_processed := TRUE;
WHILE task_list.COUNT > 0 AND l_processed LOOP
task_proc_ind := task_proc.FIRST;
l_task := task_proc(task_proc_ind);
l_ver  := task_ver(l_task);
l_processed := FALSE;
l_skipped := FALSE;
FOR task_ctr IN 1..task_list.COUNT LOOP
IF dependencies_met(l_task) THEN
l_processed := true;
l_result := run_sql(p_call_id, p_version_id, l_task, 'A');
l_rtn := l_rtn AND l_result;
task_list.DELETE(l_task);
task_ver.DELETE(l_task);
task_proc.DELETE(task_proc_ind);
ELSE
l_skipped := TRUE;
END IF;
task_proc_ind := task_proc.NEXT(task_proc_ind);
EXIT WHEN task_proc_ind IS NULL;
l_task := task_proc(task_proc_ind);
IF NVL(task_ver(l_task),get_config('TASK_VERSION')) != NVL(l_ver,get_config('TASK_VERSION')) THEN
-- requiring l_processed is necessary to prevent infinite loop when you have 1 task where dependencies are not met
EXIT WHEN l_skipped AND l_processed;
END IF;
l_ver := task_ver(l_task);
END LOOP;
END LOOP;
l_task := task_list.FIRST;
FOR task_ctr IN 1..task_list.COUNT LOOP
l_rtn := FALSE;
log_task_history(p_call_id, p_version_id, l_task, 'A', 'F', error_record('Task cannot be applied as there are missing required tasks',NULL,NULL) );
l_task := task_list.NEXT(l_task);
END LOOP;
RETURN l_rtn;
END task_based_apply;
FUNCTION task_based_rollback ( p_call_id NUMBER, p_version_id NUMBER, p_target_version IN VARCHAR2 ) RETURN BOOLEAN IS
l_task_version VARCHAR2(20) := get_config('TASK_VERSION');
CURSOR rollback_cur IS
SELECT t.file_name
FROM (SELECT file_name,
version,
NVL(DBMS_LOB.COMPARE(s1.sql,s2.sql),-1) sql_compare,
action_code,
status_code,
statement_index,
s1.sql
FROM pdx_schema_updater_sql s1
LEFT OUTER JOIN schema_updater_sql s2 USING (file_name)
JOIN pdx_schema_file_taskver f USING (file_name)
WHERE file_type = 'T'
) t
LEFT OUTER JOIN (WITH file_list AS (
SELECT file_name, DECODE(file_type,'R','Release','T','Task') type, task_version info
FROM pdx_schema_file_taskver
WHERE file_type IN ('R','T')
), task_list AS (
SELECT file_name version_file_name,
upper(task_version_value) task
FROM pdx_schema_taskver_meta
JOIN pdx_schema_file_taskver using (task_version)
WHERE meta_tag = 'RELEASETASK'
-- This is task-based rollback so release files will be in build (schema_updater_sql) not apply (pdx_schema_updater_sql)
AND task_source = 'B'
)
SELECT t.file_name, v.info release_version
FROM task_list l
JOIN file_list t ON (t.type = 'Task' AND l.task = t.info)
JOIN file_list v ON (v.type = 'Release' AND v.file_name = l.version_file_name)
JOIN schema_updater_manifest m ON (m.file_name = l.version_file_name)
WHERE (t.file_name, apply_order) IN (SELECT t.file_name, MIN(apply_order)
FROM task_list l
JOIN file_list t ON (t.type = 'Task' AND l.task = t.info)
JOIN file_list v ON (v.type = 'Release' AND v.file_name = l.version_file_name)
JOIN schema_updater_manifest m ON (m.file_name = l.version_file_name)
GROUP BY t.file_name
)
) v ON (v.file_name = t.file_name)
LEFT OUTER JOIN vw_schema_updater_manifest m ON (m.version = release_version)
WHERE sql_compare != 0
AND (NVL(action_code,'R') != 'R' OR NVL(status_code,'S') != 'S')
AND t.version = l_task_version
ORDER BY m.apply_order;
CURSOR rb_cur(c_task VARCHAR2) IS
SELECT file_name, upper(task_version_value) rollback_task
FROM pdx_schema_taskver_meta
JOIN pdx_schema_file_taskver USING (task_version)
JOIN pdx_schema_updater_sql USING (file_name)
WHERE meta_tag = 'ROLLBACK' AND task_source = 'A'
AND (action_code != 'R' OR status_code != 'S')
AND version = l_task_version
AND upper(task_version_value) = upper(pkg_pdx_schema_updater_meta.get_taskname(c_task));
task_list task_tbl;
task_proc ind_tbl;
task_proc_ind NUMBER(3);
l_processed  BOOLEAN;
l_rtn        BOOLEAN := true;
l_result     BOOLEAN;
l_task       VARCHAR2(50);
-- Recursively adds tasks that require the task we are rolling back: We have to rollback those tasks first
-- If the rollback task was applied, then it follows that all dependent tasks will have been applied
-- But including in query for good measure
PROCEDURE add_rb_dependencies ( p_fname VARCHAR2 ) IS
CURSOR dep_cur (c_taskname VARCHAR2) IS
SELECT f.file_name
FROM pdx_schema_updater_sql s
JOIN pdx_schema_file_taskver f ON (f.file_name = s.file_name)
JOIN pdx_schema_taskver_meta m ON (m.task_version = f.task_version AND m.meta_tag IN ('REQUIRES','ROLLBACK') AND m.task_source = 'A')
WHERE (action_code != 'R' OR status_code != 'S')
AND version = l_task_version
AND upper(m.task_version_value) = pkg_pdx_schema_updater_meta.get_taskname(p_fname);
l_tname    VARCHAR2(50) := UPPER(REGEXP_SUBSTR(p_fname,'^('||get_config('APPLICATION_PREFIX')||'_)(.*?)(_ddl\.sql)$',1,1,'im',2));
BEGIN
FOR dep_rec IN dep_cur(l_tname) LOOP
IF NOT task_list.EXISTS(dep_rec.file_name) THEN
task_list(dep_rec.file_name) := task_proc.COUNT+1;
task_proc(task_proc.COUNT+1) := dep_rec.file_name;
add_rb_dependencies(dep_rec.file_name);
END IF;
END LOOP;
END add_rb_dependencies;
FUNCTION is_same_apply_sql(p_file_name VARCHAR2) RETURN BOOLEAN IS
l_rtn BOOLEAN := false;
CURSOR new_cur IS
SELECT action_code, status_code, sql task_sql
FROM pdx_schema_updater_sql
WHERE file_name = p_file_name;
new_rec new_cur%ROWTYPE;
l_old_sql CLOB;
BEGIN
OPEN new_cur;
FETCH new_cur INTO new_rec;
CLOSE new_cur;
-- We can only get here if there is a row in pdx_schema_updater_sql, otherwise, there is nothing to rollback.
IF new_rec.action_code = 'A' AND new_rec.status_code = 'S' THEN
BEGIN
SELECT sql INTO l_old_sql FROM schema_updater_sql WHERE file_name = p_file_name;
--Both must be the same task type
IF (    get_tasktype(p_file_name,'A') = get_tasktype(p_file_name,'R') )
AND ( get_tasktype(p_file_name,new_rec.action_code) = UPPER(get_config('APPLICATION_PREFIX')) )
AND ( regexp_replace(regexp_replace(regexp_replace(new_rec.task_sql,'^\s*--.*$',NULL,1,0,'m'),'^\s*'||CHR(10)||CHR(13)||'?',NULL,1,0,'m'),CHR(10)||CHR(13)||'?$',NULL,1,0)
= regexp_replace(regexp_replace(regexp_replace(l_old_sql,'^\s*--.*$',NULL,1,0,'m'),'^\s*'||CHR(10)||CHR(13)||'?',NULL,1,0,'m'),CHR(10)||CHR(13)||'?$',NULL,1,0) )
THEN
l_rtn := true;
END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN NULL;
END;
END IF;
RETURN l_rtn;
END is_same_apply_sql;
PROCEDURE log_rb_sql_history (p_call_id pdx_schema_upd_pkgcall_hist.id%TYPE,
p_version_id pdx_schema_version_history.id%TYPE,
p_filename pdx_schema_task_history.file_name%TYPE) IS
l_id pdx_schema_task_history.id%TYPE;
BEGIN
-- ROLLBACK;TASK mistakenly logged as rollback is not allowed
BEGIN
SELECT id
INTO l_id
FROM pdx_schema_task_history
JOIN pdx_schema_task_error_log USING (id)
WHERE NVL(pdx_schema_upd_pkgcall_hist_id,-1) = NVL(p_call_id,-1)
AND NVL(pdx_schema_version_history_id,-1) = NVL(p_version_id,-1)
AND file_name = p_filename
AND action_code = 'R'
AND status_code = 'F'
AND error_message = 'Requested task rollback, but rollback is not allowed';
DELETE
FROM pdx_schema_task_error_log
WHERE id = l_id;
DELETE
FROM pdx_schema_task_history
WHERE id = l_id;
EXCEPTION
WHEN NO_DATA_FOUND THEN
NULL;
END;
log_sql(p_call_id, p_version_id, p_filename,'R','S',NULL);
END;
BEGIN
	  IF p_target_version IS NULL THEN
DELETE FROM pdx_schema_updater_sql WHERE file_name IN (SELECT file_name FROM pdx_schema_updater_manifest);
DELETE from pdx_schema_updater_manifest;
UPDATE pdx_schema_updater_sql SET version = l_task_version;
		COMMIT;
	  END IF;
task_list.DELETE;
task_proc.DELETE;
FOR rb_rec IN rollback_cur LOOP
IF is_same_apply_sql(rb_rec.file_name) THEN
-- Apply is the same, Rollback is different, or only comment changes
-- No need to rollback/reapply
log_sql(p_call_id, p_version_id,rb_rec.file_name, 'A', 'S', error_record('Task has been modified, however apply is the same, so leaving task applied and updating pdx_schema_updater_sql.sql only',NULL,NULL) );
ELSIF NOT task_list.EXISTS(rb_rec.file_name) THEN
task_list(rb_rec.file_name) := task_proc.COUNT+1;
task_proc(task_proc.COUNT+1) := rb_rec.file_name;
add_rb_dependencies(rb_rec.file_name);
END IF;
END LOOP;
l_processed := TRUE;
WHILE task_list.COUNT > 0 AND l_processed LOOP
task_proc_ind := task_proc.FIRST;
l_task := task_proc(task_proc_ind);
l_processed := FALSE;
FOR task_ctr IN 1..task_list.COUNT LOOP
IF rb_dependencies_met(l_task) THEN
IF UPPER(NVL(get_metadata(l_task,'ROLLBACK','R'),'YES')) IN ('YES','NO','TRUE','FALSE','NO','WRAPPED') THEN
l_processed := true;
l_result := run_sql(p_call_id, p_version_id, l_task, 'R');
l_rtn := l_rtn AND l_result;
task_list.DELETE(l_task);
task_proc.DELETE(task_proc_ind);
IF l_rtn THEN
FOR rb_rec IN rb_cur(l_task) LOOP
log_rb_sql_history (p_call_id, p_version_id, rb_rec.file_name);
task_proc.DELETE(task_list(rb_rec.file_name));
task_list.DELETE(rb_rec.file_name);
END LOOP;
END IF;
END IF;
END IF;
task_proc_ind := task_proc.NEXT(task_proc_ind);
EXIT WHEN task_proc_ind IS NULL;
l_task := task_proc(task_proc_ind);
END LOOP;
END LOOP;
l_task := task_list.FIRST;
FOR task_ctr IN 1..task_list.COUNT LOOP
l_rtn := FALSE;
IF UPPER(NVL(get_metadata(l_task,'ROLLBACK','R'),'YES')) IN ('YES','NO','TRUE','FALSE','NO','WRAPPED') THEN
log_task_history (p_call_id, p_version_id, l_task, 'R', 'F' , error_record('Task cannot be rolled back as there are dependent tasks still applied', NULL, NULL) );
ELSE
--We've removed the --ROLLBACK:{Task} task, but not the referenced {Task} that would roll it back
log_task_history (p_call_id, p_version_id, l_task, 'R', 'F' , error_record('Requested task rollback, but rollback is not allowed', NULL, NULL) );
END IF;
l_task := task_list.NEXT(l_task);
END LOOP;
RETURN l_rtn;
END task_based_rollback;
FUNCTION update_task_based ( p_call_id NUMBER, p_target_version IN VARCHAR2 ) RETURN BOOLEAN IS
l_version_id NUMBER;
l_rtn        BOOLEAN;
BEGIN
l_version_id := log_version_start ( p_call_id, schema_version(), p_target_version );
	
l_rtn := task_based_rollback( p_call_id, l_version_id, p_target_version );
l_rtn := l_rtn AND task_based_apply( p_call_id, l_version_id );
IF NOT l_rtn THEN log_version_end(l_version_id, 'F', NULL); RETURN FALSE;
ELSE              log_version_end(l_version_id, 'S', NULL); RETURN TRUE;
END IF;
EXCEPTION
WHEN OTHERS THEN
log_version_end(l_version_id, 'F', error_record('Unexpected Error', SQLCODE, DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE) );
RETURN FALSE;
END update_task_based;
PROCEDURE convert_to_task IS
l_current_version       pdx_schema_version_history.target_version%TYPE;
l_call_id               pdx_schema_upd_pkgcall_hist.id%TYPE;
l_version_id            NUMBER;
l_taskversion           VARCHAR2(20) := get_config('TASK_VERSION');
l_dummy                 NUMBER;
BEGIN
pkg_pdx_schema_updater_meta.read_metadata;
l_call_id := log_call_start(l_taskversion);
-- We have to be on a version which is task aware prior to converting to dev
l_current_version := schema_version;
IF l_current_version = l_taskversion THEN
l_dummy := log_call_end(l_call_id, 15, 'F', error_record('This schema is already a Task-Based schema',NULL,NULL) );
COMMIT;
RAISE_APPLICATION_ERROR(-20010,'This schema is already a Task-Based schema');
END IF;
l_version_id := log_version_start(l_call_id, l_current_version, l_taskversion);
log_version_end(l_version_id, 'S', NULL);
UPDATE pdx_schema_config set value = 'TASK' WHERE KEY = 'APPLYTYPE';
l_dummy := log_call_end(l_call_id, 0, 'S', NULL);
COMMIT;
END;
PROCEDURE convert_to_release (p_version VARCHAR2 := NULL) IS
l_call_id               pdx_schema_upd_pkgcall_hist.id%TYPE;
l_version_id            NUMBER;
	  l_upg_version_id        NUMBER;
l_current_version       pdx_schema_version_history.target_version%TYPE;
	  l_prior_version         pdx_schema_version_history.target_version%TYPE;
l_taskversion           VARCHAR2(20) := get_config('TASK_VERSION');
	  l_prefix                VARCHAR2(20) := get_config('APPLICATION_PREFIX');
l_dummy                 NUMBER;
	  l_version_applied       BOOLEAN;
CURSOR manifest_cur (c_source_version VARCHAR2, c_target_version VARCHAR2) IS
select lead_version target_version,
m2.file_name,
m1.apply_order
from (select version,
lead(version) over (order by apply_order) lead_version,
apply_order
from vw_schema_updater_manifest
) m1
join vw_schema_updater_manifest m2 on (m2.version = m1.lead_version)
where compare_versions(c_source_version,c_target_version) < 0
and compare_versions(lead_version,c_source_version) > 0
and compare_versions(lead_version,c_target_version) <= 0
union all select version, file_name, apply_order from schema_updater_manifest WHERE c_source_version IS NULL
			           and compare_versions(version,c_target_version)<=0
		 ORDER BY apply_order;
manifest_rec manifest_cur%ROWTYPE;
	  CURSOR sql_cur (c_release_file VARCHAR2, c_validate_update_flag VARCHAR2) IS
	    SELECT s.file_name, s.action_code, s.status_code
FROM pdx_schema_taskver_meta m
JOIN pdx_schema_file_taskver r ON (r.file_type = 'R' and r.task_version = m.task_version)
LEFT OUTER JOIN pdx_schema_file_taskver t ON (t.file_type = 'T' and t.task_version = m.task_version_value)
LEFT OUTER JOIN pdx_schema_updater_sql s ON (s.file_name = t.file_name)
WHERE m.meta_tag = 'RELEASETASK'
AND m.task_source = 'B'
AND r.file_name = c_release_file
		   AND (   (c_validate_update_flag = 'V' AND NVL(s.action_code,'R') != 'A' OR NVL(s.status_code,'F') != 'S')
		        OR (c_validate_update_flag = 'U' AND s.version = l_taskversion)
			   );
	  sql_rec sql_cur%ROWTYPE;
BEGIN
pkg_pdx_schema_updater_meta.read_metadata;
	  BEGIN
SELECT CASE WHEN target_version IS NULL THEN NULL ELSE current_version END INTO l_prior_version
FROM pdx_schema_version_history
	     WHERE id = (SELECT MAX(ID) FROM pdx_schema_version_history
		              WHERE (current_version != l_taskversion AND target_version = l_taskversion AND status_code = 'S')
					     OR (current_version = l_taskversion AND target_version IS NULL AND status_code = 'S')
				    );
	  EXCEPTION WHEN NO_DATA_FOUND THEN l_prior_version := NULL;
	  END;
	  l_call_id := log_call_start(NVL(p_version,l_prior_version));
l_current_version := schema_version;
IF l_current_version != l_taskversion THEN
l_dummy := log_call_end(l_call_id, 15, 'F', error_record('This schema is already a Release-Based schema',NULL,NULL) );
COMMIT;
RAISE_APPLICATION_ERROR(-20010,'This schema is already a Release-Based schema');
ELSE
l_version_id := log_version_start(l_call_id, l_taskversion, NVL(p_version,l_prior_version));
IF p_version IS NOT NULL THEN
IF compare_versions(l_prior_version,p_version) > 0 THEN
		    RAISE_APPLICATION_ERROR(-20100,'You cannot convert to a release prior to the point of conversion.  Earliest allowed release is '||l_prior_version);
		  END IF;
		  OPEN manifest_cur(l_prior_version,p_version);
		  FETCH manifest_cur INTO manifest_rec;
		  WHILE manifest_cur%FOUND LOOP
		    OPEN sql_cur(manifest_rec.file_name, 'V');
			FETCH sql_cur INTO sql_rec;
			l_version_applied := sql_cur%NOTFOUND;
			CLOSE sql_cur;
			IF NOT l_version_applied THEN
			  RAISE_APPLICATION_ERROR(-20100,'Unable to mark version '||manifest_rec.target_version||' as applied due to unapplied tasks required for that version');
			END IF;
l_upg_version_id := log_version_start(l_call_id, manifest_rec.target_version, l_taskversion);
			FOR rec IN sql_cur(manifest_rec.file_name,'U') LOOP
UPDATE pdx_schema_updater_sql
			     SET version = manifest_rec.target_version
			   WHERE file_name = rec.file_name;
			  log_task_history(l_call_id, l_upg_version_id, rec.file_name, rec.action_code, rec.status_code, NULL);
			END LOOP;
			INSERT INTO pdx_schema_updater_manifest (version, file_name, apply_order) VALUES (manifest_rec.target_version, manifest_rec.file_name, pdx_schema_master_seq.nextval);
			log_version_end(l_upg_version_id, 'S', NULL);
		    FETCH manifest_cur INTO manifest_rec;
		  END LOOP;
		  CLOSE manifest_cur;
END IF;
DELETE FROM schema_updater_sql WHERE file_name IN (SELECT file_name from pdx_schema_updater_sql WHERE version = l_taskversion);
IF task_based_rollback(l_call_id, l_version_id, l_taskversion) THEN
UPDATE pdx_schema_config set value = 'RELEASE' WHERE KEY = 'APPLYTYPE';
		  IF p_version IS NOT NULL THEN
		    l_upg_version_id := log_version_start(l_call_id, l_taskversion, p_version);
		    log_version_end(l_upg_version_id, 'S', NULL);
		  END IF;
		  log_version_end(l_version_id, 'S', NULL);
		  l_dummy := log_call_end(l_call_id, 0, 'S', NULL);
		ELSE
		  log_version_end(l_version_id, 'F', NULL);
		  l_dummy := log_call_end(l_call_id, 11, 'F', NULL);
END IF;
END IF;
END;
FUNCTION version_updater (p_call_id           pdx_schema_upd_pkgcall_hist.id%TYPE,
p_current_version   IN       VARCHAR2,
p_target_version    IN       VARCHAR2,
p_filename  VARCHAR2,
p_action    VARCHAR2
) RETURN BOOLEAN AS
l_version_id NUMBER;
l_dummy_id NUMBER;
l_prefix  VARCHAR2(50) := get_config('APPLICATION_PREFIX');
l_sql_ddl CLOB;
l_sql_tmp CLOB;
l_rb   VARCHAR2(20);
l_rb_ok BOOLEAN;
task_list task_tbl;
task_proc ind_tbl;
task_proc_ind NUMBER(3);
l_processed  BOOLEAN;
l_rtn        BOOLEAN := true;
l_result     BOOLEAN;
l_task       VARCHAR2(50);
l_status     VARCHAR2(2);
-- Convert Release U/D (p_action) to Task A/R (t_action)
t_action    VARCHAR2(1) := CASE p_action
WHEN 'U' THEN 'A'
WHEN 'D' THEN 'R'
END;
--  --@TA12345, --@ta12345.sql becomes TA12345 in tasks subquery
-- Don't get confused -- Versions are Upgrade/Downgrade, but SQL is Apply/Rollback
CURSOR sql_task_csr (c_filename VARCHAR2, c_action VARCHAR2) IS
WITH tasks AS (
SELECT t.file_name, upper(m.task_version_value) task
FROM pdx_schema_file_taskver r
JOIN pdx_schema_taskver_meta m ON (m.meta_tag = 'RELEASETASK' and m.task_source = DECODE(c_action,'D','A','B') and m.task_version = r.task_version)
LEFT OUTER JOIN pdx_schema_file_taskver t ON (t.task_version = m.task_version_value and t.file_type = 'T')
WHERE r.file_name = c_filename
AND r.file_type = 'R'
)
SELECT file_name
FROM tasks
LEFT OUTER JOIN pdx_schema_updater_sql applied_sql USING (file_name)
WHERE (   (c_action = 'D' AND (NVL(action_code,'R') != 'R' OR NVL(status_code,'S') != 'S') AND (p_target_version IS NULL OR pkg_pdx_schema_updater.compare_versions(NVL(version,p_target_version),p_target_version)>0))
OR (c_action = 'U' AND (NVL(action_code,'R') != 'A' OR NVL(status_code,'S') != 'S'))
);
CURSOR rb_cur(c_task VARCHAR2) IS
SELECT file_name, upper(task_version_value) rollback_task
FROM pdx_schema_taskver_meta
JOIN pdx_schema_file_taskver USING (task_version)
JOIN pdx_schema_updater_sql USING (file_name)
WHERE meta_tag = 'ROLLBACK' AND task_source = 'A'
AND (action_code != 'R' OR status_code != 'S')
AND upper(task_version_value) = upper(pkg_pdx_schema_updater_meta.get_taskname(c_task));
PROCEDURE log_rb_sql_history (p_call_id pdx_schema_upd_pkgcall_hist.id%TYPE,
p_version_id pdx_schema_version_history.id%TYPE,
p_filename pdx_schema_task_history.file_name%TYPE) IS
l_id pdx_schema_task_history.id%TYPE;
BEGIN
-- ROLLBACK;TASK mistakenly logged as rollback is not allowed
BEGIN
SELECT id
INTO l_id
FROM pdx_schema_task_history
JOIN pdx_schema_task_error_log USING (id)
WHERE NVL(pdx_schema_upd_pkgcall_hist_id,-1) = NVL(p_call_id,-1)
AND NVL(pdx_schema_version_history_id,-1) = NVL(p_version_id,-1)
AND file_name = p_filename
AND action_code = 'R'
AND status_code = 'F'
AND error_message = 'Requested task rollback, but rollback is not allowed';
DELETE
FROM pdx_schema_task_error_log
WHERE id = l_id;
DELETE
FROM pdx_schema_task_history
WHERE id = l_id;
EXCEPTION
WHEN NO_DATA_FOUND THEN
NULL;
END;
log_sql(p_call_id, p_version_id, p_filename,'R','S',NULL);
END;
BEGIN
l_version_id := log_version_start(p_call_id, p_current_version, p_target_version);
BEGIN
	    l_sql_ddl := get_sql(p_filename, p_action);
EXCEPTION
WHEN OTHERS THEN
log_version_end(l_version_id, 'F', error_record('Unable to find SQL for file ['||p_filename||']', SQLCODE, DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE) );
RETURN FALSE;
END;
IF pkg_pdx_schema_updater_meta.get_filetype(p_filename) != 'R' THEN
log_version_end(l_version_id, 'F', error_record(p_filename||' is not a valid release file', NULL, NULL) );
RETURN FALSE;
END IF;
l_rb := UPPER(NVL(get_metadata(p_filename,'ROLLBACK',p_action),'YES'));
l_rb_ok := l_rb IN ('TRUE','YES');
IF p_action = 'D' AND NOT l_rb_ok THEN
log_version_end(l_version_id, 'F', error_record('No rollback allowed from '||p_current_version,NULL,NULL) );
RETURN FALSE;
END IF;
l_dummy_id := log_sql_start(p_call_id, l_version_id, p_filename, p_action);
task_list.DELETE;
FOR sql_task_rec IN sql_task_csr (p_filename, p_action) LOOP
l_task := sql_task_rec.file_name;
BEGIN
l_sql_tmp := get_sql(l_task,t_action);
EXCEPTION WHEN OTHERS THEN
log_sql_end ( l_dummy_id, p_filename, 'F', NULL );
log_version_end(l_version_id, 'F', error_record('Unable to find SQL for task ['||l_task||']', SQLCODE, DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE) );
RETURN FALSE;
END;
l_rb := UPPER(NVL(get_metadata(l_task,'ROLLBACK',t_action),'YES'));
l_rb_ok := l_rb IN ('TRUE','YES');
l_status := get_status(l_task);
IF t_action = 'R' AND l_status = 'RS' THEN
log_task_history ( p_call_id, l_version_id, l_task, t_action, 'W', error_record('No action taken: Task status is already rolled back',NULL,NULL) );
ELSIF t_action = 'R' and l_status = 'AD' THEN
log_sql ( p_call_id, l_version_id, l_task, t_action, 'D', error_record('No action taken: Task is deprecated and therefore not applied',NULL,NULL) );
ELSIF t_action = 'A' and l_status = 'AS' THEN
log_task_history ( p_call_id, l_version_id, l_task, t_action, 'W', error_record('No action taken: Task status is already applied',NULL,NULL) );
ELSIF t_action = 'R' AND NOT l_rb_ok THEN
IF l_rb IN ('NO','FALSE') THEN
		    -- Release succeeds, so this is just a task_history warning
			-- Task is still applied so we leave it in AS status
log_task_history ( p_call_id, l_version_id, l_task, t_action, 'W', error_record('Requested task rollback, but rollback is not allowed',NULL,NULL) );
ELSIF l_rb = 'WRAPPED' THEN
		    -- Only a warning, however, we want SQL to reapply on next upgrade, thus changing sql action
log_task_history ( p_call_id, l_version_id, l_task, 'W', 'S', error_record('Requested task rollback, but rollback is not allowed (Wrapped)',NULL,NULL) );
			UPDATE pdx_schema_updater_sql SET action_code = 'W', status_code = 'S' WHERE file_name = l_task;
ELSE
--Assumed to be ROLLBACK:{Task}
task_list(l_task) := NULL;
END IF;
ELSE
task_list(l_task) := NULL;
END IF;
END LOOP;
IF p_action = 'U' THEN
l_task := task_list.FIRST;
FOR task_ctr IN 1..task_list.COUNT LOOP
l_sql_tmp := get_sql(l_task,'A');
IF is_deprecated(l_task,task_list) THEN
log_sql(p_call_id, l_version_id,l_task, 'A', 'D', error_record('Task has been deprecated and will not be applied',NULL,NULL) );
task_list.DELETE(l_task);
ELSIF is_excluded(l_task, false) THEN
log_sql(p_call_id, l_version_id,l_task, 'A', 'X', error_record('Task has been excluded and will not be applied',NULL,NULL) );
task_list.DELETE(l_task);
END IF;
DECLARE
l_task_type pdx_schema_task_history.task_type%TYPE;
l_attribcheck pkg_pdx_schema_updater_meta.results_tbl;
l_key         VARCHAR2(255);
l_value       VARCHAR2(255);
l_excluded    BOOLEAN := false;
l_idx         NUMBER;
BEGIN
l_attribcheck := get_metadata_tbl(l_task,'ATTRIBCHECK','A');
l_idx := l_attribcheck.FIRST;
FOR ctr IN 1..l_attribcheck.COUNT LOOP
l_key := TRIM(regexp_substr(l_attribcheck(l_idx),'^([^:]*):',1,1,NULL,1));
l_value := TRIM(regexp_substr(l_attribcheck(l_idx),'^[^:]*:[ 	]*(.*)$',1,1,NULL,1));
CASE UPPER(l_key)
WHEN NULL THEN NULL;  -- Currently, there are no supported ATTRIBCHECK metadata
ELSE
log_sql(p_call_id, l_version_id,l_task, 'A', 'F', error_record('Task contains invalid metadata ATTRIBCHECK: '||l_key,NULL,NULL) );
l_rtn := false;
task_list.DELETE(l_task);
END CASE;
EXIT WHEN (NOT l_rtn) or l_excluded;
l_idx := l_attribcheck.NEXT(l_idx);
END LOOP;
END;
l_task := task_list.NEXT(l_task);
EXIT WHEN l_task IS NULL OR NOT l_rtn;
END LOOP;
END IF;
IF l_rtn THEN
l_processed := TRUE;
WHILE task_list.COUNT > 0 AND l_processed LOOP
l_task := task_list.FIRST;
l_processed := FALSE;
FOR task_ctr IN 1..task_list.COUNT LOOP
IF ((p_action = 'D' AND rb_dependencies_met(l_task)) OR (p_action = 'U' AND dependencies_met(l_task))) AND l_rtn THEN
--Once a run_sql fails, IF will prevent further executions
IF p_action = 'U' OR UPPER(NVL(get_metadata(l_task,'ROLLBACK',t_action),'YES')) IN ('YES','NO','TRUE','FALSE','WRAPPED') THEN
l_processed := true;
l_rtn := run_sql(p_call_id, l_version_id, l_task, t_action);
task_list.DELETE(l_task);
IF p_action = 'D' and l_rtn THEN
-- Mark as rollbacked, any task with --ROLLBACK: l_task metadata
FOR rb_rec IN rb_cur(l_task) LOOP
log_rb_sql_history (p_call_id, l_version_id, rb_rec.file_name);
task_list.DELETE(rb_rec.file_name);
END LOOP;
END IF;
END IF;
END IF;
l_task := task_list.NEXT(l_task);
EXIT WHEN l_task IS NULL;
END LOOP;
END LOOP;
END IF;
IF l_rtn THEN
l_task := task_list.FIRST;
FOR task_ctr IN 1..task_list.COUNT LOOP
IF l_rtn THEN
IF ((p_action = 'D' AND rb_dependencies_met(l_task)) OR (p_action = 'U' AND dependencies_met(l_task))) THEN
--Once a run_sql fails, IF will prevent further executions
IF p_action = 'U' OR UPPER(NVL(get_metadata(l_task,'ROLLBACK',t_action),'YES')) IN ('YES','NO','TRUE','FALSE','NO','WRAPPED') THEN
l_rtn := false;
log_task_history(p_call_id, l_version_id,l_task, t_action, 'F', error_record('Task should have been processed based on logic, but is still in task queue',NULL,NULL) );
ELSE
		              l_rtn := false;
log_task_history(p_call_id, l_version_id,l_task, t_action, 'F', error_record('Requested task rollback, but rollback is done by another task',NULL,NULL) );
END IF;
ELSE
l_rtn := false;
log_task_history(p_call_id, l_version_id,l_task, t_action, 'F', error_record('Dependencies were not met for this task',NULL,NULL) );
END IF;
l_task := task_list.NEXT(l_task);
END IF;
END LOOP;
END IF;
IF l_rtn THEN
log_sql_end ( l_dummy_id, p_filename, 'S', NULL );
log_version_end(l_version_id, 'S', NULL);
ELSE
log_sql_end ( l_dummy_id, p_filename, 'F', NULL );
log_version_end(l_version_id, 'F', NULL);
END IF;
RETURN l_rtn;
END version_updater;
FUNCTION update_release_based ( p_call_id NUMBER, p_current_version IN VARCHAR2, p_target_version IN VARCHAR2 ) RETURN BOOLEAN IS
CURSOR manifest_cur (c_source_version VARCHAR2, c_target_version VARCHAR2) IS
select target_version, file_name
FROM (SELECT target_version, file_name, apply_order
FROM (select CASE WHEN c_target_version IS NULL OR compare_versions(lag_version,c_target_version) > 0 THEN lag_version ELSE c_target_version END target_version,
file_name,
m1.apply_order
from (select file_name,
apply_order,
version,
lag(version) over (order by apply_order) lag_version
from vw_schema_updater_manifest
) m1
join pdx_schema_updater_sql using (file_name)
where (c_target_version IS NULL OR (    compare_versions(c_source_version,c_target_version) > 0
and compare_versions(m1.version,c_target_version) > 0
)
)
and (lag_version IS NULL OR compare_versions(lag_version,c_source_version) < 0)
and (action_code != 'D' or status_code != 'S')
)
union all
select lead_version target_version,
m2.file_name,
m1.apply_order
from (select version,
lead(version) over (order by apply_order) lead_version,
apply_order
from vw_schema_updater_manifest
) m1
join vw_schema_updater_manifest m2 on (m2.version = m1.lead_version)
where compare_versions(c_source_version,c_target_version) < 0
and compare_versions(lead_version,c_source_version) > 0
and compare_versions(lead_version,c_target_version) <= 0
and c_source_version IS NOT NULL
union all select version, file_name, apply_order from schema_updater_manifest WHERE c_source_version IS NULL and compare_versions(version,c_target_version) <= 0
)
order by apply_order*compare_versions(c_source_version,c_target_version)*-1;
manifest_rec manifest_cur%ROWTYPE;
l_action_code VARCHAR2(1);
l_result      BOOLEAN        := TRUE;
l_current_version VARCHAR2(20);
BEGIN
-- The following will check to see if there is a partial apply to clean up
-- For example last successful shows we are on 2600.002, but we had previously failed to upgrade to 2600.003
-- and part of that file is still applied
-- No error will be thrown regardless of outcome if p_current_version = p_target_version
DECLARE
l_cversion pdx_schema_version_history.current_version%TYPE;
			l_tversion pdx_schema_version_history.target_version%TYPE;
BEGIN
SELECT current_version,
			       target_version
INTO l_cversion, l_tversion
FROM pdx_schema_version_history
WHERE id = (SELECT MAX(id)
FROM pdx_schema_version_history
WHERE (   target_version = pkg_pdx_schema_updater.schema_version
						         OR current_version = pkg_pdx_schema_updater.schema_version
								)
AND (current_version != target_version OR status_code = 'S')
)
AND status_code NOT IN ('S','I');
l_current_version := pkg_pdx_schema_updater.schema_version;
			
			-- If prior failure was upgrading and we are now upgrading, then no need to handle here
			-- We only need to handle if it would not be captured by the standard current_version => target version execution
			
			-- cversion should equal current_version ...
			IF compare_versions(l_cversion,l_tversion) < 0 AND compare_versions(l_current_version,p_target_version) >= 0 THEN
OPEN manifest_cur(l_tversion, l_cversion);
FETCH manifest_cur INTO manifest_rec;
IF manifest_cur%FOUND AND get_status(manifest_rec.file_name) != 'DS' THEN
l_result := version_updater(p_call_id, manifest_rec.target_version, l_current_version, manifest_rec.file_name, 'D');
END IF;
CLOSE manifest_cur;
			ELSIF compare_versions(l_cversion,l_tversion) > 0 AND compare_versions(l_current_version,p_target_version) <= 0 THEN
OPEN manifest_cur(l_tversion, l_cversion);
FETCH manifest_cur INTO manifest_rec;
IF manifest_cur%FOUND AND get_status(manifest_rec.file_name) != 'US' THEN
l_result := version_updater(p_call_id, manifest_rec.target_version, l_current_version, manifest_rec.file_name, 'U');
END IF;
CLOSE manifest_cur;
			END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
NULL;
END;
IF l_result THEN
IF p_target_version IS NULL THEN
l_action_code := 'D';
ELSIF NVL(pkg_pdx_schema_updater.schema_version,'#') = NVL(p_target_version,'#') THEN
RETURN TRUE;
ELSIF pkg_pdx_schema_updater.schema_version IS NULL OR compare_versions(pkg_pdx_schema_updater.schema_version,p_target_version) < 0 THEN
l_action_code := 'U';
ELSE
l_action_code := 'D';
END IF;
l_current_version := pkg_pdx_schema_updater.schema_version;
OPEN manifest_cur(pkg_pdx_schema_updater.schema_version, p_target_version);
FETCH manifest_cur INTO manifest_rec;
WHILE manifest_cur%FOUND AND l_result LOOP
l_result := version_updater(p_call_id, l_current_version, manifest_rec.target_version, manifest_rec.file_name, l_action_code);
IF l_result THEN
l_current_version := manifest_rec.target_version;
FETCH manifest_cur INTO manifest_rec;
END IF;
END LOOP;
END IF;
RETURN l_result;
END update_release_based;
PROCEDURE update_schema ( p_target_version    IN       VARCHAR2,
p_return_code       OUT      NUMBER,
p_allow_downgrade   IN       BOOLEAN := NULL
) AS
EX_UPG_DNG_IN_PROGRESS         EXCEPTION;
EX_NO_VERSION_HISTORY          EXCEPTION;
EX_INVALID_TARGET_VERSION      EXCEPTION;
EX_INCOMPATIBLE_APPLYTYPE      EXCEPTION;
EX_PDX_TABLES_CORRUPT          EXCEPTION;
EX_INVALID_CURRENT_VERSION     EXCEPTION;
EX_DOWNGRADE_NOT_ALLOWED       EXCEPTION;
EX_CORRUPT_MANIFEST            EXCEPTION;
EX_RELEASE_FAILED              EXCEPTION;
EX_TASK_FAILED                 EXCEPTION;
EX_NOTHING_TO_DO               EXCEPTION;
EX_INVALID_CONFIG_KEY          EXCEPTION;
l_rtn             BOOLEAN;
l_undo_rtn        BOOLEAN;
l_pkgcall_id      NUMBER;
l_process_id      NUMBER;
l_current_version VARCHAR2(20);
FUNCTION l_update_in_progress ( p_pkgcall_id NUMBER ) RETURN BOOLEAN IS
CURSOR in_progress_cur IS
SELECT NULL
FROM pdx_schema_upd_pkgcall_hist
WHERE id != p_pkgcall_id
AND UPPER(status_code) = 'I';
l_rtn BOOLEAN;
l_dummy VARCHAR2(1);
BEGIN
OPEN in_progress_cur;
FETCH in_progress_cur INTO l_dummy;
l_rtn := in_progress_cur%FOUND;
CLOSE in_progress_cur;
RETURN l_rtn;
END l_update_in_progress;
PROCEDURE l_validate_current_version ( p_current_version VARCHAR2, p_target_version VARCHAR2 ) IS
l_cnt NUMBER;
		  l_non_pdx_object_count NUMBER;
l_value VARCHAR2(10);
BEGIN
IF p_current_version IS NULL THEN
SELECT COUNT(*) INTO l_non_pdx_object_count FROM user_objects WHERE object_name NOT LIKE 'PDX_SCHEMA%' AND object_name NOT LIKE 'SCHEMA_UPDATER%' AND object_name NOT LIKE 'PKG_PDX_SCHEMA_UPDATER%' AND object_name NOT LIKE 'VW_SCHEMA_UPDATER%' AND object_type IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE','SEQUENCE');
		    IF l_non_pdx_object_count != 0 THEN
SELECT COUNT(*) INTO l_cnt FROM (SELECT file_name FROM pdx_schema_updater_sql WHERE version != p_target_version AND (action_code NOT IN ('R','D') OR status_code NOT IN ('S','X','D')) UNION ALL SELECT file_name FROM pdx_schema_updater_manifest WHERE version != p_target_version);
BEGIN SELECT value INTO l_value FROM pdx_schema_config WHERE key = 'PREEXISTINGSCHEMA' and source = 'A'; EXCEPTION WHEN NO_DATA_FOUND THEN l_value := NULL; END;
IF l_cnt > 0 OR NVL(l_value,'Y') = 'N' THEN RAISE EX_NO_VERSION_HISTORY; END IF;
			END IF;
MERGE INTO pdx_schema_config tgt USING (SELECT 'PREEXISTINGSCHEMA' key, CASE WHEN l_non_pdx_object_count = 0 THEN 'N' ELSE 'Y' END value, 'A' source FROM DUAL) src ON (tgt.key = src.key AND tgt.source = src.source)
WHEN NOT MATCHED THEN INSERT (key, value, source) values (src.key, src.value, src.source);
END IF;
IF get_config('TASK_VERSION') = p_current_version AND get_config('APPLY_TYPE') != 'TASK' THEN RAISE EX_INCOMPATIBLE_APPLYTYPE; END IF;
IF get_config('TASK_VERSION') != p_current_version AND get_config('APPLY_TYPE') != 'RELEASE' THEN RAISE EX_INCOMPATIBLE_APPLYTYPE; END IF;
IF p_current_version IS NOT NULL AND p_current_version != get_config('TASK_VERSION') THEN
SELECT COUNT(*) INTO l_cnt FROM pdx_schema_updater_manifest m JOIN pdx_schema_updater_sql s USING (file_name) WHERE m.version = p_current_version;
IF l_cnt != 1 THEN RAISE EX_PDX_TABLES_CORRUPT; END IF;
-- IF p_target_version IS NULL then we are downgrading and don't require schema_updater_manifest
IF p_target_version IS NOT NULL THEN
SELECT COUNT(*) INTO l_cnt FROM pdx_schema_updater_manifest m JOIN pdx_schema_updater_sql s USING (file_name) WHERE m.version = p_target_version;
-- IF p_target_version IS in pdx_schema_updater_manifest then we are downgrading and don't require schema_updater_manifest
IF l_cnt != 1 THEN
SELECT COUNT(*) INTO l_cnt FROM schema_updater_manifest m JOIN schema_updater_sql s USING (file_name) WHERE m.version = p_current_version;
IF l_cnt != 1 THEN RAISE EX_INVALID_CURRENT_VERSION; END IF;
END IF;
END IF;
END IF;
END l_validate_current_version;
PROCEDURE l_validate_target_version ( p_current_version VARCHAR2, p_target_version VARCHAR2 ) IS
l_cnt NUMBER;
BEGIN
IF get_config('TASK_VERSION') = p_target_version AND get_config('APPLY_TYPE') != 'TASK' THEN RAISE EX_INCOMPATIBLE_APPLYTYPE; END IF;
IF get_config('TASK_VERSION') != p_target_version AND get_config('APPLY_TYPE') != 'RELEASE' THEN RAISE EX_INCOMPATIBLE_APPLYTYPE; END IF;
IF p_target_version IS NOT NULL THEN
IF NOT (get_config('TASK_VERSION') = p_target_version AND get_config('APPLY_TYPE') = 'TASK') THEN
SELECT COUNT(*) INTO l_cnt FROM pdx_schema_updater_manifest m WHERE m.version = p_target_version;
IF l_cnt = 0 THEN
SELECT COUNT(*) INTO l_cnt FROM schema_updater_manifest m WHERE m.version = p_target_version;
IF l_cnt != 1 THEN RAISE EX_INVALID_TARGET_VERSION; END IF;
/* TO DO
-- Add validation that we don't have conflicting version order between schema_updater_manifest and pdx_schema_updater_manifest
*/
END IF;
END IF;
END IF;
END l_validate_target_version;
PROCEDURE l_validate_manifest (p_current_version VARCHAR2, p_target_version VARCHAR2) IS
a_file VARCHAR2(255);
b_file VARCHAR2(255);
l_cnt  NUMBER;
BEGIN
BEGIN SELECT file_name INTO a_file FROM pdx_schema_updater_manifest WHERE apply_order = (SELECT MAX(apply_order) FROM pdx_schema_updater_manifest); EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;
BEGIN SELECT file_name INTO b_file FROM schema_updater_manifest WHERE apply_order = (SELECT MAX(m.apply_order) FROM schema_updater_manifest m JOIN pdx_schema_updater_manifest USING (file_name)); EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;
-- If l_cnt = 2 then we are downgrading so order doesn't matter
SELECT COUNT(*) + CASE WHEN p_current_version IS NULL THEN 1 ELSE 0 END + CASE WHEN p_target_version IS NULL THEN 1 ELSE 0 END + CASE WHEN p_current_version = p_target_version THEN 1 ELSE 0 END INTO l_cnt FROM pdx_schema_updater_manifest WHERE version IN (p_current_version, p_target_version);
IF a_file IS NOT NULL AND (b_file IS NULL OR b_file != a_file) AND l_cnt != 2 THEN RAISE EX_CORRUPT_MANIFEST; END IF;
END l_validate_manifest;
PROCEDURE l_validate_action ( p_current_version VARCHAR2, p_target_version VARCHAR2 ) IS
	      l_rb NUMBER := get_config('ALLOW_DOWNGRADE');
BEGIN
IF p_current_version IS NOT NULL THEN
IF p_target_version IS NULL THEN
IF NOT NVL(p_allow_downgrade,FALSE) THEN RAISE EX_DOWNGRADE_NOT_ALLOWED; END IF;
ELSE
IF get_config('APPLY_TYPE') = 'RELEASE' AND compare_versions(p_current_version, p_target_version) > 0 AND NOT (l_rb = -1 OR NVL(p_allow_downgrade,FALSE) OR l_rb >= compare_versions(p_current_version, p_target_version)) THEN
RAISE EX_DOWNGRADE_NOT_ALLOWED;
END IF;
END IF;
END IF;
END l_validate_action;
BEGIN
l_pkgcall_id := log_call_start(p_target_version);
	  refresh_config;
	
IF l_update_in_progress(l_pkgcall_id) THEN RAISE EX_UPG_DNG_IN_PROGRESS; END IF;
l_current_version := schema_version();
l_validate_current_version(l_current_version, p_target_version);
l_validate_target_version(l_current_version, p_target_version);
	  if get_config('APPLY_TYPE') = 'RELEASE' THEN
l_validate_manifest(l_current_version, p_target_version);
	  END IF;
l_validate_action(l_current_version, p_target_version);
l_process_id := log_process_start(l_pkgcall_id, NULL, 'Converting schema_updater_sql to Unix'); dos2unix; log_process_end(l_process_id);
l_process_id := log_process_start(l_pkgcall_id, NULL, 'Purge Schema Error Logs'); purge_schema_error_logs(SYSDATE-365); log_process_end(l_process_id);
l_process_id := log_process_start(l_pkgcall_id, NULL, 'Reading metadata'); pkg_pdx_schema_updater_meta.read_metadata; log_process_end(l_process_id);
IF get_config('APPLY_TYPE') = 'TASK' THEN
l_rtn := update_task_based(l_pkgcall_id, p_target_version);
ELSE
l_rtn := update_release_based(l_pkgcall_id, l_current_version, p_target_version);
IF NOT l_rtn AND get_config('AUTO_UNDO') = 'Y' THEN
l_undo_rtn := update_release_based(l_pkgcall_id, schema_version(), l_current_version);
END IF;
END IF;
IF p_target_version IS NULL THEN
DECLARE
		  l_apply_type  VARCHAR2(15);
		  l_non_pdx_object_count NUMBER;
	      l_preexisting   VARCHAR2(1);
	    BEGIN
l_apply_type := get_config('APPLY_TYPE');
BEGIN SELECT value INTO l_preexisting FROM pdx_schema_config WHERE key = 'PREEXISTINGSCHEMA' and source = 'A'; EXCEPTION WHEN NO_DATA_FOUND THEN l_preexisting := 'Y'; END;
	      IF  l_apply_type = 'RELEASE' AND NOT l_rtn THEN
-- We will convert to task and attempt again
			DECLARE
l_task VARCHAR2(20) := get_config('TASK_VERSION');
			  l_version_id NUMBER;
			BEGIN
			  l_version_id := log_version_start(l_pkgcall_id, NULL, l_task);
		      UPDATE pdx_schema_config SET value = 'TASK' WHERE key = 'APPLYTYPE';
			  log_version_end(l_version_id,'S',NULL);
COMMIT;
l_rtn := update_task_based(l_pkgcall_id, p_target_version);
IF l_rtn AND schema_version() IS NULL THEN
			    UPDATE pdx_schema_config SET value = 'RELEASE' WHERE key = 'APPLYTYPE';
			    COMMIT;
			  END IF;
			END;
		  END IF;
SELECT COUNT(*) INTO l_non_pdx_object_count FROM user_objects WHERE object_name NOT LIKE 'PDX_SCHEMA%' AND object_name NOT LIKE 'SCHEMA_UPDATER%' AND object_name NOT LIKE 'PKG_PDX_SCHEMA_UPDATER%' AND object_name NOT LIKE 'VW_SCHEMA_UPDATER%' AND object_type IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE','SEQUENCE');
		  IF  l_non_pdx_object_count > 0 AND l_preexisting = 'N' THEN
reset_schema;
			UPDATE pdx_schema_config SET value = l_apply_type WHERE key = 'APPLYTYPE';
			COMMIT;
			l_rtn := TRUE;
		  END IF;
		END;
	  END IF;
IF get_config('MANAGE_PRIVS') = 'Y' THEN l_process_id := log_process_start(l_pkgcall_id, NULL, 'Granting Privileges'); grant_privs_on_own_objs; log_process_end(l_process_id); END IF;
IF get_config('MANAGE_SYNONYMS') = 'Y' THEN l_process_id := log_process_start(l_pkgcall_id, NULL, 'Creating Synonyms'); create_synonyms_on_own_objs; log_process_end(l_process_id); END IF;
IF NOT l_rtn THEN
IF get_config('APPLY_TYPE') = 'TASK' THEN RAISE EX_TASK_FAILED;
ELSE                                      RAISE EX_RELEASE_FAILED;
END IF;
ELSIF get_config('APPLY_TYPE') = 'RELEASE' AND l_current_version = p_target_version THEN RAISE EX_NOTHING_TO_DO;
END IF;
p_return_code := log_call_end(l_pkgcall_id,0,'S',NULL);
EXCEPTION
WHEN EX_NOTHING_TO_DO            THEN p_return_code := log_call_end(l_pkgcall_id, 00, 'F', error_record('Target Version ['||p_target_version||'] is already applied - nothing to do.', NULL, NULL) );
WHEN EX_UPG_DNG_IN_PROGRESS      THEN p_return_code := log_call_end(l_pkgcall_id, 01, 'F', error_record('An upgrade or downgrade is in progress and must finish before another upgrade/downgrade can begin.', NULL, NULL) );
WHEN EX_NO_VERSION_HISTORY       THEN p_return_code := log_call_end(l_pkgcall_id, 02, 'F', error_record('Version is NULL according to pdx_schema_updater tables, however, user objects were found in schema.', NULL, NULL) );
WHEN EX_INVALID_TARGET_VERSION   THEN p_return_code := log_call_end(l_pkgcall_id, 03, 'F', error_record('Target version ['||p_target_version||'] was not found in pdx_schema_updater_manifest/sql (Downgrading) or schema_updater_manifest/sql (Upgrading).', NULL, NULL) );
WHEN EX_INCOMPATIBLE_APPLYTYPE   THEN p_return_code := log_call_end(l_pkgcall_id, 04, 'F', error_record('Incompatible ApplyType ['||get_config('APPLY_TYPE')||']: Current Version ['||l_current_version||'] Target Version ['||p_target_version||'].', NULL, NULL) );
WHEN EX_PDX_TABLES_CORRUPT       THEN p_return_code := log_call_end(l_pkgcall_id, 05, 'F', error_record('Current Version ['||l_current_version||'] is missing from pdx_schema_updater_manifest/sql.', NULL, NULL) );
WHEN EX_INVALID_CURRENT_VERSION  THEN p_return_code := log_call_end(l_pkgcall_id, 06, 'F', error_record('Current Version ['||l_current_version||'] is missing from schema_updater_manifest/sql.', NULL, NULL) );
WHEN EX_DOWNGRADE_NOT_ALLOWED    THEN p_return_code := log_call_end(l_pkgcall_id, 07, 'F', error_record('Downgrade has been requested, however, configuration does not allow downgrade.  Please contact DBA for assistance.', NULL, NULL) );
WHEN EX_INVALID_CONFIG_KEY       THEN p_return_code := log_call_end(l_pkgcall_id, 08, 'F', error_record('Oops.  Requested invalid Configuration Key -- Schema Updater code issue.', NULL, NULL) );
WHEN EX_CORRUPT_MANIFEST         THEN p_return_code := log_call_end(l_pkgcall_id, 09, 'F', error_record('Conflicting information (Version apply order) was found in pdx_schema_updater_manifest and schema_updater_manifest.', NULL, NULL) );
WHEN EX_RELEASE_FAILED           THEN p_return_code := log_call_end(l_pkgcall_id, 10, 'F', NULL);
WHEN EX_TASK_FAILED              THEN p_return_code := log_call_end(l_pkgcall_id, 11, 'F', NULL);
WHEN OTHERS                      THEN p_return_code := log_call_end(l_pkgcall_id, 12, 'F', error_record('Unexpected Error', SQLCODE, DBMS_UTILITY.FORMAT_ERROR_STACK||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE) );
END update_schema;
END;

/
CREATE OR REPLACE package      SBMO.PKG_PDX_SCHEMA_UPDATER_HELPER as
/**********************************************************************************************************************
* PROCEDURE: Executed from task file and takes appropriate action based upon parameters and current schema
***********************************************************************************************************************
* p_change_list:   commma-separated list of column datatypes, e.g. 'COL1 NUMBER(13,4), COL2 VARCHAR2(20)
* p_increase_only: only apply for release-based if precision or scale or length are increased
*                  always apply for task-based
* p_use_ctas:      use CTAS rather than temporary columns
*********************************************************************************************************************/
PROCEDURE change_precision_scale (p_table_name VARCHAR2, p_change_list VARCHAR2, p_parallel NUMBER := 0, p_increase_only BOOLEAN := false, p_use_ctas boolean := false, p_set_unused BOOLEAN := false);
/**********************************************************************************************************************
* PROCEDURE: Executed from task file and takes appropriate action based upon parameters and current schema
***********************************************************************************************************************
* Uses DROP column in task-based schemas.  Uses SET UNUSED in release-based schemas
***********************************************************************************************************************/
PROCEDURE drop_column (p_table_name VARCHAR2, p_drop_list VARCHAR2);
/**********************************************************************************************************************
* PROCEDURE: Drops unused columns
***********************************************************************************************************************
* Drops unused columns from table_name when provided, otherwise drops unused columns from all tables
***********************************************************************************************************************/
PROCEDURE drop_unused (p_table_name VARCHAR2 := NULL);
PROCEDURE set_debug(p_value BOOLEAN);
-- Will delete from pdx_schema_upd_helper_debug_h where debug_timestamp < p_date
PROCEDURE purge_debug(p_date TIMESTAMP, p_proc VARCHAR2 := NULL);
end pkg_pdx_schema_updater_helper;

/
CREATE OR REPLACE package body      SBMO.PKG_PDX_SCHEMA_UPDATER_HELPER as
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

/
CREATE OR REPLACE PACKAGE      SBMO.PKG_PDX_SCHEMA_UPDATER_META AS
TYPE results_tbl IS TABLE OF VARCHAR2(2000);
FUNCTION meta_version RETURN VARCHAR2;
-- Reads and parses all metadata from pdx_schema_updater_sql (APPLIED) and schema_updater_sql (BUILD)
-- PDX_SCHEMA_FILE_TASKVER ( FILE_NAME, TASK_VERSION, FILE_TYPE ) will contain file_name to task or version mapping ... File Type will be T or R
-- PDX_SCHEMA_TASKVER_META ( TASK_VERSION, TASK_SOURCE, META_TAG, TASK_VERSION_VALUE ) will contain the metadata
--       TASK_VERSION is the Task/Version, i.e. TA12345 or 2.6.05.003
--       TASK_SOURCE is either A or B (Apply or Build)
--       META_TAG is the Metadata Tag, e.g. ROLLBACK, REQUIRES, etc.
--       TASK_VERSION_VALUE is the Metadata Value (Normalized).  e.g. For ROLLBACK, it would be YES, NO, or TA12345
--                          For REQUIRES, there will be one row for each required task
-- MetaTag RELEASETASK is created to list tasks associated with release files
PROCEDURE read_metadata;
-- read_metadata is incremental based on changing ora_hash(sql) values.
-- delete_metadata will delete metadata
PROCEDURE delete_metadata;
-- Used to refresh metadata from pdx_schema_updater_sql.  Should be called after attempting to apply any task.
PROCEDURE refresh_metadata_apply (p_file_or_task VARCHAR2);
-- Used to keep track of processed SQL
FUNCTION meta_hash (p_sql CLOB) RETURN VARCHAR2;
-- The following are for use in PL/SQL
-- While they can be used in SQL, it will likely be more efficient to query the SQL tables directly
FUNCTION get_taskname ( p_file_or_task VARCHAR2 ) RETURN VARCHAR2;
FUNCTION get_filename ( p_file_or_task VARCHAR2 ) RETURN VARCHAR2;
FUNCTION get_filetype ( p_file_or_task VARCHAR2 ) RETURN VARCHAR2;
FUNCTION get_metadata ( p_file_or_task VARCHAR2, p_parameter VARCHAR2, p_source VARCHAR2 ) RETURN VARCHAR2;
FUNCTION get_metadata_tbl ( p_file_or_task VARCHAR2, p_parameter VARCHAR2, p_source VARCHAR2 ) RETURN results_tbl;
-- For example ... Metadata stores TA12345 REQUIRES TA23456, TA23457, TA23458
--             ... You need to know if any task REQUIRES TA23457, then you use the _by_val function
FUNCTION get_metadata_by_val ( p_file_or_task VARCHAR2, p_parameter VARCHAR2, p_source VARCHAR2 ) RETURN VARCHAR2;
FUNCTION get_metadata_tbl_by_val ( p_file_or_task VARCHAR2, p_parameter VARCHAR2, p_source VARCHAR2 ) RETURN results_tbl;
END PKG_PDX_SCHEMA_UPDATER_META;

/
CREATE OR REPLACE PACKAGE BODY      SBMO.PKG_PDX_SCHEMA_UPDATER_META AS
g_captured BOOLEAN := FALSE;
--  TYPE value_tbl IS TABLE OF VARCHAR2(2000);
TYPE metatag_tbl IS TABLE OF results_tbl INDEX BY VARCHAR2(40);
TYPE source_tbl IS TABLE of metatag_tbl INDEX BY VARCHAR2(1);
TYPE task_tbl IS TABLE of source_tbl INDEX BY VARCHAR2(2000);
TYPE file_to_task_tbl IS TABLE OF VARCHAR2(255) INDEX BY VARCHAR2(255);
g_task_to_value task_tbl;
g_value_to_task task_tbl;
g_file_to_task  file_to_task_tbl;
g_task_to_file  file_to_task_tbl;
g_task_to_type  file_to_task_tbl;
FUNCTION meta_version RETURN VARCHAR2 IS BEGIN RETURN '1.01'; END;
FUNCTION meta_hash (p_sql CLOB) RETURN VARCHAR2 IS
l_chunk NUMBER := 2000;
l_pos NUMBER := 1;
out_raw RAW(16);
l_rtn VARCHAR2(255);
begin
WHILE l_pos <= DBMS_LOB.GETLENGTH(p_sql) LOOP
dbms_obfuscation_toolkit.md5(
input=>utl_raw.cast_to_raw(l_rtn||DBMS_LOB.SUBSTR(p_sql,l_chunk,l_pos)),
checksum=>out_raw);
l_rtn := rawtohex(out_raw);
l_pos := l_pos + l_chunk;
END LOOP;
RETURN l_rtn;
END meta_hash;
FUNCTION task_tbl_exists ( p_parm task_tbl, parm1 varchar2, parm2 varchar2, parm3 varchar2 ) RETURN BOOLEAN IS
BEGIN
IF p_parm(parm1)(parm2)(parm3) IS NULL THEN
NULL;
END IF;
RETURN TRUE;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN FALSE;
END;
PROCEDURE erase_obsolete_metadata IS
BEGIN
DELETE FROM pdx_schema_file_hash
WHERE (file_name, file_source) NOT IN (SELECT file_name, file_source
FROM pdx_schema_file_hash h
JOIN pdx_schema_updater_sql s USING (file_name)
WHERE h.file_source = 'A'
AND file_hash = NVL(pkg_pdx_schema_updater_meta.meta_hash(s.sql),0)
UNION
SELECT file_name, file_source
FROM pdx_schema_file_hash h
JOIN schema_updater_sql s USING (file_name)
WHERE h.file_source = 'B'
AND file_hash = NVL(pkg_pdx_schema_updater_meta.meta_hash(s.sql),0)
);
DELETE FROM pdx_schema_file_hash
WHERE (file_name, file_source) IN (SELECT file_name, file_source
FROM pdx_schema_file_hash
MINUS
SELECT file_name, 'A'
FROM pdx_schema_updater_sql
MINUS
SELECT file_name, 'B'
FROM schema_updater_sql
);
DELETE FROM PDX_SCHEMA_FILE_TASKVER
WHERE file_name IN (SELECT s.file_name
FROM pdx_schema_updater_sql s
LEFT OUTER JOIN pdx_schema_file_hash h ON (h.file_name = s.file_name and h.file_source = 'A')
WHERE h.file_name IS NULL
)
OR file_name IN (SELECT s.file_name
FROM schema_updater_sql s
LEFT OUTER JOIN pdx_schema_file_hash h ON (h.file_name = s.file_name and h.file_source = 'B')
WHERE h.file_name IS NULL
)
OR file_name IN (SELECT file_name
FROM pdx_schema_file_taskver
MINUS
SELECT file_name
FROM pdx_schema_file_hash
);
g_file_to_task.DELETE;
g_task_to_file.DELETE;
g_task_to_type.DELETE;
DELETE FROM PDX_SCHEMA_TASKVER_META
WHERE (task_version, task_source) IN (SELECT task_version, task_source
FROM pdx_schema_taskver_meta
MINUS
SELECT UPPER(REGEXP_SUBSTR(file_name,lower(value)||'_(.*?)_ddl.sql$',1,1,'im',1)), file_source
FROM pdx_schema_file_hash h
JOIN pdx_schema_config ON (key = 'APPLICATIONPREFIX')
);
g_task_to_value.DELETE;
g_value_to_task.DELETE;
g_captured := false;
END erase_obsolete_metadata;
PROCEDURE delete_metadata IS
BEGIN
DELETE FROM pdx_schema_file_hash;
DELETE FROM PDX_SCHEMA_FILE_TASKVER;
g_file_to_task.DELETE;
g_task_to_file.DELETE;
g_task_to_type.DELETE;
DELETE FROM PDX_SCHEMA_TASKVER_META;
g_task_to_value.DELETE;
g_value_to_task.DELETE;
g_captured := false;
END delete_metadata;
PROCEDURE read_metadata_filetask_map IS
BEGIN
INSERT INTO PDX_SCHEMA_FILE_TASKVER ( FILE_NAME, TASK_VERSION, FILE_TYPE)
SELECT *
FROM (SELECT file_name, task_version, MIN(file_type) file_type
FROM (SELECT file_name,
UPPER(REGEXP_SUBSTR(file_name,lower(value)||'_(.*?)_ddl.sql$',1,1,'im',1)) task_version,
NVL(UPPER(SUBSTR(CAST(REGEXP_SUBSTR(sql, '^ *-- *(TASKFILE|RELEASEFILE|TASKREF|RELEASEREF) *:.*',1,1,'im',1) AS VARCHAR2(15)),1,1)),'O') file_type
FROM pdx_schema_updater_sql
LEFT OUTER JOIN pdx_schema_file_taskver USING (file_name)
JOIN pdx_schema_config ON (key = 'APPLICATIONPREFIX')
WHERE file_type IS NULL
UNION
SELECT file_name,
UPPER(REGEXP_SUBSTR(file_name, lower(value) || '_(.*?)_ddl.sql$',1,1,'im',1)),
NVL(UPPER(SUBSTR(CAST(REGEXP_SUBSTR(sql, '^ *-- *(TASKFILE|RELEASEFILE|TASKREF|RELEASEREF) *:.*',1,1,'im',1) AS VARCHAR2(15)),1,1)),'O')
FROM schema_updater_sql
LEFT OUTER JOIN pdx_schema_file_taskver USING (file_name)
JOIN pdx_schema_config ON (key = 'APPLICATIONPREFIX')
WHERE file_type IS NULL
)
GROUP BY file_name, task_version
)
WHERE task_version IS NOT NULL
AND file_type IS NOT NULL;
FOR rec IN (SELECT FILE_NAME, TASK_VERSION, FILE_TYPE FROM PDX_SCHEMA_FILE_TASKVER) LOOP
g_file_to_task(rec.file_name) := rec.task_version;
g_task_to_file(rec.task_version) := rec.file_name;
g_task_to_type(rec.task_version) := rec.file_type;
END LOOP;
END;
PROCEDURE read_metadata_apply_pvt (p_task VARCHAR2 := NULL) IS
CURSOR l_apply_cur IS
SELECT v.file_name, sql ddl, v.task_version, v.file_type
FROM pdx_schema_updater_sql s
JOIN pdx_schema_file_taskver v ON (v.file_name = s.file_name)
LEFT OUTER JOIN pdx_schema_file_hash h ON (h.file_name = s.file_name AND h.file_source = 'A')
WHERE (p_task IS NULL OR p_task = v.task_version)
AND (p_task = v.task_version OR h.file_hash IS NULL);
l_metatags VARCHAR2(1000) := 'HASHKEY|REQUIRES|ROLLBACK|DEPRECATES|TASKTYPE|ATTRIBCHECK|APPLYSPRINT|APPLYIF|EXCLUDEIF';
l_iter NUMBER;
l_meta VARCHAR2(30);
l_data VARCHAR2(255);
l_valcount NUMBER;
l_prefix VARCHAR2(50);
BEGIN
SELECT LOWER(value) INTO l_prefix FROM pdx_schema_config WHERE key = 'APPLICATIONPREFIX';
IF p_task IS NOT NULL THEN
DELETE FROM pdx_schema_file_hash
WHERE file_name = (SELECT file_name FROM pdx_schema_file_taskver WHERE task_version = p_task)
AND file_source = 'A';
DELETE FROM pdx_schema_taskver_meta
WHERE task_version = p_task
AND task_source = 'A';
IF SQL%ROWCOUNT > 0 THEN
-- If there were no rows removed from the meta table above, then there will be no pl/sql table elements to remove
DECLARE
l_meta  VARCHAR2(40);
l_idx1  NUMBER;
l_idx2  NUMBER;
l_value VARCHAR2(2000);
BEGIN
l_meta := g_task_to_value(p_task)('A').FIRST;
FOR ctr IN 1..g_task_to_value(p_task)('A').COUNT LOOP
l_idx1 := g_task_to_value(p_task)('A')(l_meta).FIRST;
FOR ctr1 IN 1..g_task_to_value(p_task)('A')(l_meta).COUNT LOOP
l_value := g_task_to_value(p_task)('A')(l_meta)(l_idx1);
l_idx2 := g_value_to_task(l_value)('A')(l_meta).FIRST;
FOR ctr2 IN 1..g_value_to_task(l_value)('A')(l_meta).COUNT LOOP
IF g_value_to_task(l_value)('A')(l_meta)(l_idx2) = p_task THEN
g_value_to_task(l_value)('A')(l_meta).DELETE(l_idx2);
END IF;
l_idx2 := g_value_to_task(l_value)('A')(l_meta).NEXT(l_idx2);
END LOOP;
g_task_to_value(p_task)('A')(l_meta).DELETE(l_idx1);
l_idx1 := g_task_to_value(p_task)('A')(l_meta).NEXT(l_idx1);
END LOOP;
g_task_to_value(p_task)('A').DELETE(l_meta);
l_meta := g_task_to_value(p_task)('A').NEXT(l_meta);
END LOOP;
END;
END IF;
END IF;
FOR rec IN l_apply_cur LOOP
l_iter := 1;
l_meta := UPPER(SUBSTR(REGEXP_SUBSTR(rec.ddl,'^ *-- *('||l_metatags||') *:.*$',1,l_iter,'im',1),1,30));
WHILE l_meta IS NOT NULL LOOP
l_data := REGEXP_SUBSTR(rec.ddl,'^ *-- *('||l_metatags||') *: *(.*) *$',1,l_iter,'im',2);
l_valcount := REGEXP_COUNT(l_data,',')+1;
IF l_meta = 'ATTRIBCHECK' THEN
IF l_data IS NULL THEN
RAISE_APPLICATION_ERROR(-20011,'ATTRIBCHECK for '||rec.task_version||' in pdx_schema_updater_sql does not have a value');
ELSE
INSERT INTO PDX_SCHEMA_TASKVER_META ( TASK_VERSION, META_TAG, TASK_VERSION_VALUE, TASK_SOURCE )
VALUES ( rec.task_version, l_meta, l_data, 'A' );
END IF;
ELSE
FOR valrec IN (SELECT REGEXP_SUBSTR(l_data,'(^|,) *([^ ,]*) *',1,level,'im',2) val from dual connect by level <= l_valcount) LOOP
IF valrec.val IS NULL THEN
RAISE_APPLICATION_ERROR(-20011,l_meta||' for '||rec.task_version||' in pdx_schema_updater_sql is empty or invalid');
ELSE
INSERT INTO PDX_SCHEMA_TASKVER_META ( TASK_VERSION, META_TAG, TASK_VERSION_VALUE, TASK_SOURCE )
VALUES ( rec.task_version, l_meta, valrec.val, 'A' );
END IF;
END LOOP;
END IF;
l_iter := l_iter + 1;
l_meta := SUBSTR(REGEXP_SUBSTR(rec.ddl,'^ *-- *('||l_metatags||') *:.*$',1,l_iter,'im',1),1,30);
END LOOP;
IF rec.file_type = 'R' THEN
l_iter := 1;
l_data := REGEXP_SUBSTR(rec.ddl,'^ *--\@('||l_prefix||'_)?(.*?)(_ddl|_ddl\.sql)? *$',1,l_iter,'im',2);
WHILE l_data IS NOT NULL LOOP
IF get_taskname(l_data) IS NULL THEN
RAISE_APPLICATION_ERROR(-20011,'Unable to find taskname for '||l_data||' - is taskfile applied?');
ELSE
INSERT INTO PDX_SCHEMA_TASKVER_META ( TASK_VERSION, META_TAG, TASK_VERSION_VALUE, TASK_SOURCE )
VALUES ( rec.task_version, 'RELEASETASK', get_taskname(l_data), 'A' );
END IF;
l_iter := l_iter + 1;
l_data := REGEXP_SUBSTR(rec.ddl,'^ *--\@('||l_prefix||'_)?(.*?)(_ddl|_ddl\.sql)? *$',1,l_iter,'im',2);
END LOOP;
END IF;
INSERT INTO pdx_schema_file_hash ( FILE_NAME, FILE_SOURCE, FILE_HASH ) VALUES ( rec.file_name, 'A', pkg_pdx_schema_updater_meta.meta_hash(rec.ddl) );
END LOOP;
FOR rec IN (SELECT TASK_VERSION, META_TAG, TASK_VERSION_VALUE FROM PDX_SCHEMA_TASKVER_META WHERE TASK_SOURCE = 'A' AND (p_task IS NULL OR p_task = task_version)) LOOP
IF NOT task_tbl_exists(g_task_to_value,rec.TASK_VERSION,'A',rec.META_TAG) THEN
g_task_to_value(rec.TASK_VERSION)('A')(rec.META_TAG) := pkg_pdx_schema_updater_meta.results_tbl();
END IF;
IF NOT task_tbl_exists(g_value_to_task,rec.TASK_VERSION_VALUE,'A',rec.META_TAG) THEN
g_value_to_task(rec.TASK_VERSION_VALUE)('A')(rec.META_TAG) := pkg_pdx_schema_updater_meta.results_tbl();
END IF;
g_task_to_value(rec.TASK_VERSION)('A')(rec.META_TAG).EXTEND;
g_task_to_value(rec.TASK_VERSION)('A')(rec.META_TAG)(g_task_to_value(rec.TASK_VERSION)('A')(rec.META_TAG).LAST):=rec.TASK_VERSION_VALUE;
g_value_to_task(rec.TASK_VERSION_VALUE)('A')(rec.META_TAG).EXTEND;
g_value_to_task(rec.TASK_VERSION_VALUE)('A')(rec.META_TAG)(g_value_to_task(rec.TASK_VERSION_VALUE)('A')(rec.META_TAG).LAST):=rec.TASK_VERSION;
END LOOP;
END;
PROCEDURE refresh_metadata_apply (p_file_or_task VARCHAR2) IS
BEGIN
IF NOT g_captured THEN
RAISE_APPLICATION_ERROR(-20010,'Read_Metadata must be executed prior to updating Apply metadata');
END IF;
read_metadata_apply_pvt(get_taskname(p_file_or_task));
END;
PROCEDURE read_metadata_build IS
CURSOR l_build_cur IS
SELECT v.file_name, sql ddl, v.task_version, v.file_type
FROM schema_updater_sql s
JOIN pdx_schema_file_taskver v ON (v.file_name = s.file_name)
LEFT OUTER JOIN pdx_schema_file_hash h ON (h.file_name = s.file_name AND h.file_source = 'B')
WHERE h.file_hash IS NULL;
l_metatags VARCHAR2(1000) := 'HASHKEY|REQUIRES|ROLLBACK|DEPRECATES|TASKTYPE|ATTRIBCHECK|APPLYSPRINT|APPLYIF|EXCLUDEIF';
l_iter NUMBER;
l_meta VARCHAR2(30);
l_data VARCHAR2(255);
l_valcount NUMBER;
l_prefix VARCHAR2(50);
BEGIN
SELECT LOWER(value) INTO l_prefix FROM pdx_schema_config WHERE key = 'APPLICATIONPREFIX';
FOR rec IN l_build_cur LOOP
l_iter := 1;
l_meta := UPPER(SUBSTR(REGEXP_SUBSTR(rec.ddl,'^ *-- *('||l_metatags||') *:.*$',1,l_iter,'im',1),1,30));
WHILE l_meta IS NOT NULL LOOP
l_data := REGEXP_SUBSTR(rec.ddl,'^ *-- *('||l_metatags||') *: *(.*) *$',1,l_iter,'im',2);
l_valcount := REGEXP_COUNT(l_data,',')+1;
IF l_meta = 'ATTRIBCHECK' THEN
IF l_data IS NULL THEN
RAISE_APPLICATION_ERROR(-20011,'ATTRIBCHECK for '||rec.task_version||' in schema_updater_sql does not have a value');
ELSE
INSERT INTO PDX_SCHEMA_TASKVER_META ( TASK_VERSION, META_TAG, TASK_VERSION_VALUE, TASK_SOURCE )
VALUES ( rec.task_version, l_meta, l_data, 'B' );
END IF;
ELSE
FOR valrec IN (SELECT REGEXP_SUBSTR(l_data,'(^|,) *([^ ,]*) *',1,level,'im',2) val from dual connect by level <= l_valcount) LOOP
IF valrec.val IS NULL THEN
RAISE_APPLICATION_ERROR(-20011,l_meta||' for '||rec.task_version||' in schema_updater_sql is empty or invalid');
ELSE
INSERT INTO PDX_SCHEMA_TASKVER_META ( TASK_VERSION, META_TAG, TASK_VERSION_VALUE, TASK_SOURCE )
VALUES ( rec.task_version, l_meta, valrec.val, 'B' );
END IF;
END LOOP;
END IF;
l_iter := l_iter + 1;
l_meta := UPPER(SUBSTR(REGEXP_SUBSTR(rec.ddl,'^ *-- *('||l_metatags||') *:.*$',1,l_iter,'im',1),1,30));
END LOOP;
IF rec.file_type = 'R' THEN
l_iter := 1;
l_data := REGEXP_SUBSTR(rec.ddl,'^ *--\@('||l_prefix||'_)?(.*?)(_ddl|_ddl\.sql)? *$',1,l_iter,'im',2);
WHILE l_data IS NOT NULL LOOP
IF get_taskname(l_data) IS NULL THEN
RAISE_APPLICATION_ERROR(-20011,'Unable to find taskname for '||l_data||' - is taskfile loaded?');
ELSE
INSERT INTO PDX_SCHEMA_TASKVER_META ( TASK_VERSION, META_TAG, TASK_VERSION_VALUE, TASK_SOURCE )
VALUES ( rec.task_version, 'RELEASETASK', get_taskname(l_data), 'B' );
END IF;
l_iter := l_iter + 1;
l_data := REGEXP_SUBSTR(rec.ddl,'^ *--\@(''||l_prefix||''_)?(.*?)(_ddl|_ddl\.sql)? *$',1,l_iter,'im',2);
END LOOP;
END IF;
INSERT INTO pdx_schema_file_hash ( FILE_NAME, FILE_SOURCE, FILE_HASH ) VALUES ( rec.file_name, 'B', pkg_pdx_schema_updater_meta.meta_hash(rec.ddl) );
END LOOP;
FOR rec IN (SELECT TASK_VERSION, META_TAG, TASK_VERSION_VALUE FROM PDX_SCHEMA_TASKVER_META WHERE TASK_SOURCE = 'B') LOOP
IF NOT task_tbl_exists(g_task_to_value,rec.TASK_VERSION,'B',rec.META_TAG) THEN
g_task_to_value(rec.TASK_VERSION)('B')(rec.META_TAG) := pkg_pdx_schema_updater_meta.results_tbl();
END IF;
IF NOT task_tbl_exists(g_value_to_task,rec.TASK_VERSION_VALUE,'B',rec.META_TAG) THEN
g_value_to_task(rec.TASK_VERSION_VALUE)('B')(rec.META_TAG) := pkg_pdx_schema_updater_meta.results_tbl();
END IF;
g_task_to_value(rec.TASK_VERSION)('B')(rec.META_TAG).EXTEND;
g_task_to_value(rec.TASK_VERSION)('B')(rec.META_TAG)(g_task_to_value(rec.TASK_VERSION)('B')(rec.META_TAG).LAST):=rec.TASK_VERSION_VALUE;
g_value_to_task(rec.TASK_VERSION_VALUE)('B')(rec.META_TAG).EXTEND;
g_value_to_task(rec.TASK_VERSION_VALUE)('B')(rec.META_TAG)(g_value_to_task(rec.TASK_VERSION_VALUE)('B')(rec.META_TAG).LAST):=rec.TASK_VERSION;
END LOOP;
END;
FUNCTION validate_metadata RETURN BOOLEAN IS
l_rtn BOOLEAN;
l_cnt NUMBER;
BEGIN
SELECT COUNT(*) INTO l_cnt
FROM pdx_schema_file_hash h
FULL OUTER JOIN pdx_schema_updater_sql s ON (s.file_name = h.file_name)
WHERE h.file_source = 'A'
AND NVL(h.file_hash,0) != NVL(pkg_pdx_schema_updater_meta.meta_hash(s.sql),0);
l_rtn := l_cnt = 0;
IF l_rtn THEN
SELECT COUNT(*) INTO l_cnt
FROM pdx_schema_file_hash h
FULL OUTER JOIN schema_updater_sql s ON (s.file_name = h.file_name)
WHERE h.file_source = 'B'
AND NVL(h.file_hash,0) != NVL(pkg_pdx_schema_updater_meta.meta_hash(s.sql),0);
l_rtn := l_cnt = 0;
END IF;
RETURN l_rtn;
END;
PROCEDURE read_metadata IS
BEGIN
erase_obsolete_metadata;
read_metadata_filetask_map;
read_metadata_apply_pvt;
read_metadata_build;
g_captured := TRUE;
IF NOT validate_metadata THEN
RAISE_APPLICATION_ERROR(-20010,'Metadata is out of synch.  Please execute pkg_pdx_schema_updater_meta.delete_metadata');
END IF;
END read_metadata;
FUNCTION get_taskname ( p_file_or_task VARCHAR2 ) RETURN VARCHAR2 IS
l_rtn    VARCHAR2(255);
BEGIN
BEGIN
l_rtn := g_file_to_task(p_file_or_task);
EXCEPTION
WHEN NO_DATA_FOUND THEN
BEGIN
IF g_task_to_file(UPPER(p_file_or_task)) IS NOT NULL THEN
l_rtn := UPPER(p_file_or_task);
END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
l_rtn := NULL;
END;
END;
RETURN l_rtn;
END;
FUNCTION get_filename ( p_file_or_task VARCHAR2 ) RETURN VARCHAR2 IS
l_rtn    VARCHAR2(255);
BEGIN
BEGIN
l_rtn := g_task_to_file(UPPER(p_file_or_task));
EXCEPTION
WHEN NO_DATA_FOUND THEN
BEGIN
IF g_file_to_task(p_file_or_task) IS NOT NULL THEN
l_rtn := p_file_or_task;
END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
l_rtn := NULL;
END;
END;
RETURN l_rtn;
END;
FUNCTION get_filetype ( p_file_or_task VARCHAR2 ) RETURN VARCHAR2 IS
BEGIN
RETURN g_task_to_type(get_taskname(p_file_or_task));
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END;
FUNCTION get_metadata ( p_file_or_task VARCHAR2, p_parameter VARCHAR2, p_source VARCHAR2 ) RETURN VARCHAR2 IS
l_task VARCHAR2(255);
l_cnt  NUMBER;
BEGIN
l_task := get_taskname(p_file_or_task);
IF task_tbl_exists ( g_task_to_value, l_task, p_source, p_parameter ) THEN
l_cnt := g_task_to_value(l_task)(p_source)(p_parameter).COUNT;
IF l_cnt > 1 THEN
RAISE TOO_MANY_ROWS;
END IF;
RETURN g_task_to_value(l_task)(p_source)(p_parameter)(g_task_to_value(l_task)(p_source)(p_parameter).FIRST);
ELSE
RETURN NULL;
END IF;
END get_metadata;
FUNCTION get_metadata_tbl ( p_file_or_task VARCHAR2, p_parameter VARCHAR2, p_source VARCHAR2 ) RETURN results_tbl IS
l_task VARCHAR2(255);
BEGIN
l_task := get_taskname(p_file_or_task);
IF task_tbl_exists ( g_task_to_value, l_task, p_source, p_parameter ) THEN
RETURN g_task_to_value(l_task)(p_source)(p_parameter);
ELSE
RETURN results_tbl();
END IF;
END get_metadata_tbl;
FUNCTION get_metadata_by_val ( p_file_or_task VARCHAR2, p_parameter VARCHAR2, p_source VARCHAR2 ) RETURN VARCHAR2 IS
l_task VARCHAR2(255);
l_cnt  NUMBER;
BEGIN
l_task := get_taskname(p_file_or_task);
IF task_tbl_exists ( g_value_to_task, l_task, p_source, p_parameter ) THEN
l_cnt := g_value_to_task(l_task)(p_source)(p_parameter).COUNT;
IF l_cnt > 1 THEN
RAISE TOO_MANY_ROWS;
END IF;
RETURN g_value_to_task(l_task)(p_source)(p_parameter)(g_value_to_task(l_task)(p_source)(p_parameter).FIRST);
ELSE
RETURN NULL;
END IF;
END get_metadata_by_val;
FUNCTION get_metadata_tbl_by_val ( p_file_or_task VARCHAR2, p_parameter VARCHAR2, p_source VARCHAR2 ) RETURN results_tbl IS
l_task VARCHAR2(255);
BEGIN
l_task := get_taskname(p_file_or_task);
IF task_tbl_exists ( g_value_to_task, l_task, p_source, p_parameter ) THEN
RETURN g_value_to_task(l_task)(p_source)(p_parameter);
ELSE
RETURN results_tbl();
END IF;
END get_metadata_tbl_by_val;
END PKG_PDX_SCHEMA_UPDATER_META;

/
CREATE OR REPLACE PACKAGE      SBMO.PKG_PDX_SCHEMA_UPDATER_RPT AS
TYPE results_tbl IS TABLE OF VARCHAR2(4000);
FUNCTION report(p_pdx_schema_upd_pgkcall_id NUMBER := NULL, p_include_processes VARCHAR2 := 'N') RETURN results_tbl PIPELINED;
FUNCTION schema_version RETURN VARCHAR2;
FUNCTION updater_version RETURN VARCHAR2;
FUNCTION report_version RETURN VARCHAR2;
END PKG_PDX_SCHEMA_UPDATER_RPT;

/
CREATE OR REPLACE PACKAGE BODY      SBMO.PKG_PDX_SCHEMA_UPDATER_RPT AS
FUNCTION schema_version RETURN VARCHAR2 IS BEGIN RETURN PKG_PDX_SCHEMA_UPDATER.schema_version; END;
FUNCTION updater_version RETURN VARCHAR2 IS BEGIN RETURN PKG_PDX_SCHEMA_UPDATER.updater_version; END;
FUNCTION report_version RETURN VARCHAR2 IS BEGIN RETURN '1.00'; END;
FUNCTION report(p_pdx_schema_upd_pgkcall_id NUMBER := NULL, p_include_processes VARCHAR2 := 'N') RETURN results_tbl PIPELINED IS
CURSOR call_cur IS
SELECT id, target_version, status_code, start_date, end_date-start_date duration, return_code, error_message, sql_error_code, sql_error_message
FROM pdx_schema_upd_pkgcall_hist h
LEFT OUTER JOIN pdx_schema_upd_pkgcall_err_log l USING (id)
WHERE (p_pdx_schema_upd_pgkcall_id IS NULL AND id = (SELECT MAX(hi.id) FROM pdx_schema_upd_pkgcall_hist hi))
OR id = p_pdx_schema_upd_pgkcall_id;
CURSOR vers_cur (p_call_id NUMBER) IS
SELECT id, current_version, target_version, status_code, start_date, end_date-start_date duration, error_message, sql_error_code, sql_error_message
FROM pdx_schema_version_history h
LEFT OUTER JOIN pdx_schema_version_error_log l USING (ID)
WHERE pdx_schema_upd_pkgcall_hist_id = p_call_id
ORDER BY id;
CURSOR task_cur (p_call_id NUMBER, p_vers_id NUMBER) IS
SELECT id, file_name, task_type, action_code, status_code, start_date, end_date-start_date duration, error_message, sql_error_code, sql_error_message
FROM pdx_schema_task_history
LEFT OUTER JOIN pdx_schema_task_error_log l USING (id)
WHERE pdx_schema_upd_pkgcall_hist_id = p_call_id
AND pdx_schema_version_history_id = p_vers_id
ORDER BY id;
CURSOR process_cur (p_call_id NUMBER) IS
SELECT id, process, start_date, end_date-start_date duration
FROM pdx_schema_process_history
WHERE pdx_schema_upd_pkgcall_hist_id = p_call_id
ORDER BY id;
call_rec          call_cur%ROWTYPE;
results           results_tbl := results_tbl();
result_msg        varchar2(20);
idx               number;
PROCEDURE add (p_txt VARCHAR2) IS
BEGIN
results.EXTEND;
results(results.LAST) := p_txt;
END;
PROCEDURE print_call ( p_rec call_cur%ROWTYPE ) IS
BEGIN
IF p_rec.return_code = 0 THEN
result_msg := ' (SUCCESS)';
ELSE
result_msg := ' (FAIL)';
END IF;
add('PkgCall:  '||p_rec.target_version||' '||p_rec.status_code||' '||p_rec.start_date||' , Duration ['||(p_rec.duration)||']');
add('          RtnCode:  '||p_rec.return_code||result_msg);
IF p_rec.error_message IS NOT NULL THEN
add('          Message:  '||SUBSTR(REGEXP_REPLACE(p_rec.error_message,'^','                    ',1,0,'m'),21));
END IF;
IF p_rec.sql_error_message IS NOT NULL THEN
add('          SqlError: '||SUBSTR(REGEXP_REPLACE(p_rec.sql_error_message,'^','                    ',1,0,'m'),21));
END IF;
END;
PROCEDURE print_vers ( p_rec vers_cur%ROWTYPE ) IS
BEGIN
add('Version:  '||p_rec.current_version||' - '||p_rec.target_version||' '||p_rec.status_code||' '||p_rec.start_date||' , Duration ['||(p_rec.duration)||']');
IF p_rec.error_message IS NOT NULL THEN
add('          Message:  '||SUBSTR(REGEXP_REPLACE(p_rec.error_message,'^','                    ',1,0,'m'),21));
END IF;
IF p_rec.sql_error_message IS NOT NULL THEN
add('          SqlError: '||SUBSTR(REGEXP_REPLACE(p_rec.sql_error_message,'^','                    ',1,0,'m'),21));
END IF;
END;
PROCEDURE print_task ( p_rec task_cur%ROWTYPE ) IS
BEGIN
add('Task:     '||RPAD(p_rec.file_name,30)||' '||p_rec.action_code||' '||p_rec.status_code||' '||p_rec.start_date||' TaskType ['||p_rec.task_type||'], Duration ['||(p_rec.duration)||']');
IF p_rec.error_message IS NOT NULL THEN
add('          Message:  '||SUBSTR(REGEXP_REPLACE(p_rec.error_message,'^','                    ',1,0,'m'),21));
END IF;
IF p_rec.sql_error_message IS NOT NULL THEN
add('          SqlError: '||SUBSTR(REGEXP_REPLACE(p_rec.sql_error_message,'^','                    ',1,0,'m'),21));
END IF;
END;
PROCEDURE print_process ( p_rec process_cur%ROWTYPE ) IS
BEGIN
add('Process:  '||p_rec.process||' Started ['||p_rec.start_date||'], Duration ['||(p_rec.duration)||']');
END;
BEGIN
OPEN call_cur;
FETCH call_cur INTO call_rec;
IF call_cur%FOUND THEN
print_call(call_rec);
FOR vers_rec IN vers_cur(call_rec.id) LOOP
print_vers(vers_rec);
FOR task_rec IN task_cur(call_rec.id, vers_rec.id) LOOP
print_task(task_rec);
END LOOP;
END LOOP;
IF regexp_count(p_include_processes,'^\s*(y|yes|t|true)\s*$',1,'i') = 1 THEN
FOR process_rec IN process_cur(call_rec.id) LOOP
print_process(process_rec);
END LOOP;
END IF;
ELSE
add('Unable to find results for pdx_schema_upd_pkgcall_hist_id '||p_pdx_schema_upd_pgkcall_id);
END IF;
CLOSE call_cur;
idx := results.FIRST;
FOR ctr IN 1..results.COUNT LOOP
PIPE ROW(results(idx));
idx := results.NEXT(idx);
END LOOP;
RETURN;
END;
END PKG_PDX_SCHEMA_UPDATER_RPT;

/
CREATE OR REPLACE PACKAGE SBMO.PKG_SBMO_PURGE
AS
/*******************************************************************************
/*
/* NAME:		PKG_SBMO_PURGE
/*
/* DESCRIPTION:	This package purges data from identified tables for an
/*				identified period based on configuration settings
/*
/* NOTES:		This code was originally written assuming all tables are partitioned with the
/*				exception of the purge_history tables which are handled
/*				separately. The latest change handles non partitioned tables as well .
/*
/*******************************************************************************
/*
/*	Name				Date		Modification
/* 	-------------------	----------	-------------------------------------------
/*	Edward Stephenson	01/10/2019	Created package
/*  Medha Prasad        16/01/2025  Modified package to handle non partitioned tables.
/*  Medha Prasad        03/03/2025  Handle ORA-01847 exclude partition with high_value 1900-02-01
/*
/******************************************************************************/
	-----------------------------------------------------------------------------
	-- Define global processing variables
	-----------------------------------------------------------------------------
	
	c_Yes				CONSTANT	CHAR(1)			:= 'Y';
	c_No				CONSTANT	CHAR(1)			:= 'N';
	c_MonitorStop		CONSTANT	CHAR(1)			:= 'S';
	c_MonitorWindow		CONSTANT	CHAR(1)			:= 'W';
	c_StopJob			CONSTANT	CHAR(1)			:= 'X';
	
	-- Processing statuses
	c_Stopped			CONSTANT	VARCHAR2(10)	:= 'STOPPED';
	c_Begin				CONSTANT	VARCHAR2(10)	:= 'BEGIN';
	c_Failed			CONSTANT	VARCHAR2(10)	:= 'FAILED';
	c_FkDelete			CONSTANT	VARCHAR2(10)	:= 'FK_DELETE';
	c_SubPartDrop		CONSTANT	VARCHAR2(10)	:= 'SUBPARTS';
	c_NoTable			CONSTANT	VARCHAR2(10)	:= 'NO_TABLE';
	-- Job/task name prefixes
	c_TaskNamePrefix	CONSTANT	VARCHAR2(10)	:= 'SBMOPRG';
	c_MonJobNamePrefix	CONSTANT	VARCHAR2(10)	:= 'SBMOMON';
	c_IndJobNamePrefix	CONSTANT	VARCHAR2(10)	:= 'SBMOIND';
	-- Values for scheduler job type
	c_Monitor			CONSTANT	VARCHAR2(10)	:= 'MONITOR';
	c_Index				CONSTANT	VARCHAR2(10)	:= 'INDEX';
	
	-- Values for names in the purge_config_settings table
	c_WindowTimes		CONSTANT	VARCHAR2(30)	:= 'Window Times';
	c_DefPartMins		CONSTANT	VARCHAR2(30)	:= 'Default Partition Minutes';
	c_ChunkSize			CONSTANT	VARCHAR2(30)	:= 'Chunk Size';
	c_ParallelChunkCount		CONSTANT	VARCHAR2(30)	:= 'Parallel Chunk Count';
	c_ParallelQueryCount	CONSTANT	VARCHAR2(30)	:= 'Parallel Query Count';
	c_RetryCount		CONSTANT	VARCHAR2(30)	:= 'Retry Count';
	c_SleepTime			CONSTANT	VARCHAR2(30)	:= 'Sleep Time';
	c_MultiBlock		CONSTANT	VARCHAR2(30)	:= 'Multiblock Read Count';
	c_BlackoutDay		CONSTANT	VARCHAR2(30)	:= 'Blackout Day';
	c_JobClass			CONSTANT	VARCHAR2(30)	:= 'Job Class';
	c_MailHost			CONSTANT	VARCHAR2(30)	:=  'Mail Host';
	c_MailPort			CONSTANT	VARCHAR2(30)	:=  'Mail Port';
	c_MailFrom			CONSTANT	VARCHAR2(30)	:=  'Mail From';
	c_MailTo			CONSTANT	VARCHAR2(30)	:=  'Mail To';
	c_PageTo			CONSTANT	VARCHAR2(30)	:=  'Page To';
	c_ForceRestart		CONSTANT	VARCHAR2(30)	:= 'Force Restart';
	c_AppMonthsToKeep	CONSTANT	VARCHAR2(30)	:= 'App Months to Keep';
	c_PurgeMonthsToKeep	CONSTANT	VARCHAR2(30)	:= 'Purge Months to Keep';
	c_SubpartOptMode	CONSTANT	VARCHAR2(30)	:= 'Subpart Optimizer Mode';
	
	c_MaxDaysToPurge	CONSTANT	VARCHAR2(30)	:= 'Max Days To Purge';
	
	-- Task status values
	c_Created 			CONSTANT	VARCHAR2(20)	:= 'CREATED';
	c_Chunking 			CONSTANT	VARCHAR2(20)	:= 'CHUNKING';
	c_ChunkingFailed	CONSTANT	VARCHAR2(20)	:= 'CHUNKING_FAILED';
	c_NoChunks			CONSTANT	VARCHAR2(30)	:= 'NO_CHUNKS';
	c_Chunked 			CONSTANT	VARCHAR2(20)	:= 'CHUNKED';
	c_Processed			CONSTANT	VARCHAR2(20)	:= 'PROCESSED';
	c_Processing 		CONSTANT	VARCHAR2(20)	:= 'PROCESSING';
	c_Finished 			CONSTANT	VARCHAR2(20)	:= 'FINISHED';
	c_FinishedErrors	CONSTANT	VARCHAR2(20)	:= 'FINISHED_WITH_ERROR';
	c_Crashed 			CONSTANT	VARCHAR2(20)	:= 'CRASHED';
	-----------------------------------------------------------------------------
	-- Define global exception variables
	-----------------------------------------------------------------------------
	e_AlreadyRunning		EXCEPTION;
	e_NotInWindow			EXCEPTION;
	e_EndWindow				EXCEPTION;
	e_StopRunning			EXCEPTION;
	e_FailedTask			EXCEPTION;
	e_FkDelete				EXCEPTION;
	e_FinishedErrors		EXCEPTION;
	e_NoPartitionToRestart	EXCEPTION;
	e_BadJobType			EXCEPTION;
	e_InvalidJobClass		EXCEPTION;
	e_BlackoutDay			EXCEPTION;
	pragma exception_init( e_BlackoutDay, -20012 );
	e_SubpartDrop			EXCEPTION;
	e_DataFound				EXCEPTION;
	e_PartitionIsNewer		EXCEPTION;
	e_InvalidRestartStatus  EXCEPTION;
	pragma exception_init( e_InvalidRestartStatus, -29495 );
	e_DupTask				EXCEPTION;
	pragma exception_init( e_DupTask, -29497 );
	e_NoTask				EXCEPTION;
	pragma exception_init( e_NoTask, -29498 );
	e_ChildRecFound			EXCEPTION;
	pragma exception_init( e_ChildRecFound, -2292 );
	e_InvalidNumber			EXCEPTION;
	pragma exception_init( e_InvalidNumber, -6502 );
	e_JobExists				EXCEPTION;
	pragma exception_init( e_JobExists, -27477 );
	-----------------------------------------------------------------------------
	-- Define global constant variables
	-----------------------------------------------------------------------------
	-----------------------------------------------------------------------------
	-- Define reporting objects for use with pipeline functions
	-----------------------------------------------------------------------------
	TYPE r_DailyRec is RECORD
	(
		table_name		varchar2(30),
		tot_secs		number,
		tot_purged		number,
		tot_fk_del		number,
		tot_fk_secs		number,
		tot_subparts	number,
		purged_per_sec	number,
		fk_per_sec		number
	);
	TYPE tbl_DailyRec is TABLE of r_DailyRec;
	TYPE tbl_Strings is TABLE of varchar2(4000);
	-----------------------------------------------------------------------------
	-- Prototype public functions
	-----------------------------------------------------------------------------
	FUNCTION Fn_SplitString
	(
	p_String	IN		VARCHAR2,
	p_Delimiter	IN		CHAR			DEFAULT ','
	)
	RETURN tbl_Strings
	PIPELINED;
	FUNCTION Fn_GetElapsedSecs
	(
	p_Start		IN		DATE,
	p_End		IN		DATE
	)
	RETURN NUMBER;
	
	FUNCTION Fn_ShowErrors
	(
	p_FromDate		DATE,
	p_TaskName	IN		VARCHAR2		DEFAULT NULL
	)
	RETURN tbl_Strings
	PIPELINED;
	FUNCTION Fn_DailyRpt
	(
	p_FromDate		DATE
	)
	RETURN tbl_DailyRec
	PIPELINED;
	FUNCTION Fn_StatusNbrToChar
	(
	p_Status	IN		NUMBER
	)
	RETURN VARCHAR2;
	
	-----------------------------------------------------------------------------
	-- Prototype public procedures
	-----------------------------------------------------------------------------
	PROCEDURE Sp_PurgeSBMO;
	
	PROCEDURE Sp_MonitorTask
	(
	p_TaskName		IN		VARCHAR2,
	p_TableName		IN 		VARCHAR2,
	p_PartName		IN 		VARCHAR2
	);
	
	PROCEDURE Sp_StopRunningPurge;
	PROCEDURE Sp_CreatePurgeSchedulerJob;
END Pkg_Sbmo_Purge;			-- End Package Specification

/
CREATE OR REPLACE PACKAGE BODY SBMO.PKG_SBMO_PURGE
AS
/*******************************************************************************
/*
/* NAME:	Pkg_Sbmo_Purge
/*
/* NOTES:	None
/*
/*******************************************************************************
/*
/*	Name				Date		Modification
/* 	-------------------	----------	-------------------------------------------
/*	Edward Stephenson	01/10/2019	Created package
/*
/******************************************************************************/
	-----------------------------------------------------------------------------
	-- Declare Package Processing Variables
	-----------------------------------------------------------------------------
	b_SqlCode			NUMBER							:= NULL;
	b_SqlErrm			PURGE_ERROR_LOG.SQL_ERRM%TYPE	:= NULL;
	b_ErrDate			VARCHAR2(55)						:= 'to_date('''||to_char(sysdate, 'mm/dd/yyyy hh24:mi:ss')||''',''mm/dd/yyyy hh24:mi:ss'')';
	b_WindowEnd			DATE							:= NULL;
	b_NbrHoursInWindow	NUMBER							:= NULL;
	b_DefPartMins		NUMBER							:= NULL;
	b_ChunkSize			NUMBER							:= NULL;
	b_ParallelChunkCount		NUMBER							:= NULL;
	b_ParallelQueryCount	NUMBER							:= NULL;
	
	b_RetryCount		NUMBER							:= NULL;
	b_SleepTime			NUMBER							:= NULL;
	b_MultiBlock		NUMBER							:= NULL;
	b_OrigMultiBlock	NUMBER							:= NULL;
	b_OrigOptimizerMode	VARCHAR2(50)					:= NULL;
	b_JobClass			VARCHAR2(30)					:= NULL;
	b_AppMonthsToKeep	NUMBER							:= NULL;
	b_PurgeMonthsToKeep	NUMBER							:= NULL;
	b_MailHost			VARCHAR2(255)					:= NULL;
	b_MailPort			VARCHAR2(255)					:= NULL;
	b_MailFrom			VARCHAR2(255)					:= NULL;
	b_MailTo			VARCHAR2(255)					:= NULL;
	b_PageTo			VARCHAR2(255)					:= NULL;
	b_ForceRestart		CHAR(1)							:= NULL;
	b_SubpartOptMode	VARCHAR2(255)					:= NULL;
	b_MaxDaysToPurge	NUMBER							:= NULL;
	-----------------------------------------------------------------------------
	-- Declare Private Functions
	-----------------------------------------------------------------------------
	/***************************************************************************/
	/*
	/* Function:	Fn_Test
	/*
	/* Parameters:	p_Test1           IN    VARCHAR2
	/*				++ Description of parameter
	/*
	/* Description:	YY
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Description of return
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/10/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_Test
	(
	p_Test1		IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		v_Return			VARCHAR2(30)		:= NULL;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Comment of what you are doing
		/********************************************************************/
		NULL;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN v_Return;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_Test' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_Test', b_SqlCode, b_SqlErrm,
				'Other error',
				'P_Test1: ' || p_Test1 );
			commit;
			RAISE;
	END Fn_Test;
	
	/***************************************************************************/
	/*
	/* Function:	Fn_SplitString
	/*
	/* Parameters:	p_String       	IN  	VARCHAR2
	/*				++ String to split
	/*				p_Delimiter		IN		CHAR
	/*				++ Delimiter to split the string on
	/*
	/* Description:	This function will split the string and return the values
	/*				as a row of data
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Pipelined string values
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	02/05/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_SplitString
	(
	p_String	IN		VARCHAR2,
	p_Delimiter	IN		CHAR			DEFAULT ','
	)
	RETURN tbl_Strings
	PIPELINED
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_Strings
				(
				p_String		varchar2,
				p_Delim			varchar2
				)
		is
				select 	regexp_substr( p_String,'[^' || p_Delim || ']+', 1, level) as string_val
				from 	dual
				connect by regexp_substr( p_String, '[^' || p_Delim || ']+', 1, level) is not null;
				-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Display the strings
		/********************************************************************/
		for lr in c_Strings( p_String, p_Delimiter ) loop
			PIPE ROW( lr.string_val );
		end loop;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN;
	
	EXCEPTION
		WHEN NO_DATA_NEEDED THEN
			NULL; -- this means the function returned x nbr of rows but the query only requested first y rows
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_SplitString for P_String: ' || p_String || ' and p_Delimiter: ' || p_Delimiter );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_SplitString', b_SqlCode, b_SqlErrm,
				'Other error',
				'P_String: ' || p_String || ' | p_Delimiter: ' || p_Delimiter );
			commit;
			RAISE;
	END Fn_SplitString;
	/***************************************************************************/
	/*
	/* Function:	Fn_KeepRunning
	/*
	/* Parameters:	None
	/*
	/* Description:	This function determines if we should keep running
	/*
	/* Notes:		None
	/*
	/* Return:		BOOLEAN
	/*				++ Yes or No to keep running
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	02/03/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_KeepRunning
	RETURN BOOLEAN
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Running			purge_run_check.purge_running%TYPE	:= null;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Determine if we should continue running
		/********************************************************************/
		select	purge_running
		into	f_Running
		from	purge_run_check;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		if( f_Running = c_Yes ) then
			RETURN TRUE;
		else
			RETURN FALSE;
		end if;
		
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			insert into purge_run_check ( activity_date, purge_running ) values ( systimestamp, c_Yes );
			RETURN FALSE;
			commit;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_KeepRunning' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_KeepRunning', b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Fn_KeepRunning;
	
	/***************************************************************************/
	/*
	/* Function:	Fn_GetMonthsToKeep
	/*
	/* Parameters:	p_TableName      IN    VARCHAR2
	/*				++ Table to get months to keep for
	/*
	/* Description:	This function will get number of months of data to keep
	/*				for the table name passed in
	/*
	/* Notes:		Months will depend on if the table is an application table
	/*				or one associated just with the purge process
	/*
	/* Return:		NUMBER
	/*				++ Months of data to keep associated with the table passed
	/*					in
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetMonthsToKeep
	(
	p_TableName	IN		VARCHAR2
	)
	RETURN NUMBER
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Months			NUMBER							:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Determine the months to keep based upon purge tables or app
		/********************************************************************/
		if( p_TableName = 'PURGE_HISTORY' ) then
			f_Months := b_PurgeMonthsToKeep;
		else
			f_Months := b_AppMonthsToKeep;
		end if;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Months;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetMonthsToKeep for ' || p_TableName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetMonthsToKeep', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName );
			commit;
			RAISE;
	END Fn_GetMonthsToKeep;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetPurgeDate
	/*
	/* Parameters:	p_TableName		IN		VARCHAR2
	/*				++ Table name associated with the request
	/*
	/* Description:	This function will get the purge date from the first table
	/*				in the last run, if there are no records use sysdate
	/*
	/* Notes:		If the passed in table is the first table in the purge
	/*				order, return sysdate
	/*
	/* Return:		Date
	/*				++ Purge date
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/27/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetPurgeDate
	(
	p_TableName	IN		VARCHAR2
	)
	RETURN DATE
	IS
		-- Processing Variables
		v_MonthsToKeep		NUMBER				:= NULL;
		
		-- Fetch Variables
		f_PurgePos			NUMBER				:= NULL;
		f_MinPurgePos		NUMBER				:= NULL;
		f_Date				DATE				:= NULL;
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the purge position of the passed in table and the minimum
		/* purge position from purge tables
		/********************************************************************/
		select	purge_position
		into	f_PurgePos
		from	purge_tables
		where	table_name = p_TableName;
		select	min(purge_position)
		into	f_MinPurgePos
		from	purge_tables;
		
		/********************************************************************/
		/* If this is the first table in the purge order set null
		/* else get the purge_date of the first table in the purge order
		/* if no data is found it will still be null
		/********************************************************************/
		if( f_PurgePos = f_MinPurgePos ) then
			f_Date := null;
		else
			/********************************************************************/
			/* Get the purge date of the first table in the current purge run
			/********************************************************************/
			begin
				select 	max(h.purge_date)
				into	f_Date
				from 	purge_history h,
						purge_tables t
				where 	h.table_name = t.table_name
						and t.purge_position = f_MinPurgePos;
			exception
				when no_data_found then
					f_Date := null;
			end;
		end if; -- f_PurgePos = f_MinPurgePos
		
		/********************************************************************/
		/* If no date has been found determine which is lower, current date
		/* minus months to keep or the oldest rx-cores record plus months
		/* to keep
		/********************************************************************/
		if( f_Date is null ) then
		
			/***************************************************************/
			/* Get the number of months to keep
			/***************************************************************/
			v_MonthsToKeep := Fn_GetMonthsToKeep(p_TableName);
			select  min(purge_date)
			into	f_Date
			from    (
					select add_months( sysdate, -v_MonthsToKeep ) as purge_date
					from dual
					union
					select	min(created_date) + b_MaxDaysToPurge as purge_date
					from rx_cores
					);
		end if;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Date;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetPurgeDate for p_TableName: ' || p_TableName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetPurgeDate', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName );
			commit;
			RAISE;
	END Fn_GetPurgeDate;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetDbParameter
	/*
	/* Parameters:	p_Name		IN		VARCHAR2
	/*				++ Parameter name to get value for
	/*
	/* Description:	This function will get the value associated with the passed
	/*				in name
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Database parameter value
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/20/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetDbParameter
	(
	p_Name		IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Value				VARCHAR2(30)		:= NULL;
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get the parameter value
		/********************************************************************/
		select	value
		into	f_Value
		from	sys.v_$parameter
		where	name = p_Name;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Value;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( p_Name || ' not found in the v$parameter table ' );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetDbParameter', b_SqlCode, b_SqlErrm,
				'No data found in the v$parameter table for the name passed in',
				'P_Name: ' || p_Name );
			commit;
			RAISE NO_DATA_FOUND;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetDbParameter for ' || p_Name );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetDbParameter', b_SqlCode, b_SqlErrm,
				'Other error',
				'P_Name: ' || p_Name );
			commit;
			RAISE;
	END Fn_GetDbParameter;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetConfig
	/*
	/* Parameters:	p_Name           IN    VARCHAR2
	/*				++ Name of configuration value to retrieve
	/*
	/* Description:	This function will retrieve the value of the configuration
	/*				associated with the name passed in
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Value of the configuration
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetConfig
	(
	p_Name		IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Value				PURGE_CONFIG_SETTINGS.VALUE%TYPE	:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Comment of what you are doing
		/********************************************************************/
		select	value
		into	f_Value
		from	purge_config_settings
		where	name = p_Name;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Value;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetConfig, ' || p_Name || ' does not exist in the purge_config_settings table ' );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetConfig', b_SqlCode, b_SqlErrm,
				'No data found in purge_config_settings for the name passed in',
				'P_Name: ' || p_Name );
			commit;
			RAISE;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetConfig for name ' || p_Name );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetConfig', b_SqlCode, b_SqlErrm,
				'Other error',
				'P_Name: ' || p_Name );
			commit;
			RAISE;
	END Fn_GetConfig;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetEndWindow
	/*
	/* Parameters:	None
	/*
	/* Description:	This function will ensure we are starting inside the
	/*				processing window and determine the date value for the
	/*				end of the window
	/*
	/* Notes:		None
	/*
	/* Return:		DATE
	/*				++ Date value representing the end of the processing window
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetEndWindow
	RETURN DATE
	IS
		-- Processing Variables
		v_WindowTimes		PURGE_CONFIG_SETTINGS.VALUE%TYPE	:= NULL;
		v_StartHour			VARCHAR2(4)							:= NULL;
		v_EndHour			VARCHAR2(4)							:= NULL;
		v_StartDate			DATE								:= NULL;
		v_EndDate			DATE								:= NULL;
		v_RunTime			DATE								:= SYSDATE;
		
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get the window times configuration setting
		/********************************************************************/
		v_WindowTimes := Fn_GetConfig( c_WindowTimes );
		v_StartHour := substr( v_WindowTimes, 0, instr( v_WindowTimes, '-' )-1 );
		v_EndHour := substr( v_WindowTimes, instr( v_WindowTimes, '-' )+1 );
		/********************************************************************/
		/* Determine the start and end dates
		/********************************************************************/
		v_StartDate := to_date( to_char( v_RunTime, 'mm/dd/yyyy ' ) || v_StartHour, 'mm/dd/yyyy HH24mi' );
		v_EndDate := to_date( to_char( v_RunTime, 'mm/dd/yyyy ' ) || v_EndHour, 'mm/dd/yyyy HH24mi' );
		/********************************************************************/
		/* If the window spans a day increment the end time to accomodate
		/********************************************************************/
		if( v_StartDate > v_EndDate ) then
			v_EndDate := v_EndDate + 1;
		end if;
		/********************************************************************/
		/* If sysdate is before the start date, move the start date back one
		/* day and see if we are in the middle of the time range, if not
		/* error
		/* If sysdate is greater than the start date and the start date is
		/* greater than the end date increment the end date to tomorrow
		/********************************************************************/
		if( v_RunTime < v_StartDate ) then
			if( v_RunTime > v_StartDate-1 and v_RunTime < v_EndDate-1 ) then
				v_StartDate := v_StartDate - 1;
				v_EndDate := v_EndDate - 1;
			else
				raise e_NotInWindow;
			end if;
		elsif( v_RunTime > v_StartDate and v_RunTime < v_EndDate ) then
			NULL;
		else
			raise e_NotInWindow;
		end if;
		
		/********************************************************************/
		/* Set the number of hours in the window
		/********************************************************************/
		b_NbrHoursInWindow := 24 * ( v_EndDate - v_StartDate );
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN v_EndDate;
	
	EXCEPTION
		WHEN e_NotInWindow THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Program was called before the valid start time, ' || to_char( v_StartDate, 'mm/dd/yyyy hh24:mi' ) || ' determined by ' || c_WindowTimes || ' configuration setting of ' || v_WindowTimes );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetEndWindow', b_SqlCode, b_SqlErrm,
				'Program was called before the valid start time, ' || to_char( v_StartDate, 'mm/dd/yyyy hh24:mi' ) || ' determined by ' || c_WindowTimes || ' configuration setting of ' || v_WindowTimes,
				'None' );
			commit;
			RAISE_APPLICATION_ERROR( -20001, 'Program was called before the valid start time, ' || to_char( v_StartDate, 'mm/dd/yyyy hh24:mi' ) || ' determined by ' || c_WindowTimes || ' configuration setting of ' || v_WindowTimes );
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetEndWindow using ' || v_WindowTimes );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetEndWindow', b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Fn_GetEndWindow;
	/***************************************************************************/
	/*
	/* Function:	Fn_HasSelfReferenceFk
	/*
	/* Parameters:	p_TableName           IN    VARCHAR2
	/*				++ Table name to check
	/*
	/* Description:	This function will determine if the table has a self
	/*				referencing foreign key
	/*
	/* Notes:		None
	/*
	/* Return:		BOOLEAN
	/*				++ Boolean true or false does it have a self ref fk
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/31/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_HasSelfReferenceFk
	(
	p_TableName		IN		VARCHAR2
	)
	RETURN BOOLEAN
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Count				NUMBER				:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Count how many self referencing foreign keys the table has
		/********************************************************************/
		select  count(*)
		into	f_Count
		from    purge_tables p,
				user_constraints cc,
				user_constraints cp
		where   p.table_name = p_TableName
				and p.table_name = cp.table_name
				and cp.constraint_type='P'
				and cp.constraint_name = cc.r_constraint_name
				and cc.constraint_type = 'R';
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		if( f_Count > 0 ) then
			RETURN TRUE;
		else
			RETURN FALSE;
		end if;
		
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_HasSelfReferenceFk' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_HasSelfReferenceFk', b_SqlCode, b_SqlErrm,
				'Other error',
				'P_TableName: ' || p_TableName );
			commit;
			RAISE;
	END Fn_HasSelfReferenceFk;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetTaskElapsedSecs
	/*
	/* Parameters:	p_HistId           IN    NUMBER
	/*				++ purge_history.id to get elapsed seconds for
	/*
	/* Description:	This function will sum all the elapsed seconds for all
	/*				the partitions associated with the history record
	/*
	/* Notes:		None
	/*
	/* Return:		NUMER
	/*				++ Total elapsed seconds for table
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/24/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetTaskElapsedSecs
	(
	p_HistId	IN		NUMBER
	)
	RETURN NUMBER
	IS
		-- Processing Variables
		-- Fetch Variables
		f_TotSecs			NUMBER				:= NULL;
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Sum all the elapsed seconds for the partitions
		/********************************************************************/
		select 	sum(tot_elapsed_secs)
		into	f_TotSecs
		from 	purge_history_partitions
		where 	id_purge_history = p_HistId;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_TotSecs;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetTaskElapsedSecs for id ' || p_HistId );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetTaskElapsedSecs', b_SqlCode, b_SqlErrm,
				'Other error',
				'P_HistId: ' || p_HistId );
			commit;
			RAISE;
	END Fn_GetTaskElapsedSecs;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetEligibleCount
	/*
	/* Parameters:	None
	/*
	/* Description:	This function will return the number of tables that are
	/*				eligible to be purged
	/*
	/* Notes:		The number of eligible tables is the sum of all the tables
	/*				to be purged plus the number not completed from the last
	/*				run
	/*
	/* Return:		NUMBER
	/*				++ Number of tables that are eligible for purge
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/17/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetEligibleCount
	RETURN NUMBER
	IS
		-- Processing Variables
		-- Fetch Variables
		f_TableCount		NUMBER				:= 0;
		f_CurrentCount		NUMBER				:= 0;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get a count of all the purge tables
		/********************************************************************/
		select	count(purge_position)
		into	f_TableCount
		from	purge_tables;
		/********************************************************************/
		/* Get a count of all the purge tables left to complete the
		/* current cycle
		/********************************************************************/
		select	count(purge_position)
		into	f_CurrentCount
		from	purge_tables
		where	purge_position >
				(
				select	purge_position
				from	purge_tables
				where	table_name =
						(
						select	table_name
						from	purge_history
						where	id =
								(
								select	max(id)
								from	purge_history
								)
						)
				);
		/********************************************************************/
		/* Return the number of eligible tables
		/********************************************************************/
		RETURN f_TableCount+f_CurrentCount;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_Test' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetEligibleCount', b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Fn_GetEligibleCount;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetLatestHistory
	/*
	/* Parameters:	None
	/*
	/* Description:	This function will retrieve the last purge_history record
	/*				generated by the SBMO purge process
	/*
	/* Notes:		None
	/*
	/* Return:		PURGE_HISTORY%ROWTYPE
	/*				++ The latest history row in purge_history
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetLatestHistory
	RETURN PURGE_HISTORY%ROWTYPE
	IS
		-- Processing Variables
		-- Fetch Variables
		f_HistoryRec		PURGE_HISTORY%ROWTYPE			:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the last row in the purge_history table
		/********************************************************************/
		select	*
		into	f_HistoryRec
		from	purge_history
		where	id =
				(
				select	max(id)
				from	purge_history
				-- this is taken care of in Sp_PurgeSbmo where	status in ( c_Stopped, c_Finished, c_FinishedErrors )
				);
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_HistoryRec;
	
	EXCEPTION
		/********************************************************************/
		/* If no data is in the history table set status and no table
		/********************************************************************/
		WHEN NO_DATA_FOUND THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			f_HistoryRec.STATUS := c_Finished;
			f_HistoryRec.TABLE_NAME := c_NoTable;
			RETURN f_HistoryRec;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetLatestHistory' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetLatestHistory', b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Fn_GetLatestHistory;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetLatestHistoryPartitions
	/*
	/* Parameters:	None
	/*
	/* Description:	This function will retrieve the last purge_history_partitions
	/*				record generated by the SBMO purge process for a partition
	/*				that is associated with the purge_history.id passed in
	/*
	/* Notes:		None
	/*
	/* Return:		PURGE_HISTORY_PARTITIONS%ROWTYPE
	/*				++ The latest history row in purge_history
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/23/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetLatestHistoryPartitions
	(
	p_HistId		IN		NUMBER
	)
	RETURN PURGE_HISTORY_PARTITIONS%ROWTYPE
	IS
		-- Processing Variables
		-- Fetch Variables
		f_HistoryRec		PURGE_HISTORY_PARTITIONS%ROWTYPE	:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the last row in the purge_history_partitions table
		/********************************************************************/
		select	*
		into	f_HistoryRec
		from	purge_history_partitions
		where	id =
				(
				select	max(id)
				from	purge_history_partitions
				where	id_purge_history = p_HistId
				);
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_HistoryRec;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			RAISE NO_DATA_FOUND;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetLatestHistoryPartitions for purge_history_id ' || P_HistId );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetLatestHistoryPartitions', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_HistId: ' || p_HistId );
			commit;
			RAISE;
	END Fn_GetLatestHistoryPartitions;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetNextPurgeTable
	/*
	/* Parameters:	p_TableName      IN    VARCHAR2
	/*				++ Last purge table
	/*
	/* Description:	This function will get the table name of the next table to
	/*				be purged, it used the input table name to determine the
	/*				next
	/*
	/* Notes:		There may be gaps in the table id
	/*
	/* Return:		VARCHAR2
	/*				++ Next table to be purged
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetNextPurgeTable
	(
	p_TableName	IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		-- Fetch Variables
		f_TableName			PURGE_TABLES.TABLE_NAME%TYPE	:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the next available table with a higher purge position
		/* If none found, return the first one
		/********************************************************************/
		BEGIN
			select	table_name
			into	f_TableName
			from	purge_tables
			where	purge_position >
					(
					select	purge_position
					from	purge_tables
					where	table_name = p_TableName
					)
			order by purge_position
			fetch first 1 rows only;
		EXCEPTION
			WHEN NO_DATA_FOUND then
				select	table_name
				into	f_TableName
				from	purge_tables
				where	purge_position =
						(
						select	min(purge_position)
						from	purge_tables
						);
		END;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_TableName;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetNextPurgeTable for ' || p_TableName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetNextPurgeTable', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName );
			commit;
			RAISE;
	END Fn_GetNextPurgeTable;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetPurgePosition
	/*
	/* Parameters:	p_TableName      IN    VARCHAR2
	/*				++ Table to get purge position for
	/*
	/* Description:	This function will get purge position for the table name
	/*				passed in
	/*
	/* Notes:		None
	/*
	/* Return:		NUMBER
	/*				++ Purge position associated with the table passed in
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetPurgePosition
	(
	p_TableName	IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Position			NUMBER							:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the purge position of the passed in table
		/********************************************************************/
		select	purge_position
		into	f_Position
		from	purge_tables
		where	table_name = p_TableName;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Position;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetPurgePosition for ' || p_TableName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetPurgePosition', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName );
			commit;
			RAISE;
	END Fn_GetPurgePosition;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetTaskParallelCount
	/*
	/* Parameters:	p_TableName      IN    VARCHAR2
	/*				++ Table to get parallel count for
	/*
	/* Description:	This function will get the parallel count (or use the default)
	/*				for the table name passed in
	/*
	/* Notes:		If no parallel count exists in purge tables or it is higher
	/8				than the configuration setting, use the configuration
	/*
	/* Return:		NUMBER
	/*				++ Parallel count associated with the table passed in
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/28/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetTaskParallelCount
	(
	p_TableName	IN		VARCHAR2
	)
	RETURN NUMBER
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Parallel			NUMBER							:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the purge position of the passed in table
		/********************************************************************/
		select	nvl(parallel_count, b_ParallelChunkCount)
		into	f_Parallel
		from	purge_tables
		where	table_name = p_TableName;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		if( f_Parallel <= b_ParallelChunkCount ) then
			RETURN f_Parallel;
		else
			RETURN b_ParallelChunkCount;
		end if;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetTaskParallelCount for ' || p_TableName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetTaskParallelCount', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName );
			commit;
			RAISE;
	END Fn_GetTaskParallelCount;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetPurgeColumn
	/*
	/* Parameters:	p_TableName      IN    VARCHAR2
	/*				++ Table to get purge column for
	/*
	/* Description:	This function will get purge column for the table name
	/*				passed in
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Purge column associated with the table passed in
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetPurgeColumn
	(
	p_TableName	IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Column			VARCHAR2(30)					:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the purge column of the passed in table
		/********************************************************************/
		select	purge_column
		into	f_Column
		from	purge_tables
		where	table_name = p_TableName;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Column;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetPurgeColumn for ' || p_TableName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetPurgeColumn', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName );
			commit;
			RAISE;
	END Fn_GetPurgeColumn;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetTaskName
	/*
	/* Parameters:	p_TableName			IN		VARCHAR2
	/*				++ Table name used for the task name
	/*				p_PartName			IN		VARCHAR2
	/*				++ Partition name used for task name
	/*
	/* Description:	This function will generate the task name
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Task name
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetTaskName
	(
	p_TableName		IN		VARCHAR2,
	p_PartName		IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		v_Name				VARCHAR2(30)		:= NULL;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Generate the task name
		/********************************************************************/
		v_Name := c_TaskNamePrefix || '_PP' || fn_GetPurgePosition( p_TableName );
		v_Name := v_Name || '_' || p_PartName;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN UPPER( v_Name );
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetTaskName for table ' || p_TableName || ' and partition ' || p_PartName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetTaskName', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
			RAISE;
	END Fn_GetTaskName;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetJobName
	/*
	/* Parameters:	p_TableName			IN		VARCHAR2
	/*				++ Table name used for the task name
	/*				p_PartName			IN		VARCHAR2
	/*				++ Partition name used for task name
	/*
	/* Description:	This function will generate the scheduler job name
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Job name
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetJobName
	(
	p_JobType		IN		VARCHAR2,
	p_TableName		IN		VARCHAR2,
	p_PartName		IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		v_Name				VARCHAR2(60)		:= NULL;
		v_Date				VARCHAR2(20)		:= to_char( sysdate, 'mmddyyyy' );
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Generate the job name
		/********************************************************************/
		if( p_JobType = c_Monitor ) then
			v_Name := c_MonJobNamePrefix || '_PP' || fn_GetPurgePosition( p_TableName );
			v_Name := v_Name || '_' || p_PartName || '_' || v_Date;
		elsif( p_JobType = c_Index ) then
			v_Name := c_IndJobNamePrefix || '_PP' || fn_GetPurgePosition( p_TableName );
			v_Name := v_Name || '_' || p_PartName || '_' || v_Date;
		else
			raise e_BadJobType;
		end if;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN substr( UPPER( v_Name ), 1, 30 );
	
	EXCEPTION
		WHEN e_BadJobType THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetJobName job type ' || p_JobType || ' does not exist ' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetJobName', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_JobType: ' || p_JobType || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
			RAISE;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetJobName for job type ' || p_JobType || ', table ' || p_TableName || ' and partition ' || p_PartName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetJobName', b_SqlCode, b_SqlErrm,
				'Job type ' || p_JobType || ' does not exist ',
				'p_JobType: ' || p_JobType || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
			RAISE;
	END Fn_GetJobName;
/***************************************************************************/
	/*
	/* Function:	Fn_GetChunkCount
	/*
	/* Parameters:	p_TaskName			IN		VARCHAR2
	/*				++ Task name to get count for
	/*
	/* Description:	This function will get the chunk count for a task
	/*
	/* Notes:		None
	/*
	/* Return:		NUMBER
	/*				++ Chunk Count
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetChunkCount
	(
	p_TaskName		IN		VARCHAR2
	)
	RETURN NUMBER
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Count				NUMBER				:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get the chunk count
		/********************************************************************/
		select	count(*)
		into	f_Count
		from	user_parallel_execute_chunks
		where	task_name = p_TaskName;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Count;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetChunkCount for task ' || p_TaskName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetChunkCount', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TaskName: ' || p_TaskName );
			commit;
			RAISE;
	END Fn_GetChunkCount;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetConsColumns
	/*
	/* Parameters:	p_TableName			IN		VARCHAR2
	/*				++ Table associated with the constraint
	/*				p_ConsName			IN		VARCHAR2
	/*				++ Constraint name
	/*				p_AddTenant			IN		CHAR
	/*				++ Flag denoting to add the tenant column or not
	/*
	/* Description:	This function will get the column list for the passed in
	/*				table and constraint
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Column list
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/26/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetConsColumns
	(
	p_TableName		IN		VARCHAR2,
	p_ConsName		IN		VARCHAR2,
	p_AddTenant		IN		CHAR				DEFAULT c_Yes
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Cols				VARCHAR2(500)		:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get the column list
		/********************************************************************/
		if( p_AddTenant = c_Yes ) THEN
			select  LISTAGG(column_name, ',')
					within group (order by position) as columns
			into	f_Cols
			FROM    user_cons_columns
			where   table_name = p_TableName
					and constraint_name = p_ConsName;
		else
			select  LISTAGG(column_name, ',')
					within group (order by position) as columns
			into	f_Cols
			FROM    user_cons_columns
			where   table_name = p_TableName
					and constraint_name = p_ConsName
					and column_name <> 'TENANT_ID';
		end if;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Cols;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetConsColumns for table ' || p_TableName || ' and constraint ' || p_ConsName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetConsColumns',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' p_ConsName: ' || p_ConsName );
			commit;
			RAISE;
	END Fn_GetConsColumns;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetChunkSql
	/*
	/* Parameters:	p_TableName			IN		VARCHAR2
	/*				++ Table to chunk sql for
	/*				p_PartName			IN		VARCHAR2
	/*				++ Partition to chunk sql for
	/*				p_ColumnName		IN		VARCHAR2
	/*				++ Date column used to purge by
	/*				++ Purge anything older than this many months
	/*				p_PurgeDate			IN		DATE
	/*				++ Date to purge before
	/*				p_Tenant			IN		NUMBER
	/*				++ Tenant id
	/*
	/* Description:	This function will generate the sql used to chunk the
	/*				table into pieces for the parallel execution
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Chunk sql
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetChunkSql
	(
	p_TableName		IN		VARCHAR2,
	p_PartName		IN		VARCHAR2,
	p_ColumnName	IN		VARCHAR2,
	p_PurgeDate		IN		DATE,
	p_Tenant		IN		NUMBER
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		v_Sql				VARCHAR2(4000)		:= NULL;
		v_part_clause       VARCHAR2(4000)		:= NULL;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Generate the chunk sql
		/********************************************************************/
dbms_output.put_line('DEBUG Fn_GetChunkSql : p_TableName - ' || p_TableName || ' , p_PartName - ' || p_PartName );
		
		if (p_partName = 'NON_PARTITIONED') then
		v_part_clause := null ;
		else
		  v_part_clause := ' partition (' || p_partName || ') '  ;
		end if ;
		
		v_Sql := ' with ids ' ||
				' as ' ||
				'( ' ||
					'select  id as start_id ' ||
					'from    ( ' ||
							'select  id ' ||
							'from ' || p_TableName || v_part_clause ; -- old code :' partition (' || p_partName || ') ';
	
		-- Medha: add check here if partition is NULL or NON_PARTITIONED , then skip part clause
		
		if(	p_Tenant is NULL ) then
			v_Sql := v_Sql || ' where ' || p_ColumnName || ' < ';
		else
			v_Sql := v_Sql || ' where  tenant_id = ' || p_Tenant || ' and ' || p_ColumnName || ' < ';
		end if;
		v_Sql := v_Sql || 'to_date( ''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ''', ''mm/dd/yyyy hh24:mi:ss'' ) ' ||
							'order by id ' ||
							') ' ||
					'group by rownum, id ' ||
					'having mod(rownum, ' || b_ChunkSize || ' ) = 0 ' ||
					'union ' ||
					'select min(id) as start_id ' ||
					'from ' || p_TableName || v_part_clause ; -- old code : ' partition (' || p_partName || ') ';
		if(	p_Tenant is NULL ) then
			v_Sql := v_Sql || ' where ' || p_ColumnName || ' < ';
		else
			v_Sql := v_Sql || ' where  tenant_id = ' || p_Tenant || ' and ' || p_ColumnName || ' < ';
		end if;
		
		v_Sql := v_Sql || 'to_date( ''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ''', ''mm/dd/yyyy hh24:mi:ss'' ) ' ||
					'union ' ||
					'select max(id) as start_id ' ||
					'from ' || p_TableName || v_part_clause ; -- old code: ' partition (' || p_partName || ') ';
					
		-- Do not include tenant_id, testing determined it is faster for the chunking
		-- sql to just do the subpartition pruning and then full subpartition scan
		v_Sql := v_Sql || ' where ' || p_ColumnName || ' < ';
		v_Sql := v_Sql || 'to_date( ''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ''', ''mm/dd/yyyy hh24:mi:ss'' ) ' ||
					'order by 1 ' ||
				'), ' ||
				'chunks ' ||
				'as ' ||
				'( ' ||
					'select  start_id, ' ||
							'lead(start_id,1,0) over (order by start_id) as end_id, ' ||
							'lag(start_id,1,0) over (order by start_id) as prevr ' ||
					'from    ids ' ||
				') ' ||
				'select	start_id, ' ||
						'decode( end_id, 0, start_id + ' || b_ChunkSize || ', end_id-1 ) as end_id ' ||
				'from	chunks ';
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
dbms_output.put_line('DEBUG | Fn_GetChunkSql - ' || v_Sql );
		RETURN v_Sql;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetChunkSql for table ' || p_TableName || ' and partition ' || p_PartName || ' and column ' || p_ColumnName|| ' | p_PurgeDate: ' || to_char(p_PurgeDate,'mm/dd/yyyy hh24:mi:ss') );
			DBMS_OUTPUT.PUT_LINE( 'Sql thus far: ' || v_Sql );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetChunkSql',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_ColumnName: ' || p_ColumnName || ' | p_PurgeDate: ' || to_char(p_PurgeDate,'mm/dd/yyyy hh24:mi:ss') );
			commit;
			RAISE;
	END Fn_GetChunkSql;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetTaskSql
	/*
	/* Parameters:	p_TaskName			IN		VARCHAR2
	/*				++ Task name associated, used in final row count insert
	/*				p_TableName			IN		VARCHAR2
	/*				++ Table to chunk sql for
	/*				p_PartName			IN		VARCHAR2
	/*				++ Partition to chunk sql for
	/*				p_ColumnName		IN		VARCHAR2
	/*				++ Date column used to purge by
	/*				p_PurgeDate			IN		DATE
	/*				++ Date to purge below
	/*				p_HistId			IN		NUMBER
	/*				++ Purge history record id for the table passed in
	/*				p_Tenant			IN		NUMBER
	/*				++ Tenant id
	/*
	/* Description:	This function will generate the sql used to delete the
	/*				table
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Task sql
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetTaskSql
	(
	p_TaskName		IN		VARCHAR2,
	p_TableName		IN		VARCHAR2,
	p_PartName		IN		VARCHAR2,
	p_ColumnName	IN		VARCHAR2,
	p_PurgeDate		IN		DATE,
	p_HistId		IN		NUMBER,
	p_Tenant		IN		NUMBER
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		v_FkSql				VARCHAR2(4000)		:= ' ';
		v_Sql				VARCHAR2(4000)		:= NULL;
		v_part_clause   	VARCHAR2(4000)		:= NULL;
		
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_SelfFks
				(
				p_Table		VARCHAR2
				)
		is
				select  cp.constraint_name as parent_constraint,
						cc.constraint_name as fk_constraint
				from    user_constraints cp,
						user_constraints cc
				where   cp.table_name = p_Table
						and cp.constraint_type='P'
						and cp.constraint_name = cc.r_constraint_name
						and cc.constraint_type = 'R'
						and cp.table_name = cc.table_name;
		
		cursor	c_Cols
				(
				p_String	VARCHAR2
				)
		is
				select	column_value as string_val
				from	table(Fn_SplitString( p_String ) );
		-- Cursor Fetch Variables
	BEGIN
		--Medha: Depending on if table is partitioned or not use the v_part_clause clause 		
		if (p_PartName = 'NON_PARTITIONED') then
		v_part_clause := null;
		else
		  v_part_clause := ' partition (' || p_PartName || ') ' ;
		end if;
		
		
		/********************************************************************/
		/* Generate the self referencing foreign key sql
		/********************************************************************/
		for lr in c_SelfFks( p_TableName ) loop
			v_FkSql := v_FkSql || 'update ' ||
					p_TableName || v_part_clause || ' d ' ||
					'set ';
					
			for lr1 in c_Cols( Fn_GetConsColumns( p_TableName, lr.fk_constraint, c_No ) ) loop
				v_FkSql := v_FkSql || lr1.string_val || ' = null, ';
			end loop;
			v_FkSql := substr( v_FkSql, 1, instr( v_FkSql, ',' )-1 );
			v_FkSql := v_FkSql || ' ' ||
					' where (' || Fn_GetConsColumns( p_TableName, lr.fk_constraint ) || ') in ' ||
						'( ' ||
						'select ' || Fn_GetConsColumns( p_TableName, lr.parent_constraint ) || ' ' ||
						'from ' || p_TableName || v_part_clause ||
						' where ' || Fn_GetConsColumns( p_TableName, lr.parent_constraint, c_No ) || ' ' ||
										'between :start_id and :end_id  ';
		if(	p_Tenant is NOT NULL ) then
			v_FkSql := v_FkSql || 'and tenant_id = ' || p_Tenant || ' ';
		end if;
			v_FkSql := v_FkSql || 'and ' || p_ColumnName || ' < ' ||
							'to_date( ''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ''', ''mm/dd/yyyy hh24:mi:ss'' ) ' ||
					'); ';
		end loop;
		
		/********************************************************************/
		/* Generate the task sql
		/********************************************************************/
		v_Sql :=	'declare ' ||
						'v_StartTime	date	:= sysdate; ' ||
						'v_count		number	:= null; ' ||
					'begin ' ||
						' ' ||
						v_FkSql ||
						' ' ||
						'delete ' || p_TableName || v_part_clause ;
		if(	p_Tenant is NULL ) then
			v_Sql := v_Sql || ' where ' || p_ColumnName || ' < ';
		else
			v_Sql := v_Sql || ' where  tenant_id = ' || p_Tenant || ' and ' || p_ColumnName || ' < ';
		end if;
		v_Sql := v_Sql || 'to_date( ''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ''', ''mm/dd/yyyy hh24:mi:ss'' ) ' ||
						'and id between :start_id and :end_id ; ' ||
						' ' ||
						'v_count := sql%rowcount; ' ||
						' ' ||
						'insert into purge_history_chunks( id, id_purge_history_partitions, ' ||
							' table_name, part_name, task_name, start_time, end_time, row_count ) ' ||
						'values ( purge_seq.nextval, ' || p_HistId || ', ' ||
							'''' || p_TableName || ''', ''' || p_PartName || ''', ' ||
							'''' || p_TaskName || ''', v_StartTime, sysdate, v_count ); ' ||
						'commit; ' ||
					'end; ';
					
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN v_Sql;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetTaskSql for table ' || p_TableName || ' and partition ' || p_PartName || ' and column ' || p_ColumnName || ' | p_PurgeDate: ' || to_char(p_PurgeDate,'mm/dd/yyyy hh24:mi:ss') || ' | p_HistId: ' || p_HistId );
			DBMS_OUTPUT.PUT_LINE( 'Sql thus far: ' || v_Sql );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetTaskSql',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_ColumnName: ' || p_ColumnName || ' | p_PurgeDate: ' || to_char(p_PurgeDate,'mm/dd/yyyy hh24:mi:ss') || ' | p_HistId: ' || p_HistId );
			commit;
			RAISE;
	END Fn_GetTaskSql;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetTenantId
	/*
	/* Parameters:	p_TableName			IN		VARCHAR2
	/*				++ Table to chunk sql for
	/*				p_PartName			IN		VARCHAR2
	/*				++ Partition to chunk sql for
	/*
	/* Description:	This function will get the tenant_id associated with the
	/*				table and partition unless the partition is other then it
	/*				will return null
	/*
	/* Notes:		None
	/*
	/* Return:		NUMBER
	/*				++ Tenant id
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	02/08/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetTenantId
	(
	p_TableName		IN		VARCHAR2,
	p_PartName		IN		VARCHAR2
	)
	RETURN NUMBER
	IS
		-- Processing Variables
		v_Count				NUMBER				:= 0;
		v_Tenant			NUMBER				:= null;
		
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_Val
				(
				p_Table		VARCHAR2,
				p_Part		VARCHAR2
				)
		is
				select  high_value
				from    user_tab_partitions
				where   table_name = p_Table
						and partition_name = p_Part;
		
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Look at the high value for the partition, error if none found
		/********************************************************************/
		for lr in c_val( p_TableName, p_PartName ) loop
			if( upper(lr.high_value) = 'DEFAULT' ) then
				v_Tenant := null;
			else	
				v_Tenant := to_number(lr.high_value);
			end if;
			v_Count := v_Count + 1;
		end loop;
		if( v_count = 0 ) then
			raise no_data_found;
		end if;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN v_Tenant;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'No data found in Fn_GetTenantId for table ' || p_TableName || ' and partition ' || p_PartName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetTenantId',  b_SqlCode, b_SqlErrm,
				'No Data Found',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
			RAISE;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetTenantId for table ' || p_TableName || ' and partition ' || p_PartName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetTenantId',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
			RAISE;
	END Fn_GetTenantId;
	-----------------------------------------------------------------------------
	-- Declare Private Procedures
	-----------------------------------------------------------------------------
	/***************************************************************************/
	/*
	/* Procedure:	Sp_Test
	/*
	/* Parameters:	p_Test1           IN    VARCHAR2
	/*				++ Description of parameter
	/*
	/* Description:	YY
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/10/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_Test
	(
	p_Test1		IN		VARCHAR2
	)
	IS
		-- Processing Variables
		v_Return			VARCHAR2(30)		:= NULL;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Comment of what you are doing
		/********************************************************************/
		NULL;
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_Test' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_Test',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_Test1: ' || p_Test1 );
			commit;
			RAISE;
	END Sp_Test;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_SetConfig
	/*
	/* Parameters:	None
	/*
	/* Description:	This procedure will set the package body variables
	/*				associated with all the configuration settings
	/*
	/* Notes:		This procedure should be the first line of any public
	/*				function or procedure
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/25/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_SetConfig
	IS
		-- Processing Variables
		v_Today				VARCHAR2(20)		:= rtrim(to_char(sysdate,'DAY'));
		v_Config			VARCHAR2(255)		:= NULL;
		
		-- Fetch Variables
		f_Count				NUMBER				:= NULL;
		f_Freespace			NUMBER				:= NULL;
		
		-- Exception Variables
		-- Cursors
		cursor	c_Blackout
				(
				p_String	VARCHAR2
				)
		is
				select	upper(column_value) as blackout_day
				from	table(Fn_SplitString( p_String ) );
				
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Set the package body variables for configuration settings
		/* and check minimum requirements
		/********************************************************************/
		b_DefPartMins := to_number( Fn_GetConfig( c_DefPartMins ) );
		b_ChunkSize	:= to_number( Fn_GetConfig( c_ChunkSize ) );
		b_ParallelChunkCount	:= to_number( Fn_GetConfig( c_ParallelChunkCount ) );
		b_ParallelQueryCount	:= to_number( Fn_GetConfig( c_ParallelQueryCount ) );
		b_RetryCount := to_number( Fn_GetConfig( c_RetryCount ) );
		b_SleepTime := to_number( Fn_GetConfig( c_SleepTime ) );
		b_MultiBlock := to_number( Fn_GetConfig( c_MultiBlock ) );
		b_OrigMultiBlock := Fn_GetDbParameter( 'db_file_multiblock_read_count' );
		b_OrigOptimizerMode := Fn_GetDbParameter( 'optimizer_mode' );
		
		b_MailHost := Fn_GetConfig( c_MailHost );
		b_MailPort := Fn_GetConfig( c_MailPort );
		b_MailFrom := Fn_GetConfig( c_MailFrom );
		b_MailTo := Fn_GetConfig( c_MailTo );
		b_PageTo := Fn_GetConfig( c_PageTo );
		b_ForceRestart := Fn_GetConfig( c_ForceRestart );
		b_AppMonthsToKeep := to_number( Fn_GetConfig( c_AppMonthsToKeep ) );
		b_PurgeMonthsToKeep := to_number( Fn_GetConfig( c_PurgeMonthsToKeep ) );
		b_SubpartOptMode := Fn_GetConfig( c_SubpartOptMode );
		b_MaxDaysToPurge := to_number( Fn_GetConfig( c_MaxDaysToPurge ) );
		/********************************************************************/
		/* Make sure job class exists and we can use it
		/********************************************************************/
		b_JobClass := Fn_GetConfig( c_JobClass );
		select 	sum(priv_count)
		into	f_Count
		from 	(
				select 	count(*) as priv_count
				from 	user_tab_privs
				where 	table_name = b_JobClass
						and privilege = 'EXECUTE'
				union
				select 	count(*)  as priv_count
				from 	all_tab_privs
				where 	grantee = 'PUBLIC'
						and table_name = b_JobClass
						and privilege = 'EXECUTE'
				);
				
		if( f_Count = 0 ) then
			raise e_InvalidJobClass;
		end if;
		b_WindowEnd	:= Fn_GetEndWindow;
		/********************************************************************/
		/* Ensure today is not a blackout day
		/********************************************************************/
		for lr in c_Blackout( Fn_GetConfig( c_BlackoutDay ) ) loop
			if( lr.blackout_day = v_Today ) then
				raise e_BlackoutDay;
			end if;
		end loop;
		
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'No data found in Sp_SetConfig for config ' || v_Config );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SetConfig',  b_SqlCode, b_SqlErrm,
				'No data found for config ' || v_Config,
				'v_Config: ' || v_Config );
			commit;
			raise_application_error(-20912, 'No data found for config ' || v_Config);
		WHEN e_InvalidJobClass THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SetConfig Invalid job class ' || b_JobClass );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SetConfig',  b_SqlCode, b_SqlErrm,
				'Invalid job class - ' || b_JobClass,
				'None' );
			commit;
			raise_application_error(-20011, 'Job class does not exist or user has no permissions on it: ' || b_JobClass );
		WHEN e_BlackoutDay THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SetConfig today, ' || v_Today || ', is defined as a blackout day' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SetConfig',  b_SqlCode, b_SqlErrm,
				'Today, ' || v_Today || ', is defined as a blackout day',
				'None' );
			commit;
			raise_application_error(-20012, 'Today, ' || v_Today || ', is defined as a blackout day' );
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SetConfig' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SetConfig',  b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			raise_application_error(-20015, 'Other error setting configurations, sqlcode: ' || b_SqlCode || ' and message: ' || b_SqlErrm );
	END Sp_SetConfig;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_WriteLogFile
	/*
	/* Parameters:	p_PurgeDate		DATE
	/*				++ Date used as the purge baseline
	/*
	/* Description:	This procedure will write all input data to a log file
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	05/08/2020	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_WriteLogFile
	(
	p_RunStart		IN			DATE,
	p_Msg			IN			CLOB
	)
	IS
		-- Processing Variables
		v_Sql				VARCHAR2(4000)		:= null;
		v_FileName			VARCHAR2(255)		:= 'ora_purge_sbmo_' || sys_context('USERENV','INSTANCE_NAME') || '_' || to_char(p_RunStart, 'yyyymmdd_hh24mi') || '.log';
		v_File			UTL_FILE.FILE_TYPE;
		v_Length			NUMBER			:= NVL(DBMS_LOB.GetLength(p_Msg),0);
		v_Buffer			NUMBER			:= 32000;
		v_Offset			NUMBER			:= 1;
		
		-- Fetch Variables
		f_HistId			NUMBER			:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Open the log file, if error recreate the directory object and
		/* try again
		/********************************************************************/
		begin
			v_File := utl_file.fopen( 'DBA_LOG_DIR', v_FileName, 'w', 32760 );
		exception
			when others then
				v_Sql := 'Create or replace directory dba_log_dir as ''/oracle_scripts/log/' || sys_context('USERENV','INSTANCE_NAME') || ''' ';
				execute immediate v_Sql;
				v_File := utl_file.fopen( 'DBA_LOG_DIR', v_FileName, 'w', 32760 );
		end;
		/********************************************************************/
		/* Write the message to the file
		/********************************************************************/
		while( v_Offset < v_Length ) loop
			utl_file.put( v_File, dbms_lob.substr(p_Msg, v_Buffer, v_Offset) );
			utl_file.fflush(v_File);
			v_Offset := v_Offset + v_Buffer;
		end loop;
		utl_file.new_line(v_File);
		/********************************************************************/
		/* Close the file
		/********************************************************************/
		utl_file.fclose( v_File );
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_WriteLogFile for p_RunStart: ' || to_char(p_RunStart, 'mm/dd/yyyy hh24:mi:ss') );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			rollback;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_WriteLogFile',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_RunStart: ' || to_char(p_RunStart, 'mm/dd/yyyy hh24:mi:ss') || ' | p_Msg: ' || p_Msg );
			commit;
			if( utl_file.is_open(v_File) ) then
				utl_file.fflush(v_File);
				utl_file.fclose( v_File );
			end if;
			RAISE;
	END Sp_WriteLogFile;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_SendEmail
	/*
	/* Parameters:	p_Subj           IN    	VARCHAR2
	/*				++ Subject of the email
	/*				p_Msg			IN		CLOB
	/*				++ Body of the email
	/*				p_Fail			IN		CHAR
	/*				++ Flag to denote failure
	/*
	/* Description:	This procedure sends an email
	/*
	/* Notes:		If failure also include page email
	/*			If 'Mail To' is not set and no failure, no email will be
	/*			sent
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/28/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_SendEmail
	(
	p_Subj		IN		VARCHAR2,
	p_Msg		IN		CLOB,
	p_Fail		IN		CHAR					DEFAULT c_No
	)
	IS
		-- Processing Variables
		v_MailConn			UTL_SMTP.CONNECTION;
		v_Subj				VARCHAR2(1000)		:= 	lower(sys_context('USERENV','HOST')) || ':' || lower(sys_context('USERENV','DB_NAME')) || ':' || p_Subj;
		v_Count				NUMBER			:= 0;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_Addrs
				(
				p_String	VARCHAR2
				)
		is
				select	column_value as string_val
				from	table(Fn_SplitString( p_String ) )
				where		length(column_value) > 1
						and upper(column_value) <> 'NONE';
				-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Fill in the email and send it, add pager address if needed
		/********************************************************************/
		v_MailConn := UTL_SMTP.open_connection( b_MailHost, b_MailPort );
		UTL_SMTP.HELO( v_MailConn, b_MailHost );
		UTL_SMTP.MAIL( v_MailConn, b_MailFrom );
		for lr in c_Addrs( b_MailTo ) loop
			UTL_SMTP.RCPT( v_MailConn, lr.string_val );
			v_Count := v_Count + 1;
		end loop;
		if( p_Fail = c_Yes ) then
			for lr in c_Addrs( b_PageTo ) loop
				UTL_SMTP.RCPT( v_MailConn, lr.string_val );
				v_Count := v_Count + 1;
			end loop;
		end if;
		
		if( v_Count > 0 ) then
			UTL_SMTP.OPEN_DATA( v_MailConn );
			UTL_SMTP.WRITE_DATA( v_MailConn, 'Date: ' || to_char(sysdate, 'DD-MON-YYYY HH24:mi:ss') || UTL_TCP.crlf );
			UTL_SMTP.WRITE_DATA( v_MailConn, 'To: ' || b_MailTo || UTL_TCP.crlf );
			UTL_SMTP.WRITE_DATA( v_MailConn, 'From: ' || b_MailFrom || UTL_TCP.crlf );
			UTL_SMTP.WRITE_DATA( v_MailConn, 'Subject: ' || v_Subj || UTL_TCP.crlf );
			UTL_SMTP.WRITE_DATA( v_MailConn, 'Reply-To: ' || b_MailFrom || UTL_TCP.crlf || UTL_TCP.crlf );
			UTL_SMTP.WRITE_DATA( v_MailConn, p_Msg );
			UTL_SMTP.CLOSE_DATA( v_MailConn );
			UTL_SMTP.QUIT( v_MailConn );
		end if;
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SendEmail p_Subj: ' || p_Subj || ' | p_Msg: ' || substr(p_Msg, 1, 200) );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SendEmail',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_Subj: ' || p_Subj || ' | p_Msg: ' || substr(p_Msg, 1, 200) );
			commit;
			RAISE;
	END Sp_SendEmail;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_SendStatusReport
	/*
	/* Parameters:	p_Status		IN			VARCHAR2
	/*				++ Status of the return from Sp_PurgeSbmo
	/*				p_RunStart		IN			DATE
	/*				++ Date/time the current run started
	/*				p_Fail			IN			CHAR
	/*				++ Flag to denote if the status is a failure
	/*
	/* Description:	This procedure will generate and send the daily status rpt
	/*
	/* Notes:		If fail is yes then send fail notification as well
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/28/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_SendStatusReport
	(
	p_Status		IN			VARCHAR2,
	p_RunStart		IN 			DATE,
	p_Fail			IN			CHAR			DEFAULT c_No
	)
	IS
		-- Processing Variables
		v_Report			CLOB				:= empty_clob();
		v_Status			CLOB				:= p_Status;
		v_RunStart			DATE				:= p_RunStart;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_rpt
		is
				select	*
				from	table(Pkg_SBMO_Purge.Fn_DailyRpt(p_RunStart));
		cursor	c_errs
		is
				select	*
				from table(pkg_sbmo_purge.fn_ShowErrors(p_RunStart));
				
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Add the status and header to the report
		/********************************************************************/
		v_Report := 'SBMO Purge Report from ' || to_char(p_RunStart, 'mm/dd/yyyy hh24:mi:ss') || ' - ' || to_char(sysdate,'mm/dd/yyyy hh24:mi:ss') || chr(10) || chr(10);
		v_Report := v_Report || 'Report Status: ' || p_Status || chr(10) || chr(10);
		v_Report := v_Report || rpad('Table Name',33) || rpad('Tot Secs',15) || rpad('Tot Purged',15) || rpad('Tot FK Del',15) || rpad('Tot FK Secs',15) || rpad('# Dropped SP',15) || rpad('Purged / Sec',15) || 'FK / Sec' || chr(10);
		v_Report := v_Report || rpad('-',30,'-') || '   ' || rpad('-',12,'-') || '   ' || rpad('-',12,'-') || '   ' || rpad('-',12,'-') || '   ' || rpad('-',12,'-') || '   ' || rpad('-',12,'-') || '   ' || rpad('-',12,'-') || '   ' || rpad('-',12,'-') || chr(10);
		
		/********************************************************************/
		/* Loop through the daily report and add them to the message clob
		/********************************************************************/
		for lr in c_rpt loop
			v_Report := v_Report || rpad(lr.table_name,33) || to_char(lpad(lr.tot_secs,12),'999,999,999') || '   ' || to_char(lpad(lr.tot_purged,12),'999,999,999') || '   ' || to_char(lpad(lr.tot_fk_del,12),'999,999,999') || '   ' || to_char(lpad(lr.tot_fk_secs,12),'999,999,999') || '   ' || to_char(lpad(lr.tot_subparts,12),'999,999,999') || '   ' || to_char(lpad(lr.purged_per_sec,12),'999,999,999') || '   ' || to_char(lpad(lr.fk_per_sec,12),'999,999,999') || chr(10);
		end loop;
		/********************************************************************/
		/* Send the report
		/********************************************************************/
		Sp_SendEmail( 'Daily SBMO Purge Report - ' || to_char(sysdate, 'dd Mon yyyy'), v_Report );
		
		/********************************************************************/
		/* Send the failure email if necessary
		/********************************************************************/
		if( p_Fail = c_Yes ) then
			v_Status := v_Status || chr(10);
			for lr in c_errs loop
				v_Status := v_Status || chr(10) || lr.column_value;
			end loop;
			Sp_SendEmail( '[CRITICAL] Daily SBMO Purge ++FAILED++ - ' || to_char(sysdate, 'dd Mon yyyy'), '++FAILED++ Daily SBMO Purge with ' || v_Status, c_Yes );
		end if;
		/********************************************************************/
		/* Write the report to a log file
		/********************************************************************/
		Sp_WriteLogFile( v_RunStart, v_Report );
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SendStatusReport - Status: ' || p_Status || ' and Run Start: ' || to_char(p_RunStart,'mm/dd/yyyy hh24:mi:ss') );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SendStatusReport',  b_SqlCode, b_SqlErrm,
				'Other error',
				'Status: ' || p_Status || ' and Run Start: ' || to_char(p_RunStart,'mm/dd/yyyy hh24:mi:ss') );
			commit;
			RAISE;
	END Sp_SendStatusReport;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_SetRunFlag
	/*
	/* Parameters:	p_State           IN    CHAR
	/*				++ State to set the flag, running or stopped
	/*
	/* Description:	This procedure will update the run state table to reflect
	/*				the code sent in
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/28/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_SetRunFlag
	(
	p_State		IN		CHAR
	)
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* If data already exists, remove it.  Then insert a record to
		/* indicate the status passed in
		/********************************************************************/
		delete purge_run_check;
		
		insert into purge_run_check ( activity_date, purge_running )
		values ( systimestamp, p_State );
		
		commit;
		
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SetRunFlag' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SetRunFlag',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_State: ' || p_State );
			commit;
			RAISE;
	END Sp_SetRunFlag;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_CheckMonitorReturn
	/*
	/* Parameters:	None
	/*
	/* Description:	This procedure will check the monitor job return and if it
	/*				stopped the job it will raise the appropriate error
	/*
	/* Notes:		If the monitor determines it is the end of the processing
	/*				window or the stop run flag was set it will update the
	/*				table accordingly
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	04/30/2020	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_CheckMonitorReturn
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Running			purge_run_check.purge_running%TYPE	:= null;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get the running value and determine if it was updated by the
		/* monitor
		/********************************************************************/
		select	purge_running
		into	f_Running
		from	purge_run_check;
		/********************************************************************/
		/* If the monitor updated the value raise the appropriate flag
		/********************************************************************/
		case	f_Running
				when c_MonitorStop then
					raise e_StopRunning;
				when c_MonitorWindow then
					raise e_EndWindow;
				when c_StopJob then
					raise e_StopRunning;
				else
					null;
		end case;
	EXCEPTION
		WHEN e_StopRunning THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_CheckMonitorReturn' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CheckMonitorReturn',  b_SqlCode, b_SqlErrm,
				'Stop running',
				'None' );
			commit;
			RAISE e_StopRunning;
		WHEN e_EndWindow THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_CheckMonitorReturn' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CheckMonitorReturn',  b_SqlCode, b_SqlErrm,
				'End of Window',
				'None' );
			commit;
			RAISE e_EndWindow;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_CheckMonitorReturn' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CheckMonitorReturn',  b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Sp_CheckMonitorReturn;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_SumChunksToParts
	/*
	/* Parameters:	p_HistRec		IN OUT	purge_history_partitions%rowtype
	/*				++ Purge_History_Partitions record to get counts for
	/*
	/* Description:	This procedure will get the total counts for the partition
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	02/05/2019	Created function
	/*
	/***************************************************************************/
	PROCEDURE Sp_SumChunksToParts
	(
	p_HistRec		IN OUT	purge_history_partitions%ROWTYPE
	)
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get the total elapsed seconds
		/********************************************************************/
		select	sum(Fn_GetElapsedSecs( start_time, end_time )),
				sum(row_count)
		into	p_HistRec.tot_elapsed_secs,
				p_HistRec.nbr_rows_purged
		from	purge_history_chunks
		where	id_purge_history_partitions = p_HistRec.ID;
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SumChunksToParts for History ID ' || p_HistRec.ID || ' and table ' || p_HistRec.table_name || ' and partition ' || p_HistRec.partition_name );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SumChunksToParts', b_SqlCode, b_SqlErrm,
				'Other error',
				'ID ' || p_HistRec.ID || ' and table ' || p_HistRec.table_name || ' and partition ' || p_HistRec.partition_name );
			commit;
			RAISE;
	END Sp_SumChunksToParts;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_SumPartsToTable
	/*
	/* Parameters:	p_HistRec		IN OUT	purge_history%rowtype
	/*				++ Purge_History record to get counts for
	/*
	/* Description:	This procedure will get the total counts for the table
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/29/2019	Created function
	/*
	/***************************************************************************/
	PROCEDURE Sp_SumPartsToTable
	(
	p_HistRec		IN OUT	purge_history%ROWTYPE
	)
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get the total elapsed seconds
		/********************************************************************/
		select	sum(tot_elapsed_secs),
				sum(tot_index_secs),
				sum(tot_nbr_chunks),
				sum(nbr_rows_purged),
				sum(nbr_rows_deleted_fk+nbr_rows_deleted_child_fk+nbr_rows_deleted_grandchild_fk),
				sum(tot_elapsed_fk_secs),
				sum(nbr_subparts_dropped),
				sum(tot_elapsed_drop_secs)
		into	p_HistRec.tot_elapsed_secs,
				p_HistRec.tot_index_secs,
				p_HistRec.tot_nbr_chunks,
				p_HistRec.nbr_rows_purged,
				p_HistRec.nbr_rows_deleted_fk,
				p_HistRec.tot_elapsed_fk_secs,
				p_HistRec.nbr_subparts_dropped,
				p_HistRec.tot_elapsed_drop_secs
		from	purge_history_partitions
		where	id_purge_history = p_HistRec.ID;
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SumPartsToTable for History ID ' || p_HistRec.ID || ' and table ' || p_HistRec.table_name );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SumPartsToTable', b_SqlCode, b_SqlErrm,
				'Other error',
				'ID ' || p_HistRec.ID || ' and table ' || p_HistRec.table_name );
			commit;
			RAISE;
	END Sp_SumPartsToTable;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_RebuildIndexes
	/*
	/* Parameters:	p_TableName     IN    	VARCHAR2
	/*				++ Table to rebuild indexes for
	/*				p_PartName		IN		VARCHAR2
	/*				++ Partition name of table if building part or subpart indexes
	/*				p_Sql			IN OUT	VARCHAR2
	/*				++ Index_sql column from the history record to save the sql
	/*				p_HistId		IN		NUMBER
	/*				++ purge_history record id
	/*				p_HistPartId	IN		NUMBER
	/*				++ purge_history_partitions id
	/*				p_ExecJob		IN		CHAR
	/*				++ Flag to denote whether to run the index sql or create
	/*					a scheduler job for it
	/*
	/* Description:	This procedure will run or create a scheduler job to rebuild
	/*				all the bad indexes found for the level passed in
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/28/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_RebuildIndexes
	(
	p_TableName		IN			VARCHAR2,
	p_PartName		IN			VARCHAR2		DEFAULT NULL,
	p_Sql			IN OUT		VARCHAR2,
	p_HistId		IN			NUMBER,
	p_HistPartId	IN			NUMBER			DEFAULT NULL,
	p_ExecJob		IN			CHAR			DEFAULT c_Yes
	)
	IS
		-- Processing Variables
		v_Sql				VARCHAR2(4000)		:= NULL;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_bad_subparts
				(
				p_Table		VARCHAR2,
				p_Part		VARCHAR2
				)
		is	
			select 	p.index_name,
					p.partition_name,
					s.subpartition_name
			from 	user_indexes i,
					user_ind_partitions p,
					user_ind_subpartitions s
			where	i.table_name = p_Table
					and i.index_name = p.index_name
					and p.partition_name = p_Part
					and p.index_name = s.index_name
					and p.partition_name = s.partition_name
					and s.status != 'USABLE' ;
		cursor	c_bad_parts
				(
				p_Table		VARCHAR2,
				p_Part		VARCHAR2
				)
		is	
			select 	p.index_name,
					p.partition_name
			from 	user_indexes i,
					user_ind_partitions p
			where	i.table_name = p_Table
					and i.index_name = p.index_name
					and p.partition_name = p_Part
					and p.status not in ('N/A', 'USABLE');
		cursor	c_bad_ind
				(
				p_Table		VARCHAR2
				)
		is	
			select 	index_name
			from 	user_indexes
			where 	table_name = p_Table
					and status not in ('N/A', 'VALID');
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Add each index that needs rebuilt into the sql statement
		/********************************************************************/
		if(( p_PartName is not null) and (p_PartName != 'NON_PARTITIONED' ) ) then
			for lr in c_bad_subparts( p_TableName, p_PartName ) loop
				v_Sql := v_Sql || 'execute immediate ''alter index ' || lr.index_name ||
					' rebuild subpartition ' || lr.subpartition_name ||
					' online parallel ' || b_ParallelQueryCount || ' ''; ';
			end loop;
			for lr in c_bad_parts( p_TableName, p_PartName ) loop
				v_Sql := v_Sql || 'execute immediate ''alter index ' || lr.index_name ||
					' rebuild partition ' || lr.partition_name ||
					' online parallel ' || b_ParallelQueryCount || ' ''; ';
			end loop;
		end if;
		
		if(( p_PartName is null ) or (p_PartName = 'NON_PARTITIONED' )) then
			for lr in c_bad_ind( p_TableName ) loop
				v_Sql := v_Sql || 'execute immediate ''alter index ' || lr.index_name ||
					' rebuild ' ||
					' online parallel ' || b_ParallelQueryCount || ' ''; ';
			end loop;
		end if;
		
		/********************************************************************/
		/* Finish the sql and create the job if bad indexes were found
		/********************************************************************/
		if( v_Sql is not null ) then
			p_Sql := 'declare v_Start date := sysdate; v_Secs number := null; begin ' ||
				v_Sql || ' v_secs := ' || 'round((sysdate-v_Start) * 24 * 60 * 60 ); ' ||
				'update purge_history set tot_index_secs = ' ||
				'nvl(tot_index_secs,0) + v_Secs where id = ' || p_HistId || '; ';
				
			if( p_HistPartId is not null ) then
				p_Sql := p_Sql || 'update purge_history_partitions set tot_index_secs = ' ||
				'nvl(tot_index_secs,0) + v_Secs where id = ' || p_HistPartId || '; ';
			end if;
			
			p_Sql := p_Sql || ' end; ';
			if( p_ExecJob = c_Yes ) then
				dbms_scheduler.create_job(
					job_name	=> Fn_GetJobName( c_Index, p_TableName, p_PartName ),
					job_type	=> 'PLSQL_BLOCK',
					job_action	=> p_Sql,
					start_date	=> sysdate,
					job_class	=> b_JobClass,
					comments	=> 'Index rebuild task for Table.Part: ' || p_TableName || '.' || nvl(p_PartName,'None'),
					auto_drop	=> true,
					enabled		=> true );
			else
				execute immediate p_Sql;
			end if;
			
		end if;
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_RebuildIndexes for p_TableName: ' || p_TableName || ' | p_PartName ' || p_PartName || ' | p_HistId: ' || p_HistId || ' | p_HistPartId: ' || p_HistPartId || ' | p_Sql ' || p_Sql );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RebuildIndexes',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' | p_PartName ' || p_PartName || ' | p_HistId: ' || p_HistId || ' | p_HistPartId: ' || p_HistPartId || ' | p_Sql: ' || p_Sql );
			commit;
			RAISE;
	END Sp_RebuildIndexes;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_StopTask
	/*
	/* Parameters:	p_TaskName     IN    VARCHAR2
	/*				++ Task to stop
	/*
	/* Description:	This procedure will stop the task passed in
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/19/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_StopTask
	(
	p_TaskName	IN		VARCHAR2
	)
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Stop the task
		/********************************************************************/
		dbms_parallel_execute.stop_task( p_TaskName );
	EXCEPTION
		WHEN e_NoTask THEN
			NULL;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_StopTask for task ' || p_TaskName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_StopTask',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TaskName: ' || p_TaskName );
			commit;
			RAISE;
	END Sp_StopTask;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_StopAllTasks
	/*
	/* Parameters:	None
	/*
	/* Description:	This procedure will stop all the running tasks
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/19/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_StopAllTasks
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		CURSOR	c_tasks
		IS
				select	task_name
				from	user_parallel_execute_tasks
				where	task_name like c_TaskNamePrefix || '%'
						and status = c_Processing;
						
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Loop through all the tasks and stop them
		/********************************************************************/
		for lr in c_tasks loop
			Sp_StopTask( lr.task_name );
		end loop;
		
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_StopAllTasks ' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_StopAllTasks',  b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Sp_StopAllTasks;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_CheckWindowEndTime
	/*
	/* Parameters:	p_TableName			IN		VARCHAR2
	/*				++ Table to check end interval for
	/*				p_PartName			IN 		VARCHAR2
	/*				++ Partition to check end interval for
	/*
	/* Description:	This procedure will check if the end of the processing
	/*				window minus the maximum time recorded for the table and
	/*				partition combination has been broached.  If it has, it
	/*				will abort the purge process
	/*
	/* Notes:		If there is no data in the history tables to determine the
	/*				interval a default value from config settings will be used
	/*				This value is set at package instantiation
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_CheckWindowEndTime
	(
	p_TableName		IN		VARCHAR2,
	p_PartName		IN		VARCHAR2
	)
	IS
		-- Processing Variables
		v_ParallelCount		NUMBER				:= Fn_GetTaskParallelCount( p_TableName );
		
		-- Fetch Variables
		f_MaxMinDiff		NUMBER				:= NULL;
		f_EstEndTime		DATE				:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		if( Fn_KeepRunning ) then
		
			/****************************************************************/
			/* Determine the max amount of time to complete one partition for
			/* this table/partition combination and number of parallel
			/* If no data exists use the default value
			/****************************************************************/
			select 	nvl(round(max((end_time-start_time) * 24 * 60) * v_ParallelCount), b_DefPartMins ) as diff_min
			into	f_MaxMinDiff
			from 	purge_history_chunks
			where 	table_name = p_Tablename
					and part_name = p_PartName;
					
			/****************************************************************/
			/* If the max number of minutes is greater than the entire window
			/* use the default
			/****************************************************************/
			if( f_MaxMinDiff > (b_NbrHoursInWindow * 60) ) then
				f_MaxMinDiff := b_DefPartMins * v_ParallelCount;
			end if;
			/****************************************************************/
			/* Add the max minute difference to sysdate to get estimated
			/* finish
			/****************************************************************/
			f_EstEndTime := sysdate + numtodsinterval( f_MaxMinDiff, 'MINUTE' );
			/****************************************************************/
			/* If the estimated time for a chunk to complete exceeds the purge
			/* window raise an error to abort the purge processing
			/****************************************************************/
			if( f_EstEndTime > b_WindowEnd ) then
				RAISE e_EndWindow;
			end if;
		else
			raise e_StopRunning;
		end if; -- Fn_KeepRunning
		
	EXCEPTION
		WHEN e_EndWindow THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CheckWindowEndTime',  b_SqlCode, b_SqlErrm,
				'Estimated end time surpasses the end of the window',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | f_EstEndTime: ' || to_char(f_EstEndTime, 'mm/dd/yyyy hh24:mi:ss') || ' | b_WindowEnd: ' || to_char(b_WindowEnd, 'mm/dd/yyyy hh24:mi:ss' ) );
			commit;
			RAISE e_EndWindow;
		WHEN e_StopRunning THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CheckWindowEndTime',  b_SqlCode, b_SqlErrm,
				'Stop running set, exiting',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | f_EstEndTime: ' || to_char(f_EstEndTime, 'mm/dd/yyyy hh24:mi:ss') || ' | b_WindowEnd: ' || to_char(b_WindowEnd, 'mm/dd/yyyy hh24:mi:ss' ) );
			commit;
			RAISE e_StopRunning;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_CheckWindowEndTime for table ' || p_TableName || ' and partition ' || p_PartName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CheckWindowEndTime',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
			RAISE;
	END Sp_CheckWindowEndTime;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_CreateTask
	/*
	/* Parameters:	p_Taskname           IN    VARCHAR2
	/*				++ Name of task to create
	/*
	/* Description:	This procedure create a dbms_parallel task
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_CreateTask
	(
	p_TaskName	IN		VARCHAR2
	)
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Create the task
		/********************************************************************/
		dbms_parallel_execute.create_task( p_TaskName );
	EXCEPTION
		WHEN e_DupTask THEN
			dbms_parallel_execute.drop_task( p_TaskName );
			dbms_parallel_execute.create_task( p_TaskName );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CreateTask',  b_SqlCode, b_SqlErrm,
				'Task exists, drop and create it',
				'p_TaskName: ' || p_TaskName );
			commit;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_CreateTask for ' || p_TaskName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CreateTask',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TaskName: ' || p_TaskName );
			commit;
			RAISE;
	END Sp_CreateTask;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_ChunkTask
	/*
	/* Parameters:	p_Taskname           IN    VARCHAR2
	/*				++ Name of task to create
	/*				p_Sql				IN		VARCHAR2
	/*				++ Sql to chunk with
	/*
	/* Description:	This procedure will take the passed sql and chunk it and
	/*				associate it with the passed in task
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_ChunkTask
	(
	p_TaskName	IN		VARCHAR2,
	p_Sql		IN		VARCHAR2
	)
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Chunk the task
		/********************************************************************/
		dbms_parallel_execute.create_chunks_by_sql(
			task_name 	=> p_TaskName,
			sql_stmt  	=> p_Sql,
			by_rowid  	=> FALSE );
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_ChunkTask for ' || p_TaskName );
			DBMS_OUTPUT.PUT_LINE( 'Chunk Sql: ' || p_Sql );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_ChunkTask',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TaskName: ' || p_TaskName || ' | p_Sql: ' || p_Sql );
			commit;
			RAISE;
	END Sp_ChunkTask;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_ExecuteTask
	/*
	/* Parameters:	p_Taskname      IN    	VARCHAR2
	/*				++ Name of task to create
	/*				p_Sql			IN		VARCHAR2
	/*				++ Sql to execute with
	/*				p_TableName		IN		VARCHAR2
	/*				++ Used to get the parallel count for the task
	/*
	/* Description:	This procedure will execute the task and start purging data
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_ExecuteTask
	(
	p_TaskName	IN		VARCHAR2,
	p_Sql		IN		VARCHAR2,
	p_TableName	IN		VARCHAR2
	)
	IS
		-- Processing Variables
		v_ParallelCount				NUMBER			:= Fn_GetTaskParallelCount( p_TableName );
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Execute the task
		/********************************************************************/
		dbms_parallel_execute.run_task(
			task_name 		=> p_TaskName,
			sql_stmt 		=> p_Sql,
			language_flag 	=> DBMS_SQL.NATIVE,
			parallel_level 	=> v_ParallelCount,
			job_class		=> b_JobClass );
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_ExecuteTask for ' || p_TaskName || ', table name: ' || p_TableName || ' with parallel of ' || v_ParallelCount );
			DBMS_OUTPUT.PUT_LINE( 'Task Sql: ' || p_Sql );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_ExecuteTask',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TaskName: ' || p_TaskName || ' | p_Sql: ' || p_Sql || ' | p_TableName: ' || p_TableName || ' | v_ParallelCount: ' || v_ParallelCount );
			commit;
			RAISE;
	END Sp_ExecuteTask;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_CreateMonitorJob
	/*
	/* Parameters:	p_Taskname          IN    	VARCHAR2
	/*				++ Name of task to create monitor job for
	/* 				p_TableName			IN OUT	VARCHAR2
	/*				++ Table being purged
	/*				p_PartName			IN OUT	VARCHAR2
	/*				++ Tables partition being purged
	/*
	/* Description:	This procedure will create a scheduler job to monitor a
	/*				task and restart it up to configuration times if needed and
	/*				stop the job at the end of the window
	/*
	/* Notes:		If the task completes successfully in the window this job
	/*				will do nothing
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/22/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_CreateMonitorJob
	(
	p_TaskName		IN OUT	VARCHAR2,
	p_TableName	IN OUT	VARCHAR2,
	p_PartName		IN OUT	VARCHAR2
	)
	IS
		-- Processing Variables
		v_Sql				VARCHAR2(4000)				:= NULL;
		v_JobName			VARCHAR2(50)				:= Fn_GetJobName( c_Monitor, p_TableName, p_PartName );
		
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Create the job sql
		/********************************************************************/
		v_Sql := 'begin dbms_lock.sleep(' || b_SleepTime || '); ' ||
			'Pkg_SBMO_Purge.Sp_MonitorTask( ' ||
			'''' || p_TaskName || ''',''' || p_TableName ||
			''',''' || p_PartName || ''' ); ' ||
			'end; ';
			
		/********************************************************************/
		/* Create the job
		/********************************************************************/
		dbms_scheduler.create_job(
			job_name	=> v_JobName,
			job_type	=> 'PLSQL_BLOCK',
			job_action	=> v_Sql,
			start_date	=> sysdate,
			job_class	=> b_JobClass,
			comments	=> 'Monitor parallel exeute task for ' || p_TaskName || ' Table.Part: ' || p_TableName || '.' || p_PartName,
			auto_drop	=> true,
			enabled		=> true );
	EXCEPTION
		WHEN e_JobExists THEN
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CreateMonitorJob',  -25000, 'ORA-25000 Drop and recreate monitor job, ' || v_JobName,
				'JObExists',
				'p_TaskName: ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' v_Sql: ' || v_Sql );
			commit;
			dbms_scheduler.drop_job( job_name => v_JobName, force => TRUE );
			dbms_lock.sleep(10);
			Sp_CreateMonitorJob( 	p_TaskName, p_TableName, p_PartName );
		WHEN e_BadJobType THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CreateMonitorJob',  b_SqlCode, b_SqlErrm,
				'Bad job type',
				'p_TaskName: ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' v_Sql: ' || v_Sql );
			commit;
			RAISE e_BadJobType;
			
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_CreateMonitorJob for ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			DBMS_OUTPUT.PUT_LINE( 'Task Sql: ' || v_Sql );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CreateMonitorJob',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TaskName: ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' v_Sql: ' || v_Sql );
			commit;
			RAISE;
	END Sp_CreateMonitorJob;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_DeleteFKs
	/*
	/* Parameters:	p_Hist			IN 		VARCHAR2
	/*				++ purge_history_partitions record with table info
	/*				p_PurgeDate		IN		DATE
	/*				++ Date to purge from
	/*				p_Tenant		IN		NUMBER
	/*				++ Tenant id
	/*				
	/* Description:	This procedure will delete all the rows from the table
	/*				that are associated with a parent record that is also
	/*				going to be purged
	/*
	/* Notes:		If child records are found delete up to two level below
	/*				the current table
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/27/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_DeleteFKs
	(
	p_Hist			IN OUT	purge_history_partitions%ROWTYPE,
	p_PurgeDate		IN		DATE,
	p_Tenant		IN		NUMBER
	)
	IS
		-- Processing Variables
		v_DelSql			VARCHAR2(4000)				:= NULL;
		v_ChildSql			VARCHAR2(4000)				:= NULL;
		v_GrandChildSql		VARCHAR2(4000)				:= NULL;
		v_PurgeColumn		VARCHAR2(30)				:= NULL;
		v_PartName			VARCHAR2(30)				:= p_Hist.partition_name;
		v_StartDate			DATE						:= NULL;
		v_part_clause	    VARCHAR2(4000)				:= NULL;
				
		-- Fetch Variables
		f_Count				NUMBER						:= NULL;
		
		-- Exception Variables
		-- Cursors
		cursor	c_Fks
				(
				p_Table		VARCHAR2
				)
		is
				select  c.constraint_name,
						c.r_constraint_name ,
						f.table_name
				from    user_constraints c,
						user_constraints f,
						purge_tables p
				where   c.table_name = p_Table
						and c.constraint_type = 'R'
						and c.r_constraint_name = f.constraint_name
						and f.table_name = p.table_name;
		cursor	c_Childfks
				(
				p_Table		VARCHAR2
				)
		is
select  c.constraint_name,
c.r_constraint_name ,
c.table_name,
						t.partitioned
from    user_constraints c,
user_constraints f,
purge_tables p,
						user_tables t
where   f.table_name = p_Table
				        and c.table_name = t.table_name
and f.constraint_type = 'P'
and f.constraint_name = c.r_constraint_name
and c.table_name = p.table_name;
		cursor	c_GrandChildfks
				(
				p_Table		VARCHAR2
				)
		is
select  c.constraint_name,
c.r_constraint_name ,
c.table_name,
						t.partitioned
from    user_constraints c,
user_constraints f,
purge_tables p,
						user_tables t
where   f.table_name = p_Table
				        and c.table_name = t.table_name
and f.constraint_type = 'P'
and f.constraint_name = c.r_constraint_name
and c.table_name = p.table_name;
						-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Ensure the history sql columns are empty
		/********************************************************************/
		p_Hist.fk_sql := null;
		p_Hist.child_fk_sql := null;
	
		/********************************************************************/
		/* Loop through all the foreign keys
		/********************************************************************/
		for lr in c_Fks( p_Hist.table_name ) loop
			/****************************************************************/
			/* Make sure we have time to start purging the delete
			/****************************************************************/
			Sp_CheckWindowEndTime( p_Hist.table_name, p_Hist.partition_name );
			/****************************************************************/
			/* Get the purge column and months to keep for the parent table
			/****************************************************************/
			v_PurgeColumn := Fn_GetPurgeColumn( lr.table_name );
			/****************************************************************/
			/* Check if the partition exists in the parent table, if not use
			/* the other partition
			/****************************************************************/
	       -- Medha : Check if table is partitioned or not, if not , then set partition_name to 'NON_PARTITIONED'
		   if ( p_Hist.partition_name = 'NON_PARTITIONED' ) then
				v_PartName := 'NON_PARTITIONED';
		   else
			select	count(*)
			into	f_Count
			from	user_tab_partitions
			where	table_name = lr.table_name
					and partition_name = p_Hist.partition_name;
					
			if( f_Count = 0 ) then
				v_PartName := 'OTHER';
			end if;
			
		   end if;
					
			/****************************************************************/
			/* Generate the sql to delete any records associated with the
			/* parent records that will be purged
			/****************************************************************/
			-- Medha : Dynamically Generate Partition Clause
			if (v_PartName = 'NON_PARTITIONED') then
			 v_part_clause := null;
			
			else
			 v_part_clause := ' partition ( ' || v_PartName || ' ) ' ;
			end if;
			v_DelSql := 'delete /*+ parallel (d,' || b_ParallelQueryCount || ') */ ' ||
					'from ' || p_Hist.table_name ||  v_part_clause || ' d ' ||
					' where (' || Fn_GetConsColumns( p_Hist.table_name, lr.constraint_name ) || ') in ' ||
							'( ' ||
							'select /*+ parallel(t,' || b_ParallelQueryCount || ') */ ' ||
								Fn_GetConsColumns( p_Hist.table_name, lr.constraint_name ) || ' ' ||
							'from ' || p_Hist.table_name || v_part_clause || ' t ' ||
							' where (' || Fn_GetConsColumns( p_Hist.table_name, lr.constraint_name ) || ') in ' ||
								'( ' ||
								'select  /*+ parallel(r,' || b_ParallelQueryCount || ') */ ' ||
									Fn_GetConsColumns( lr.table_name, lr.r_constraint_name ) || ' ' ||
								'from ' || lr.table_name || v_part_clause || ' r ';
			if( p_Tenant is NULL ) then
				v_DelSql := v_DelSql || ' where ' || v_PurgeColumn || ' < ';
			else
				v_DelSql := v_DelSql || ' where tenant_id = ' || p_Tenant || ' and ' || v_PurgeColumn || ' < ';
			end if;
			v_DelSql := v_DelSql ||	'to_date(''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss') || ''', ''mm/dd/yyyy hh24:mi:ss'') ' ||
								') ' ||
							') ';
			p_Hist.fk_sql := p_Hist.fk_sql || ' ' || v_DelSql;
			
			/****************************************************************/
			/* Delete the rows and set the number of deleted rows
			/****************************************************************/
dbms_output.put_line ('Inside spdelete - v_DelSql : ' || v_DelSql);
			execute immediate 'alter session set db_file_multiblock_read_count=' || b_MultiBlock;
			v_StartDate := sysdate;
			begin
				execute immediate v_Delsql;
			exception
				/************************************************************/
				/* If child rows are found delete the rows for all child
				/* tables and set the number of deleted rows then try again
				/************************************************************/
				when e_ChildRecFound then
				
				dbms_output.put_line ('Debug : Inside e_ChildRecFound exception ');
				
						for lr1 in c_ChildFks( p_Hist.table_name ) loop
						dbms_output.put_line ('Debug : Inside c_ChildFks loppop ');
						
						if (lr1.PARTITIONED = 'YES') then
						     v_part_clause :=  ' partition (' || v_PartName || ') ';
						else
						      v_part_clause :=  null;
						end if;
							v_ChildSql := 'delete /*+ parallel (d,' || b_ParallelQueryCount || ') */ ' ||
											'from ' || lr1.table_name || v_part_clause || ' d ' ||
											' where (' || Fn_GetConsColumns( lr1.table_name, lr1.constraint_name ) || ') in ' ||
													'( ' ||
													'select /*+ parallel(t,' || b_ParallelQueryCount || ') */ ' ||
															Fn_GetConsColumns( p_Hist.table_name, lr1.r_constraint_name ) || ' ' ||
													'from ' || p_Hist.table_name || v_part_clause ||  ' t ' ||
													' where (' || Fn_GetConsColumns( p_Hist.table_name, lr.constraint_name ) || ') in ' ||
															'( ' ||
															'select	/*+ parallel(r,' || b_ParallelQueryCount || ') */ ' ||
																Fn_GetConsColumns( lr.table_name, lr.r_constraint_name ) || ' ' ||
															'from ' || lr.table_name || v_part_clause || ' r ';
dbms_output.put_line ('Inside spdelete 2 - v_ChildSql : ' || v_ChildSql);
							if( p_Tenant is NULL ) then
								v_ChildSql := v_ChildSql || ' where ' || v_PurgeColumn || ' < ';
							else
								v_ChildSql := v_ChildSql || ' where tenant_id = ' || p_Tenant || ' and ' || v_PurgeColumn || ' < ';
							end if;
							v_ChildSql := v_ChildSql || 'to_date(''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss') || ''', ''mm/dd/yyyy hh24:mi:ss'') ' ||
											') ' ||
										') ';
							p_Hist.child_fk_sql := p_Hist.child_fk_sql || ' ' || v_ChildSql;
							begin
								execute immediate v_ChildSql;
							exception						
								/********************************************/
								/* If child rows are found delete the rows
								/* for all grandchild tables and set the
								/* number of deleted rows then try again
								/********************************************/
								when e_ChildRecFound then
									for lr2 in c_GrandChildfks( lr1.table_name ) loop	
									  if ( lr2.partitioned = 'YES') then
						                v_part_clause :=  ' partition (' || v_PartName || ') ';
						              else
						                 v_part_clause  :=  null;
						              end if;
										v_GrandChildSql := 'delete /*+ parallel (d,' || b_ParallelQueryCount || ') */ ' ||
												'from ' || lr2.table_name || v_part_clause || ' d ' ||
												' where (' || Fn_GetConsColumns( lr2.table_name, lr2.constraint_name ) || ') in ' ||
													'( ' ||
													'select /*+ parallel(c,' || b_ParallelQueryCount || ') */ ' ||
														Fn_GetConsColumns( lr1.table_name, lr2.r_constraint_name ) || ' ' ||
													'from ' || lr1.table_name || v_part_clause || ' c ' ||
													' where (' || Fn_GetConsColumns( lr1.table_name, lr1.constraint_name ) || ') in ' ||
														'( ' ||
														'select /*+ parallel(t,' || b_ParallelQueryCount || ') */ ' ||
															Fn_GetConsColumns( p_Hist.table_name, lr1.r_constraint_name ) || ' ' ||
														'from ' || p_Hist.table_name || v_part_clause || ' t ' ||
														' where (' || Fn_GetConsColumns( p_Hist.table_name, lr.constraint_name ) || ') in ' ||
															'( ' ||
															'select /*+ parallel(r,' || b_ParallelQueryCount || ') */ ' ||
																Fn_GetConsColumns( lr.table_name, lr.r_constraint_name ) || ' ' ||
															'from ' || lr.table_name || v_part_clause || ' r ';
											dbms_output.put_line ('Inside spdelete 3  - v_GrandChildSql : ' || v_GrandChildSql);
										if( p_Tenant is NULL ) then
											v_GrandChildSql := v_GrandChildSql || ' where ' || v_PurgeColumn || ' < ';
										else
											v_GrandChildSql := v_GrandChildSql || ' where tenant_id = ' || p_Tenant || ' and ' || v_PurgeColumn || ' < ';
										end if;
										v_GrandChildSql := v_GrandChildSql ||	'to_date(''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss') || ''', ''mm/dd/yyyy hh24:mi:ss'') ' ||
															') ' ||
														') ' ||
													') ';
										p_Hist.grandchild_fk_sql := p_Hist.grandchild_fk_sql || ' ' || v_GrandChildSql;
										execute immediate v_GrandChildSql;
										p_Hist.nbr_rows_deleted_grandchild_fk := nvl(p_Hist.nbr_rows_deleted_grandchild_fk,0) + sql%ROWCOUNT;
									end loop;
									
									execute immediate v_ChildSql;
							end;
							p_Hist.nbr_rows_deleted_child_fk := nvl(p_Hist.nbr_rows_deleted_child_fk,0) + sql%ROWCOUNT;
						end loop;
					execute immediate v_Delsql;
			end;
			p_Hist.nbr_rows_deleted_fk := nvl(p_Hist.nbr_rows_deleted_fk,0) + sql%ROWCOUNT;
			execute immediate 'alter session set db_file_multiblock_read_count=' || b_OrigMultiBlock;
			p_Hist.tot_elapsed_fk_secs := nvl(p_Hist.tot_elapsed_fk_secs,0) + Fn_GetElapsedSecs( v_StartDate, SYSDATE );
			commit;
		end loop; -- for lr in c_Fks
	EXCEPTION
		WHEN e_EndWindow THEN
			raise e_FkDelete;
		WHEN e_StopRunning THEN
			raise e_FkDelete;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_DeleteFKs for Table: ' || p_hist.table_name || ' Partition: ' || p_Hist.partition_name );
			DBMS_OUTPUT.PUT_LINE( 'Delete Sql: ' || substr(p_Hist.fk_sql, 1, 3975) );
			DBMS_OUTPUT.PUT_LINE( 'Delete Child Sql: ' || substr(p_Hist.child_fk_sql, 1, 3975) );
			DBMS_OUTPUT.PUT_LINE( 'Delete GrandChild Sql: ' || substr(p_Hist.grandchild_fk_sql, 1, 3975)  );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_DeleteFKs',  b_SqlCode, b_SqlErrm,
				'Other error',
				substr( 'TableName: ' || p_Hist.table_name || ' | PartName: ' || p_Hist.partition_name || ' | fk_sql: ' || p_Hist.fk_sql || ' | child_fk_sql: ' || p_hist.child_fk_sql || ' | grandchild_fk_sql: ' || p_hist.grandchild_fk_sql, 1, 4000) );
			commit;
			RAISE;
	END Sp_DeleteFKs;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_DropSubpartitions
	/*
	/* Parameters:	p_HistRec			IN OUT	purge_history_partitions%ROWTYPE
	/*				++ History record with table and partition to drop for
	/*				p_PurgeDate			IN		DATE
	/*				++ Highest date to purge
	/*
	/* Description:	This procedure will delete all subpartitions in the table
	/*				and partition starting from the bottom that are empty
	/*
	/* Notes:		Once a non-empty partition is found, stop
	/*				If the partition high value date is greater than purge
	/*				date, stop
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/29/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_DropSubpartitions
	(
	p_HistRec		IN OUT		purge_history_partitions%ROWTYPE,
	p_PurgeDate		IN			DATE
	)
	IS
		-- Processing Variables
		v_Sql				VARCHAR2(4000)				:= NULL;
		v_StartDate			DATE						:= NULL;
		v_TestDate			DATE						:= NULL;
		v_PurgeDate			DATE						:= NULL;
		
		-- Fetch Variables
		f_Id				NUMBER						:= NULL;
		
		-- Exception Variables
		-- Cursors
		cursor	c_Subs
				(
				p_Table		VARCHAR2,
				p_Part		VARCHAR2
				)
		is
				select 	subpartition_name,
					high_value,
					subpartition_position
				from 	user_tab_subpartitions
				where 	table_name = p_Table
					and partition_name = p_Part
					and subpartition_position <
					(
					--Ensure we leave one subpartition and the default
					select	max(subpartition_position)-1
					from	user_tab_subpartitions
					where 	table_name = p_Table
						and partition_name = p_Part
					)
				and subpartition_name not like '%1900%'  -- Exclude partition with high_value 1900-02-01
				order by subpartition_position;
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Make sure we have time to start dropping the subpartitions
		/********************************************************************/
		Sp_CheckWindowEndTime( p_HistRec.table_name, p_HistRec.partition_name );
		/********************************************************************/
		/* Loop through all the subpartitions
		/********************************************************************/
		for lr in c_Subs( p_HistRec.table_name, p_HistRec.partition_name ) loop
			/****************************************************************/
			/* Make sure we have time to start dropping the subpartitions
			/* Check again after every 2 subpartition drops
			/****************************************************************/
			if( mod( c_Subs%ROWCOUNT, 2 ) = 0 ) then
				Sp_CheckWindowEndTime( p_HistRec.table_name, p_HistRec.partition_name );
			end if;
			
			/****************************************************************/
			/* Turn the high value into a date variable
			/****************************************************************/
			v_TestDate := to_date( substr(lr.high_value,instr(lr.high_value,'2'),19), 'yyyy-mm-dd hh24:mi:ss' );
			/****************************************************************/
			/* If the partition is newer than the purge date exit, else
			/* Check if the subpartition has any data
			/* If the subpartition is empty, drop it
			/****************************************************************/
			if( v_TestDate > p_PurgeDate ) then
				raise e_PartitionIsNewer;
			else
				v_Sql := 'Select id from ' || p_HistRec.table_name || ' SUBPARTITION (' || lr.subpartition_name || ') fetch first 1 row only ';
			
				begin
					execute immediate v_Sql into f_Id;
					raise e_DataFound;
				exception
					when no_data_found then
						v_Sql := 'alter table ' || p_HistRec.table_name || ' drop subpartition ' || lr.subpartition_name || ' ';
						execute immediate 'alter session set optimizer_mode = ' || b_SubpartOptMode || ' ';
						v_StartDate := sysdate;
						execute immediate v_Sql;
						execute immediate 'alter session set optimizer_mode = ' || b_OrigOptimizerMode || ' ';
						p_HistRec.nbr_subparts_dropped := nvl(p_HistRec.nbr_subparts_dropped,0) + 1;
						p_HistRec.tot_elapsed_drop_secs := nvl(p_HistRec.tot_elapsed_drop_secs,0) + Fn_GetElapsedSecs( v_StartDate, SYSDATE );
						commit;
				end;
			end if;
		end loop; -- for lr in c_Subs
		
	EXCEPTION
		WHEN e_EndWindow THEN
			raise e_SubpartDrop;
		WHEN e_StopRunning THEN
			raise e_SubpartDrop;
		WHEN e_PartitionIsNewer THEN
			null;
		WHEN e_DataFound THEN
			null;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_DropSubpartitions for Table: ' || p_HistRec.table_name || ' Partition: ' || p_HistRec.partition_name );
			DBMS_OUTPUT.PUT_LINE( 'v_Sql: ' || v_Sql );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_DropSubpartitions',  b_SqlCode, b_SqlErrm,
				'Other error',
				'TableName: ' || p_HistRec.table_name || ' PartName: ' || p_HistRec.partition_name || ' | v_Sql ' || v_Sql );
			commit;
			RAISE;
	END Sp_DropSubpartitions;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_PurgePartition
	/*
	/* Parameters:	p_TableName			IN OUT	VARCHAR2
	/*				++ Table to purge
	/*				p_PartName			IN OUT	VARCHAR2
	/*				++ Tables partition to purge
	/*				p_PurgeColumn		IN OUT	VARCHAR2
	/*				++ Date column used to purge with
	/*				p_HistId			IN		NUMBER
	/*				++ Purge history record id for the table passed in
	/*				p_PurgeDate			IN OUT	DATE
	/*				++ Date used as the base for the data deletes
	/*
	/* Description:	This procedure will purge the table/partition passed in
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name			Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_PurgePartition
	(
	p_TableName		IN OUT	VARCHAR2,
	p_PartName		IN OUT	VARCHAR2,
	p_PurgeColumn	IN OUT	VARCHAR2,
	p_HistId		IN		NUMBER,
	p_PurgeDate		IN OUT	DATE
	)
	IS
		-- Processing Variables
		v_TaskName			VARCHAR2(30)		:= NULL;
		v_Tenant			NUMBER				:= NULL;
		v_Status			NUMBER				:= NULL;
		v_HistoryRec		PURGE_HISTORY_PARTITIONS%ROWTYPE	:= NULL;
		
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Make sure we have time to start purging the partition
		/********************************************************************/
		dbms_output.put_line ( 'DEBUG - Sp_PurgePartition - Begins ' );
		
		Sp_CheckWindowEndTime( p_TableName, p_PartName );
		Sp_RebuildIndexes( p_TableName, p_PartName, v_HistoryRec.index_sql, p_HistId, v_HistoryRec.ID, c_No );
		/********************************************************************/
		/* Get the tenant_id associated with the partition
		/********************************************************************/
--Medha : This is needed only incase table is partitioned
	    dbms_output.put_line('DEBUG Sp_PurgePartition p_TableName - ' || p_TableName || ', p_PartName - ' || p_PartName );	
	    if ((p_PartName = 'NON_PARTITIONED') OR (p_PartName IS NULL )) then
		 v_Tenant := null ;
		else
		 v_Tenant := Fn_GetTenantId( p_TableName, p_partName );
		end if;
		
		/********************************************************************/
		/* Create the task
		/********************************************************************/
		v_TaskName := Fn_GetTaskName( p_TableName, p_PartName );
		Sp_CreateTask( v_TaskName );
		/********************************************************************/
		/* Populate the initial history record values
		/********************************************************************/
		v_HistoryRec.ID := purge_seq.nextval;
		v_HistoryRec.ID_PURGE_HISTORY := p_HistId;
		v_HistoryRec.TABLE_NAME := p_TableName;
		v_HistoryRec.PARTITION_NAME := p_PartName;
		v_HistoryRec.TASK_NAME := v_TaskName;
		v_HistoryRec.START_DATE := SYSDATE;
		v_HistoryRec.STATUS := c_Begin;
		insert into purge_history_partitions values v_HistoryRec;
		commit;
		/********************************************************************/
		/* Chunk the task and set the status
		/* Set the multiblock parameter to help speed up the I/O
		/********************************************************************/
		v_HistoryRec.chunk_sql := Fn_GetChunkSql( p_TableName, p_PartName, p_PurgeColumn, p_PurgeDate, v_Tenant );
		execute immediate 'alter session set db_file_multiblock_read_count=' || b_MultiBlock;
		Sp_ChunkTask( v_TaskName, v_HistoryRec.chunk_sql );
		execute immediate 'alter session set db_file_multiblock_read_count=' || b_OrigMultiBlock;
		v_Status := dbms_parallel_execute.task_status( v_TaskName );
		/********************************************************************/
		/* If there are no chunks do not process further for the partition
		/********************************************************************/
		if( v_Status = dbms_parallel_execute.no_chunks ) then
			v_HistoryRec.TOT_NBR_CHUNKS := 0;
			v_HistoryRec.NBR_ROWS_PURGED := 0;
			v_HistoryRec.END_DATE := SYSDATE;
		else
		
			/****************************************************************/
			/* Set the number of chunks and ensure we have time to start
			/* the partition purge
			/****************************************************************/
			v_HistoryRec.TOT_NBR_CHUNKS := Fn_GetChunkCount( v_TaskName );
			Sp_CheckWindowEndTime( p_TableName, p_PartName );
			/****************************************************************/
			/* Create the monitor job and send the task to be executed
			/****************************************************************/
			v_HistoryRec.task_sql := Fn_GetTaskSql( v_TaskName, p_TableName, p_PartName, p_PurgeColumn, p_PurgeDate, v_HistoryRec.ID, v_Tenant );
			Sp_CreateMonitorJob( v_TaskName, p_TableName, p_PartName );
			Sp_ExecuteTask( v_TaskName, v_HistoryRec.task_sql, p_TableName );
			v_Status := dbms_parallel_execute.task_status( v_TaskName );
			/****************************************************************/
			/* Determine if the monitor stopped the job, else check the status
			/****************************************************************/
			Sp_CheckMonitorReturn;
			if( v_Status = dbms_parallel_execute.crashed ) then
				raise e_EndWindow;
			elsif( v_Status = dbms_parallel_execute.finished_with_error ) then
				raise e_FinishedErrors;
			elsif( v_Status <> dbms_parallel_execute.finished ) then
				raise e_FailedTask;
			end if;
			
		end if;		-- If no_chunks
		
		/********************************************************************/
		/* Delete rows that are not eligible for purge for parent records
		/* that will be purged
		/********************************************************************/
dbms_output.put_line( 'EHS: Calling Sp_DeleteFKs - v_HistoryRec.id- '  || v_HistoryRec.id || 'p_TableName' || p_TableName );
		Sp_DeleteFKs( v_HistoryRec, p_PurgeDate, v_Tenant );
		Sp_RebuildIndexes( p_TableName, p_PartName, v_HistoryRec.index_sql, p_HistId, v_HistoryRec.ID );
		Sp_DropSubpartitions( v_HistoryRec, p_PurgeDate );
		/********************************************************************/
		/* Complete the history record and insert it
		/********************************************************************/
		v_HistoryRec.STATUS := Fn_StatusNbrToChar( v_Status );
		Sp_SumChunksToParts( v_HistoryRec );
		v_HistoryRec.END_DATE := SYSDATE;
		dbms_parallel_execute.drop_task( v_TaskName );
		update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
		commit;
	EXCEPTION
		WHEN e_SubPartDrop THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_PurgePartition: Window ended for table ' || p_TableName || ' and partition ' || p_PartName || ' and tenant id ' || nvl(v_Tenant, -1) );
			v_HistoryRec.STATUS := c_SubPartDrop;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgePartition',  b_SqlCode, b_SqlErrm,
				'End of window while deleting Subpartitions',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_PurgeColumn: ' || p_PurgeColumn || ' | p_HistId: ' || p_HistId || ' | p_PurgeDate: ' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ' and tenant id ' || nvl(v_Tenant, -1) );
			commit;
			RAISE e_SubPartDrop;
		WHEN e_FkDelete THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_PurgePartition: Window ended for table ' || p_TableName || ' and partition ' || p_PartName || ' and tenant id ' || nvl(v_Tenant, -1) );
			v_HistoryRec.STATUS := c_FkDelete;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgePartition',  b_SqlCode, b_SqlErrm,
				'End of window while deleting FKs',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_PurgeColumn: ' || p_PurgeColumn || ' | p_HistId: ' || p_HistId || ' | p_PurgeDate: ' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ' and tenant id ' || nvl(v_Tenant, -1) );
			commit;
			RAISE e_FkDelete;
		WHEN e_EndWindow THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_PurgePartition: Window ended for table ' || p_TableName || ' and partition ' || p_PartName || ' and tenant id ' || nvl(v_Tenant, -1) );
			v_HistoryRec.STATUS := c_Stopped;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgePartition',  b_SqlCode, b_SqlErrm,
				'End of window',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_PurgeColumn: ' || p_PurgeColumn || ' | p_HistId: ' || p_HistId || ' | p_PurgeDate: ' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ' and tenant id ' || nvl(v_Tenant, -1) );
			commit;
			RAISE e_EndWindow;
		WHEN e_StopRunning THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_PurgePartition: Stop run requested ' || p_TableName || ' and partition ' || p_PartName || ' and tenant id ' || nvl(v_Tenant, -1) );
			v_HistoryRec.STATUS := c_Stopped;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgePartition',  b_SqlCode, b_SqlErrm,
				'Stop run requested',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_PurgeColumn: ' || p_PurgeColumn || ' | p_HistId: ' || p_HistId || ' | p_PurgeDate: ' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ' and tenant id ' || nvl(v_Tenant, -1) );
			commit;
			RAISE e_StopRunning;
		WHEN e_FinishedErrors THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			v_HistoryRec.STATUS := Fn_StatusNbrToChar( v_Status );
			Sp_SumChunksToParts( v_HistoryRec );
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_PurgePartition task finished with errors ' || p_TableName || ' and partition ' || p_PartName || ' with status ' || v_HistoryRec.STATUS  || ' and tenant id ' || nvl(v_Tenant, -1));
			DBMS_OUTPUT.PUT_LINE( '   select * from table(pkg_sbmo_purge.fn_showerrors(' || b_ErrDate || ')); ' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgePartition',  b_SqlCode, b_SqlErrm,
				'Task finished with errors',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_PurgeColumn: ' || p_PurgeColumn || ' | p_HistId: ' || p_HistId || ' | p_PurgeDate: ' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ' and tenant id ' || nvl(v_Tenant, -1) );
			commit;
			RAISE e_FinishedErrors;
		WHEN e_FailedTask THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			v_HistoryRec.STATUS := Fn_StatusNbrToChar( v_Status );
			Sp_SumChunksToParts( v_HistoryRec );
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_PurgePartition task failed for ' || p_TableName || ' and partition ' || p_PartName || ' with status ' || v_HistoryRec.STATUS || ' and tenant id ' || nvl(v_Tenant, -1) );
			DBMS_OUTPUT.PUT_LINE( '   select * from table(pkg_sbmo_purge.fn_showerrors(' || b_ErrDate || ')); ' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgePartition',  b_SqlCode, b_SqlErrm,
				'Task failed with status ' || v_HistoryRec.STATUS,
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_PurgeColumn: ' || p_PurgeColumn || ' | p_HistId: ' || p_HistId || ' | p_PurgeDate: ' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ' and tenant id ' || nvl(v_Tenant, -1) );
			commit;
			RAISE e_FailedTask;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_PurgePartition for table ' || p_TableName || ' and partition ' || p_PartName || ' and tenant id ' || nvl(v_Tenant, -1) );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			v_HistoryRec.STATUS := c_Failed;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgePartition',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_PurgeColumn: ' || p_PurgeColumn || ' | p_HistId: ' || p_HistId || ' | p_PurgeDate: ' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ' and tenant id ' || nvl(v_Tenant, -1) );
			commit;
			RAISE;
	END Sp_PurgePartition;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_RestartPurgePartition
	/*
	/* Parameters:	p_HistId			IN		NUMBER
	/*				++ Purge history record id for the table passed in
	/*				p_PurgeDate			IN OUT	DATE
	/*				++ Original purge date
	/*
	/* Description:	This procedure will restart the purge that was previously
	/*				stopped
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name			Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/23/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_RestartPurgePartition
	(
	p_HistId		IN		NUMBER,
	p_PurgeDate		IN OUT	DATE
	)
	IS
		-- Processing Variables
		v_ResumeDate		DATE								:= SYSDATE;
		v_Status			NUMBER								:= NULL;
		v_HistoryRec		PURGE_HISTORY_PARTITIONS%ROWTYPE	:= NULL;
		v_PurgeColumn		VARCHAR2(30)						:= NULL;
		v_Tenant			NUMBER								:= NULL;
		
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the history record for the partition to restart
		/* If no data found the purge was stopped at a new partition in
		/* Sp_PurgePartition before the record was inserted so there is
		/* nothing to do
		/********************************************************************/
		begin
			v_HistoryRec := Fn_GetLatestHistoryPartitions( p_HistId );
		exception
			when no_data_found then
				raise e_NoPartitionToRestart;
		end;
		Sp_RebuildIndexes( v_HistoryRec.table_name, v_HistoryRec.partition_name, v_HistoryRec.index_sql, p_HistId, v_HistoryRec.ID, c_No );
		Sp_CheckWindowEndTime( v_HistoryRec.table_name, v_HistoryRec.partition_name );
		v_PurgeColumn := Fn_GetPurgeColumn( v_HistoryRec.table_name );
		/********************************************************************/
		/* If the status is foreign key deletes the task already completed
		/* and all we need to do is finish deleting the foreign keys
		/********************************************************************/
		if( v_HistoryRec.Status = c_FkDelete ) THEN
		
			/****************************************************************/
			/* Delete rows that are not eligible for purge for parent records
			/* that will be purged
			/****************************************************************/
			v_HistoryRec.fk_sql := null;
			v_HistoryRec.child_fk_sql := null;
			v_Tenant := Fn_GetTenantId( v_HistoryRec.table_name, v_HistoryRec.partition_name );
			Sp_DeleteFKs( v_HistoryRec, p_PurgeDate, v_Tenant );
			v_Status := dbms_parallel_execute.finished;
		elsif( v_HistoryRec.Status = c_SubPartDrop ) THEN
			/****************************************************************/
			/* Do nothing it will be done at the end of this procedure
			/****************************************************************/
			v_Status := dbms_parallel_execute.finished;
		
		elsif( v_HistoryRec.Status in ( c_FinishedErrors, c_Processed, c_Processing, c_Failed ) ) THEN
		
			/****************************************************************/
			/* Reprocess the partition forcing rechunk to accept any fixes
			/* might have been applied since last run
			/* Then error so we don't attempt to continue this task
			/****************************************************************/
			Sp_PurgePartition( v_HistoryRec.table_name, v_HistoryRec.partition_name, v_PurgeColumn, p_HistId, p_PurgeDate );
			raise e_NoPartitionToRestart;
		elsif( v_HistoryRec.STATUS in ( c_Stopped, c_Chunked, c_Crashed, c_Begin ) ) then
			/****************************************************************/
			/* Set the number of chunks and ensure we have time to start the
			/* partition purge
			/****************************************************************/
			v_HistoryRec.TOT_NBR_CHUNKS := Fn_GetChunkCount( v_HistoryRec.task_name );
			Sp_CheckWindowEndTime( v_HistoryRec.table_name, v_HistoryRec.partition_name );
			/****************************************************************/
			/* Create the monitor job and resume the task execution
			/****************************************************************/
			Sp_CreateMonitorJob( v_HistoryRec.task_name, v_HistoryRec.table_name, v_HistoryRec.partition_name );
			begin
				dbms_parallel_execute.resume_task( v_HistoryRec.task_name );
				v_Status := dbms_parallel_execute.task_status( v_HistoryRec.task_name );
				/************************************************************/
				/* Determine if the monitor stopped the job, else check the
				/* status
				/************************************************************/
				Sp_CheckMonitorReturn;
				if( v_Status = dbms_parallel_execute.crashed ) then
					raise e_EndWindow;
				elsif( v_Status = dbms_parallel_execute.finished_with_error ) then
					raise e_FinishedErrors;
				elsif( v_Status <> dbms_parallel_execute.finished ) then
					raise e_FailedTask;
				end if;
			exception
				when e_InvalidRestartStatus then
					dbms_parallel_execute.drop_task( v_HistoryRec.task_name );
					Sp_PurgePartition( v_HistoryRec.table_name, v_HistoryRec.partition_name, v_PurgeColumn, p_HistId, p_PurgeDate );
			end;
		elsif( v_HistoryRec.STATUS in ( c_Finished ) ) then
			raise e_NoPartitionToRestart;
		else
			raise e_InvalidRestartStatus;
		end if; -- v_HistoryRec.Status = c_FkDelete
		
		/********************************************************************/
		/* Complete the history record and insert it
		/********************************************************************/
		Sp_RebuildIndexes( v_HistoryRec.table_name, v_HistoryRec.partition_name, v_HistoryRec.index_sql, v_HistoryRec.id_purge_history, v_HistoryRec.id );
		Sp_DropSubpartitions( v_HistoryRec, p_PurgeDate );
		v_HistoryRec.STATUS := Fn_StatusNbrToChar( v_Status );
		Sp_SumChunksToParts( v_HistoryRec );
		v_HistoryRec.END_DATE := SYSDATE;
		begin
			dbms_parallel_execute.drop_task( v_HistoryRec.task_name );
		exception
			when e_NoTask then
				null;
		end;
		update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
		commit;
	EXCEPTION
		WHEN e_NoPartitionToRestart THEN
			NULL;
		WHEN e_SubPartDrop THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_RestartPurgePartition: Window ended for table ' || v_HistoryRec.table_name || ' and partition ' || v_HistoryRec.partition_name );
			v_HistoryRec.STATUS := c_SubPartDrop;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'End of window while deleting Subpartitions',
				'p_HistId: ' || p_HistId );
			commit;
			RAISE e_SubPartDrop;
		WHEN e_FkDelete THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_RestartPurgePartition: Window ended for table ' || v_HistoryRec.table_name || ' and partition ' || v_HistoryRec.partition_name );
			v_HistoryRec.STATUS := c_FkDelete;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'End of window while deleting FKs',
				'p_HistId: ' || p_HistId );
			commit;
			RAISE e_FkDelete;
		WHEN e_EndWindow THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_RestartPurgePartition: Window ended for table ' || v_HistoryRec.table_name || ' and partition ' || v_HistoryRec.partition_name );
			v_HistoryRec.STATUS := c_Stopped;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'End of window',
				'p_HistId: ' || p_HistId );
			commit;
			RAISE e_EndWindow;
		WHEN e_StopRunning THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_RestartPurgePartition: Stop run requested ' || v_HistoryRec.table_name || ' and partition ' || v_HistoryRec.partition_name );
			v_HistoryRec.STATUS := c_Stopped;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'Stop run requested',
				'p_HistId: ' || p_HistId );
			commit;
			RAISE e_StopRunning;
		WHEN e_FinishedErrors THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			v_HistoryRec.STATUS := Fn_StatusNbrToChar( v_Status );
			Sp_SumChunksToParts( v_HistoryRec );
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_RestartPurgePartition task finished with errors ' || v_HistoryRec.table_name || ' and partition ' || v_HistoryRec.partition_name );
			DBMS_OUTPUT.PUT_LINE( '   select * from table(pkg_sbmo_purge.fn_showerrors(' || b_ErrDate || ')); ' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'Task finished with errors',
				'p_TableName: ' || v_HistoryRec.table_name || ' | p_PartName: ' || v_HistoryRec.partition_name );
			commit;
			RAISE e_FinishedErrors;
		WHEN e_FailedTask THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			v_HistoryRec.STATUS := Fn_StatusNbrToChar( v_Status );
			Sp_SumChunksToParts( v_HistoryRec );
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_RestartPurgePartition task failed for table ' || v_HistoryRec.table_name || ' and partition ' || v_HistoryRec.partition_name || ' with status ' || v_HistoryRec.STATUS );
			DBMS_OUTPUT.PUT_LINE( '   select * from table(pkg_sbmo_purge.fn_showerrors(' || b_ErrDate || ')); ' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'Task failed with status ' || v_HistoryRec.STATUS,
				'p_HistId: ' || p_HistId );
			commit;
			RAISE e_FailedTask;
		WHEN e_InvalidRestartStatus THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_RestartPurgePartition, Restart has invalid status ' || v_HistoryRec.STATUS );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'Restart has invalid status ' || v_HistoryRec.STATUS,
				'p_HistId: ' || p_HistId );
			commit;
			Raise e_InvalidRestartStatus;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Other Error in Sp_RestartPurgePartition for table ' || v_HistoryRec.table_name || ' and partition ' || v_HistoryRec.partition_name );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			v_HistoryRec.STATUS := c_Failed;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_HistId: ' || p_HistId );
			commit;
			RAISE;
	END Sp_RestartPurgePartition;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_PurgeHistoryTables
	/*
	/* Parameters:	p_PurgeDate		DATE
	/*				++ Date used as the purge baseline
	/*
	/* Description:	This procedure will set purge the purge history tables
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	02/04/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_PurgeHistoryTables
	(
	p_PurgeDate			IN			DATE
	)
	IS
		-- Processing Variables
		v_Start				DATE			:= SYSDATE;
		
		-- Fetch Variables
		f_HistId			NUMBER			:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Determine the lowest purge_history record to keep
		/********************************************************************/
		select  min(id)
		into	f_HistId
		from    purge_history
		where   table_name =
				(
				select  table_name
				from    purge_tables
				where   purge_position =
						(
						select  min(purge_position)
						from    purge_tables
						)
				)
				and start_date > p_PurgeDate;
		/********************************************************************/
		/* Determine all records older than the lowest purge history record
		/* to keep
		/********************************************************************/
		delete 	purge_history_chunks
		where	id_purge_history_partitions <=
				(
				select 	max(id)
				from 	purge_history_partitions
				where 	id_purge_history < f_HistId
				);
		delete	purge_history_partitions
		where	id_purge_history < f_HistId;
		
		delete	purge_history
		where	id < f_HistId;
		commit;
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_PurgeHistoryTables for p_PurgeDate: ' || to_char(p_purgedate, 'mm/dd/yyyy hh24:mi:ss') );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			rollback;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeHistoryTables',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_PurgeDate: ' || to_char(p_purgedate, 'mm/dd/yyyy hh24:mi:ss') );
			commit;
			RAISE;
	END Sp_PurgeHistoryTables;
	-----------------------------------------------------------------------------
	-- Declare Public Functions
	-----------------------------------------------------------------------------
	/***************************************************************************/
	/*
	/* Function:	Fn_GetElapsedSecs
	/*
	/* Parameters:	p_Start         IN    	DATE
	/*				++ Start date/time
	/*				p_End			IN		DATE
	/*				++ End date/time
	/*
	/* Description:	This function returns the number of seconds between the
	/*				two dates passed in
	/*
	/* Notes:		None
	/*
	/* Return:		NUBER
	/*				++ Number of seconds between the dates
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/23/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetElapsedSecs
	(
	p_Start		IN		DATE,
	p_End		IN		DATE
	)
	RETURN NUMBER
	IS
		-- Processing Variables
		-- Fetch Variables
		f_ElapsedSecs		NUMBER				:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Determine the number of seconds between the two dates
		/********************************************************************/
		select 	round(max((p_End - p_Start) * 24 * 60 * 60)) as diff_min
		into	f_ElapsedSecs
		from	dual;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_ElapsedSecs;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetElapsedSecs for ' || 'p_Start: ' || to_char( p_Start, 'mm/dd/yyyy hh24:mi:ss' ) || ' | p_End: ' || to_char( p_End, 'mm/dd/yyyy hh24:mi:ss' ) );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetElapsedSecs', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_Start: ' || to_char( p_Start, 'mm/dd/yyyy hh24:mi:ss' ) || ' | p_End: ' || to_char( p_End, 'mm/dd/yyyy hh24:mi:ss' ) );
			commit;
			RAISE;
	END Fn_GetElapsedSecs;
	/***************************************************************************/
	/*
	/* Function:	Fn_StatusNbrToChar
	/*
	/* Parameters:	p_Status           IN    NUMBER
	/*				++ Numeric status to translate
	/*
	/* Description:	This function will translate dbms_parallel numeric status
	/*				into a character status
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Readable status
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/19/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_StatusNbrToChar
	(
	p_Status	IN		NUMBER
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		v_Return			VARCHAR2(30)		:= NULL;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Translate numeric to character status value
		/********************************************************************/
		CASE	p_Status
				WHEN dbms_parallel_execute.created				
					THEN v_Return := c_Created;
				WHEN dbms_parallel_execute.chunking				
					THEN v_Return := c_Chunking;
				WHEN dbms_parallel_execute.chunking_failed		
					THEN v_Return := c_ChunkingFailed;
				WHEN dbms_parallel_execute.no_chunks
					THEN v_Return := c_NoChunks;
				WHEN dbms_parallel_execute.chunked				
					THEN v_Return := c_Chunked;
				WHEN dbms_parallel_execute.processing			
					THEN v_Return := c_Processing;
				WHEN dbms_parallel_execute.processed
					THEN v_Return := c_Processed;
				WHEN dbms_parallel_execute.finished				
					THEN v_Return := c_Finished;
				WHEN dbms_parallel_execute.finished_with_error	
					THEN v_Return := c_FinishedErrors;
				WHEN dbms_parallel_execute.crashed				
					THEN v_Return := c_Crashed;
				ELSE
					v_Return := 'Uknown - ' || p_Status;
		END CASE;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN v_Return;
	
	END Fn_StatusNbrToChar;
	/***************************************************************************/
	/*
	/* Function:	Fn_ShowErrors
	/*
	/* Parameters:	p_FromDate		IN		DATE
	/*				++ Show data from this date forward
	/* 			p_TaskName          IN    VARCHAR2
	/*				++ Task name to get errors for
	/*
	/* Description:	This function shows errors for the task passed in or the
	/*				most recent with errors if it is omitted
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Pipelined error messages
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/25/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_ShowErrors
	(
	p_FromDate			DATE,
	p_TaskName	IN		VARCHAR2		DEFAULT NULL
	)
	RETURN tbl_Strings
	PIPELINED
	IS
		-- Processing Variables
		v_TaskName			VARCHAR2(128)			:= upper(p_TaskName);
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_errs
				(
				p_Task		varchar2
				)
		is
				select	distinct
						substr(error_message,1,1000) as error_message
				from	user_parallel_execute_chunks
				where	task_name = p_Task
						and error_message is not null
				order by error_message;
	cursor		c_procs
				(
				p_Date		date
				)
	is
				select 	code_block || ': ' || exception_message as error_message
				from		purge_error_log
				where		error_time >= p_Date
				order by error_time;
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* If no task is passed in get the latest one with errors
		/********************************************************************/
		if( v_TaskName is null ) then
			begin
				select 	task_name
				into	v_TaskName
				from 	user_parallel_execute_chunks
				where 	chunk_id =
						(
							select 	max(chunk_id)
							from 	user_parallel_execute_chunks
	    					where 	error_message is not null
						);
			exception
				when no_data_found then
					null;
			end;
		end if;
		/********************************************************************/
		/* Display the parallel execute chunk errors
		/********************************************************************/
		PIPE ROW( 'Parallel_Execute_Chunk Errors:' );
		for lr in c_errs( v_TaskName ) loop
			PIPE ROW( lr.error_message );
		end loop;
		/********************************************************************/
		/* Display the processing errors
		/********************************************************************/
		PIPE ROW( 'Processing Errors:' );
		for lr in c_procs( p_FromDate ) loop
			PIPE ROW( lr.error_message );
		end loop;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			dbms_output.put_line( 'No errors found to display' );
		WHEN NO_DATA_NEEDED THEN
			NULL; -- this means the function returned x nbr of rows but the query only requested first y rows
	END Fn_ShowErrors;
	/***************************************************************************/
	/*
	/* Function:	Fn_DailyRpt
	/*
	/* Parameters:	p_FromDate		IN		DATE
	/*				++ Show data from this date forward
	/*
	/* Description:	This function shows statistics for the last run
	/*
	/* Notes:		The last run may or may not have completed all tables
	/*
	/* Return:		VARCHAR2
	/*				++ Pipelined error messages
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/25/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_DailyRpt
	(
	p_FromDate		DATE
	)
	RETURN tbl_DailyRec
	PIPELINED
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_Rows
		is
				select  table_name as table_name,
						sum(tot_elapsed_secs) as tot_elapsed_secs,
						sum(nbr_rows_purged) as nbr_rows_purged,
						nvl(sum(nbr_rows_deleted_fk+nbr_rows_deleted_child_fk+nbr_rows_deleted_grandchild_fk),0) as nbr_rows_delted_fk,
						nvl(sum(tot_elapsed_fk_secs),0) as tot_elapsed_fk_secs,
						nvl(sum(nbr_subparts_dropped),0) as nbr_subparts_dropped,
						round(sum(nbr_rows_purged)/case sum(tot_elapsed_secs) when 0 then 1 else sum(tot_elapsed_secs) end,2) as purged_per_sec,
						round(sum(nvl(nbr_rows_deleted_fk,0))/case sum(nvl(tot_elapsed_fk_secs,0)) when 0 then 1 else sum(nvl(tot_elapsed_fk_secs,0)) end,2) as fk_per_sec
				from    purge_history_partitions
				where	start_date > p_FromDate
				group by table_name
				order by table_name;
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Display the data rows
		/********************************************************************/
		for lr in c_Rows loop
			PIPE ROW( lr );
		end loop;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			dbms_output.put_line( 'No last run found to display' );
		WHEN NO_DATA_NEEDED THEN
			NULL; -- this means the function returned x nbr of rows but the query only requested first y rows
	END Fn_DailyRpt;
	-----------------------------------------------------------------------------
	-- Declare Public Procedures
	-----------------------------------------------------------------------------
	/***************************************************************************/
	/*
	/* Procedure:	Sp_CreatePurgeSchedulerJob
	/*
	/* Parameters:	None
	/*
	/* Description:	This procedure will create a scheduler job to automate the
	/*				SBMO purge daily
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	02/25/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_CreatePurgeSchedulerJob
	IS
		-- Processing Variables
		v_JobName			VARCHAR2(30)						:= 'ORA_SBMO_PURGE';
		v_WindowTimes		PURGE_CONFIG_SETTINGS.VALUE%TYPE	:= NULL;
		v_StartHour			VARCHAR2(4)							:= NULL;
		v_StartDate			DATE								:= NULL;
		
		-- Fetch Variables
		f_Count				NUMBER								:= 0;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Determine if the job is currently running, if so then error
		/********************************************************************/
		select	count(*)
		into	f_Count
		from	user_scheduler_running_jobs
		where	job_name = v_JobName;
		
		if( f_Count > 0 ) then
			RAISE_APPLICATION_ERROR( -20699, v_JobName || ' is currently running - unable to recreate the job, exiting' );
		end if;
		
		/********************************************************************/
		/* Get the window times configuration setting and determine the start
		/* date for the job, 1 second past the next configuration start time
		/********************************************************************/
		v_WindowTimes := Fn_GetConfig( c_WindowTimes );
		v_StartHour := substr( v_WindowTimes, 0, instr( v_WindowTimes, '-' )-1 );
		v_StartDate := to_date(to_char( sysdate, 'mm/dd/yyyy ' ) || v_StartHour || '01', 'mm/dd/yyyy hh24miss');
		if( v_StartDate < sysdate ) then
			v_StartDate := v_StartDate + 1;
		end if;
		
		/********************************************************************/
		/* Create a scheduler job to execute the purge that will begin
		/********************************************************************/
		dbms_scheduler.create_job(
			job_name	=> v_JobName,
			job_type	=> 'PLSQL_BLOCK',
			job_action	=> 'begin pkg_sbmo_purge.sp_purgesbmo; end; ',
			start_date	=> v_StartDate,
			repeat_interval	=> 'FREQ=DAILY',
			end_date	=> NULL,
			job_class	=> Fn_GetConfig( c_JobClass ),
			comments	=> 'Purge SBMO',
			auto_drop	=> false,
			enabled		=> true );
	EXCEPTION
		WHEN e_JobExists THEN
			dbms_scheduler.drop_job( v_JobName );
			Sp_CreatePurgeSchedulerJob;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_CreatePurgeSchedulerJob' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CreatePurgeSchedulerJob',  b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Sp_CreatePurgeSchedulerJob;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_StopRunningPurge
	/*
	/* Parameters:	None
	/*
	/* Description:	This procedure will stop the purge that is currently running
	/*
	/* Notes:		The stop will occur when a task is created and is able to
	/*				be stopped.  The code may be working on a FK delete or so
	/*				but when the next task is created the purge will stop
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/28/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_StopRunningPurge
	IS
		-- Processing Variables
		v_Return			VARCHAR2(30)		:= NULL;
		-- Fetch Variables
		f_Running			CHAR(1)				:= c_Yes;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Loop until the purge running flag is set to N
		/* Each loop will kill any purge tasks and will trigger a stop
		/* However, it may loop with no effect if a FK delete or processing
		/* leading to a task is running but will catch up once a task is
		/* created
		/********************************************************************/
		Sp_SetRunFlag( c_StopJob );
		Sp_StopAllTasks;
		dbms_output.put_line( 'It may take up to 10 minutes for all process to completely stop' );
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_StopRunningPurge' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_StopRunningPurge',  b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Sp_StopRunningPurge;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_MonitorTask
	/*
	/* Parameters:	p_Taskname          IN    	VARCHAR2
	/*				++ Name of task to monitor
	/* 				p_TableName			IN OUT	VARCHAR2
	/*				++ Table being purged
	/*				p_PartName			IN OUT	VARCHAR2
	/*				++ Tables partition being purged
	/*
	/* Description:	This procedure will monitor the task until it errors over
	/*				the configured number of times, completes or the end of the
	/*				maintenance window
	/*
	/* Notes:		This should never be run manually, only scheduled via a
	/*				job in the package
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_MonitorTask
	(
	p_TaskName		IN		VARCHAR2,
	p_TableName		IN 		VARCHAR2,
	p_PartName		IN 		VARCHAR2
	)
	IS
		-- Processing Variables
		v_Retries				NUMBER				:= 0;
		v_Status				NUMBER				:= NULL;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Set the body processing variables from the configuration table
		/********************************************************************/
		Sp_SetConfig;
	
		/********************************************************************/
		/* Monitor the task
		/********************************************************************/
		v_Status := dbms_parallel_execute.task_status( p_TaskName );
		WHILE ( v_Retries < b_RetryCount and v_Status in ( dbms_parallel_execute.processing, dbms_parallel_execute.processed ) ) LOOP
			if( v_Status = dbms_parallel_execute.processing ) then
				dbms_lock.sleep( b_SleepTime );
			else
				v_Retries := v_Retries + 1;
				dbms_parallel_execute.resume_task( p_TaskName );
			end if;
			v_Status := dbms_parallel_execute.task_status( p_TaskName );
			Sp_CheckWindowEndTime( p_TableName, p_PartName );
		END LOOP;
		/********************************************************************/
		/* Error if other than finished status for the task
		/********************************************************************/
		if( v_Status not in ( dbms_parallel_execute.finished, dbms_parallel_execute.crashed ) ) then
			RAISE e_FailedTask;
		end if;
		
	EXCEPTION
		WHEN e_NoTask THEN
			NULL;
		WHEN e_EndWindow THEN
			Sp_StopTask( p_TaskName );
			Sp_SetRunFlag( c_MonitorWindow );
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_MonitorTask',  b_SqlCode, b_SqlErrm,
				'Task stopped due to end of window condition ',
				'p_TaskName: ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
		WHEN e_StopRunning THEN
			Sp_StopTask( p_TaskName );
			Sp_SetRunFlag( c_MonitorStop );
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_MonitorTask',  b_SqlCode, b_SqlErrm,
				'Stop run requested ',
				'p_TaskName: ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
		WHEN e_FailedTask THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Task ' || p_TaskName || ' for table ' || p_TableName || ' and partition ' || p_PartName || ' failed with status ' || v_Status || ', ' || Fn_StatusNbrToChar(v_Status) );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_MonitorTask',  b_SqlCode, b_SqlErrm,
				'Task failed with status ' || v_Status,
				'p_TaskName: ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | v_Status: ' || v_Status || ', ' || Fn_StatusNbrToChar(v_Status) );
			commit;
			RAISE e_FailedTask;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_MonitorTask for ' || p_TaskName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_MonitorTask',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TaskName: ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | v_Status: ' || v_Status || ', ' || Fn_StatusNbrToChar(v_Status) );
			commit;
			RAISE;
	END Sp_MonitorTask;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_PurgeSBMO
	/*
	/* Parameters:	None
	/*
	/* Description:	This procedure is the main driver for the sbmo purge
	/*
	/* Notes:		This is the driving procedure for the SBMO purge
	/*
	/***************************************************************************
	/*
	/* Name			Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/15/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_PurgeSBMO
	IS
		-- Processing Variables
		v_EligibleCount		NUMBER							:= 0;
		v_TableCount		NUMBER							:= 0;
		v_ChunkCount		NUMBER							:= 0;
		v_ResumeTime		DATE							:= SYSDATE;
		
		v_HistoryRec		PURGE_HISTORY%ROWTYPE			:= NULL;
		v_PurgeTable		PURGE_TABLES.TABLE_NAME%TYPE	:= NULL;
		v_PurgeColumn		VARCHAR2(30)					:= NULL;
		
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		CURSOR	c_Parts
				(
				p_TableName		VARCHAR2
				)
		IS		
		    -- Medha : We want to pick partition_name when table is partitioned , else set the value to NON_PARTITIONED when
		     with all_tbl(partition_name) as (
select	partition_name
from	user_tab_partitions
where	table_name = p_TableName
union
select 'NON_PARTITIONED' -- We are fetching only non partitioned tables here
from user_tables
where	table_name = p_TableName
			 and partitioned='NO' )
select partition_name from all_tbl
order by partition_name;
		
		       -- old sql
				--select	partition_name
				--from	user_tab_partitions
				--where	table_name = p_TableName
				--order by partition_name;
				
		CURSOR	c_CatchUpParts
				(
				p_HistId		NUMBER,
				p_TableName		VARCHAR2
				)
		IS
				select	partition_name
				from	user_tab_partitions
				where	table_name = p_TableName
						and partition_name not in
						(
						select	partition_name
						from	purge_history_partitions
						where	id_purge_history = p_HistId
								and status = c_Finished
						)
				order by partition_name;
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Set the body processing variables from the configuration table
		/********************************************************************/
		Sp_SetConfig;
		/********************************************************************/
		/* Check if the purge is already running, if so error
		/********************************************************************/
		if( Fn_KeepRunning ) then
			raise e_AlreadyRunning;
		else
			Sp_SetRunFlag( c_Yes );
		end if;
		
		/********************************************************************/
		/* Get the number of tables eligible for purge and the last history
		/* record
		/* If force restart is requested setup the history record and
		/* update config settings so it will not force on next run but will
		/* again pick up where we left off
		/********************************************************************/
		v_EligibleCount := Fn_GetEligibleCount;
		
		dbms_output.put_line('DEBUG | Force Restart-' ||b_ForceRestart );
		
		if( b_ForceRestart = c_Yes ) then
			v_HistoryRec.STATUS := c_Finished;
			v_HistoryRec.TABLE_NAME := c_NoTable;
			update purge_config_settings set value = c_No where name = c_ForceRestart;
			commit;
		else
			v_HistoryRec := Fn_GetLatestHistory;
		end if;
		
		/********************************************************************/
		/* If the last run stopped a task, restart it
		/********************************************************************/
		dbms_output.put_line('DEBUG | History Task Status -' ||v_HistoryRec.STATUS );
		if( v_HistoryRec.STATUS in ( c_Stopped, c_Chunked, c_Crashed, c_FkDelete, c_SubPartDrop, c_FinishedErrors, c_Processed, c_Processing, c_Failed ) ) then
dbms_output.put_line('DEBUG | Restart Stopped task from previous run, task status was -' || v_HistoryRec.STATUS );
			
			dbms_output.put_line('DEBUG | Before Sp_RestartPurgePartition. Details of prev task - PURGE_HISTORY.ID: ' ||  v_HistoryRec.ID || 'PURGE_DATE : ' || v_HistoryRec.PURGE_DATE  );     			
			
			Sp_RestartPurgePartition( v_HistoryRec.ID, v_HistoryRec.PURGE_DATE );
		
			/****************************************************************/
			/* Loop through all the remaining table partitions and process
			/* each one
			/****************************************************************/
			dbms_output.put_line('DEBUG | Before Fn_GetPurgeColumn Restartv_HistoryRec.table_name  -' || v_HistoryRec.table_name );
			v_PurgeColumn := Fn_GetPurgeColumn( v_HistoryRec.table_name );
			for lr in c_CatchUpParts( v_HistoryRec.ID, v_HistoryRec.TABLE_NAME ) loop
			    dbms_output.put_line('DEBUG | Loop thru c_CatchUpParts, before  Sp_PurgePartition' );
				dbms_output.put_line('DEBUG | v_HistoryRec.table_name-' || v_HistoryRec.table_name || 'lr.partition_name - ' || lr.partition_name || 'v_PurgeColumn -' || v_PurgeColumn || 'v_HistoryRec.ID - ' || v_HistoryRec.ID || 'v_HistoryRec.PURGE_DAT-' || v_HistoryRec.PURGE_DATE );
				Sp_PurgePartition( v_HistoryRec.table_name, lr.partition_name, v_PurgeColumn, v_HistoryRec.ID, v_HistoryRec.PURGE_DATE );
			end loop;
			/****************************************************************/
			/* Complete the history record values and insert it
			/****************************************************************/
		
			v_HistoryRec.Status := c_Finished;
			v_HistoryRec.End_Date := sysdate;
			Sp_SumPartsToTable( v_HistoryRec );
			Sp_RebuildIndexes( v_HistoryRec.table_name, NULL, v_HistoryRec.index_sql, v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			v_TableCount := v_TableCount + 1;
		elsif( v_HistoryRec.Status in ( c_Finished ) ) then
			null;
		else
			raise e_InvalidRestartStatus;
		end if;
		
		/********************************************************************/
		/* Purge tables until time runs out or all tables are processed
		/********************************************************************/
		dbms_output.put_line('DEBUG |Outside IF task stats  v_TableCount - ' || v_TableCount);
		while v_TableCount < v_EligibleCount loop
			/****************************************************************/
			/* Get the next table to be purged and its purge column
			/****************************************************************/
		   dbms_output.put_line ('DEBUG| Before call First table to purge  TABLE_NAME - ' || v_HistoryRec.TABLE_NAME  );
			v_PurgeTable := Fn_GetNextPurgeTable( v_HistoryRec.TABLE_NAME );
			dbms_output.put_line ('DEBUG| Before call First table to purge  ' || v_HistoryRec.TABLE_NAME);
			v_PurgeColumn := Fn_GetPurgeColumn( v_PurgeTable );
			
			dbms_output.put_line ('DEBUG| After Call table to purge  ' || v_HistoryRec.TABLE_NAME);
			
			/****************************************************************/
			/* Set the initial history record values
			/****************************************************************/
		
			v_HistoryRec := NULL;
			v_HistoryRec.ID := purge_seq.nextval;
			v_HistoryRec.Table_Name := v_PurgeTable;
			v_HistoryRec.Start_Date := sysdate;
			v_HistoryRec.Purge_Date := Fn_GetPurgeDate( v_PurgeTable );
			v_HistoryRec.Status := c_Processing;
			insert into purge_history values v_HistoryRec;
			commit;
			
			/****************************************************************/
			/* Loop through all the table partitions and process each one
			/****************************************************************/
		
			if( v_PurgeTable = 'PURGE_HISTORY' ) then
				Sp_PurgeHistoryTables( v_HistoryRec.PURGE_DATE );
			else
				for lr in c_parts( v_PurgeTable ) loop
					Sp_PurgePartition( v_PurgeTable, lr.partition_name, v_PurgeColumn, v_HistoryRec.ID, v_HistoryRec.PURGE_DATE );
				end loop;
			end if;
			
			/****************************************************************/
			/* Rebuild any invalid indexes
			/****************************************************************/
		
			Sp_RebuildIndexes( v_PurgeTable, NULL, v_HistoryRec.index_sql, v_HistoryRec.ID );
			/****************************************************************/
			/* Complete the history record values and insert it
			/****************************************************************/
		
			v_HistoryRec.Status := c_Finished;
			v_HistoryRec.End_Date := sysdate;
			Sp_SumPartsToTable( v_HistoryRec );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			
			/****************************************************************/
			/* Increment the table counter
			/****************************************************************/
		
			v_TableCount := v_TableCount + 1;
		end loop; -- while v_TableCount < v_EligibleCount
		
		/********************************************************************/
		/* Set the run flag to no, as this run has completed
		/********************************************************************/
		Sp_SetRunFlag( c_No );
		Sp_SendStatusReport( 'All tables successfully purged', v_ResumeTime );
	EXCEPTION
		WHEN e_AlreadyRunning THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			dbms_output.put_line( 'Purge is already running according to purge_run_check table, exiting' );
			dbms_output.put_line( 'If this is incorrect please truncate purge_run_check table' );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'Purge is already running, exiting',
				'None' );
			commit;
			Sp_SendStatusReport( 'FAILED: Attempted to start purge when it is already running according to purge_run_check table, exiting.  ' || chr(10) || 'If this is incorrect please truncate purge_run_check table', sysdate, c_Yes );
			RAISE_APPLICATION_ERROR( -20299, 'Purge is already running according to purge_run_check table, exiting' || chr(10) || 'If this is incorrect please truncate purge_run_check table' );
		WHEN e_SubPartDrop THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_SubPartDrop;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'End of Window while dropping subpartitions',
				'None' );
			commit;
			Sp_SendStatusReport( 'End of Window while dropping subpartitions', v_ResumeTime );
		WHEN e_FkDelete THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_FkDelete;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'End of Window while deleting Fks',
				'None' );
			commit;
			Sp_SendStatusReport( 'End of Window while deleting Fks', v_ResumeTime );
		WHEN e_FinishedErrors THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_FinishedErrors;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'Finished with errors.',
				'None' );
			commit;
			Sp_SendStatusReport( 'FAILED: Finished with errors', v_ResumeTime, c_Yes );
			RAISE_APPLICATION_ERROR( -20220, 'Task finished with errors.  Get errors from purge_error_log using: select * from table(pkg_sbmo_purge.fn_ShowErrors(' || b_ErrDate || ')).  Also review dba_parallel_execute_tasks.' );
		WHEN e_EndWindow THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_Stopped;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'End of Window',
				'None' );
			commit;
			Sp_SendStatusReport( 'End of Window', v_ResumeTime );
		WHEN e_StopRunning THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_Stopped;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'Stop run requested',
				'None' );
			commit;
			Sp_SendStatusReport( 'Stop run requested', v_ResumeTime );
		WHEN e_BlackoutDay THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_Stopped;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'Today is a blackout day',
				'None' );
			commit;
			-- No need to send for blackout day Sp_SendStatusReport( b_SqlErrm, v_ResumeTime );
		WHEN e_InvalidRestartStatus THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_PurgeSBMO, Restart has invalid status ' || v_HistoryRec.STATUS );
			Sp_SetRunFlag( c_No );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'Restart has invalid status ' || v_HistoryRec.STATUS,
				'None' );
			commit;
			Sp_SendStatusReport( 'FAILED: Restart has invalid status ' || v_HistoryRec.STATUS, v_ResumeTime, c_Yes );
			RAISE_APPLICATION_ERROR( -20200, 'Restart has invalid status: ' || v_HistoryRec.STATUS );
		WHEN e_FailedTask THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_PurgeSBMO, table failed' );
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_Failed;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'Failed task',
				'None' );
			commit;
			Sp_SendStatusReport( 'FAILED: Failed Task', v_ResumeTime, c_Yes );
			RAISE_APPLICATION_ERROR( -20200, 'Task failed. Get errors from purge_error_log using: select * from table(pkg_sbmo_purge.fn_ShowErrors(' || b_ErrDate || ')).  Also review dba_parallel_execute_tasks.' );
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_PurgeSBMO' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_Failed;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			Sp_SendStatusReport( 'FAILED: Other Error: ' || b_SqlCode || ' - ' || b_SqlErrm, v_ResumeTime, c_Yes );
			RAISE_APPLICATION_ERROR( -20100, 'Other error in sp_PurgeSbmo.  Get errors from purge_error_log using: select * from table(pkg_sbmo_purge.fn_ShowErrors(' || b_ErrDate || ')).  Also review dba_parallel_execute_tasks.' );
	END Sp_PurgeSBMO;
--BEGIN
	/************************************************************************/
	/*
	/************************************************************************/
	
END Pkg_Sbmo_Purge;			-- End Package Body

/
CREATE OR REPLACE package           SBMO.ROTATE_PARTITIONS_PKG as

  procedure create_partitions;

end rotate_partitions_pkg;
/
CREATE OR REPLACE package body SBMO.ROTATE_PARTITIONS_PKG as

  l_start_timestamp timestamp;

  function lookup_properties (p_key varchar2) return varchar2
  is
     l_value sbmo_properties.value%type;
  begin
     select value into l_value
     from sbmo_properties
     where key = p_key;
     return l_value;
  end lookup_properties;

  function export_partitions return boolean
  IS
     l_ret sbmo_properties.value%type;
  BEGIN
     l_ret := lookup_properties('dataRetentionMonths');
     if to_number(l_ret) < 24 then
        return true;
     else
        return false;
     end if;
  END export_partitions;

  PROCEDURE send_email (p_message clob, p_html clob)
  IS
    l_from sbmo_properties.value%TYPE;
    l_to sbmo_properties.value%TYPE;
    l_text clob;
    l_temp varchar2(32000);
    l_subject varchar2(32000);
    l_user varchar2(30);
  BEGIN
    l_from := lookup_properties('partitionsEmailFrom');
    l_to := lookup_properties('partitionsEmailTo');
    select user into l_user from dual;
    l_subject := 'Unexpected error in ' || l_user || '.rotate_partitions_pkg on ' || to_char(sysdate, 'mm/dd/yyyy hh:mi:ss am');
    l_text := chr(10) || l_subject || chr(10) || chr(10);
    dbms_lob.createtemporary( l_text, false, 10 );
    dbms_lob.append(l_text, p_message  || chr(10) || chr(10));
    dba_tools.send_mail_pkg.html_email(
                          l_to,
                          l_from,
                          l_subject,
                          l_text,
                          p_html
                          );
    dbms_lob.freetemporary(l_text);
  END send_email;

  PROCEDURE apply_changes (p_sql varchar2)
  IS
    l_err varchar2(4000);
    l_id number;
  BEGIN
    IF p_sql IS NOT NULL THEN
      insert into partition_sql_history (id, sql_timestamp, sql_text)
          values (master_seq.nextval, systimestamp, p_sql)
          returning id into l_id;
      commit;
      execute immediate p_sql;
      commit;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
       l_err := sqlerrm;
       update partition_sql_history set sql_error = l_err
          where id = l_id;
       commit;
       if sqlcode != -2266 and sqlcode != -2292 then
          insert into partition_sql_history (id, sql_timestamp, sql_text, sql_error, report_error)
             values (master_seq.nextval, systimestamp, p_sql, l_err, 'Y');
          commit;
       end if;
  END apply_changes;

  function check_changes  (p_table_name varchar2, p_subpartition_name varchar2) return boolean
  IS
    l_err varchar2(4000);
    l_id number;
    l_s varchar2(32000);
  BEGIN
    l_s := 'delete ' || p_table_name || ' SUBPARTITION (' || p_subpartition_name || ')';
    insert into partition_sql_history (id, sql_timestamp, sql_text)
          values (master_seq.nextval, systimestamp, l_s)
          returning id into l_id;
    commit;
    execute immediate l_s;
    rollback;
    return true;
  EXCEPTION
    WHEN OTHERS THEN
       l_err := l_s || chr(10) || sqlerrm;
       update partition_sql_history set sql_error = l_err
          where id = l_id;
       commit;
       if sqlcode = -2266 or sqlcode = -2292 then
          return false;
       else
          l_err := sqlerrm;
          insert into partition_sql_history (id, sql_timestamp, sql_text, sql_error, report_error)
                 values (master_seq.nextval, systimestamp, l_s, l_err, 'Y');
          commit;
       end if;
  END check_changes;

  function lookup_subpartition (p_table_name varchar2, p_subpartition_name varchar2) return boolean
  is
     l_s varchar2(30);
  begin
     select subpartition_name
         into l_s
         from user_tab_subpartitions
         where table_name = p_table_name
         and subpartition_name = p_subpartition_name;
     return true;
  exception when no_data_found then
     return false;
  end lookup_subpartition;

  procedure export_subpartition(p_table_name varchar2, p_subpartition_name varchar2)
  is
  l_filename  varchar2(250);
  l_rand varchar2 (50);
  l_username varchar2(30);
  l_dir sbmo_properties.value%type;
  l_logdir sbmo_properties.value%type;
  h1          number;
  percent_done number;
  job_state    VARCHAR2(30);  -- To keep track of job state
  le           ku$_LogEntry;         -- For WIP and error messages
  js           ku$_JobStatus;        -- The job status from get_status
  jd           ku$_JobDesc;          -- The job description from get_status
  sts          ku$_Status;          -- The status object returned by get_status
  ind          number;
  i integer;
  l_job varchar2(30);
  l_exists       BOOLEAN;
  l_file_length  NUMBER;
  l_blocksize    NUMBER;
  l_text         VARCHAR2(32767);
  l_file         UTL_FILE.file_type;
  l_err varchar2(4000);
begin
  select dbms_random.string('L', 12) into l_rand from dual;
  l_username := sys_context('userenv','current_schema');
  l_filename := l_username || '_' || p_table_name || '_' || p_subpartition_name || '_' || l_rand;
  l_dir := lookup_properties('partitionExportDirectory');
  l_logdir := lookup_properties('partitionExportLogDirectory');
  l_job := substr(p_table_name || l_rand || p_subpartition_name, 1, 30);
  h1 := dbms_datapump.open (operation => 'EXPORT', job_mode => 'TABLE', job_name => upper(l_job));
  for i in 1..60
  loop
     dbms_lock.sleep(5);
     begin
        dbms_datapump.add_file (handle => h1, filename => l_filename || '.log', directory => l_logdir, filetype => 3);
        exit when 1 = 1;
    exception when others then
       if sqlcode != -31626 then
          l_err := sqlerrm;
          insert into partition_sql_history (id, sql_timestamp, sql_text, sql_error, report_error)
                   values (master_seq.nextval, systimestamp, 'expdp of ' || p_table_name || '.' || p_subpartition_name || ' Failed', l_err, 'Y');
          commit;
       end if;
    end;
  end loop;
  dbms_datapump.add_file (handle => h1, filename => l_filename || '.dmp', directory => l_dir, filetype => 1);
  dbms_datapump.set_parallel(handle => h1, degree => 4);

  dbms_datapump.metadata_filter (handle => h1, name => 'SCHEMA_EXPR', value => 'IN (''' || l_username || ''')');

  dbms_datapump.metadata_filter (handle => h1, name => 'NAME_EXPR', value => 'IN (''' || p_table_name || ''')');


  dbms_datapump.data_filter (handle => h1, name => 'PARTITION_LIST',
                             value => '''' || p_subpartition_name || '''',
                             table_name => p_table_name,
                             schema_name => l_username);

  begin
     dbms_datapump.start_job (handle => h1);
  exception when others then
     begin
        DBMS_DATAPUMP.STOP_JOB (
                      handle => h1,
                      immediate =>  1,
                      keep_master => 0,
                      delay   => 60);
      exception when others then
         if sqlcode != -31623 then
            l_err := sqlerrm;
            insert into partition_sql_history (id, sql_timestamp, sql_text, sql_error, report_error)
                   values (master_seq.nextval, systimestamp, 'dbms_datapump.stop_job failed for ' || p_table_name || '.' || p_subpartition_name || '.', l_err, 'Y');
            commit;
         end if;
      end;
      l_err := sqlerrm;
      insert into partition_sql_history (id, sql_timestamp, sql_text, sql_error, report_error)
                   values (master_seq.nextval, systimestamp, 'dbms_datapump.start_job failed for ' || p_table_name || '.' || p_subpartition_name || '.', l_err, 'Y');
      commit;
   end;

  percent_done := 0;
  job_state := 'UNDEFINED';
  WHILE (job_state != 'COMPLETED') AND (job_state != 'STOPPED')
  LOOP
    dbms_datapump.get_status(h1,
           dbms_datapump.ku$_status_job_error +
           dbms_datapump.ku$_status_job_status +
           dbms_datapump.ku$_status_wip, -1, job_state, sts);
    js := sts.job_status;
    percent_done := js.percent_done;
  END LOOP;
  dbms_datapump.detach (handle => h1);

  -- check log file for errors.
  UTL_FILE.fgetattr(l_logdir, l_filename || '.log', l_exists, l_file_length, l_blocksize);

    IF l_exists THEN
      -- Open file.
      l_file := UTL_FILE.fopen(l_logdir, l_filename || '.log', 'r', 32767);

      BEGIN
          LOOP
            UTL_FILE.get_line(l_file, l_text, 32767);
            IF instr (upper(l_text), 'ORA-') > 0 THEN
               RAISE_application_Error(-20500, 'Error during export of ' || l_username || '.' || p_table_name || '.' ||  p_subpartition_name);
            END IF ;
          END LOOP;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
            NULL;
      END;

      -- Close the file.
      UTL_FILE.fclose(l_file);
    END IF ;
  end export_subpartition;

  PROCEDURE drop_subpartitions
  IS
    l_s varchar2(32000);
    l_past sbmo_properties.value%type;
    l_d date;
    l_high_value varchar2(50);
    l_hd date;
  BEGIN
    FOR r1 IN (select p.table_name, u.partition_name
                   from partition_table_list p, user_tab_partitions u
                   where p.table_name = u.table_name
                   order by p.table_rank, u.partition_name)
    LOOP
      l_past := lookup_properties('dataRetentionMonths');
      l_d := add_months(sysdate, - to_number(l_past));
      FOR p1 IN (SELECT SUBPARTITION_NAME, high_value
                    FROM user_tab_subpartitions
                    WHERE table_name = r1.table_name
                    and partition_name = r1.partition_name)
      LOOP
         l_high_value := substr(p1.high_value, 12, 19);
         l_hd := to_date (l_high_value, 'yyyy-mm-dd hh24:mi:ss');
         IF l_hd < l_d THEN
            IF export_partitions THEN
               IF check_changes (r1.table_name, p1.subpartition_name) THEN
                  export_subpartition(r1.table_name, p1.subpartition_name);
                  l_s := 'delete ' || r1.table_name || ' ' ;
                  l_s := l_s || 'SUBPARTITION (' || p1.subpartition_name || ')';
                  apply_changes (l_s);
                  l_s := 'alter table ' || r1.table_name || ' ' ;
                  l_s := l_s || 'DROP SUBPARTITION ' || p1.subpartition_name ;
                  apply_changes (l_s);
                  l_s := null;
               END IF;
            ELSE
               l_s := 'delete ' || r1.table_name || ' ' ;
               l_s := l_s || 'SUBPARTITION (' || p1.subpartition_name || ')';
               apply_changes (l_s);
               l_s := 'alter table ' || r1.table_name || ' ' ;
               l_s := l_s || 'DROP SUBPARTITION ' || p1.subpartition_name ;
               apply_changes (l_s);
               l_s := null;
            END IF;
         END IF ;
      END LOOP;
    END LOOP;
  END DROP_SUBPARTITIONS;

  PROCEDURE cleanup_expdp_jobs
  IS
     l_username varchar2(30);
     l_job number;
     l_err varchar2(2000);
  BEGIN
     l_username := sys_context('userenv','current_schema');
     for rec in (select owner_name, job_name from dba_datapump_jobs where state in ('NOT RUNNING', 'UNDEFINED') and owner_name = l_username)
     loop
        begin
           l_job := DBMS_DATAPUMP.ATTACH(rec.job_name, rec.owner_name);
           DBMS_DATAPUMP.STOP_JOB (l_job);
        exception
           when others then
              l_err := sqlerrm;
              insert into partition_sql_history (id, sql_timestamp, sql_text, sql_error, report_error)
                   values (master_seq.nextval, systimestamp, 'Cleanup of expdp Job: ' || rec.job_name || ' Owner: ' || rec.owner_name || ' Failed', l_err, 'Y');
              commit;
        end;
     end loop;
  END cleanup_expdp_jobs;

  procedure create_partitions as
    l_future sbmo_properties.value%type;
    l_past sbmo_properties.value%type;
    l_d date;
    l_s varchar2(32000);
    l_msg clob;
    l_msg_html clob;
    l_send_email varchar2(1) := 'N';
  begin
    l_start_timestamp := systimestamp;
    l_future := lookup_properties('createFuturePartitionsMonths');
    l_past := lookup_properties('dataRetentionMonths');
    for r1 in (select p.table_name, u.partition_name, u.tablespace_name
                   from partition_table_list p, user_tab_partitions u
                   where p.table_name = u.table_name
                   order by p.table_rank, u.partition_name)
    loop
        l_d := trunc(sysdate, 'MM');
        WHILE l_d <= add_months(trunc(sysdate, 'MM'), to_number(l_future))
        LOOP
           IF NOT lookup_subpartition (r1.table_name, r1.partition_name || to_char(l_d, 'yyyymm')) THEN
             l_s := 'alter table ' || r1.table_name || ' modify ' || chr(10);
             l_s := l_s || 'PARTITION ' || r1.partition_name || ' ' || chr(10);
             l_s := l_s || 'ADD SUBPARTITION ' || r1.partition_name || to_char(l_d, 'yyyymm') || ' ';
             l_s := l_s || 'VALUES LESS THAN (TO_DATE(''' || '01' || to_char(add_months(l_d, 1), 'mmyyyy') || ''',' ;
             l_s := l_s || '''ddmmyyyy'')) tablespace ' || r1.tablespace_name;
             l_s := l_s || chr(10);
             apply_changes (l_s);
             l_s := null;
           end if;
           l_d := add_months(l_d, 1);
        end loop;
    end loop;
    drop_subpartitions;
    cleanup_expdp_jobs;

    -- Send email in case of errors
    dbms_lob.createtemporary (lob_loc => l_msg, cache => true);
    dbms_lob.createtemporary (lob_loc => l_msg_html, cache => true);
    dbms_lob.append(l_msg, 'ID: Error' || chr(10));
    dbms_lob.append(l_msg, '---------------------------------------------------------------------------------------------------------' || chr(10));
    dbms_lob.append( l_msg_html, '<html><body style="background-color:white;">' || chr(10));
    dbms_lob.append( l_msg_html, '<table border="1" cellpadding="3" cellspacing="0" width="800" style="font-family:verdana; font-size:12px; color:black; background-color:white;">' );
    dbms_lob.append( l_msg_html, '<tr>'  || chr(10));
    dbms_lob.append( l_msg_html, '<th align="center";>ID' || '</th>'  || chr(10));
    dbms_lob.append( l_msg_html, '<th align="center";>Timestamp' || '</th>'  || chr(10));
    dbms_lob.append( l_msg_html, '<th align="center";>SQL' || '</th>'  || chr(10));
    dbms_lob.append( l_msg_html, '<th align="center";>Error' || '</th>'  || chr(10));
    dbms_lob.append( l_msg_html, '</tr>'  || chr(10));
    for r in (select id, sql_timestamp, sql_text, sql_error
                   from partition_sql_history
                   where sql_timestamp > l_start_timestamp
                   and sql_error is not null
                   and report_error = 'Y')
    loop
       dbms_lob.append (l_msg, r.id || ': ' || r.sql_error || chr(10)|| chr(10));
       dbms_lob.append( l_msg_html, '<tr>'  || chr(10));
       dbms_lob.append( l_msg_html, '<td>' || r.id || '</td>'  || chr(10));
       dbms_lob.append( l_msg_html, '<td>' || to_char(r.sql_timestamp, 'mm/dd/yyyy hh24:mi:ss') || '</td>'  || chr(10));
       dbms_lob.append( l_msg_html, '<td>' || r.sql_text || '</td>'  || chr(10));
       dbms_lob.append( l_msg_html, '<td>' || r.sql_error || '</td>'  || chr(10));
       dbms_lob.append( l_msg_html, '</tr>'  || chr(10));
       l_send_email := 'Y';
    end loop;
    dbms_lob.append( l_msg_html, '</table>'  || chr(10));
    dbms_lob.append( l_msg_html, '</body></html>' || chr(10));
    if l_send_email = 'Y' then
       send_email (l_msg, l_msg_html);
       dbms_lob.freetemporary (l_msg);
       dbms_lob.freetemporary (l_msg_html);
    end if;
  end create_partitions;

end rotate_partitions_pkg;
/

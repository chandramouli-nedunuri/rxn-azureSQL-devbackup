
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SBMO"."PKG_PDX_SCHEMA_UPDATER" AS
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

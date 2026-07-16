
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SBMO"."PKG_PDX_SCHEMA_UPDATER_RPT" AS
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

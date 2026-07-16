
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SBMO"."PKG_PDX_SCHEMA_UPDATER_META" AS
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

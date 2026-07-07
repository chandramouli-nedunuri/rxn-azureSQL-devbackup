INSERT INTO ALL_OBJECTS (FILE_NAME,DDL_CLOB) VALUES
	 ('sbmo.procedure.custom_redef.sql',TO_CLOB('
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SBMO"."CUSTOM_REDEF" 
(v_owner in varchar2,v_table_name in varchar2)
as
v_metadata clob := empty_clob();
v_rdef_table varchar2(35);
v_count number;
v_status varchar2(10);
v_templine clob;
v_obj_name varchar2(30);
v_counter number;
v_start number;
v_end number;
v_line clob;
NO_META_FOUND EXCEPTION;
pragma exception_init (NO_META_FOUND,-31608);

cursor ref_con is
select upper(constraint_name) constraint_name, upper(constraint_type) constraint_type, row_number()OVER(PARTITION BY
constraint_type order by constraint_name) CON_COUNT
   from dba_constraints
     where (table_name,owner) in
     (select table_name,owner from dba_tables
          where  table_name= v_table_name
          and owner=v_owner)
     and    constraint_type in (''R'');


cursor cur_con is
select upper(constraint_name) constraint_name, upper(constraint_type) constraint_type, row_number()OVER (PARTITION BY
constraint_type order by constraint_name) CON_COUNT
   from dba_constraints
     where table_name=upper(v_table_name)
     and    owner=upper(v_owner)
     and    constraint_type in (''C'',''P'',''U'');


cursor cur_idx is
 select owner,index_name,partitioned,row_number()OVER(PARTITION BY
index_type order by index_name ) CON_COUNT
from dba_indexes
where  table_owner=upper(v_owner)
and table_name=upper(v_table_name)
and index_type not in (''LOB'')
and (index_name,owner) not in (select constraint_name,owner from dba_constraints
     where table_name=upper(v_table_name)
     and   owner=upper(v_owner)
     and status=''ENABLED'');



 procedure create_sub_part_tab (v_total in out clob,v_owner in varchar2,v_table in varchar2,v_rdef_table in varchar2)
  AS
  v_column CLOB;
  v_count number;
  v_column_list CLOB;
  v_check number;
  v_sub_col CLOB;
  v_sql  clob;
  v_tablespace varchar2(30);

procedure create_sub_part (metadata in out clob,tenant IN varchar2,tbs IN varchar2)
AS
  v_line CLOB;
  v_count number;
  v_num_days number :=2;
  v_archive_day number;
  v_archive_mo')||TO_CLOB('nths number :=19;

BEGIN
  v_column_list := null;
---- Start Create Sub Partition for TENANAT
  v_count :=v_archive_months;
  while (v_count > 0)
  LOOP
  v_line :=v_line||'',SUBPARTITION ''||upper(tenant)||to_char(add_months(sysdate,- v_count),''YYYYMM'')||'' VALUES LESS THAN (to_date(''''''||to_char(add_months(sysdate,- (v_count - 1)),''YYYY-MM'')||'''''',''''YYYY-MM'''')) TABLESPACE ''||upper(tbs)||CHR(13) || CHR(10);
  v_count := v_count - 1;
  END LOOP;


----Create Future Partition
  v_count :=0;
  while (v_count <= v_num_days)
  LOOP
  v_line :=v_line||'',SUBPARTITION ''||upper(tenant)||to_char(add_months(sysdate,+ v_count),''YYYYMM'')||'' VALUES LESS THAN (to_date(''''''||to_char(add_months(sysdate,+(v_count + 1)),''YYYY-MM'')||'''''',''''YYYY-MM'''')) TABLESPACE ''||upper(tbs)||CHR(13) || CHR(10);
  v_count := v_count + 1;
  END LOOP;

----- Remove comma from first line and add brackets

  v_line := ltrim(v_line,'','');
  metadata  := metadata||v_line||'')'';
end create_sub_part;
------ End Create Partition for TENANT


BEGIN

  ---- Check Table existence
  select count(1) into v_check from dba_tables where owner=upper(v_owner) and table_name=upper(v_table_name);

  IF v_check = 1 then

  ---- Capture tablespace name
    select tablespace_name into v_tablespace from dba_segments where owner=v_owner
    and segment_type like ''TABLE%'' and tablespace_name is not null and rownum=1;

  ---- Start Create table
    v_sql := ''CREATE TABLE ''||v_owner||''.''||v_rdef_table|| CHR(13) || CHR(10) ||
           ''('';

  v_total  := v_total||CHR(13) || CHR(10)||v_sql;
  v_count :=0;

  ---- Reterive column information
  for c1 in
  (
  select column_name , data_type , data_length from dba_tab_columns
  where owner=v_owner
  and table_name=v_table_name
  order by column_id
  )
  LOOP

  IF c1.data_type like ''CLOB'' THEN
  v_column :=c1.column_name||'' CLOB'';
  ELSIF c1.data_type like ''BLOB'' THEN
  v_column :=c1.column_name||'' BLOB'';
  ELSIF c1.data_type like ''TIMESTAMP%'' THEN
  v_column :=c1.column_name||'' TIMESTAMP(6')||TO_CLOB(')'';
  ELSIF c1.data_type like ''FLOAT%'' THEN
  v_column :=c1.column_name||'' FLOAT'';
  ELSIF c1.data_type like ''DATE'' THEN
  v_column :=c1.column_name||'' DATE'';
  ELSIF c1.data_type like ''NUMBER'' THEN
  v_column :=c1.column_name||'' NUMBER'';
  ELSIF c1.data_type like ''VARCHAR2'' THEN
  v_column :=c1.column_name||'' VARCHAR2(''||c1.data_length||'')'';
  END IF;

  IF v_count = 0 then
  v_column_list := v_column;
  ELSE
  v_column_list := v_column_list||'',''||CHR(13) || CHR(10) ||v_column;
  END IF;
  v_count := v_count + 1;
  END LOOP;
  --v_column_list   := ltrim(v_column_list,'','');
  v_total  := v_total||CHR(13) || CHR(10)||v_column_list;

  v_sql := '')'';
  v_total  := v_total||CHR(13) || CHR(10)||v_sql;

  ---- Start Partition/Sub partition Create
  v_sql := ''PARTITION BY LIST (TENANT_ID)''|| CHR(13) || CHR(10) ||
           ''SUBPARTITION BY RANGE (CREATED_DATE)''|| CHR(13) || CHR(10) ||
           ''('';
  v_total  := v_total||CHR(13) || CHR(10)||v_sql;

------ Start Create Partition for RXCOM

  v_sql := ''PARTITION  RXCOM  VALUES (1) TABLESPACE ''||v_tablespace||CHR(13) || CHR(10) || ''('' || CHR(13) || CHR(10);
  v_total  := v_total||CHR(13) || CHR(10)||v_sql;
  v_column_list := null;
  create_sub_part(v_column_list,''RXCOM'',v_tablespace);
  v_total  := v_total||v_column_list;
  v_sql := '','';
  v_total  := v_total||v_sql;

------- End Create Partition for RXCOM

------ Start Create Partition for NAVARRO
  v_sql := ''PARTITION  NAVARRO  VALUES (2) TABLESPACE ''||v_tablespace||CHR(13) || CHR(10) || ''(''|| CHR(13) || CHR(10);
  v_total  := v_total||CHR(13) || CHR(10)||v_sql;
  v_column_list := null;
  create_sub_part(v_column_list,''NAVARRO'',v_tablespace);
  v_total  := v_total||v_column_list;
  v_sql := '','';
  v_total  := v_total||v_sql;

------- End Create Partition for NAVARRO

------- Start Create Partition for MEIJER

  v_sql := ''PARTITION  MEIJER  VALUES (3) TABLESPACE ''||v_tablespace||CHR(13) || CHR(10) || ''(''||CHR(13) || CHR(10);
  v_total  := v_total||CHR(13) || CHR(10)||v_sq')||TO_CLOB('l;
  v_column_list := null;
  create_sub_part(v_column_list,''MEIJER'',v_tablespace);
  v_total  := v_total||v_column_list;
  v_sql := '','';
  v_total  := v_total||v_sql;

------ End Create Partition for NAVARRO

------ Start Create Partition for KERR

  v_sql := ''PARTITION KERR VALUES (4) TABLESPACE ''||v_tablespace||CHR(13) || CHR(10) || ''(''||CHR(13) || CHR(10);
  v_total  := v_total||CHR(13) || CHR(10)||v_sql;
  v_column_list := null;
  create_sub_part(v_column_list,''KERR'',v_tablespace);
  v_total  := v_total||v_column_list;
  v_sql := '','';
  v_total  := v_total||v_sql;

------ End Create Partition for NAVARRO

------ Start Create Partition for Default/Other

  v_sql := ''PARTITION OTHER VALUES (DEFAULT) TABLESPACE ''||v_tablespace||CHR(13) || CHR(10) || ''(''||CHR(13) || CHR(10);
  v_total  := v_total||CHR(13) || CHR(10)||v_sql;

  v_column_list := null;
  create_sub_part(v_column_list,''OTHER'',v_tablespace);
  v_total  := v_total||v_column_list;
  ------ End Create Partition  for Default/Other

  v_sql := '')'';
  v_total  := v_total||v_sql;
  --- End Partition Create
  --- End Create Table
  else
   raise_application_error (-20001, ''Source table ''||v_owner||'',''||v_table_name||'' not exists'');
  END IF;
END create_sub_part_tab;

/** Following procedure replace string from clob **/

procedure lob_replace( p_lob in out clob, p_what in varchar2, p_with in varchar2 )as
n number;
begin
n := dbms_lob.instr( p_lob, p_what );
if ( nvl(n,0) > 0 )
then
dbms_lob.copy( p_lob,
p_lob,
dbms_lob.getlength(p_lob),
n+length(p_with),
n+length(p_what) );
dbms_lob.write( p_lob, length(p_with), n, p_with );
if ( length(p_what) > length(p_with) )
then
dbms_lob.trim( p_lob,
dbms_lob.getlength(p_lob)-(length(p_what)-length(p_with)) );
end if;
end if;
end lob_replace;


procedure insert_to_obj_map
(
CHANGE_REQUEST in varchar2,
OBJECT_OWNER in varchar2,
OBJECT_NAME  in varchar2,
OBJECT_TYPE  in varchar2,
SOURCE_TABLE in varchar2,
REDEF_OWNER in varchar2,
REDEF_OBJECT_NAME in varchar2 default null,
R')||TO_CLOB('EDEF_TAB_NAME in varchar2,
REDEF_SQL in clob default null,
REDEF_STATUS  in varchar2 default null,
RENAME_STATUS in varchar2 default null
) AS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
if CHANGE_REQUEST=''I'' then

insert into object_mapping values
(
OBJECT_OWNER,
OBJECT_NAME,
OBJECT_TYPE,
SOURCE_TABLE,
REDEF_OWNER,
REDEF_OBJECT_NAME,
REDEF_TAB_NAME,
REDEF_SQL,
REDEF_STATUS,
RENAME_STATUS
);
elsif  CHANGE_REQUEST=''U'' THEN
update object_mapping
set rename_status=RENAME_STATUS
where object_owner= object_owner
and  object_name= object_name
and object_type = object_type
and source_table = source_table
and redef_owner = redef_owner
and redef_table = REDEF_TAB_NAME;
end if;


commit;

end insert_to_obj_map;




procedure lob_line_search( input_lob in out clob, input_string in varchar2)as
string_pos number :=0;
l_begin number :=0;
l_end number :=0;
temp_lob clob := EMPTY_CLOB();
begin_string varchar2(10) :=''ALTER'';
end_string varchar2(10) :='';'';
occur number := 1;

begin
string_pos := dbms_lob.instr( input_lob, input_string );
if ( nvl(string_pos,0) > 0 ) THEN
l_end := DBMS_LOB.INSTR(input_lob,end_string,string_pos,1);



dbms_lob.read(input_lob,l_end,1,temp_lob);
--dbms_output.put_line(temp_lob);
WHILE DBMS_LOB.INSTR(temp_lob,begin_string,1,occur) > 0
 LOOP
 l_begin   := DBMS_LOB.INSTR(temp_lob,begin_string,1,occur);
 occur := occur + 1;
END LOOP;
--dbms_output.put_line(''Alter Postion :''||l_begin);
--dbms_output.put_line(''String Postion :''||string_pos);
--dbms_output.put_line(''Semicolon Postion :''||l_end);

input_lob := dbms_lob.substr(temp_lob,(l_end - l_begin ),l_begin);
end if;
end lob_line_search;


procedure rep_table_from_trig ( input_lob in out clob, input_string in varchar2, convet_string in varchar2) as
starting_point varchar2(10) :=''ON'';
starting_pos number;
table_pos number;

BEGIN
starting_pos := dbms_lob.instr( input_lob, starting_point );
if ( nvl(starting_pos,0) > 0 ) THEN
input_lob := regexp_replace (input_lob, input_string, convet_string, starting_pos);
end if;
')||TO_CLOB('end rep_table_from_trig;



function abbrev ( object_name VARCHAR2 ) RETURN VARCHAR2 as
rtn  VARCHAR2(50) := object_name;
done BOOLEAN      := false;
begin
if length(rtn)  <=25 then
return rtn;
end if;
if length(rtn) > 25 then rtn := REPLACE(rtn, ''PACKAGE'',''PKG'');         end if;
if length(rtn) > 25 then rtn := REPLACE(rtn, ''SHIPPING'',''SHPNG'');      end if;
if length(rtn) > 25 then rtn := REPLACE(rtn, ''REDEF'', ''RDF'');          end if;
if length(rtn) > 25 then rtn := REPLACE(rtn, ''RETURN'',''RET'');          end if;
if length(rtn) > 25 then rtn := REPLACE(rtn, ''ADJUSTMENT'',''ADJ'');      end if;
if length(rtn) > 25 then rtn := REPLACE(rtn, ''REQUEST'',''REQ'');         end if;
if length(rtn) > 25 then rtn := REPLACE(rtn, ''PURCHASE'',''PUR'');         end if;
if length(rtn) > 25 then rtn := REPLACE(rtn, ''ERROR'',''ERR'');           end if;
if length(rtn) > 30 then raise_application_error(-20001, ''Unable to abbreviate ''||object_name||'' to under 30 characters''); end if;
return rtn;
end abbrev;



BEGIN

v_rdef_table :=abbrev(upper(v_table_name)||''_REDEF'');


------ Step 1 : Create Redefination Table
create_sub_part_tab(v_metadata,v_owner,v_table_name,v_rdef_table);


BEGIN
execute immediate v_metadata;
execute immediate ''INSERT INTO ''||v_owner||''.''||v_rdef_table||''(SELECT * FROM ''||v_owner||''.''||v_table_name||'')'';
commit;
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => upper(v_table_name),
OBJECT_TYPE =>  ''TABLE'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => upper(v_rdef_table),
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_metadata,
REDEF_STATUS => ''SUCESS''
);
EXCEPTION
  WHEN OTHERS THEN
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => upper(v_table_name),
OBJECT_TYPE =>  ''TABLE'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => upper(v_rdef_table),
REDE')||TO_CLOB('F_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_metadata,
REDEF_STATUS => ''FAILED''
);
RAISE;
END;




------ Step 2: Create Check-Constraint

dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''CONSTRAINTS_AS_ALTER'', TRUE );
dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''STORAGE'', false );
dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''SEGMENT_ATTRIBUTES'', false );
dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''SQLTERMINATOR'', false );


for c1 in cur_con
LOOP


if c1.constraint_type like ''C'' then
select dbms_metadata.get_ddl(''CONSTRAINT'',c1.constraint_name,v_owner) into v_metadata from dual;
lob_replace(v_metadata,upper(v_table_name),ltrim(upper(v_rdef_table)));

if c1.constraint_name not like ''SYS%'' THEN
v_obj_name :=abbrev(upper(v_rdef_table)||''_CHK''||c1.con_count);
lob_replace(v_metadata,upper(c1.constraint_name),v_obj_name);
end if;



BEGIN
execute immediate v_metadata;
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c1.constraint_name,
OBJECT_TYPE =>  ''CHECK_CONSTRANINT'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => ''N/A'',
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_metadata,
REDEF_STATUS => ''SUCESS''
);
EXCEPTION
  WHEN OTHERS THEN
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c1.constraint_name,
OBJECT_TYPE =>  ''CHECK_CONSTRANINT'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => ''N/A'',
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_metadata,
REDEF_STATUS => ''FAILED''
);
RAISE;
END;

elsif c1.constraint_type like ''P'' then
select dbms_metadata.get_ddl(''CONSTRAINT'',c1.constraint_name,v_owner) into v_metadata from dual;
lob_replace(v_metadata,upper(v_table_name),ltrim(upper(v_rdef_table)));
lob_replace(v_metadata,upper(c1.constraint_name)')||TO_CLOB(',ltrim(upper(v_rdef_table))||''_PK'');

BEGIN
execute immediate v_metadata;
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c1.constraint_name,
OBJECT_TYPE =>  ''PRIMARY_KEY'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => ltrim(upper(v_rdef_table))||''_PK'',
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_metadata,
REDEF_STATUS => ''SUCESS''
);
EXCEPTION
  WHEN OTHERS THEN
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c1.constraint_name,
OBJECT_TYPE =>  ''PRIMARY_KEY'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => ltrim(upper(v_rdef_table))||''_PK'',
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_metadata,
REDEF_STATUS => ''FAILED''
);
RAISE;
END;
elsif c1.constraint_type like ''U'' then
select dbms_metadata.get_ddl(''CONSTRAINT'',c1.constraint_name,v_owner) into v_metadata from dual;
lob_replace(v_metadata,upper(v_table_name),ltrim(upper(v_rdef_table)));
lob_replace(v_metadata,upper(c1.constraint_name),upper(v_rdef_table)||''_UK''||c1.con_count);

BEGIN
execute immediate v_metadata;
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c1.constraint_name,
OBJECT_TYPE =>  ''UNIQUE_KEY'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => upper(v_rdef_table)||''_UK''||c1.con_count,
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_metadata,
REDEF_STATUS => ''SUCESS''
);
EXCEPTION
  WHEN OTHERS THEN
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c1.constraint_name,
OBJECT_TYPE =>  ''UNIQUE_KEY'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => upper(v_rdef_table)||''_UK''||c1.con_count,
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>  ')||TO_CLOB(' v_metadata,
REDEF_STATUS => ''FAILED''
);
RAISE;
END;
end if;

END LOOP;


------ Step 3: Add default value to the column


for c14 in
(select owner,table_name, column_name , data_type , data_default
from dba_tab_columns where owner=upper(v_owner)
and table_name=upper(v_table_name)
and data_default is not null)
LOOP
v_metadata := ''ALTER TABLE ''||v_owner||''.''||v_rdef_table||'' MODIFY ''||c14.column_name||'' DEFAULT ''||c14.data_default;

BEGIN
execute immediate v_metadata;
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c14.column_name,
OBJECT_TYPE =>  ''DEFAULT_VALUE'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => ''N/A'',
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_metadata,
REDEF_STATUS => ''SUCESS''
);
EXCEPTION
  WHEN OTHERS THEN
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c14.column_name,
OBJECT_TYPE =>  ''DEFAULT_VALUE'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => ''N/A'',
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_metadata,
REDEF_STATUS => ''FAILED''
);
RAISE;
END;
END LOOP;



------ Step 4: Add default value to the column


for c13 in
(select owner,table_name, column_name , data_type , data_default
from dba_tab_columns where owner=upper(v_owner)
and table_name=upper(v_table_name)
and data_default is not null)
LOOP
v_metadata := ''ALTER TABLE ''||v_owner||''.''||v_rdef_table||'' MODIFY ''||c13.column_name||'' DEFAULT ''||c13.data_default;

BEGIN
execute immediate v_metadata;
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c13.column_name,
OBJECT_TYPE =>  ''DEFAULT_VALUE'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => ''N/A'',
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_metadata,
REDEF_STATUS => ''SUCESS''
);
EX')||TO_CLOB('CEPTION
  WHEN OTHERS THEN
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c13.column_name,
OBJECT_TYPE =>  ''DEFAULT_VALUE'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => ''N/A'',
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_metadata,
REDEF_STATUS => ''FAILED''
);
RAISE;
END;

END LOOP;








------ Step 5: Create Ref-constraint but disabled

BEGIN
dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''SQLTERMINATOR'', TRUE );
select dbms_metadata.get_dependent_ddl(''REF_CONSTRAINT'',v_table_name,v_owner) into v_metadata from dual;
EXCEPTION
  when NO_META_FOUND then null;
END;


FOR c2 in ref_con
LOOP
v_templine := v_metadata;
lob_line_search(v_templine,c2.constraint_name);
lob_replace(v_templine,upper(v_table_name),ltrim(upper(v_rdef_table)));
--v_templine :=REGEXP_REPLACE(v_templine,upper(v_table_name),ltrim(upper(v_rdef_table)));
v_obj_name := abbrev(upper(v_rdef_table)||''_FK''||c2.con_count);
--v_templine :=REGEXP_REPLACE(v_templine,upper(c2.constraint_name),v_obj_name);
lob_replace(v_templine,upper(c2.constraint_name),v_obj_name);
v_templine :=REGEXP_REPLACE(v_templine,''ENABLE'',''DISABLE'');
BEGIN
execute immediate v_templine;
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c2.constraint_name,
OBJECT_TYPE =>  ''FOREIGN_KEY'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => v_obj_name,
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_templine,
REDEF_STATUS => ''SUCESS''
);
EXCEPTION
  WHEN OTHERS THEN
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c2.constraint_name,
OBJECT_TYPE =>  ''FOREIGN_KEY'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => v_obj_name,
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_t')||TO_CLOB('empline,
REDEF_STATUS => ''FAILED''
);
RAISE;
END;
END LOOP;


------ Step 6: Create Trigger
for c3 in
(
 select upper(trigger_name) trigger_name, upper(trigger_type) trigger_type,
        trigger_type||'' ''||triggering_event as trig_type
     from  dba_triggers
     where table_name=upper(v_table_name)
     and   table_owner=upper(v_owner)
)
LOOP

dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''SQLTERMINATOR'', false );
select dbms_metadata.get_ddl(''TRIGGER'',c3.trigger_name,v_owner) into v_metadata from dual;
rep_table_from_trig(v_metadata,v_table_name,v_rdef_table);
v_metadata := SUBSTR(v_metadata,1,INSTR(v_metadata,''ALTER'',1,1)-1);


if c3.trig_type like ''%AFTER EACH ROW UPDATE%'' then
v_obj_name :=abbrev(upper(v_rdef_table)||''_TRIG_AUR'');
lob_replace(v_metadata,c3.trigger_name,v_obj_name);
elsif c3.trig_type like ''%AFTER EACH ROW INSERT%'' then
v_obj_name :=abbrev(upper(v_rdef_table)||''_TRIG_AIR'');
lob_replace(v_metadata,c3.trigger_name,v_obj_name);
elsif c3.trig_type like ''%AFTER EACH ROW INSERT OR UPDATE%'' then
v_obj_name :=abbrev(upper(v_rdef_table)||''_TRIG_AIUR'');
lob_replace(v_metadata,c3.trigger_name,v_obj_name);
elsif c3.trig_type like ''%BEFORE EACH ROW INSERT%'' then
v_obj_name :=abbrev(upper(v_rdef_table)||''_TRIG_BIR'');
lob_replace(v_metadata,c3.trigger_name,v_obj_name);
elsif c3.trig_type like ''%BEFORE EACH ROW INSERT OR UPDATE%'' then
v_obj_name :=abbrev(upper(v_rdef_table)||''_TRIG_BIUR'');
lob_replace(v_metadata,c3.trigger_name,v_obj_name);
elsif c3.trig_type like ''%AFTER EACH ROW UPDATE OR DELETE%'' then
v_obj_name :=abbrev(upper(v_rdef_table)||''_TRIG_AUDR'');
lob_replace(v_metadata,c3.trigger_name,v_obj_name);
elsif c3.trig_type like ''%BEFORE EACH ROW INSERT OR UPDATE OR DELETE%'' then
v_obj_name :=abbrev(upper(v_rdef_table)||''_TRIG_BIUDR'');
lob_replace(v_metadata,c3.trigger_name,v_obj_name);
elsif c3.trig_type like ''%BEFORE EACH ROW DELETE%'' then
v_obj_name :=abbrev(upper(v_rdef_table)||''_TRIG_BDR'');
lob_replace(v_metadata,c3.trigger_name,')||TO_CLOB('v_obj_name);
elsif c3.trig_type like ''%AFTER EACH ROW DELETE%'' then
v_obj_name :=abbrev(upper(v_rdef_table)||''_TRIG_ADR'');
lob_replace(v_metadata,c3.trigger_name,v_obj_name);
end if;

BEGIN
execute immediate v_metadata;
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c3.trigger_name,
OBJECT_TYPE =>  ''TRIGGER'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => v_obj_name,
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_metadata,
REDEF_STATUS => ''SUCESS''
);
EXCEPTION
  WHEN OTHERS THEN
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c3.trigger_name,
OBJECT_TYPE =>  ''TRIGGER'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => v_obj_name,
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_metadata,
REDEF_STATUS => ''FAILED''
);
RAISE;
END;
--dbms_output.put_line(v_metadata);
END LOOP;

------ Step 7: Create Index

dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''SQLTERMINATOR'',TRUE,''INDEX'');
dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''SEGMENT_ATTRIBUTES'', TRUE , ''INDEX'' );
dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''STORAGE'', TRUE, ''INDEX'' );
dbms_metadata.set_transform_param(DBMS_METADATA.SESSION_TRANSFORM,''TABLESPACE'',TRUE,''INDEX'');
dbms_metadata.set_transform_param(dbms_metadata.session_transform,''PARTITIONING'',TRUE,''INDEX'');

for c4 in
(  select owner,index_name,partitioned,row_number()OVER(PARTITION BY
owner order by index_name ) CON_COUNT
from dba_indexes
where  table_owner=upper(v_owner)
and table_name=upper(v_table_name)
and index_type not in (''LOB'')
and (index_name,owner) not in (select constraint_name,owner from dba_constraints
     where table_name=upper(v_table_name)
     and   table_owner=upper(v_owner)
     and status=''ENABLED''))
LOOP



if c4.partitioned =''YES'' THE')||TO_CLOB('N
dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''SQLTERMINATOR'',FALSE,''INDEX'');
dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''SEGMENT_ATTRIBUTES'', TRUE , ''INDEX'' );
dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''STORAGE'', TRUE, ''INDEX'' );
dbms_metadata.set_transform_param(dbms_metadata.session_transform,''PARTITIONING'',TRUE,''INDEX'');
select dbms_metadata.get_ddl(''INDEX'',c4.index_name,v_owner) into v_metadata from dual;
v_metadata := SUBSTR(v_metadata,1,INSTR(v_metadata,''(PARTITION'',1,1)-1);
else
dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''SQLTERMINATOR'',FALSE,''INDEX'');
dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''SEGMENT_ATTRIBUTES'', TRUE , ''INDEX'' );
dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''STORAGE'', TRUE, ''INDEX'' );
dbms_metadata.set_transform_param(dbms_metadata.session_transform,''PARTITIONING'',FALSE,''INDEX'');
select dbms_metadata.get_ddl(''INDEX'',c4.index_name,v_owner) into v_metadata from dual;
v_metadata := v_metadata||'' LOCAL'';
end if;
v_obj_name :=abbrev(upper(v_rdef_table)||''_IX''||c4.con_count);
v_metadata := REGEXP_REPLACE(v_metadata,c4.index_name,v_obj_name);
rep_table_from_trig(v_metadata,upper(v_table_name),upper(v_rdef_table));
--dbms_output.put_line(v_metadata);

BEGIN
execute immediate v_metadata;
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c4.index_name,
OBJECT_TYPE =>  ''INDEX'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => v_obj_name,
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_metadata,
REDEF_STATUS => ''SUCESS''
);
EXCEPTION
  WHEN OTHERS THEN
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => c4.index_name,
OBJECT_TYPE =>  ''INDEX'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => v_')||TO_CLOB('obj_name,
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_metadata,
REDEF_STATUS => ''FAILED''
);
RAISE;
END;
--dbms_output.put_line(v_metadata);
END LOOP;


------ Step 8: Apply Table Grants


for c13 in
(
select  grantee, privilege, grantable  from dba_tab_privs where table_name=upper(v_table_name) and owner=upper(v_owner)
)
LOOP

if c13.grantable = ''YES'' THEN
v_line := ''GRANT ''|| c13.privilege ||'' on "''||v_owner||''"."''|| upper(v_rdef_table)||''" to ''||c13.grantee||'' WITH GRANT OPTION'';
elsif c13.grantable = ''NO'' THEN
v_line := ''GRANT ''|| c13.privilege ||'' on "''||v_owner||''"."''|| upper(v_rdef_table)||''" to ''||c13.grantee;
END if;
--- Capture Table Grants
BEGIN
execute immediate v_line;
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME =>  upper(v_table_name),
OBJECT_TYPE =>  ''GRANT'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => upper(v_rdef_table),
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_line,
REDEF_STATUS => ''SUCESS''
);
EXCEPTION
  WHEN OTHERS THEN
insert_to_obj_map
(
CHANGE_REQUEST => ''I'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME =>  upper(v_table_name),
OBJECT_TYPE =>  ''GRANT'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>   sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => upper(v_rdef_table),
REDEF_TAB_NAME => upper(v_rdef_table),
REDEF_SQL =>   v_line,
REDEF_STATUS => ''FAILED''
);
RAISE;
END;
END LOOP;



----- Step 9: Finish the Redefinition

BEGIN
v_metadata := ''ALTER TABLE ''||upper(v_owner)||''.''||upper(v_table_name)||'' RENAME TO ''||upper(v_table_name)||''_BKP'';
execute immediate v_metadata;

v_metadata := ''ALTER TABLE ''||upper(v_owner)||''.''||upper(v_rdef_table)||'' RENAME TO ''||upper(v_table_name);
execute immediate v_metadata;

v_metadata := ''ALTER TABLE ''||upper(v_owner)||''.''||upper(v_table_name)||''_BKP RENAME TO ''||upper(v_rdef_table);
execute immediate v_metadata;

insert_to_obj_map
(
CHANGE_REQUEST => ''U')||TO_CLOB(''',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => upper(v_table_name),
OBJECT_TYPE =>  ''TABLE'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>    sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => upper(v_rdef_table),
REDEF_TAB_NAME => upper(v_rdef_table),
RENAME_STATUS => ''SUCESS''
);
EXCEPTION
  WHEN OTHERS THEN
insert_to_obj_map
(
CHANGE_REQUEST => ''U'',
OBJECT_OWNER => upper(v_owner),
OBJECT_NAME => upper(v_table_name),
OBJECT_TYPE =>  ''TABLE'',
SOURCE_TABLE => upper(v_table_name),
REDEF_OWNER =>    sys_context(''USERENV'', ''CURRENT_SCHEMA''),
REDEF_OBJECT_NAME => upper(v_rdef_table),
REDEF_TAB_NAME => upper(v_rdef_table),
RENAME_STATUS => ''FAILED''
);
RAISE;
END;








----- Step 10: Disable and Drop Source Primary/foreign/Unique Constraints

for c5 in
(select upper(constraint_name) constraint_name, upper(constraint_type) constraint_type, row_number()OVER(PARTITION BY
constraint_type order by constraint_name) CON_COUNT
   from dba_constraints
     where (table_name,owner) in
     (select table_name,owner from dba_tables
          where  table_name= upper(v_rdef_table)
          and owner=v_owner)
     and    constraint_type in (''R''))
LOOP
select redef_status into v_status from OBJECT_MAPPING
 where object_type in (''FOREIGN_KEY'')
 and object_name=c5.constraint_name
 and redef_table=upper(v_rdef_table)
 and object_owner=upper(v_owner);


if v_status =''SUCESS'' THEN
v_metadata := ''ALTER TABLE ''||upper(v_owner)||''.''||upper(v_rdef_table)||'' DISABLE CONSTRAINT ''||upper(c5.constraint_name);
execute immediate v_metadata;
v_metadata := ''ALTER TABLE ''||upper(v_owner)||''.''||upper(v_rdef_table)||'' DROP CONSTRAINT ''||upper(c5.constraint_name);
execute immediate v_metadata;
else
  raise_application_error (-20001,v_owner||''.''||v_table_name||'' : ''||c5.constraint_name||''constraint did not copy sucesfully to redef table'');
end if;


END LOOP;






for c6 in
(
select upper(constraint_name) constraint_name, upper(constraint_type) constraint_type, row_number()OVER (PART')||TO_CLOB('ITION BY
constraint_type order by constraint_name) CON_COUNT
   from dba_constraints
     where table_name=upper(v_rdef_table)
     and    owner=upper(v_owner)
     and    constraint_type in (''P'',''U'')
)
LOOP
select redef_status into v_status from OBJECT_MAPPING
 where object_type in (''PRIMARY_KEY'',''UNIQUE_KEY'')
 and object_name=c6.constraint_name
 and redef_table=upper(v_rdef_table)
 and object_owner=upper(v_owner);


if v_status =''SUCESS'' THEN

if c6.constraint_type = ''P'' then

for c11 in
(
select owner, constraint_name,table_name from dba_constraints
where (r_owner,r_constraint_name)
in
(select owner,constraint_name
   from dba_constraints
     where table_name=upper(v_rdef_table)
     and    owner=upper(v_owner)
     and    constraint_type in (''P'')
     and    constraint_name = c6.constraint_name)
and constraint_type=''R''
)

LOOP
BEGIN
dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM,''SQLTERMINATOR'', TRUE );
select dbms_metadata.get_dependent_ddl(''REF_CONSTRAINT'',c11.table_name,c11.owner) into v_metadata from dual;
EXCEPTION
  when NO_META_FOUND then null;
END;
v_templine := v_metadata;
lob_line_search(v_templine,c11.constraint_name);
v_templine :=REGEXP_REPLACE(v_templine,upper(v_rdef_table),ltrim(upper(v_table_name)));
execute immediate ''ALTER TABLE ''||c11.owner||''.''||c11.table_name||'' DISABLE  CONSTRAINT ''||c11.constraint_name;
execute immediate ''ALTER TABLE ''||c11.owner||''.''||c11.table_name||'' DROP  CONSTRAINT ''||c11.constraint_name;
execute immediate v_templine;
END LOOP;
end if;

v_metadata := ''ALTER TABLE ''||upper(v_owner)||''.''||upper(v_rdef_table)||'' DISABLE CONSTRAINT ''||upper(c6.constraint_name);
execute immediate v_metadata;
v_metadata := ''ALTER TABLE ''||upper(v_owner)||''.''||upper(v_rdef_table)||'' DROP CONSTRAINT ''||upper(c6.constraint_name);
execute immediate v_metadata;

BEGIN
execute immediate ''DROP INDEX  ''||upper(v_owner)||''.''||upper(c6.constraint_name);
EXCEPTION
  when others then null;
END;
else
  raise_application_error (-2000')||TO_CLOB('1,v_owner||''.''||v_table_name||'' : ''||c6.constraint_name||''constraint did not copy sucesfully to redef table'');

end if;
END LOOP;



for c12 in
(
select owner, constraint_name,table_name from dba_constraints
where (r_owner,r_constraint_name)
in
(select owner,constraint_name
   from dba_constraints
     where table_name=upper(v_table_name)
     and    owner=upper(v_owner)
     and    constraint_type in (''P'')
)
and constraint_type=''R''
)
LOOP
v_metadata := ''ALTER TABLE ''||c12.owner||''.''||c12.table_name||'' ENABLE CONSTRAINT ''||upper(c12.constraint_name);
BEGIN
execute immediate v_metadata;
EXCEPTION
  WHEN OTHERS THEN
   if sqlcode =-02298 then
       v_metadata := ''ALTER TABLE ''||c12.owner||''.''||c12.table_name||'' MODIFY CONSTRAINT ''||upper(c12.constraint_name)||'' ENABLE NOVALIDATE'';
       execute immediate v_metadata;
   else
       RAISE;
   end if;
END;




END LOOP;


----- Step 11: Drop Index from Source Table

for c7 in
(
select owner,index_name,partitioned,row_number()OVER(PARTITION BY
index_type order by index_name ) CON_COUNT
from dba_indexes
where  table_owner=upper(v_owner)
and table_name=upper(v_rdef_table)
and index_type not in (''LOB'')
and (index_name,owner) not in (select constraint_name,owner from dba_constraints
     where table_name=upper(v_rdef_table)
     and   owner=upper(v_owner))
)


LOOP
select redef_status into v_status from OBJECT_MAPPING
 where object_type=''INDEX''
 and object_name=c7.index_name
 and redef_table=upper(v_rdef_table)
 and object_owner=upper(v_owner);


if v_status =''SUCESS'' THEN
v_metadata := ''DROP INDEX ''||c7.owner||''.''||c7.index_name;
execute immediate v_metadata;
else
  raise_application_error (-20001,v_owner||''.''||v_table_name||'' : ''||c7.index_name||''index did not copy sucesfully to redef table'');
end if;
END LOOP;


----- Step 12: Rename CONSTRANIT


for c8 in (
select * from OBJECT_MAPPING
 where object_type in (''FOREIGN_KEY'',''UNIQUE_KEY'',''PRIMARY_KEY'')
 and redef_table=upper(v_rdef_table)
 and object_owner=upper(v_owner)
 ')||TO_CLOB(')
LOOP



v_metadata := ''ALTER TABLE ''||upper(v_owner)||''.''||upper(v_table_name)||'' RENAME CONSTRAINT ''||upper(c8.redef_object_name)||'' TO ''||upper(c8.object_name);
execute immediate v_metadata;


if c8.object_type =''FOREIGN_KEY'' then
 v_metadata := ''ALTER TABLE ''||upper(v_owner)||''.''||upper(v_table_name)||'' ENABLE CONSTRAINT ''||upper(c8.object_name);
BEGIN
execute immediate v_metadata;
EXCEPTION
  WHEN OTHERS THEN
   if sqlcode =-02298 then
       v_metadata := ''ALTER TABLE ''||upper(v_owner)||''.''||upper(v_table_name)||'' MODIFY CONSTRAINT ''||upper(c8.object_name)||'' ENABLE NOVALIDATE'';
       execute immediate v_metadata;
   else
       RAISE;
   end if;
END;
end if;
END LOOP;


----- Step 13: Rename INDEX



for c9 in (
select * from OBJECT_MAPPING
 where object_type in (''INDEX'',''PRIMARY_KEY'',''UNIQUE_KEY'')
 and redef_table=upper(v_rdef_table)
 and object_owner=upper(v_owner)
 )
LOOP



BEGIN
v_metadata := ''ALTER INDEX ''||upper(c9.redef_owner)||''.''||upper(c9.redef_object_name)||'' RENAME TO ''||upper(c9.object_name);
execute immediate v_metadata;



insert_to_obj_map
(
CHANGE_REQUEST => ''U'',
OBJECT_OWNER => c9.object_owner,
OBJECT_NAME => c9.object_name,
OBJECT_TYPE =>  c9.object_type,
SOURCE_TABLE => c9.source_table,
REDEF_OWNER =>   c9.redef_owner,
REDEF_OBJECT_NAME => c9.redef_object_name,
REDEF_TAB_NAME => c9.redef_table,
RENAME_STATUS => ''SUCESS''
);
EXCEPTION
  WHEN OTHERS THEN
insert_to_obj_map
(
CHANGE_REQUEST => ''U'',
OBJECT_OWNER => c9.object_owner,
OBJECT_NAME => c9.object_name,
OBJECT_TYPE =>  c9.object_type,
SOURCE_TABLE => c9.source_table,
REDEF_OWNER =>   c9.redef_owner,
REDEF_OBJECT_NAME => c9.redef_object_name,
REDEF_TAB_NAME => c9.redef_table,
RENAME_STATUS => ''FAILED''
);
RAISE;
END;

END LOOP;


---- Step 14 : Drop OLD Trigger and Rename Redef trigger to actual name

for c10 in (
select * from OBJECT_MAPPING
 where object_type in (''TRIGGER'')
 and source_table=upper(v_table_name)
 and object_owner=upper(v_owner)
 )
LOOP


BEGIN
v_metadata := ''DROP TRIG')||TO_CLOB('GER ''||upper(c10.object_owner)||''.''||upper(c10.object_name);
execute immediate v_metadata;
v_metadata := ''ALTER TRIGGER ''||upper(c10.redef_owner)||''.''||upper(c10.redef_object_name)||'' RENAME TO ''||upper(c10.object_name);
execute immediate v_metadata;

insert_to_obj_map
(
CHANGE_REQUEST => ''U'',
OBJECT_OWNER => c10.object_owner,
OBJECT_NAME => c10.object_name,
OBJECT_TYPE =>  c10.object_type,
SOURCE_TABLE => c10.source_table,
REDEF_OWNER =>   c10.redef_owner,
REDEF_OBJECT_NAME => c10.redef_object_name,
REDEF_TAB_NAME => c10.redef_table,
RENAME_STATUS => ''SUCESS''
);
EXCEPTION
  WHEN OTHERS THEN
insert_to_obj_map
(
CHANGE_REQUEST => ''U'',
OBJECT_OWNER => c10.object_owner,
OBJECT_NAME => c10.object_name,
OBJECT_TYPE =>  c10.object_type,
SOURCE_TABLE => c10.source_table,
REDEF_OWNER =>   c10.redef_owner,
REDEF_OBJECT_NAME => c10.redef_object_name,
REDEF_TAB_NAME => c10.redef_table,
RENAME_STATUS => ''FAILED''
);
RAISE;
END;

END LOOP;

END custom_redef;')),
	 ('sbmo.procedure.sp_purge_rx_print_chr.sql',TO_CLOB('
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SBMO"."SP_PURGE_RX_PRINT_CHR" (p_delete_date date default null) AS
BEGIN
   if p_delete_date is null then
      delete from rx_print_chr
           where (tenant_id, rx_id) in (select tenant_id, id from rx_cores where status in (3,4,5));
   else
      delete from rx_print_chr
           where (tenant_id, rx_id) in (select tenant_id, id from rx_cores where status in (3,4,5))
           and created_date <= p_delete_date;
   end if;
   commit;
END SP_PURGE_RX_PRINT_CHR;')),
	 ('sbmo.procedure.update_retail_cost.sql',TO_CLOB('
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SBMO"."UPDATE_RETAIL_COST" IS

cursor c_retail_cost_source is
select drug_id,mail_acq_last_updated,mail_acq,store_acq_last_updated,store_acq
from sbmo.retail_cost
where chain_id=3105660
and vendor_id=1247507
and drug_id in
(select drug_id
from sbmo.retail_cost
where chain_id=3105660
and vendor_id=43038305);


v_counter NUMBER := 0;


BEGIN

--******************************************************************************

-- process through source rows - update retail_cost table
--******************************************************************************


for c_retail_cost_rec in c_retail_cost_source loop

  update sbmo.retail_cost
    set mail_acq_last_updated = c_retail_cost_rec.mail_acq_last_updated,
    mail_acq = c_retail_cost_rec.mail_acq,
    store_acq_last_updated = c_retail_cost_rec.store_acq_last_updated,
    store_acq = c_retail_cost_rec.store_acq
  where chain_id=3105660
  and vendor_id=43038305
  and drug_id=c_retail_cost_rec.drug_id;

  v_counter := v_counter+1;

end loop;
dbms_output.put_line(''Updated ''||v_counter||'' rows in the RETAIL_COST table'');
commit;

-- update SYSTEM_MESSAGES table to prevent SBMO dashboard from being flooded with bogus messages

update SBMO.SYSTEM_MESSAGES set ACKNOWLEDGED_BY=''DWJ'',ACKNOWLEDGED = sysdate
where MESSAGE like ''Store%'' and ACKNOWLEDGED_BY is null;

update SBMO.SYSTEM_MESSAGES set ACKNOWLEDGED_BY=''DWJ'',ACKNOWLEDGED = sysdate
where MESSAGE like ''Mail%'' and ACKNOWLEDGED_BY is null;
commit;
END;')),
	 ('sbmo.procedure.update_shipping.sql',TO_CLOB('
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SBMO"."UPDATE_SHIPPING" (p_order_number number,p_ounces float,p_tracking_number
varchar2,p_true_ship_amt number, p_ship_name varchar2)
is
cursor c_ship_pack is
select shipping_package_id
from sbmo.rx_cores
where order_id =
(select id from sbmo.orders
where order_number=p_order_number);
begin
for r_ship_pack in c_ship_pack loop
update sbmo.rx_shipping_packages
set ounces=p_ounces,tracking_number=p_tracking_number,true_ship_amt=p_true_ship_amt,carrier=p_ship_name
where id=r_ship_pack.shipping_package_id;
end loop;
commit;
end;'));

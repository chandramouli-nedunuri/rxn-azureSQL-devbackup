
  CREATE OR REPLACE EDITIONABLE PACKAGE "SBMO"."ROTATE_PARTITIONS_PKG" as

  procedure create_partitions;

end rotate_partitions_pkg;
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SBMO"."ROTATE_PARTITIONS_PKG" as

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
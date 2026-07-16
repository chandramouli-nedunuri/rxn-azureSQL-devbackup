-- ========================================================
-- ORACLE PKG_SBMO_PURGE - EXECUTABLE CODE ONLY (NO COMMENTS)
-- ========================================================

CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SBMO"."PKG_SBMO_PURGE" 
AS
-- PACKAGE-LEVEL VARIABLES
b_SqlCode                       NUMBER                                 := NULL;
b_SqlErrm                       PURGE_ERROR_LOG.SQL_ERRM%TYPE   := NULL;
b_ErrDate                       VARCHAR2(55)                           := 'to_date('''||to_char(sysdate, 'mm/dd/yyyy hh24:mi:ss')||''',''mm/dd/yyyy hh24:mi:ss'')';
b_WindowEnd                     DATE                                   := NULL;
b_NbrHoursInWindow      NUMBER                                         := NULL;
b_DefPartMins           NUMBER                                         := NULL;
b_ChunkSize                     NUMBER                                 := NULL;
b_ParallelChunkCount            NUMBER                                 := NULL;
b_ParallelQueryCount    NUMBER                                         := NULL;
b_RetryCount            NUMBER                                         := NULL;
b_SleepTime                     NUMBER                                 := NULL;
b_MultiBlock            NUMBER                                         := NULL;
b_OrigMultiBlock        NUMBER                                         := NULL;
b_OrigOptimizerMode     VARCHAR2(50)                                   := NULL;
b_JobClass                      VARCHAR2(30)                           := NULL;
b_AppMonthsToKeep       NUMBER                                         := NULL;
b_PurgeMonthsToKeep     NUMBER                                         := NULL;
b_MailHost                      VARCHAR2(255)                          := NULL;
b_MailPort                      VARCHAR2(255)                          := NULL;
b_MailFrom                      VARCHAR2(255)                          := NULL;
b_MailTo                        VARCHAR2(255)                          := NULL;
b_PageTo                        VARCHAR2(255)                          := NULL;
b_ForceRestart          CHAR(1)                                        := NULL;
b_SubpartOptMode        VARCHAR2(255)                                  := NULL;
b_MaxDaysToPurge        NUMBER                                         := NULL;

-- FUNCTIONS
FUNCTION Fn_Test
(
p_Test1         IN      VARCHAR2
)
RETURN VARCHAR2
IS
        v_Return                        VARCHAR2(30)            := NULL;
BEGIN
        NULL;
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

FUNCTION Fn_SplitString
(
p_String        IN      VARCHAR2,
p_Delimiter     IN      CHAR                    DEFAULT ','
)
RETURN tbl_Strings
PIPELINED
IS
        cursor  c_Strings
                        (
                        p_String                varchar2,
                        p_Delim                 varchar2
                        )
        is
                        select  regexp_substr( p_String,'[^' || p_Delim || ']+', 1, level) as string_val
                        from    dual
                        connect by regexp_substr( p_String, '[^' || p_Delim || ']+', 1, level) is not null;
BEGIN
        for lr in c_Strings( p_String, p_Delimiter ) loop
                PIPE ROW( lr.string_val );
        end loop;
        RETURN;
EXCEPTION
        WHEN NO_DATA_NEEDED THEN
                NULL;
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

FUNCTION Fn_KeepRunning
RETURN BOOLEAN
IS
        f_Running                       purge_run_check.purge_running%TYPE      := null;
BEGIN
        select  purge_running
        into    f_Running
        from    purge_run_check;
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

FUNCTION Fn_GetMonthsToKeep
(
p_TableName     IN      VARCHAR2
)
RETURN NUMBER
IS
        f_Months                        NUMBER                         := NULL;
BEGIN
        if( p_TableName = 'PURGE_HISTORY' ) then
                f_Months := b_PurgeMonthsToKeep;
        else
                f_Months := b_AppMonthsToKeep;
        end if;
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

FUNCTION Fn_GetPurgeDate
(
p_TableName     IN      VARCHAR2
)
RETURN DATE
IS
        v_MonthsToKeep          NUMBER                          := NULL;
        f_PurgePos                      NUMBER                         := NULL;
        f_MinPurgePos           NUMBER                          := NULL;
        f_Date                          DATE                           := NULL;
BEGIN
        select  purge_position
        into    f_PurgePos
        from    purge_tables
        where   table_name = p_TableName;
        select  min(purge_position)
        into    f_MinPurgePos
        from    purge_tables;
        if( f_PurgePos = f_MinPurgePos ) then
                f_Date := null;
        else
                begin
                        select  max(h.purge_date)
                        into    f_Date
                        from    purge_history h,
                                        purge_tables t
                        where   h.table_name = t.table_name
                                        and t.purge_position = f_MinPurgePos;
                exception
                        when no_data_found then
                                f_Date := null;
                end;
        end if;
        if( f_Date is null ) then
                v_MonthsToKeep := Fn_GetMonthsToKeep(p_TableName);
                select  min(purge_date)
                into    f_Date
                from    (
                                select add_months( sysdate, -v_MonthsToKeep ) as purge_date
                                from dual
                                union
                                select  min(created_date) + b_MaxDaysToPurge as purge_date
                                from rx_cores
                                );
        end if;
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

-- KEY PATTERNS:
-- 1. master_seq.nextval generates sequence IDs
-- 2. systimestamp captures timestamps
-- 3. Error logging: INSERT INTO purge_error_log with generated ID
-- 4. Exception handling: WHEN ... THEN blocks with RAISE
-- 5. Transaction control: commit/rollback patterns
-- 6. Cursor loops: FOR lr IN cursor LOOP ... END LOOP
-- 7. Dynamic conditions: IF/ELSE with Boolean returns
-- 8. String concatenation: || operator
-- 9. Date arithmetic: add_months(), trunc()
-- 10. PIPELINED functions: PIPE ROW() pattern for returning rows

END "PKG_SBMO_PURGE";
/

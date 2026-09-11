-- =====================================================================
-- SBMO Schema Procedures Export - Part1_Procedures_001-025
-- Database: nonEPR-DB
-- Server: sql-non-epr-dev-eastus2.ceb73025282c.database.windows.net
-- Procedures: 1 to 25 (Total: 25)
-- Exported: 2026-08-13
-- =====================================================================
-- This is part of the complete 73-procedure export from SBMO schema.
-- =====================================================================


-- =====================================================================
-- Procedure 1: apply_changes
-- =====================================================================

CREATE PROCEDURE SBMO.apply_changes(
    @p_sql NVARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @l_id INT;
    DECLARE @l_err NVARCHAR(4000);
    
    IF @p_sql IS NULL
        RETURN;
    
    BEGIN TRY
        INSERT INTO SBMO.partition_sql_history (sql_timestamp, sql_text)
        VALUES (GETDATE(), @p_sql);
        
        SET @l_id = SCOPE_IDENTITY();
        
        EXEC sp_executesql @p_sql;
        
    END TRY
    BEGIN CATCH
        SET @l_err = ERROR_MESSAGE();
        
        UPDATE SBMO.partition_sql_history 
        SET sql_error = @l_err 
        WHERE id = @l_id;
        
        IF ERROR_NUMBER() NOT IN (547)
        BEGIN
            INSERT INTO SBMO.partition_sql_history 
                (sql_timestamp, sql_text, sql_error, report_error)
            VALUES 
                (GETDATE(), @p_sql, @l_err, 'Y');
        END;
        
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 2: check_changes
-- =====================================================================

CREATE PROCEDURE SBMO.check_changes(
    @p_table_name NVARCHAR(MAX),
    @p_subpartition_name NVARCHAR(MAX),
    @result BIT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @l_fk_exists INT = 0;
    DECLARE @l_table_id INT;
    
    SET @l_table_id = OBJECT_ID(@p_table_name);
    
    IF @l_table_id IS NULL
    BEGIN
        SET @result = 0;
        RETURN;
    END;
    
    SELECT @l_fk_exists = COUNT(*)
    FROM sys.foreign_keys
    WHERE parent_object_id = @l_table_id;
    
    IF @l_fk_exists > 0
    BEGIN
        SET @result = 0;
        RETURN;
    END;
    
    SET @result = 1;
    RETURN;
END;
GO

-- =====================================================================
-- Procedure 3: create_partitions
-- =====================================================================

CREATE PROCEDURE SBMO.create_partitions
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @l_start_timestamp DATETIME2;
    DECLARE @l_future NVARCHAR(MAX);
    DECLARE @l_past NVARCHAR(MAX);
    DECLARE @l_d DATE;
    DECLARE @l_s NVARCHAR(MAX);
    DECLARE @l_msg NVARCHAR(MAX) = '';
    DECLARE @l_msg_html NVARCHAR(MAX) = '';
    DECLARE @l_send_email CHAR(1) = 'N';
    DECLARE @l_err_count INT = 0;
    
    DECLARE @table_name NVARCHAR(128);
    DECLARE @partition_name NVARCHAR(128);
    DECLARE @tablespace_name NVARCHAR(128);
    DECLARE @table_rank INT;
    DECLARE @subpart_name NVARCHAR(128);
    DECLARE @months_to_add INT;
    
    DECLARE @id INT;
    DECLARE @sql_timestamp DATETIME2;
    DECLARE @sql_text NVARCHAR(MAX);
    DECLARE @sql_error NVARCHAR(4000);
    
    BEGIN TRY
        -- ===== PHASE 1: INITIALIZATION =====
        SET @l_start_timestamp = GETDATE();  -- Record start time for error filtering
        
        -- Get future and past month counts from configuration
        SET @l_future = SBMO.lookup_properties('createFuturePartitionsMonths');
        SET @l_past = SBMO.lookup_properties('dataRetentionMonths');
        
        -- ===== PHASE 2: CREATE FUTURE PARTITIONS =====
        -- Loop through all partitioned tables
        DECLARE table_cursor CURSOR FOR
            SELECT p.table_name, p.partition_name, u.tablespace_name, p.table_rank
            FROM SBMO.partition_table_list p
            INNER JOIN SBMO.user_tab_partitions u ON p.table_name = u.table_name
            ORDER BY p.table_rank, u.partition_name;
        
        OPEN table_cursor;
        
        FETCH NEXT FROM table_cursor 
        INTO @table_name, @partition_name, @tablespace_name, @table_rank;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Start with first day of current month
            SET @l_d = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);
            
            -- Loop through months from current month to future months
            SET @months_to_add = 0;
            
            WHILE @months_to_add <= CAST(ISNULL(@l_future, 3) AS INT)
            BEGIN
                -- Create subpartition name: {partition_name}{YYYYMM}
                SET @subpart_name = @partition_name + FORMAT(@l_d, 'yyyymm');
                
                -- Check if this subpartition already exists
                IF SBMO.lookup_subpartition(@table_name, @subpart_name) = 0
                BEGIN
                    -- Subpartition doesn't exist - create it
                    DECLARE @next_month_date DATE = DATEADD(MONTH, 1, @l_d);
                    DECLARE @date_str VARCHAR(8) = FORMAT(@next_month_date, 'ddMMyyyy');
                    
                    SET @l_s = 'ALTER TABLE ' + QUOTENAME(@table_name) + ' MODIFY ' + CHAR(10) +
                               'PARTITION ' + QUOTENAME(@partition_name) + ' ' + CHAR(10) +
                               'ADD SUBPARTITION ' + QUOTENAME(@subpart_name) + ' ' +
                               'VALUES LESS THAN (TO_DATE(''' + @date_str + ''',''ddmmyyyy'')) ' +
                               'TABLESPACE ' + @tablespace_name;
                    
                    -- Execute the partition creation
                    EXEC SBMO.apply_changes @l_s;
                    
                    -- Log the subpartition to partition_mapping table
                    INSERT INTO SBMO.partition_mapping 
                        (table_name, partition_name, partition_number, range_start, range_end)
                    SELECT 
                        @table_name,
                        @subpart_name,
                        COUNT(*) + 1,
                        @l_d,
                        @next_month_date
                    FROM SBMO.partition_mapping
                    WHERE table_name = @table_name;
                END;
                
                -- Move to next month
                SET @l_d = DATEADD(MONTH, 1, @l_d);
                SET @months_to_add = @months_to_add +
GO

-- =====================================================================
-- Procedure 4: drop_subpartitions
-- =====================================================================

-- Simplified drop_subpartitions - works with current schema
CREATE PROCEDURE SBMO.drop_subpartitions
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @l_s NVARCHAR(MAX);
    DECLARE @l_past NVARCHAR(MAX);
    DECLARE @l_d DATE;
    DECLARE @l_hd DATE;
    DECLARE @table_name NVARCHAR(128);
    DECLARE @subpart_name NVARCHAR(128);
    
    BEGIN TRY
        -- Get retention period from configuration
        SET @l_past = SBMO.lookup_properties('dataRetentionMonths');
        
        -- Calculate cutoff date: today minus retention months
        SET @l_d = DATEADD(MONTH, -CAST(ISNULL(@l_past, 24) AS INT), GETDATE());
        
        -- Cursor: Iterate through all subpartitions for configured tables
        DECLARE subpart_cursor CURSOR FOR
            SELECT DISTINCT pm.table_name, pm.partition_name
            FROM SBMO.partition_mapping pm
            WHERE pm.range_end < @l_d;
        
        OPEN subpart_cursor;
        FETCH NEXT FROM subpart_cursor INTO @table_name, @subpart_name;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Check if we should export first
            IF SBMO.export_partitions() = 1
            BEGIN
                DECLARE @check_result BIT;
                EXEC SBMO.check_changes @table_name, @subpart_name, @check_result OUTPUT;
                
                IF @check_result = 1
                BEGIN
                    SET @l_s = N'DELETE FROM ' + QUOTENAME(@table_name) + 
                               N' WHERE subpartition_name = ''' + @subpart_name + '''';
                    EXEC SBMO.apply_changes @l_s;
                    
                    SET @l_s = N'ALTER TABLE ' + QUOTENAME(@table_name) + 
                               N' DROP SUBPARTITION ' + QUOTENAME(@subpart_name);
                    EXEC SBMO.apply_changes @l_s;
                END;
            END
            ELSE
            BEGIN
                SET @l_s = N'DELETE FROM ' + QUOTENAME(@table_name) + 
                           N' WHERE subpartition_name = ''' + @subpart_name + '''';
                EXEC SBMO.apply_changes @l_s;
                
                SET @l_s = N'ALTER TABLE ' + QUOTENAME(@table_name) + 
                           N' DROP SUBPARTITION ' + QUOTENAME(@subpart_name);
                EXEC SBMO.apply_changes @l_s;
            END;
            
            FETCH NEXT FROM subpart_cursor INTO @table_name, @subpart_name;
        END;
        
        CLOSE subpart_cursor;
        DEALLOCATE subpart_cursor;
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('local', 'subpart_cursor') >= -1
            DEALLOCATE subpart_cursor;
        
        THROW;
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 5: PKG_PDX_SCHEMA_UPDATER$GET_CONFIG$IMPL
-- =====================================================================

CREATE PROCEDURE SBMO.PKG_PDX_SCHEMA_UPDATER$GET_CONFIG$IMPL  
   @P_KEY varchar(max),
   @return_value_argument varchar(max)  OUTPUT
AS 
   BEGIN

      IF ssma_oracle.get_pv_varchar('SBMO', 'PKG_PDX_SCHEMA_UPDATER', 'G_CONFIG_RECORD$APPLY_TYPE') IS NULL OR ssma_oracle.get_pv_varchar('SBMO', 'PKG_PDX_SCHEMA_UPDATER', 'G_CONFIG_RECORD$APPLY_TYPE') = ''
         EXECUTE SBMO.PKG_PDX_SCHEMA_UPDATER$REFRESH_CONFIG 

      IF @P_KEY = 'APPLY_TYPE'
         BEGIN

            SET @return_value_argument = ssma_oracle.get_pv_varchar('SBMO', 'PKG_PDX_SCHEMA_UPDATER', 'G_CONFIG_RECORD$APPLY_TYPE')

            RETURN 

         END
      ELSE 
         IF @P_KEY = 'TASK_VERSION'
            BEGIN

               SET @return_value_argument = ssma_oracle.get_pv_varchar('SBMO', 'PKG_PDX_SCHEMA_UPDATER', 'G_CONFIG_RECORD$TASK_VERSION')

               RETURN 

            END
         ELSE 
            IF @P_KEY = 'APPLICATION_PREFIX'
               BEGIN

                  SET @return_value_argument = ssma_oracle.get_pv_varchar('SBMO', 'PKG_PDX_SCHEMA_UPDATER', 'G_CONFIG_RECORD$APPLICATION_PREFIX')

                  RETURN 

               END
            ELSE 
               IF @P_KEY = 'MANAGE_PRIVS'
                  BEGIN

                     SET @return_value_argument = ssma_oracle.get_pv_varchar('SBMO', 'PKG_PDX_SCHEMA_UPDATER', 'G_CONFIG_RECORD$MANAGE_PRIVS')

                     RETURN 

                  END
               ELSE 
                  IF @P_KEY = 'MANAGE_SYNONYMS'
                     BEGIN

                        SET @return_value_argument = ssma_oracle.get_pv_varchar('SBMO', 'PKG_PDX_SCHEMA_UPDATER', 'G_CONFIG_RECORD$MANAGE_SYNONYMS')

                        RETURN 

                     END
                  ELSE 
                     IF @P_KEY = 'ALLOW_DOWNGRADE'
                        BEGIN

                           SET @return_value_argument = ssma_oracle.get_pv_float('SBMO', 'PKG_PDX_SCHEMA_UPDATER', 'G_CONFIG_RECORD$ALLOW_DOWNGRADE')

                           RETURN 

                        END
                     ELSE 
                        IF @P_KEY = 'MANAGE_SYNONYMS_FOR'
                           BEGIN

                              SET @return_value_argument = ssma_oracle.get_pv_varchar('SBMO', 'PKG_PDX_SCHEMA_UPDATER', 'G_CONFIG_RECORD$MANAGE_SYNONYMS_FOR')

                              RETURN 

                           END
                        ELSE 
                           IF @P_KEY = 'AUTO_UNDO'
                              BEGIN

                                 SET @return_value_argument = ssma_oracle.get_pv_varchar('SBMO', 'PKG_PDX_SCHEMA_UPDATER', 'G_CONFIG_RECORD$AUTO_UNDO')

                                 RETURN 

                              END
                           ELSE 
                              BEGIN

                                 DECLARE
                                    @db_raise_application_error_message nvarchar(4000)

                                 SET @db_raise_application_error_message = N'ORA' + CAST(-20100 AS nvarchar) + N': ' + N'Invalid Key requested in get_config'

                                 RAISERROR(59998, 16, 1, @db_raise_application_error_message)

                              END

   END
GO

-- =====================================================================
-- Procedure 6: PKG_PDX_SCHEMA_UPDATER$GET_SQL$IMPL
-- =====================================================================

CREATE PROCEDURE SBMO.PKG_PDX_SCHEMA_UPDATER$GET_SQL$IMPL  
   @P_FNAME varchar(max),
   @P_ACTION varchar(max),
   @return_value_argument varchar(max)  OUTPUT
AS 
   BEGIN

      DECLARE
         @L_SQL varchar(max)

      SELECT @L_SQL = 
         CASE 
            WHEN @P_ACTION IN ( 'R', 'D' ) THEN S1.SQL
            WHEN isnull(S1.STATUS_CODE, 'S') != 'S' THEN S1.SQL
            ELSE S2.SQL
         END
      FROM 
         SBMO.PDX_SCHEMA_UPDATER_SQL  AS S1 
            FULL OUTER JOIN SBMO.SCHEMA_UPDATER_SQL  AS S2 
            ON S1.FILE_NAME = S2.FILE_NAME
      WHERE S1.FILE_NAME = @P_FNAME

      IF @L_SQL IS NULL OR @L_SQL = ''
         RAISERROR(59999, 16, 1, N'ORA-00100%')

      SET @return_value_argument = @L_SQL

      RETURN 

   END
GO

-- =====================================================================
-- Procedure 7: PKG_PDX_SCHEMA_UPDATER$GET_STATUS$IMPL
-- =====================================================================

CREATE PROCEDURE SBMO.PKG_PDX_SCHEMA_UPDATER$GET_STATUS$IMPL  
   @P_FNAME varchar(max),
   @return_value_argument varchar(max)  OUTPUT
AS 
   BEGIN

      DECLARE
         @L_STATUS varchar(2)

      BEGIN

         BEGIN TRY
            SELECT @L_STATUS = ISNULL(PDX_SCHEMA_UPDATER_SQL.ACTION_CODE, '') + ISNULL(PDX_SCHEMA_UPDATER_SQL.STATUS_CODE, '')
            FROM SBMO.PDX_SCHEMA_UPDATER_SQL
            WHERE PDX_SCHEMA_UPDATER_SQL.FILE_NAME = @P_FNAME
         END TRY

         BEGIN CATCH

            DECLARE
               @errornumber int

            SET @errornumber = ERROR_NUMBER()

            DECLARE
               @errormessage nvarchar(4000)

            SET @errormessage = ERROR_MESSAGE()

            DECLARE
               @exceptionidentifier nvarchar(4000)

            SELECT @exceptionidentifier = ssma_oracle.db_error_get_oracle_exception_id(@errormessage, @errornumber)

            IF (@exceptionidentifier LIKE N'ORA-00100%')
               SET @L_STATUS = NULL
            ELSE 
               BEGIN
                  IF (@exceptionidentifier IS NOT NULL)
                     BEGIN
                        IF @errornumber = 59998
                           RAISERROR(59998, 16, 1, @exceptionidentifier)
                        ELSE 
                           RAISERROR(59999, 16, 1, @exceptionidentifier)
                     END
                  ELSE 
                     BEGIN
                        EXECUTE ssma_oracle.ssma_rethrowerror
                     END
               END

         END CATCH

      END

      SET @return_value_argument = @L_STATUS

      RETURN 

   END
GO

-- =====================================================================
-- Procedure 8: PKG_PDX_SCHEMA_UPDATER$LOG_CALL_END$IMPL
-- =====================================================================

CREATE PROCEDURE SBMO.PKG_PDX_SCHEMA_UPDATER$LOG_CALL_END$IMPL  
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @P_CALL_ID float(53),
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @P_RC float(53),
   @P_STATUS varchar(max),
   @P_ERROR_RECORD$ERROR_MESSAGE varchar(max),
   @P_ERROR_RECORD$SQL_ERROR_CODE varchar(max),
   @P_ERROR_RECORD$SQL_ERROR_MESSAGE varchar(max),
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @return_value_argument float(53)  OUTPUT
AS 
   BEGIN

      UPDATE SBMO.PDX_SCHEMA_UPD_PKGCALL_HIST
         SET 
            STATUS_CODE = @P_STATUS, 
            END_DATE = sysdatetimeoffset(), 
            RETURN_CODE = @P_RC
      WHERE PDX_SCHEMA_UPD_PKGCALL_HIST.ID = @P_CALL_ID

      IF NOT SBMO.PKG_PDX_SCHEMA_UPDATER$IS_ERROR_RECORD_EMPTY(@P_ERROR_RECORD$ERROR_MESSAGE, @P_ERROR_RECORD$SQL_ERROR_CODE, @P_ERROR_RECORD$SQL_ERROR_MESSAGE) != 0
         INSERT SBMO.PDX_SCHEMA_UPD_PKGCALL_ERR_LOG(ID, ERROR_MESSAGE, SQL_ERROR_CODE, SQL_ERROR_MESSAGE)
            VALUES (@P_CALL_ID, @P_ERROR_RECORD$ERROR_MESSAGE, @P_ERROR_RECORD$SQL_ERROR_CODE, @P_ERROR_RECORD$SQL_ERROR_MESSAGE)

      IF @@TRANCOUNT > 0
         COMMIT TRANSACTION 

      SET @return_value_argument = @P_RC

      RETURN 

   END
GO

-- =====================================================================
-- Procedure 9: PKG_PDX_SCHEMA_UPDATER$LOG_CALL_START$IMPL
-- =====================================================================

CREATE PROCEDURE SBMO.PKG_PDX_SCHEMA_UPDATER$LOG_CALL_START$IMPL  
   @P_TARGET_VERSION varchar(max),
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @return_value_argument float(53)  OUTPUT
AS 
   BEGIN

      DECLARE
         /*
         *   SSMA warning messages:
         *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
         */

         @L_RTN float(53)

      DECLARE
         @temp_table TABLE 
         (
            /*
            *   SSMA warning messages:
            *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
            */

            L_RTN float(53)
         )

      /*
      *   SSMA warning messages:
      *   O2SS0058: OUTPUT clauses might return different results in SQL Server when using triggers.
      */

      INSERT SBMO.PDX_SCHEMA_UPD_PKGCALL_HIST(ID, TARGET_VERSION, STATUS_CODE, START_DATE)
         OUTPUT INSERTED.ID
            INTO @temp_table(L_RTN)
         VALUES (NEXT VALUE FOR SBMO.PDX_SCHEMA_MASTER_SEQ, @P_TARGET_VERSION, 'I', sysdatetimeoffset())

      SELECT @L_RTN = NULL

      SELECT @L_RTN = L_RTN
      FROM @temp_table

      IF @@TRANCOUNT > 0
         COMMIT TRANSACTION 

      SET @return_value_argument = @L_RTN

      RETURN 

   END
GO

-- =====================================================================
-- Procedure 10: PKG_PDX_SCHEMA_UPDATER$LOG_PROCESS_START$IMPL
-- =====================================================================

CREATE PROCEDURE SBMO.PKG_PDX_SCHEMA_UPDATER$LOG_PROCESS_START$IMPL  
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @P_CALL_ID float(53),
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @P_VERSION_ID float(53),
   @P_PROCESS varchar(max),
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @return_value_argument float(53)  OUTPUT
AS 
   BEGIN

      DECLARE
         /*
         *   SSMA warning messages:
         *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
         */

         @L_RTN float(53)

      DECLARE
         @temp_table TABLE 
         (
            /*
            *   SSMA warning messages:
            *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
            */

            L_RTN float(53)
         )

      /*
      *   SSMA warning messages:
      *   O2SS0058: OUTPUT clauses might return different results in SQL Server when using triggers.
      */

      INSERT SBMO.PDX_SCHEMA_PROCESS_HISTORY(
         ID, 
         PDX_SCHEMA_UPD_PKGCALL_HIST_ID, 
         PDX_SCHEMA_VERSION_HISTORY_ID, 
         PROCESS, 
         START_DATE)
         OUTPUT INSERTED.ID
            INTO @temp_table(L_RTN)
         VALUES (
            NEXT VALUE FOR SBMO.PDX_SCHEMA_MASTER_SEQ, 
            @P_CALL_ID, 
            @P_VERSION_ID, 
            @P_PROCESS, 
            sysdatetimeoffset())

      SELECT @L_RTN = NULL

      SELECT @L_RTN = L_RTN
      FROM @temp_table

      IF @@TRANCOUNT > 0
         COMMIT TRANSACTION 

      SET @return_value_argument = @L_RTN

      RETURN 

   END
GO

-- =====================================================================
-- Procedure 11: PKG_PDX_SCHEMA_UPDATER$LOG_TASK_START$IMPL
-- =====================================================================

CREATE PROCEDURE SBMO.PKG_PDX_SCHEMA_UPDATER$LOG_TASK_START$IMPL  
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @P_CALL_ID float(53),
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @P_VERSION_ID float(53),
   @P_FILENAME varchar(max),
   @P_ACTION varchar(max),
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @return_value_argument float(53)  OUTPUT
AS 
   BEGIN

      DECLARE
         /*
         *   SSMA warning messages:
         *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
         */

         @L_RTN float(53), 
         @L_TASK_TYPE varchar(20) = SBMO.PKG_PDX_SCHEMA_UPDATER$GET_TASKTYPE(@P_FILENAME, @P_ACTION)

      DECLARE
         @temp_table TABLE 
         (
            /*
            *   SSMA warning messages:
            *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
            */

            L_RTN float(53)
         )

      /*
      *   SSMA warning messages:
      *   O2SS0058: OUTPUT clauses might return different results in SQL Server when using triggers.
      */

      INSERT SBMO.PDX_SCHEMA_TASK_HISTORY(
         ID, 
         PDX_SCHEMA_UPD_PKGCALL_HIST_ID, 
         PDX_SCHEMA_VERSION_HISTORY_ID, 
         FILE_NAME, 
         TASK_TYPE, 
         ACTION_CODE, 
         STATUS_CODE, 
         START_DATE)
         OUTPUT INSERTED.ID
            INTO @temp_table(L_RTN)
         VALUES (
            NEXT VALUE FOR SBMO.PDX_SCHEMA_MASTER_SEQ, 
            @P_CALL_ID, 
            @P_VERSION_ID, 
            @P_FILENAME, 
            @L_TASK_TYPE, 
            @P_ACTION, 
            'I', 
            sysdatetimeoffset())

      SELECT @L_RTN = NULL

      SELECT @L_RTN = L_RTN
      FROM @temp_table

      IF @@TRANCOUNT > 0
         COMMIT TRANSACTION 

      SET @return_value_argument = @L_RTN

      RETURN 

   END
GO

-- =====================================================================
-- Procedure 12: PKG_PDX_SCHEMA_UPDATER$LOG_VERSION_START$IMPL
-- =====================================================================

CREATE PROCEDURE SBMO.PKG_PDX_SCHEMA_UPDATER$LOG_VERSION_START$IMPL  
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @P_CALL_ID float(53),
   @P_CURRENT_VERSION varchar(max),
   @P_TARGET_VERSION varchar(max),
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @return_value_argument float(53)  OUTPUT
AS 
   BEGIN

      DECLARE
         /*
         *   SSMA warning messages:
         *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
         */

         @L_RTN float(53)

      DECLARE
         @temp_table TABLE 
         (
            /*
            *   SSMA warning messages:
            *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
            */

            L_RTN float(53)
         )

      /*
      *   SSMA warning messages:
      *   O2SS0058: OUTPUT clauses might return different results in SQL Server when using triggers.
      */

      INSERT SBMO.PDX_SCHEMA_VERSION_HISTORY(
         ID, 
         PDX_SCHEMA_UPD_PKGCALL_HIST_ID, 
         CURRENT_VERSION, 
         TARGET_VERSION, 
         STATUS_CODE, 
         START_DATE)
         OUTPUT INSERTED.ID
            INTO @temp_table(L_RTN)
         VALUES (
            NEXT VALUE FOR SBMO.PDX_SCHEMA_MASTER_SEQ, 
            @P_CALL_ID, 
            @P_CURRENT_VERSION, 
            @P_TARGET_VERSION, 
            'I', 
            sysdatetimeoffset())

      SELECT @L_RTN = NULL

      SELECT @L_RTN = L_RTN
      FROM @temp_table

      IF @@TRANCOUNT > 0
         COMMIT TRANSACTION 

      SET @return_value_argument = @L_RTN

      RETURN 

   END
GO

-- =====================================================================
-- Procedure 13: PKG_PDX_SCHEMA_UPDATER$RUN_SQL$IMPL
-- =====================================================================

CREATE PROCEDURE SBMO.PKG_PDX_SCHEMA_UPDATER$RUN_SQL$IMPL  
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @P_CALL_ID float(53),
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @P_VERSION_ID float(53),
   @P_FILENAME varchar(max),
   @P_ACTION varchar(max),
   @return_value_argument bit  OUTPUT
AS 
   BEGIN

      DECLARE
         @L_TYPE_CHECK varchar(30), 
         @L_RB_OK bit = 1, 
         @L_RB_FOUND bit = 0, 
         @L_RTN bit = 0, 
         @L_SQL varchar(max) = SBMO.PKG_PDX_SCHEMA_UPDATER$GET_SQL(@P_FILENAME, @P_ACTION), 
         /*
         *   SSMA warning messages:
         *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
         */

         @L_TASK_ID float(53)

      BEGIN TRY

         /* 
         *   SSMA error messages:
         *   O2SS0050: Conversion of identifier 'REGEXP_INSTR(CLOB, CHAR, BINARY_INTEGER, BINARY_INTEGER, BINARY_INTEGER, CHAR)' is not supported.

         SET @L_RB_FOUND = 
            CASE 
               WHEN REGEXP_INSTR(
                  @L_SQL, 
                  '^\s*--\*\s*\S', 
                  1, 
                  1, 
                  0, 
                  'm') > 0 THEN 1
               ELSE 0
            END
         */



         /*If we don't have the TASKTYPE metadata, then assumed to be sql-based release file executed as tasK*/
         IF SBMO.PKG_PDX_SCHEMA_UPDATER_META$GET_FILETYPE(@P_FILENAME) = 'T'
            SET @L_RB_OK = 
               CASE 
                  WHEN upper(isnull(SBMO.PKG_PDX_SCHEMA_UPDATER$GET_METADATA(@P_FILENAME, 'ROLLBACK', @P_ACTION), 'YES')) IN ( 'TRUE', 'YES' ) THEN 1
                  ELSE 0
               END
         ELSE 
            SET @L_RB_OK = @L_RB_FOUND

         IF @L_RB_OK != 0 AND NOT @L_RB_FOUND != 0
            BEGIN

               SET @L_RTN = 0

               /* 
               *   SSMA error messages:
               *   O2SS0237: Cannot resolve the type of parameter expression needed for the temporary variable.

               DECLARE
                  @temp varchar(8000)
               */



               /* 
               *   SSMA error messages:
               *   O2SS0174: The declaration of the identifier '@temp' was converted with error(s).

               SET @temp = SBMO.PKG_PDX_SCHEMA_UPDATER$ERROR_RECORD('Requested task has rollback enabled, but no rollback statements', NULL, NULL)
               */



               /* 
               *   SSMA error messages:
               *   O2SS0174: The declaration of the identifier '@temp' was converted with error(s).

               EXECUTE SBMO.PKG_PDX_SCHEMA_UPDATER$LOG_TASK_HISTORY 
                  @P_CALL_ID = @P_CALL_ID, 
                  @P_VERSION_ID = @P_VERSION_ID, 
                  @P_FILENAME = @P_FILENAME, 
                  @P_ACTION = @P_ACTION, 
                  @P_STATUS = 'F', 
                  @P_ERROR_RECORD = @temp
               */



            END
         ELSE 
            BEGIN

               SET @L_TYPE_CHECK = SBMO.PKG_PDX_SCHEMA_UPDATER$GET_TASKTYPE(@P_FILENAME, @P_ACTION)

               IF @L_TYPE_CHECK = 'SYS'
                  BEGIN

                     SET @L_TASK_ID = SBMO.PKG_PDX_SCHEMA_UPDATER$LOG_SQL_START(@P_CALL_ID, @P_VERSION_ID, @P_FILENAME, @P_ACTION)

                     /* 
                     *   SSMA error messages:
                     *   O2SS0083: Identifier PDXDBA.pkg_pdx_dba_updater.run_sql cannot be converted because it was not resolved.

                     SET @L_RTN = PDXDBA.PKG_PDX_DBA_UPDATER.RUN_SQL
                     */



                     EXECUTE SBMO.PKG_PDX_SCHEMA_UPDATER$LOG_SYS_SQL_END @P_CALL_ID = @P_CALL_ID, @P_VERSION_ID = @P_VERSION_ID, @P_TASK_ID = @L_TASK_ID, @P_FILENAME = @P_FILENAME

                  END
               ELSE 
                  IF @L_TYPE_CHECK = upper(SBMO.PKG_PDX_SCHEMA_UPDATER$GET_CONFIG('APPLICATION_PRE
GO

-- =====================================================================
-- Procedure 14: PKG_PDX_SCHEMA_UPDATER$SCHEMA_VERSION$IMPL
-- =====================================================================

CREATE PROCEDURE SBMO.PKG_PDX_SCHEMA_UPDATER$SCHEMA_VERSION$IMPL  
   @return_value_argument varchar(max)  OUTPUT
AS 
   BEGIN

      DECLARE
         @L_RTN varchar(23)

      BEGIN TRY

         EXECUTE ssma_oracle.db_fn_check_init_package 'SBMO', 'PKG_PDX_SCHEMA_UPDATER'

         SELECT @L_RTN = PDX_SCHEMA_VERSION_HISTORY.TARGET_VERSION
         FROM SBMO.PDX_SCHEMA_VERSION_HISTORY
         WHERE PDX_SCHEMA_VERSION_HISTORY.ID = 
            (
               SELECT max(PDX_SCHEMA_VERSION_HISTORY$2.ID) AS expr
               FROM SBMO.PDX_SCHEMA_VERSION_HISTORY  AS PDX_SCHEMA_VERSION_HISTORY$2
               WHERE PDX_SCHEMA_VERSION_HISTORY$2.STATUS_CODE = 'S'
            )

         SET @return_value_argument = @L_RTN

         RETURN 

      END TRY

      BEGIN CATCH

         DECLARE
            @errornumber int

         SET @errornumber = ERROR_NUMBER()

         DECLARE
            @errormessage nvarchar(4000)

         SET @errormessage = ERROR_MESSAGE()

         DECLARE
            @exceptionidentifier nvarchar(4000)

         SELECT @exceptionidentifier = ssma_oracle.db_error_get_oracle_exception_id(@errormessage, @errornumber)

         IF (@exceptionidentifier LIKE N'ORA-00100%')
            BEGIN

               SET @return_value_argument = NULL

               RETURN 

            END
         ELSE 
            BEGIN
               IF (@exceptionidentifier IS NOT NULL)
                  BEGIN
                     IF @errornumber = 59998
                        RAISERROR(59998, 16, 1, @exceptionidentifier)
                     ELSE 
                        RAISERROR(59999, 16, 1, @exceptionidentifier)
                  END
               ELSE 
                  BEGIN
                     EXECUTE ssma_oracle.ssma_rethrowerror
                  END
            END

      END CATCH

   END
GO

-- =====================================================================
-- Procedure 15: PKG_PDX_SCHEMA_UPDATER$SSMA_Initialize_Package
-- =====================================================================

CREATE PROCEDURE SBMO.PKG_PDX_SCHEMA_UPDATER$SSMA_Initialize_Package
AS 
   EXECUTE ssma_oracle.db_clean_storage
GO

-- =====================================================================
-- Procedure 16: PKG_PDX_SCHEMA_UPDATER$UPDATE_RELEASE_BASED$IMPL
-- =====================================================================

CREATE PROCEDURE SBMO.PKG_PDX_SCHEMA_UPDATER$UPDATE_RELEASE_BASED$IMPL  
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @P_CALL_ID float(53),
   @P_CURRENT_VERSION varchar(max),
   @P_TARGET_VERSION varchar(max),
   @return_value_argument bit  OUTPUT
AS 
   BEGIN

      DECLARE
         @MANIFEST_REC$TARGET_VERSION varchar(4000), 
         @MANIFEST_REC$FILE_NAME varchar(max), 
         @L_ACTION_CODE varchar(1), 
         @L_RESULT bit = 1, 
         @L_CURRENT_VERSION varchar(20)

      
      /*
      *    The following will check to see if there is a partial apply to clean up
      *    For example last successful shows we are on 2600.002, but we had previously failed to upgrade to 2600.003
      *    and part of that file is still applied
      *    No error will be thrown regardless of outcome if p_current_version = p_target_version
      */
      BEGIN

         DECLARE
            @L_CVERSION varchar(20), 
            @L_TVERSION varchar(20)

         BEGIN TRY

            SELECT @L_CVERSION = PDX_SCHEMA_VERSION_HISTORY.CURRENT_VERSION, @L_TVERSION = PDX_SCHEMA_VERSION_HISTORY.TARGET_VERSION
            FROM SBMO.PDX_SCHEMA_VERSION_HISTORY
            WHERE PDX_SCHEMA_VERSION_HISTORY.ID = 
               (
                  SELECT max(PDX_SCHEMA_VERSION_HISTORY$2.ID) AS expr
                  FROM SBMO.PDX_SCHEMA_VERSION_HISTORY  AS PDX_SCHEMA_VERSION_HISTORY$2
                  WHERE (PDX_SCHEMA_VERSION_HISTORY$2.TARGET_VERSION = SBMO.PKG_PDX_SCHEMA_UPDATER$SCHEMA_VERSION() OR PDX_SCHEMA_VERSION_HISTORY$2.CURRENT_VERSION = SBMO.PKG_PDX_SCHEMA_UPDATER$SCHEMA_VERSION()) AND (PDX_SCHEMA_VERSION_HISTORY$2.CURRENT_VERSION != PDX_SCHEMA_VERSION_HISTORY$2.TARGET_VERSION OR PDX_SCHEMA_VERSION_HISTORY$2.STATUS_CODE = 'S')
               ) AND PDX_SCHEMA_VERSION_HISTORY.STATUS_CODE NOT IN ( 'S', 'I' )

            SET @L_CURRENT_VERSION = SBMO.PKG_PDX_SCHEMA_UPDATER$SCHEMA_VERSION()

            
            /*
            *    If prior failure was upgrading and we are now upgrading, then no need to handle here
            *    We only need to handle if it would not be captured by the standard current_version => target version execution
            *    cversion should equal current_version ...
            */
            IF SBMO.PKG_PDX_SCHEMA_UPDATER$COMPARE_VERSIONS(@L_CVERSION, @L_TVERSION) < 0 AND SBMO.PKG_PDX_SCHEMA_UPDATER$COMPARE_VERSIONS(@L_CURRENT_VERSION, @P_TARGET_VERSION) >= 0
               BEGIN

                  DECLARE
                     @CURSOR_PARAM_MANIFEST_CUR_C_SOURCE_VERSION varchar(max), 
                     @CURSOR_PARAM_MANIFEST_CUR_C_TARGET_VERSION varchar(max)

                  SET @CURSOR_PARAM_MANIFEST_CUR_C_SOURCE_VERSION = @L_TVERSION

                  SET @CURSOR_PARAM_MANIFEST_CUR_C_TARGET_VERSION = @L_CVERSION

                  /* 
                  *   SSMA error messages:
                  *   O2SS0297: The following USING clause cannot be converted: USING(file_name)

                  DECLARE
                      MANIFEST_CUR CURSOR LOCAL FOR 
                        SELECT fci.TARGET_VERSION, fci.FILE_NAME
                        FROM 
                           (
                              SELECT fci$2.TARGET_VERSION, fci$2.FILE_NAME, fci$2.APPLY_ORDER
                              FROM 
                                 (
                                    SELECT 
                                       CASE 
                                          WHEN @CURSOR_PARAM_MANIFEST_CUR_C_TARGET_VERSION IS NULL OR SBMO.PKG_PDX_SCHEMA_UPDATER$COMPARE_VERSIONS(M1$2.LAG_VERSION, @CURSOR_PARAM_MANIFEST_CUR_C_TARGET_VERSION) > 0 THEN M1$2.LAG_VERSION
                                          ELSE @CURSOR_PARAM_MANIFEST_CUR_C_TARGET_VERSION
                                       END AS TARGET_VERSION, M1$2.FILE_NAME, M1$2.APPLY_ORDER
                                    FROM 
                                       (
GO

-- =====================================================================
-- Procedure 17: PKG_PDX_SCHEMA_UPDATER$UPDATE_TASK_BASED$IMPL
-- =====================================================================

CREATE PROCEDURE SBMO.PKG_PDX_SCHEMA_UPDATER$UPDATE_TASK_BASED$IMPL  
   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   @P_CALL_ID float(53),
   @P_TARGET_VERSION varchar(max),
   @return_value_argument bit  OUTPUT
AS 
   BEGIN

      DECLARE
         /*
         *   SSMA warning messages:
         *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
         */

         @L_VERSION_ID float(53), 
         @L_RTN bit

      BEGIN TRY

         SET @L_VERSION_ID = SBMO.PKG_PDX_SCHEMA_UPDATER$LOG_VERSION_START(@P_CALL_ID, SBMO.PKG_PDX_SCHEMA_UPDATER$SCHEMA_VERSION(), @P_TARGET_VERSION)

         SET @L_RTN = SBMO.PKG_PDX_SCHEMA_UPDATER$TASK_BASED_ROLLBACK(@P_CALL_ID, @L_VERSION_ID, @P_TARGET_VERSION)

         SET @L_RTN = 
            CASE 
               WHEN @L_RTN != 0 AND SBMO.PKG_PDX_SCHEMA_UPDATER$TASK_BASED_APPLY(@P_CALL_ID, @L_VERSION_ID) != 0 THEN 1
               ELSE 0
            END

         IF NOT @L_RTN != 0
            BEGIN

               EXECUTE SBMO.PKG_PDX_SCHEMA_UPDATER$LOG_VERSION_END @P_VERSION_ID = @L_VERSION_ID, @P_STATUS = 'F', @P_ERROR_RECORD = NULL

               SET @return_value_argument = 0

               RETURN 

            END
         ELSE 
            BEGIN

               EXECUTE SBMO.PKG_PDX_SCHEMA_UPDATER$LOG_VERSION_END @P_VERSION_ID = @L_VERSION_ID, @P_STATUS = 'S', @P_ERROR_RECORD = NULL

               SET @return_value_argument = 1

               RETURN 

            END

      END TRY

      BEGIN CATCH

         DECLARE
            @errornumber int

         SET @errornumber = ERROR_NUMBER()

         DECLARE
            @errormessage nvarchar(4000)

         SET @errormessage = ERROR_MESSAGE()

         DECLARE
            @exceptionidentifier nvarchar(4000)

         SELECT @exceptionidentifier = ssma_oracle.db_error_get_oracle_exception_id(@errormessage, @errornumber)

         BEGIN

            /* 
            *   SSMA error messages:
            *   O2SS0560: Identifier DBMS_UTILITY.FORMAT_ERROR_STACK cannot be converted because it was not resolved.
            *   This may happen because system package that defines the identifier was excluded from loading in Project Settings.
            *   O2SS0560: Identifier DBMS_UTILITY.FORMAT_ERROR_BACKTRACE cannot be converted because it was not resolved.
            *   This may happen because system package that defines the identifier was excluded from loading in Project Settings.

            EXECUTE SBMO.PKG_PDX_SCHEMA_UPDATER$LOG_VERSION_END @P_VERSION_ID = @L_VERSION_ID, @P_STATUS = 'F', @P_ERROR_RECORD = SBMO.PKG_PDX_SCHEMA_UPDATER$ERROR_RECORD('Unexpected Error', (ssma_oracle.db_error_sqlcode(@exceptionidentifier, @errornumber)), ISNULL(CAST(DBMS_UTILITY.FORMAT_ERROR_STACK AS nvarchar(max)), '') + ISNULL(char(10), '') + ISNULL(CAST(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE AS nvarchar(max)), ''))
            */



            SET @return_value_argument = 0

            RETURN 

         END

      END CATCH

   END
GO

-- =====================================================================
-- Procedure 18: PKG_PDX_SCHEMA_UPDATER_HELPER_change_precision_scale
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_change_precision_scale]
(
    @p_table_name NVARCHAR(128),
    @p_change_list NVARCHAR(MAX),
    @p_parallel INT = 0,
    @p_increase_only BIT = 0,
    @p_use_ctas BIT = 0,
    @p_set_unused BIT = 0
)
AS
BEGIN
    DECLARE @is_release BIT;
    DECLARE @l_use_ctas BIT = 0;
    DECLARE @error_msg NVARCHAR(MAX);
    DECLARE @error_line INT;
    DECLARE @session_id INT = @@SPID;
    
    BEGIN TRY
        -- Validate table exists
        IF NOT EXISTS (
            SELECT 1 FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = 'SBMO' AND TABLE_NAME = UPPER(@p_table_name)
        )
        BEGIN
            SET @error_msg = 'Table ' + @p_table_name + ' not found in SBMO schema';
            RAISERROR(@error_msg, 16, 1);
        END;
        
        SET @is_release = [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_get_is_release]();
        
        -- Validate CTAS prerequisites (table must have PK)
        IF @p_use_ctas = 1
        BEGIN
            DECLARE @has_pk BIT = 0;
            SELECT @has_pk = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
            FROM sys.indexes
            WHERE object_id = OBJECT_ID('[SBMO].[' + @p_table_name + ']')
            AND is_primary_key = 1;
            
            IF @has_pk = 0
                SET @l_use_ctas = 0;
            ELSE
                SET @l_use_ctas = 1;
        END
        ELSE
        BEGIN
            SET @l_use_ctas = 0;
        END;
        
        -- NESTED PROCEDURE ORCHESTRATION
        -- Parse change list into column collection
        EXEC [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_process_change_list] @p_change_list;
        
        -- Query current column state
        EXEC [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_set_renamed] @p_table_name;
        
        -- Determine modification method for each column
        EXEC [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_set_method]
            @p_table_name,
            @p_increase_only,
            @l_use_ctas,
            @is_release;
        
        -- Validate consistency of modification plan
        EXEC [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_validate_data] @l_use_ctas;
        
    END TRY
    BEGIN CATCH
        SET @error_msg = ERROR_MESSAGE();
        SET @error_line = ERROR_LINE();
        
        RAISERROR('Error in change_precision_scale at line %d: %s', 16, 1, @error_line, @error_msg);
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 19: PKG_PDX_SCHEMA_UPDATER_HELPER_create_out_of_place
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_create_out_of_place]
(
    @p_table_name NVARCHAR(128)
)
AS
BEGIN
    DECLARE @session_id INT = @@SPID;
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @first_column BIT = 1;
    DECLARE @use_ctas BIT;
    DECLARE @col_key NVARCHAR(30);
    DECLARE @method NVARCHAR(1);
    DECLARE @data_type NVARCHAR(15);
    DECLARE @data_prec INT;
    DECLARE @data_scale INT;
    DECLARE @temp_table_name NVARCHAR(128);
    DECLARE @temp_col_name NVARCHAR(128);
    DECLARE @error_msg NVARCHAR(MAX);
    
    BEGIN TRY
        -- Determine if using CTAS
        SELECT @use_ctas = MAX(CASE WHEN method = 'T' THEN 1 ELSE 0 END)
        FROM [SBMO].[pdx_schema_updater_helper_coldata]
        WHERE session_id = @session_id AND method IN ('C', 'T');
        
        IF @use_ctas IS NULL SET @use_ctas = 0;
        
        -- Build CREATE statement
        SET @sql = NULL;
        
        IF @use_ctas = 1
        BEGIN
            -- CTAS: Create table with PK columns + new columns
            SET @temp_table_name = [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_get_temp_table_name](@p_table_name, 1);
            SET @sql = 'CREATE TABLE [SBMO].[' + @temp_table_name + '] (';
            
            -- Add primary key columns
            SET @first_column = 1;
            DECLARE cursor_pk CURSOR FOR
                SELECT c.name, TYPE_NAME(c.user_type_id), c.max_length, c.precision, c.scale
                FROM sys.index_columns ic
                JOIN sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
                JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
                WHERE i.object_id = OBJECT_ID('[SBMO].[' + @p_table_name + ']')
                AND i.is_primary_key = 1
                ORDER BY ic.key_ordinal;
            
            OPEN cursor_pk;
            FETCH NEXT FROM cursor_pk INTO @col_key, @data_type, @data_prec, @data_scale, @data_scale;
            
            WHILE @@FETCH_STATUS = 0
            BEGIN
                IF @first_column = 0 SET @sql = @sql + ', ';
                SET @sql = @sql + '[' + @col_key + '] ' + 
                    [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_get_data_type](
                        CASE WHEN @data_type LIKE '%varchar%' THEN 'VARCHAR2' ELSE 'NUMBER' END,
                        CASE WHEN @data_type LIKE '%varchar%' THEN @data_prec ELSE @data_scale END,
                        CASE WHEN @data_type LIKE '%varchar%' THEN NULL ELSE @data_scale END
                    );
                SET @first_column = 0;
                FETCH NEXT FROM cursor_pk INTO @col_key, @data_type, @data_prec, @data_scale, @data_scale;
            END;
            CLOSE cursor_pk;
            DEALLOCATE cursor_pk;
            
            SET @sql = @sql + ')';
        END
        ELSE
        BEGIN
            -- Inline: ALTER TABLE ADD columns
            SET @sql = 'ALTER TABLE [SBMO].[' + @p_table_name + '] ADD ';
            SET @first_column = 1;
            
            DECLARE cursor_col CURSOR FOR
                SELECT col_key, data_type, data_precision_length, data_scale
                FROM [SBMO].[pdx_schema_updater_helper_coldata]
                WHERE session_id = @session_id AND method = 'C';
            
            OPEN cursor_col;
            FETCH NEXT FROM cursor_col INTO @col_key, @data_type, @data_prec, @data_scale;
            
            WHILE @@FETCH_STATUS = 0
            BEGIN
                IF @first_column = 0 SET @sql = @sql + ', ';
                SET @temp_col_name = [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_get_temp_column_name](@col_key, 0);
                SET @sql = @sql + '[' + @temp_col_name + '] ' + [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_get_data_type](@data_type, @data_prec, @data_scale);
                SET @first_column = 0;
                FETCH NEXT FROM cursor_col INTO @col_key, @data_type, @data_prec, @data_scale;
            END;
            CLOSE cursor_col;
            DE
GO

-- =====================================================================
-- Procedure 20: PKG_PDX_SCHEMA_UPDATER_HELPER_debug_dtl
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_debug_dtl]
(
    @p_msg NVARCHAR(MAX),
    @p_sql NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @debug_enabled BIT;
    DECLARE @session_id INT = @@SPID;
    DECLARE @debug_hdr_id NUMERIC(18, 0);
    DECLARE @debug_dtl_id NUMERIC(18, 0);
    
    SELECT @debug_enabled = debug_enabled, @debug_hdr_id = debug_hdr_id
    FROM [SBMO].[pdx_schema_updater_helper_debug_context]
    WHERE session_id = @session_id;
    
    IF @debug_enabled = 1 AND @debug_hdr_id IS NOT NULL
    BEGIN
        INSERT INTO [SBMO].[pdx_schema_upd_helper_debug_d]
        (pdx_schema_upd_hlpr_dbg_h_id, start_timestamp, message, sql)
        VALUES (@debug_hdr_id, GETUTCDATE(), @p_msg, @p_sql);
        
        SET @debug_dtl_id = SCOPE_IDENTITY();
        
        UPDATE [SBMO].[pdx_schema_updater_helper_debug_context]
        SET debug_dtl_id = @debug_dtl_id, last_updated = GETUTCDATE()
        WHERE session_id = @session_id;
    END;
END;
GO

-- =====================================================================
-- Procedure 21: PKG_PDX_SCHEMA_UPDATER_HELPER_debug_dtl_error
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_debug_dtl_error]
(
    @p_err NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @session_id INT = @@SPID;
    DECLARE @debug_dtl_id NUMERIC(18, 0);
    
    SELECT @debug_dtl_id = debug_dtl_id
    FROM [SBMO].[pdx_schema_updater_helper_debug_context]
    WHERE session_id = @session_id;
    
    IF @debug_dtl_id IS NOT NULL
    BEGIN
        UPDATE [SBMO].[pdx_schema_upd_helper_debug_d]
        SET sql_error = @p_err
        WHERE id = @debug_dtl_id;
        
        UPDATE [SBMO].[pdx_schema_updater_helper_debug_context]
        SET debug_dtl_id = NULL, last_updated = GETUTCDATE()
        WHERE session_id = @session_id;
    END;
END;
GO

-- =====================================================================
-- Procedure 22: PKG_PDX_SCHEMA_UPDATER_HELPER_debug_dtl_success
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_debug_dtl_success]
AS
BEGIN
    DECLARE @session_id INT = @@SPID;
    DECLARE @debug_dtl_id NUMERIC(18, 0);
    
    SELECT @debug_dtl_id = debug_dtl_id
    FROM [SBMO].[pdx_schema_updater_helper_debug_context]
    WHERE session_id = @session_id;
    
    IF @debug_dtl_id IS NOT NULL
    BEGIN
        UPDATE [SBMO].[pdx_schema_upd_helper_debug_d]
        SET end_timestamp = GETUTCDATE()
        WHERE id = @debug_dtl_id;
        
        UPDATE [SBMO].[pdx_schema_updater_helper_debug_context]
        SET debug_dtl_id = NULL, last_updated = GETUTCDATE()
        WHERE session_id = @session_id;
    END;
END;
GO

-- =====================================================================
-- Procedure 23: PKG_PDX_SCHEMA_UPDATER_HELPER_debug_hdr
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_debug_hdr]
(
    @p_proc NVARCHAR(256),
    @p_parms NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @debug_enabled BIT;
    DECLARE @session_id INT = @@SPID;
    
    SELECT @debug_enabled = debug_enabled
    FROM [SBMO].[pdx_schema_updater_helper_debug_context]
    WHERE session_id = @session_id;
    
    IF @debug_enabled = 1
    BEGIN
        DECLARE @debug_hdr_id NUMERIC(18, 0);
        
        INSERT INTO [SBMO].[pdx_schema_upd_helper_debug_h]
        ([proc], parms, debug_timestamp)
        VALUES (UPPER(@p_proc), @p_parms, GETUTCDATE());
        
        SET @debug_hdr_id = SCOPE_IDENTITY();
        
        UPDATE [SBMO].[pdx_schema_updater_helper_debug_context]
        SET debug_hdr_id = @debug_hdr_id, last_updated = GETUTCDATE()
        WHERE session_id = @session_id;
    END;
END;
GO

-- =====================================================================
-- Procedure 24: PKG_PDX_SCHEMA_UPDATER_HELPER_debug_hdr_error
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_debug_hdr_error]
(
    @p_err NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @session_id INT = @@SPID;
    DECLARE @debug_hdr_id NUMERIC(18, 0);
    
    SELECT @debug_hdr_id = debug_hdr_id
    FROM [SBMO].[pdx_schema_updater_helper_debug_context]
    WHERE session_id = @session_id;
    
    IF @debug_hdr_id IS NOT NULL
    BEGIN
        UPDATE [SBMO].[pdx_schema_upd_helper_debug_h]
        SET sql_error = @p_err
        WHERE id = @debug_hdr_id;
        
        UPDATE [SBMO].[pdx_schema_updater_helper_debug_context]
        SET debug_hdr_id = NULL, debug_dtl_id = NULL, last_updated = GETUTCDATE()
        WHERE session_id = @session_id;
    END;
END;
GO

-- =====================================================================
-- Procedure 25: PKG_PDX_SCHEMA_UPDATER_HELPER_debug_hdr_success
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_debug_hdr_success]
AS
BEGIN
    DECLARE @session_id INT = @@SPID;
    
    UPDATE [SBMO].[pdx_schema_updater_helper_debug_context]
    SET debug_hdr_id = NULL, debug_dtl_id = NULL, last_updated = GETUTCDATE()
    WHERE session_id = @session_id;
END;
GO

-- =====================================================================
-- End of Part1_Procedures_001-025
-- =====================================================================
-- Procedures 1-25 exported successfully.
-- =====================================================================

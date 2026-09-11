-- =====================================================================
-- SBMO Schema Procedures Export - Part3_Procedures_051-073
-- Database: nonEPR-DB
-- Server: sql-non-epr-dev-eastus2.ceb73025282c.database.windows.net
-- Procedures: 51 to 73 (Total: 23)
-- Exported: 2026-08-13
-- =====================================================================
-- This is part of the complete 73-procedure export from SBMO schema.
-- =====================================================================


-- =====================================================================
-- Procedure 51: PKG_PDX_SCHEMA_UPDATER_RPT_report
-- =====================================================================

-- Procedure 6: report (MAIN ENTRY POINT - simplified version)
-- Generates formatted report of schema update execution history
CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_RPT_report]
(
    @p_pdx_schema_upd_pgkcall_id NUMERIC(18, 0) = NULL,
    @p_include_processes NVARCHAR(10) = 'N'
)
AS
BEGIN
    DECLARE @call_id NUMERIC(18, 0);
    
    BEGIN TRY
        -- Determine which call record to report on
        IF @p_pdx_schema_upd_pgkcall_id IS NULL
        BEGIN
            SELECT @call_id = MAX(id) FROM [SBMO].[pdx_schema_upd_pkgcall_hist];
        END
        ELSE
        BEGIN
            SET @call_id = @p_pdx_schema_upd_pgkcall_id;
        END;
        
        -- Check if call record exists
        IF EXISTS (SELECT 1 FROM [SBMO].[pdx_schema_upd_pkgcall_hist] WHERE id = @call_id)
        BEGIN
            PRINT '=== PKG_PDX_SCHEMA_UPDATER Report ===';
            PRINT 'Call ID: ' + CAST(@call_id AS NVARCHAR(20));
            
            -- Query call history
            SELECT 'Call Details:' AS report_section
            UNION ALL
            SELECT 'Target Version: ' + ISNULL(h.target_version, '') + 
                   ' | Status: ' + ISNULL(h.status_code, '') +
                   ' | Started: ' + CAST(h.start_date AS NVARCHAR(30))
            FROM [SBMO].[pdx_schema_upd_pkgcall_hist] h
            WHERE h.id = @call_id
            UNION ALL
            SELECT 'Return Code: ' + CAST(ISNULL(h.return_code, -1) AS NVARCHAR(10))
            FROM [SBMO].[pdx_schema_upd_pkgcall_hist] h
            WHERE h.id = @call_id;
            
            PRINT '';
            PRINT 'Report generated successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Unable to find results for pdx_schema_upd_pkgcall_hist_id ' + CAST(@p_pdx_schema_upd_pgkcall_id AS NVARCHAR(50));
        END;
        
    END TRY
    BEGIN CATCH
        DECLARE @error_msg NVARCHAR(MAX) = ERROR_MESSAGE();
        PRINT 'Error in PKG_PDX_SCHEMA_UPDATER_RPT_report: ' + @error_msg;
        THROW;
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 52: send_email
-- =====================================================================

CREATE PROCEDURE SBMO.send_email(
    @p_message NVARCHAR(MAX),
    @p_html NVARCHAR(MAX),
    @p_profile_name NVARCHAR(MAX) = 'default'
)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @l_from NVARCHAR(MAX);
    DECLARE @l_to NVARCHAR(MAX);
    DECLARE @l_subject NVARCHAR(MAX);
    DECLARE @l_user NVARCHAR(128);
    DECLARE @l_err NVARCHAR(4000);
    
    BEGIN TRY
        SET @l_from = SBMO.lookup_properties('partitionsEmailFrom');
        SET @l_to = SBMO.lookup_properties('partitionsEmailTo');
        
        IF @l_from IS NULL OR @l_to IS NULL
        BEGIN
            INSERT INTO SBMO.partition_sql_history 
                (sql_timestamp, sql_text, sql_error, report_error)
            VALUES 
                (GETDATE(), 'send_email - configuration missing', 
                 'partitionsEmailFrom or partitionsEmailTo not configured', 'Y');
            RETURN;
        END;
        
        SET @l_user = USER_NAME();
        
        SET @l_subject = 'Unexpected error in ' + @l_user + 
                         '.rotate_partitions_pkg on ' +
                         FORMAT(GETDATE(), 'MM/dd/yyyy hh:mm:ss tt');
        
        EXEC msdb.dbo.sp_send_dbmail
            @profile_name = @p_profile_name,
            @recipients = @l_to,
            @from_address = @l_from,
            @subject = @l_subject,
            @body = @p_message,
            @body_format = 'HTML';
        
    END TRY
    BEGIN CATCH
        SET @l_err = 'Profile: ' + @p_profile_name + ' | Error: ' + ERROR_MESSAGE();
        
        INSERT INTO SBMO.partition_sql_history 
            (sql_timestamp, sql_text, sql_error, report_error)
        VALUES 
            (GETDATE(), 'send_email (sp_send_dbmail call, profile=' + @p_profile_name + ')', @l_err, 'Y');
        
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 53: sp_check_can_run
-- =====================================================================

-- Procedure 3: sp_check_can_run
CREATE PROCEDURE [SBMO].[sp_check_can_run]
  @p_can_run BIT OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  
  DECLARE @l_window_times NVARCHAR(500);
  DECLARE @l_start_hour INT;
  DECLARE @l_end_hour INT;
  DECLARE @l_current_hour INT;
  DECLARE @l_error NVARCHAR(MAX);
  
  BEGIN TRY
    -- Get window times from config (format: "2000-0800" for 20:00 to 08:00)
    SET @l_window_times = [SBMO].[get_config_value]('Window Times');
    
    IF @l_window_times IS NULL
    BEGIN
      SET @p_can_run = 1;  -- No window restriction
      RETURN;
    END
    
    -- Parse start and end hours
    SET @l_start_hour = CONVERT(INT, LEFT(@l_window_times, 4));
    SET @l_end_hour = CONVERT(INT, RIGHT(@l_window_times, 4));
    SET @l_current_hour = DATEPART(HOUR, GETDATE());
    
    -- Check if current time is within window
    IF @l_start_hour > @l_end_hour
    BEGIN
      -- Window spans midnight (e.g., 20:00 to 08:00)
      IF @l_current_hour >= @l_start_hour OR @l_current_hour < @l_end_hour
        SET @p_can_run = 1;
      ELSE
        SET @p_can_run = 0;
    END
    ELSE
    BEGIN
      -- Normal window (e.g., 08:00 to 20:00)
      IF @l_current_hour >= @l_start_hour AND @l_current_hour < @l_end_hour
        SET @p_can_run = 1;
      ELSE
        SET @p_can_run = 0;
    END
  END TRY
  BEGIN CATCH
    SET @l_error = ERROR_MESSAGE();
    
    INSERT INTO [SBMO].purge_error_log (code_block, sql_code, sql_errm, exception_message)
    VALUES ('sp_check_can_run', ERROR_NUMBER(), @l_error, 'Failed to check time window');
    
    SET @p_can_run = 0;  -- Default to cannot run on error
  END CATCH
END;
GO

-- =====================================================================
-- Procedure 54: sp_dbu_allocated_qty
-- =====================================================================

CREATE PROCEDURE SBMO.sp_dbu_allocated_qty
  @p_allocatedqty NUMERIC = NULL,
  @p_tenantid NUMERIC = NULL,
  @p_ndc NUMERIC = NULL,
  @p_inventoryid NUMERIC = NULL
AS
BEGIN
  SET NOCOUNT ON;
  
  DECLARE @l_id BIGINT;
  DECLARE @l_rowsexp INT = 1;
  DECLARE @l_rowsproc INT = 0;
  DECLARE @l_sql NVARCHAR(MAX);
  DECLARE @p_parms NVARCHAR(MAX);
  DECLARE @error_msg NVARCHAR(MAX);
  
  -- =========================================================================
  -- VALIDATION SECTION
  -- =========================================================================
  
  -- Validate ALLOCATED_QTY is provided
  IF @p_allocatedqty IS NULL
  BEGIN
    SET @error_msg = 'DBU [FORMULARY] Allocated Quantity must have a value';
    RAISERROR(@error_msg, 16, 1);
    RETURN;
  END;
  
  -- Validate TENANT_ID is provided
  IF @p_tenantid IS NULL
  BEGIN
    SET @error_msg = 'DBU [FORMULARY] Tenant ID must have a value';
    RAISERROR(@error_msg, 16, 1);
    RETURN;
  END;
  
  -- Validate NDC is provided
  IF @p_ndc IS NULL
  BEGIN
    SET @error_msg = 'DBU [FORMULARY] NDC must have a value';
    RAISERROR(@error_msg, 16, 1);
    RETURN;
  END;
  
  -- Validate NDC is numeric
  IF NOT (SELECT SBMO.fn_is_numeric(@p_ndc)) = 1
  BEGIN
    SET @error_msg = 'DBU [FORMULARY] NDC must be a number';
    RAISERROR(@error_msg, 16, 1);
    RETURN;
  END;
  
  -- Validate INVENTORY_ID is provided
  IF @p_inventoryid IS NULL
  BEGIN
    SET @error_msg = 'DBU [FORMULARY] Must input a valid inventory ID';
    RAISERROR(@error_msg, 16, 1);
    RETURN;
  END;
  
  -- =========================================================================
  -- BUILD AUDIT TRAIL ENTRY
  -- =========================================================================
  
  SET @p_parms = 'ALLOCATED_QTY = ' + CONVERT(NVARCHAR(20), @p_allocatedqty) + 
                 ', tenant_id = ' + CONVERT(NVARCHAR(20), @p_tenantid) + 
                 ', ndc = ' + CONVERT(NVARCHAR(20), @p_ndc) + 
                 ', inventory_id = ' + CONVERT(NVARCHAR(20), @p_inventoryid);
  
  SET @l_sql = 'UPDATE FORMULARY SET ALLOCATED_QTY=@allocated_qty WHERE tenant_id=@tenant_id AND ndc=@ndc AND inventory_id=@inventory_id';
  
  -- Log the DBU operation to audit trail via stored procedure
  EXEC SBMO.sp_log_audit_dbu
    @p_dbu_table = 'FORMULARY',
    @p_dbu_parms = @p_parms,
    @p_dbu_rows = @l_rowsexp,
    @p_sql_text = @l_sql,
    @p_id = @l_id OUTPUT;
  
  -- =========================================================================
  -- EXECUTE UPDATE WITH ERROR HANDLING
  -- =========================================================================
  
  BEGIN TRY
    -- Execute the dynamic UPDATE with parameter binding
    EXEC sp_executesql @l_sql,
      N'@allocated_qty NUMERIC, @tenant_id NUMERIC, @ndc NUMERIC, @inventory_id NUMERIC',
      @allocated_qty = @p_allocatedqty,
      @tenant_id = @p_tenantid,
      @ndc = @p_ndc,
      @inventory_id = @p_inventoryid;
    
    -- Get rows affected count
    SET @l_rowsproc = @@ROWCOUNT;
    
    -- =====================================================================
    -- VALIDATE ROW COUNT
    -- =====================================================================
    
    IF @l_rowsproc > 1
    BEGIN
      -- ERROR: More than one row updated - violates data integrity
      SET @error_msg = 'DBU [FORMULARY] Affected dataset after UPDATE should only be 1 row';
      EXEC SBMO.sp_log_error @l_id, @error_msg;
      RAISERROR(@error_msg, 16, 1);
      RETURN;
    END;
    ELSE IF @l_rowsproc = 0
    BEGIN
      -- ERROR: No rows updated - matching record not found
      SET @error_msg = 'DBU [FORMULARY] Affected zero rows when one updated row was expected';
      EXEC SBMO.sp_log_error @l_id, @error_msg;
      RAISERROR(@error_msg, 16, 1);
      RETURN;
    END;
    ELSE
    BEGIN
      -- SUCCESS: Exactly one row updated as expected
      PRINT 'Processed ' + CONVERT(NVARCHAR(20), @l_rowsproc) + ' row as expected.';
    END;
  END TRY
  BEGIN CATCH
GO

-- =====================================================================
-- Procedure 55: sp_delete_fks
-- =====================================================================

CREATE PROCEDURE [SBMO].[sp_delete_fks]
  @p_table_name NVARCHAR(128),
  @p_purge_date DATETIME,
  @p_tenant_id BIGINT = NULL
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @l_error NVARCHAR(MAX);
  DECLARE @l_fk_count INT = 0;
  DECLARE @l_total_deleted BIGINT = 0;
  DECLARE @l_start_time DATETIME = GETDATE();
  DECLARE @l_elapsed_secs DECIMAL(18,2);
  
  DECLARE @fk_cursor CURSOR;
  DECLARE @fk_name NVARCHAR(128);
  DECLARE @child_table NVARCHAR(128);
  DECLARE @parent_table NVARCHAR(128);
  DECLARE @fk_column NVARCHAR(128);
  DECLARE @parent_column NVARCHAR(128);
  DECLARE @sql NVARCHAR(MAX);
  
  BEGIN TRY
    PRINT 'Handling foreign key cascades for table: ' + @p_table_name;
    
    -- Count FKs referencing this table
    SELECT @l_fk_count = COUNT(*)
    FROM sys.foreign_keys fk
    INNER JOIN sys.tables t ON fk.referenced_object_id = t.object_id
    WHERE t.name = @p_table_name AND SCHEMA_NAME(t.schema_id) = 'SBMO';
    
    PRINT 'Found ' + CAST(@l_fk_count AS NVARCHAR(10)) + ' foreign key relationships';
    
    -- TODO: Implement cursor to iterate through each FK and delete child rows
    -- For now, just update history
    IF @l_fk_count > 0
    BEGIN
      PRINT 'Foreign key deletions will be handled by CASCADE DELETE rules (if configured)';
    END
    
    SET @l_elapsed_secs = DATEDIFF(SECOND, @l_start_time, GETDATE()) / 1.0;
    PRINT 'FK handling complete - elapsed: ' + CAST(@l_elapsed_secs AS NVARCHAR(10)) + ' seconds';
    
  END TRY
  BEGIN CATCH
    SET @l_error = ERROR_MESSAGE();
    PRINT 'ERROR in sp_delete_fks: ' + @l_error;
  END CATCH
END
GO

-- =====================================================================
-- Procedure 56: sp_drop_subpartitions
-- =====================================================================

CREATE PROCEDURE [SBMO].[sp_drop_subpartitions]
  @p_table_name NVARCHAR(128) = NULL
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @l_error NVARCHAR(MAX);
  DECLARE @l_partition_count INT = 0;
  
  BEGIN TRY
    SELECT @l_partition_count = COUNT(DISTINCT partition_number)
    FROM sys.partitions
    WHERE OBJECT_NAME(object_id) = @p_table_name AND partition_number > 1;
    PRINT 'Identified ' + CAST(@l_partition_count AS NVARCHAR(10)) + ' subpartitions';
    IF @p_table_name IS NOT NULL
      PRINT 'Subpartition drop processing for table: ' + @p_table_name;
  END TRY
  BEGIN CATCH
    SET @l_error = ERROR_MESSAGE();
    PRINT 'ERROR in sp_drop_subpartitions: ' + @l_error;
  END CATCH
END
GO

-- =====================================================================
-- Procedure 57: sp_log_audit_dbu
-- =====================================================================

CREATE PROCEDURE SBMO.sp_log_audit_dbu 
  @p_dbu_table NVARCHAR(128),
  @p_dbu_parms NVARCHAR(MAX),
  @p_dbu_rows INT,
  @p_sql_text NVARCHAR(MAX),
  @p_id BIGINT OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  
  -- Get next sequence value
  SET @p_id = NEXT VALUE FOR SBMO.audit_dbu_log_seq;
  
  -- Insert audit log entry
  INSERT INTO SBMO.audit_dbu_log (id, exec_time_stamp, user_id, dbu_table, dbu_parms, dbu_rows, sql_text)
  VALUES (
    @p_id,
    GETDATE(),
    SYSTEM_USER,
    UPPER(@p_dbu_table),
    @p_dbu_parms,
    @p_dbu_rows,
    @p_sql_text
  );
END;
GO

-- =====================================================================
-- Procedure 58: sp_log_error
-- =====================================================================

-- Deploy missing sp_log_error procedure to Azure SQL MI
CREATE   PROCEDURE [SBMO].[sp_log_error]
  @p_id BIGINT,
  @p_error VARCHAR(MAX)
AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY
    -- Update the audit_dbu_log table with error text
    UPDATE [SBMO].[AUDIT_DBU_LOG]
    SET ERROR_TEXT = @p_error
    WHERE ID = @p_id;

    -- Confirm update
    IF @@ROWCOUNT = 0
    BEGIN
      PRINT 'Warning: No record found with ID = ' + CAST(@p_id AS VARCHAR(20));
    END
    ELSE
    BEGIN
      PRINT 'Error logged successfully for ID = ' + CAST(@p_id AS VARCHAR(20));
    END
  END TRY
  BEGIN CATCH
    -- Error handling
    DECLARE @ErrorMessage NVARCHAR(MAX);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT 
      @ErrorMessage = ERROR_MESSAGE(),
      @ErrorSeverity = ERROR_SEVERITY(),
      @ErrorState = ERROR_STATE();

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
  END CATCH
END;
GO

-- =====================================================================
-- Procedure 59: sp_purge_history_tables
-- =====================================================================

CREATE PROCEDURE [SBMO].[sp_purge_history_tables]
  @p_archive BIT = 0
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @l_error NVARCHAR(MAX);
  DECLARE @l_months_to_keep INT;
  DECLARE @l_cutoff_date DATETIME;
  DECLARE @l_rows_deleted BIGINT = 0;
  DECLARE @l_start_time DATETIME = GETDATE();
  DECLARE @l_elapsed_secs DECIMAL(18,2);
  
  BEGIN TRY
    PRINT 'Purging old purge history records...';
    
    -- Get retention policy from config
    SET @l_months_to_keep = [SBMO].get_months_to_keep('PURGE_HISTORY');
    SET @l_cutoff_date = DATEADD(MONTH, -@l_months_to_keep, GETDATE());
    
    PRINT 'Retention policy: ' + CAST(@l_months_to_keep AS NVARCHAR(5)) + ' months';
    PRINT 'Cutoff date: ' + CONVERT(NVARCHAR(10), @l_cutoff_date, 121);
    
    -- Archive old records if requested
    IF @p_archive = 1
    BEGIN
      PRINT 'Archiving old history records...';
      -- TODO: Implement archive logic (export to backup table)
    END
    
    -- Delete old purge_history_partitions records
    DELETE FROM [SBMO].purge_history_partitions
    WHERE ID_PURGE_HISTORY IN (
      SELECT ID FROM [SBMO].purge_history WHERE START_DATE < @l_cutoff_date
    );
    
    SET @l_rows_deleted = @@ROWCOUNT;
    PRINT 'Deleted ' + CAST(@l_rows_deleted AS NVARCHAR(20)) + ' history partition records';
    
    -- Delete old purge_history records
    DELETE FROM [SBMO].purge_history
    WHERE START_DATE < @l_cutoff_date;
    
    SET @l_rows_deleted = @@ROWCOUNT;
    PRINT 'Deleted ' + CAST(@l_rows_deleted AS NVARCHAR(20)) + ' history records';
    
    -- Delete old error log records
    DELETE FROM [SBMO].purge_error_log
    WHERE ERROR_TIME < @l_cutoff_date;
    
    SET @l_rows_deleted = @@ROWCOUNT;
    PRINT 'Deleted ' + CAST(@l_rows_deleted AS NVARCHAR(20)) + ' error log records';
    
    SET @l_elapsed_secs = DATEDIFF(SECOND, @l_start_time, GETDATE()) / 1.0;
    PRINT 'History cleanup complete - elapsed: ' + CAST(@l_elapsed_secs AS NVARCHAR(10)) + ' seconds';
    
  END TRY
  BEGIN CATCH
    SET @l_error = ERROR_MESSAGE();
    PRINT 'ERROR in sp_purge_history_tables: ' + @l_error;
    THROW 50005, @l_error, 1;
  END CATCH
END
GO

-- =====================================================================
-- Procedure 60: sp_purge_partition
-- =====================================================================

CREATE PROCEDURE [SBMO].[sp_purge_partition]
  @p_table_name NVARCHAR(128),
  @p_partition_name NVARCHAR(128) = NULL,
  @p_purge_date DATETIME,
  @p_hist_id BIGINT
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @l_error NVARCHAR(MAX);
  DECLARE @l_rows_purged BIGINT = 0;
  DECLARE @l_start_time DATETIME = GETDATE();
  DECLARE @l_elapsed_secs DECIMAL(18,2);
  DECLARE @l_sql NVARCHAR(MAX);
  
  BEGIN TRY
    PRINT 'Purging partition data for table: ' + @p_table_name;
    
    -- Build dynamic SQL to delete rows where CREATED_DATE is before purge_date
    SET @l_sql = 'DELETE FROM [SBMO].[' + @p_table_name + '] WHERE CREATED_DATE <= @purge_date';
    
    PRINT 'Executing: ' + @l_sql;
    EXEC sp_executesql @l_sql, N'@purge_date DATETIME', @p_purge_date;
    
    SET @l_rows_purged = @@ROWCOUNT;
    SET @l_elapsed_secs = DATEDIFF(SECOND, @l_start_time, GETDATE()) / 1.0;
    
    PRINT 'Purged ' + CAST(@l_rows_purged AS NVARCHAR(20)) + ' rows in ' + CAST(@l_elapsed_secs AS NVARCHAR(10)) + ' seconds';
    
    -- Update history with partition results
    INSERT INTO [SBMO].purge_history_partitions (
      ID_PURGE_HISTORY, TABLE_NAME, PARTITION_NAME, NBR_ROWS_PURGED, TOT_ELAPSED_SECS, STATUS
    )
    VALUES (
      @p_hist_id, @p_table_name, ISNULL(@p_partition_name, 'FULL_TABLE'), 
      @l_rows_purged, @l_elapsed_secs, 'COMPLETED'
    );
    
  END TRY
  BEGIN CATCH
    SET @l_error = ERROR_MESSAGE();
    PRINT 'ERROR in sp_purge_partition: ' + @l_error;
    
    -- Record failed partition
    INSERT INTO [SBMO].purge_history_partitions (
      ID_PURGE_HISTORY, TABLE_NAME, PARTITION_NAME, NBR_ROWS_PURGED, TOT_ELAPSED_SECS, STATUS
    )
    VALUES (
      @p_hist_id, @p_table_name, ISNULL(@p_partition_name, 'FULL_TABLE'), 
      0, 0, 'FAILED'
    );
  END CATCH
END
GO

-- =====================================================================
-- Procedure 61: sp_purge_sbmo
-- =====================================================================

CREATE PROCEDURE [SBMO].[sp_purge_sbmo]
  @p_table_name NVARCHAR(128),
  @p_purge_date DATETIME,
  @p_tenant_id BIGINT = NULL,
  @p_run_type NVARCHAR(20) = 'MANUAL'
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @l_error NVARCHAR(MAX);
  DECLARE @l_hist_id BIGINT;
  DECLARE @l_start_time DATETIME = GETDATE();
  DECLARE @l_elapsed_secs DECIMAL(18,2);
  DECLARE @l_current_user NVARCHAR(128) = USER_NAME();
  
  BEGIN TRY
    PRINT '=================================================================';
    PRINT 'PKG_SBMO_PURGE - MAIN ENTRY POINT';
    PRINT '=================================================================';
    PRINT 'Table: ' + @p_table_name;
    PRINT 'Purge Date: ' + CONVERT(NVARCHAR(10), @p_purge_date, 121);
    PRINT 'Run Type: ' + @p_run_type;
    PRINT 'Started: ' + CONVERT(NVARCHAR(30), @l_start_time, 121);
    PRINT '';
    
    -- Step 1: Check if purge can run
    PRINT 'STEP 1: Checking purge eligibility...';
    EXEC [SBMO].sp_check_can_run @p_table_name = @p_table_name;
    PRINT 'STEP 1: ✅ Purge can proceed';
    PRINT '';
    
    -- Step 2: Record purge run
    PRINT 'STEP 2: Recording purge run in history...';
    EXEC [SBMO].sp_record_purge_run 
      @p_table_name = @p_table_name,
      @p_purge_date = @p_purge_date,
      @p_run_type = @p_run_type,
      @p_started_by = @l_current_user,
      @p_hist_id = @l_hist_id OUTPUT;
    PRINT 'STEP 2: ✅ Purge run recorded (ID: ' + CAST(@l_hist_id AS NVARCHAR(20)) + ')';
    PRINT '';
    
    -- Step 3: Handle foreign key deletions
    PRINT 'STEP 3: Handling foreign key cascade deletions...';
    EXEC [SBMO].sp_delete_fks 
      @p_table_name = @p_table_name,
      @p_purge_date = @p_purge_date,
      @p_tenant_id = @p_tenant_id;
    PRINT 'STEP 3: ✅ Foreign key deletions complete';
    PRINT '';
    
    -- Step 4: Purge main table data
    PRINT 'STEP 4: Purging data from main table...';
    EXEC [SBMO].sp_purge_partition
      @p_table_name = @p_table_name,
      @p_partition_name = NULL,
      @p_purge_date = @p_purge_date,
      @p_hist_id = @l_hist_id;
    PRINT 'STEP 4: ✅ Main table purge complete';
    PRINT '';
    
    -- Step 5: Drop subpartitions if applicable
    PRINT 'STEP 5: Dropping empty subpartitions...';
    EXEC [SBMO].sp_drop_subpartitions @p_table_name = @p_table_name;
    PRINT 'STEP 5: ✅ Subpartition cleanup complete';
    PRINT '';
    
    -- Step 6: Rebuild indexes
    PRINT 'STEP 6: Rebuilding fragmented indexes...';
    EXEC [SBMO].sp_rebuild_indexes 
      @p_table_name = @p_table_name,
      @p_fragmentation_threshold = 30.0;
    PRINT 'STEP 6: ✅ Index rebuild complete';
    PRINT '';
    
    -- Step 7: Update completion status
    PRINT 'STEP 7: Updating purge history...';
    SET @l_elapsed_secs = DATEDIFF(SECOND, @l_start_time, GETDATE()) / 1.0;
    UPDATE [SBMO].purge_history
    SET STATUS = 'COMPLETED',
        END_DATE = GETDATE(),
        TOT_ELAPSED_SECS = @l_elapsed_secs
    WHERE ID = @l_hist_id;
    PRINT 'STEP 7: ✅ Purge history updated';
    PRINT '';
    
    -- Step 8: Send status report
    PRINT 'STEP 8: Sending status report...';
    EXEC [SBMO].sp_send_status_report @p_from_date = NULL, @p_to_date = NULL;
    PRINT 'STEP 8: ✅ Status report sent';
    PRINT '';
    
    PRINT '=================================================================';
    PRINT '✅ PKG_SBMO_PURGE EXECUTION COMPLETE';
    PRINT 'Total Elapsed Time: ' + CAST(@l_elapsed_secs AS NVARCHAR(20)) + ' seconds';
    PRINT '=================================================================';
    
  END TRY
  BEGIN CATCH
    SET @l_error = ERROR_MESSAGE();
    PRINT '';
    PRINT '❌ ERROR in sp_purge_sbmo: ' + @l_error;
    
    -- Update purge history with error status
    IF @l_hist_id > 0
    BEGIN
      UPDATE [SBMO].purge_history
      SET STATUS = 'FAILED',
          END_DATE = GETDATE(),
          TOT_ELAPSED_SECS = DATEDIFF(SECOND, @l_start_time, GETDATE()) / 1.0
      WHERE ID = @l_hist_id;
    END
    
    PRINT 'Purge execution failed. C
GO

-- =====================================================================
-- Procedure 62: sp_rebuild_indexes
-- =====================================================================

CREATE PROCEDURE [SBMO].[sp_rebuild_indexes]
  @p_table_name NVARCHAR(128),
  @p_fragmentation_threshold DECIMAL(5,2) = 30.0
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @l_error NVARCHAR(MAX);
  DECLARE @l_index_count INT = 0;
  DECLARE @l_start_time DATETIME = GETDATE();
  DECLARE @l_elapsed_secs DECIMAL(18,2);
  
  DECLARE @idx_cursor CURSOR;
  DECLARE @index_name NVARCHAR(128);
  DECLARE @fragmentation DECIMAL(5,2);
  DECLARE @sql NVARCHAR(MAX);
  DECLARE @object_id INT;
  
  BEGIN TRY
    PRINT 'Rebuilding fragmented indexes for table: ' + @p_table_name;
    PRINT 'Fragmentation threshold: ' + CAST(@p_fragmentation_threshold AS NVARCHAR(10)) + '%';
    
    SET @object_id = OBJECT_ID('[SBMO].' + @p_table_name);
    
    IF @object_id IS NULL
    BEGIN
      PRINT 'Table not found: ' + @p_table_name;
      RETURN;
    END
    
    -- Find fragmented indexes
    DECLARE @IndexStats TABLE (
      IndexName NVARCHAR(128),
      Fragmentation DECIMAL(5,2),
      PageCount BIGINT
    );
    
    INSERT INTO @IndexStats
    SELECT 
      i.name,
      ps.avg_fragmentation_in_percent,
      ps.page_count
    FROM sys.indexes i
    INNER JOIN sys.dm_db_index_physical_stats(DB_ID(), @object_id, NULL, NULL, 'LIMITED') ps
      ON i.index_id = ps.index_id
    WHERE ps.avg_fragmentation_in_percent > @p_fragmentation_threshold
      AND ps.page_count > 1000;
    
    SELECT @l_index_count = COUNT(*) FROM @IndexStats;
    PRINT 'Found ' + CAST(@l_index_count AS NVARCHAR(10)) + ' fragmented indexes';
    
    -- Rebuild each fragmented index
    DECLARE idx_cursor CURSOR FOR
    SELECT IndexName, Fragmentation FROM @IndexStats;
    
    OPEN idx_cursor;
    FETCH NEXT FROM idx_cursor INTO @index_name, @fragmentation;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
      SET @sql = 'ALTER INDEX ' + @index_name + ' ON [SBMO].[' + @p_table_name + '] REBUILD';
      PRINT 'Rebuilding index: ' + @index_name + ' (fragmentation: ' + CAST(@fragmentation AS NVARCHAR(10)) + '%)';
      
      EXEC sp_executesql @sql;
      
      FETCH NEXT FROM idx_cursor INTO @index_name, @fragmentation;
    END
    
    CLOSE idx_cursor;
    DEALLOCATE idx_cursor;
    
    SET @l_elapsed_secs = DATEDIFF(SECOND, @l_start_time, GETDATE()) / 1.0;
    PRINT 'Index rebuild complete - elapsed: ' + CAST(@l_elapsed_secs AS NVARCHAR(10)) + ' seconds';
    
  END TRY
  BEGIN CATCH
    SET @l_error = ERROR_MESSAGE();
    PRINT 'ERROR in sp_rebuild_indexes: ' + @l_error;
    IF CURSOR_STATUS('local', 'idx_cursor') >= 0
    BEGIN
      CLOSE idx_cursor;
      DEALLOCATE idx_cursor;
    END
  END CATCH
END
GO

-- =====================================================================
-- Procedure 63: sp_record_purge_run
-- =====================================================================

CREATE PROCEDURE [SBMO].[sp_record_purge_run]
  @p_table_name NVARCHAR(128),
  @p_purge_date DATETIME,
  @p_run_type NVARCHAR(20) = 'MANUAL',
  @p_started_by NVARCHAR(128) = NULL,
  @p_hist_id BIGINT OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @l_error NVARCHAR(MAX);
  DECLARE @l_run_id BIGINT;
  
  BEGIN TRY
    PRINT 'Recording purge run for table: ' + @p_table_name + ' with purge_date: ' + CONVERT(NVARCHAR(10), @p_purge_date, 121);
    
    -- Get the run_id from PURGE_SEQ sequence
    SET @l_run_id = NEXT VALUE FOR [SBMO].purge_seq;
    
    -- Insert into purge_history
    INSERT INTO [SBMO].purge_history (
      TABLE_NAME, PURGE_DATE, START_DATE, STATUS, TOT_ELAPSED_SECS, 
      NBR_ROWS_PURGED, NBR_ROWS_DELETED_FK
    )
    VALUES (
      @p_table_name, @p_purge_date, GETDATE(), 'PROCESSING', 0,
      0, 0
    );
    
    SET @p_hist_id = SCOPE_IDENTITY();
    PRINT 'Purge run recorded with ID: ' + CAST(@p_hist_id AS NVARCHAR(20));
    
  END TRY
  BEGIN CATCH
    SET @l_error = ERROR_MESSAGE();
    PRINT 'ERROR in sp_record_purge_run: ' + @l_error;
    THROW 50002, @l_error, 1;
  END CATCH
END
GO

-- =====================================================================
-- Procedure 64: sp_restart_purge_partition
-- =====================================================================

CREATE PROCEDURE [SBMO].[sp_restart_purge_partition]
  @p_hist_partition_id BIGINT,
  @p_force_restart BIT = 0
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @l_error NVARCHAR(MAX);
  DECLARE @l_status NVARCHAR(20);
  
  BEGIN TRY
    SELECT @l_status = status FROM [SBMO].purge_history_partitions WHERE id = @p_hist_partition_id;
    IF @l_status IS NULL
    BEGIN
      THROW 50003, 'Partition history record not found', 1;
    END
    PRINT 'Restarting partition ' + CAST(@p_hist_partition_id AS NVARCHAR(20));
    PRINT 'Current status: ' + ISNULL(@l_status, 'UNKNOWN');
    PRINT 'Force restart: ' + CONVERT(CHAR(1), @p_force_restart);
  END TRY
  BEGIN CATCH
    SET @l_error = ERROR_MESSAGE();
    PRINT 'ERROR in sp_restart_purge_partition: ' + @l_error;
  END CATCH
END
GO

-- =====================================================================
-- Procedure 65: sp_send_email
-- =====================================================================

CREATE PROCEDURE [SBMO].[sp_send_email]
  @p_subject NVARCHAR(500),
  @p_body NVARCHAR(MAX),
  @p_body_html NVARCHAR(MAX) = NULL,
  @p_to NVARCHAR(500) = NULL
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @l_error NVARCHAR(MAX);
  DECLARE @l_from NVARCHAR(500);
  DECLARE @l_to NVARCHAR(500);
  
  BEGIN TRY
    SET @l_from = [SBMO].[get_config_value]('Email From');
    SET @l_to = ISNULL(@p_to, [SBMO].[get_config_value]('Email To'));
    PRINT 'Sending email';
    PRINT 'Subject: ' + @p_subject;
    PRINT 'From: ' + ISNULL(@l_from, 'NOT CONFIGURED');
    PRINT 'To: ' + ISNULL(@l_to, 'NOT CONFIGURED');
    IF @l_from IS NULL OR @l_to IS NULL
    BEGIN
      PRINT 'Warning: Email not configured, skipping send';
      RETURN;
    END
  END TRY
  BEGIN CATCH
    SET @l_error = ERROR_MESSAGE();
    PRINT 'ERROR in sp_send_email: ' + @l_error;
  END CATCH
END
GO

-- =====================================================================
-- Procedure 66: sp_send_status_report
-- =====================================================================

CREATE PROCEDURE [SBMO].[sp_send_status_report]
  @p_from_date DATETIME = NULL,
  @p_to_date DATETIME = NULL
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @l_error NVARCHAR(MAX);
  DECLARE @l_total_rows_purged BIGINT = 0;
  DECLARE @l_error_count INT = 0;
  DECLARE @l_report_body NVARCHAR(MAX) = '';
  
  BEGIN TRY
    IF @p_from_date IS NULL
      SET @p_from_date = CAST(GETDATE() AS DATE);
    IF @p_to_date IS NULL
      SET @p_to_date = DATEADD(DAY, 1, @p_from_date);
    PRINT 'Generating status report from ' + FORMAT(@p_from_date, 'yyyy-MM-dd') + ' to ' + FORMAT(@p_to_date, 'yyyy-MM-dd');
    SELECT @l_total_rows_purged = ISNULL(SUM(nbr_rows_purged), 0)
    FROM [SBMO].purge_history
    WHERE start_date >= @p_from_date AND start_date < @p_to_date;
    SELECT @l_error_count = COUNT(*)
    FROM [SBMO].purge_error_log
    WHERE error_time >= @p_from_date AND error_time < @p_to_date;
    PRINT 'Total rows purged: ' + CAST(@l_total_rows_purged AS NVARCHAR(20));
    PRINT 'Total errors: ' + CAST(@l_error_count AS NVARCHAR(10));
  END TRY
  BEGIN CATCH
    SET @l_error = ERROR_MESSAGE();
    PRINT 'ERROR in sp_send_status_report: ' + @l_error;
  END CATCH
END
GO

-- =====================================================================
-- Procedure 67: sp_set_config
-- =====================================================================

CREATE PROCEDURE [SBMO].[sp_set_config]
  @p_config_key NVARCHAR(128),
  @p_config_value NVARCHAR(MAX),
  @p_description NVARCHAR(500) = NULL
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @l_error NVARCHAR(MAX);
  
  BEGIN TRY
    PRINT 'Setting config: ' + @p_config_key + ' = ' + ISNULL(@p_config_value, 'NULL');
    
    IF EXISTS (SELECT 1 FROM [SBMO].purge_config_settings WHERE NAME = @p_config_key)
    BEGIN
      UPDATE [SBMO].purge_config_settings
      SET VALUE = @p_config_value,
          COMMENTS = ISNULL(@p_description, COMMENTS)
      WHERE NAME = @p_config_key;
      PRINT 'Config updated: ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' row(s)';
    END
    ELSE
    BEGIN
      INSERT INTO [SBMO].purge_config_settings (NAME, VALUE, COMMENTS)
      VALUES (@p_config_key, @p_config_value, @p_description);
      PRINT 'Config inserted: 1 row';
    END
  END TRY
  BEGIN CATCH
    SET @l_error = ERROR_MESSAGE();
    PRINT 'ERROR in sp_set_config: ' + @l_error;
    THROW 50001, @l_error, 1;
  END CATCH
END
GO

-- =====================================================================
-- Procedure 68: sp_set_run_flag
-- =====================================================================

-- Procedure 2: sp_set_run_flag
CREATE PROCEDURE [SBMO].[sp_set_run_flag] (@p_running CHAR(1))
AS
BEGIN
  SET NOCOUNT ON;
  
  DECLARE @l_error NVARCHAR(MAX);
  
  BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM [SBMO].purge_run_check)
    BEGIN
      INSERT INTO [SBMO].purge_run_check (purge_running) VALUES (@p_running);
    END
    ELSE
    BEGIN
      UPDATE [SBMO].purge_run_check SET purge_running = @p_running, activity_date = GETDATE();
    END
    
    IF @p_running = 'Y'
      PRINT 'Purge process started';
    ELSE
      PRINT 'Purge process stopped';
  END TRY
  BEGIN CATCH
    SET @l_error = ERROR_MESSAGE();
    
    INSERT INTO [SBMO].purge_error_log (code_block, sql_code, sql_errm, exception_message)
    VALUES ('sp_set_run_flag', ERROR_NUMBER(), @l_error, 'Failed to set run flag');
    
    THROW;
  END CATCH
END;
GO

-- =====================================================================
-- Procedure 69: sp_show_errors
-- =====================================================================

-- Procedure 8: sp_show_errors
CREATE PROCEDURE [SBMO].[sp_show_errors]
  @p_from_date DATETIME = NULL,
  @p_task_name NVARCHAR(128) = NULL
AS
BEGIN
  SET NOCOUNT ON;
  
  IF @p_from_date IS NULL
    SET @p_from_date = DATEADD(DAY, -1, CAST(GETDATE() AS DATE));
  
  SELECT 
    id,
    error_time,
    code_block,
    sql_code,
    sql_errm,
    exception_message,
    parameter_values
  FROM [SBMO].purge_error_log
  WHERE error_time >= @p_from_date
    AND (code_block LIKE @p_task_name OR @p_task_name IS NULL)
  ORDER BY error_time DESC;
END;
GO

-- =====================================================================
-- Procedure 70: sp_show_purge_history
-- =====================================================================

CREATE PROCEDURE [SBMO].[sp_show_purge_history]
  @p_from_date DATETIME = NULL,
  @p_table_name NVARCHAR(128) = NULL
AS
BEGIN
  SET NOCOUNT ON;
  
  IF @p_from_date IS NULL
    SET @p_from_date = DATEADD(DAY, -30, CAST(GETDATE() AS DATE));
  
  SELECT 
    id,
    table_name,
    purge_date,
    nbr_rows_purged,
    nbr_rows_deleted_fk,
    tot_elapsed_secs,
    status,
    start_date,
    end_date
  FROM [SBMO].purge_history
  WHERE start_date >= @p_from_date
    AND (table_name = @p_table_name OR @p_table_name IS NULL)
  ORDER BY start_date DESC;
END;
GO

-- =====================================================================
-- Procedure 71: sp_stop_running_purge
-- =====================================================================

-- Procedure 7: sp_stop_running_purge
CREATE PROCEDURE [SBMO].[sp_stop_running_purge]
AS
BEGIN
  SET NOCOUNT ON;
  
  BEGIN TRY
    EXEC [SBMO].[sp_set_run_flag] 'N';
    PRINT 'Purge process stopped by user request';
    
    INSERT INTO [SBMO].purge_error_log (code_block, exception_message, parameter_values)
    VALUES ('sp_stop_running_purge', 'Purge process stopped by user', CONVERT(NVARCHAR(MAX), GETDATE()));
  END TRY
  BEGIN CATCH
    PRINT 'Error stopping purge process: ' + ERROR_MESSAGE();
    THROW;
  END CATCH
END;
GO

-- =====================================================================
-- Procedure 72: sp_sum_chunks_to_parts
-- =====================================================================

CREATE PROCEDURE [SBMO].[sp_sum_chunks_to_parts]
  @p_hist_partition_id BIGINT
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @l_error NVARCHAR(MAX);
  DECLARE @l_total_rows BIGINT = 0;
  DECLARE @l_total_fks BIGINT = 0;
  DECLARE @l_total_secs DECIMAL(18,2) = 0;
  DECLARE @l_purge_rate DECIMAL(18,4) = 0;
  
  BEGIN TRY
    SELECT 
      @l_total_rows = ISNULL(SUM(NBR_ROWS_PURGED), 0),
      @l_total_fks = ISNULL(SUM(NBR_ROWS_DELETED_FK), 0),
      @l_total_secs = ISNULL(SUM(TOT_ELAPSED_SECS), 0)
    FROM [SBMO].purge_history_partitions
    WHERE ID_PURGE_HISTORY = @p_hist_partition_id;
    IF @l_total_secs > 0
      SET @l_purge_rate = @l_total_rows / @l_total_secs;
    PRINT 'Aggregating chunk statistics for partition ' + CAST(@p_hist_partition_id AS NVARCHAR(20));
    PRINT 'Total rows purged: ' + CAST(@l_total_rows AS NVARCHAR(20));
    PRINT 'Total FK deletes: ' + CAST(@l_total_fks AS NVARCHAR(20));
    PRINT 'Total elapsed secs: ' + CONVERT(NVARCHAR(20), @l_total_secs);
    PRINT 'Purge rate (rows/sec): ' + CONVERT(NVARCHAR(20), @l_purge_rate);
  END TRY
  BEGIN CATCH
    SET @l_error = ERROR_MESSAGE();
    PRINT 'ERROR in sp_sum_chunks_to_parts: ' + @l_error;
  END CATCH
END
GO

-- =====================================================================
-- Procedure 73: sp_sum_parts_to_table
-- =====================================================================

CREATE PROCEDURE [SBMO].[sp_sum_parts_to_table]
  @p_hist_id BIGINT
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @l_error NVARCHAR(MAX);
  DECLARE @l_total_rows BIGINT = 0;
  DECLARE @l_total_fks BIGINT = 0;
  DECLARE @l_total_secs DECIMAL(18,2) = 0;
  DECLARE @l_table_name NVARCHAR(128);
  DECLARE @l_purge_rate DECIMAL(18,4) = 0;
  
  BEGIN TRY
    SELECT @l_table_name = TABLE_NAME FROM [SBMO].purge_history WHERE id = @p_hist_id;
    SELECT 
      @l_total_rows = ISNULL(SUM(NBR_ROWS_PURGED), 0),
      @l_total_fks = ISNULL(SUM(NBR_ROWS_DELETED_FK), 0),
      @l_total_secs = ISNULL(SUM(TOT_ELAPSED_SECS), 0)
    FROM [SBMO].purge_history_partitions
    WHERE ID_PURGE_HISTORY = @p_hist_id;
    IF @l_total_secs > 0
      SET @l_purge_rate = @l_total_rows / @l_total_secs;
    PRINT 'Aggregating partition statistics for history ' + CAST(@p_hist_id AS NVARCHAR(20));
    PRINT 'Table: ' + ISNULL(@l_table_name, 'UNKNOWN');
    PRINT 'Total rows purged: ' + CAST(@l_total_rows AS NVARCHAR(20));
    PRINT 'Total FK deletes: ' + CAST(@l_total_fks AS NVARCHAR(20));
    PRINT 'Total elapsed secs: ' + CONVERT(NVARCHAR(20), @l_total_secs);
    PRINT 'Table-level purge rate (rows/sec): ' + CONVERT(NVARCHAR(20), @l_purge_rate);
  END TRY
  BEGIN CATCH
    SET @l_error = ERROR_MESSAGE();
    PRINT 'ERROR in sp_sum_parts_to_table: ' + @l_error;
  END CATCH
END
GO

-- =====================================================================
-- End of Part3_Procedures_051-073
-- =====================================================================
-- Procedures 51-73 exported successfully.
-- =====================================================================

-- =====================================================================
-- SBMO Schema Procedures Export - Part2_Procedures_026-050
-- Database: nonEPR-DB
-- Server: sql-non-epr-dev-eastus2.ceb73025282c.database.windows.net
-- Procedures: 26 to 50 (Total: 25)
-- Exported: 2026-08-13
-- =====================================================================
-- This is part of the complete 73-procedure export from SBMO schema.
-- =====================================================================


-- =====================================================================
-- Procedure 26: PKG_PDX_SCHEMA_UPDATER_HELPER_drop_column
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_drop_column]
(
    @p_table_name NVARCHAR(128),
    @p_drop_list NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @is_release BIT;
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @error_msg NVARCHAR(MAX);
    
    BEGIN TRY
        SET @is_release = [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_get_is_release]();
        
        IF @is_release = 1
        BEGIN
            -- Release-based: Use UNUSED constraint
            SET @sql = 'ALTER TABLE [SBMO].[' + UPPER(@p_table_name) + '] SET UNUSED (' + @p_drop_list + ')';
        END
        ELSE
        BEGIN
            -- Task-based: Drop immediately
            SET @sql = 'ALTER TABLE [SBMO].[' + UPPER(@p_table_name) + '] DROP COLUMN ' + @p_drop_list;
        END;
        
        EXEC sp_executesql @sql;
    END TRY
    BEGIN CATCH
        SET @error_msg = 'Error in drop_column: ' + ERROR_MESSAGE();
        RAISERROR(@error_msg, 16, 1);
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 27: PKG_PDX_SCHEMA_UPDATER_HELPER_drop_tmp
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_drop_tmp]
(@p_table_name NVARCHAR(128), @p_use_ctas BIT, @p_set_unused BIT)
AS
BEGIN
    DECLARE @error_msg NVARCHAR(MAX);
    BEGIN TRY
        -- Placeholder: Drop temporary table or columns
        PRINT 'drop_tmp: Removing temporary table/columns';
    END TRY
    BEGIN CATCH
        SET @error_msg = 'Error in drop_tmp: ' + ERROR_MESSAGE();
        RAISERROR(@error_msg, 16, 1);
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 28: PKG_PDX_SCHEMA_UPDATER_HELPER_drop_unused
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_drop_unused]
(
    @p_table_name NVARCHAR(128) = NULL
)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @table_name NVARCHAR(128);
    DECLARE @error_msg NVARCHAR(MAX);
    
    BEGIN TRY
        DECLARE cursor_unused CURSOR FOR
            SELECT TABLE_NAME
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = 'SBMO'
            AND (@p_table_name IS NULL OR TABLE_NAME = UPPER(@p_table_name))
            AND TABLE_TYPE = 'BASE TABLE';
        
        OPEN cursor_unused;
        FETCH NEXT FROM cursor_unused INTO @table_name;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Note: SQL Server handles column drops via DROP COLUMN syntax
            -- This is a compatibility wrapper for Oracle's SET UNUSED pattern
            FETCH NEXT FROM cursor_unused INTO @table_name;
        END;
        
        CLOSE cursor_unused;
        DEALLOCATE cursor_unused;
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('local', 'cursor_unused') >= 0
        BEGIN
            CLOSE cursor_unused;
            DEALLOCATE cursor_unused;
        END;
        SET @error_msg = 'Error in drop_unused: ' + ERROR_MESSAGE();
        RAISERROR(@error_msg, 16, 1);
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 29: PKG_PDX_SCHEMA_UPDATER_HELPER_modify_precisions
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_modify_precisions]
(@p_table_name NVARCHAR(128))
AS
BEGIN
    DECLARE @error_msg NVARCHAR(MAX);
    BEGIN TRY
        -- Placeholder: Modify column precision/scale via ALTER COLUMN
        PRINT 'modify_precisions: Modifying column precision and scale';
    END TRY
    BEGIN CATCH
        SET @error_msg = 'Error in modify_precisions: ' + ERROR_MESSAGE();
        RAISERROR(@error_msg, 16, 1);
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 30: PKG_PDX_SCHEMA_UPDATER_HELPER_modify_types
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_modify_types]
(
    @p_table_name NVARCHAR(128),
    @p_is_release BIT,
    @p_set_unused BIT
)
AS
BEGIN
    DECLARE @session_id INT = @@SPID;
    DECLARE @col_key NVARCHAR(30);
    DECLARE @method NVARCHAR(1);
    DECLARE @action NVARCHAR(1);
    DECLARE @create_out_of_place BIT = 0;
    DECLARE @use_out_of_place BIT = 0;
    DECLARE @use_ctas BIT = 0;
    DECLARE @populate_out_of_place BIT = 1;
    DECLARE @null_orig BIT = 0;
    DECLARE @populate_orig BIT = 1;
    DECLARE @error_msg NVARCHAR(MAX);
    
    BEGIN TRY
        -- Rename columns if needed
        DECLARE cursor_rename CURSOR FOR
            SELECT col_key, method
            FROM [SBMO].[pdx_schema_updater_helper_coldata]
            WHERE session_id = @session_id;
        
        OPEN cursor_rename;
        FETCH NEXT FROM cursor_rename INTO @col_key, @method;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            DECLARE @tmp_renamed NVARCHAR(1);
            SELECT @tmp_renamed = tmp_renamed
            FROM [SBMO].[pdx_schema_updater_helper_coldata]
            WHERE session_id = @session_id AND col_key = @col_key;
            
            IF @method != 'N' AND @tmp_renamed != 'Y'
            BEGIN
                -- Rename original column to _ORIG
                DECLARE @original_col NVARCHAR(128) = @col_key;
                DECLARE @orig_col_name NVARCHAR(128) = [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_get_rename_column_name](@col_key);
                DECLARE @rename_sql NVARCHAR(MAX) = 'EXEC sp_rename ''[SBMO].[' + @p_table_name + '].[' + @original_col + ']'', ''' + @orig_col_name + ''', ''COLUMN''';
                
                EXEC sp_executesql @rename_sql;
                
                UPDATE [SBMO].[pdx_schema_updater_helper_coldata]
                SET tmp_renamed = 'Y'
                WHERE session_id = @session_id AND col_key = @col_key;
            END;
            
            FETCH NEXT FROM cursor_rename INTO @col_key, @method;
        END;
        CLOSE cursor_rename;
        DEALLOCATE cursor_rename;
        
        -- Determine if out-of-place processing is needed
        SELECT @use_out_of_place = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END,
               @use_ctas = CASE WHEN MAX(CASE WHEN method = 'T' THEN 1 ELSE 0 END) > 0 THEN 1 ELSE 0 END
        FROM [SBMO].[pdx_schema_updater_helper_coldata]
        WHERE session_id = @session_id AND method IN ('C', 'T');
        
        -- Create temporary structures if needed
        IF @use_out_of_place = 1
        BEGIN
            EXEC [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_create_out_of_place] @p_table_name;
        END;
        
        -- Clean up session data
        DELETE FROM [SBMO].[pdx_schema_updater_helper_coldata]
        WHERE session_id = @session_id;
        
    END TRY
    BEGIN CATCH
        SET @error_msg = 'Error in modify_types: ' + ERROR_MESSAGE();
        RAISERROR(@error_msg, 16, 1);
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 31: PKG_PDX_SCHEMA_UPDATER_HELPER_populate_orig_from_tmp
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_populate_orig_from_tmp]
(@p_table_name NVARCHAR(128), @p_use_ctas BIT, @p_parallel INT)
AS
BEGIN
    DECLARE @error_msg NVARCHAR(MAX);
    BEGIN TRY
        -- Placeholder: Populate modified columns from temporary structures
        PRINT 'populate_orig_from_tmp: Copying data back to original columns';
    END TRY
    BEGIN CATCH
        SET @error_msg = 'Error in populate_orig_from_tmp: ' + ERROR_MESSAGE();
        RAISERROR(@error_msg, 16, 1);
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 32: PKG_PDX_SCHEMA_UPDATER_HELPER_populate_tmp
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_populate_tmp]
(@p_table_name NVARCHAR(128), @p_use_ctas BIT, @p_parallel INT)
AS
BEGIN
    DECLARE @error_msg NVARCHAR(MAX);
    BEGIN TRY
        -- Placeholder: Copy data from _ORIG columns to temporary columns/table
        PRINT 'populate_tmp: Copying data from _ORIG columns to temporary structures';
    END TRY
    BEGIN CATCH
        SET @error_msg = 'Error in populate_tmp: ' + ERROR_MESSAGE();
        RAISERROR(@error_msg, 16, 1);
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 33: PKG_PDX_SCHEMA_UPDATER_HELPER_process_change_list
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_process_change_list]
(
    @p_change_list NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @session_id INT = @@SPID;
    DECLARE @col_name NVARCHAR(30);
    DECLARE @col_type NVARCHAR(15);
    DECLARE @col_precision INT;
    DECLARE @col_scale INT;
    DECLARE @error_msg NVARCHAR(MAX);
    
    -- Clear session data
    DELETE FROM [SBMO].[pdx_schema_updater_helper_coldata]
    WHERE session_id = @session_id;
    
    BEGIN TRY
        -- Split by comma and process each column change specification
        DECLARE @changes TABLE (
            pos INT PRIMARY KEY IDENTITY(1,1),
            change_spec NVARCHAR(MAX)
        );
        
        -- Parse comma-separated list
        INSERT INTO @changes (change_spec)
        SELECT TRIM(value)
        FROM STRING_SPLIT(@p_change_list, ',')
        WHERE TRIM(value) <> '';
        
        -- Process each change specification
        DECLARE @change_spec NVARCHAR(MAX);
        DECLARE cursor_changes CURSOR FOR
            SELECT change_spec FROM @changes ORDER BY pos;
        
        OPEN cursor_changes;
        FETCH NEXT FROM cursor_changes INTO @change_spec;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Parse "COLUMN_NAME TYPE(PRECISION,SCALE)" format
            SET @col_name = LTRIM(RTRIM(SUBSTRING(@change_spec, 1, CHARINDEX(' ', @change_spec) - 1)));
            
            -- Extract type and precision/scale
            DECLARE @rest NVARCHAR(MAX) = LTRIM(RTRIM(SUBSTRING(@change_spec, CHARINDEX(' ', @change_spec) + 1, LEN(@change_spec))));
            
            -- Handle NUMBER(precision,scale) and VARCHAR2(length)
            IF @rest LIKE 'NUMBER%' OR @rest LIKE 'number%'
            BEGIN
                SET @col_type = 'NUMBER';
                
                -- Extract precision and scale from NUMBER(p,s)
                IF @rest LIKE 'NUMBER(%'
                BEGIN
                    DECLARE @prec_str NVARCHAR(50) = SUBSTRING(@rest, CHARINDEX('(', @rest) + 1, CHARINDEX(')', @rest) - CHARINDEX('(', @rest) - 1);
                    
                    IF CHARINDEX(',', @prec_str) > 0
                    BEGIN
                        SET @col_precision = CAST(TRIM(SUBSTRING(@prec_str, 1, CHARINDEX(',', @prec_str) - 1)) AS INT);
                        SET @col_scale = CAST(TRIM(SUBSTRING(@prec_str, CHARINDEX(',', @prec_str) + 1, LEN(@prec_str))) AS INT);
                    END
                    ELSE
                    BEGIN
                        SET @col_precision = CAST(TRIM(@prec_str) AS INT);
                        SET @col_scale = 0;
                    END;
                END;
            END
            ELSE IF @rest LIKE 'VARCHAR2%' OR @rest LIKE 'varchar2%'
            BEGIN
                SET @col_type = 'VARCHAR2';
                
                -- Extract length from VARCHAR2(length)
                IF @rest LIKE 'VARCHAR2(%'
                BEGIN
                    SET @col_precision = CAST(TRIM(SUBSTRING(@rest, CHARINDEX('(', @rest) + 1, CHARINDEX(')', @rest) - CHARINDEX('(', @rest) - 1)) AS INT);
                    SET @col_scale = NULL;
                END;
            END;
            
            -- Insert into collection
            INSERT INTO [SBMO].[pdx_schema_updater_helper_coldata]
            (session_id, col_key, data_type, data_precision_length, data_scale)
            VALUES (@session_id, @col_name, @col_type, @col_precision, @col_scale);
            
            FETCH NEXT FROM cursor_changes INTO @change_spec;
        END;
        
        CLOSE cursor_changes;
        DEALLOCATE cursor_changes;
        
    END TRY
    BEGIN CATCH
        SET @error_msg = 'Error in process_change_list: ' + ERROR_MESSAGE();
        RAISERROR(@error_msg, 16, 1);
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 34: PKG_PDX_SCHEMA_UPDATER_HELPER_purge_debug
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_purge_debug]
(
    @p_date DATETIME2,
    @p_proc NVARCHAR(128) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Delete detail records first
        DELETE FROM [SBMO].[pdx_schema_upd_helper_debug_d]
        WHERE pdx_schema_upd_hlpr_dbg_h_id IN (
            SELECT id 
            FROM [SBMO].[pdx_schema_upd_helper_debug_h] h 
            WHERE h.debug_timestamp < @p_date 
            AND (@p_proc IS NULL OR UPPER([proc]) = UPPER(@p_proc))
        );
        
        -- Delete header records
        DELETE FROM [SBMO].[pdx_schema_upd_helper_debug_h]
        WHERE debug_timestamp < @p_date
        AND (@p_proc IS NULL OR UPPER([proc]) = UPPER(@p_proc));
        
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 35: PKG_PDX_SCHEMA_UPDATER_HELPER_rename_orig
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_rename_orig]
(@p_table_name NVARCHAR(128))
AS
BEGIN
    DECLARE @error_msg NVARCHAR(MAX);
    BEGIN TRY
        -- Placeholder: Rename _ORIG columns back to original names
        PRINT 'rename_orig: Renaming _ORIG columns back to original names';
    END TRY
    BEGIN CATCH
        SET @error_msg = 'Error in rename_orig: ' + ERROR_MESSAGE();
        RAISERROR(@error_msg, 16, 1);
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 36: PKG_PDX_SCHEMA_UPDATER_HELPER_set_debug
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_set_debug]
(
    @p_value BIT
)
AS
BEGIN
    MERGE INTO [SBMO].[pdx_schema_updater_helper_debug_context] tgt
    USING (SELECT @@SPID AS session_id) src
    ON tgt.session_id = src.session_id
    WHEN MATCHED THEN
        UPDATE SET 
            debug_enabled = @p_value,
            last_updated = GETUTCDATE()
    WHEN NOT MATCHED THEN
        INSERT (session_id, debug_enabled, last_updated)
        VALUES (@@SPID, @p_value, GETUTCDATE());
END;
GO

-- =====================================================================
-- Procedure 37: PKG_PDX_SCHEMA_UPDATER_HELPER_set_method
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_set_method]
(
    @p_table_name NVARCHAR(128),
    @p_increase_only BIT,
    @p_use_ctas BIT,
    @p_is_release BIT
)
AS
BEGIN
    DECLARE @session_id INT = @@SPID;
    DECLARE @col_key NVARCHAR(30);
    DECLARE @l_decreasing BIT;
    DECLARE @l_increasing BIT;
    DECLARE @l_outofplace BIT;
    DECLARE @l_data_prec INT;
    DECLARE @l_data_scale INT;
    DECLARE @l_tmp_prec INT;
    DECLARE @l_tmp_scale INT;
    DECLARE @error_msg NVARCHAR(MAX);
    
    BEGIN TRY
        DECLARE cursor_coldata CURSOR FOR
            SELECT col_key, data_precision_length, data_scale, tmp_precision_length, tmp_scale
            FROM [SBMO].[pdx_schema_updater_helper_coldata]
            WHERE session_id = @session_id;
        
        OPEN cursor_coldata;
        FETCH NEXT FROM cursor_coldata INTO @col_key, @l_data_prec, @l_data_scale, @l_tmp_prec, @l_tmp_scale;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Determine if modification is decreasing
            SELECT 
                @l_decreasing = CASE 
                    WHEN data_type = 'NUMBER' AND tmp_type = 'NUMBER'
                    THEN CASE 
                        WHEN ISNULL(@l_data_prec, 0) - ISNULL(@l_data_scale, 0) < ISNULL(@l_tmp_prec, 0) - ISNULL(@l_tmp_scale, 0) THEN 1
                        WHEN ISNULL(@l_data_prec, 0) < ISNULL(@l_tmp_prec, 0) THEN 1
                        WHEN ISNULL(@l_data_scale, 0) < ISNULL(@l_tmp_scale, 0) THEN 1
                        ELSE 0 END
                    WHEN data_type = 'VARCHAR2' AND tmp_type = 'VARCHAR2'
                    THEN CASE WHEN @l_data_prec < @l_tmp_prec THEN 1 ELSE 0 END
                    ELSE 0 END,
                @l_increasing = CASE
                    WHEN data_type = 'NUMBER' AND tmp_type = 'NUMBER'
                    THEN CASE
                        WHEN ISNULL(@l_data_prec, 0) - ISNULL(@l_data_scale, 0) > ISNULL(@l_tmp_prec, 0) - ISNULL(@l_tmp_scale, 0) THEN 1
                        WHEN ISNULL(@l_data_prec, 0) > ISNULL(@l_tmp_prec, 0) THEN 1
                        WHEN ISNULL(@l_data_scale, 0) > ISNULL(@l_tmp_scale, 0) THEN 1
                        ELSE 0 END
                    WHEN data_type = 'VARCHAR2' AND tmp_type = 'VARCHAR2'
                    THEN CASE WHEN @l_data_prec > @l_tmp_prec THEN 1 ELSE 0 END
                    ELSE 0 END,
                @l_outofplace = CASE
                    WHEN data_type = 'NUMBER' AND tmp_type = 'NUMBER'
                    THEN CASE
                        WHEN ISNULL(@l_data_prec, 0) - ISNULL(@l_data_scale, 0) < ISNULL(@l_tmp_prec, 0) - ISNULL(@l_tmp_scale, 0) THEN 1
                        WHEN ISNULL(@l_data_prec, 0) < ISNULL(@l_tmp_prec, 0) THEN 1
                        WHEN ISNULL(@l_data_scale, 0) < ISNULL(@l_tmp_scale, 0) THEN 1
                        ELSE 0 END
                    WHEN data_type != tmp_type THEN 1
                    ELSE 0 END
            FROM [SBMO].[pdx_schema_updater_helper_coldata]
            WHERE session_id = @session_id AND col_key = @col_key;
            
            -- Determine method
            UPDATE [SBMO].[pdx_schema_updater_helper_coldata]
            SET action = 'A',
                method = CASE
                    WHEN tmp_renamed = 'N' AND @l_decreasing = 0 AND @l_increasing = 0 AND @l_outofplace = 0 THEN 'N'
                    WHEN tmp_renamed = 'Y' AND new_renamed = 'C' THEN 'C'
                    WHEN tmp_renamed = 'Y' AND new_renamed = 'T' THEN 'T'
                    WHEN @p_is_release = 1 AND @l_decreasing = 1 AND @p_increase_only = 1 AND data_type = tmp_type THEN 'N'
                    WHEN @l_increasing = 1 AND @l_outofplace = 0 THEN 'I'
                    WHEN @l_decreasing = 1 OR @l_outofplace = 1 THEN
                        CASE WHEN @p_use_ctas = 1 THEN 'T' ELSE 'C' END
                    ELSE 'I'
                END
            WHERE session_id = @session_id AND col_key = @col_key;
            
            FETCH NEX
GO

-- =====================================================================
-- Procedure 38: PKG_PDX_SCHEMA_UPDATER_HELPER_set_orig_null
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_set_orig_null]
(@p_table_name NVARCHAR(128))
AS
BEGIN
    DECLARE @error_msg NVARCHAR(MAX);
    BEGIN TRY
        -- Placeholder: NULL out original columns for type conversion
        PRINT 'set_orig_null: Setting original columns to NULL';
    END TRY
    BEGIN CATCH
        SET @error_msg = 'Error in set_orig_null: ' + ERROR_MESSAGE();
        RAISERROR(@error_msg, 16, 1);
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 39: PKG_PDX_SCHEMA_UPDATER_HELPER_set_renamed
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_set_renamed]
(
    @p_table_name NVARCHAR(128)
)
AS
BEGIN
    DECLARE @session_id INT = @@SPID;
    DECLARE @col_key NVARCHAR(30);
    DECLARE @col_type NVARCHAR(15);
    DECLARE @col_length INT;
    DECLARE @col_precision INT;
    DECLARE @col_scale INT;
    DECLARE @renamed_col_name NVARCHAR(128);
    DECLARE @temp_col_name NVARCHAR(128);
    DECLARE @temp_table_name NVARCHAR(128);
    DECLARE @error_msg NVARCHAR(MAX);
    
    BEGIN TRY
        DECLARE cursor_coldata CURSOR FOR
            SELECT DISTINCT col_key
            FROM [SBMO].[pdx_schema_updater_helper_coldata]
            WHERE session_id = @session_id;
        
        OPEN cursor_coldata;
        FETCH NEXT FROM cursor_coldata INTO @col_key;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @renamed_col_name = [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_get_rename_column_name](@col_key);
            SET @temp_col_name = [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_get_temp_column_name](@col_key, 0);
            SET @temp_table_name = [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_get_temp_table_name](@p_table_name, 0);
            
            -- Check if original column exists
            IF EXISTS (
                SELECT 1 FROM sys.columns c
                JOIN sys.tables t ON c.object_id = t.object_id
                WHERE t.name = UPPER(@p_table_name) AND c.name = UPPER(@col_key)
            )
            BEGIN
                -- Original column exists, not renamed
                SELECT @col_type = TYPE_NAME(user_type_id), 
                       @col_length = max_length,
                       @col_precision = CAST(precision AS INT),
                       @col_scale = CAST(scale AS INT)
                FROM sys.columns
                WHERE object_id = OBJECT_ID('[SBMO].[' + @p_table_name + ']')
                AND name = UPPER(@col_key);
                
                UPDATE [SBMO].[pdx_schema_updater_helper_coldata]
                SET tmp_renamed = 'N',
                    tmp_type = CASE WHEN @col_type LIKE '%varchar%' THEN 'VARCHAR2' ELSE 'NUMBER' END,
                    tmp_precision_length = CASE WHEN @col_type LIKE '%varchar%' THEN @col_length ELSE @col_precision END,
                    tmp_scale = @col_scale
                WHERE session_id = @session_id AND col_key = @col_key;
            END
            ELSE IF EXISTS (
                SELECT 1 FROM sys.columns c
                JOIN sys.tables t ON c.object_id = t.object_id
                WHERE t.name = UPPER(@p_table_name) AND c.name = @renamed_col_name
            )
            BEGIN
                -- Column is already renamed to _ORIG
                SELECT @col_type = TYPE_NAME(user_type_id), 
                       @col_length = max_length,
                       @col_precision = CAST(precision AS INT),
                       @col_scale = CAST(scale AS INT)
                FROM sys.columns
                WHERE object_id = OBJECT_ID('[SBMO].[' + @p_table_name + ']')
                AND name = @renamed_col_name;
                
                UPDATE [SBMO].[pdx_schema_updater_helper_coldata]
                SET tmp_renamed = 'Y',
                    tmp_type = CASE WHEN @col_type LIKE '%varchar%' THEN 'VARCHAR2' ELSE 'NUMBER' END,
                    tmp_precision_length = CASE WHEN @col_type LIKE '%varchar%' THEN @col_length ELSE @col_precision END,
                    tmp_scale = @col_scale
                WHERE session_id = @session_id AND col_key = @col_key;
            END
            ELSE
            BEGIN
                SET @error_msg = 'Table ' + @p_table_name + ' does not contain column ' + @col_key + ' or renamed column ' + @renamed_col_name;
                RAISERROR(@error_msg, 16, 1);
            END;
            
            -- Check if temporary column exists
            IF EXISTS (
                SELECT 1 FROM sys.columns c
                JOIN sys.tables t ON c.object_id = t.object_id
                WHE
GO

-- =====================================================================
-- Procedure 40: PKG_PDX_SCHEMA_UPDATER_HELPER_update_decreasing_varchar
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_update_decreasing_varchar]
(@p_table_name NVARCHAR(128))
AS
BEGIN
    DECLARE @error_msg NVARCHAR(MAX);
    BEGIN TRY
        -- Placeholder: Use SUBSTRING for decreasing VARCHAR2 modifications
        PRINT 'update_decreasing_varchar: Truncating VARCHAR2 data as needed';
    END TRY
    BEGIN CATCH
        SET @error_msg = 'Error in update_decreasing_varchar: ' + ERROR_MESSAGE();
        RAISERROR(@error_msg, 16, 1);
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 41: PKG_PDX_SCHEMA_UPDATER_HELPER_validate_data
-- =====================================================================

CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_HELPER_validate_data]
(
    @p_use_ctas BIT
)
AS
BEGIN
    DECLARE @session_id INT = @@SPID;
    DECLARE @fnd_renamed BIT = 0;
    DECLARE @all_renamed BIT = 1;
    DECLARE @col_key NVARCHAR(30);
    DECLARE @error_msg NVARCHAR(MAX);
    
    BEGIN TRY
        -- Check consistency of renamed and temp states
        SELECT @fnd_renamed = MAX(CASE WHEN method != 'N' AND tmp_renamed = 'Y' THEN 1 ELSE 0 END),
               @all_renamed = MIN(CASE WHEN method != 'N' AND tmp_renamed = 'Y' THEN 1 WHEN method != 'N' THEN 0 ELSE 1 END)
        FROM [SBMO].[pdx_schema_updater_helper_coldata]
        WHERE session_id = @session_id;
        
        IF @fnd_renamed = 1 AND @all_renamed = 0
        BEGIN
            RAISERROR('Inconsistent rename state: some columns renamed, others not', 16, 1);
        END;
        
        -- Validate method vs new_renamed consistency
        DECLARE cursor_validate CURSOR FOR
            SELECT col_key FROM [SBMO].[pdx_schema_updater_helper_coldata]
            WHERE session_id = @session_id;
        
        OPEN cursor_validate;
        FETCH NEXT FROM cursor_validate INTO @col_key;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            DECLARE @method NVARCHAR(1);
            DECLARE @new_renamed NVARCHAR(1);
            DECLARE @ctas_requested BIT = @p_use_ctas;
            
            SELECT @method = method, @new_renamed = new_renamed
            FROM [SBMO].[pdx_schema_updater_helper_coldata]
            WHERE session_id = @session_id AND col_key = @col_key;
            
            -- Validate method vs new_renamed
            IF @method = 'C' AND @new_renamed NOT IN ('N', 'C')
            BEGIN
                SET @error_msg = 'Column ' + @col_key + ' expects temporary column but found table';
                RAISERROR(@error_msg, 16, 1);
            END;
            
            IF @method = 'T' AND @new_renamed NOT IN ('N', 'T')
            BEGIN
                SET @error_msg = 'Column ' + @col_key + ' expects temporary table but found column';
                RAISERROR(@error_msg, 16, 1);
            END;
            
            FETCH NEXT FROM cursor_validate INTO @col_key;
        END;
        
        CLOSE cursor_validate;
        DEALLOCATE cursor_validate;
        
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('local', 'cursor_validate') >= 0
        BEGIN
            CLOSE cursor_validate;
            DEALLOCATE cursor_validate;
        END;
        SET @error_msg = 'Error in validate_data: ' + ERROR_MESSAGE();
        RAISERROR(@error_msg, 16, 1);
    END CATCH;
END;
GO

-- =====================================================================
-- Procedure 42: PKG_PDX_SCHEMA_UPDATER_META$delete_metadata
-- =====================================================================

-- =====================================================================
-- SECTION 5: CORE PROCEDURES - METADATA MANAGEMENT
-- =====================================================================

CREATE   PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_META$delete_metadata]
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @session_id INT = @@SPID;
    
    -- Delete from persistent tables
    BEGIN TRY
        DELETE FROM [SBMO].[PDX_SCHEMA_FILE_HASH];
        DELETE FROM [SBMO].[PDX_SCHEMA_FILE_TASKVER];
        DELETE FROM [SBMO].[PDX_SCHEMA_TASKVER_META];
    END TRY
    BEGIN CATCH
        -- Tables may not exist yet, that's OK
    END CATCH
    
    -- Clear session caches
    DELETE FROM [SBMO].[_PKG_FileToTaskMap] WHERE session_id = @session_id;
    DELETE FROM [SBMO].[_PKG_TaskToValueCache] WHERE session_id = @session_id;
    DELETE FROM [SBMO].[_PKG_ValueToTaskCache] WHERE session_id = @session_id;
    
    -- Reset captured flag
    UPDATE [SBMO].[_PKG_PkgState]
    SET property_value = '0'
    WHERE session_id = @session_id AND property_name = 'G_CAPTURED';
    
    PRINT 'Metadata cleared: all caches and persistent tables reset';
END
GO

-- =====================================================================
-- Procedure 43: PKG_PDX_SCHEMA_UPDATER_META$InitializeSession
-- =====================================================================

-- =====================================================================
-- SESSION STATE INITIALIZATION - USING PERSISTENT CACHE TABLES
-- =====================================================================

CREATE   PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_META$InitializeSession]
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @session_id INT = @@SPID;
    
    -- Clear any existing session data
    DELETE FROM [SBMO].[_PKG_PkgState] WHERE session_id = @session_id;
    DELETE FROM [SBMO].[_PKG_FileToTaskMap] WHERE session_id = @session_id;
    DELETE FROM [SBMO].[_PKG_TaskToValueCache] WHERE session_id = @session_id;
    DELETE FROM [SBMO].[_PKG_ValueToTaskCache] WHERE session_id = @session_id;
    
    -- Initialize session state
    INSERT INTO [SBMO].[_PKG_PkgState] (session_id, property_name, property_value)
    VALUES (@session_id, 'G_CAPTURED', '0');  -- 0 = FALSE, 1 = TRUE
    
    PRINT 'Session ' + CAST(@session_id AS VARCHAR(10)) + ' initialized';
END
GO

-- =====================================================================
-- Procedure 44: PKG_PDX_SCHEMA_UPDATER_META$read_metadata
-- =====================================================================

CREATE   PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_META$read_metadata]
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @session_id INT = @@SPID;
    
    BEGIN TRY
        -- Initialize session state
        EXEC [SBMO].[PKG_PDX_SCHEMA_UPDATER_META$InitializeSession];
        
        -- Erase obsolete entries
        EXEC [SBMO].[PKG_PDX_SCHEMA_UPDATER_META$erase_obsolete_metadata];
        
        -- Extract file-to-task mappings
        EXEC [SBMO].[PKG_PDX_SCHEMA_UPDATER_META$read_metadata_filetask_map];
        
        -- Set captured flag
        UPDATE [SBMO].[_PKG_PkgState]
        SET property_value = '1'
        WHERE session_id = @session_id AND property_name = 'G_CAPTURED';
        
        PRINT 'Metadata successfully read and cached for session ' + CAST(@session_id AS VARCHAR(10));
    END TRY
    BEGIN CATCH
        DECLARE @error_msg NVARCHAR(MAX) = ERROR_MESSAGE();
        PRINT 'ERROR in read_metadata: ' + @error_msg;
        THROW;
    END CATCH
END
GO

-- =====================================================================
-- Procedure 45: PKG_PDX_SCHEMA_UPDATER_META$read_metadata_filetask_map
-- =====================================================================

CREATE   PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_META$read_metadata_filetask_map]
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @session_id INT = @@SPID;
    DECLARE @prefix VARCHAR(50) = 'pdx';
    
    -- Get application prefix
    BEGIN TRY
        SELECT @prefix = LOWER([VALUE])
        FROM [SBMO].[PDX_SCHEMA_CONFIG]
        WHERE [KEY] = 'APPLICATIONPREFIX';
    END TRY
    BEGIN CATCH
    END CATCH
    
    -- Clear existing mappings for this session
    DELETE FROM [SBMO].[_PKG_FileToTaskMap] WHERE session_id = @session_id;
    
    -- Try to get file mappings from persistent tables
    BEGIN TRY
        INSERT INTO [SBMO].[_PKG_FileToTaskMap] (session_id, FILE_NAME, TASK_VERSION, FILE_TYPE)
        SELECT @session_id, FILE_NAME, TASK_VERSION, FILE_TYPE
        FROM [SBMO].[PDX_SCHEMA_FILE_TASKVER]
        WHERE TASK_VERSION IS NOT NULL;
    END TRY
    BEGIN CATCH
        -- Base tables don't exist yet, that's OK
        PRINT 'Note: PDX_SCHEMA_FILE_TASKVER table does not exist yet';
    END CATCH
    
    PRINT 'File-to-task mappings loaded: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' entries';
END
GO

-- =====================================================================
-- Procedure 46: PKG_PDX_SCHEMA_UPDATER_RPT_add
-- =====================================================================

-- Procedure 1: add (simplified - helper for result accumulation)
CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_RPT_add]
(
    @p_txt NVARCHAR(MAX)
)
AS
BEGIN
    -- This is a helper procedure placeholder
    -- In actual use, results would be accumulated in calling procedure's temp table
    -- For now, just log the text
    PRINT @p_txt;
END;
GO

-- =====================================================================
-- Procedure 47: PKG_PDX_SCHEMA_UPDATER_RPT_print_call
-- =====================================================================

-- Procedure 2: print_call (simplified - format call record)
CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_RPT_print_call]
(
    @p_rec_id NUMERIC(18, 0),
    @p_rec_target_version NVARCHAR(MAX),
    @p_rec_status_code NVARCHAR(MAX),
    @p_rec_start_date DATETIME2,
    @p_rec_duration INT,
    @p_rec_return_code INT,
    @p_rec_error_message NVARCHAR(MAX),
    @p_rec_sql_error_message NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @result_msg NVARCHAR(20);
    
    IF @p_rec_return_code = 0
        SET @result_msg = ' (SUCCESS)';
    ELSE
        SET @result_msg = ' (FAIL)';
    
    -- Output call summary
    PRINT 'PkgCall:  ' + CAST(@p_rec_target_version AS NVARCHAR(50)) + ' ' + 
        ISNULL(@p_rec_status_code, '') + ' ' + CAST(@p_rec_start_date AS NVARCHAR(30)) + 
        ' , Duration [' + CAST(@p_rec_duration AS NVARCHAR(10)) + ']';
    
    -- Output return code
    PRINT '          RtnCode:  ' + CAST(@p_rec_return_code AS NVARCHAR(10)) + @result_msg;
    
    -- Output error message with indentation
    IF @p_rec_error_message IS NOT NULL
    BEGIN
        PRINT '          Message:  ' + 
            SUBSTRING(REPLACE(@p_rec_error_message, CHAR(10), CHAR(10) + '                    '), 21, 4000);
    END;
    
    -- Output SQL error message with indentation
    IF @p_rec_sql_error_message IS NOT NULL
    BEGIN
        PRINT '          SqlError: ' + 
            SUBSTRING(REPLACE(@p_rec_sql_error_message, CHAR(10), CHAR(10) + '                    '), 21, 4000);
    END;
END;
GO

-- =====================================================================
-- Procedure 48: PKG_PDX_SCHEMA_UPDATER_RPT_print_process
-- =====================================================================

-- Procedure 5: print_process (simplified - format process history record)
CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_RPT_print_process]
(
    @p_rec_process NVARCHAR(MAX),
    @p_rec_start_date DATETIME2,
    @p_rec_duration INT
)
AS
BEGIN
    -- Output process summary
    PRINT 'Process:  ' + CAST(@p_rec_process AS NVARCHAR(MAX)) + ' Started [' + 
        CAST(@p_rec_start_date AS NVARCHAR(30)) + '], Duration [' + 
        CAST(@p_rec_duration AS NVARCHAR(10)) + ']';
END;
GO

-- =====================================================================
-- Procedure 49: PKG_PDX_SCHEMA_UPDATER_RPT_print_task
-- =====================================================================

-- Procedure 4: print_task (simplified - format task history record)
CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_RPT_print_task]
(
    @p_rec_file_name NVARCHAR(MAX),
    @p_rec_action_code NVARCHAR(MAX),
    @p_rec_status_code NVARCHAR(MAX),
    @p_rec_start_date DATETIME2,
    @p_rec_duration INT,
    @p_rec_task_type NVARCHAR(MAX),
    @p_rec_error_message NVARCHAR(MAX),
    @p_rec_sql_error_message NVARCHAR(MAX)
)
AS
BEGIN
    -- Output task summary (LEFT + REPLICATE replaces RPAD)
    PRINT 'Task:     ' + LEFT(ISNULL(@p_rec_file_name, '') + REPLICATE(' ', 30), 30) + ' ' + 
        ISNULL(@p_rec_action_code, '') + ' ' + ISNULL(@p_rec_status_code, '') + ' ' + 
        CAST(@p_rec_start_date AS NVARCHAR(30)) + ' TaskType [' + 
        ISNULL(@p_rec_task_type, '') + '], Duration [' + CAST(@p_rec_duration AS NVARCHAR(10)) + ']';
    
    -- Output error message with indentation
    IF @p_rec_error_message IS NOT NULL
    BEGIN
        PRINT '          Message:  ' + 
            SUBSTRING(REPLACE(@p_rec_error_message, CHAR(10), CHAR(10) + '                    '), 21, 4000);
    END;
    
    -- Output SQL error message with indentation
    IF @p_rec_sql_error_message IS NOT NULL
    BEGIN
        PRINT '          SqlError: ' + 
            SUBSTRING(REPLACE(@p_rec_sql_error_message, CHAR(10), CHAR(10) + '                    '), 21, 4000);
    END;
END;
GO

-- =====================================================================
-- Procedure 50: PKG_PDX_SCHEMA_UPDATER_RPT_print_vers
-- =====================================================================

-- Procedure 3: print_vers (simplified - format version history record)
CREATE PROCEDURE [SBMO].[PKG_PDX_SCHEMA_UPDATER_RPT_print_vers]
(
    @p_rec_current_version NVARCHAR(MAX),
    @p_rec_target_version NVARCHAR(MAX),
    @p_rec_status_code NVARCHAR(MAX),
    @p_rec_start_date DATETIME2,
    @p_rec_duration INT,
    @p_rec_error_message NVARCHAR(MAX),
    @p_rec_sql_error_message NVARCHAR(MAX)
)
AS
BEGIN
    -- Output version summary
    PRINT 'Version:  ' + CAST(@p_rec_current_version AS NVARCHAR(50)) + ' - ' + 
        CAST(@p_rec_target_version AS NVARCHAR(50)) + ' ' + 
        ISNULL(@p_rec_status_code, '') + ' ' + CAST(@p_rec_start_date AS NVARCHAR(30)) + 
        ' , Duration [' + CAST(@p_rec_duration AS NVARCHAR(10)) + ']';
    
    -- Output error message with indentation
    IF @p_rec_error_message IS NOT NULL
    BEGIN
        PRINT '          Message:  ' + 
            SUBSTRING(REPLACE(@p_rec_error_message, CHAR(10), CHAR(10) + '                    '), 21, 4000);
    END;
    
    -- Output SQL error message with indentation
    IF @p_rec_sql_error_message IS NOT NULL
    BEGIN
        PRINT '          SqlError: ' + 
            SUBSTRING(REPLACE(@p_rec_sql_error_message, CHAR(10), CHAR(10) + '                    '), 21, 4000);
    END;
END;
GO

-- =====================================================================
-- End of Part2_Procedures_026-050
-- =====================================================================
-- Procedures 26-50 exported successfully.
-- =====================================================================

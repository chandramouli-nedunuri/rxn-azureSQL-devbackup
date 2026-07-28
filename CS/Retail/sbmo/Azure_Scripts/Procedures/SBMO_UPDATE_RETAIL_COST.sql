-- =====================================================
-- PROCEDURE: UPDATE_RETAIL_COST
-- CONVERTED FROM: Oracle PL/SQL to Azure SQL T-SQL
-- PURPOSE: Update retail cost data from source vendor to target vendor
-- =====================================================

CREATE OR ALTER PROCEDURE [SBMO].[UPDATE_RETAIL_COST]
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @v_counter INT = 0;
    DECLARE @v_drug_id BIGINT;
    DECLARE @v_mail_acq_last_updated DATETIME2;
    DECLARE @v_mail_acq DECIMAL(18, 2);
    DECLARE @v_store_acq_last_updated DATETIME2;
    DECLARE @v_store_acq DECIMAL(18, 2);
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- ============================================================
        -- Process retail cost records from source vendor (1247507)
        -- and update target vendor (43038305)
        -- ============================================================
        
        DECLARE retail_cost_cursor CURSOR FOR
            SELECT drug_id, mail_acq_last_updated, mail_acq, 
                   store_acq_last_updated, store_acq
            FROM [SBMO].[retail_cost]
            WHERE chain_id = 3105660
                AND vendor_id = 1247507
                AND drug_id IN (
                    SELECT drug_id
                    FROM [SBMO].[retail_cost]
                    WHERE chain_id = 3105660
                        AND vendor_id = 43038305
                );
        
        OPEN retail_cost_cursor;
        FETCH NEXT FROM retail_cost_cursor 
            INTO @v_drug_id, @v_mail_acq_last_updated, @v_mail_acq, 
                 @v_store_acq_last_updated, @v_store_acq;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE [SBMO].[retail_cost]
            SET mail_acq_last_updated = @v_mail_acq_last_updated,
                mail_acq = @v_mail_acq,
                store_acq_last_updated = @v_store_acq_last_updated,
                store_acq = @v_store_acq
            WHERE chain_id = 3105660
                AND vendor_id = 43038305
                AND drug_id = @v_drug_id;
            
            SET @v_counter = @v_counter + 1;
            
            FETCH NEXT FROM retail_cost_cursor 
                INTO @v_drug_id, @v_mail_acq_last_updated, @v_mail_acq, 
                     @v_store_acq_last_updated, @v_store_acq;
        END;
        
        CLOSE retail_cost_cursor;
        DEALLOCATE retail_cost_cursor;
        
        -- Log update count
        PRINT 'Updated ' + CAST(@v_counter AS NVARCHAR) + ' rows in the RETAIL_COST table';
        
        -- ============================================================
        -- Update SYSTEM_MESSAGES table to prevent dashboard flooding
        -- Acknowledge Store and Mail acquisition messages
        -- ============================================================
        
        UPDATE [SBMO].[SYSTEM_MESSAGES]
        SET ACKNOWLEDGED_BY = 'DWJ',
            ACKNOWLEDGED = SYSDATETIME()
        WHERE MESSAGE LIKE 'Store%'
            AND ACKNOWLEDGED_BY IS NULL;
        
        UPDATE [SBMO].[SYSTEM_MESSAGES]
        SET ACKNOWLEDGED_BY = 'DWJ',
            ACKNOWLEDGED = SYSDATETIME()
        WHERE MESSAGE LIKE 'Mail%'
            AND ACKNOWLEDGED_BY IS NULL;
        
        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH;
END;
GO

-- =====================================================
-- CONVERSION NOTES
-- =====================================================
-- NOTE: This conversion transforms the Oracle PL/SQL procedure to Azure SQL T-SQL.
--
-- KEY CHANGES:
-- 1. Converted FOR LOOP with cursor to T-SQL CURSOR syntax
-- 2. Replaced DBMS_OUTPUT.PUT_LINE with PRINT statement
-- 3. Converted SYSDATE to SYSDATETIME()
-- 4. Added transaction control (BEGIN TRANSACTION, COMMIT, ROLLBACK)
-- 5. Schema-qualified naming: [SBMO].[ProcedureName] format
-- 6. Variable prefix: @variable instead of v_variable
-- 7. Added explicit cursor OPEN, FETCH, CLOSE, DEALLOCATE
-- 8. Added TRY...CATCH error handling
-- 9. Converted NUMBER to appropriate SQL Server types (BIGINT, DECIMAL)
--
-- LOGIC:
-- 1. Retrieve all drug_ids from source vendor (1247507) that exist in target (43038305)
-- 2. For each drug_id, update the target vendor's retail_cost record
-- 3. Count updates and log result
-- 4. Acknowledge pending Store/Mail acquisition system messages
--
-- EXECUTION:
-- EXEC [SBMO].[UPDATE_RETAIL_COST];
--
-- PERFORMANCE NOTES:
-- For large datasets, consider replacing cursor with set-based UPDATE:
-- UPDATE t1 SET mail_acq_last_updated = t2.mail_acq_last_updated, ...
-- FROM [SBMO].[retail_cost] t1
-- INNER JOIN [SBMO].[retail_cost] t2 ON t1.drug_id = t2.drug_id
-- WHERE t1.chain_id = 3105660 AND t1.vendor_id = 43038305
--   AND t2.chain_id = 3105660 AND t2.vendor_id = 1247507;
-- =====================================================

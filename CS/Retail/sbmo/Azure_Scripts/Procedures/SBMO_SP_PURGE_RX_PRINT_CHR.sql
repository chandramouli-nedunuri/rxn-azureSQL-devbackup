-- =====================================================
-- PROCEDURE: SP_PURGE_RX_PRINT_CHR
-- CONVERTED FROM: Oracle PL/SQL to Azure SQL T-SQL
-- PURPOSE: Delete print character records for completed/cancelled RX
-- =====================================================

CREATE OR ALTER PROCEDURE [SBMO].[SP_PURGE_RX_PRINT_CHR]
    @p_delete_date DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF @p_delete_date IS NULL
        BEGIN
            -- Delete all print characters for completed/cancelled RX (status: 3, 4, 5)
            DELETE FROM [SBMO].[rx_print_chr]
            WHERE (tenant_id, rx_id) IN 
                (SELECT tenant_id, id 
                 FROM [SBMO].[rx_cores] 
                 WHERE status IN (3, 4, 5));
        END
        ELSE
        BEGIN
            -- Delete print characters for completed/cancelled RX on or before specified date
            DELETE FROM [SBMO].[rx_print_chr]
            WHERE (tenant_id, rx_id) IN 
                (SELECT tenant_id, id 
                 FROM [SBMO].[rx_cores] 
                 WHERE status IN (3, 4, 5))
                AND created_date <= @p_delete_date;
        END;
        
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
-- 1. Converted IF...THEN...ELSE to T-SQL IF...ELSE syntax
-- 2. Added transaction control (BEGIN TRANSACTION, COMMIT, ROLLBACK)
-- 3. Schema-qualified naming: [SBMO].[ProcedureName] format
-- 4. Removed COMMIT from procedure (handled in transaction)
-- 5. Added TRY...CATCH error handling
-- 6. Parameter syntax: @variable instead of p_variable
-- 7. NULL comparison: IS NULL instead of "is null"
--
-- EXECUTION:
-- EXEC [SBMO].[SP_PURGE_RX_PRINT_CHR];  -- Delete all (today)
-- EXEC [SBMO].[SP_PURGE_RX_PRINT_CHR] @p_delete_date = '2024-12-31';  -- Delete up to date
-- =====================================================

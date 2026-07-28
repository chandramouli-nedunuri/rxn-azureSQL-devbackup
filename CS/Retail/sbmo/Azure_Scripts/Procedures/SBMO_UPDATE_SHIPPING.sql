-- =====================================================
-- PROCEDURE: UPDATE_SHIPPING
-- CONVERTED FROM: Oracle PL/SQL to Azure SQL T-SQL
-- PURPOSE: Update shipping package details for an order
-- =====================================================

CREATE OR ALTER PROCEDURE [SBMO].[UPDATE_SHIPPING]
    @p_order_number NUMERIC(18, 0),
    @p_ounces FLOAT,
    @p_tracking_number NVARCHAR(MAX),
    @p_true_ship_amt DECIMAL(18, 2),
    @p_ship_name NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @v_shipping_package_id BIGINT;
    DECLARE @v_order_id BIGINT;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Get order ID from order number
        SELECT @v_order_id = id
        FROM [SBMO].[orders]
        WHERE order_number = @p_order_number;
        
        IF @v_order_id IS NULL
        BEGIN
            THROW 50001, 'Order number ' + CAST(@p_order_number AS NVARCHAR) + ' not found', 1;
        END;
        
        -- ============================================================
        -- Process all shipping packages for the specified order
        -- Update ounces, tracking number, true ship amount, and carrier
        -- ============================================================
        
        DECLARE shipping_package_cursor CURSOR FOR
            SELECT shipping_package_id
            FROM [SBMO].[rx_cores]
            WHERE order_id = @v_order_id;
        
        OPEN shipping_package_cursor;
        FETCH NEXT FROM shipping_package_cursor INTO @v_shipping_package_id;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE [SBMO].[rx_shipping_packages]
            SET ounces = @p_ounces,
                tracking_number = @p_tracking_number,
                true_ship_amt = @p_true_ship_amt,
                carrier = @p_ship_name
            WHERE id = @v_shipping_package_id;
            
            FETCH NEXT FROM shipping_package_cursor INTO @v_shipping_package_id;
        END;
        
        CLOSE shipping_package_cursor;
        DEALLOCATE shipping_package_cursor;
        
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
-- 1. Converted procedure parameters from Oracle (p_parameter) to T-SQL (@p_parameter)
-- 2. Converted "is" to "AS" (Oracle syntax to T-SQL)
-- 3. Converted FOR LOOP with cursor to T-SQL CURSOR syntax
-- 4. Converted NUMBER to NUMERIC(18, 0)
-- 5. Converted FLOAT to FLOAT (same in T-SQL)
-- 6. Converted VARCHAR2 to NVARCHAR(MAX)
-- 7. Converted DECIMAL for monetary amounts
-- 8. Added transaction control (BEGIN TRANSACTION, COMMIT, ROLLBACK)
-- 9. Schema-qualified naming: [SBMO].[ProcedureName] format
-- 10. Added TRY...CATCH error handling
-- 11. Added explicit cursor OPEN, FETCH, CLOSE, DEALLOCATE
-- 12. Added order ID validation
--
-- LOGIC:
-- 1. Lookup order ID from order number
-- 2. Retrieve all shipping packages for that order's RX cores
-- 3. For each shipping package, update:
--    - ounces (weight)
--    - tracking_number
--    - true_ship_amt (actual shipping amount)
--    - carrier (carrier name from p_ship_name)
--
-- EXECUTION:
-- EXEC [SBMO].[UPDATE_SHIPPING]
--      @p_order_number = 12345,
--      @p_ounces = 5.5,
--      @p_tracking_number = 'TRK123456789',
--      @p_true_ship_amt = 12.99,
--      @p_ship_name = 'UPS';
--
-- PERFORMANCE NOTES:
-- For large orders with many shipping packages, consider set-based update:
-- UPDATE [SBMO].[rx_shipping_packages]
-- SET ounces = @p_ounces,
--     tracking_number = @p_tracking_number,
--     true_ship_amt = @p_true_ship_amt,
--     carrier = @p_ship_name
-- FROM [SBMO].[rx_shipping_packages] sp
-- INNER JOIN [SBMO].[rx_cores] rc ON sp.id = rc.shipping_package_id
-- INNER JOIN [SBMO].[orders] o ON rc.order_id = o.id
-- WHERE o.order_number = @p_order_number;
-- =====================================================

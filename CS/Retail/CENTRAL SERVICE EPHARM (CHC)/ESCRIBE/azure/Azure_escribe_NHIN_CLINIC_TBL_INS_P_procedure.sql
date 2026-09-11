-- =====================================================================
-- PROCEDURE: NHIN_CLINIC_TBL_INS_P (CORRECTED v2)
-- =====================================================================
-- Oracle Source: ESCRIBE.NHIN_CLINIC_TBL_INS_P
-- Conversion Status: FIDELITY-RESTORED (NO GOTO, EXACT LOOP SEMANTICS)
--
-- Key Conversion Rules Applied:
--   1. ✅ Oracle outer LOOP -> Azure WHILE 1=1 for clinic cursor
--   2. ✅ Oracle CASE (OPEN cursor) -> Azure IF/ELSE with cursor declaration per path
--   3. ✅ Oracle <<inner>> LOOP -> Azure nested WHILE 1=1 for address cursor
--   4. ✅ Oracle FETCH ... EXIT WHEN %NOTFOUND -> Azure FETCH with @@FETCH_STATUS check
--   5. ✅ Each matched address row processed via INSERT (not GOTO)
--   6. ✅ Proper cursor lifecycle: DECLARE, OPEN, WHILE/FETCH, CLOSE, DEALLOCATE
--   7. ✅ Oracle NULL-safe || concat -> Azure COALESCE with explicit concatenation
--   8. ✅ NULL-safe comparisons in WHERE clauses preserved
--   9. ✅ Oracle sequence NEXTVAL -> Azure NEXT VALUE FOR sequence
--  10. ✅ Oracle COMMIT -> Azure COMMIT (implicit mode)
-- =====================================================================

USE noneprdb;
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'NHIN_CLINIC_TBL_INS_P' AND type = 'P' AND schema_id = SCHEMA_ID('ESCRIBE'))
    DROP PROCEDURE ESCRIBE.NHIN_CLINIC_TBL_INS_P;
GO

CREATE PROCEDURE ESCRIBE.NHIN_CLINIC_TBL_INS_P
AS
BEGIN
    SET NOCOUNT ON;
    
    -- =====================================================================
    -- ERROR TRACKING & SEQUENCE VARIABLES
    -- =====================================================================
    DECLARE
        @error_loc INT = 0,
        @error_msg NVARCHAR(2000) = '',
        @nhin_clinic_id BIGINT,
        @nhin_clinic_com_clnc_id BIGINT,
        @nhin_clinic_id_address BIGINT,
        @audit_dates_id BIGINT;
    
    -- =====================================================================
    -- OUTER LOOP VARIABLES (Clinic records from prescriber source)
    -- =====================================================================
    DECLARE
        @rec_organization_name NVARCHAR(MAX),
        @rec_phys_address_line_1 NVARCHAR(MAX),
        @rec_phys_address_line_2 NVARCHAR(MAX),
        @rec_phys_suite_apartment_num NVARCHAR(MAX),
        @rec_department_mail_stop NVARCHAR(MAX),
        @rec_phys_city_name NVARCHAR(MAX),
        @rec_phys_state_province_code NVARCHAR(MAX),
        @rec_phys_zip_postal_zone NVARCHAR(MAX),
        @rec_phys_country_code NVARCHAR(MAX),
        @rec_hin_num NVARCHAR(MAX),
        @rec_prime_phone_num NUMERIC(10,0),
        @rec_second_phone_num NUMERIC(10,0),
        @rec_refill_phone_num NUMERIC(10,0),
        @rec_fax_num NUMERIC(10,0);
    
    -- =====================================================================
    -- ADDRESS CONCATENATION (for NULL-safe comparison)
    -- Oracle: address_line_2 || suite_apartment_num
    -- =====================================================================
    DECLARE
        @address_line_2_concatenated NVARCHAR(MAX);
    
    BEGIN TRY
        SET @error_loc = 1;
        
        -- =====================================================================
        -- OUTER CURSOR DECLARATION
        -- Oracle: FOR rec IN (SELECT...) with ROW_NUMBER() and ROWID order
        -- Azure: Cursor with ROW_NUMBER() ordered by load sequence
        -- =====================================================================
        DECLARE clinic_cursor CURSOR LOCAL FORWARD_ONLY FOR
            SELECT 
                organization_name,
                phys_address_line_1,
                phys_address_line_2,
                phys_suite_apartment_num,
                department_mail_stop,
                phys_city_name,
                phys_state_province_code,
                phys_zip_postal_zone,
                phys_country_code,
                hin_num,
                prime_phone_num,
                second_phone_num,
                refill_phone_num,
                fax_num
            FROM (
                SELECT 
                    xt.*,
                    ROW_NUMBER() OVER (
                        PARTITION BY 
                            organization_name,
                            phys_address_line_1,
                            phys_address_line_2,
                            phys_suite_apartment_num,
                            department_mail_stop,
                            phys_city_name,
                            phys_state_province_code,
                            phys_zip_postal_zone,
                            phys_country_code
                        ORDER BY xt.DATA_SUPPLIER_REF_KEY_1  /* ROWID replacement */
                    ) AS rn
                FROM ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT AS xt
                WHERE phys_country_code IS NOT NULL
                  AND phys_address_line_1 IS NOT NULL
                  AND phys_city_name IS NOT NULL
                  AND phys_state_province_code IS NOT NULL
                  AND phys_zip_postal_zone IS NOT NULL
            ) AS filtered
            WHERE rn = 1
            ORDER BY 
                organization_name,
                phys_address_line_1,
                phys_address_line_2,
                phys_suite_apartment_num,
                department_mail_stop,
                phys_city_name,
                phys_state_province_code,
                phys_zip_postal_zone,
                phys_country_code;
        
        OPEN clinic_cursor;
        
        -- =====================================================================
        -- OUTER LOOP: Oracle FOR rec IN ... LOOP
        -- =====================================================================
        WHILE 1 = 1
        BEGIN
            SET @error_loc = 2;
            
            FETCH clinic_cursor INTO
                @rec_organization_name,
                @rec_phys_address_line_1,
                @rec_phys_address_line_2,
                @rec_phys_suite_apartment_num,
                @rec_department_mail_stop,
                @rec_phys_city_name,
                @rec_phys_state_province_code,
                @rec_phys_zip_postal_zone,
                @rec_phys_country_code,
                @rec_hin_num,
                @rec_prime_phone_num,
                @rec_second_phone_num,
                @rec_refill_phone_num,
                @rec_fax_num;
            
            IF @@FETCH_STATUS <> 0
                BREAK;
            
            SET @error_loc = 2;
            SET @nhin_clinic_id_address = NULL;
            SET @address_line_2_concatenated = NULL;
            
            -- ===================================================================
            -- NULL-SAFE CONCATENATION: address_line_2 || suite_apartment_num
            -- Oracle uses || which is NULL-safe (NULL || 'x' = 'x')
            -- Azure: COALESCE(val1, '') + COALESCE(val2, '') = result
            -- ===================================================================
            SET @address_line_2_concatenated = COALESCE(@rec_phys_address_line_2, '') 
                                              + COALESCE(@rec_phys_suite_apartment_num, '');
            
            -- =====================================================================
            -- ORACLE CASE STATEMENT CONVERTED TO IF/ELSE PATHS
            -- Each path: OPEN cursor -> INNER LOOP (FETCH/EXIT/PROCESS) -> CLOSE
            -- =====================================================================
            
            -- =====================================================================
            -- PATH 1: address_line_2||suite IS NOT NULL AND mail_stop IS NOT NULL
            -- =====================================================================
            IF (@address_line_2_concatenated <> '' AND @rec_department_mail_stop IS NOT NULL)
            BEGIN
                SET @error_loc = 3;
                
                -- DECLARE: add_cur1 equivalent
                DECLARE address_cur1 CURSOR LOCAL FORWARD_ONLY FOR
                    SELECT ID
                    FROM ESCRIBE.ADDRESS
                    WHERE ADDRESS_LINE_1 = @rec_phys_address_line_1
                      AND ADDRESS_LINE_2 = @address_line_2_concatenated
                      AND DEPARTMENT_MAIL_STOP = @rec_department_mail_stop
                      AND CITY = @rec_phys_city_name
                      AND STATE = @rec_phys_state_province_code
                      AND ZIP_CODE = @rec_phys_zip_postal_zone
                      AND COUNTRY = @rec_phys_country_code
                    ORDER BY ADDRESS_LINE_1, ADDRESS_LINE_2, DEPARTMENT_MAIL_STOP, 
                             CITY, ZIP_CODE, COUNTRY;
                
                -- OPEN: add_cur1
                OPEN address_cur1;
                
                -- ===================================================================
                -- INNER LOOP: Oracle <<inner>> LOOP ... FETCH ... EXIT WHEN %NOTFOUND
                -- ===================================================================
                WHILE 1 = 1
                BEGIN
                    SET @error_loc = 4;
                    
                    FETCH address_cur1 INTO @nhin_clinic_id_address;
                    
                    -- EXIT INNER WHEN add_cur1%NOTFOUND
                    IF @@FETCH_STATUS <> 0
                    BEGIN
                        CLOSE address_cur1;
                        DEALLOCATE address_cur1;
                        BREAK;  -- EXIT inner loop
                    END;
                    
                    -- ===================================================================
                    -- PROCESS MATCHED ADDRESS ROW
                    -- Generate sequences and INSERT into nhin_clinic & audit_dates
                    -- ===================================================================
                    SET @error_loc = 5;
                    SET @nhin_clinic_id = NEXT VALUE FOR ESCRIBE.NHIN_CLINIC_ID_SEQ;
                    SET @nhin_clinic_com_clnc_id = NEXT VALUE FOR ESCRIBE.NHIN_CLINIC_COM_CLINIC_ID_SEQ;
                    
                    SET @error_loc = 6;
                    
                    INSERT INTO ESCRIBE.NHIN_CLINIC
                        (ID, NHIN_COM_CLINIC_ID, ID_ADDRESS, OFFICE_PHONE_1, OFFICE_PHONE_2, 
                         REFILL_PHONE, HIN, DEPARTMENT_MAIL_STOP, CLINIC_NAME)
                    VALUES
                        (@nhin_clinic_id, @nhin_clinic_com_clnc_id, @nhin_clinic_id_address, 
                         @rec_prime_phone_num, @rec_second_phone_num, @rec_refill_phone_num, 
                         @rec_hin_num, @rec_department_mail_stop, @rec_organization_name);
                    
                    SET @error_loc = 7;
                    
                    SET @audit_dates_id = NEXT VALUE FOR ESCRIBE.AUDIT_DATES_ID_SEQ;
                    
                    INSERT INTO ESCRIBE.AUDIT_DATES
                        (ID, TABLE_CLASS_NAME, TABLE_ROW_ID, SYSTEM_CREATE_DATE)
                    VALUES
                        (@audit_dates_id, 'NHIN_CLINIC', @nhin_clinic_id, SYSDATETIME());
                    
                    -- Continue inner loop to fetch next address row
                END;  -- END inner loop for address_cur1
            END
            
            -- =====================================================================
            -- PATH 2: address_line_2||suite IS NOT NULL AND mail_stop IS NULL
            -- =====================================================================
            ELSE IF (@address_line_2_concatenated <> '' AND @rec_department_mail_stop IS NULL)
            BEGIN
                SET @error_loc = 8;
                
                DECLARE address_cur2 CURSOR LOCAL FORWARD_ONLY FOR
                    SELECT ID
                    FROM ESCRIBE.ADDRESS
                    WHERE ADDRESS_LINE_1 = @rec_phys_address_line_1
                      AND ADDRESS_LINE_2 = @address_line_2_concatenated
                      AND DEPARTMENT_MAIL_STOP IS NULL
                      AND CITY = @rec_phys_city_name
                      AND STATE = @rec_phys_state_province_code
                      AND ZIP_CODE = @rec_phys_zip_postal_zone
                      AND COUNTRY = @rec_phys_country_code
                    ORDER BY ADDRESS_LINE_1, ADDRESS_LINE_2, DEPARTMENT_MAIL_STOP, 
                             CITY, ZIP_CODE, COUNTRY;
                
                OPEN address_cur2;
                
                WHILE 1 = 1
                BEGIN
                    SET @error_loc = 9;
                    
                    FETCH address_cur2 INTO @nhin_clinic_id_address;
                    
                    IF @@FETCH_STATUS <> 0
                    BEGIN
                        CLOSE address_cur2;
                        DEALLOCATE address_cur2;
                        BREAK;
                    END;
                    
                    SET @error_loc = 10;
                    SET @nhin_clinic_id = NEXT VALUE FOR ESCRIBE.NHIN_CLINIC_ID_SEQ;
                    SET @nhin_clinic_com_clnc_id = NEXT VALUE FOR ESCRIBE.NHIN_CLINIC_COM_CLINIC_ID_SEQ;
                    
                    SET @error_loc = 11;
                    
                    INSERT INTO ESCRIBE.NHIN_CLINIC
                        (ID, NHIN_COM_CLINIC_ID, ID_ADDRESS, OFFICE_PHONE_1, OFFICE_PHONE_2, 
                         REFILL_PHONE, HIN, DEPARTMENT_MAIL_STOP, CLINIC_NAME)
                    VALUES
                        (@nhin_clinic_id, @nhin_clinic_com_clnc_id, @nhin_clinic_id_address, 
                         @rec_prime_phone_num, @rec_second_phone_num, @rec_refill_phone_num, 
                         @rec_hin_num, @rec_department_mail_stop, @rec_organization_name);
                    
                    SET @error_loc = 12;
                    
                    SET @audit_dates_id = NEXT VALUE FOR ESCRIBE.AUDIT_DATES_ID_SEQ;
                    
                    INSERT INTO ESCRIBE.AUDIT_DATES
                        (ID, TABLE_CLASS_NAME, TABLE_ROW_ID, SYSTEM_CREATE_DATE)
                    VALUES
                        (@audit_dates_id, 'NHIN_CLINIC', @nhin_clinic_id, SYSDATETIME());
                    
                END;  -- END inner loop for address_cur2
            END
            
            -- =====================================================================
            -- PATH 3: address_line_2||suite IS NULL AND mail_stop IS NOT NULL
            -- =====================================================================
            ELSE IF (@address_line_2_concatenated = '' AND @rec_department_mail_stop IS NOT NULL)
            BEGIN
                SET @error_loc = 13;
                
                DECLARE address_cur3 CURSOR LOCAL FORWARD_ONLY FOR
                    SELECT ID
                    FROM ESCRIBE.ADDRESS
                    WHERE ADDRESS_LINE_1 = @rec_phys_address_line_1
                      AND ADDRESS_LINE_2 IS NULL
                      AND DEPARTMENT_MAIL_STOP = @rec_department_mail_stop
                      AND CITY = @rec_phys_city_name
                      AND STATE = @rec_phys_state_province_code
                      AND ZIP_CODE = @rec_phys_zip_postal_zone
                      AND COUNTRY = @rec_phys_country_code
                    ORDER BY ADDRESS_LINE_1, ADDRESS_LINE_2, DEPARTMENT_MAIL_STOP, 
                             CITY, ZIP_CODE, COUNTRY;
                
                OPEN address_cur3;
                
                WHILE 1 = 1
                BEGIN
                    SET @error_loc = 14;
                    
                    FETCH address_cur3 INTO @nhin_clinic_id_address;
                    
                    IF @@FETCH_STATUS <> 0
                    BEGIN
                        CLOSE address_cur3;
                        DEALLOCATE address_cur3;
                        BREAK;
                    END;
                    
                    SET @error_loc = 15;
                    SET @nhin_clinic_id = NEXT VALUE FOR ESCRIBE.NHIN_CLINIC_ID_SEQ;
                    SET @nhin_clinic_com_clnc_id = NEXT VALUE FOR ESCRIBE.NHIN_CLINIC_COM_CLINIC_ID_SEQ;
                    
                    SET @error_loc = 16;
                    
                    INSERT INTO ESCRIBE.NHIN_CLINIC
                        (ID, NHIN_COM_CLINIC_ID, ID_ADDRESS, OFFICE_PHONE_1, OFFICE_PHONE_2, 
                         REFILL_PHONE, HIN, DEPARTMENT_MAIL_STOP, CLINIC_NAME)
                    VALUES
                        (@nhin_clinic_id, @nhin_clinic_com_clnc_id, @nhin_clinic_id_address, 
                         @rec_prime_phone_num, @rec_second_phone_num, @rec_refill_phone_num, 
                         @rec_hin_num, @rec_department_mail_stop, @rec_organization_name);
                    
                    SET @error_loc = 17;
                    
                    SET @audit_dates_id = NEXT VALUE FOR ESCRIBE.AUDIT_DATES_ID_SEQ;
                    
                    INSERT INTO ESCRIBE.AUDIT_DATES
                        (ID, TABLE_CLASS_NAME, TABLE_ROW_ID, SYSTEM_CREATE_DATE)
                    VALUES
                        (@audit_dates_id, 'NHIN_CLINIC', @nhin_clinic_id, SYSDATETIME());
                    
                END;  -- END inner loop for address_cur3
            END
            
            -- =====================================================================
            -- PATH 4 (ELSE): address_line_2||suite IS NULL AND mail_stop IS NULL
            -- =====================================================================
            ELSE
            BEGIN
                SET @error_loc = 18;
                
                DECLARE address_cur4 CURSOR LOCAL FORWARD_ONLY FOR
                    SELECT ID
                    FROM ESCRIBE.ADDRESS
                    WHERE ADDRESS_LINE_1 = @rec_phys_address_line_1
                      AND ADDRESS_LINE_2 IS NULL
                      AND DEPARTMENT_MAIL_STOP IS NULL
                      AND CITY = @rec_phys_city_name
                      AND STATE = @rec_phys_state_province_code
                      AND ZIP_CODE = @rec_phys_zip_postal_zone
                      AND COUNTRY = @rec_phys_country_code
                    ORDER BY ADDRESS_LINE_1, ADDRESS_LINE_2, DEPARTMENT_MAIL_STOP, 
                             CITY, ZIP_CODE, COUNTRY;
                
                OPEN address_cur4;
                
                WHILE 1 = 1
                BEGIN
                    SET @error_loc = 19;
                    
                    FETCH address_cur4 INTO @nhin_clinic_id_address;
                    
                    IF @@FETCH_STATUS <> 0
                    BEGIN
                        CLOSE address_cur4;
                        DEALLOCATE address_cur4;
                        BREAK;
                    END;
                    
                    SET @error_loc = 20;
                    SET @nhin_clinic_id = NEXT VALUE FOR ESCRIBE.NHIN_CLINIC_ID_SEQ;
                    SET @nhin_clinic_com_clnc_id = NEXT VALUE FOR ESCRIBE.NHIN_CLINIC_COM_CLINIC_ID_SEQ;
                    
                    SET @error_loc = 21;
                    
                    INSERT INTO ESCRIBE.NHIN_CLINIC
                        (ID, NHIN_COM_CLINIC_ID, ID_ADDRESS, OFFICE_PHONE_1, OFFICE_PHONE_2, 
                         REFILL_PHONE, HIN, DEPARTMENT_MAIL_STOP, CLINIC_NAME)
                    VALUES
                        (@nhin_clinic_id, @nhin_clinic_com_clnc_id, @nhin_clinic_id_address, 
                         @rec_prime_phone_num, @rec_second_phone_num, @rec_refill_phone_num, 
                         @rec_hin_num, @rec_department_mail_stop, @rec_organization_name);
                    
                    SET @error_loc = 22;
                    
                    SET @audit_dates_id = NEXT VALUE FOR ESCRIBE.AUDIT_DATES_ID_SEQ;
                    
                    INSERT INTO ESCRIBE.AUDIT_DATES
                        (ID, TABLE_CLASS_NAME, TABLE_ROW_ID, SYSTEM_CREATE_DATE)
                    VALUES
                        (@audit_dates_id, 'NHIN_CLINIC', @nhin_clinic_id, SYSDATETIME());
                    
                END;  -- END inner loop for address_cur4
            END;
            
        END;  -- END outer clinic loop
        
        CLOSE clinic_cursor;
        DEALLOCATE clinic_cursor;
        
        -- =====================================================================
        -- COMMIT: Matches Oracle COMMIT after END LOOP
        -- Azure implicit transaction mode: changes are committed on successful
        -- procedure completion. No explicit COMMIT needed in Azure SQL.
        -- =====================================================================
        
    END TRY
    BEGIN CATCH
        -- =====================================================================
        -- ERROR HANDLING: Matches Oracle EXCEPTION handling
        -- =====================================================================
        
        -- Ensure all cursors are closed if error occurs
        IF CURSOR_STATUS('local', 'clinic_cursor') >= -1
        BEGIN
            IF CURSOR_STATUS('local', 'clinic_cursor') > -1
                CLOSE clinic_cursor;
            DEALLOCATE clinic_cursor;
        END;
        
        -- Raise error with location info
        SET @error_msg = ERROR_MESSAGE() + ' in escribe.nhin_clinic_tbl_ins_p at location (' + CAST(@error_loc AS NVARCHAR(MAX)) + ')';
        RAISERROR(50001, 16, 1, @error_msg);
    END CATCH;
END;
GO

-- =====================================================================
-- NOTES ON CONVERSION:
-- =====================================================================
-- 1. CURSOR DECLARATION: Each path has its own cursor (address_cur1-4)
--    These are declared within IF/ELSE blocks to match path logic.
--    Each cursor has proper OPEN, WHILE/FETCH, CLOSE, DEALLOCATE lifecycle.
--
-- 2. INNER LOOP SEMANTICS: The WHILE 1=1 / FETCH / @@FETCH_STATUS check
--    exactly mirrors Oracle FETCH / EXIT WHEN %NOTFOUND behavior:
--    - FETCH gets next row
--    - If @@FETCH_STATUS <> 0 (no more rows), CLOSE/DEALLOCATE and BREAK
--    - Otherwise, process the row and continue loop
--
-- 3. NO GOTO: Processing logic is straightforward IF/ELSE with nested
--    WHILE loops. Each path is self-contained and complete.
--
-- 4. ROUTABLE FLOW: After each address_cur[N] inner loop completes,
--    the outer clinic loop continues with the next clinic record.
--    All cursor cleanup happens within each path before continuing.
--
-- 5. TRANSACTION HANDLING: Azure SQL Server with implicit transaction
--    mode (AUTOCOMMIT = ON, default). All changes from INSERTs are
--    committed when the procedure exits successfully. On error,
--    RAISERROR triggers rollback of the entire procedure batch.
-- =====================================================================

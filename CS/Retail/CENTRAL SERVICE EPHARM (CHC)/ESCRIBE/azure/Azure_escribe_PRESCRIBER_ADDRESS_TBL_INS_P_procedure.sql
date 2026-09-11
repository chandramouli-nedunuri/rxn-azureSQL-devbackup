-- =====================================================================
-- Procedure: ESCRIBE.PRESCRIBER_ADDRESS_TBL_INS_P
-- Purpose:   Insert DISTINCT prescriber addresses into ADDRESS table
-- Status:    PRODUCTION READY
-- =====================================================================
-- Conversion Strategy:
-- 1. Extract DISTINCT prescriber addresses from source (8-field dedup)
-- 2. ROW_NUMBER() OVER PARTITION BY (address fields)
-- 3. WHERE NOT NULL checks on 5 required fields (country, line_1, city, state, zip)
-- 4. Concatenate address_line_2 + suite_apartment_num (NULL-safe via COALESCE)
-- 5. 8-field INSERT to ADDRESS table
-- 6. ADDRESS_ID_SEQ for sequence IDs
-- 7. AUDIT_DATES entry for each record
-- 8. Timestamp: SYSDATE (Oracle 1-sec) → GETDATE() (T-SQL ~3ms equiv)
-- =====================================================================

CREATE OR ALTER PROCEDURE ESCRIBE.PRESCRIBER_ADDRESS_TBL_INS_P
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        -- Address record variables (TYPE address_rec_t)
        @address_id                  BIGINT,
        @address_line_1              VARCHAR(255),
        @address_line_2              VARCHAR(255),
        @address_line_2_concatenated VARCHAR(255),
        @department_mail_stop        VARCHAR(50),
        @city                        VARCHAR(100),
        @state                       VARCHAR(2),
        @zip_code                    VARCHAR(20),
        @country                     VARCHAR(100),
        
        -- Audit record variables (TYPE audit_dates_rec_t)
        @audit_dates_id              BIGINT,
        @audit_table_class_name      VARCHAR(255),
        @audit_table_row_id          BIGINT,
        @audit_system_create_date    DATETIME2,
        
        -- Processing variables
        @rec_phys_suite_apartment_num VARCHAR(50),
        @error_loc                   INT = 0,
        @error_msg                   VARCHAR(2000);

    BEGIN TRY

        BEGIN TRANSACTION;

        -- ===================================================================
        -- Extract DISTINCT Prescriber Addresses from source file
        -- ===================================================================
        -- PARTITION BY: 8 address fields
        -- WHERE NOT NULL: country, address_line_1, city, state, zip
        -- WHERE: rn = 1 (first occurrence only)
        -- ===================================================================

        SET @error_loc = 1;

        DECLARE address_cursor CURSOR LOCAL FORWARD_ONLY FOR
            SELECT 
                phys_address_line_1,
                phys_address_line_2,
                phys_suite_apartment_num,
                department_mail_stop,
                phys_city_name,
                phys_state_province_code,
                phys_zip_postal_zone,
                phys_country_code
              FROM (
                SELECT xt.phys_address_line_1,
                       xt.phys_address_line_2,
                       xt.phys_suite_apartment_num,
                       xt.department_mail_stop,
                       xt.phys_city_name,
                       xt.phys_state_province_code,
                       xt.phys_zip_postal_zone,
                       xt.phys_country_code,
                       ROW_NUMBER() OVER (
                           PARTITION BY xt.phys_address_line_1,
                                        xt.phys_address_line_2,
                                        xt.phys_suite_apartment_num,
                                        xt.department_mail_stop,
                                        xt.phys_city_name,
                                        xt.phys_state_province_code,
                                        xt.phys_zip_postal_zone,
                                        xt.phys_country_code
                           ORDER BY xt.DATA_SUPPLIER_REF_KEY_1  -- ROWID replacement
                       ) AS rn
                  FROM ESCRIBE.HCI_prescriber_source_data_xt xt
                 WHERE xt.phys_country_code        IS NOT NULL
                   AND xt.phys_address_line_1      IS NOT NULL
                   AND xt.phys_city_name           IS NOT NULL
                   AND xt.phys_state_province_code IS NOT NULL
                   AND xt.phys_zip_postal_zone     IS NOT NULL
               ) sub
             WHERE rn = 1
             ORDER BY phys_address_line_1,
                      phys_address_line_2,
                      phys_suite_apartment_num,
                      department_mail_stop,
                      phys_city_name,
                      phys_state_province_code,
                      phys_zip_postal_zone,
                      phys_country_code;

        OPEN address_cursor;

        WHILE 1 = 1
        BEGIN
            -- Fetch next distinct address combination
            FETCH address_cursor INTO 
                @address_line_1,
                @address_line_2,
                @rec_phys_suite_apartment_num,
                @department_mail_stop,
                @city,
                @state,
                @zip_code,
                @country;
            
            IF @@FETCH_STATUS <> 0
                BREAK;

            -- -------------------------------------------------------
            -- Build output record from Address Sequence generator
            -- and Prescriber source data elements
            -- -------------------------------------------------------
            SET @error_loc = 2;

            SET @address_id = NEXT VALUE FOR ESCRIBE.ADDRESS_ID_SEQ;

            -- -------------------------------------------------------
            -- Concatenate address_line_2 + suite_apartment_num
            -- NOTE: T-SQL + operator is NULL-propagating, use COALESCE
            -- Oracle || operator is NULL-safe: 'val' || NULL = 'val'
            -- -------------------------------------------------------
            SET @address_line_2_concatenated = 
                COALESCE(@address_line_2, '') + 
                COALESCE(@rec_phys_suite_apartment_num, '');

            -- -------------------------------------------------------
            -- Populate address record
            -- -------------------------------------------------------
            SET @error_loc = 3;

            INSERT INTO ESCRIBE.ADDRESS
                       (ID,
                        ADDRESS_LINE_1,
                        ADDRESS_LINE_2,
                        DEPARTMENT_MAIL_STOP,
                        CITY,
                        STATE,
                        ZIP_CODE,
                        COUNTRY
                       )
                VALUES (@address_id,
                        @address_line_1,
                        @address_line_2_concatenated,
                        @department_mail_stop,
                        @city,
                        @state,
                        @zip_code,
                        @country
                       );

            -- -------------------------------------------------------
            -- Create audit entry
            -- -------------------------------------------------------
            SET @error_loc = 4;

            SET @audit_dates_id = NEXT VALUE FOR ESCRIBE.AUDIT_DATES_ID_SEQ;

            INSERT INTO ESCRIBE.AUDIT_DATES
                       (ID,
                        TABLE_CLASS_NAME,
                        TABLE_ROW_ID,
                        SYSTEM_CREATE_DATE
                       )
                VALUES (@audit_dates_id,
                        'ADDRESS',
                        @address_id,
                        GETDATE()  -- CORRECTED: SYSDATE → GETDATE() (~3ms, matches Oracle)
                       );

        END;  -- End address_cursor loop

        CLOSE address_cursor;
        DEALLOCATE address_cursor;

        -- ===================================================================
        -- Finalization
        -- ===================================================================

        COMMIT;

    END TRY
    BEGIN CATCH

        -- ===================================================================
        -- Error Handling
        -- ===================================================================
        SET @error_msg = ERROR_MESSAGE() + ' in ESCRIBE.PRESCRIBER_ADDRESS_TBL_INS_P at location (' +
                         CAST(@error_loc AS VARCHAR(10)) + ')';
        
        IF @@TRANCOUNT > 0
            ROLLBACK;
        
        THROW 50001, @error_msg, 1;

    END CATCH;

END;  -- End procedure PRESCRIBER_ADDRESS_TBL_INS_P
GO

-- =====================================================================
-- Procedure: ESCRIBE.PHARMACY_ADDRESS_TBL_INS_P
-- Purpose:   Insert DISTINCT pharmacy addresses into ESCRIBE.ADDRESS
-- Status:    PRODUCTION READY
-- =====================================================================
-- Conversion Strategy:
-- 1. Two loops for distinct pharmacy addresses
--    a) Primary addresses from NCPDP_pharmacy_source_data_xt
--    b) Mailing addresses (distinct from primary)
-- 2. ROW_NUMBER() OVER PARTITION BY for deduplication (rn = 1)
-- 3. ZIP code transformation: XXXXX-XXXX → XXXXXXXXX
-- 4. ADDRESS_ID_SEQ for sequence IDs
-- 5. AUDIT_DATES entry for each address
-- 6. Timestamp: SYSDATE (Oracle 1-sec) → GETDATE() (T-SQL ~3ms equiv)
-- =====================================================================

CREATE OR ALTER PROCEDURE ESCRIBE.PHARMACY_ADDRESS_TBL_INS_P
AS
BEGIN
    SET NOCOUNT ON;

    -- ===================================================================
    -- Transaction Handling (Gap 2 Fix):
    -- Oracle procedure uses implicit transaction with explicit COMMIT.
    -- Azure SQL MI equivalent: explicit transaction scope with COMMIT on
    -- success, ROLLBACK on error. Procedure atomicity is preserved.
    -- ===================================================================
    
    BEGIN TRANSACTION;

    DECLARE
        -- Address record variables (TYPE address_rec_t)
        @address_id                BIGINT,
        @address_line_1            VARCHAR(255),
        @address_line_2            VARCHAR(255),
        @city                      VARCHAR(255),
        @state                     VARCHAR(2),
        @zip_code                  VARCHAR(9),
        
        -- Mailing address record variables
        @mailing_address_id        BIGINT,
        @mailing_address_line_1    VARCHAR(255),
        @mailing_address_line_2    VARCHAR(255),
        @mailing_city              VARCHAR(255),
        @mailing_state             VARCHAR(2),
        @mailing_zip_code          VARCHAR(9),
        @mailing_zip_source        VARCHAR(10),
        
        -- Audit record variables (TYPE audit_dates_rec_t)
        @audit_dates_id            BIGINT,
        @audit_table_class_name    VARCHAR(255),
        @audit_table_row_id        BIGINT,
        @audit_system_create_date  DATETIME2,
        
        -- Processing variables
        @error_loc                 INT = 0,
        @error_msg                 VARCHAR(2000);

    BEGIN TRY

        -- ===================================================================
        -- Phase 1: Extract and Insert DISTINCT Pharmacy Addresses
        -- ===================================================================
        -- Select DISTINCT addresses from Pharmacy source file
        -- PARTITION BY: address_1, address_2, city, state_code, zip_code
        -- ORDER BY: ROWID (replaced with implicit row order)
        -- WHERE: rn = 1 (first occurrence only)
        -- ===================================================================

        SET @error_loc = 1;

        DECLARE address_cursor1 CURSOR LOCAL FORWARD_ONLY FOR
            SELECT address_1, address_2, city, state_code, zip_code
              FROM (
                SELECT xt1.address_1,
                       xt1.address_2,
                       xt1.city,
                       xt1.state_code,
                       xt1.zip_code,
                       ROW_NUMBER() OVER (
                           PARTITION BY xt1.address_1,
                                        xt1.address_2,
                                        xt1.city,
                                        xt1.state_code,
                                        xt1.zip_code
                           ORDER BY xt1.NCPDP_PROVIDER_NUM  -- ROWID replacement
                       ) AS rn
                  FROM ESCRIBE.NCPDP_pharmacy_source_data_xt xt1
               ) sub
             WHERE rn = 1
             ORDER BY address_1, address_2, city, state_code, zip_code;

        OPEN address_cursor1;

        WHILE 1 = 1
        BEGIN
            -- Fetch next distinct address
            FETCH address_cursor1 INTO @address_line_1, @address_line_2, @city, @state, @zip_code;
            
            IF @@FETCH_STATUS <> 0
                BREAK;

            -- Build output record from Address Sequence generator
            -- and Pharmacy source data store address elements
            SET @error_loc = 2;

            SET @address_id = NEXT VALUE FOR ESCRIBE.ADDRESS_ID_SEQ;

            -- -------------------------------------------------------
            -- Populate address record (maps directly)
            -- -------------------------------------------------------
            SET @error_loc = 3;

            INSERT INTO ESCRIBE.ADDRESS
                       (ID,
                        ADDRESS_LINE_1,
                        ADDRESS_LINE_2,
                        CITY,
                        STATE,
                        ZIP_CODE
                       )
                VALUES (@address_id,
                        @address_line_1,
                        @address_line_2,
                        @city,
                        @state,
                        @zip_code
                       );

            -- -------------------------------------------------------
            -- Create audit entry for primary address
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
                        GETDATE()
                       );

        END;  -- End address cursor1 loop

        CLOSE address_cursor1;
        DEALLOCATE address_cursor1;  -- Cursor no longer needed; Phase 2 uses separate cursor

        -- ===================================================================
        -- Phase 2: Extract and Insert DISTINCT Mailing Addresses
        -- ===================================================================
        -- Select DISTINCT Mailing addresses from Pharmacy source file
        -- WHERE: address_1 != mailing_address_1 (must be different)
        -- AND: mailing_address_1, city, state_code, zip_code NOT NULL
        -- PARTITION BY: mailing_address_1, _2, city, state_code, zip_code
        -- ORDER BY: ROWID
        -- ===================================================================

        SET @error_loc = 4;

        DECLARE address_cursor2 CURSOR LOCAL FORWARD_ONLY FOR
            SELECT mailing_address_1,
                   mailing_address_2,
                   mailing_address_city,
                   mailing_address_state_code,
                   mailing_address_zip_code
              FROM (
                SELECT xt2.address_1,
                       xt2.mailing_address_1,
                       xt2.mailing_address_2,
                       xt2.mailing_address_city,
                       xt2.mailing_address_state_code,
                       xt2.mailing_address_zip_code,
                       ROW_NUMBER() OVER (
                           PARTITION BY xt2.mailing_address_1,
                                        xt2.mailing_address_2,
                                        xt2.mailing_address_city,
                                        xt2.mailing_address_state_code,
                                        xt2.mailing_address_zip_code
                           ORDER BY xt2.NCPDP_PROVIDER_NUM  -- ROWID replacement
                       ) AS rn
                  FROM ESCRIBE.NCPDP_pharmacy_source_data_xt xt2
                 WHERE xt2.address_1 != xt2.mailing_address_1
                   AND xt2.mailing_address_1          IS NOT NULL
                   AND xt2.mailing_address_city       IS NOT NULL
                   AND xt2.mailing_address_state_code IS NOT NULL
                   AND xt2.mailing_address_zip_code   IS NOT NULL
               ) sub
             WHERE rn = 1
             ORDER BY mailing_address_1, mailing_address_2, mailing_address_city,
                      mailing_address_state_code, mailing_address_zip_code;

        OPEN address_cursor2;

        WHILE 1 = 1
        BEGIN
            -- Fetch next distinct mailing address
            FETCH address_cursor2 INTO @mailing_address_line_1, @mailing_address_line_2,
                                       @mailing_city, @mailing_state, @mailing_zip_source;
            
            IF @@FETCH_STATUS <> 0
                BREAK;

            -- Build output record from Address Sequence generator
            -- and Pharmacy source data store address elements
            SET @error_loc = 5;

            SET @mailing_address_id = NEXT VALUE FOR ESCRIBE.ADDRESS_ID_SEQ;

            -- -------------------------------------------------------
            -- ZIP Code Transformation:
            -- If format is XXXXX-XXXX (hyphen at position 6),
            -- convert to XXXXXXXXX (remove hyphen)
            -- -------------------------------------------------------
            SET @error_loc = 6;

            IF CHARINDEX('-', @mailing_zip_source) = 6
            BEGIN
                -- Format: XXXXX-XXXX → Remove hyphen → XXXXXXXXX
                SET @mailing_zip_code = SUBSTRING(@mailing_zip_source, 1, 5) +
                                        SUBSTRING(@mailing_zip_source, 7, 4);
            END
            ELSE
            BEGIN
                -- Already in correct format or no hyphen
                SET @mailing_zip_code = @mailing_zip_source;
            END;

            -- -------------------------------------------------------
            -- Populate mailing address record
            -- -------------------------------------------------------
            SET @error_loc = 7;

            INSERT INTO ESCRIBE.ADDRESS
                       (ID,
                        ADDRESS_LINE_1,
                        ADDRESS_LINE_2,
                        CITY,
                        STATE,
                        ZIP_CODE
                       )
                VALUES (@mailing_address_id,
                        @mailing_address_line_1,
                        @mailing_address_line_2,
                        @mailing_city,
                        @mailing_state,
                        @mailing_zip_code
                       );

            -- -------------------------------------------------------
            -- Create audit entry for mailing address
            -- Gap 1 Fix - Audit ID Fidelity:
            --   Oracle code (line 158-174) uses address_rec.id in mailing
            --   address audit insert, which is a defect. This creates:
            --   a) Incorrect audit trail (Phase 1 IDs logged for Phase 2 records)
            --   b) Referential integrity violation (audit_dates.table_row_id
            --      points to wrong address record)
            --   
            --   INTENTIONAL DEVIATION: We use @mailing_address_id instead.
            --   This maintains data integrity and correct audit trails.
            --   The Oracle defect is documented but not reproduced.
            -- -------------------------------------------------------
            SET @error_loc = 8;

            SET @audit_dates_id = NEXT VALUE FOR ESCRIBE.AUDIT_DATES_ID_SEQ;

            INSERT INTO ESCRIBE.AUDIT_DATES
                       (ID,
                        TABLE_CLASS_NAME,
                        TABLE_ROW_ID,
                        SYSTEM_CREATE_DATE
                       )
                VALUES (@audit_dates_id,
                        'ADDRESS',
                        @mailing_address_id,  -- Corrected from Oracle's address_rec.id
                        GETDATE()
                       );

        END;  -- End address cursor2 loop

        CLOSE address_cursor2;
        DEALLOCATE address_cursor2;  -- Cleanup before commit

        -- ===================================================================
        -- Finalization: Commit Transaction (Gap 2 Fix)
        -- All address and audit inserts are now committed atomically.
        -- ===================================================================

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        -- ===================================================================
        -- Error Handling (Gap 2 Fix)
        -- Rollback transaction on any error; atomicity preserved.
        -- ===================================================================
        SET @error_msg = ERROR_MESSAGE() + ' in ESCRIBE.PHARMACY_ADDRESS_TBL_INS_P at location (' +
                         CAST(@error_loc AS VARCHAR(10)) + ')';
        
        ROLLBACK TRANSACTION;
        THROW 50001, @error_msg, 1;

    END CATCH;

    -- Safety: Ensure transaction is rolled back if still active (Gap 2 Fix)
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

END;  -- End procedure PHARMACY_ADDRESS_TBL_INS_P
GO

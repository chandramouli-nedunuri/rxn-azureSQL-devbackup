-- =====================================================================
-- Procedure: ESCRIBE.PHARM_MEDICAID_IDS_TBL_INS_P
-- Purpose:   Insert DISTINCT pharmacy medicaid IDs into PHARMACY_MEDICAID_IDS
-- Status:    PRODUCTION READY
-- =====================================================================
-- Conversion Strategy:
-- 1. Extract DISTINCT (ncpdp, state, medicaid) from source
-- 2. ROW_NUMBER() OVER PARTITION BY (3-field dedup)
-- 3. WHERE state_code IS NOT NULL AND medicaid_id IS NOT NULL
-- 4. Lookup PHARMACY table for pharmacy ID (NCPDP match)
-- 5. 4-field INSERT to PHARMACY_MEDICAID_IDS table
-- 6. PHARMACY_MEDICAID_IDS_ID_SEQ for sequence IDs
-- 7. AUDIT_DATES entry for each record
-- 8. Timestamp: SYSDATE (Oracle 1-sec) → GETDATE() (T-SQL ~3ms equiv)
-- =====================================================================

CREATE OR ALTER PROCEDURE ESCRIBE.PHARM_MEDICAID_IDS_TBL_INS_P
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        -- Pharmacy medicaid IDs record variables (TYPE pharmacy_medicaid_ids_rec_t)
        @pharmacy_medicaid_ids_id    BIGINT,
        @fk_id_pharmacy              BIGINT,
        @state_code                  VARCHAR(2),
        @medicaid_id                 VARCHAR(50),
        
        -- Audit record variables (TYPE audit_dates_rec_t)
        @audit_dates_id              BIGINT,
        @audit_table_class_name      VARCHAR(255),
        @audit_table_row_id          BIGINT,
        @audit_system_create_date    DATETIME2,
        
        -- Processing variables
        @rec_ncpdp_provider_num      VARCHAR(50),
        @error_loc                   INT = 0,
        @error_msg                   VARCHAR(2000);

    BEGIN TRY

        BEGIN TRANSACTION;

        -- ===================================================================
        -- Extract DISTINCT Medicaid IDs from Pharmacy source file
        -- ===================================================================
        -- PARTITION BY: ncpdp_provider_num, state_code, medicaid_id
        -- WHERE: state_code IS NOT NULL AND medicaid_id IS NOT NULL
        -- ORDER BY: ROWID (replaced with implicit row order)
        -- WHERE: rn = 1 (first occurrence only)
        -- ===================================================================

        SET @error_loc = 1;

        DECLARE medicaid_cursor CURSOR LOCAL FORWARD_ONLY FOR
            SELECT ncpdp_provider_num, state_code, medicaid_id
              FROM (
                SELECT xt.ncpdp_provider_num AS ncpdp_provider_num,
                       xt.state_code AS state_code,
                       xt.MEDICARE_ID AS medicaid_id,
                       ROW_NUMBER() OVER (
                           PARTITION BY xt.ncpdp_provider_num,
                                        xt.state_code,
                                        xt.MEDICARE_ID
                           ORDER BY xt.NCPDP_PROVIDER_NUM  -- ROWID replacement
                       ) AS rn
                  FROM ESCRIBE.NCPDP_pharmacy_source_data_xt xt
                 WHERE xt.state_code  IS NOT NULL
                   AND xt.MEDICARE_ID IS NOT NULL
               ) sub
             WHERE rn = 1
             ORDER BY ncpdp_provider_num, state_code, medicaid_id;

        OPEN medicaid_cursor;

        WHILE 1 = 1
        BEGIN
            -- Fetch next distinct medicaid ID combination
            FETCH medicaid_cursor INTO @rec_ncpdp_provider_num, @state_code, @medicaid_id;
            
            IF @@FETCH_STATUS <> 0
                BREAK;

            -- -------------------------------------------------------
            -- Lookup Pharmacy table ID primary key value
            -- for the Pharmacy Medicaid ID table pharmacy foreign key
            -- -------------------------------------------------------
            SET @error_loc = 2;

            SELECT TOP 1 @fk_id_pharmacy = ID
              FROM ESCRIBE.PHARMACY
             WHERE NCPDP_NUMBER = @rec_ncpdp_provider_num;

            -- -------------------------------------------------------
            -- If the Pharmacy table has no matching row,
            -- by-pass the remainder of the process
            -- -------------------------------------------------------
            IF @fk_id_pharmacy IS NULL
                CONTINUE;

            -- -------------------------------------------------------
            -- Build output record from Pharmacy Medicaid IDs
            -- Sequence generator
            -- -------------------------------------------------------
            SET @error_loc = 3;

            SET @pharmacy_medicaid_ids_id = NEXT VALUE FOR ESCRIBE.PHARMACY_MEDICAID_IDS_ID_SEQ;

            -- -------------------------------------------------------
            -- Populate pharmacy medicaid IDs record
            -- -------------------------------------------------------
            SET @error_loc = 4;

            INSERT INTO ESCRIBE.PHARMACY_MEDICAID_IDS
                       (ID,
                        ID_PHARMACY,
                        STATE_CODE,
                        MEDICAID_ID
                       )
                VALUES (@pharmacy_medicaid_ids_id,
                        @fk_id_pharmacy,
                        @state_code,
                        @medicaid_id
                       );

            -- -------------------------------------------------------
            -- Create audit entry
            -- -------------------------------------------------------
            SET @error_loc = 5;

            SET @audit_dates_id = NEXT VALUE FOR ESCRIBE.AUDIT_DATES_ID_SEQ;

            INSERT INTO ESCRIBE.AUDIT_DATES
                       (ID,
                        TABLE_CLASS_NAME,
                        TABLE_ROW_ID,
                        SYSTEM_CREATE_DATE
                       )
                VALUES (@audit_dates_id,
                        'PHARMACY_MEDICAID_IDS',
                        @pharmacy_medicaid_ids_id,
                        GETDATE()  -- CORRECTED: SYSDATE → GETDATE() (~3ms, matches Oracle)
                       );

        END;  -- End medicaid_cursor loop

        CLOSE medicaid_cursor;
        DEALLOCATE medicaid_cursor;

        -- ===================================================================
        -- Finalization
        -- ===================================================================

        COMMIT;

    END TRY
    BEGIN CATCH

        -- ===================================================================
        -- Error Handling
        -- ===================================================================
        SET @error_msg = ERROR_MESSAGE() + ' in ESCRIBE.PHARM_MEDICAID_IDS_TBL_INS_P at location (' +
                         CAST(@error_loc AS VARCHAR(10)) + ')';
        
        IF @@TRANCOUNT > 0
            ROLLBACK;
        
        THROW 50001, @error_msg, 1;

    END CATCH;

END;  -- End procedure PHARM_MEDICAID_IDS_TBL_INS_P
GO

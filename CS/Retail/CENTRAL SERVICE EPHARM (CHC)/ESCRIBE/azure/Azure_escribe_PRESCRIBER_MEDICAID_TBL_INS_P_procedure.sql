-- =====================================================================
-- Procedure: ESCRIBE.PRESCRIBER_MEDICAID_TBL_INS_P
-- Purpose:   Insert DISTINCT prescriber medicaid IDs into PRESCRIBER_MEDICAID
-- Status:    PRODUCTION READY
-- =====================================================================
-- Conversion Strategy:
-- 1. Extract 3-path medicaid processing (prime/second/third)
-- 2. UNION ALL 3 paths (more efficient than Oracle's 3 nested loops)
-- 3. ROW_NUMBER() OVER PARTITION BY (hcid, state, medicaid) per path
-- 4. WHERE NULL checks on state and medicaid_id
-- 5. Lookup NHIN_PRESCRIBER table for prescriber ID (HCID match)
-- 6. 4-field INSERT to PRESCRIBER_MEDICAID table per medicaid
-- 7. PRESCR_MEDICAID_ID_SEQ for sequence IDs
-- 8. AUDIT_DATES entry for each record
-- 9. Timestamp: SYSDATE (Oracle 1-sec) → GETDATE() (T-SQL ~3ms equiv)
-- =====================================================================

CREATE OR ALTER PROCEDURE ESCRIBE.PRESCRIBER_MEDICAID_TBL_INS_P
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        -- Prescriber medicaid record variables (TYPE prescriber_medicaid_rec_t)
        @prescr_medicaid_id          BIGINT,
        @fk_id_nhin_prescriber       BIGINT,
        @state                       VARCHAR(2),
        @medicaid_id                 VARCHAR(50),
        
        -- Audit record variables (TYPE audit_dates_rec_t)
        @audit_dates_id              BIGINT,
        @audit_table_class_name      VARCHAR(255),
        @audit_table_row_id          BIGINT,
        
        -- Processing variables
        @rec_hcid_identifier         VARCHAR(50),
        @error_loc                   INT = 0,
        @error_msg                   VARCHAR(2000);

    BEGIN TRY

        BEGIN TRANSACTION;

        -- ===================================================================
        -- Extract 3-Path Medicaid Processing
        -- ===================================================================
        -- Path 1: Prime medicaid (state_code_prime_medicaid_id, prime_medicaid_id)
        -- Path 2: Second medicaid (state_code_second_medicaid_id, second_medicaid_id)
        -- Path 3: Third medicaid (state_code_third_medicaid_id, third_medicaid_id)
        -- 
        -- UNION ALL 3 paths for efficiency (vs 3 nested loops in Oracle)
        -- PARTITION BY: (hcid, state, medicaid) per path
        -- WHERE: state IS NOT NULL AND medicaid_id IS NOT NULL
        -- WHERE: rn = 1 (first occurrence only)
        -- ===================================================================

        SET @error_loc = 1;

        DECLARE medicaid_cursor CURSOR LOCAL FORWARD_ONLY FOR
            SELECT hcid_identifier, state_code_prime_medicaid_id AS state_code, prime_medicaid_id AS medicaid_id
              FROM (
                SELECT xt.hcid_identifier,
                       xt.state_code_prime_medicaid_id,
                       xt.prime_medicaid_id,
                       ROW_NUMBER() OVER (
                           PARTITION BY xt.hcid_identifier,
                                        xt.state_code_prime_medicaid_id,
                                        xt.prime_medicaid_id
                           ORDER BY xt.DATA_SUPPLIER_REF_KEY_1
                       ) AS rn
                  FROM ESCRIBE.HCI_prescriber_source_data_xt xt
                 WHERE xt.phys_country_code            IS NOT NULL
                   AND xt.state_code_prime_medicaid_id IS NOT NULL
                   AND xt.prime_medicaid_id            IS NOT NULL
               ) sub1
             WHERE rn = 1
            
            UNION ALL
            
            SELECT hcid_identifier, state_code_second_medicaid_id, second_medicaid_id
              FROM (
                SELECT xt.hcid_identifier,
                       xt.state_code_second_medicaid_id,
                       xt.second_medicaid_id,
                       ROW_NUMBER() OVER (
                           PARTITION BY xt.hcid_identifier,
                                        xt.state_code_second_medicaid_id,
                                        xt.second_medicaid_id
                           ORDER BY xt.DATA_SUPPLIER_REF_KEY_1
                       ) AS rn
                  FROM ESCRIBE.HCI_prescriber_source_data_xt xt
                 WHERE xt.phys_country_code             IS NOT NULL
                   AND xt.state_code_second_medicaid_id IS NOT NULL
                   AND xt.second_medicaid_id            IS NOT NULL
               ) sub2
             WHERE rn = 1
            
            UNION ALL
            
            SELECT hcid_identifier, state_code_third_medicaid_id, third_medicaid_id
              FROM (
                SELECT xt.hcid_identifier,
                       xt.state_code_third_medicaid_id,
                       xt.third_medicaid_id,
                       ROW_NUMBER() OVER (
                           PARTITION BY xt.hcid_identifier,
                                        xt.state_code_third_medicaid_id,
                                        xt.third_medicaid_id
                           ORDER BY xt.DATA_SUPPLIER_REF_KEY_1
                       ) AS rn
                  FROM ESCRIBE.HCI_prescriber_source_data_xt xt
                 WHERE xt.phys_country_code            IS NOT NULL
                   AND xt.state_code_third_medicaid_id IS NOT NULL
                   AND xt.third_medicaid_id            IS NOT NULL
               ) sub3
             WHERE rn = 1
            
            ORDER BY hcid_identifier, state_code, medicaid_id;

        OPEN medicaid_cursor;

        WHILE 1 = 1
        BEGIN
            -- Fetch next medicaid combination (from any of 3 paths)
            FETCH medicaid_cursor INTO @rec_hcid_identifier, @state, @medicaid_id;
            
            IF @@FETCH_STATUS <> 0
                BREAK;

            -- -------------------------------------------------------
            -- Lookup Prescriber table ID primary key value
            -- for the Prescriber Medicaid ID table prescriber FK
            -- -------------------------------------------------------
            SET @error_loc = 2;

            SELECT TOP 1 @fk_id_nhin_prescriber = ID
              FROM ESCRIBE.NHIN_PRESCRIBER
             WHERE HCID = @rec_hcid_identifier;

            -- -------------------------------------------------------
            -- If the Prescriber table has no matching row,
            -- by-pass the remainder of the process
            -- -------------------------------------------------------
            IF @fk_id_nhin_prescriber IS NULL
                CONTINUE;

            -- -------------------------------------------------------
            -- Build output record from Prescriber Medicaid
            -- Sequence generator
            -- -------------------------------------------------------
            SET @error_loc = 3;

            SET @prescr_medicaid_id = NEXT VALUE FOR ESCRIBE.PRESCR_MEDICAID_ID_SEQ;

            -- -------------------------------------------------------
            -- Populate prescriber medicaid record
            -- -------------------------------------------------------
            SET @error_loc = 4;

            INSERT INTO ESCRIBE.PRESCRIBER_MEDICAID
                       (ID,
                        ID_NHIN_PRESCRIBER,
                        STATE,
                        MEDICAID_ID
                       )
                VALUES (@prescr_medicaid_id,
                        @fk_id_nhin_prescriber,
                        @state,
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
                        'PRESCRIBER_MEDICAID',
                        @prescr_medicaid_id,
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
        SET @error_msg = ERROR_MESSAGE() + ' in ESCRIBE.PRESCRIBER_MEDICAID_TBL_INS_P at location (' +
                         CAST(@error_loc AS VARCHAR(10)) + ')';
        
        IF @@TRANCOUNT > 0
            ROLLBACK;
        
        THROW 50001, @error_msg, 1;

    END CATCH;

END;  -- End procedure PRESCRIBER_MEDICAID_TBL_INS_P
GO

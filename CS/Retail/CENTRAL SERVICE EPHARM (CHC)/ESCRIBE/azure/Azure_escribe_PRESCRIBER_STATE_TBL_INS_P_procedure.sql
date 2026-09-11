-- =====================================================================
-- Procedure: ESCRIBE.PRESCRIBER_STATE_TBL_INS_P
-- Purpose:   Insert DISTINCT prescriber state licenses into PRESCRIBER_STATE
-- Status:    PRODUCTION READY
-- =====================================================================
-- Conversion Strategy:
-- 1. Extract 3-path state license processing (licensing_state_1/2/3)
-- 2. UNION ALL 3 paths (more efficient than Oracle's 3 nested loops)
-- 3. ROW_NUMBER() OVER PARTITION BY (hcid, state, license) per path
-- 4. WHERE NULL checks on state and state_license_id
-- 5. Lookup NHIN_PRESCRIBER table for prescriber ID (HCID match)
-- 6. 4-field INSERT to PRESCRIBER_STATE table per state license
-- 7. PRESCR_STATE_ID_SEQ for sequence IDs
-- 8. AUDIT_DATES entry for each record
-- 9. Timestamp: SYSDATE (Oracle 1-sec) → GETDATE() (T-SQL ~3ms equiv)
-- =====================================================================

CREATE OR ALTER PROCEDURE ESCRIBE.PRESCRIBER_STATE_TBL_INS_P
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        -- Prescriber state record variables (TYPE prescriber_state_rec_t)
        @prescr_state_id             BIGINT,
        @fk_id_nhin_prescriber       BIGINT,
        @state                       VARCHAR(2),
        @state_license_id            VARCHAR(50),
        
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
        -- Extract 3-Path State License Processing
        -- ===================================================================

        -- Path 1: Licensing state 1 (licensing_state_1, state_license_1)
        -- Path 2: Licensing state 2 (licensing_state_2, state_license_2)
        -- Path 3: Licensing state 3 (licensing_state_3, state_license_3)
        -- 
        -- UNION ALL 3 paths for efficiency (vs 3 nested loops in Oracle)
        -- PARTITION BY: (hcid, state, state_license) per path
        -- WHERE: state IS NOT NULL AND state_license_id IS NOT NULL
        -- WHERE: rn = 1 (first occurrence only)
        -- ===================================================================

        SET @error_loc = 1;

        DECLARE state_cursor CURSOR LOCAL FORWARD_ONLY FOR
            SELECT hcid_identifier, licensing_state_1 AS licensing_state, state_license_1 AS state_license_id
              FROM (
                SELECT xt.hcid_identifier,
                       xt.licensing_state_1,
                       xt.state_license_1,
                       ROW_NUMBER() OVER (
                           PARTITION BY xt.hcid_identifier,
                                        xt.licensing_state_1,
                                        xt.state_license_1
                           ORDER BY xt.DATA_SUPPLIER_REF_KEY_1
                       ) AS rn
                  FROM ESCRIBE.HCI_prescriber_source_data_xt xt
                 WHERE xt.phys_country_code  IS NOT NULL
                   AND xt.licensing_state_1  IS NOT NULL
                   AND xt.state_license_1    IS NOT NULL
               ) sub1
             WHERE rn = 1
            
            UNION ALL
            
            SELECT hcid_identifier, licensing_state_2, state_license_2
              FROM (
                SELECT xt.hcid_identifier,
                       xt.licensing_state_2,
                       xt.state_license_2,
                       ROW_NUMBER() OVER (
                           PARTITION BY xt.hcid_identifier,
                                        xt.licensing_state_2,
                                        xt.state_license_2
                           ORDER BY xt.DATA_SUPPLIER_REF_KEY_1
                       ) AS rn
                  FROM ESCRIBE.HCI_prescriber_source_data_xt xt
                 WHERE xt.phys_country_code  IS NOT NULL
                   AND xt.licensing_state_2  IS NOT NULL
                   AND xt.state_license_2    IS NOT NULL
               ) sub2
             WHERE rn = 1
            
            UNION ALL
            
            SELECT hcid_identifier, licensing_state_3, state_license_3
              FROM (
                SELECT xt.hcid_identifier,
                       xt.licensing_state_3,
                       xt.state_license_3,
                       ROW_NUMBER() OVER (
                           PARTITION BY xt.hcid_identifier,
                                        xt.licensing_state_3,
                                        xt.state_license_3
                           ORDER BY xt.DATA_SUPPLIER_REF_KEY_1
                       ) AS rn
                  FROM ESCRIBE.HCI_prescriber_source_data_xt xt
                 WHERE xt.phys_country_code  IS NOT NULL
                   AND xt.licensing_state_3  IS NOT NULL
                   AND xt.state_license_3    IS NOT NULL
               ) sub3
             WHERE rn = 1
            
            ORDER BY hcid_identifier, licensing_state, state_license_id;

        OPEN state_cursor;

        WHILE 1 = 1
        BEGIN
            -- Fetch next state license combination (from any of 3 paths)
            FETCH state_cursor INTO @rec_hcid_identifier, @state, @state_license_id;
            
            IF @@FETCH_STATUS <> 0
                BREAK;

            -- -------------------------------------------------------
            -- Lookup Prescriber table ID primary key value
            -- for the Prescriber State table prescriber FK
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
            -- Build output record from Prescriber State
            -- Sequence generator
            -- -------------------------------------------------------
            SET @error_loc = 3;

            SET @prescr_state_id = NEXT VALUE FOR ESCRIBE.PRESCR_STATE_ID_SEQ;

            -- -------------------------------------------------------
            -- Populate prescriber state record
            -- -------------------------------------------------------
            SET @error_loc = 4;

            INSERT INTO ESCRIBE.PRESCRIBER_STATE
                       (ID,
                        ID_NHIN_PRESCRIBER,
                        STATE,
                        STATE_LICENSE_ID
                       )
                VALUES (@prescr_state_id,
                        @fk_id_nhin_prescriber,
                        @state,
                        @state_license_id
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
                        'PRESCRIBER_STATE',
                        @prescr_state_id,
                        GETDATE()  -- CORRECTED: SYSDATE → GETDATE() (~3ms, matches Oracle)
                       );

        END;  -- End state_cursor loop

        CLOSE state_cursor;
        DEALLOCATE state_cursor;

        -- ===================================================================
        -- Finalization
        -- ===================================================================

        COMMIT;

    END TRY
    BEGIN CATCH

        -- ===================================================================
        -- Error Handling
        -- ===================================================================
        SET @error_msg = ERROR_MESSAGE() + ' in ESCRIBE.PRESCRIBER_STATE_TBL_INS_P at location (' +
                         CAST(@error_loc AS VARCHAR(10)) + ')';
        
        IF @@TRANCOUNT > 0
            ROLLBACK;
        
        THROW 50001, @error_msg, 1;

    END CATCH;

END;  -- End procedure PRESCRIBER_STATE_TBL_INS_P
GO

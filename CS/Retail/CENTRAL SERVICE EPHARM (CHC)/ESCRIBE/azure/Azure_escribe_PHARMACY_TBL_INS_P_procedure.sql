CREATE OR ALTER PROCEDURE ESCRIBE.PHARMACY_TBL_INS_P
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
        @pharmacy_id               BIGINT,
        @ncpdp_number              BIGINT,
        @id_address                BIGINT,
        @pharmacy_name             VARCHAR(255),
        @store_number              VARCHAR(50),
        @id_mailing_address        BIGINT,
        @phone_number              BIGINT,
        @fax_phone                 BIGINT,
        @open_24_hour              VARCHAR(1),
        @state_tax_id              VARCHAR(50),
        @federal_tax_id            VARCHAR(50),
        @state_license_number      VARCHAR(50),
        @dispenser_class_code      VARCHAR(2),
        @dispenser_type_code_1     VARCHAR(2),
        @pharmacy_hours            VARCHAR(255),
        @audit_dates_id            BIGINT,
        @audit_table_class_name    VARCHAR(255),
        @audit_table_row_id        BIGINT,
        @audit_system_create_date  DATETIME2,
        @error_loc                 INT = 0,
        @error_msg                 VARCHAR(2000),
        @rec_ncpdp_provider_num    VARCHAR(50),
        @rec_name                  VARCHAR(255),
        @rec_store_num             VARCHAR(50),
        @rec_phone_num             VARCHAR(20),
        @rec_fax_num               VARCHAR(20),
        @rec_open_24_hour          VARCHAR(1),
        @rec_state_tax_id          VARCHAR(50),
        @rec_federal_tax_id        VARCHAR(50),
        @rec_state_license_num     VARCHAR(50),
        @rec_dispenser_class       VARCHAR(3),
        @rec_dispenser_type        VARCHAR(3),
        @rec_provider_hours        VARCHAR(255),
        @rec_address_1             VARCHAR(255),
        @rec_address_2             VARCHAR(255),
        @rec_city                  VARCHAR(255),
        @rec_state_code            VARCHAR(2),
        @rec_zip_code              VARCHAR(9),
        @rec_mailing_address_1     VARCHAR(255),
        @rec_mailing_address_2     VARCHAR(255),
        @rec_mailing_city          VARCHAR(255),
        @rec_mailing_state_code    VARCHAR(2),
        @rec_mailing_zip_code      VARCHAR(9);

    DECLARE pharmacy_cursor CURSOR LOCAL FORWARD_ONLY FOR
    SELECT ncpdp_provider_num, name, store_num, phone_num, fax_num, open_24_hour, state_tax_id, federal_tax_id, 
           state_license_num, dispenser_class_code, dispenser_type_code, provider_hours, address_1, address_2, 
           city, state_code, zip_code, mailing_address_1, mailing_address_2, mailing_address_city, 
           mailing_address_state_code, mailing_address_zip_code
      FROM (
        SELECT xt.ncpdp_provider_num AS ncpdp_provider_num,
               xt.name AS name,
               xt.store_num AS store_num,
               xt.phone_num AS phone_num,
               xt.fax_num AS fax_num,
               xt.open_24_hour AS open_24_hour,
               xt.state_tax_id AS state_tax_id,
               xt.federal_tax_id AS federal_tax_id,
               xt.state_license_num AS state_license_num,
               xt.dispenser_class_code AS dispenser_class_code,
               xt.PRIMARY_DISPENSER_TYPE_CODE AS dispenser_type_code,
               xt.provider_hours AS provider_hours,
               xt.address_1 AS address_1,
               xt.address_2 AS address_2,
               xt.city AS city,
               xt.state_code AS state_code,
               xt.zip_code AS zip_code,
               xt.mailing_address_1 AS mailing_address_1,
               xt.mailing_address_2 AS mailing_address_2,
               xt.mailing_address_city AS mailing_address_city,
               xt.mailing_address_state_code AS mailing_address_state_code,
               xt.mailing_address_zip_code AS mailing_address_zip_code,
               ROW_NUMBER() OVER (PARTITION BY xt.ncpdp_provider_num ORDER BY xt.NCPDP_PROVIDER_NUM) AS rn
          FROM ESCRIBE.NCPDP_pharmacy_source_data_xt xt
      ) pharmacy_dedup
     WHERE rn = 1
     ORDER BY ncpdp_provider_num;

    BEGIN TRY
        BEGIN TRANSACTION;
        SET @error_loc = 1;
        OPEN pharmacy_cursor;

        WHILE 1 = 1
        BEGIN
            FETCH pharmacy_cursor INTO
                @rec_ncpdp_provider_num, @rec_name, @rec_store_num, @rec_phone_num, @rec_fax_num, @rec_open_24_hour,
                @rec_state_tax_id, @rec_federal_tax_id, @rec_state_license_num, @rec_dispenser_class, @rec_dispenser_type,
                @rec_provider_hours, @rec_address_1, @rec_address_2, @rec_city, @rec_state_code, @rec_zip_code,
                @rec_mailing_address_1, @rec_mailing_address_2, @rec_mailing_city, @rec_mailing_state_code, @rec_mailing_zip_code;
            
            IF @@FETCH_STATUS <> 0 BREAK;

            SET @error_loc = 2;
            SET @id_address = NULL;
            SET @id_mailing_address = NULL;

            SET @error_loc = 3;
            SELECT @id_address = id FROM ESCRIBE.ADDRESS
            WHERE address_line_1 = @rec_address_1
              AND city = @rec_city
              AND state = @rec_state_code
              AND zip_code = @rec_zip_code;

            SET @error_loc = 4;
            IF @rec_mailing_address_1 IS NOT NULL
            BEGIN
                SELECT @id_mailing_address = id FROM ESCRIBE.ADDRESS
                WHERE address_line_1 = @rec_mailing_address_1
                  AND city = @rec_mailing_city
                  AND state = @rec_mailing_state_code
                  AND zip_code = @rec_mailing_zip_code;
            END
            ELSE
            BEGIN
                SET @id_mailing_address = NULL;
            END;

            SET @error_loc = 5;
            SET @pharmacy_id = NEXT VALUE FOR ESCRIBE.PHARMACY_ID_SEQ;
            SET @ncpdp_number = CAST(@rec_ncpdp_provider_num AS BIGINT);
            SET @phone_number = CASE WHEN @rec_phone_num IS NOT NULL THEN CAST(@rec_phone_num AS BIGINT) ELSE NULL END;
            SET @fax_phone = CASE WHEN @rec_fax_num IS NOT NULL THEN CAST(@rec_fax_num AS BIGINT) ELSE NULL END;
            SET @dispenser_class_code = SUBSTRING(@rec_dispenser_class, 1, 2);
            SET @dispenser_type_code_1 = SUBSTRING(@rec_dispenser_type, 1, 2);
            SET @pharmacy_name = @rec_name;
            SET @store_number = @rec_store_num;
            SET @open_24_hour = @rec_open_24_hour;
            SET @state_tax_id = @rec_state_tax_id;
            SET @federal_tax_id = @rec_federal_tax_id;
            SET @state_license_number = @rec_state_license_num;
            SET @pharmacy_hours = @rec_provider_hours;

            SET @error_loc = 6;
            INSERT INTO ESCRIBE.PHARMACY (ID, NCPDP_NUMBER, ID_ADDRESS, PHARMACY_NAME, STORE_NUMBER, ID_MAILING_ADDRESS, 
                       PHONE_NUMBER, FAX_PHONE, OPEN_24_HOUR, STATE_TAX_ID, FEDERAL_TAX_ID, STATE_LICENSE_NUMBER, 
                       DISPENSER_CLASS_CODE, DISPENSER_TYPE_CODE_1, PHARMACY_HOURS)
                VALUES (@pharmacy_id, @ncpdp_number, @id_address, @pharmacy_name, @store_number, @id_mailing_address, 
                        @phone_number, @fax_phone, @open_24_hour, @state_tax_id, @federal_tax_id, @state_license_number, 
                        @dispenser_class_code, @dispenser_type_code_1, @pharmacy_hours);

            SET @error_loc = 7;
            SET @audit_dates_id = NEXT VALUE FOR ESCRIBE.AUDIT_DATES_ID_SEQ;
            INSERT INTO ESCRIBE.AUDIT_DATES (ID, TABLE_CLASS_NAME, TABLE_ROW_ID, SYSTEM_CREATE_DATE)
                VALUES (@audit_dates_id, 'PHARMACY', @pharmacy_id, GETDATE());

        END;

        CLOSE pharmacy_cursor;
        DEALLOCATE pharmacy_cursor;
        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        SET @error_msg = ERROR_MESSAGE() + ' in ESCRIBE.PHARMACY_TBL_INS_P at location (' +
                         CAST(@error_loc AS VARCHAR(10)) + ')';
        
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        RAISERROR(@error_msg,16,1);

    END CATCH

    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

END;
GO

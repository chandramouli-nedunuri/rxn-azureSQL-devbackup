CREATE OR REPLACE PROCEDURE         ESCRIBE.NHIN_CLINIC_TBL_INS_P IS

CURSOR add_cur1 (add_line1 VARCHAR2,
                 add_line2 VARCHAR2,
                 suite_num VARCHAR2,
                 mail_stop VARCHAR2,
                 city_name VARCHAR2,
                 state_nam VARCHAR2,
                 zip_zone  VARCHAR2,
                 cntry_cod VARCHAR2
                )
    IS SELECT id
         FROM escribe.address
        WHERE address_line_1       = add_line1
          AND address_line_2       = add_line2||suite_num
          AND department_mail_stop = mail_stop
          AND city                 = city_name
          AND state                = state_nam
          AND zip_code             = zip_zone
          AND country              = cntry_cod
        ORDER BY
              address_line_1,
              address_line_2,
              department_mail_stop,
              city,
              zip_code,
              country;

CURSOR add_cur2 (add_line1 VARCHAR2,
                 add_line2 VARCHAR2,
                 suite_num VARCHAR2,
                 city_name VARCHAR2,
                 state_nam VARCHAR2,
                 zip_zone  VARCHAR2,
                 cntry_cod VARCHAR2
                )
    IS SELECT id
         FROM escribe.address
        WHERE address_line_1       = add_line1
          AND address_line_2       = add_line2||suite_num
          AND department_mail_stop IS NULL
          AND city                 = city_name
          AND state                = state_nam
          AND zip_code             = zip_zone
          AND country              = cntry_cod
        ORDER BY
              address_line_1,
              address_line_2,
              department_mail_stop,
              city,
              zip_code,
              country;

CURSOR add_cur3 (add_line1 VARCHAR2,
                 mail_stop VARCHAR2,
                 city_name VARCHAR2,
                 state_nam VARCHAR2,
                 zip_zone  VARCHAR2,
                 cntry_cod VARCHAR2
                )
    IS SELECT id
         FROM escribe.address
        WHERE address_line_1       = add_line1
          AND address_line_2       IS NULL
          AND department_mail_stop = mail_stop
          AND city                 = city_name
          AND state                = state_nam
          AND zip_code             = zip_zone
          AND country              = cntry_cod
        ORDER BY
              address_line_1,
              address_line_2,
              department_mail_stop,
              city,
              zip_code,
              country;

CURSOR add_cur4 (add_line1 VARCHAR2,
                 city_name VARCHAR2,
                 state_nam VARCHAR2,
                 zip_zone  VARCHAR2,
                 cntry_cod VARCHAR2
                )
    IS SELECT id
         FROM escribe.address
        WHERE address_line_1       = add_line1
          AND address_line_2       IS NULL
          AND department_mail_stop IS NULL
          AND city                 = city_name
          AND state                = state_nam
          AND zip_code             = zip_zone
          AND country              = cntry_cod
        ORDER BY
              address_line_1,
              address_line_2,
              department_mail_stop,
              city,
              zip_code,
              country;

TYPE nhin_clinic_rec_t  IS RECORD
    (id                    escribe.nhin_clinic.id%TYPE,
     nhin_com_clinic_id    escribe.nhin_clinic.nhin_com_clinic_id%TYPE,
     id_address            escribe.nhin_clinic.id_address%TYPE,
     office_phone_1        escribe.nhin_clinic.office_phone_1%TYPE,
     office_phone_2        escribe.nhin_clinic.office_phone_2%TYPE,
     refill_phone          escribe.nhin_clinic.refill_phone%TYPE,
     hin                   escribe.nhin_clinic.hin%TYPE,
     department_mail_stop  escribe.nhin_clinic.department_mail_stop%TYPE,
     clinic_name           escribe.nhin_clinic.clinic_name%TYPE
    );

TYPE audit_dates_rec_t  IS RECORD
    (table_class_name      escribe.audit_dates.table_class_name%TYPE,
     table_row_id          escribe.audit_dates.table_row_id%TYPE,
     system_create_date    escribe.audit_dates.system_create_date%TYPE
    );

audit_dates_rec            audit_dates_rec_t;

nhin_clinic_rec            nhin_clinic_rec_t;
nhin_clinic_id             NUMBER;
nhin_clinic_com_clnc_id    NUMBER;
nhin_clinic_id_address     NUMBER;
audit_dates_id             NUMBER;

error_loc                  NUMBER;
error_msg                  VARCHAR2(2000);

e_custom_exception         EXCEPTION;
  PRAGMA exception_init(e_custom_exception, -20001);

BEGIN

     /*-----------------------------------------------------*
      | Select DISTINCT Clinic from Prescriber source file. |
      *-----------------------------------------------------*/
      error_loc := 1;

      FOR rec IN  (SELECT organization_name,
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
                     FROM (SELECT xt.*, ROW_NUMBER() OVER
                                       (PARTITION BY organization_name,
                                                     phys_address_line_1,
                                                     phys_address_line_2,
                                                     phys_suite_apartment_num,
                                                     department_mail_stop,
                                                     phys_city_name,
                                                     phys_state_province_code,
                                                     phys_zip_postal_zone,
                                                     phys_country_code
                                                     ORDER BY ROWID
                                       ) rn
                             FROM escribe.HCI_prescriber_source_data_xt xt
                            WHERE phys_country_code        IS NOT NULL
                              AND phys_address_line_1      IS NOT NULL
                              AND phys_city_name           IS NOT NULL
                              AND phys_state_province_code IS NOT NULL
                              AND phys_zip_postal_zone     IS NOT NULL
                          )
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
                          phys_country_code
                  )

      LOOP
           error_loc := 2;

           /*----------------------------------------------------------*
            | Lookup Address table ID primary key value for the clinic |
            |        table id_address foreign key column.              |
            *----------------------------------------------------------*/
           CASE
                WHEN
                     rec.phys_address_line_2||
                     rec.phys_suite_apartment_num IS NOT NULL AND
                     rec.department_mail_stop     IS NOT NULL
                     THEN
                          IF add_cur1%ISOPEN = TRUE
                             THEN
                                  CLOSE add_cur1;
                          END IF;

                          OPEN add_cur1(rec.phys_address_line_1,
                                        rec.phys_address_line_2,
                                        rec.phys_suite_apartment_num,
                                        rec.department_mail_stop,
                                        rec.phys_city_name,
                                        rec.phys_state_province_code,
                                        rec.phys_zip_postal_zone,
                                        rec.phys_country_code
                                       );

                WHEN
                     rec.phys_address_line_2||
                     rec.phys_suite_apartment_num IS NOT NULL AND
                     rec.department_mail_stop     IS     NULL
                     THEN
                          IF add_cur2%ISOPEN = TRUE
                             THEN
                                  CLOSE add_cur2;
                          END IF;

                          OPEN add_cur2(rec.phys_address_line_1,
                                        rec.phys_address_line_2,
                                        rec.phys_suite_apartment_num,
                                        rec.phys_city_name,
                                        rec.phys_state_province_code,
                                        rec.phys_zip_postal_zone,
                                        rec.phys_country_code
                                       );

                WHEN
                     rec.phys_address_line_2||
                     rec.phys_suite_apartment_num IS     NULL AND
                     rec.department_mail_stop     IS NOT NULL
                     THEN
                          IF add_cur3%ISOPEN = TRUE
                             THEN
                                  CLOSE add_cur3;
                          END IF;

                          OPEN add_cur3(rec.phys_address_line_1,
                                        rec.department_mail_stop,
                                        rec.phys_city_name,
                                        rec.phys_state_province_code,
                                        rec.phys_zip_postal_zone,
                                        rec.phys_country_code
                                       );

                ELSE
                          IF add_cur4%ISOPEN = TRUE
                             THEN
                                  CLOSE add_cur4;
                          END IF;

                          OPEN add_cur4(rec.phys_address_line_1,
                                        rec.phys_city_name,
                                        rec.phys_state_province_code,
                                        rec.phys_zip_postal_zone,
                                        rec.phys_country_code
                                       );
           END CASE;

           <<inner>>
           LOOP
                /*---------------------------------------------------------*
                 | If the Address table has no matching row, then by-pass  |
                 | the remainder of the process to build and insert a row. |
                 *---------------------------------------------------------*/
                error_loc := 3;

                CASE
                     WHEN
                          rec.phys_address_line_2||
                          rec.phys_suite_apartment_num IS NOT NULL AND
                          rec.department_mail_stop     IS NOT NULL
                          THEN
                               FETCH add_cur1 INTO nhin_clinic_id_address;

                                     EXIT inner WHEN add_cur1%NOTFOUND;
                     WHEN
                          rec.phys_address_line_2||
                          rec.phys_suite_apartment_num IS NOT NULL AND
                          rec.department_mail_stop     IS     NULL
                          THEN
                               FETCH add_cur2 INTO nhin_clinic_id_address;

                                     EXIT inner WHEN add_cur2%NOTFOUND;
                     WHEN
                          rec.phys_address_line_2||
                          rec.phys_suite_apartment_num IS     NULL AND
                          rec.department_mail_stop     IS NOT NULL
                          THEN
                               FETCH add_cur3 INTO nhin_clinic_id_address;

                                     EXIT inner WHEN add_cur3%NOTFOUND;
                     ELSE
                               FETCH add_cur4 INTO nhin_clinic_id_address;

                                     EXIT inner WHEN add_cur4%NOTFOUND;

                END CASE;

                /*----------------------------------------------------*
                 | Build output record from Clinic Sequence generator |
                 |   and from NHIN_com_clinic_id Sequence generator   |
                 *----------------------------------------------------*/
                error_loc := 4;

                SELECT nhin_clinic_id_seq.NEXTVAL
                  INTO nhin_clinic_id
                  FROM dual;

                SELECT nhin_clinic_com_clinic_id_seq.NEXTVAL
                  INTO nhin_clinic_com_clnc_id
                  FROM dual;

                error_loc := 5;

                nhin_clinic_rec.id                   := nhin_clinic_id;
                nhin_clinic_rec.nhin_com_clinic_id   := nhin_clinic_com_clnc_id;
                nhin_clinic_rec.id_address           := nhin_clinic_id_address;

                nhin_clinic_rec.office_phone_1       := rec.prime_phone_num;
                nhin_clinic_rec.office_phone_2       := rec.second_phone_num;
                nhin_clinic_rec.refill_phone         := rec.refill_phone_num;
                nhin_clinic_rec.hin                  := rec.hin_num;
                nhin_clinic_rec.department_mail_stop := rec.department_mail_stop;
                nhin_clinic_rec.clinic_name          := rec.organization_name;

                error_loc := 6;

                INSERT INTO escribe.nhin_clinic
                           (id,
                            nhin_com_clinic_id,
                            id_address,
                            office_phone_1,
                            office_phone_2,
                            refill_phone,
                            hin,
                            department_mail_stop,
                            clinic_name
                           )
                    VALUES (nhin_clinic_rec.id,
                            nhin_clinic_rec.nhin_com_clinic_id,
                            nhin_clinic_rec.id_address,
                            nhin_clinic_rec.office_phone_1,
                            nhin_clinic_rec.office_phone_2,
                            nhin_clinic_rec.refill_phone,
                            nhin_clinic_rec.hin,
                            nhin_clinic_rec.department_mail_stop,
                            nhin_clinic_rec.clinic_name
                           );

                error_loc := 7;

                SELECT audit_dates_id_seq.NEXTVAL
                  INTO audit_dates_id
                  FROM dual;

                INSERT INTO escribe.audit_dates
                           (id,
                            table_class_name,
                            table_row_id,
                            system_create_date
                           )
                    VALUES (audit_dates_id,
                            'NHIN_CLINIC',
                            nhin_clinic_rec.id,
                            SYSDATE
                           );


           END LOOP inner;

      END LOOP;

      COMMIT;

      error_loc := 12;

     /*----------------------------------------------*
      | Display the escribe.nhin_clinic table count. |
      *----------------------------------------------*/
--       DBMS_OUTPUT.put_line (TABCOUNT ('escribe', 'nhin_clinic'));

EXCEPTION

WHEN OTHERS THEN
     error_msg := SQLERRM||' in escribe.nhin_clinic_tbl_ins_p at'||
                  ' location ('||TO_CHAR(error_loc)||')';
     raise_application_error(-20001,error_msg);

/*-------------------------------------------------------------------*
 *                          End of Procedure                         *
 *-------------------------------------------------------------------*/
END nhin_clinic_tbl_ins_p;
/
CREATE OR REPLACE PROCEDURE         ESCRIBE.NHIN_PRESCR_CLNC_LNK_TBL_INS_P IS

CURSOR cln_cur1 (clin_name VARCHAR2,
                 add_line1 VARCHAR2,
                 add_line2 VARCHAR2,
                 suite_num VARCHAR2,
                 mail_stop VARCHAR2,
                 city_name VARCHAR2,
                 state_nam VARCHAR2,
                 zip_zone  VARCHAR2,
                 cntry_cod VARCHAR2
                )
    IS SELECT c.id
         FROM escribe.nhin_clinic c,
              escribe.address     a
        WHERE c.id_address           = a.id
          AND c.clinic_name          = clin_name
          AND a.address_line_1       = add_line1
          AND a.address_line_2       = add_line2||suite_num
          AND a.department_mail_stop = mail_stop
          AND a.city                 = city_name
          AND a.state                = state_nam
          AND a.zip_code             = zip_zone
          AND a.country              = cntry_cod
        ORDER BY
              c.clinic_name,
              a.address_line_1,
              a.address_line_2,
              a.department_mail_stop,
              a.city,
              a.zip_code,
              a.country;

CURSOR cln_cur2 (clin_name VARCHAR2,
                 add_line1 VARCHAR2,
                 add_line2 VARCHAR2,
                 suite_num VARCHAR2,
                 city_name VARCHAR2,
                 state_nam VARCHAR2,
                 zip_zone  VARCHAR2,
                 cntry_cod VARCHAR2
                )
    IS SELECT c.id
         FROM escribe.nhin_clinic c,
              escribe.address     a
        WHERE c.id_address           = a.id
          AND c.clinic_name          = clin_name
          AND a.address_line_1       = add_line1
          AND a.address_line_2       = add_line2||suite_num
          AND a.department_mail_stop IS NULL
          AND a.city                 = city_name
          AND a.state                = state_nam
          AND a.zip_code             = zip_zone
          AND a.country              = cntry_cod
        ORDER BY
              c.clinic_name,
              a.address_line_1,
              a.address_line_2,
              a.department_mail_stop,
              a.city,
              a.zip_code,
              a.country;

CURSOR cln_cur3 (clin_name VARCHAR2,
                 add_line1 VARCHAR2,
                 mail_stop VARCHAR2,
                 city_name VARCHAR2,
                 state_nam VARCHAR2,
                 zip_zone  VARCHAR2,
                 cntry_cod VARCHAR2
                )
    IS SELECT c.id
         FROM escribe.nhin_clinic c,
              escribe.address     a
        WHERE c.id_address           = a.id
          AND c.clinic_name          = clin_name
          AND a.address_line_1       = add_line1
          AND a.address_line_2       IS NULL
          AND a.department_mail_stop = mail_stop
          AND a.city                 = city_name
          AND a.state                = state_nam
          AND a.zip_code             = zip_zone
          AND a.country              = cntry_cod
        ORDER BY
              c.clinic_name,
              a.address_line_1,
              a.address_line_2,
              a.department_mail_stop,
              a.city,
              a.zip_code,
              a.country;

CURSOR cln_cur4 (clin_name VARCHAR2,
                 add_line1 VARCHAR2,
                 city_name VARCHAR2,
                 state_nam VARCHAR2,
                 zip_zone  VARCHAR2,
                 cntry_cod VARCHAR2
                )
    IS SELECT c.id
         FROM escribe.nhin_clinic c,
              escribe.address     a
        WHERE c.id_address           = a.id
          AND c.clinic_name          = clin_name
          AND a.address_line_1       = add_line1
          AND a.address_line_2       IS NULL
          AND a.department_mail_stop IS NULL
          AND a.city                 = city_name
          AND a.state                = state_nam
          AND a.zip_code             = zip_zone
          AND a.country              = cntry_cod
        ORDER BY
              c.clinic_name,
              a.address_line_1,
              a.address_line_2,
              a.department_mail_stop,
              a.city,
              a.zip_code,
              a.country;

CURSOR cln_cur5 (add_line1 VARCHAR2,
                 add_line2 VARCHAR2,
                 suite_num VARCHAR2,
                 mail_stop VARCHAR2,
                 city_name VARCHAR2,
                 state_nam VARCHAR2,
                 zip_zone  VARCHAR2,
                 cntry_cod VARCHAR2
                )
    IS SELECT c.id
         FROM escribe.nhin_clinic c,
              escribe.address     a
        WHERE c.id_address           = a.id
          AND c.clinic_name          IS NULL
          AND a.address_line_1       = add_line1
          AND a.address_line_2       = add_line2||suite_num
          AND a.department_mail_stop = mail_stop
          AND a.city                 = city_name
          AND a.state                = state_nam
          AND a.zip_code             = zip_zone
          AND a.country              = cntry_cod
        ORDER BY
              c.clinic_name,
              a.address_line_1,
              a.address_line_2,
              a.department_mail_stop,
              a.city,
              a.zip_code,
              a.country;

CURSOR cln_cur6 (add_line1 VARCHAR2,
                 add_line2 VARCHAR2,
                 suite_num VARCHAR2,
                 city_name VARCHAR2,
                 state_nam VARCHAR2,
                 zip_zone  VARCHAR2,
                 cntry_cod VARCHAR2
                )
    IS SELECT c.id
         FROM escribe.nhin_clinic c,
              escribe.address     a
        WHERE c.id_address           = a.id
          AND c.clinic_name          IS NULL
          AND a.address_line_1       = add_line1
          AND a.address_line_2       = add_line2||suite_num
          AND a.department_mail_stop IS NULL
          AND a.city                 = city_name
          AND a.state                = state_nam
          AND a.zip_code             = zip_zone
          AND a.country              = cntry_cod
        ORDER BY
              c.clinic_name,
              a.address_line_1,
              a.address_line_2,
              a.department_mail_stop,
              a.city,
              a.zip_code,
              a.country;

CURSOR cln_cur7 (add_line1 VARCHAR2,
                 mail_stop VARCHAR2,
                 city_name VARCHAR2,
                 state_nam VARCHAR2,
                 zip_zone  VARCHAR2,
                 cntry_cod VARCHAR2
                )
    IS SELECT c.id
         FROM escribe.nhin_clinic c,
              escribe.address     a
        WHERE c.id_address           = a.id
          AND c.clinic_name          IS NULL
          AND a.address_line_1       = add_line1
          AND a.address_line_2       IS NULL
          AND a.department_mail_stop = mail_stop
          AND a.city                 = city_name
          AND a.state                = state_nam
          AND a.zip_code             = zip_zone
          AND a.country              = cntry_cod
        ORDER BY
              c.clinic_name,
              a.address_line_1,
              a.address_line_2,
              a.department_mail_stop,
              a.city,
              a.zip_code,
              a.country;

CURSOR cln_cur8 (add_line1 VARCHAR2,
                 city_name VARCHAR2,
                 state_nam VARCHAR2,
                 zip_zone  VARCHAR2,
                 cntry_cod VARCHAR2
                )
    IS SELECT c.id
         FROM escribe.nhin_clinic c,
              escribe.address     a
        WHERE c.id_address           = a.id
          AND c.clinic_name          IS NULL
          AND a.address_line_1       = add_line1
          AND a.address_line_2       IS NULL
          AND a.department_mail_stop IS NULL
          AND a.city                 = city_name
          AND a.state                = state_nam
          AND a.zip_code             = zip_zone
          AND a.country              = cntry_cod
        ORDER BY
              c.clinic_name,
              a.address_line_1,
              a.address_line_2,
              a.department_mail_stop,
              a.city,
              a.zip_code,
              a.country;

CURSOR pre_cur (prescr_hcid VARCHAR2)
    IS SELECT id
         FROM escribe.nhin_prescriber
        WHERE hcid = prescr_hcid;

TYPE prescr_clnc_lnk_rec_t IS RECORD
    (id                    escribe.nhin_prescriber_clinic_link.id%TYPE,
     id_nhin_clinic        escribe.nhin_prescriber_clinic_link.id_nhin_clinic%TYPE,
     id_nhin_prescriber    escribe.nhin_prescriber_clinic_link.id_nhin_prescriber%TYPE,
     office_phone          escribe.nhin_prescriber_clinic_link.office_phone%TYPE,
     fax_phone             escribe.nhin_prescriber_clinic_link.fax_phone%TYPE,
     hcid                  escribe.nhin_prescriber_clinic_link.hcid%TYPE,
     hcidea_location       escribe.nhin_prescriber_clinic_link.hcidea_location%TYPE,
     hin                   escribe.nhin_prescriber_clinic_link.hin%TYPE,
     dea_id                escribe.nhin_prescriber_clinic_link.dea_id%TYPE
    );

TYPE audit_dates_rec_t  IS RECORD
    (table_class_name      escribe.audit_dates.table_class_name%TYPE,
     table_row_id          escribe.audit_dates.table_row_id%TYPE,
     system_create_date    escribe.audit_dates.system_create_date%TYPE
    );

audit_dates_rec            audit_dates_rec_t;

prescr_clnc_lnk_rec        prescr_clnc_lnk_rec_t;
prescr_clnc_lnk_id         NUMBER;
prescr_clnc_lnk_id_clinic  NUMBER;
prescr_clnc_lnk_id_prescr  NUMBER;
audit_dates_id             NUMBER;

error_loc                  NUMBER;
error_msg                  VARCHAR2(2000);

e_custom_exception         EXCEPTION;
  PRAGMA exception_init(e_custom_exception, -20001);

BEGIN

     /*-----------------------------------------------------*
      | Select DISTINCT Clinic from Prescriber source file. |
      *-----------------------------------------------------*/
      error_loc := 1;

      FOR rec IN  (SELECT organization_name,
                          hcid_identifier,
                          hcid_location_code,
                          phys_address_line_1,
                          phys_address_line_2,
                          phys_suite_apartment_num,
                          department_mail_stop,
                          phys_city_name,
                          phys_state_province_code,
                          phys_zip_postal_zone,
                          phys_country_code,
                          hin_num,
                          dea_registration_num,
                          prime_phone_num,
                          second_phone_num,
                          refill_phone_num,
                          fax_num
                     FROM (SELECT xt.*, ROW_NUMBER() OVER
                                       (PARTITION BY organization_name,
                                                     hcid_identifier,
                                                     hcid_location_code,
                                                     phys_address_line_1,
                                                     phys_address_line_2,
                                                     phys_suite_apartment_num,
                                                     department_mail_stop,
                                                     phys_city_name,
                                                     phys_state_province_code,
                                                     phys_zip_postal_zone,
                                                     phys_country_code
                                                     ORDER BY ROWID
                                       ) rn
                             FROM escribe.HCI_prescriber_source_data_xt xt
                            WHERE phys_country_code        IS NOT NULL
                              AND phys_address_line_1      IS NOT NULL
                              AND phys_city_name           IS NOT NULL
                              AND phys_state_province_code IS NOT NULL
                              AND phys_zip_postal_zone     IS NOT NULL
                          )
                    WHERE rn = 1
                    ORDER BY
                          organization_name,
                          hcid_identifier,
                          hcid_location_code,
                          phys_address_line_1,
                          phys_address_line_2,
                          phys_suite_apartment_num,
                          department_mail_stop,
                          phys_city_name,
                          phys_state_province_code,
                          phys_zip_postal_zone,
                          phys_country_code
                  )

      LOOP
           error_loc := 2;

           /*-----------------------------------------------------*
            | Select DISTINCT Clinic from Prescriber source file. |
            *-----------------------------------------------------*/
           IF pre_cur%ISOPEN = TRUE
              THEN
                   CLOSE pre_cur;
           END IF;

           /*---------------------------------------------------*
            | Lookup Prescriber table HCID value to acquire the |
            | Prescriber primary key to provide the Prescriber  |
            | foreign key.                                      |
            *---------------------------------------------------*/
           OPEN pre_cur(rec.hcid_identifier);

                /*-----------------------------------------------------------*
                 | If the Prescriber table has no matching row, then by-pass |
                 | the remainder of the process to build and insert a row.   |
                 *-----------------------------------------------------------*/
                FETCH pre_cur INTO prescr_clnc_lnk_id_prescr;

                      EXIT WHEN pre_cur%NOTFOUND;

           /*----------------------------------------------------------*
            | Lookup Address table ID primary key value for the clinic |
            |        table id_address foreign key column.              |
            *----------------------------------------------------------*/
           CASE
                WHEN
                     rec.organization_name        IS NOT NULL AND
                     rec.phys_address_line_2||
                     rec.phys_suite_apartment_num IS NOT NULL AND
                     rec.department_mail_stop     IS NOT NULL
                     THEN
                          IF cln_cur1%ISOPEN = TRUE
                             THEN
                                  CLOSE cln_cur1;
                          END IF;

                          OPEN cln_cur1(rec.organization_name,
                                        rec.phys_address_line_1,
                                        rec.phys_address_line_2,
                                        rec.phys_suite_apartment_num,
                                        rec.department_mail_stop,
                                        rec.phys_city_name,
                                        rec.phys_state_province_code,
                                        rec.phys_zip_postal_zone,
                                        rec.phys_country_code
                                       );

                WHEN
                     rec.organization_name        IS NOT NULL AND
                     rec.phys_address_line_2||
                     rec.phys_suite_apartment_num IS NOT NULL AND
                     rec.department_mail_stop     IS     NULL
                     THEN
                          IF cln_cur2%ISOPEN = TRUE
                             THEN
                                  CLOSE cln_cur2;
                          END IF;

                          OPEN cln_cur2(rec.organization_name,
                                        rec.phys_address_line_1,
                                        rec.phys_address_line_2,
                                        rec.phys_suite_apartment_num,
                                        rec.phys_city_name,
                                        rec.phys_state_province_code,
                                        rec.phys_zip_postal_zone,
                                        rec.phys_country_code
                                       );

                WHEN
                     rec.organization_name        IS NOT NULL AND
                     rec.phys_address_line_2||
                     rec.phys_suite_apartment_num IS     NULL AND
                     rec.department_mail_stop     IS NOT NULL
                     THEN
                          IF cln_cur3%ISOPEN = TRUE
                             THEN
                                  CLOSE cln_cur3;
                          END IF;

                          OPEN cln_cur3(rec.organization_name,
                                        rec.phys_address_line_1,
                                        rec.department_mail_stop,
                                        rec.phys_city_name,
                                        rec.phys_state_province_code,
                                        rec.phys_zip_postal_zone,
                                        rec.phys_country_code
                                       );

                WHEN
                     rec.organization_name        IS NOT NULL AND
                     rec.phys_address_line_2||
                     rec.phys_suite_apartment_num IS     NULL AND
                     rec.department_mail_stop     IS     NULL
                     THEN
                          IF cln_cur4%ISOPEN = TRUE
                             THEN
                                  CLOSE cln_cur4;
                          END IF;

                          OPEN cln_cur4(rec.organization_name,
                                        rec.phys_address_line_1,
                                        rec.phys_city_name,
                                        rec.phys_state_province_code,
                                        rec.phys_zip_postal_zone,
                                        rec.phys_country_code
                                       );
                WHEN
                     rec.organization_name        IS     NULL AND
                     rec.phys_address_line_2||
                     rec.phys_suite_apartment_num IS NOT NULL AND
                     rec.department_mail_stop     IS NOT NULL
                     THEN
                          IF cln_cur5%ISOPEN = TRUE
                             THEN
                                  CLOSE cln_cur5;
                          END IF;

                          OPEN cln_cur5(rec.phys_address_line_1,
                                        rec.phys_address_line_2,
                                        rec.phys_suite_apartment_num,
                                        rec.department_mail_stop,
                                        rec.phys_city_name,
                                        rec.phys_state_province_code,
                                        rec.phys_zip_postal_zone,
                                        rec.phys_country_code
                                       );

                WHEN
                     rec.organization_name        IS     NULL AND
                     rec.phys_address_line_2||
                     rec.phys_suite_apartment_num IS NOT NULL AND
                     rec.department_mail_stop     IS     NULL
                     THEN
                          IF cln_cur6%ISOPEN = TRUE
                             THEN
                                  CLOSE cln_cur6;
                          END IF;

                          OPEN cln_cur6(rec.phys_address_line_1,
                                        rec.phys_address_line_2,
                                        rec.phys_suite_apartment_num,
                                        rec.phys_city_name,
                                        rec.phys_state_province_code,
                                        rec.phys_zip_postal_zone,
                                        rec.phys_country_code
                                       );

                WHEN
                     rec.organization_name        IS     NULL AND
                     rec.phys_address_line_2||
                     rec.phys_suite_apartment_num IS     NULL AND
                     rec.department_mail_stop     IS NOT NULL
                     THEN
                          IF cln_cur7%ISOPEN = TRUE
                             THEN
                                  CLOSE cln_cur7;
                          END IF;

                          OPEN cln_cur7(rec.phys_address_line_1,
                                        rec.department_mail_stop,
                                        rec.phys_city_name,
                                        rec.phys_state_province_code,
                                        rec.phys_zip_postal_zone,
                                        rec.phys_country_code
                                       );

                ELSE
                          IF cln_cur8%ISOPEN = TRUE
                             THEN
                                  CLOSE cln_cur8;
                          END IF;

                          OPEN cln_cur8(rec.phys_address_line_1,
                                        rec.phys_city_name,
                                        rec.phys_state_province_code,
                                        rec.phys_zip_postal_zone,
                                        rec.phys_country_code
                                       );
           END CASE;

           <<inner>>
           LOOP
                /*---------------------------------------------------------*
                 | If the Address table has no matching row, then by-pass  |
                 | the remainder of the process to build and insert a row. |
                 *---------------------------------------------------------*/
                error_loc := 3;

                CASE
                     WHEN
                          rec.organization_name        IS NOT NULL AND
                          rec.phys_address_line_2||
                          rec.phys_suite_apartment_num IS NOT NULL AND
                          rec.department_mail_stop     IS NOT NULL
                          THEN
                               FETCH cln_cur1 INTO prescr_clnc_lnk_id_clinic;

                                     EXIT inner WHEN cln_cur1%NOTFOUND;

                     WHEN
                          rec.organization_name        IS NOT NULL AND
                          rec.phys_address_line_2||
                          rec.phys_suite_apartment_num IS NOT NULL AND
                          rec.department_mail_stop     IS     NULL
                          THEN
                               FETCH cln_cur2 INTO prescr_clnc_lnk_id_clinic;

                                     EXIT inner WHEN cln_cur2%NOTFOUND;

                     WHEN
                          rec.organization_name        IS NOT NULL AND
                          rec.phys_address_line_2||
                          rec.phys_suite_apartment_num IS     NULL AND
                          rec.department_mail_stop     IS NOT NULL
                          THEN
                               FETCH cln_cur3 INTO prescr_clnc_lnk_id_clinic;

                                     EXIT inner WHEN cln_cur3%NOTFOUND;

                     WHEN
                          rec.organization_name        IS NOT NULL AND
                          rec.phys_address_line_2||
                          rec.phys_suite_apartment_num IS     NULL AND
                          rec.department_mail_stop     IS     NULL
                          THEN
                               FETCH cln_cur4 INTO prescr_clnc_lnk_id_clinic;

                                     EXIT inner WHEN cln_cur4%NOTFOUND;

                     WHEN
                          rec.organization_name        IS     NULL AND
                          rec.phys_address_line_2||
                          rec.phys_suite_apartment_num IS NOT NULL AND
                          rec.department_mail_stop     IS NOT NULL
                          THEN
                               FETCH cln_cur5 INTO prescr_clnc_lnk_id_clinic;

                                     EXIT inner WHEN cln_cur5%NOTFOUND;

                     WHEN
                          rec.organization_name        IS     NULL AND
                          rec.phys_address_line_2||
                          rec.phys_suite_apartment_num IS NOT NULL AND
                          rec.department_mail_stop     IS     NULL
                          THEN
                               FETCH cln_cur6 INTO prescr_clnc_lnk_id_clinic;

                                     EXIT inner WHEN cln_cur6%NOTFOUND;

                     WHEN
                          rec.organization_name        IS     NULL AND
                          rec.phys_address_line_2||
                          rec.phys_suite_apartment_num IS     NULL AND
                          rec.department_mail_stop     IS NOT NULL
                          THEN
                               FETCH cln_cur7 INTO prescr_clnc_lnk_id_clinic;

                                     EXIT inner WHEN cln_cur7%NOTFOUND;

                     ELSE
                               FETCH cln_cur8 INTO prescr_clnc_lnk_id_clinic;

                                     EXIT inner WHEN cln_cur8%NOTFOUND;

                END CASE;

                      /*----------------------------------------------------------*
                       | Build output record from Clinic Link Sequence generator. |
                       *----------------------------------------------------------*/
                      error_loc := 8;

                      SELECT nhin_prescr_clinic_link_id_seq.NEXTVAL
                        INTO prescr_clnc_lnk_id
                        FROM dual;

                      /*-------------------------------------------------------*
                       | If the Source Org Name does not match the Clinc Name, |
                       | then by-pass the remainder of the process.            |
                       *-------------------------------------------------------*/
                      error_loc := 9;

                      prescr_clnc_lnk_rec.id                 := prescr_clnc_lnk_id;
                      prescr_clnc_lnk_rec.id_nhin_clinic     := prescr_clnc_lnk_id_clinic;
                      prescr_clnc_lnk_rec.id_nhin_prescriber := prescr_clnc_lnk_id_prescr;

                      prescr_clnc_lnk_rec.office_phone       := rec.prime_phone_num;
                      prescr_clnc_lnk_rec.fax_phone          := rec.fax_num;
                      prescr_clnc_lnk_rec.hcid               := rec.hcid_identifier;
                      prescr_clnc_lnk_rec.hcidea_location    := rec.hcid_location_code;
                      prescr_clnc_lnk_rec.hin                := rec.hin_num;
                      prescr_clnc_lnk_rec.dea_id             := rec.dea_registration_num;

                      error_loc := 10;

                      INSERT INTO escribe.nhin_prescriber_clinic_link
                                 (id,
                                  id_nhin_clinic,
                                  id_nhin_prescriber,
                                  office_phone,
                                  fax_phone,
                                  hcid,
                                  hcidea_location,
                                  hin,
                                  dea_id
                                 )
                          VALUES (prescr_clnc_lnk_rec.id,
                                  prescr_clnc_lnk_rec.id_nhin_clinic,
                                  prescr_clnc_lnk_rec.id_nhin_prescriber,
                                  prescr_clnc_lnk_rec.office_phone,
                                  prescr_clnc_lnk_rec.fax_phone,
                                  prescr_clnc_lnk_rec.hcid,
                                  prescr_clnc_lnk_rec.hcidea_location,
                                  prescr_clnc_lnk_rec.hin,
                                  prescr_clnc_lnk_rec.dea_id
                                 );

                      error_loc := 7;

                      SELECT audit_dates_id_seq.NEXTVAL
                        INTO audit_dates_id
                        FROM dual;

                      INSERT INTO escribe.audit_dates
                                 (id,
                                  table_class_name,
                                  table_row_id,
                                  system_create_date
                                 )
                          VALUES (audit_dates_id,
                                  'NHIN_PRESCRIBER_CLINIC_LINK',
                                  prescr_clnc_lnk_rec.id,
                                  SYSDATE
                                 );

           END LOOP inner;

      END LOOP;

      COMMIT;

      error_loc := 12;

     /*--------------------------------------------------------------*
      | Display the escribe.nhin_prescriber_clinic_link table count. |
      *--------------------------------------------------------------*/
--       DBMS_OUTPUT.put_line (TABCOUNT ('escribe', 'nhin_prescriber_clinic_link'));

EXCEPTION

WHEN OTHERS THEN
     error_msg := SQLERRM||' in escribe.nhin_prescr_clnc_lnk_tbl_ins_p at'||
                  ' location ('||TO_CHAR(error_loc)||')';
     raise_application_error(-20001,error_msg);

/*-------------------------------------------------------------------*
 *                          End of Procedure                         *
 *-------------------------------------------------------------------*/
END nhin_prescr_clnc_lnk_tbl_ins_p;
/
CREATE OR REPLACE PROCEDURE         ESCRIBE.NHIN_PRESCRIBER_TBL_INS_P IS

TYPE prescriber_rec_t   IS RECORD
    (id                    escribe.nhin_prescriber.id%TYPE,
     nhin_com_id           escribe.nhin_prescriber.nhin_com_id%TYPE,
     last_name             escribe.nhin_prescriber.last_name%TYPE,
     first_name            escribe.nhin_prescriber.first_name%TYPE,
     middle_name           escribe.nhin_prescriber.middle_name%TYPE,
     hcid                  escribe.nhin_prescriber.hcid%TYPE,
     npi                   escribe.nhin_prescriber.npi%TYPE,
     dea_id                escribe.nhin_prescriber.dea_id%TYPE,
     dea_status_code       escribe.nhin_prescriber.dea_status_code%TYPE,
     gender                escribe.nhin_prescriber.gender%TYPE,
     nhin_retire           escribe.nhin_prescriber.nhin_retire%TYPE,
     nhin_deceased         escribe.nhin_prescriber.nhin_deceased%TYPE,
     probation             escribe.nhin_prescriber.probation%TYPE,
     degree_1              escribe.nhin_prescriber.degree_1%TYPE,
     degree_2              escribe.nhin_prescriber.degree_2%TYPE,
     upin                  escribe.nhin_prescriber.upin%TYPE,
     taxonomy_code_1       escribe.nhin_prescriber.taxonomy_code_1%TYPE,
     taxonomy_code_2       escribe.nhin_prescriber.taxonomy_code_2%TYPE,
     ncpdp_id              escribe.nhin_prescriber.ncpdp_id%TYPE,
     nhin_id               escribe.nhin_prescriber.nhin_id%TYPE,
     email_address         escribe.nhin_prescriber.email_address%TYPE
    );

TYPE audit_dates_rec_t  IS RECORD
    (table_class_name      escribe.audit_dates.table_class_name%TYPE,
     table_row_id          escribe.audit_dates.table_row_id%TYPE,
     system_create_date    escribe.audit_dates.system_create_date%TYPE
    );

audit_dates_rec            audit_dates_rec_t;

prescriber_rec             prescriber_rec_t;
prescriber_id              NUMBER;
prescr_nhin_com_id         NUMBER;
prescr_probation           VARCHAR2(1);
prescr_nhin_retire         DATE;
prescr_nhin_deceased       DATE;
prescr_gender              escribe.nhin_prescriber.gender%TYPE;
audit_dates_id             NUMBER;

error_loc                  NUMBER;
error_msg                  VARCHAR2(2000);

e_custom_exception         EXCEPTION;
  PRAGMA exception_init(e_custom_exception, -20001);

BEGIN

     /*----------------------------------------------------------*
      | Select DISTINCT Prescribers from Prescriber source file. |
      *----------------------------------------------------------*/
      error_loc := 1;

      FOR rec IN  (SELECT last_name,
                          first_name,
                          middle_name_initial,
                          hcid_identifier,
                          npi,
                          dea_registration_num,
                          dea_status_code,
                          gender_code,
                          retire_date,
                          nhin_deceased_date,
                          dea_drug_schedule,
                          prime_degree,
                          second_degree,
                          upin_num,
                          prime_taxonomy_code,
                          second_taxonomy_code,
                          ncpdp_provider_id_num,
                          nhin_provider_id,
                          email_address
                     FROM (SELECT xt.*, ROW_NUMBER() OVER
                                       (PARTITION BY last_name,
                                                     first_name,
                                                     middle_name_initial,
                                                     hcid_identifier
                                                     ORDER BY ROWID
                                       ) rn
                             FROM escribe.HCI_prescriber_source_data_xt xt
                            WHERE phys_country_code IS NOT NULL
                          )
                    WHERE rn = 1
                  )

      LOOP
           /*-----------------------------------------------------------*
            | Build output record from Prescriber Sequence generator    |
            |   and output record from Prescriber NHIN_com_id           |
            |   Sequence generator and Prescriber source data elements. |
            *-----------------------------------------------------------*/

           error_loc := 2;

           SELECT nhin_prescr_id_seq.NEXTVAL
             INTO prescriber_id
             FROM dual;

           SELECT nhin_prescr_nhin_com_id_seq.NEXTVAL
             INTO prescr_nhin_com_id
             FROM dual;

           /*---------------------------------------------------------*
            | Translate the source data DEA_drug_schedule information |
            |    to the appropriate Probation codes for PDX.          |
            *---------------------------------------------------------*/
           error_loc := 3;

           CASE
                WHEN rec.dea_drug_schedule     LIKE '%2%' THEN prescr_probation := NULL;
                WHEN rec.dea_drug_schedule NOT LIKE '%5%' THEN prescr_probation := '5';
                WHEN rec.dea_drug_schedule NOT LIKE '%4%' THEN prescr_probation := '4';
                WHEN rec.dea_drug_schedule NOT LIKE '%3%' THEN prescr_probation := '3';
                WHEN rec.dea_drug_schedule NOT LIKE '%2%' THEN prescr_probation := '2';
                ELSE prescr_probation := NULL;
           END CASE;

           error_loc := 4;

           CASE rec.retire_date
                WHEN 0    THEN prescr_nhin_retire   := NULL;
                WHEN NULL THEN prescr_nhin_retire   := NULL;
                ELSE prescr_nhin_retire     := TO_DATE(rec.retire_date,'YYYYMMDD');
           END CASE;

           error_loc := 5;

           CASE rec.nhin_deceased_date
                WHEN 0    THEN prescr_nhin_deceased := NULL;
                WHEN NULL THEN prescr_nhin_deceased := NULL;
                ELSE prescr_nhin_deceased   := TO_DATE(rec.nhin_deceased_date,'YYYYMMDD');
           END CASE;

           CASE rec.gender_code
                WHEN 'M'  THEN prescr_gender := rec.gender_code;
                WHEN 'F'  THEN prescr_gender := rec.gender_code;
                ELSE           prescr_gender := NULL;
           END CASE;

           prescriber_rec.id               := prescriber_id;
           prescriber_rec.nhin_com_id      := prescr_nhin_com_id;

           prescriber_rec.last_name        := rec.last_name;
           prescriber_rec.first_name       := rec.first_name;
           prescriber_rec.middle_name      := rec.middle_name_initial;
           prescriber_rec.hcid             := rec.hcid_identifier;
           prescriber_rec.npi              := rec.npi;
           prescriber_rec.dea_id           := rec.dea_registration_num;
           prescriber_rec.dea_status_code  := rec.dea_status_code;
           prescriber_rec.gender           := prescr_gender;
           prescriber_rec.nhin_retire      := prescr_nhin_retire;
           prescriber_rec.nhin_deceased    := prescr_nhin_deceased;
           prescriber_rec.probation        := prescr_probation;
           prescriber_rec.degree_1         := rec.prime_degree;
           prescriber_rec.degree_2         := rec.second_degree;
           prescriber_rec.upin             := rec.upin_num;
           prescriber_rec.taxonomy_code_1  := rec.prime_taxonomy_code;
           prescriber_rec.taxonomy_code_2  := rec.second_taxonomy_code;
           prescriber_rec.ncpdp_id         := rec.ncpdp_provider_id_num;
           prescriber_rec.nhin_id          := rec.nhin_provider_id;
           prescriber_rec.email_address    := rec.email_address;

           error_loc := 6;

           INSERT INTO escribe.nhin_prescriber
                      (id,
                       nhin_com_id,
                       last_name,
                       first_name,
                       middle_name,
                       hcid,
                       npi,
                       dea_id,
                       dea_status_code,
                       gender,
                       nhin_retire,
                       nhin_deceased,
                       probation,
                       degree_1,
                       degree_2,
                       upin,
                       taxonomy_code_1,
                       taxonomy_code_2,
                       ncpdp_id,
                       nhin_id,
                       email_address
                      )
               VALUES (prescriber_rec.id,
                       prescriber_rec.nhin_com_id,
                       prescriber_rec.last_name,
                       prescriber_rec.first_name,
                       prescriber_rec.middle_name,
                       prescriber_rec.hcid,
                       prescriber_rec.npi,
                       prescriber_rec.dea_id,
                       prescriber_rec.dea_status_code,
                       prescriber_rec.gender,
                       prescriber_rec.nhin_retire,
                       prescriber_rec.nhin_deceased,
                       prescriber_rec.probation,
                       prescriber_rec.degree_1,
                       prescriber_rec.degree_2,
                       prescriber_rec.upin,
                       prescriber_rec.taxonomy_code_1,
                       prescriber_rec.taxonomy_code_2,
                       prescriber_rec.ncpdp_id,
                       prescriber_rec.nhin_id,
                       prescriber_rec.email_address
                      );

           error_loc := 7;


           SELECT audit_dates_id_seq.NEXTVAL
             INTO audit_dates_id
             FROM dual;

           INSERT INTO escribe.audit_dates
                      (id,
                       table_class_name,
                       table_row_id,
                       system_create_date
                      )
               VALUES (audit_dates_id,
                       'NHIN_PRESCRIBER',
                       prescriber_rec.id,
                       SYSDATE
                      );

      END LOOP;

      COMMIT;

     /*--------------------------------------------------*
      | Display the escribe.nhin_prescriber table count. |
      *--------------------------------------------------*/
--       DBMS_OUTPUT.put_line (TABCOUNT ('escribe', 'nhin_prescriber'));

EXCEPTION

WHEN OTHERS THEN
     error_msg := SQLERRM||' in escribe.nhin_prescriber_tbl_ins_p at'||
                  ' location ('||TO_CHAR(error_loc)||')';
     raise_application_error(-20001,error_msg);

/*-------------------------------------------------------------------*
 *                          End of Procedure                         *
 *-------------------------------------------------------------------*/
END nhin_prescriber_tbl_ins_p;
/
CREATE OR REPLACE PROCEDURE         ESCRIBE.PHARM_MEDICAID_IDS_TBL_INS_P IS

CURSOR pharm_cur (ncpdp_num VARCHAR2)
    IS SELECT id
         FROM escribe.pharmacy
        WHERE ncpdp_number = ncpdp_num;

TYPE pharmacy_medicaid_ids_rec_t IS RECORD
    (id                    escribe.pharmacy_medicaid_ids.id%TYPE,
     id_pharmacy           escribe.pharmacy_medicaid_ids.id_pharmacy%TYPE,
     state_code            escribe.pharmacy_medicaid_ids.state_code%TYPE,
     medicaid_id           escribe.pharmacy_medicaid_ids.medicaid_id%TYPE
    );

TYPE audit_dates_rec_t  IS RECORD
    (table_class_name      escribe.audit_dates.table_class_name%TYPE,
     table_row_id          escribe.audit_dates.table_row_id%TYPE,
     system_create_date    escribe.audit_dates.system_create_date%TYPE
    );

audit_dates_rec            audit_dates_rec_t;

pharmacy_medicaid_ids_rec  pharmacy_medicaid_ids_rec_t;
pharmacy_medicaid_ids_id   NUMBER;
fk_id_pharmacy             NUMBER;
audit_dates_id             NUMBER;

error_loc                  NUMBER;
error_msg                  VARCHAR2(2000);

e_custom_exception         EXCEPTION;
  PRAGMA exception_init(e_custom_exception, -20001);

BEGIN

     /*--------------------------------------------------------*
      | Select DISTINCT Medicaid ID from Pharmacy source file. |
      *--------------------------------------------------------*/
      error_loc := 1;

      FOR rec IN  (SELECT ncpdp_provider_num,
                          state_code,
                          medicaid_id
                     FROM (SELECT xt.*, ROW_NUMBER() OVER
                                       (PARTITION BY ncpdp_provider_num,
                                                     state_code,
                                                     medicaid_id
                                                     ORDER BY ROWID
                                       ) rn
                             FROM escribe.NCPDP_pharmacy_source_data_xt xt
                            WHERE state_code  IS NOT NULL
                              AND medicaid_id IS NOT NULL
                          )
                    WHERE rn = 1
                  )

      LOOP
           error_loc := 2;

           IF pharm_cur%ISOPEN = TRUE
              THEN
                   CLOSE pharm_cur;
           END IF;

           /*-------------------------------------------------------------*
            | Lookup Pharmacy table ID primary key value for the Pharmacy |
            |        Medicaid ID table Pharmacy foreign key column.       |
            *-------------------------------------------------------------*/
           OPEN pharm_cur(rec.ncpdp_provider_num);

           LOOP
                /*---------------------------------------------------------*
                 | the remainder of the process to build and insert a row. |
                 *---------------------------------------------------------*/
                error_loc := 4;

                FETCH pharm_cur INTO fk_id_pharmacy;

                      EXIT WHEN pharm_cur%NOTFOUND;

                /*------------------------------------------------------------------*
                 | Build output record from Pharmacy Medicaid ID Sequence generator |
                 *------------------------------------------------------------------*/
                error_loc := 3;

                SELECT pharmacy_medicaid_ids_id_seq.NEXTVAL
                  INTO pharmacy_medicaid_ids_id
                  FROM dual;

                error_loc := 5;

                pharmacy_medicaid_ids_rec.id            := pharmacy_medicaid_ids_id;
                pharmacy_medicaid_ids_rec.id_pharmacy   := fk_id_pharmacy;

                pharmacy_medicaid_ids_rec.state_code    := rec.state_code;
                pharmacy_medicaid_ids_rec.medicaid_id   := rec.medicaid_id;

                error_loc := 6;

                INSERT INTO escribe.pharmacy_medicaid_ids
                           (id,
                            id_pharmacy,
                            state_code,
                            medicaid_id
                           )
                    VALUES (pharmacy_medicaid_ids_rec.id,
                            pharmacy_medicaid_ids_rec.id_pharmacy,
                            pharmacy_medicaid_ids_rec.state_code,
                            pharmacy_medicaid_ids_rec.medicaid_id
                           );

                error_loc := 7;

                SELECT audit_dates_id_seq.NEXTVAL
                  INTO audit_dates_id
                  FROM dual;

                INSERT INTO escribe.audit_dates
                           (id,
                            table_class_name,
                            table_row_id,
                            system_create_date
                           )
                    VALUES (audit_dates_id,
                            'PHARMACY_MEDICAID_IDS',
                            pharmacy_medicaid_ids_rec.id,
                            SYSDATE
                           );

           END LOOP;

      END LOOP;

      COMMIT;

     /*--------------------------------------------------------*
      | Display the escribe.pharmacy_medicaid_ids table count. |
      *--------------------------------------------------------*/
--       DBMS_OUTPUT.put_line (TABCOUNT ('escribe', 'pharmacy_medicaid_ids'));

EXCEPTION

WHEN OTHERS THEN
     error_msg := SQLERRM||' in escribe.pharm_medicaid_ids_tbl_ins_p at'||
                  ' location ('||TO_CHAR(error_loc)||')';
     raise_application_error(-20001,error_msg);

/*-------------------------------------------------------------------*
 *                          End of Procedure                         *
 *-------------------------------------------------------------------*/
END pharm_medicaid_ids_tbl_ins_p;
/
CREATE OR REPLACE PROCEDURE         ESCRIBE.PHARMACY_ADDRESS_TBL_INS_P IS

TYPE address_rec_t      IS RECORD
    (id                    escribe.address.id%TYPE,
     address_line_1        escribe.address.address_line_1%TYPE,
     address_line_2        escribe.address.address_line_2%TYPE,
     city                  escribe.address.city%TYPE,
     state                 escribe.address.state%TYPE,
     zip_code              escribe.address.zip_code%TYPE,
     country               escribe.address.country%TYPE
    );

TYPE audit_dates_rec_t  IS RECORD
    (table_class_name      escribe.audit_dates.table_class_name%TYPE,
     table_row_id          escribe.audit_dates.table_row_id%TYPE,
     system_create_date    escribe.audit_dates.system_create_date%TYPE
    );

audit_dates_rec            audit_dates_rec_t;

address_rec                address_rec_t;
mailing_address_rec        address_rec_t;
address_id                 NUMBER;
mailing_address_id         NUMBER;
mailing_zip_code           escribe.address.zip_code%TYPE;
audit_dates_id             NUMBER;

error_loc                  NUMBER;
error_msg                  VARCHAR2(2000);

e_custom_exception         EXCEPTION;
  PRAGMA exception_init(e_custom_exception, -20001);

BEGIN

     /*------------------------------------------------------*
      | Select DISTINCT addresses from Pharmacy source file. |
      *------------------------------------------------------*/
     error_loc := 1;

      FOR rec1 IN  (SELECT address_1,
                           address_2,
                           city,
                           state_code,
                           zip_code
                      FROM (SELECT xt1.*, ROW_NUMBER() OVER
                                        (PARTITION BY address_1,
                                                      address_2,
                                                      city,
                                                      state_code,
                                                      zip_code
                                                      ORDER BY ROWID
                                        ) rn
                              FROM escribe.NCPDP_pharmacy_source_data_xt xt1
                           )
                     WHERE rn = 1
                   )

      LOOP
           /*--------------------------------------------------------*
            | Build output record from Address Sequence generator    |
            |       and Pharmacy source data store address elements. |
            *--------------------------------------------------------*/
           error_loc := 2;

           SELECT address_id_seq.NEXTVAL
             INTO address_id
             FROM dual;

           address_rec.id             := address_id;
           address_rec.address_line_1 := rec1.address_1;
           address_rec.address_line_2 := rec1.address_2;
           address_rec.city           := rec1.city;
           address_rec.state          := rec1.state_code;
           address_rec.zip_code       := rec1.zip_code;

           error_loc := 3;

           INSERT INTO escribe.address
                      (id,
                       address_line_1,
                       address_line_2,
                       city,
                       state,
                       zip_code
                      )
               VALUES (address_rec.id,
                       address_rec.address_line_1,
                       address_rec.address_line_2,
                       address_rec.city,
                       address_rec.state,
                       address_rec.zip_code
                      );

           error_loc := 4;

           SELECT audit_dates_id_seq.NEXTVAL
             INTO audit_dates_id
             FROM dual;

           INSERT INTO escribe.audit_dates
                      (id,
                       table_class_name,
                       table_row_id,
                       system_create_date
                      )
               VALUES (audit_dates_id,
                       'ADDRESS',
                       address_rec.id,
                       SYSDATE
                      );

      END LOOP;

     /*--------------------------------------------------------------*
      | Select DISTINCT Mailing addresses from Pharmacy source file. |
      *--------------------------------------------------------------*/
     error_loc := 4;

      FOR rec2 IN  (SELECT address_1,
                           address_2,
                           city,
                           state_code,
                           zip_code,
                           mailing_address_1,
                           mailing_address_2,
                           mailing_address_city,
                           mailing_address_state_code,
                           mailing_address_zip_code
                      FROM (SELECT xt2.*, ROW_NUMBER() OVER
                                        (PARTITION BY mailing_address_1,
                                                      mailing_address_2,
                                                      mailing_address_city,
                                                      mailing_address_state_code,
                                                      mailing_address_zip_code
                                                      ORDER BY ROWID
                                        ) rn
                              FROM escribe.NCPDP_pharmacy_source_data_xt xt2
                             WHERE address_1 != mailing_address_1
                               AND (mailing_address_1          IS NOT NULL
                               AND  mailing_address_city       IS NOT NULL
                               AND  mailing_address_state_code IS NOT NULL
                               AND  mailing_address_zip_code   IS NOT NULL)
                           )
                     WHERE rn = 1
                   )

      LOOP
           /*--------------------------------------------------------*
            | Build output record from Address Sequence generator    |
            |       and Pharmacy source data store address elements. |
            *--------------------------------------------------------*/
           error_loc := 5;

           SELECT address_id_seq.NEXTVAL
             INTO mailing_address_id
             FROM dual;

                   error_loc := 6;

           CASE WHEN INSTR(rec2.mailing_address_zip_code,'-') = 6
                THEN
                     mailing_zip_code := SUBSTR(rec2.mailing_address_zip_code,1,5)||
                                         SUBSTR(rec2.mailing_address_zip_code,7,4);
                ELSE
                     mailing_zip_code := rec2.mailing_address_zip_code;
           END CASE;

           mailing_address_rec.id             := mailing_address_id;
           mailing_address_rec.address_line_1 := rec2.mailing_address_1;
           mailing_address_rec.address_line_2 := rec2.mailing_address_2;
           mailing_address_rec.city           := rec2.mailing_address_city;
           mailing_address_rec.state          := rec2.mailing_address_state_code;
           mailing_address_rec.zip_code       := mailing_zip_code;

           error_loc := 7;

           INSERT INTO escribe.address
                      (id,
                       address_line_1,
                       address_line_2,
                       city,
                       state,
                       zip_code
                      )
               VALUES (mailing_address_rec.id,
                       mailing_address_rec.address_line_1,
                       mailing_address_rec.address_line_2,
                       mailing_address_rec.city,
                       mailing_address_rec.state,
                       mailing_address_rec.zip_code
                      );

           error_loc := 8;

           SELECT audit_dates_id_seq.NEXTVAL
             INTO audit_dates_id
             FROM dual;

           INSERT INTO escribe.audit_dates
                      (id,
                       table_class_name,
                       table_row_id,
                       system_create_date
                      )
               VALUES (audit_dates_id,
                       'ADDRESS',
                       address_rec.id,
                       SYSDATE
                      );
      END LOOP;

      COMMIT;

     /*------------------------------------------*
      | Display the escribe.address table count. |
      *------------------------------------------*/
--       DBMS_OUTPUT.put_line (TABCOUNT ('escribe', 'address'));

EXCEPTION

WHEN OTHERS THEN
     error_msg := SQLERRM||' in escribe.pharmacy_address_tbl_ins_p at'||
                  ' location ('||TO_CHAR(error_loc)||')';
     raise_application_error(-20001,error_msg);

/*-------------------------------------------------------------------*
 *                          End of Procedure                         *
 *-------------------------------------------------------------------*/
END pharmacy_address_tbl_ins_p;
/
CREATE OR REPLACE PROCEDURE         ESCRIBE.PHARMACY_TBL_INS_P IS

CURSOR add_cur (add_line1 VARCHAR2,
                city_name VARCHAR2,
                state_nam VARCHAR2,
                zip_zone  VARCHAR2
               )
    IS SELECT id
         FROM escribe.address
        WHERE address_line_1 = add_line1
          AND city           = city_name
          AND state          = state_nam
          AND zip_code       = zip_zone;

TYPE pharmacy_rec_t IS RECORD
    (id                           escribe.pharmacy.id%TYPE,
     ncpdp_number                 escribe.pharmacy.ncpdp_number%TYPE,
     id_address                   escribe.pharmacy.id_address%TYPE,
     pharmacy_name                escribe.pharmacy.pharmacy_name%TYPE,
     store_number                 escribe.pharmacy.store_number%TYPE,
     id_mailing_address           escribe.pharmacy.id_mailing_address%TYPE,
     phone_number                 escribe.pharmacy.phone_number%TYPE,
     fax_phone                    escribe.pharmacy.fax_phone%TYPE,
     open_24_hour                 escribe.pharmacy.open_24_hour%TYPE,
     state_tax_id                 escribe.pharmacy.state_tax_id%TYPE,
     federal_tax_id               escribe.pharmacy.federal_tax_id%TYPE,
     state_license_number         escribe.pharmacy.state_license_number%TYPE,
     dispenser_class_code         escribe.pharmacy.dispenser_class_code%TYPE,
     dispenser_type_code_1        escribe.pharmacy.dispenser_type_code_1%TYPE,
     pharmacy_hours               escribe.pharmacy.pharmacy_hours%TYPE
    );
TYPE audit_dates_rec_t  IS RECORD
    (table_class_name             escribe.audit_dates.table_class_name%TYPE,
     table_row_id                 escribe.audit_dates.table_row_id%TYPE,
     system_create_date           escribe.audit_dates.system_create_date%TYPE
    );

audit_dates_rec                   audit_dates_rec_t;

pharmacy_rec                      pharmacy_rec_t;
pharmacy_id                       NUMBER;
address_id                        NUMBER;
mailing_address_id                NUMBER;
audit_dates_id                    NUMBER;

error_loc                         NUMBER;
error_msg                         VARCHAR2(2000);

e_custom_exception                EXCEPTION;
  PRAGMA exception_init(e_custom_exception, -20001);

BEGIN

     /*------------------------------------------------------*
      | Select DISTINCT Pharmacys from Pharmacy source file. |
      *------------------------------------------------------*/
      error_loc := 1;

      FOR rec IN  (SELECT ncpdp_provider_num,
                          name,
                          store_num,
                          phone_num,
                          fax_num,
                          open_24_hour,
                          state_tax_id,
                          federal_tax_id,
                          state_license_num,
                          dispenser_class_code,
                          dispenser_type_code,
                          provider_hours,
                          address_1,
                          address_2,
                          city,
                          state_code,
                          zip_code,
                          mailing_address_1,
                          mailing_address_2,
                          mailing_address_city,
                          mailing_address_state_code,
                          mailing_address_zip_code
                     FROM (SELECT xt.*, ROW_NUMBER() OVER
                                       (PARTITION BY ncpdp_provider_num
                                                     ORDER BY ROWID
                                       ) rn
                             FROM escribe.NCPDP_pharmacy_source_data_xt xt
                          )
                    WHERE rn = 1
                  )

      LOOP
           /*---------------------------------------------------------*
            | Build output record from Pharmacy Sequence generator    |
            |   and Pharmacy source data elements.                    |
            *---------------------------------------------------------*/

            address_id         := NULL;
            mailing_address_id := NULL;

--            DBMS_OUTPUT.put_line ('ADDRESS INFO: '||
--                                  rec.address_1||' ~ '||
--                                  rec.address_2||' ~ '||
--                                  rec.city||' ~ '||
--                                  rec.state_code||' ~ '||
--                                  rec.zip_code
--                                 );

           error_loc := 2;

           IF add_cur%ISOPEN = TRUE
              THEN
                   CLOSE add_cur;
           END IF;

           /*---------------------------------------------------*
            | Lookup Address table ID primary key value to the  |
            | Store Address to provide the address foreign key. |
            *---------------------------------------------------*/
           OPEN add_cur(rec.address_1,
                        rec.city,
                        rec.state_code,
                        rec.zip_code
                       );

                /*---------------------------------------------------------*
                 | If the Address table has no matching row, then by-pass  |
                 | the remainder of the process to build and insert a row. |
                 *---------------------------------------------------------*/
                error_loc := 3;

                FETCH add_cur INTO address_id;

--                 DBMS_OUTPUT.put_line ('ADDRESS Table PK value: '||address_id);

--                       EXIT WHEN add_cur%NOTFOUND;

                error_loc := 4;

                 /*-----------------------------------------------------*
                  | Check for the existence of a Mailing Address in the |
                  | Pharmacy source data to acquire the Address table   |
                  | primary key for the mailing address foreign key.    |
                  *-----------------------------------------------------*/
                IF rec.mailing_address_1 IS NOT NULL
                   THEN
                        CLOSE add_cur;
                        /*----------------------------------------------------------*
                         | Lookup Address table ID primary key value to lookup the  |
                         | clinic table id_address to acquire the clinic table      |
                         | primary key to provide the clinic link foreign key.      |
                         *----------------------------------------------------------*/
                        OPEN add_cur(rec.mailing_address_1,
                                     rec.mailing_address_city,
                                     rec.mailing_address_state_code,
                                     rec.mailing_address_zip_code
                                    );

                        error_loc := 5;

                        FETCH add_cur INTO mailing_address_id;

                   ELSE

                        mailing_address_id := NULL;

                END IF;

                SELECT pharmacy_id_seq.NEXTVAL
                  INTO pharmacy_id
                  FROM dual;

                error_loc := 6;

                pharmacy_rec.id                    := pharmacy_id;

                pharmacy_rec.ncpdp_number          := TO_NUMBER(rec.ncpdp_provider_num);
                pharmacy_rec.id_address            := address_id;
                pharmacy_rec.pharmacy_name         := rec.name;
                pharmacy_rec.store_number          := rec.store_num;
                pharmacy_rec.id_mailing_address    := mailing_address_id;
                pharmacy_rec.phone_number          := TO_NUMBER(rec.phone_num);
                pharmacy_rec.fax_phone             := TO_NUMBER(rec.fax_num);
                pharmacy_rec.open_24_hour          := rec.open_24_hour;
                pharmacy_rec.state_tax_id          := rec.state_tax_id;
                pharmacy_rec.federal_tax_id        := rec.federal_tax_id;
                pharmacy_rec.state_license_number  := rec.state_license_num;
                pharmacy_rec.dispenser_class_code  := SUBSTR(rec.dispenser_class_code,1,2);
                pharmacy_rec.dispenser_type_code_1 := SUBSTR(rec.dispenser_type_code,1,2);
                pharmacy_rec.pharmacy_hours        := rec.provider_hours;

                error_loc := 7;

                INSERT INTO escribe.pharmacy
                           (id,
                            ncpdp_number,
                            id_address,
                            pharmacy_name,
                            store_number,
                            id_mailing_address,
                            phone_number,
                            fax_phone,
                            open_24_hour,
                            state_tax_id,
                            federal_tax_id,
                            state_license_number,
                            dispenser_class_code,
                            dispenser_type_code_1,
                            pharmacy_hours
                           )
                    VALUES (pharmacy_rec.id,
                            pharmacy_rec.ncpdp_number,
                            pharmacy_rec.id_address,
                            pharmacy_rec.pharmacy_name,
                            pharmacy_rec.store_number,
                            pharmacy_rec.id_mailing_address,
                            pharmacy_rec.phone_number,
                            pharmacy_rec.fax_phone,
                            pharmacy_rec.open_24_hour,
                            pharmacy_rec.state_tax_id,
                            pharmacy_rec.federal_tax_id,
                            pharmacy_rec.state_license_number,
                            pharmacy_rec.dispenser_class_code,
                            pharmacy_rec.dispenser_type_code_1,
                            pharmacy_rec.pharmacy_hours
                           );

           error_loc := 8;

           SELECT audit_dates_id_seq.NEXTVAL
             INTO audit_dates_id
             FROM dual;

           INSERT INTO escribe.audit_dates
                      (id,
                       table_class_name,
                       table_row_id,
                       system_create_date
                      )
               VALUES (audit_dates_id,
                       'PHARMACY',
                       pharmacy_rec.id,
                       SYSDATE
                      );

      END LOOP;

      COMMIT;

     /*-------------------------------------------*
      | Display the escribe.pharmacy table count. |
      *-------------------------------------------*/
--       DBMS_OUTPUT.put_line (TABCOUNT ('escribe', 'pharmacy'));

EXCEPTION

WHEN OTHERS THEN
     error_msg := SQLERRM||' in escribe.pharmacy_tbl_ins_p at'||
                  ' location ('||TO_CHAR(error_loc)||')';
     raise_application_error(-20001,error_msg);

/*-------------------------------------------------------------------*
 *                          End of Procedure                         *
 *-------------------------------------------------------------------*/
END pharmacy_tbl_ins_p;
/
CREATE OR REPLACE PROCEDURE         ESCRIBE.PRESCRIBER_ADDRESS_TBL_INS_P IS

TYPE address_rec_t      IS RECORD
    (id                    escribe.address.id%TYPE,
     address_line_1        escribe.address.address_line_1%TYPE,
     address_line_2        escribe.address.address_line_2%TYPE,
     department_mail_stop  escribe.address.department_mail_stop%TYPE,
     city                  escribe.address.city%TYPE,
     state                 escribe.address.state%TYPE,
     zip_code              escribe.address.zip_code%TYPE,
     country               escribe.address.country%TYPE
    );

TYPE audit_dates_rec_t  IS RECORD
    (table_class_name      escribe.audit_dates.table_class_name%TYPE,
     table_row_id          escribe.audit_dates.table_row_id%TYPE,
     system_create_date    escribe.audit_dates.system_create_date%TYPE
    );

audit_dates_rec            audit_dates_rec_t;

address_rec                address_rec_t;
address_id                 NUMBER;
audit_dates_id             NUMBER;

error_loc                  NUMBER;
error_msg                  VARCHAR2(2000);

e_custom_exception         EXCEPTION;
  PRAGMA exception_init(e_custom_exception, -20001);

BEGIN

     /*--------------------------------------------------------*
      | Select DISTINCT addresses from Prescriber source file. |
      *--------------------------------------------------------*/
      error_loc := 1;

      FOR rec IN  (SELECT phys_address_line_1,
                          phys_address_line_2,
                          phys_suite_apartment_num,
                          department_mail_stop,
                          phys_city_name,
                          phys_state_province_code,
                          phys_zip_postal_zone,
                          phys_country_code
                     FROM (SELECT xt.*, ROW_NUMBER() OVER
                                       (PARTITION BY
                                                     phys_address_line_1,
                                                     phys_address_line_2,
                                                     phys_suite_apartment_num,
                                                     department_mail_stop,
                                                     phys_city_name,
                                                     phys_state_province_code,
                                                     phys_zip_postal_zone,
                                                     phys_country_code
                                                     ORDER BY ROWID
                                       ) rn
                             FROM escribe.HCI_prescriber_source_data_xt xt
                            WHERE phys_country_code        IS NOT NULL
                              AND phys_address_line_1      IS NOT NULL
                              AND phys_city_name           IS NOT NULL
                              AND phys_state_province_code IS NOT NULL
                              AND phys_zip_postal_zone     IS NOT NULL
                          )
                    WHERE rn = 1
                    ORDER BY
                          phys_address_line_1,
                          phys_address_line_2,
                          phys_suite_apartment_num,
                          department_mail_stop,
                          phys_city_name,
                          phys_state_province_code,
                          phys_zip_postal_zone,
                          phys_country_code
                  )

      LOOP
           /*-----------------------------------------------------*
            | Build output record from Address Sequence generator |
            |       and Prescriber source data elements.          |
            *-----------------------------------------------------*/
           error_loc := 2;

           SELECT address_id_seq.NEXTVAL INTO address_id FROM dual;

           address_rec.id                   := address_id;
           address_rec.address_line_1       := rec.phys_address_line_1;
           address_rec.address_line_2       := rec.phys_address_line_2 ||
                                               rec.phys_suite_apartment_num;
           address_rec.department_mail_stop := rec.department_mail_stop;
           address_rec.city                 := rec.phys_city_name;
           address_rec.state                := rec.phys_state_province_code;
           address_rec.zip_code             := rec.phys_zip_postal_zone;
           address_rec.country              := rec.phys_country_code;

           error_loc := 3;

           INSERT INTO escribe.address
                      (id,
                       address_line_1,
                       address_line_2,
                       department_mail_stop,
                       city,
                       state,
                       zip_code,
                       country
                      )
               VALUES (address_rec.id,
                       address_rec.address_line_1,
                       address_rec.address_line_2,
                       address_rec.department_mail_stop,
                       address_rec.city,
                       address_rec.state,
                       address_rec.zip_code,
                       address_rec.country
                      );

           error_loc := 4;

           SELECT audit_dates_id_seq.NEXTVAL
             INTO audit_dates_id
             FROM dual;

           INSERT INTO escribe.audit_dates
                      (id,
                       table_class_name,
                       table_row_id,
                       system_create_date
                      )
               VALUES (audit_dates_id,
                       'ADDRESS',
                       address_rec.id,
                       SYSDATE
                      );

      END LOOP;

      COMMIT;

     /*------------------------------------------*
      | Display the escribe.address table count. |
      *------------------------------------------*/
--       DBMS_OUTPUT.put_line (TABCOUNT ('escribe', 'address'));

EXCEPTION

WHEN OTHERS THEN
     error_msg := SQLERRM||' in escribe.prescriber_address_tbl_ins_p at'||
                  ' location ('||TO_CHAR(error_loc)||')';
     raise_application_error(-20001,error_msg);

/*-------------------------------------------------------------------*
 *                          End of Procedure                         *
 *-------------------------------------------------------------------*/
END prescriber_address_tbl_ins_p;
/
CREATE OR REPLACE PROCEDURE         ESCRIBE.PRESCRIBER_MEDICAID_TBL_INS_P IS

CURSOR prescr_cur (hcid_ident VARCHAR2)
    IS SELECT id
         FROM escribe.nhin_prescriber
        WHERE hcid = hcid_ident;

TYPE prescriber_medicaid_rec_t IS RECORD
    (id                           escribe.prescriber_medicaid.id%TYPE,
     id_nhin_prescriber           escribe.prescriber_medicaid.id_nhin_prescriber%TYPE,
     state                        escribe.prescriber_medicaid.state%TYPE,
     medicaid_id                  escribe.prescriber_medicaid.medicaid_id%TYPE,
     deactivate_date              escribe.prescriber_medicaid.deactivate_date%TYPE
    );

TYPE audit_dates_rec_t         IS RECORD
    (table_class_name             escribe.audit_dates.table_class_name%TYPE,
     table_row_id                 escribe.audit_dates.table_row_id%TYPE,
     user_create_login            escribe.audit_dates.user_create_login%TYPE,
     user_create_date             escribe.audit_dates.user_create_date%TYPE,
     system_create_date           escribe.audit_dates.system_create_date%TYPE,
     user_update_login            escribe.audit_dates.user_update_login%TYPE,
     user_update_date             escribe.audit_dates.user_update_date%TYPE,
     system_update_date           escribe.audit_dates.system_update_date%TYPE
    );

prescriber_medicaid_rec           prescriber_medicaid_rec_t;
fk_id_nhin_prescriber             NUMBER;
prescr_medicaid_id                NUMBER;
audit_dates_id                    NUMBER;

audit_dates_rec                   audit_dates_rec_t;

error_loc                         NUMBER;
error_msg                         VARCHAR2(2000);

e_custom_exception                EXCEPTION;
  PRAGMA exception_init(e_custom_exception, -20001);

BEGIN

     /*---------------------------------------------------------------------------*
      | Select DISTINCT Prescriber State Information from Prescriber source file. |
      *---------------------------------------------------------------------------*/
      error_loc := 1;

      FOR rec1 IN  (SELECT hcid_identifier,
                           state_code_prime_medicaid_id,
                           prime_medicaid_id
                      FROM (SELECT xt.*, ROW_NUMBER() OVER
                                        (PARTITION BY hcid_identifier,
                                                      state_code_prime_medicaid_id,
                                                      prime_medicaid_id
                                                      ORDER BY ROWID
                                        ) rn
                              FROM escribe.HCI_prescriber_source_data_xt xt
                             WHERE phys_country_code            IS NOT NULL
                               AND state_code_prime_medicaid_id IS NOT NULL
                               AND prime_medicaid_id            IS NOT NULL
                           )
                     WHERE rn = 1
                   )

      LOOP
           error_loc := 2;

           IF prescr_cur%ISOPEN = TRUE
              THEN
                   CLOSE prescr_cur;
           END IF;

           /*-----------------------------------------------------------------*
            | Lookup Prescriber table ID primary key value for the Prescriber |
            |        State table id_nhin_prescriber foreign key column.       |
            *-----------------------------------------------------------------*/
           OPEN prescr_cur(rec1.hcid_identifier);
           LOOP
                /*------------------------------------------------------------*
                 | If the Prescriber table has no matching row, then by-pass  |
                 | the remainder of the process to build and insert a row.    |
                 *------------------------------------------------------------*/
                error_loc := 3;

                FETCH prescr_cur INTO fk_id_nhin_prescriber;

                      EXIT WHEN prescr_cur%NOTFOUND;

                /*--------------------------------------------------------------*
                 | Build output record from Prescriber State Sequence generator |
                 *--------------------------------------------------------------*/
                error_loc := 4;

                SELECT prescr_medicaid_id_seq.NEXTVAL
                  INTO prescr_medicaid_id
                  FROM dual;

                error_loc := 5;

                prescriber_medicaid_rec.id                   := prescr_medicaid_id;
                prescriber_medicaid_rec.id_nhin_prescriber   := fk_id_nhin_prescriber;

                prescriber_medicaid_rec.state                := rec1.state_code_prime_medicaid_id;
                prescriber_medicaid_rec.medicaid_id          := rec1.prime_medicaid_id;

                error_loc := 6;

                INSERT INTO escribe.prescriber_medicaid
                           (id,
                            id_nhin_prescriber,
                            state,
                            medicaid_id
                           )
                    VALUES (prescriber_medicaid_rec.id,
                            prescriber_medicaid_rec.id_nhin_prescriber,
                            prescriber_medicaid_rec.state,
                            prescriber_medicaid_rec.medicaid_id
                           );

                error_loc := 7;

                SELECT audit_dates_id_seq.NEXTVAL
                  INTO audit_dates_id
                  FROM dual;

                INSERT INTO escribe.audit_dates
                           (id,
                            table_class_name,
                            table_row_id,
                            system_create_date
                           )
                    VALUES (audit_dates_id,
                            'PRESCRIBER_MEDICAID',
                            prescriber_medicaid_rec.id,
                            SYSDATE
                           );

           END LOOP;

      END LOOP;

     /*---------------------------------------------------------------------------*
      | Select DISTINCT Prescriber State Information from Prescriber source file. |
      *---------------------------------------------------------------------------*/
      error_loc := 8;

      FOR rec2 IN  (SELECT hcid_identifier,
                           state_code_second_medicaid_id,
                           second_medicaid_id
                      FROM (SELECT xt.*, ROW_NUMBER() OVER
                                        (PARTITION BY hcid_identifier,
                                                      state_code_second_medicaid_id,
                                                      second_medicaid_id
                                                      ORDER BY ROWID
                                        ) rn
                              FROM escribe.HCI_prescriber_source_data_xt xt
                             WHERE phys_country_code             IS NOT NULL
                               AND state_code_second_medicaid_id IS NOT NULL
                               AND second_medicaid_id            IS NOT NULL
                           )
                     WHERE rn = 1
                   )

      LOOP
           error_loc := 9;

           IF prescr_cur%ISOPEN = TRUE
              THEN
                   CLOSE prescr_cur;
           END IF;

           /*-----------------------------------------------------------------*
            | Lookup Prescriber table ID primary key value for the Prescriber |
            |        State table id_nhin_prescriber foreign key column.       |
            *-----------------------------------------------------------------*/
           OPEN prescr_cur(rec2.hcid_identifier);
           LOOP
                /*------------------------------------------------------------*
                 | If the Prescriber table has no matching row, then by-pass  |
                 | the remainder of the process to build and insert a row.    |
                 *------------------------------------------------------------*/
                error_loc := 10;

                FETCH prescr_cur INTO fk_id_nhin_prescriber;

                      EXIT WHEN prescr_cur%NOTFOUND;

                /*--------------------------------------------------------------*
                 | Build output record from Prescriber State Sequence generator |
                 *--------------------------------------------------------------*/
                error_loc := 11;

                SELECT prescr_medicaid_id_seq.NEXTVAL
                  INTO prescr_medicaid_id
                  FROM dual;

                error_loc := 12;

                prescriber_medicaid_rec.id                   := prescr_medicaid_id;
                prescriber_medicaid_rec.id_nhin_prescriber   := fk_id_nhin_prescriber;

                prescriber_medicaid_rec.state                := rec2.state_code_second_medicaid_id;
                prescriber_medicaid_rec.medicaid_id          := rec2.second_medicaid_id;

                error_loc := 13;

                INSERT INTO escribe.prescriber_medicaid
                           (id,
                            id_nhin_prescriber,
                            state,
                            medicaid_id
                           )
                    VALUES (prescriber_medicaid_rec.id,
                            prescriber_medicaid_rec.id_nhin_prescriber,
                            prescriber_medicaid_rec.state,
                            prescriber_medicaid_rec.medicaid_id
                           );

                error_loc := 14;

                SELECT audit_dates_id_seq.NEXTVAL
                  INTO audit_dates_id
                  FROM dual;

                INSERT INTO escribe.audit_dates
                           (id,
                            table_class_name,
                            table_row_id,
                            system_create_date
                           )
                    VALUES (audit_dates_id,
                            'PRESCRIBER_MEDICAID',
                            prescriber_medicaid_rec.id,
                            SYSDATE
                           );

           END LOOP;

      END LOOP;

     /*---------------------------------------------------------------------------*
      | Select DISTINCT Prescriber State Information from Prescriber source file. |
      *---------------------------------------------------------------------------*/
      error_loc := 15;

      FOR rec3 IN  (SELECT hcid_identifier,
                           state_code_third_medicaid_id,
                           third_medicaid_id
                      FROM (SELECT xt.*, ROW_NUMBER() OVER
                                        (PARTITION BY hcid_identifier,
                                                      state_code_third_medicaid_id,
                                                      third_medicaid_id
                                                      ORDER BY ROWID
                                        ) rn
                              FROM escribe.HCI_prescriber_source_data_xt xt
                             WHERE phys_country_code            IS NOT NULL
                               AND state_code_third_medicaid_id IS NOT NULL
                               AND third_medicaid_id            IS NOT NULL
                           )
                     WHERE rn = 1
                   )

      LOOP
           error_loc := 16;

           IF prescr_cur%ISOPEN = TRUE
              THEN
                   CLOSE prescr_cur;
           END IF;

           /*-----------------------------------------------------------------*
            | Lookup Prescriber table ID primary key value for the Prescriber |
            |        State table id_nhin_prescriber foreign key column.       |
            *-----------------------------------------------------------------*/
           OPEN prescr_cur(rec3.hcid_identifier);
           LOOP
                /*------------------------------------------------------------*
                 | If the Prescriber table has no matching row, then by-pass  |
                 | the remainder of the process to build and insert a row.    |
                 *------------------------------------------------------------*/
                error_loc := 17;

                FETCH prescr_cur INTO fk_id_nhin_prescriber;

                      EXIT WHEN prescr_cur%NOTFOUND;

                /*--------------------------------------------------------------*
                 | Build output record from Prescriber State Sequence generator |
                 *--------------------------------------------------------------*/
                error_loc := 18;

                SELECT prescr_medicaid_id_seq.NEXTVAL
                  INTO prescr_medicaid_id
                  FROM dual;

                error_loc := 19;

                prescriber_medicaid_rec.id                   := prescr_medicaid_id;
                prescriber_medicaid_rec.id_nhin_prescriber   := fk_id_nhin_prescriber;

                prescriber_medicaid_rec.state                := rec3.state_code_third_medicaid_id;
                prescriber_medicaid_rec.medicaid_id          := rec3.third_medicaid_id;

                error_loc := 20;

                INSERT INTO escribe.prescriber_medicaid
                           (id,
                            id_nhin_prescriber,
                            state,
                            medicaid_id
                           )
                    VALUES (prescriber_medicaid_rec.id,
                            prescriber_medicaid_rec.id_nhin_prescriber,
                            prescriber_medicaid_rec.state,
                            prescriber_medicaid_rec.medicaid_id
                           );

                error_loc := 21;

                SELECT audit_dates_id_seq.NEXTVAL
                  INTO audit_dates_id
                  FROM dual;

                INSERT INTO escribe.audit_dates
                           (id,
                            table_class_name,
                            table_row_id,
                            system_create_date
                           )
                    VALUES (audit_dates_id,
                            'PRESCRIBER_MEDICAID',
                            prescriber_medicaid_rec.id,
                            SYSDATE
                           );

           END LOOP;

      END LOOP;


      COMMIT;

     /*------------------------------------------------------*
      | Display the escribe.prescriber_medicaid table count. |
      *------------------------------------------------------*/
--       DBMS_OUTPUT.put_line (TABCOUNT ('escribe', 'prescriber_medicaid'));

EXCEPTION

WHEN OTHERS THEN
     error_msg := SQLERRM||' in escribe.prescriber_medicaid_tbl_ins_p at'||
                  ' location ('||TO_CHAR(error_loc)||')';
     raise_application_error(-20001,error_msg);

/*-------------------------------------------------------------------*
 *                          End of Procedure                         *
 *-------------------------------------------------------------------*/
END prescriber_medicaid_tbl_ins_p;
/
CREATE OR REPLACE PROCEDURE         ESCRIBE.PRESCRIBER_STATE_TBL_INS_P IS

CURSOR prescr_cur (hcid_ident VARCHAR2)
    IS SELECT id
         FROM escribe.nhin_prescriber
        WHERE hcid = hcid_ident;

TYPE prescriber_state_rec_t IS RECORD
    (id                        escribe.prescriber_state.id%TYPE,
     id_nhin_prescriber        escribe.prescriber_state.id_nhin_prescriber%TYPE,
     state                     escribe.prescriber_state.state%TYPE,
     state_license_id          escribe.prescriber_state.state_license_id%TYPE
    );

TYPE audit_dates_rec_t      IS RECORD
    (table_class_name          escribe.audit_dates.table_class_name%TYPE,
     table_row_id              escribe.audit_dates.table_row_id%TYPE,
     system_create_date        escribe.audit_dates.system_create_date%TYPE
    );

audit_dates_rec                audit_dates_rec_t;

prescriber_state_rec           prescriber_state_rec_t;
fk_id_nhin_prescriber          NUMBER;
prescr_state_id                NUMBER;
audit_dates_id                 NUMBER;

error_loc                      NUMBER;
error_msg                      VARCHAR2(2000);

e_custom_exception             EXCEPTION;
  PRAGMA exception_init(e_custom_exception, -20001);

BEGIN

     /*---------------------------------------------------------------------------*
      | Select DISTINCT Prescriber State Information from Prescriber source file. |
      *---------------------------------------------------------------------------*/
      error_loc := 1;

      FOR rec1 IN  (SELECT hcid_identifier,
                           licensing_state_1,
                           state_license_1
                      FROM (SELECT xt.*, ROW_NUMBER() OVER
                                        (PARTITION BY hcid_identifier,
                                                      licensing_state_1,
                                                      state_license_1
                                                      ORDER BY ROWID
                                        ) rn
                              FROM escribe.HCI_prescriber_source_data_xt xt
                             WHERE phys_country_code IS NOT NULL
                               AND licensing_state_1 IS NOT NULL
                               AND state_license_1   IS NOT NULL
                           )
                     WHERE rn = 1
                   )

      LOOP
           error_loc := 2;

           IF prescr_cur%ISOPEN = TRUE
              THEN
                   CLOSE prescr_cur;
           END IF;

           /*-----------------------------------------------------------------*
            | Lookup Prescriber table ID primary key value for the Prescriber |
            |        State table id_nhin_prescriber foreign key column.       |
            *-----------------------------------------------------------------*/
           OPEN prescr_cur(rec1.hcid_identifier);
           LOOP
                /*------------------------------------------------------------*
                 | If the Prescriber table has no matching row, then by-pass  |
                 | the remainder of the process to build and insert a row.    |
                 *------------------------------------------------------------*/
                error_loc := 3;

                FETCH prescr_cur INTO fk_id_nhin_prescriber;

                      EXIT WHEN prescr_cur%NOTFOUND;

                /*--------------------------------------------------------------*
                 | Build output record from Prescriber State Sequence generator |
                 *--------------------------------------------------------------*/
                error_loc := 4;

                SELECT prescr_state_id_seq.NEXTVAL
                  INTO prescr_state_id
                  FROM dual;

                error_loc := 5;

                prescriber_state_rec.id                   := prescr_state_id;
                prescriber_state_rec.id_nhin_prescriber   := fk_id_nhin_prescriber;

                prescriber_state_rec.state                := rec1.licensing_state_1;
                prescriber_state_rec.state_license_id     := rec1.state_license_1;

                error_loc := 6;

                INSERT INTO escribe.prescriber_state
                           (id,
                            id_nhin_prescriber,
                            state,
                            state_license_id
                           )
                    VALUES (prescriber_state_rec.id,
                            prescriber_state_rec.id_nhin_prescriber,
                            prescriber_state_rec.state,
                            prescriber_state_rec.state_license_id
                           );

                error_loc := 7;

                SELECT audit_dates_id_seq.NEXTVAL
                  INTO audit_dates_id
                  FROM dual;

                INSERT INTO escribe.audit_dates
                           (id,
                            table_class_name,
                            table_row_id,
                            system_create_date
                           )
                    VALUES (audit_dates_id,
                            'PRESCRIBER_STATE',
                            prescriber_state_rec.id,
                            SYSDATE
                           );

           END LOOP;

      END LOOP;

     /*---------------------------------------------------------------------------*
      | Select DISTINCT Prescriber State Information from Prescriber source file. |
      *---------------------------------------------------------------------------*/
      error_loc := 8;

      FOR rec2 IN  (SELECT hcid_identifier,
                           licensing_state_2,
                           state_license_2
                      FROM (SELECT xt.*, ROW_NUMBER() OVER
                                        (PARTITION BY hcid_identifier,
                                                      licensing_state_2,
                                                      state_license_2
                                                      ORDER BY ROWID
                                        ) rn
                              FROM escribe.HCI_prescriber_source_data_xt xt
                             WHERE phys_country_code IS NOT NULL
                               AND licensing_state_2 IS NOT NULL
                               AND state_license_2   IS NOT NULL
                           )
                     WHERE rn = 1
                   )

      LOOP
           error_loc := 9;

           IF prescr_cur%ISOPEN = TRUE
              THEN
                   CLOSE prescr_cur;
           END IF;

           /*-----------------------------------------------------------------*
            | Lookup Prescriber table ID primary key value for the Prescriber |
            |        State table id_nhin_prescriber foreign key column.       |
            *-----------------------------------------------------------------*/
           OPEN prescr_cur(rec2.hcid_identifier);
           LOOP
                /*------------------------------------------------------------*
                 | If the Prescriber table has no matching row, then by-pass  |
                 | the remainder of the process to build and insert a row.    |
                 *------------------------------------------------------------*/
                error_loc := 10;

                FETCH prescr_cur INTO fk_id_nhin_prescriber;

                      EXIT WHEN prescr_cur%NOTFOUND;

                /*--------------------------------------------------------------*
                 | Build output record from Prescriber State Sequence generator |
                 *--------------------------------------------------------------*/
                error_loc := 11;

                SELECT prescr_state_id_seq.NEXTVAL
                  INTO prescr_state_id
                  FROM dual;

                error_loc := 12;

                prescriber_state_rec.id                   := prescr_state_id;
                prescriber_state_rec.id_nhin_prescriber   := fk_id_nhin_prescriber;

                prescriber_state_rec.state                := rec2.licensing_state_2;
                prescriber_state_rec.state_license_id     := rec2.state_license_2;

                error_loc := 13;

                INSERT INTO escribe.prescriber_state
                           (id,
                            id_nhin_prescriber,
                            state,
                            state_license_id
                           )
                    VALUES (prescriber_state_rec.id,
                            prescriber_state_rec.id_nhin_prescriber,
                            prescriber_state_rec.state,
                            prescriber_state_rec.state_license_id
                           );

                error_loc := 14;

                SELECT audit_dates_id_seq.NEXTVAL
                  INTO audit_dates_id
                  FROM dual;

                INSERT INTO escribe.audit_dates
                           (id,
                            table_class_name,
                            table_row_id,
                            system_create_date
                           )
                    VALUES (audit_dates_id,
                            'PRESCRIBER_STATE',
                            prescriber_state_rec.id,
                            SYSDATE
                           );

           END LOOP;

      END LOOP;

     /*---------------------------------------------------------------------------*
      | Select DISTINCT Prescriber State Information from Prescriber source file. |
      *---------------------------------------------------------------------------*/
      error_loc := 15;

      FOR rec3 IN  (SELECT hcid_identifier,
                           licensing_state_3,
                           state_license_3
                      FROM (SELECT xt.*, ROW_NUMBER() OVER
                                        (PARTITION BY hcid_identifier,
                                                      licensing_state_3,
                                                      state_license_3
                                                      ORDER BY ROWID
                                        ) rn
                              FROM escribe.HCI_prescriber_source_data_xt xt
                             WHERE phys_country_code IS NOT NULL
                               AND licensing_state_3 IS NOT NULL
                               AND state_license_3   IS NOT NULL
                           )
                     WHERE rn = 1
                   )

      LOOP
           error_loc := 16;

           IF prescr_cur%ISOPEN = TRUE
              THEN
                   CLOSE prescr_cur;
           END IF;

           /*-----------------------------------------------------------------*
            | Lookup Prescriber table ID primary key value for the Prescriber |
            |        State table id_nhin_prescriber foreign key column.       |
            *-----------------------------------------------------------------*/
           OPEN prescr_cur(rec3.hcid_identifier);
           LOOP
                /*------------------------------------------------------------*
                 | If the Prescriber table has no matching row, then by-pass  |
                 | the remainder of the process to build and insert a row.    |
                 *------------------------------------------------------------*/
                error_loc := 17;

                FETCH prescr_cur INTO fk_id_nhin_prescriber;

                      EXIT WHEN prescr_cur%NOTFOUND;

                /*--------------------------------------------------------------*
                 | Build output record from Prescriber State Sequence generator |
                 *--------------------------------------------------------------*/
                error_loc := 18;

                SELECT prescr_state_id_seq.NEXTVAL
                  INTO prescr_state_id
                  FROM dual;

                error_loc := 19;

                prescriber_state_rec.id                   := prescr_state_id;
                prescriber_state_rec.id_nhin_prescriber   := fk_id_nhin_prescriber;

                prescriber_state_rec.state                := rec3.licensing_state_3;
                prescriber_state_rec.state_license_id     := rec3.state_license_3;

                error_loc := 20;

                INSERT INTO escribe.prescriber_state
                           (id,
                            id_nhin_prescriber,
                            state,
                            state_license_id
                           )
                    VALUES (prescriber_state_rec.id,
                            prescriber_state_rec.id_nhin_prescriber,
                            prescriber_state_rec.state,
                            prescriber_state_rec.state_license_id
                           );

                error_loc := 21;

                SELECT audit_dates_id_seq.NEXTVAL
                  INTO audit_dates_id
                  FROM dual;

                INSERT INTO escribe.audit_dates
                           (id,
                            table_class_name,
                            table_row_id,
                            system_create_date
                           )
                    VALUES (audit_dates_id,
                            'PRESCRIBER_STATE',
                            prescriber_state_rec.id,
                            SYSDATE
                           );

           END LOOP;

      END LOOP;

      COMMIT;

     /*---------------------------------------------------*
      | Display the escribe.prescriber_state table count. |
      *---------------------------------------------------*/
--       DBMS_OUTPUT.put_line (TABCOUNT ('escribe', 'prescriber_state'));

EXCEPTION

WHEN OTHERS THEN
     error_msg := SQLERRM||' in escribe.prescriber_state_tbl_ins_p at'||
                  ' location ('||TO_CHAR(error_loc)||')';
     raise_application_error(-20001,error_msg);

/*-------------------------------------------------------------------*
 *                          End of Procedure                         *
 *-------------------------------------------------------------------*/
END prescriber_state_tbl_ins_p;
/

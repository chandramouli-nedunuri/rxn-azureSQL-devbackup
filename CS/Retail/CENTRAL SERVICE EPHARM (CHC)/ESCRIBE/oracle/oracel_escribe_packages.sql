CREATE OR REPLACE PACKAGE             ESCRIBE.PRESCR_PKG AS

--------------------------------------------------------------------------------
-- Global Records Types
--------------------------------------------------------------------------------
TYPE rt_prescr_upd_xt              IS RECORD
    (comm_group_id                    escribe.prescr_upd_xt.comm_group_id%TYPE,
     dea_registration_num             escribe.prescr_upd_xt.dea_registration_num%TYPE,
     dea_num_renewal_date             escribe.prescr_upd_xt.dea_num_renewal_date%TYPE,
     last_name                        escribe.prescr_upd_xt.last_name%TYPE,
     previous_last_name               escribe.prescr_upd_xt.previous_last_name%TYPE,
     first_name                       escribe.prescr_upd_xt.first_name%TYPE,
     middle_name_initial              escribe.prescr_upd_xt.middle_name_initial%TYPE,
     name_suffix                      escribe.prescr_upd_xt.name_suffix%TYPE,
     gender_code                      escribe.prescr_upd_xt.gender_code%TYPE,
     organization_name                escribe.prescr_upd_xt.organization_name%TYPE,
     department_mail_stop             escribe.prescr_upd_xt.department_mail_stop%TYPE,
     phys_address_line_1              escribe.prescr_upd_xt.phys_address_line_1%TYPE,
     phys_address_line_2              escribe.prescr_upd_xt.phys_address_line_2%TYPE,
     phys_suite_apartment_num         escribe.prescr_upd_xt.phys_suite_apartment_num%TYPE,
     phys_city_name                   escribe.prescr_upd_xt.phys_city_name%TYPE,
     phys_state_province_code         escribe.prescr_upd_xt.phys_state_province_code%TYPE,
     phys_zip_postal_zone             escribe.prescr_upd_xt.phys_zip_postal_zone%TYPE,
     phys_country_code                escribe.prescr_upd_xt.phys_country_code%TYPE,
     prime_phone_num                  escribe.prescr_upd_xt.prime_phone_num%TYPE,
     second_phone_num                 escribe.prescr_upd_xt.second_phone_num%TYPE,
     refill_phone_num                 escribe.prescr_upd_xt.refill_phone_num%TYPE,
     fax_num                          escribe.prescr_upd_xt.fax_num%TYPE,
     email_ignored                    escribe.prescr_upd_xt.email_ignored%TYPE,
     prime_degree                     escribe.prescr_upd_xt.prime_degree%TYPE,
     prime_taxonomy_code              escribe.prescr_upd_xt.prime_taxonomy_code%TYPE,
     second_degree                    escribe.prescr_upd_xt.second_degree%TYPE,
     second_taxonomy_code             escribe.prescr_upd_xt.second_taxonomy_code%TYPE,
     state_code_prime_medicaid_id     escribe.prescr_upd_xt.state_code_prime_medicaid_id%TYPE,
     prime_medicaid_id                escribe.prescr_upd_xt.prime_medicaid_id%TYPE,
     state_code_second_medicaid_id    escribe.prescr_upd_xt.state_code_second_medicaid_id%TYPE,
     second_medicaid_id               escribe.prescr_upd_xt.second_medicaid_id%TYPE,
     state_code_third_medicaid_id     escribe.prescr_upd_xt.state_code_third_medicaid_id%TYPE,
     third_medicaid_id                escribe.prescr_upd_xt.third_medicaid_id%TYPE,
     upin_num                         escribe.prescr_upd_xt.upin_num%TYPE,
     hin_num                          escribe.prescr_upd_xt.hin_num%TYPE,
     hcid_location_code               escribe.prescr_upd_xt.hcid_location_code%TYPE,
     dea_status_code                  escribe.prescr_upd_xt.dea_status_code%TYPE,
     retire_date                      escribe.prescr_upd_xt.retire_date%TYPE,
     data_supplier_ref_key_1          escribe.prescr_upd_xt.data_supplier_ref_key_1%TYPE,
     data_supplier_ref_key_2          escribe.prescr_upd_xt.data_supplier_ref_key_2%TYPE,
     data_supplier_ref_key_3          escribe.prescr_upd_xt.data_supplier_ref_key_3%TYPE,
     data_supplier_site_num           escribe.prescr_upd_xt.data_supplier_site_num%TYPE,
     npi                              escribe.prescr_upd_xt.npi%TYPE,
     hcid_identifier                  escribe.prescr_upd_xt.hcid_identifier%TYPE,
     nhin_provider_id                 escribe.prescr_upd_xt.nhin_provider_id%TYPE,
     phys_location_type_code          escribe.prescr_upd_xt.phys_location_type_code%TYPE,
     dupe_dea_flag                    escribe.prescr_upd_xt.dupe_dea_flag%TYPE,
     dupe_data_supplier_ref_key_1     escribe.prescr_upd_xt.dupe_data_supplier_ref_key_1%TYPE,
     comm_sub_group_id                escribe.prescr_upd_xt.comm_sub_group_id%TYPE,
     update_record_type_code          escribe.prescr_upd_xt.update_record_type_code%TYPE,
     date_last_change                 escribe.prescr_upd_xt.date_last_change%TYPE,
     dea_registration_num_suffix      escribe.prescr_upd_xt.dea_registration_num_suffix%TYPE,
     dea_drug_schedule                escribe.prescr_upd_xt.dea_drug_schedule%TYPE,
     ncpdp_provider_id_num            escribe.prescr_upd_xt.ncpdp_provider_id_num%TYPE,
     dupe_data_supplier_ref_key_2     escribe.prescr_upd_xt.dupe_data_supplier_ref_key_2%TYPE,
     dupe_data_supplier_ref_key_3     escribe.prescr_upd_xt.dupe_data_supplier_ref_key_3%TYPE,
     origin                           escribe.prescr_upd_xt.origin%TYPE,
     reserve_1                        escribe.prescr_upd_xt.reserve_1%TYPE,
     previous_hcid                    escribe.prescr_upd_xt.previous_hcid%TYPE,
     replacement_hcid                 escribe.prescr_upd_xt.replacement_hcid%TYPE,
     hcid_dc_date                     escribe.prescr_upd_xt.hcid_dc_date%TYPE,
     nhin_deceased_flag               escribe.prescr_upd_xt.nhin_deceased_flag%TYPE,
     nhin_deceased_date               escribe.prescr_upd_xt.nhin_deceased_date%TYPE,
     replacement_dea_num              escribe.prescr_upd_xt.replacement_dea_num%TYPE,
     previous_dea_num                 escribe.prescr_upd_xt.previous_dea_num%TYPE,
     data_element_change_type         escribe.prescr_upd_xt.data_element_change_type%TYPE,
     email_address                    escribe.prescr_upd_xt.email_address%TYPE,
     filler_1                         escribe.prescr_upd_xt.filler_1%TYPE,
     pdx_reserve                      escribe.prescr_upd_xt.pdx_reserve%TYPE,
     reserved                         escribe.prescr_upd_xt.reserved%TYPE,
     state_license_1                  escribe.prescr_upd_xt.state_license_1%TYPE,
     licensing_state_1                escribe.prescr_upd_xt.licensing_state_1%TYPE,
     state_license_2                  escribe.prescr_upd_xt.state_license_2%TYPE,
     licensing_state_2                escribe.prescr_upd_xt.licensing_state_2%TYPE,
     state_license_3                  escribe.prescr_upd_xt.state_license_3%TYPE,
     licensing_state_3                escribe.prescr_upd_xt.licensing_state_3%TYPE,
     nhin_use                         escribe.prescr_upd_xt.nhin_use%TYPE,
     filler                           escribe.prescr_upd_xt.filler%TYPE
    );

TYPE rt_address                    IS RECORD
    (id                               escribe.address.id%TYPE,
     address_line_1                   escribe.address.address_line_1%TYPE,
     city                             escribe.address.city%TYPE,
     state                            escribe.address.state%TYPE,
     zip_code                         escribe.address.zip_code%TYPE,
     country                          escribe.address.country%TYPE,
     address_line_2                   escribe.address.address_line_2%TYPE,
     department_mail_stop             escribe.address.department_mail_stop%TYPE
    );

TYPE rt_prescriber                 IS RECORD
    (id                               escribe.nhin_prescriber.id%TYPE,
     nhin_com_id                      escribe.nhin_prescriber.nhin_com_id%TYPE,
     last_name                        escribe.nhin_prescriber.last_name%TYPE,
     first_name                       escribe.nhin_prescriber.first_name%TYPE,
     middle_name                      escribe.nhin_prescriber.middle_name%TYPE,
     name_suffix                      escribe.nhin_prescriber.name_suffix%TYPE,
     name_prefix                      escribe.nhin_prescriber.name_prefix%TYPE,
     hcid                             escribe.nhin_prescriber.hcid%TYPE,
     npi                              escribe.nhin_prescriber.npi%TYPE,
     dea_id                           escribe.nhin_prescriber.dea_id%TYPE,
     dea_status_code                  escribe.nhin_prescriber.dea_status_code%TYPE,
     daw                              escribe.nhin_prescriber.daw%TYPE,
     gender                           escribe.nhin_prescriber.gender%TYPE,
     birth_date                       escribe.nhin_prescriber.birth_date%TYPE,
     deactivation_date                escribe.nhin_prescriber.deactivation_date%TYPE,
     nhin_retire                      escribe.nhin_prescriber.nhin_retire%TYPE,
     nhin_deceased                    escribe.nhin_prescriber.nhin_deceased%TYPE,
     mobile_phone                     escribe.nhin_prescriber.mobile_phone%TYPE,
     pager                            escribe.nhin_prescriber.pager%TYPE,
     home_phone                       escribe.nhin_prescriber.home_phone%TYPE,
     probation                        escribe.nhin_prescriber.probation%TYPE,
     specialty                        escribe.nhin_prescriber.specialty%TYPE,
     degree_1                         escribe.nhin_prescriber.degree_1%TYPE,
     degree_2                         escribe.nhin_prescriber.degree_2%TYPE,
     upin                             escribe.nhin_prescriber.upin%TYPE,
     taxonomy_code_1                  escribe.nhin_prescriber.taxonomy_code_1%TYPE,
     taxonomy_code_2                  escribe.nhin_prescriber.taxonomy_code_2%TYPE,
     federal_tax_id                   escribe.nhin_prescriber.federal_tax_id%TYPE,
     ncpdp_id                         escribe.nhin_prescriber.ncpdp_id%TYPE,
     previous_hcid                    escribe.nhin_prescriber.previous_hcid%TYPE,
     medicare_id                      escribe.nhin_prescriber.medicare_id%TYPE,
     blue_cross_id                    escribe.nhin_prescriber.blue_cross_id%TYPE,
     blue_shield_id                   escribe.nhin_prescriber.blue_shield_id%TYPE,
     champus_id                       escribe.nhin_prescriber.champus_id%TYPE,
     nhin_id                          escribe.nhin_prescriber.nhin_id%TYPE,
     email_address                    escribe.nhin_prescriber.email_address%TYPE,
     verified                         escribe.nhin_prescriber.verified%TYPE,
     id_primary_clinic_link           escribe.nhin_prescriber.id_primary_clinic_link%TYPE,
     new_rx_email_address             escribe.nhin_prescriber.new_rx_email_address%TYPE,
     registration_date                escribe.nhin_prescriber.registration_date%TYPE,
     registration_pin                 escribe.nhin_prescriber.registration_pin%TYPE,
     verification_date                escribe.nhin_prescriber.verification_date%TYPE,
     id_registration_address          escribe.nhin_prescriber.id_registration_address%TYPE,
     id_billing_service               escribe.nhin_prescriber.id_billing_service%TYPE,
     terms_of_use_accepted            escribe.nhin_prescriber.terms_of_use_accepted%TYPE
    );

TYPE rt_clinic                     IS RECORD
    (id                               escribe.nhin_clinic.id%TYPE,
     nhin_com_clinic_id               escribe.nhin_clinic.nhin_com_clinic_id%TYPE,
     id_address                       escribe.nhin_clinic.id_address%TYPE,
     office_phone_1                   escribe.nhin_clinic.office_phone_1%TYPE,
     office_phone_2                   escribe.nhin_clinic.office_phone_2%TYPE,
     fax_phone                        escribe.nhin_clinic.fax_phone%TYPE,
     refill_phone                     escribe.nhin_clinic.refill_phone%TYPE,
     contact_pref                     escribe.nhin_clinic.contact_pref%TYPE,
     script_version                   escribe.nhin_clinic.script_version%TYPE,
     hin                              escribe.nhin_clinic.hin%TYPE,
     federal_tax_id                   escribe.nhin_clinic.federal_tax_id%TYPE,
     npi                              escribe.nhin_clinic.npi%TYPE,
     department_mail_stop             escribe.nhin_clinic.department_mail_stop%TYPE,
     clinic_name                      escribe.nhin_clinic.clinic_name%TYPE,
     contact_name                     escribe.nhin_clinic.contact_name%TYPE,
     department                       escribe.nhin_clinic.department%TYPE,
     deactivation_date                escribe.nhin_clinic.deactivation_date%TYPE
    );

TYPE rt_presr_clin_lnk             IS RECORD
    (id                               escribe.nhin_prescriber_clinic_link.id%TYPE,
     id_nhin_clinic                   escribe.nhin_prescriber_clinic_link.id_nhin_clinic%TYPE,
     id_nhin_prescriber               escribe.nhin_prescriber_clinic_link.id_nhin_prescriber%TYPE,
     deactivation_date                escribe.nhin_prescriber_clinic_link.deactivation_date%TYPE,
     supervising_pres_id              escribe.nhin_prescriber_clinic_link.supervising_pres_id%TYPE,
     office_phone                     escribe.nhin_prescriber_clinic_link.office_phone%TYPE,
     fax_phone                        escribe.nhin_prescriber_clinic_link.fax_phone%TYPE,
     refill_phone                     escribe.nhin_prescriber_clinic_link.refill_phone%TYPE,
     hcid                             escribe.nhin_prescriber_clinic_link.hcid%TYPE,
     hcidea_location                  escribe.nhin_prescriber_clinic_link.hcidea_location%TYPE,
     hin                              escribe.nhin_prescriber_clinic_link.hin%TYPE,
     federal_tax_id                   escribe.nhin_prescriber_clinic_link.federal_tax_id%TYPE,
     dea_id                           escribe.nhin_prescriber_clinic_link.dea_id%TYPE
    );

TYPE rt_presr_medicaid             IS RECORD
    (id                               escribe.prescriber_medicaid.id%TYPE,
     id_nhin_prescriber               escribe.prescriber_medicaid.id_nhin_prescriber%TYPE,
     state                            escribe.prescriber_medicaid.state%TYPE,
     medicaid_id                      escribe.prescriber_medicaid.medicaid_id%TYPE,
     deactivate_date                  escribe.prescriber_medicaid.deactivate_date%TYPE
    );

TYPE rt_presr_state                IS RECORD
    (id                               escribe.prescriber_state.id%TYPE,
     id_nhin_prescriber               escribe.prescriber_state.id_nhin_prescriber%TYPE,
     state                            escribe.prescriber_state.state%TYPE,
     state_license_id                 escribe.prescriber_state.state_license_id%TYPE,
     other_state_id_type              escribe.prescriber_state.other_state_id_type%TYPE,
     other_state_id                   escribe.prescriber_state.other_state_id%TYPE,
     deactivation_date                escribe.prescriber_state.deactivation_date%TYPE
    );

--------------------------------------------------------------------------------
-- Global Records
--------------------------------------------------------------------------------
rec_prescr_upd_xt                     rt_prescr_upd_xt;
rec_address                           rt_address;
rec_mailing_address                   rt_address;
rec_prescriber                        rt_prescriber;
rec_nhin_clinic                       rt_clinic;
rec_prescr_clnc_lnk                   rt_presr_clin_lnk;
rec_prescr_medicaid                   rt_presr_medicaid;
rec_prescr_state                      rt_presr_state;

--------------------------------------------------------------------------------
-- Global REF Cursors
--------------------------------------------------------------------------------
TYPE prescr_upd_xt_curtyp IS REF CURSOR
     RETURN escribe.prescr_upd_xt%ROWTYPE;

        PROCEDURE read_upd_xt;

        PROCEDURE main          (rec_prescr_upd_xt   IN  prescr_upd_xt_curtyp);

        PROCEDURE ins           (r_prescr_upd_xt     IN  rt_prescr_upd_xt);

        PROCEDURE addr_ins      (rec_address         IN  rt_address,
                                 new_address_id      OUT NUMBER);

        PROCEDURE prescr_ins    (rec_prescriber      IN  rt_prescriber,
                                 new_prescr_id       OUT NUMBER);

        PROCEDURE clinic_ins    (rec_nhin_clinic     IN  rt_clinic,
                                 new_clinic_id       OUT NUMBER);

        PROCEDURE cln_lnk_ins   (rec_prescr_clnc_lnk IN  rt_presr_clin_lnk);

        PROCEDURE medicaid_ins  (rec_prescr_medicaid IN  rt_presr_medicaid);

        PROCEDURE state_ins     (rec_prescr_state    IN  rt_presr_state);

        PROCEDURE audit_dat_ins (tbl_class_nam       IN  VARCHAR2,
                                 tbl_row_id          IN  NUMBER);

END prescr_pkg;
/
CREATE OR REPLACE PACKAGE BODY         ESCRIBE.PRESCR_PKG AS
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * NAME:        prescr_pkg
 * PURPOSE:     Define package body for
 *
 * LIMITATIONS: None
 * REVISIONS:
 * DATE         WHO         WHAT
 * 18-APR-07    C Walton
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
--------------------------------------------------------------------------------
-- Global Variables
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Primary and Foreign Key Id variables
--------------------------------------------------------------------------------
v_audit_dates_id                  escribe.audit_dates.id%TYPE;
v_audit_dates_tbl_class_nam       escribe.audit_dates.table_class_name%TYPE;
v_audit_dates_tbl_row_id          escribe.audit_dates.table_row_id%TYPE;
v_address_id                      escribe.address.id%TYPE;
v_prescriber_id                   escribe.nhin_prescriber.id%TYPE;
v_prescr_nhin_com_id              escribe.nhin_prescriber.nhin_com_id%TYPE;
v_nhin_clinic_id                  escribe.nhin_clinic.id%TYPE;
v_nhin_clinic_com_clnc_id         escribe.nhin_clinic.nhin_com_clinic_id%TYPE;
v_nhin_clinic_id_address          escribe.nhin_clinic.id_address%TYPE;
v_prescr_clnc_lnk_id              escribe.nhin_prescriber_clinic_link.id%TYPE;
v_prescr_clnc_lnk_id_clinic       escribe.nhin_prescriber_clinic_link.id_nhin_clinic%TYPE;
v_prescr_clnc_lnk_id_prescr       escribe.nhin_prescriber_clinic_link.id_nhin_prescriber%TYPE;
v_prescr_medicaid_id              escribe.prescriber_medicaid.id%TYPE;
v_prescr_state_id                 escribe.prescriber_state.id%TYPE;
v_mailing_address_id              escribe.address.id%TYPE;
v_fk_id_nhin_prescriber           escribe.nhin_prescriber.hcid%TYPE;

--------------------------------------------------------------------------------
-- Prescriber Special Handling variables
--------------------------------------------------------------------------------
v_prescr_probation                VARCHAR2(1);
v_prescr_nhin_retire              DATE;
v_prescr_nhin_deceased            DATE;
v_prescr_gender                   escribe.nhin_prescriber.gender%TYPE;

--------------------------------------------------------------------------------
-- Global Cursors
--------------------------------------------------------------------------------
CURSOR cur_addr1 (add_line1 VARCHAR2,
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

CURSOR cur_addr2 (add_line1 VARCHAR2,
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

CURSOR cur_addr3 (add_line1 VARCHAR2,
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

CURSOR cur_addr4 (add_line1 VARCHAR2,
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

CURSOR cur_clinic1 (clin_name VARCHAR2,
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

CURSOR cur_clinic2 (clin_name VARCHAR2,
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

CURSOR cur_clinic3 (clin_name VARCHAR2,
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

CURSOR cur_clinic4 (clin_name VARCHAR2,
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

CURSOR cur_clinic5 (add_line1 VARCHAR2,
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

CURSOR cur_clinic6 (add_line1 VARCHAR2,
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

CURSOR cur_clinic7 (add_line1 VARCHAR2,
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

CURSOR cur_clinic8 (add_line1 VARCHAR2,
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

CURSOR cur_prescr_hcid (hcid_ident VARCHAR2)
    IS SELECT id
         FROM escribe.nhin_prescriber
        WHERE hcid = hcid_ident;

CURSOR cur_prescr_hcid_loc (hcid_ident VARCHAR2, hcid_loc NUMBER)
    IS SELECT id
         FROM escribe.nhin_prescriber_clinic_link
        WHERE hcid            = hcid_ident
          AND hcidea_location = TO_CHAR(hcid_loc);

--------------------------------------------------------------------------------
-- Error Handling variables
--------------------------------------------------------------------------------
err_loc                           NUMBER(3,1);
err_value                         VARCHAR2(10);
err_msg                           VARCHAR2(500);

e_custom_exception                EXCEPTION;
  PRAGMA exception_init(e_custom_exception, -20001);

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * NAME:        read_upd_xt
 * PURPOSE:     This procedure is called within the package to
 *
 * LIMITATIONS: None
 * REVISIONS:
 * DATE         WHO         WHAT
 * 18-APR-07    C Walton
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
PROCEDURE read_upd_xt IS

c_proc    VARCHAR2(30) := 'read_upd_xt';

v_rowcnt  NUMBER;

--------------------------------------------------------------------------------
-- Global REF Cursor
--------------------------------------------------------------------------------
cur_prescr_upd_xt                      prescr_upd_xt_curtyp;

BEGIN
      DBMS_OUTPUT.ENABLE (1000000);

      prescr_pkg.err_loc := 1;

      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

      OPEN cur_prescr_upd_xt FOR SELECT *
                                   FROM escribe.prescr_upd_xt
                                  WHERE phys_country_code IS NOT NULL
                                  ORDER BY date_last_change,
                                           update_record_type_code,
                                           last_name,
                                           first_name,
                                           middle_name_initial,
                                           hcid_identifier,
                                           hcid_location_code,
                                           organization_name,
                                           phys_address_line_1,
                                           phys_address_line_2,
                                           phys_suite_apartment_num,
                                           department_mail_stop,
                                           phys_city_name,
                                           phys_state_province_code,
                                           phys_zip_postal_zone,
                                           phys_country_code;

      v_rowcnt := SQL%ROWCOUNT;

      -- DBMS_OUTPUT.PUT_LINE ('Row Count from read_upd_xt ('||v_rowcnt||');');

      prescr_pkg.main(cur_prescr_upd_xt);

EXCEPTION
WHEN e_custom_exception THEN
     prescr_pkg.err_msg := 'Custom Error Occurred';

WHEN OTHERS THEN
     prescr_pkg.err_msg := ' Unhandled Error Occurred: '||SQLERRM||
                           ' in escribe.prescr_pkg in proc '||c_proc||
                           ' at location ('||TO_CHAR(err_loc)||')';
     raise_application_error(-20001,err_msg);

END read_upd_xt;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * NAME:        main
 * PURPOSE:     This procedure is called within the package to
 *
 * LIMITATIONS: None
 * REVISIONS:
 * DATE         WHO         WHAT
 * 18-APR-07    C Walton
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
PROCEDURE main(rec_prescr_upd_xt IN prescr_upd_xt_curtyp) IS

c_proc    VARCHAR2(30) := 'main';

v_cnt     NUMBER(6)    := 0;

r_prescr_upd_xt                   rt_prescr_upd_xt;

BEGIN
      prescr_pkg.err_loc := 0;

      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

      LOOP
           FETCH rec_prescr_upd_xt INTO r_prescr_upd_xt;

           v_cnt := v_cnt + 1;

           v_audit_dates_id            := NULL;
           v_audit_dates_tbl_class_nam := NULL;
           v_audit_dates_tbl_row_id    := NULL;
           v_address_id                := NULL;
           v_prescriber_id             := NULL;
           v_prescr_nhin_com_id        := NULL;
           v_nhin_clinic_id            := NULL;
           v_nhin_clinic_com_clnc_id   := NULL;
           v_nhin_clinic_id_address    := NULL;
           v_prescr_clnc_lnk_id        := NULL;
           v_prescr_clnc_lnk_id_clinic := NULL;
           v_prescr_clnc_lnk_id_prescr := NULL;
           v_prescr_medicaid_id        := NULL;
           v_prescr_state_id           := NULL;
           v_mailing_address_id        := NULL;
           v_fk_id_nhin_prescriber     := NULL;
           v_prescr_probation          := NULL;
           v_prescr_nhin_retire        := NULL;
           v_prescr_nhin_deceased      := NULL;
           v_prescr_gender             := NULL;

                 -- DBMS_OUTPUT.PUT_LINE ('Main('||v_cnt||'): '||
                 --                        r_prescr_upd_xt.dea_registration_num||' '||
                 --                        r_prescr_upd_xt.last_name||' '||
                 --                        r_prescr_upd_xt.first_name);

                 EXIT WHEN rec_prescr_upd_xt%NOTFOUND;

                 CASE
                      WHEN r_prescr_upd_xt.update_record_type_code = '1'
                           THEN
                                prescr_pkg.err_loc := 1;

                                -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                                prescr_pkg.ins(r_prescr_upd_xt);

                      WHEN r_prescr_upd_xt.update_record_type_code = '2'
                           THEN
                                /*-------------------------------*
                                 | Substitute Insert Processing  |
                                 |      until Update is defined. |
                                 *-------------------------------*/

                                prescr_pkg.err_loc := 2;

                                -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                                prescr_pkg.ins(r_prescr_upd_xt);

                                --  prescr_pkg.upd(r_prescr_upd_xt);
                      ELSE
                                /*-------------------------------*
                                 | Substitute NULL Processing    |
                                 |      until Delete is defined. |
                                 *-------------------------------*/

                                NULL;

                                --  prescr_pkg.del(r_prescr_upd_xt);
                 END CASE;

      END LOOP;

EXCEPTION
WHEN e_custom_exception THEN
     prescr_pkg.err_msg := 'Custom Error Occurred';

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     INSERT INTO prescriber_update_error VALUES r_prescr_upd_xt;

     COMMIT;

WHEN OTHERS THEN
     prescr_pkg.err_msg := ' Unhandled Error Occurred: '||SQLERRM||
                           ' in escribe.prescr_pkg in proc '||c_proc||
                           ' at location ('||TO_CHAR(err_loc)||')';

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     INSERT INTO prescriber_update_error VALUES r_prescr_upd_xt;

     COMMIT;

     raise_application_error(-20001,err_msg);

END main;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * NAME:        ins
 * PURPOSE:
 *
 * LIMITATIONS: None
 * REVISIONS:
 * DATE         WHO         WHAT
 * 18-APR-07    C Walton
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
PROCEDURE ins(r_prescr_upd_xt IN rt_prescr_upd_xt) IS

c_proc    VARCHAR2(30) := 'ins';

v_cnt     NUMBER(6);

v_attr    VARCHAR2(80);

rec_address                       rt_address;
rec_mailing_address               rt_address;
rec_prescriber                    rt_prescriber;
rec_nhin_clinic                   rt_clinic;
rec_prescr_clnc_lnk               rt_presr_clin_lnk;
rec_prescr_medicaid               rt_presr_medicaid;
rec_prescr_state                  rt_presr_state;

BEGIN
       prescr_pkg.err_loc  := 1;

       -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

       v_prescr_clnc_lnk_id_clinic := NULL;
       v_prescr_clnc_lnk_id_prescr := NULL;

      /*-------------------------------------------------------------------*
       | Build the Address Record for Insertion.                           |
       *-------------------------------------------------------------------*/

       rec_address.address_line_1        := r_prescr_upd_xt.phys_address_line_1;
       rec_address.address_line_2        := r_prescr_upd_xt.phys_address_line_2 ||
                                            r_prescr_upd_xt.phys_suite_apartment_num;
       rec_address.department_mail_stop  := r_prescr_upd_xt.department_mail_stop;
       rec_address.city                  := r_prescr_upd_xt.phys_city_name;
       rec_address.state                 := r_prescr_upd_xt.phys_state_province_code;
       rec_address.zip_code              := r_prescr_upd_xt.phys_zip_postal_zone;
       rec_address.country               := r_prescr_upd_xt.phys_country_code;

       prescr_pkg.err_loc  := 2;

       -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

      /*-------------------------------------------------------------------*
       | Build the Prescriber Record for Insertion.                        |
       *-------------------------------------------------------------------*/

       IF cur_prescr_hcid%ISOPEN
          THEN
               CLOSE cur_prescr_hcid;

               OPEN cur_prescr_hcid(r_prescr_upd_xt.hcid_identifier);
          ELSE
               OPEN cur_prescr_hcid(r_prescr_upd_xt.hcid_identifier);
       END IF;

       -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||' '||
       --                       r_prescr_upd_xt.hcid_identifier||' '||
       --                       r_prescr_upd_xt.last_name||' '||
       --                       r_prescr_upd_xt.first_name);

       FETCH cur_prescr_hcid INTO v_prescriber_id;

       IF cur_prescr_hcid%FOUND

          THEN
               prescr_pkg.err_loc  := 2.1;

               FETCH cur_prescr_hcid INTO v_prescr_clnc_lnk_id_prescr;

               -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
               --                       ' Prescr ID found: '||v_prescriber_id);

          ELSE
               CASE
                    /*--------------------------------------------------*
                     | Decode DEA Drug Schedule Code to Probation Code. |
                     *--------------------------------------------------*/

                    WHEN r_prescr_upd_xt.dea_drug_schedule     LIKE '%2%'
                         THEN v_prescr_probation := NULL;
                    WHEN r_prescr_upd_xt.dea_drug_schedule NOT LIKE '%5%'
                         THEN v_prescr_probation := '5';
                    WHEN r_prescr_upd_xt.dea_drug_schedule NOT LIKE '%4%'
                         THEN v_prescr_probation := '4';
                    WHEN r_prescr_upd_xt.dea_drug_schedule NOT LIKE '%3%'
                         THEN v_prescr_probation := '3';
                    WHEN r_prescr_upd_xt.dea_drug_schedule NOT LIKE '%2%'
                         THEN v_prescr_probation := '2';
                    ELSE v_prescr_probation := NULL;

               END CASE;

               prescr_pkg.err_loc  := 2.2;

               -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

               CASE r_prescr_upd_xt.retire_date
                    /*----------------------------------------------------*
                     | Convert NHIN Retire value to NULL or DATE value.   |
                     *----------------------------------------------------*/

                    WHEN 0    THEN v_prescr_nhin_retire   := NULL;
                    WHEN NULL THEN v_prescr_nhin_retire   := NULL;
                    ELSE v_prescr_nhin_retire :=
                         TO_DATE(r_prescr_upd_xt.retire_date,'YYYYMMDD');
               END CASE;

               prescr_pkg.err_loc  := 2.3;

               -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

               CASE r_prescr_upd_xt.nhin_deceased_date
                    /*----------------------------------------------------*
                     | Convert NHIN Deceased value to NULL or DATE value. |
                     *----------------------------------------------------*/

                    WHEN 0    THEN v_prescr_nhin_deceased := NULL;
                    WHEN NULL THEN v_prescr_nhin_deceased := NULL;
                    ELSE v_prescr_nhin_deceased :=
                         TO_DATE(r_prescr_upd_xt.nhin_deceased_date,'YYYYMMDD');
               END CASE;

               CASE r_prescr_upd_xt.gender_code
                    /*--------------------------------------------------*
                     | Decode Gender Code to Appropriate Code.          |
                     *--------------------------------------------------*/

                    WHEN 'M'  THEN v_prescr_gender := r_prescr_upd_xt.gender_code;
                    WHEN 'F'  THEN v_prescr_gender := r_prescr_upd_xt.gender_code;
                    ELSE           v_prescr_gender := NULL;
               END CASE;

               rec_prescriber.last_name            := r_prescr_upd_xt.last_name;
               rec_prescriber.first_name           := r_prescr_upd_xt.first_name;
               rec_prescriber.middle_name          := r_prescr_upd_xt.middle_name_initial;
               rec_prescriber.hcid                 := r_prescr_upd_xt.hcid_identifier;
               rec_prescriber.npi                  := r_prescr_upd_xt.npi;
               rec_prescriber.dea_id               := r_prescr_upd_xt.dea_registration_num;
               rec_prescriber.dea_status_code      := r_prescr_upd_xt.dea_status_code;
               rec_prescriber.gender               := v_prescr_gender;
               rec_prescriber.nhin_retire          := v_prescr_nhin_retire;
               rec_prescriber.nhin_deceased        := v_prescr_nhin_deceased;
               rec_prescriber.probation            := v_prescr_probation;
               rec_prescriber.degree_1             := r_prescr_upd_xt.prime_degree;
               rec_prescriber.degree_2             := r_prescr_upd_xt.second_degree;
               rec_prescriber.upin                 := r_prescr_upd_xt.upin_num;
               rec_prescriber.taxonomy_code_1      := r_prescr_upd_xt.prime_taxonomy_code;
               rec_prescriber.taxonomy_code_2      := r_prescr_upd_xt.second_taxonomy_code;
               rec_prescriber.ncpdp_id             := r_prescr_upd_xt.ncpdp_provider_id_num;
               rec_prescriber.nhin_id              := r_prescr_upd_xt.nhin_provider_id;
               rec_prescriber.email_address        := r_prescr_upd_xt.email_address;

               -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
               --                       ' Prescr Insertion: '||
               --                       rec_prescriber.hcid||' '||
               --                       rec_prescriber.last_name||' '||
               --                       rec_prescriber.first_name);

               prescr_ins(rec_prescriber,
                          v_prescr_clnc_lnk_id_prescr
                         );

       END IF;

       prescr_pkg.err_loc  := 3;

       -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

       CASE
            WHEN
                 /*-------------------------------------------------------*
                  | Record HAS Address_line_2+Suite AND Mail Stop.        |
                  *-------------------------------------------------------*/

                 r_prescr_upd_xt.phys_address_line_2||
                 r_prescr_upd_xt.phys_suite_apartment_num IS NOT NULL AND
                 r_prescr_upd_xt.department_mail_stop     IS NOT NULL

                 THEN

                      prescr_pkg.err_loc  := 3.1;

                      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                      IF cur_addr1%ISOPEN
                         THEN
                              CLOSE cur_addr1;
                      END IF;

                      OPEN cur_addr1(r_prescr_upd_xt.phys_address_line_1,
                                     r_prescr_upd_xt.phys_address_line_2,
                                     r_prescr_upd_xt.phys_suite_apartment_num,
                                     r_prescr_upd_xt.department_mail_stop,
                                     r_prescr_upd_xt.phys_city_name,
                                     r_prescr_upd_xt.phys_state_province_code,
                                     r_prescr_upd_xt.phys_zip_postal_zone,
                                     r_prescr_upd_xt.phys_country_code
                                    );

                      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||' '||
                      --                       r_prescr_upd_xt.hcid_identifier||' '||
                      --                       r_prescr_upd_xt.last_name||' '||
                      --                       r_prescr_upd_xt.first_name);

                      FETCH cur_addr1 INTO v_nhin_clinic_id_address;

                      IF cur_addr1%FOUND
                         THEN
                              -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
                              --                       ' Address ID found: '||
                              --                       v_nhin_clinic_id_address);
                              NULL;
                         ELSE
                              addr_ins(rec_address, v_nhin_clinic_id_address);

                      END IF;

                      CLOSE cur_addr1;
            WHEN
                 /*-------------------------------------------------------*
                  | Record HAS Address_line_2+Suite BUT NO Mail Stop.     |
                  *-------------------------------------------------------*/

                 r_prescr_upd_xt.phys_address_line_2||
                 r_prescr_upd_xt.phys_suite_apartment_num IS NOT NULL AND
                 r_prescr_upd_xt.department_mail_stop     IS     NULL
                 THEN

                      prescr_pkg.err_loc  := 3.2;

                      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                      IF cur_addr2%ISOPEN
                         THEN
                              CLOSE cur_addr2;
                      END IF;

                      OPEN cur_addr2(r_prescr_upd_xt.phys_address_line_1,
                                     r_prescr_upd_xt.phys_address_line_2,
                                     r_prescr_upd_xt.phys_suite_apartment_num,
                                     r_prescr_upd_xt.phys_city_name,
                                     r_prescr_upd_xt.phys_state_province_code,
                                     r_prescr_upd_xt.phys_zip_postal_zone,
                                     r_prescr_upd_xt.phys_country_code
                                    );

                      FETCH cur_addr2 INTO v_nhin_clinic_id_address;

                      IF cur_addr2%FOUND
                         THEN
                              -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
                              --                       ' Address ID found: '||
                              --                       v_nhin_clinic_id_address);
                              NULL;
                         ELSE
                              addr_ins(rec_address, v_nhin_clinic_id_address);

                      END IF;

                      CLOSE cur_addr2;
            WHEN
                 /*-------------------------------------------------------*
                  | Record HAS NO Address_line_2+Suite BUT HAS Mail Stop. |
                  *-------------------------------------------------------*/

                 r_prescr_upd_xt.phys_address_line_2||
                 r_prescr_upd_xt.phys_suite_apartment_num IS     NULL AND
                 r_prescr_upd_xt.department_mail_stop     IS NOT NULL
                 THEN

                      prescr_pkg.err_loc  := 3.3;

                      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                      IF cur_addr3%ISOPEN
                         THEN
                              CLOSE cur_addr3;
                      END IF;

                      OPEN cur_addr3(r_prescr_upd_xt.phys_address_line_1,
                                     r_prescr_upd_xt.department_mail_stop,
                                     r_prescr_upd_xt.phys_city_name,
                                     r_prescr_upd_xt.phys_state_province_code,
                                     r_prescr_upd_xt.phys_zip_postal_zone,
                                     r_prescr_upd_xt.phys_country_code
                                    );

                      FETCH cur_addr3 INTO v_nhin_clinic_id_address;

                      IF cur_addr3%FOUND
                         THEN
                              -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
                              --                       ' Address ID found: '||
                              --                       v_nhin_clinic_id_address);
                              NULL;
                         ELSE
                              addr_ins(rec_address, v_nhin_clinic_id_address);

                      END IF;

                      CLOSE cur_addr3;
            ELSE
                 /*-------------------------------------------------------*
                  | Record HAS NO Address_line_2+Suite OR Mail Stop.      |
                  *-------------------------------------------------------*/

                      prescr_pkg.err_loc  := 3.4;

                      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                      IF cur_addr4%ISOPEN
                         THEN
                              CLOSE cur_addr4;
                      END IF;

                      OPEN cur_addr4(r_prescr_upd_xt.phys_address_line_1,
                                     r_prescr_upd_xt.phys_city_name,
                                     r_prescr_upd_xt.phys_state_province_code,
                                     r_prescr_upd_xt.phys_zip_postal_zone,
                                     r_prescr_upd_xt.phys_country_code
                                    );

                      FETCH cur_addr4 INTO v_nhin_clinic_id_address;

                      IF cur_addr4%FOUND
                         THEN
                              -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
                              --                       ' Address ID found: '||
                              --                       v_nhin_clinic_id_address);
                              NULL;
                         ELSE
                              addr_ins(rec_address, v_nhin_clinic_id_address);

                      END IF;

                      CLOSE cur_addr4;
       END CASE;

       prescr_pkg.err_loc  := 4;

       -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

      /*-------------------------------------------------------------------*
       | Build the Clinic Record for Insertion.                            |
       *-------------------------------------------------------------------*/

       rec_nhin_clinic.id_address           := v_nhin_clinic_id_address;
       rec_nhin_clinic.office_phone_1       := r_prescr_upd_xt.prime_phone_num;
       rec_nhin_clinic.office_phone_2       := r_prescr_upd_xt.second_phone_num;
       rec_nhin_clinic.refill_phone         := r_prescr_upd_xt.refill_phone_num;
       rec_nhin_clinic.hin                  := r_prescr_upd_xt.hin_num;
       rec_nhin_clinic.department_mail_stop := r_prescr_upd_xt.department_mail_stop;
       rec_nhin_clinic.clinic_name          := r_prescr_upd_xt.organization_name;

       -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||' '||
       --                       r_prescr_upd_xt.hcid_identifier||' '||
       --                       r_prescr_upd_xt.last_name||' '||
       --                       r_prescr_upd_xt.first_name);

       CASE
            WHEN
                 /*---------------------------------------------------------*
                  | Record HAS Org AND Address_line_2+Suite AND Mail Stop.  |
                  *---------------------------------------------------------*/

                 r_prescr_upd_xt.organization_name        IS NOT NULL AND
                 r_prescr_upd_xt.phys_address_line_2||
                 r_prescr_upd_xt.phys_suite_apartment_num IS NOT NULL AND
                 r_prescr_upd_xt.department_mail_stop     IS NOT NULL

                 THEN

                      prescr_pkg.err_loc  := 4.1;

                      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                      IF cur_clinic1%ISOPEN
                         THEN
                              CLOSE cur_clinic1;
                      END IF;

                      OPEN cur_clinic1 (r_prescr_upd_xt.organization_name,
                                        r_prescr_upd_xt.phys_address_line_1,
                                        r_prescr_upd_xt.phys_address_line_2,
                                        r_prescr_upd_xt.phys_suite_apartment_num,
                                        r_prescr_upd_xt.department_mail_stop,
                                        r_prescr_upd_xt.phys_city_name,
                                        r_prescr_upd_xt.phys_state_province_code,
                                        r_prescr_upd_xt.phys_zip_postal_zone,
                                        r_prescr_upd_xt.phys_country_code
                                       );

                      FETCH cur_clinic1 INTO v_prescr_clnc_lnk_id_clinic;

                      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||' '||
                      --                       r_prescr_upd_xt.hcid_identifier||' '||
                      --                       r_prescr_upd_xt.last_name||' '||
                      --                       r_prescr_upd_xt.first_name);

                      IF cur_clinic1%FOUND
                         THEN
                              -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
                              --                       ' Clinic ID found: '||
                              --                       v_prescr_clnc_lnk_id_clinic);
                              NULL;
                         ELSE
                              clinic_ins(rec_nhin_clinic,
                                         v_prescr_clnc_lnk_id_clinic
                                        );

                      END IF;

                      CLOSE cur_clinic1;
            WHEN
                 /*---------------------------------------------------------*
                  | Record HAS Org AND Address_line_2+Suite NO Mail Stop.   |
                  *---------------------------------------------------------*/

                 r_prescr_upd_xt.organization_name        IS NOT NULL AND
                 r_prescr_upd_xt.phys_address_line_2||
                 r_prescr_upd_xt.phys_suite_apartment_num IS NOT NULL AND
                 r_prescr_upd_xt.department_mail_stop     IS     NULL

                 THEN

                      prescr_pkg.err_loc  := 4.2;

                      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                      IF cur_clinic2%ISOPEN
                         THEN
                              CLOSE cur_clinic2;
                      END IF;

                      OPEN cur_clinic2 (r_prescr_upd_xt.organization_name,
                                        r_prescr_upd_xt.phys_address_line_1,
                                        r_prescr_upd_xt.phys_address_line_2,
                                        r_prescr_upd_xt.phys_suite_apartment_num,
                                        r_prescr_upd_xt.phys_city_name,
                                        r_prescr_upd_xt.phys_state_province_code,
                                        r_prescr_upd_xt.phys_zip_postal_zone,
                                        r_prescr_upd_xt.phys_country_code
                                       );

                      FETCH cur_clinic2 INTO v_prescr_clnc_lnk_id_clinic;

                      IF cur_clinic2%FOUND
                         THEN
                              -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
                              --                       ' Clinic ID found: '||
                              --                       v_prescr_clnc_lnk_id_clinic);
                              NULL;
                         ELSE
                              clinic_ins(rec_nhin_clinic,
                                         v_prescr_clnc_lnk_id_clinic
                                        );

                      END IF;

                      CLOSE cur_clinic2;
            WHEN
                 /*---------------------------------------------------------*
                  | Record HAS Org NO Address_line_2+Suite HAS Mail Stop.   |
                  *---------------------------------------------------------*/

                 r_prescr_upd_xt.organization_name        IS NOT NULL AND
                 r_prescr_upd_xt.phys_address_line_2||
                 r_prescr_upd_xt.phys_suite_apartment_num IS     NULL AND
                 r_prescr_upd_xt.department_mail_stop     IS NOT NULL

                 THEN

                      prescr_pkg.err_loc  := 4.3;

                      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                      IF cur_clinic3%ISOPEN
                         THEN
                              CLOSE cur_clinic3;
                      END IF;

                      OPEN cur_clinic3 (r_prescr_upd_xt.organization_name,
                                        r_prescr_upd_xt.phys_address_line_1,
                                        r_prescr_upd_xt.department_mail_stop,
                                        r_prescr_upd_xt.phys_city_name,
                                        r_prescr_upd_xt.phys_state_province_code,
                                        r_prescr_upd_xt.phys_zip_postal_zone,
                                        r_prescr_upd_xt.phys_country_code
                                       );

                      FETCH cur_clinic3 INTO v_prescr_clnc_lnk_id_clinic;

                      IF cur_clinic3%FOUND
                         THEN
                              -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
                              --                       ' Clinic ID found: '||
                              --                       v_prescr_clnc_lnk_id_clinic);
                              NULL;
                         ELSE
                              clinic_ins(rec_nhin_clinic,
                                         v_prescr_clnc_lnk_id_clinic
                                        );

                      END IF;

                      CLOSE cur_clinic3;
            WHEN
                 /*-------------------------------------------------------*
                  | Record HAS Org NO Address_line_2+Suite NO Mail Stop.  |
                  *-------------------------------------------------------*/

                 r_prescr_upd_xt.organization_name        IS NOT NULL AND
                 r_prescr_upd_xt.phys_address_line_2||
                 r_prescr_upd_xt.phys_suite_apartment_num IS     NULL AND
                 r_prescr_upd_xt.department_mail_stop     IS     NULL

                 THEN

                      prescr_pkg.err_loc  := 4.4;

                      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                      IF cur_clinic4%ISOPEN
                         THEN
                              CLOSE cur_clinic4;
                      END IF;

                      OPEN cur_clinic4 (r_prescr_upd_xt.organization_name,
                                        r_prescr_upd_xt.phys_address_line_1,
                                        r_prescr_upd_xt.phys_city_name,
                                        r_prescr_upd_xt.phys_state_province_code,
                                        r_prescr_upd_xt.phys_zip_postal_zone,
                                        r_prescr_upd_xt.phys_country_code
                                       );

                      FETCH cur_clinic4 INTO v_prescr_clnc_lnk_id_clinic;

                      IF cur_clinic4%FOUND
                         THEN
                              -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
                              --                       ' Clinic ID found: '||
                              --                       v_prescr_clnc_lnk_id_clinic);
                              NULL;
                         ELSE
                              clinic_ins(rec_nhin_clinic,
                                         v_prescr_clnc_lnk_id_clinic
                                        );

                      END IF;

                      CLOSE cur_clinic4;
            WHEN
                 /*-------------------------------------------------------*
                  | Record HAS Org HAS Address_line_2+Suite NO Mail Stop. |
                  *-------------------------------------------------------*/

                 r_prescr_upd_xt.organization_name        IS     NULL AND
                 r_prescr_upd_xt.phys_address_line_2||
                 r_prescr_upd_xt.phys_suite_apartment_num IS NOT NULL AND
                 r_prescr_upd_xt.department_mail_stop     IS NOT NULL

                 THEN

                      prescr_pkg.err_loc  := 4.5;

                      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                      IF cur_clinic5%ISOPEN
                         THEN
                              CLOSE cur_clinic5;
                      END IF;

                      OPEN cur_clinic5 (r_prescr_upd_xt.phys_address_line_1,
                                        r_prescr_upd_xt.phys_address_line_2,
                                        r_prescr_upd_xt.phys_suite_apartment_num,
                                        r_prescr_upd_xt.department_mail_stop,
                                        r_prescr_upd_xt.phys_city_name,
                                        r_prescr_upd_xt.phys_state_province_code,
                                        r_prescr_upd_xt.phys_zip_postal_zone,
                                        r_prescr_upd_xt.phys_country_code
                                       );

                      FETCH cur_clinic5 INTO v_prescr_clnc_lnk_id_clinic;

                      IF cur_clinic5%FOUND
                         THEN
                              -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
                              --                       ' Clinic ID found: '||
                              --                       v_prescr_clnc_lnk_id_clinic);
                              NULL;
                         ELSE
                              clinic_ins(rec_nhin_clinic,
                                         v_prescr_clnc_lnk_id_clinic
                                        );

                      END IF;

                      CLOSE cur_clinic5;
            WHEN
                 /*----------------------------------------------------------*
                  | Record HAS NO Org HAS Address_line_2+Suite NO Mail Stop. |
                  *----------------------------------------------------------*/

                 r_prescr_upd_xt.organization_name        IS     NULL AND
                 r_prescr_upd_xt.phys_address_line_2||
                 r_prescr_upd_xt.phys_suite_apartment_num IS NOT NULL AND
                 r_prescr_upd_xt.department_mail_stop     IS     NULL

                 THEN

                      prescr_pkg.err_loc  := 4.6;

                      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                      IF cur_clinic6%ISOPEN
                         THEN
                              CLOSE cur_clinic6;
                      END IF;

                      OPEN cur_clinic6 (r_prescr_upd_xt.phys_address_line_1,
                                        r_prescr_upd_xt.phys_address_line_2,
                                        r_prescr_upd_xt.phys_suite_apartment_num,
                                        r_prescr_upd_xt.phys_city_name,
                                        r_prescr_upd_xt.phys_state_province_code,
                                        r_prescr_upd_xt.phys_zip_postal_zone,
                                        r_prescr_upd_xt.phys_country_code
                                       );

                      FETCH cur_clinic6 INTO v_prescr_clnc_lnk_id_clinic;

                      IF cur_clinic6%FOUND
                         THEN
                              -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
                              --                       ' Clinic ID found: '||
                              --                       v_prescr_clnc_lnk_id_clinic);
                              NULL;
                         ELSE
                              clinic_ins(rec_nhin_clinic,
                                         v_prescr_clnc_lnk_id_clinic
                                        );

                      END IF;

                      CLOSE cur_clinic6;
            WHEN
                 /*----------------------------------------------------------*
                  | Record HAS NO Org NO Address_line_2+Suite HAS Mail Stop. |
                  *----------------------------------------------------------*/

                 r_prescr_upd_xt.organization_name        IS     NULL AND
                 r_prescr_upd_xt.phys_address_line_2||
                 r_prescr_upd_xt.phys_suite_apartment_num IS     NULL AND
                 r_prescr_upd_xt.department_mail_stop     IS NOT NULL

                 THEN

                      prescr_pkg.err_loc  := 4.7;

                      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                      IF cur_clinic7%ISOPEN
                         THEN
                              CLOSE cur_clinic7;
                      END IF;

                      OPEN cur_clinic7 (r_prescr_upd_xt.phys_address_line_1,
                                        r_prescr_upd_xt.department_mail_stop,
                                        r_prescr_upd_xt.phys_city_name,
                                        r_prescr_upd_xt.phys_state_province_code,
                                        r_prescr_upd_xt.phys_zip_postal_zone,
                                        r_prescr_upd_xt.phys_country_code
                                       );

                      FETCH cur_clinic7 INTO v_prescr_clnc_lnk_id_clinic;

                      IF cur_clinic7%FOUND
                         THEN
                              -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
                              --                       ' Clinic ID found: '||
                              --                       v_prescr_clnc_lnk_id_clinic);
                              NULL;
                         ELSE
                              clinic_ins(rec_nhin_clinic,
                                         v_prescr_clnc_lnk_id_clinic
                                        );

                      END IF;

                      CLOSE cur_clinic7;
            ELSE
                 /*----------------------------------------------------------*
                  | Record HAS NO Org OR Address_line_2+Suite OR Mail Stop.  |
                  *----------------------------------------------------------*/

                      prescr_pkg.err_loc  := 4.8;

                      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                      IF cur_clinic8%ISOPEN
                         THEN
                              CLOSE cur_clinic8;
                      END IF;

                      OPEN cur_clinic8 (r_prescr_upd_xt.phys_address_line_1,
                                        r_prescr_upd_xt.phys_city_name,
                                        r_prescr_upd_xt.phys_state_province_code,
                                        r_prescr_upd_xt.phys_zip_postal_zone,
                                        r_prescr_upd_xt.phys_country_code
                                       );

                      FETCH cur_clinic8 INTO v_prescr_clnc_lnk_id_clinic;

                      IF cur_clinic8%FOUND
                         THEN
                              -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
                              --                       ' Clinic ID found: '||
                              --                       v_prescr_clnc_lnk_id_clinic);
                              NULL;
                         ELSE
                              clinic_ins(rec_nhin_clinic,
                                         v_prescr_clnc_lnk_id_clinic
                                        );

                      END IF;

                      CLOSE cur_clinic8;
       END CASE;

       prescr_pkg.err_loc  := 5;

       -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

      /*-------------------------------------------------------------------*
       | Build the Clinic LINK Record for Insertion.                       |
       *-------------------------------------------------------------------*/

       IF cur_prescr_hcid_loc%ISOPEN
          THEN
               CLOSE cur_prescr_hcid_loc;

               OPEN  cur_prescr_hcid_loc(r_prescr_upd_xt.hcid_identifier,
                                         r_prescr_upd_xt.hcid_location_code);
          ELSE
               OPEN  cur_prescr_hcid_loc(r_prescr_upd_xt.hcid_identifier,
                                         r_prescr_upd_xt.hcid_location_code);
       END IF;

       -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||' '||
       --                       r_prescr_upd_xt.hcid_identifier||' '||
       --                       r_prescr_upd_xt.last_name||' '||
       --                       r_prescr_upd_xt.first_name);

            FETCH cur_prescr_hcid_loc INTO v_prescr_clnc_lnk_id;

            IF cur_prescr_hcid_loc%FOUND
               THEN
                    NULL;
                    -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
                    --                       ' Clinic ID found: '||
                    --                       v_prescr_clnc_lnk_id_clinic);
               ELSE

                    IF v_prescr_clnc_lnk_id_prescr IS NULL
                       THEN
                            CLOSE cur_prescr_hcid;

                            prescr_pkg.err_loc  := 5.1;

                            -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                            OPEN cur_prescr_hcid(r_prescr_upd_xt.hcid_identifier);

                            FETCH cur_prescr_hcid INTO v_prescr_clnc_lnk_id_prescr;
                    END IF;

               rec_prescr_clnc_lnk.id_nhin_clinic     := v_prescr_clnc_lnk_id_clinic;
               rec_prescr_clnc_lnk.id_nhin_prescriber := v_prescr_clnc_lnk_id_prescr;

               rec_prescr_clnc_lnk.office_phone       := r_prescr_upd_xt.prime_phone_num;
               rec_prescr_clnc_lnk.fax_phone          := r_prescr_upd_xt.fax_num;
               rec_prescr_clnc_lnk.hcid               := r_prescr_upd_xt.hcid_identifier;
               rec_prescr_clnc_lnk.hcidea_location    := r_prescr_upd_xt.hcid_location_code;
               rec_prescr_clnc_lnk.hin                := r_prescr_upd_xt.hin_num;
               rec_prescr_clnc_lnk.dea_id             := r_prescr_upd_xt.dea_registration_num;

               cln_lnk_ins(rec_prescr_clnc_lnk);

            END IF;

       prescr_pkg.err_loc  := 6;

       -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

      /*-------------------------------------------------------------------*
       | Build the Medicaid Records for Insertion.                         |
       *-------------------------------------------------------------------*/

       IF cur_prescr_hcid%ISOPEN
          THEN
               CLOSE cur_prescr_hcid;

               prescr_pkg.err_loc  := 6.1;

               -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

               OPEN cur_prescr_hcid(r_prescr_upd_xt.hcid_identifier);
          ELSE
               prescr_pkg.err_loc  := 6.2;

               -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

               OPEN cur_prescr_hcid(r_prescr_upd_xt.hcid_identifier);
       END IF;

       FETCH cur_prescr_hcid INTO v_fk_id_nhin_prescriber;

       -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||' '||
       --                       r_prescr_upd_xt.hcid_identifier||' '||
       --                       r_prescr_upd_xt.last_name||' '||
       --                       r_prescr_upd_xt.first_name);

       IF r_prescr_upd_xt.state_code_prime_medicaid_id   IS NOT NULL AND
          r_prescr_upd_xt.prime_medicaid_id              IS NOT NULL
          THEN
               prescr_pkg.err_loc  := 6.3;

               -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

               rec_prescr_medicaid.id_nhin_prescriber := v_fk_id_nhin_prescriber;
               rec_prescr_medicaid.state              := r_prescr_upd_xt.state_code_prime_medicaid_id;
               rec_prescr_medicaid.medicaid_id        := r_prescr_upd_xt.prime_medicaid_id;

               medicaid_ins(rec_prescr_medicaid);
       END IF;

       IF r_prescr_upd_xt.state_code_second_medicaid_id  IS NOT NULL AND
          r_prescr_upd_xt.second_medicaid_id             IS NOT NULL
          THEN
               prescr_pkg.err_loc  := 6.4;

               -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

               rec_prescr_medicaid.id_nhin_prescriber := v_fk_id_nhin_prescriber;
               rec_prescr_medicaid.state              := r_prescr_upd_xt.state_code_second_medicaid_id;
               rec_prescr_medicaid.medicaid_id        := r_prescr_upd_xt.second_medicaid_id;

               medicaid_ins(rec_prescr_medicaid);
       END IF;

       IF r_prescr_upd_xt.state_code_third_medicaid_id   IS NOT NULL AND
          r_prescr_upd_xt.third_medicaid_id              IS NOT NULL
          THEN

               prescr_pkg.err_loc  := 6.5;

               -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

               rec_prescr_medicaid.id_nhin_prescriber := v_fk_id_nhin_prescriber;
               rec_prescr_medicaid.state              := r_prescr_upd_xt.state_code_third_medicaid_id;
               rec_prescr_medicaid.medicaid_id        := r_prescr_upd_xt.third_medicaid_id;

               medicaid_ins(rec_prescr_medicaid);
       END IF;

       prescr_pkg.err_loc  := 7;

       -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

           /*-------------------------------------------------------------------*
            | Build the State Records for Insertion.                            |
            *-------------------------------------------------------------------*/

            -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||' '||
            --                       r_prescr_upd_xt.hcid_identifier||' '||
            --                       r_prescr_upd_xt.last_name||' '||
            --                       r_prescr_upd_xt.first_name);

            IF r_prescr_upd_xt.licensing_state_1   IS NOT NULL AND
               r_prescr_upd_xt.state_license_1     IS NOT NULL
               THEN

               prescr_pkg.err_loc  := 7.1;

               -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                    rec_prescr_state.id_nhin_prescriber := v_fk_id_nhin_prescriber;
                    rec_prescr_state.state              := r_prescr_upd_xt.licensing_state_1;
                    rec_prescr_state.state_license_id   := r_prescr_upd_xt.state_license_1;

                    state_ins(rec_prescr_state);
            END IF;

            IF r_prescr_upd_xt.licensing_state_2   IS NOT NULL AND
               r_prescr_upd_xt.state_license_2     IS NOT NULL
               THEN

               prescr_pkg.err_loc  := 7.2;

               -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                    rec_prescr_state.id_nhin_prescriber := v_fk_id_nhin_prescriber;
                    rec_prescr_state.state              := r_prescr_upd_xt.licensing_state_2;
                    rec_prescr_state.state_license_id   := r_prescr_upd_xt.state_license_2;

                    state_ins(rec_prescr_state);
            END IF;

            IF r_prescr_upd_xt.licensing_state_3   IS NOT NULL AND
               r_prescr_upd_xt.state_license_3     IS NOT NULL
               THEN

               prescr_pkg.err_loc  := 7.3;

               -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc);

                    rec_prescr_state.id_nhin_prescriber := v_fk_id_nhin_prescriber;
                    rec_prescr_state.state              := r_prescr_upd_xt.licensing_state_3;
                    rec_prescr_state.state_license_id   := r_prescr_upd_xt.state_license_3;

                    state_ins(rec_prescr_state);
            END IF;

     COMMIT;

EXCEPTION
WHEN e_custom_exception THEN
     ROLLBACK;

     prescr_pkg.err_msg := 'Custom Error Occurred';

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     INSERT INTO prescriber_update_error VALUES r_prescr_upd_xt;

     COMMIT;

WHEN OTHERS THEN
     ROLLBACK;

     prescr_pkg.err_msg := ' Unhandled Error Occurred: '||SQLERRM||
                           ' in escribe.prescr_pkg in proc '||c_proc||
                           ' at location ('||TO_CHAR(err_loc)||')';

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     INSERT INTO prescriber_update_error VALUES r_prescr_upd_xt;

     raise_application_error(-20001,err_msg);

     COMMIT;

END ins;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * NAME:        upd
 * PURPOSE:
 *
 * LIMITATIONS: None
 * REVISIONS:
 * DATE         WHO         WHAT
 * 18-APR-07    C Walton
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
-- PROCEDURE upd(r_prescr_upd_xt IN rt_prescr_upd_xt) IS
--
-- c_proc    VARCHAR2(30) := 'upd';
--
-- BEGIN
--       prescr_pkg.err_loc  := 1;
--
--      <<some_loop_name>>
--      LOOP
--           prescr_pkg.err_loc := 2;
--
--
--      END LOOP some_loop_name;
--
-- EXCEPTION
-- WHEN e_custom_exception THEN
--      prescr_pkg.err_msg := 'Custom Error Occurred';
--
--      INSERT INTO prescriber_update_error VALUES r_prescr_upd_xt;
--
--      DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);
--
--      COMMIT;
--
-- WHEN OTHERS THEN
--      prescr_pkg.err_msg := ' Unhandled Error Occurred: '||SQLERRM||
--                            ' in escribe.prescr_pkg in proc '||c_proc||
--                            ' at location ('||TO_CHAR(err_loc)||')';
--
--      DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);
--
--      INSERT INTO prescriber_update_error VALUES r_prescr_upd_xt;
--
--      raise_application_error(-20001,err_msg);
--
--      COMMIT;
--
-- END upd;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * NAME:        del
 * PURPOSE:
 *
 * LIMITATIONS: None
 * REVISIONS:
 * DATE         WHO         WHAT
 * 18-APR-07    C Walton
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
-- PROCEDURE del(r_prescr_upd_xt IN rt_prescr_upd_xt) IS
--
-- c_proc    VARCHAR2(30) := 'del';
--
-- BEGIN
--
--       prescr_pkg.err_loc  := 1;
--
--       <<some_loop_name>>
--       LOOP
--            prescr_pkg.err_loc := 2;
--
--
--       END LOOP some_loop_name;
--  CLOSE prescr_pkg.<global_cursor_name>;
--
--  END IF;
--
--  CLOSE prescr_pkg.<global_cursor_name>;
--
-- EXCEPTION
-- WHEN e_custom_exception THEN
--      prescr_pkg.err_msg := 'Custom Error Occurred';
--
--      DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);
--
--      INSERT INTO prescriber_update_error VALUES r_prescr_upd_xt;
--
--      COMMIT;
--
-- WHEN OTHERS THEN
--      prescr_pkg.err_msg := ' Unhandled Error Occurred: '||SQLERRM||
--                            ' in escribe.prescr_pkg in proc '||c_proc||
--                            ' at location ('||TO_CHAR(err_loc)||')';
--
--      DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);
--
--      INSERT INTO prescriber_update_error VALUES r_prescr_upd_xt;
--
--      raise_application_error(-20001,err_msg);
--
--      COMMIT;
--
-- END del;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * NAME:        addr_ins
 * PURPOSE:
 *
 * LIMITATIONS: None
 * REVISIONS:
 * DATE         WHO         WHAT
 * 18-APR-07    C Walton
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
PROCEDURE addr_ins(rec_address    IN  rt_address,
                   new_address_id OUT NUMBER) IS

c_proc    VARCHAR2(30) := 'addr_ins';

BEGIN

      prescr_pkg.err_loc  := 1;

      SELECT address_id_seq.NEXTVAL
        INTO v_address_id
        FROM dual;

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
          VALUES (v_address_id,
                  rec_address.address_line_1,
                  rec_address.address_line_2,
                  rec_address.department_mail_stop,
                  rec_address.city,
                  rec_address.state,
                  rec_address.zip_code,
                  rec_address.country
                 );

      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
      --                       ' Input data from Addr_Ins(): '||
      --                        rec_address.address_line_1||' '||
      --                        rec_address.city||' '||
      --                        rec_address.state||' '||
      --                        rec_address.zip_code);

      prescr_pkg.audit_dat_ins('ADDRESS', v_address_id);

      new_address_id := v_address_id;

EXCEPTION
WHEN e_custom_exception THEN
     ROLLBACK;

     prescr_pkg.err_msg := 'Custom Error Occurred';

     INSERT INTO escribe.address_upd_err
                (id, address_line_1, address_line_2,
                 department_mail_stop, city, state,
                 zip_code, country)
         VALUES (v_address_id, rec_address.address_line_1, rec_address.address_line_2,
                 rec_address.department_mail_stop, rec_address.city, rec_address.state,
                 rec_address.zip_code, rec_address.country);

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     raise_application_error(-20001,err_msg);

     COMMIT;

WHEN OTHERS THEN
     ROLLBACK;

     prescr_pkg.err_msg := ' Unhandled Error Occurred: '||SQLERRM||
                           ' in escribe.prescr_pkg in proc '||c_proc||
                           ' at location ('||TO_CHAR(err_loc)||')';

     INSERT INTO escribe.address_upd_err
                (id, address_line_1, address_line_2,
                 department_mail_stop, city, state,
                 zip_code, country)
         VALUES (v_address_id, rec_address.address_line_1, rec_address.address_line_2,
                 rec_address.department_mail_stop, rec_address.city, rec_address.state,
                 rec_address.zip_code, rec_address.country);

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     raise_application_error(-20001,err_msg);

     COMMIT;

END addr_ins;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * NAME:        prescr_ins
 * PURPOSE:
 *
 * LIMITATIONS: None
 * REVISIONS:
 * DATE         WHO         WHAT
 * 18-APR-07    C Walton
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
PROCEDURE prescr_ins(rec_prescriber IN  rt_prescriber,
                     new_prescr_id  OUT NUMBER)  IS

c_proc    VARCHAR2(30) := 'prescr_ins';

BEGIN

      prescr_pkg.err_loc  := 1;

      SELECT nhin_prescr_id_seq.NEXTVAL
        INTO v_prescriber_id
        FROM dual;

      SELECT nhin_prescr_nhin_com_id_seq.NEXTVAL
        INTO v_prescr_nhin_com_id
        FROM dual;

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
          VALUES (v_prescriber_id,
                  v_prescr_nhin_com_id,
                  rec_prescriber.last_name,
                  rec_prescriber.first_name,
                  rec_prescriber.middle_name,
                  rec_prescriber.hcid,
                  rec_prescriber.npi,
                  rec_prescriber.dea_id,
                  rec_prescriber.dea_status_code,
                  rec_prescriber.gender,
                  rec_prescriber.nhin_retire,
                  rec_prescriber.nhin_deceased,
                  rec_prescriber.probation,
                  rec_prescriber.degree_1,
                  rec_prescriber.degree_2,
                  rec_prescriber.upin,
                  rec_prescriber.taxonomy_code_1,
                  rec_prescriber.taxonomy_code_2,
                  rec_prescriber.ncpdp_id,
                  rec_prescriber.nhin_id,
                  rec_prescriber.email_address
                 );

      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
      --                       ' Input data from Prescr_Ins(): '||
      --                        rec_prescriber.last_name||' '||
      --                        rec_prescriber.first_name||' '||
      --                        rec_prescriber.hcid||' '||
      --                        rec_prescriber.dea_id);

      prescr_pkg.audit_dat_ins('NHIN_PRESCRIBER', v_prescriber_id);

      new_prescr_id  := v_prescriber_id;

EXCEPTION
WHEN e_custom_exception THEN
     ROLLBACK;

     prescr_pkg.err_msg := 'Custom Error Occurred';

     INSERT INTO escribe.nhin_prescriber_upd_err
                (id, nhin_com_id, last_name, first_name, middle_name,
                 hcid, npi, dea_id, dea_status_code, gender,
                 nhin_retire, nhin_deceased, probation, degree_1, degree_2,
                 upin, taxonomy_code_1, taxonomy_code_2, ncpdp_id, nhin_id,
                 email_address
                )
         VALUES (v_prescriber_id, v_prescr_nhin_com_id,
                 rec_prescriber.last_name, rec_prescriber.first_name,
                 rec_prescriber.middle_name, rec_prescriber.hcid,
                 rec_prescriber.npi, rec_prescriber.dea_id,
                 rec_prescriber.dea_status_code, rec_prescriber.gender,
                 rec_prescriber.nhin_retire, rec_prescriber.nhin_deceased,
                 rec_prescriber.probation, rec_prescriber.degree_1,
                 rec_prescriber.degree_2, rec_prescriber.upin,
                 rec_prescriber.taxonomy_code_1, rec_prescriber.taxonomy_code_2,
                 rec_prescriber.ncpdp_id, rec_prescriber.nhin_id,
                 rec_prescriber.email_address
                );

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     raise_application_error(-20001,err_msg);

     COMMIT;

WHEN OTHERS THEN
     ROLLBACK;

     prescr_pkg.err_msg := ' Unhandled Error Occurred: '||SQLERRM||
                           ' in escribe.prescr_pkg in proc '||c_proc||
                           ' at location ('||TO_CHAR(err_loc)||')';

     INSERT INTO escribe.nhin_prescriber_upd_err
                (id, nhin_com_id, last_name, first_name, middle_name,
                 hcid, npi, dea_id, dea_status_code, gender,
                 nhin_retire, nhin_deceased, probation, degree_1, degree_2,
                 upin, taxonomy_code_1, taxonomy_code_2, ncpdp_id, nhin_id,
                 email_address
                )
         VALUES (v_prescriber_id, v_prescr_nhin_com_id,
                 rec_prescriber.last_name, rec_prescriber.first_name,
                 rec_prescriber.middle_name, rec_prescriber.hcid,
                 rec_prescriber.npi, rec_prescriber.dea_id,
                 rec_prescriber.dea_status_code, rec_prescriber.gender,
                 rec_prescriber.nhin_retire, rec_prescriber.nhin_deceased,
                 rec_prescriber.probation, rec_prescriber.degree_1,
                 rec_prescriber.degree_2, rec_prescriber.upin,
                 rec_prescriber.taxonomy_code_1, rec_prescriber.taxonomy_code_2,
                 rec_prescriber.ncpdp_id, rec_prescriber.nhin_id,
                 rec_prescriber.email_address
                );

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     raise_application_error(-20001,err_msg);

     COMMIT;

END prescr_ins;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * NAME:        clinic_ins
 * PURPOSE:
 *
 * LIMITATIONS: None
 * REVISIONS:
 * DATE         WHO         WHAT
 * 18-APR-07    C Walton
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
PROCEDURE clinic_ins(rec_nhin_clinic     IN  rt_clinic,
                     new_clinic_id       OUT NUMBER) IS

c_proc    VARCHAR2(30) := 'clinic_ins';

BEGIN

      prescr_pkg.err_loc  := 1;

      SELECT nhin_clinic_id_seq.NEXTVAL
        INTO v_nhin_clinic_id
        FROM dual;

      SELECT nhin_clinic_com_clinic_id_seq.NEXTVAL
        INTO v_nhin_clinic_com_clnc_id
        FROM dual;

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
          VALUES (v_nhin_clinic_id,
                  v_nhin_clinic_com_clnc_id,
                  rec_nhin_clinic.id_address,
                  rec_nhin_clinic.office_phone_1,
                  rec_nhin_clinic.office_phone_2,
                  rec_nhin_clinic.refill_phone,
                  rec_nhin_clinic.hin,
                  rec_nhin_clinic.department_mail_stop,
                  rec_nhin_clinic.clinic_name
                 );

      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
      --                       ' Input data from Clinic_Ins(): '||
      --                        rec_nhin_clinic.id_address||' '||
      --                        rec_nhin_clinic.office_phone_1||' '||
      --                        rec_nhin_clinic.refill_phone||' '||
      --                        rec_nhin_clinic.clinic_name);

      prescr_pkg.audit_dat_ins('NHIN_CLINIC', v_nhin_clinic_id);

      new_clinic_id := v_nhin_clinic_id;

EXCEPTION
WHEN e_custom_exception THEN
     ROLLBACK;

     prescr_pkg.err_msg := 'Custom Error Occurred';

     INSERT INTO escribe.nhin_clinic_upd_err
                (id, nhin_com_clinic_id, id_address,
                 office_phone_1, office_phone_2, refill_phone,
                 hin, department_mail_stop, clinic_name
                )
         VALUES (v_nhin_clinic_id, v_nhin_clinic_com_clnc_id,
                 rec_nhin_clinic.id_address, rec_nhin_clinic.office_phone_1,
                 rec_nhin_clinic.office_phone_2, rec_nhin_clinic.refill_phone,
                 rec_nhin_clinic.hin, rec_nhin_clinic.department_mail_stop,
                 rec_nhin_clinic.clinic_name
                );

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     raise_application_error(-20001,err_msg);

     COMMIT;

WHEN OTHERS THEN
     ROLLBACK;

     prescr_pkg.err_msg := ' Unhandled Error Occurred: '||SQLERRM||
                           ' in escribe.prescr_pkg in proc '||c_proc||
                           ' at location ('||TO_CHAR(err_loc)||')';

     INSERT INTO escribe.nhin_clinic_upd_err
                (id, nhin_com_clinic_id, id_address,
                 office_phone_1, office_phone_2, refill_phone,
                 hin, department_mail_stop, clinic_name
                )
         VALUES (v_nhin_clinic_id, v_nhin_clinic_com_clnc_id,
                 rec_nhin_clinic.id_address, rec_nhin_clinic.office_phone_1,
                 rec_nhin_clinic.office_phone_2, rec_nhin_clinic.refill_phone,
                 rec_nhin_clinic.hin, rec_nhin_clinic.department_mail_stop,
                 rec_nhin_clinic.clinic_name
                );

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     raise_application_error(-20001,err_msg);

     COMMIT;

END clinic_ins;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * NAME:        cln_lnk_ins
 * PURPOSE:
 *
 * LIMITATIONS: None
 * REVISIONS:
 * DATE         WHO         WHAT
 * 18-APR-07    C Walton
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
PROCEDURE cln_lnk_ins(rec_prescr_clnc_lnk IN rt_presr_clin_lnk) IS

c_proc    VARCHAR2(30) := 'cln_lnk_ins';

BEGIN

      prescr_pkg.err_loc  := 1;

      SELECT nhin_prescr_clinic_link_id_seq.NEXTVAL
        INTO v_prescr_clnc_lnk_id
        FROM dual;

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
          VALUES (v_prescr_clnc_lnk_id,
                  rec_prescr_clnc_lnk.id_nhin_clinic,
                  rec_prescr_clnc_lnk.id_nhin_prescriber,
                  rec_prescr_clnc_lnk.office_phone,
                  rec_prescr_clnc_lnk.fax_phone,
                  rec_prescr_clnc_lnk.hcid,
                  rec_prescr_clnc_lnk.hcidea_location,
                  rec_prescr_clnc_lnk.hin,
                  rec_prescr_clnc_lnk.dea_id
                 );

      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
      --                       ' Input data from Cln_Lnk_Ins(): '||
      --                        rec_prescr_clnc_lnk.id_nhin_clinic||' '||
      --                        rec_prescr_clnc_lnk.id_nhin_prescriber||' '||
      --                        rec_prescr_clnc_lnk.hcid||' '||
      --                        rec_prescr_clnc_lnk.hcidea_location||' '||
      --                        rec_prescr_clnc_lnk.dea_id);

      prescr_pkg.audit_dat_ins('NHIN_PRESCRIBER_CLINIC_LINK', v_prescr_clnc_lnk_id);

EXCEPTION
WHEN e_custom_exception THEN
     ROLLBACK;

     prescr_pkg.err_msg := 'Custom Error Occurred';

     INSERT INTO escribe.nhin_prescr_clinic_lnk_upd_err
                (id, id_nhin_clinic, id_nhin_prescriber,
                 office_phone, fax_phone, hcid,
                 hcidea_location, hin, dea_id
                )
         VALUES (v_prescr_clnc_lnk_id, rec_prescr_clnc_lnk.id_nhin_clinic,
                 rec_prescr_clnc_lnk.id_nhin_prescriber, rec_prescr_clnc_lnk.office_phone,
                 rec_prescr_clnc_lnk.fax_phone, rec_prescr_clnc_lnk.hcid,
                 rec_prescr_clnc_lnk.hcidea_location, rec_prescr_clnc_lnk.hin,
                 rec_prescr_clnc_lnk.dea_id
                );

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     raise_application_error(-20001,err_msg);

     COMMIT;

WHEN OTHERS THEN
     ROLLBACK;

     prescr_pkg.err_msg := ' Unhandled Error Occurred: '||SQLERRM||
                           ' in escribe.prescr_pkg in proc '||c_proc||
                           ' at location ('||TO_CHAR(err_loc)||')';

     INSERT INTO escribe.nhin_prescr_clinic_lnk_upd_err
                (id, id_nhin_clinic, id_nhin_prescriber,
                 office_phone, fax_phone, hcid,
                 hcidea_location, hin, dea_id
                )
         VALUES (v_prescr_clnc_lnk_id, rec_prescr_clnc_lnk.id_nhin_clinic,
                 rec_prescr_clnc_lnk.id_nhin_prescriber, rec_prescr_clnc_lnk.office_phone,
                 rec_prescr_clnc_lnk.fax_phone, rec_prescr_clnc_lnk.hcid,
                 rec_prescr_clnc_lnk.hcidea_location, rec_prescr_clnc_lnk.hin,
                 rec_prescr_clnc_lnk.dea_id
                );

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     raise_application_error(-20001,err_msg);

     COMMIT;

END cln_lnk_ins;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * NAME:        medicaid_ins
 * PURPOSE:
 *
 * LIMITATIONS: None
 * REVISIONS:
 * DATE         WHO         WHAT
 * 18-APR-07    C Walton
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
PROCEDURE medicaid_ins(rec_prescr_medicaid IN rt_presr_medicaid) IS

c_proc    VARCHAR2(30) := 'medicaid_ins';

BEGIN

      prescr_pkg.err_loc  := 1;

      SELECT prescr_medicaid_id_seq.NEXTVAL
        INTO v_prescr_medicaid_id
        FROM dual;

      INSERT INTO escribe.prescriber_medicaid
                 (id,
                  id_nhin_prescriber,
                  state,
                  medicaid_id
                  )
          VALUES (v_prescr_medicaid_id,
                  rec_prescr_medicaid.id_nhin_prescriber,
                  rec_prescr_medicaid.state,
                  rec_prescr_medicaid.medicaid_id
                 );

      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
      --                       ' Input data from Medicaid_Ins(): '||
      --                        rec_prescr_medicaid.id_nhin_prescriber||' '||
      --                        rec_prescr_medicaid.state||' '||
      --                        rec_prescr_medicaid.medicaid_id);

      prescr_pkg.audit_dat_ins('PRESCRIBER_MEDICAID', v_prescr_medicaid_id);

EXCEPTION
WHEN e_custom_exception THEN
     ROLLBACK;

     prescr_pkg.err_msg := 'Custom Error Occurred';

     INSERT INTO escribe.prescriber_medicaid_upd_err
                (id, id_nhin_prescriber, state, medicaid_id)
         VALUES (v_prescr_medicaid_id, rec_prescr_medicaid.id_nhin_prescriber,
                 rec_prescr_medicaid.state, rec_prescr_medicaid.medicaid_id
                );

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     raise_application_error(-20001,err_msg);

     COMMIT;

WHEN OTHERS THEN
     ROLLBACK;

     prescr_pkg.err_msg := ' Unhandled Error Occurred: '||SQLERRM||
                           ' in escribe.prescr_pkg in proc '||c_proc||
                           ' at location ('||TO_CHAR(err_loc)||')';

     INSERT INTO escribe.prescriber_medicaid_upd_err
                (id, id_nhin_prescriber, state, medicaid_id)
         VALUES (v_prescr_medicaid_id, rec_prescr_medicaid.id_nhin_prescriber,
                 rec_prescr_medicaid.state, rec_prescr_medicaid.medicaid_id
                );

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     raise_application_error(-20001,err_msg);

     COMMIT;

END medicaid_ins;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * NAME:        state_ins
 * PURPOSE:
 *
 * LIMITATIONS: None
 * REVISIONS:
 * DATE         WHO         WHAT
 * 18-APR-07    C Walton
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
PROCEDURE state_ins(rec_prescr_state IN rt_presr_state) IS

c_proc    VARCHAR2(30) := 'state_ins';

BEGIN

      prescr_pkg.err_loc  := 1;

      SELECT prescr_state_id_seq.NEXTVAL
        INTO v_prescr_state_id
        FROM dual;

      INSERT INTO escribe.prescriber_state
                 (id,
                  id_nhin_prescriber,
                  state,
                  state_license_id
                 )
          VALUES (v_prescr_state_id,
                  rec_prescr_state.id_nhin_prescriber,
                  rec_prescr_state.state,
                  rec_prescr_state.state_license_id
                 );

      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
      --                       ' Input data from State_Ins(): '||
      --                        rec_prescr_state.id_nhin_prescriber||' '||
      --                        rec_prescr_state.state||' '||
      --                        rec_prescr_state.state_license_id);

      prescr_pkg.audit_dat_ins('PRESCRIBER_STATE', v_prescr_state_id);

EXCEPTION
WHEN e_custom_exception THEN
     ROLLBACK;

     prescr_pkg.err_msg := 'Custom Error Occurred';

     INSERT INTO escribe.prescriber_state_upd_err
                (id, id_nhin_prescriber, state, state_license_id)
         VALUES (v_prescr_state_id, rec_prescr_state.id_nhin_prescriber,
                 rec_prescr_state.state, rec_prescr_state.state_license_id
                );

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     raise_application_error(-20001,err_msg);

     COMMIT;

WHEN OTHERS THEN
     ROLLBACK;

     prescr_pkg.err_msg := ' Unhandled Error Occurred: '||SQLERRM||
                           ' in escribe.prescr_pkg in proc '||c_proc||
                           ' at location ('||TO_CHAR(err_loc)||')';

     INSERT INTO escribe.prescriber_state_upd_err
                (id, id_nhin_prescriber, state, state_license_id)
         VALUES (v_prescr_state_id, rec_prescr_state.id_nhin_prescriber,
                 rec_prescr_state.state, rec_prescr_state.state_license_id
                );

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     raise_application_error(-20001,err_msg);

     COMMIT;

END state_ins;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * NAME:        audit_dat_ins
 * PURPOSE:
 *
 * LIMITATIONS: None
 * REVISIONS:
 * DATE         WHO         WHAT
 * 18-APR-07    C Walton
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
PROCEDURE audit_dat_ins(tbl_class_nam IN VARCHAR2,
                        tbl_row_id    IN NUMBER) IS

c_proc    VARCHAR2(30) := 'audit_dat_ins';

BEGIN

      prescr_pkg.err_loc  := 1;

      v_audit_dates_tbl_class_nam := tbl_class_nam;
      v_audit_dates_tbl_row_id    := tbl_row_id;

      SELECT audit_dates_id_seq.NEXTVAL
        INTO v_audit_dates_id
        FROM dual;

      INSERT INTO escribe.audit_dates
                 (id,
                  table_class_name,
                  table_row_id,
                  system_create_date
                 )
          VALUES (v_audit_dates_id,
                  v_audit_dates_tbl_class_nam,
                  v_audit_dates_tbl_row_id,
                  SYSDATE
                 );

      -- DBMS_OUTPUT.PUT_LINE (c_proc||'.'||err_loc||
      --                       ' Input data from Audit_Dat_Ins(): '||
      --                        v_audit_dates_id||' '||
      --                        v_audit_dates_tbl_class_nam||' '||
      --                        v_audit_dates_tbl_row_id);

EXCEPTION
WHEN e_custom_exception THEN
     ROLLBACK;

     prescr_pkg.err_msg := 'Custom Error Occurred';

     INSERT INTO escribe.audit_dates_upd_err
                (id, table_class_name, table_row_id, system_create_date)
         VALUES (v_audit_dates_id, v_audit_dates_tbl_class_nam,
                 v_audit_dates_tbl_row_id, SYSDATE
                );

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     raise_application_error(-20001,err_msg);

     COMMIT;
WHEN OTHERS THEN
     ROLLBACK;

     prescr_pkg.err_msg := ' Unhandled Error Occurred: '||SQLERRM||
                           ' in escribe.prescr_pkg in proc '||c_proc||
                           ' at location ('||TO_CHAR(err_loc)||')';

     INSERT INTO escribe.audit_dates_upd_err
                (id, table_class_name, table_row_id, system_create_date)
         VALUES (v_audit_dates_id, v_audit_dates_tbl_class_nam,
                 v_audit_dates_tbl_row_id, SYSDATE
                );

     DBMS_OUTPUT.PUT_LINE (prescr_pkg.err_msg);

     raise_application_error(-20001,err_msg);

     COMMIT;

END audit_dat_ins;

END prescr_pkg;
/

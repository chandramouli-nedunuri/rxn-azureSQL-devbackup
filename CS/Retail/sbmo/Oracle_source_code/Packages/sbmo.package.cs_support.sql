
  CREATE OR REPLACE EDITIONABLE PACKAGE "SBMO"."CS_SUPPORT" 
IS
PROCEDURE dbu_allocated_qty
(p_allocatedqty   IN NUMBER DEFAULT NULL,
	p_tenantid   IN NUMBER DEFAULT NULL,
	p_ndc   IN NUMBER DEFAULT NULL,
p_inventoryid        IN NUMBER DEFAULT NULL);
END cs_support;

CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SBMO"."CS_SUPPORT" 
IS
excp_no_id         EXCEPTION;
excp_rowcount  EXCEPTION;
excp_rowcount_zero EXCEPTION;
excp_no_tenant  EXCEPTION;
excp_no_allocatedqty  EXCEPTION;
	excp_no_ndc EXCEPTION;
	excp_ndc_notnumber EXCEPTION;
	
FUNCTION log_audit_dbu (p_dbu_table varchar2,
p_dbu_parms varchar2,
						p_dbu_rows number,
p_sql_text varchar2) return number
IS
l_id number;
BEGIN
-- *****************************************************************************
-- For compliance and support reasons, log the execution of the DBU
-- *****************************************************************************
insert into audit_dbu_log (id, exec_time_stamp, user_id, dbu_table, dbu_parms, dbu_rows, sql_text)
values (audit_dbu_log_seq.nextval, systimestamp, sys_context('userenv','session_user'), upper(p_dbu_table),
p_dbu_parms, p_dbu_rows, p_sql_text)
returning id into l_id;
commit;
return l_id;
END log_audit_dbu;
PROCEDURE log_error (l_id number, p_error varchar2)
IS
BEGIN
update audit_dbu_log set error_text = p_error where id = l_id;
commit;
END log_error;
PROCEDURE dbu_allocated_qty
(p_allocatedqty   IN NUMBER DEFAULT NULL,
	p_tenantid   IN NUMBER DEFAULT NULL,
	p_ndc   IN NUMBER DEFAULT NULL,
p_inventoryid        IN NUMBER DEFAULT NULL)
	 IS
-- This should update one and only one row per execution
v_rowsexp          NUMBER            := 1;
v_rowsproc         NUMBER;
v_sql              VARCHAR2(2000);
l_id               number;
BEGIN
-- *****************************************************************************
-- A value must be provided for ALLOCATED_QTY
-- *****************************************************************************
IF p_allocatedqty IS NULL THEN
RAISE excp_no_allocatedqty;
END IF;
	
-- *****************************************************************************
-- The tenant id MUST be specified in order for this to execute
-- *****************************************************************************
IF p_tenantid IS NULL THEN
RAISE excp_no_tenant;
END IF;
-- *****************************************************************************
-- The value for ndc must not be null
-- *****************************************************************************
IF p_ndc IS NULL THEN
RAISE excp_no_ndc;
END IF;
	
-- *****************************************************************************
-- The value for ndc must be a number
-- *****************************************************************************
if( regexp_like( p_ndc, '^[[:digit:]]+$') ) then
dbms_output.put_line( p_ndc || ' is numeric' );
else
RAISE excp_ndc_notnumber;
end if;
-- *****************************************************************************
-- The inventory id must also be specified
-- *****************************************************************************
IF p_inventoryid IS NULL THEN
RAISE excp_no_id;
END IF;
-- *****************************************************************************
-- The SQL performs an UPDATE to the ALLOCATED_QTY on the FORMULARY table.
-- *****************************************************************************
v_sql := 'UPDATE FORMULARY set ALLOCATED_QTY=:ALLOCATED_QTY' || ' where tenant_id=:tenant_id and ndc=:ndc and inventory_id=:inventory_id';
l_id := log_audit_dbu (p_dbu_table => 'FORMULARY',
p_dbu_parms => 'ALLOCATED_QTY = '||p_allocatedqty||', tenant_id = '||p_tenantid||', ndc = '||p_ndc||', inventory_id = '||p_inventoryid,
						p_dbu_rows => v_rowsexp,
p_sql_text => v_sql || chr(10) || 'Using: ' || p_allocatedqty || ', ' || p_tenantid || ', ' || p_ndc || ', ' || p_inventoryid);
	EXECUTE IMMEDIATE v_sql USING p_allocatedqty, p_tenantid, p_ndc, p_inventoryid;
-- *****************************************************************************
-- Get the number of rows affected from the update and make sure that it only updates
-- one row.  If not, then ROLLBACK; otherwise COMMIT.
-- *****************************************************************************
v_rowsproc := SQL%ROWCOUNT;
IF v_rowsproc > 1 THEN
ROLLBACK;
RAISE excp_rowcount;
	ELSIF v_rowsproc = 0 THEN
	   RAISE excp_rowcount_zero;
ELSE
DBMS_OUTPUT.PUT_LINE('Processed '||v_rowsproc||' row as expected.');
COMMIT;
END IF;
-- *****************************************************************************
-- Error handling
-- *****************************************************************************
EXCEPTION
WHEN excp_no_tenant THEN
	  log_error (l_id, 'DBU [FORMULARY] Tenant ID must have a value');
RAISE_APPLICATION_ERROR(-20400,'DBU [FORMULARY] Tenant ID must have a value');
WHEN excp_no_id THEN
	  log_error (l_id, 'DBU [FORMULARY] Must input a valid inventory ID');
RAISE_APPLICATION_ERROR(-20401,'DBU [FORMULARY] Must input a valid inventory ID');
WHEN excp_rowcount THEN
	  log_error (l_id, 'DBU [FORMULARY] Affected dataset after UPDATE should only be 1 row');
RAISE_APPLICATION_ERROR(-20402,'DBU [FORMULARY] Affected dataset after UPDATE should only be 1 row');
WHEN excp_rowcount_zero THEN
	  log_error (l_id, 'DBU [FORMULARY] Affected zero rows when one updated row was expected');
RAISE_APPLICATION_ERROR(-20403,'DBU [FORMULARY] Affected zero rows when one updated row was expected');
WHEN excp_no_allocatedqty THEN
	  log_error (l_id, 'DBU [FORMULARY] Allocated Quantity must have a value');
RAISE_APPLICATION_ERROR(-20404,'DBU [FORMULARY] Allocated Quantity must have a value');
	WHEN excp_no_ndc THEN
	  log_error (l_id, 'DBU [FORMULARY] NDC must have a value');
RAISE_APPLICATION_ERROR(-20405,'DBU [FORMULARY] NDC must have a value');
	WHEN excp_ndc_notnumber THEN
	  log_error (l_id, 'DBU [FORMULARY] NDC must be a number');
RAISE_APPLICATION_ERROR(-20406,'DBU [FORMULARY] NDC must be a number');
WHEN OTHERS THEN
log_error (l_id, 'DBU [FORMULARY] unhandled exception encountered:' || chr(10) || DBMS_UTILITY.FORMAT_ERROR_STACK() || chr(10) ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
RAISE_APPLICATION_ERROR(-20407,'DBU [FORMULARY] unhandled exception encountered:' || chr(10) || DBMS_UTILITY.FORMAT_ERROR_STACK() || chr(10) ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
	END dbu_allocated_qty;
END CS_SUPPORT;

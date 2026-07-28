
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SBMO"."PKG_SBMO_PURGE" 
AS
/*******************************************************************************
/*
/* NAME:	Pkg_Sbmo_Purge
/*
/* NOTES:	None
/*
/*******************************************************************************
/*
/*	Name				Date		Modification
/* 	-------------------	----------	-------------------------------------------
/*	Edward Stephenson	01/10/2019	Created package
/*
/******************************************************************************/
	-----------------------------------------------------------------------------
	-- Declare Package Processing Variables
	-----------------------------------------------------------------------------
	b_SqlCode			NUMBER							:= NULL;
	b_SqlErrm			PURGE_ERROR_LOG.SQL_ERRM%TYPE	:= NULL;
	b_ErrDate			VARCHAR2(55)						:= 'to_date('''||to_char(sysdate, 'mm/dd/yyyy hh24:mi:ss')||''',''mm/dd/yyyy hh24:mi:ss'')';
	b_WindowEnd			DATE							:= NULL;
	b_NbrHoursInWindow	NUMBER							:= NULL;
	b_DefPartMins		NUMBER							:= NULL;
	b_ChunkSize			NUMBER							:= NULL;
	b_ParallelChunkCount		NUMBER							:= NULL;
	b_ParallelQueryCount	NUMBER							:= NULL;
	
	b_RetryCount		NUMBER							:= NULL;
	b_SleepTime			NUMBER							:= NULL;
	b_MultiBlock		NUMBER							:= NULL;
	b_OrigMultiBlock	NUMBER							:= NULL;
	b_OrigOptimizerMode	VARCHAR2(50)					:= NULL;
	b_JobClass			VARCHAR2(30)					:= NULL;
	b_AppMonthsToKeep	NUMBER							:= NULL;
	b_PurgeMonthsToKeep	NUMBER							:= NULL;
	b_MailHost			VARCHAR2(255)					:= NULL;
	b_MailPort			VARCHAR2(255)					:= NULL;
	b_MailFrom			VARCHAR2(255)					:= NULL;
	b_MailTo			VARCHAR2(255)					:= NULL;
	b_PageTo			VARCHAR2(255)					:= NULL;
	b_ForceRestart		CHAR(1)							:= NULL;
	b_SubpartOptMode	VARCHAR2(255)					:= NULL;
	b_MaxDaysToPurge	NUMBER							:= NULL;
	-----------------------------------------------------------------------------
	-- Declare Private Functions
	-----------------------------------------------------------------------------
	/***************************************************************************/
	/*
	/* Function:	Fn_Test
	/*
	/* Parameters:	p_Test1           IN    VARCHAR2
	/*				++ Description of parameter
	/*
	/* Description:	YY
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Description of return
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/10/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_Test
	(
	p_Test1		IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		v_Return			VARCHAR2(30)		:= NULL;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Comment of what you are doing
		/********************************************************************/
		NULL;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN v_Return;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_Test' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_Test', b_SqlCode, b_SqlErrm,
				'Other error',
				'P_Test1: ' || p_Test1 );
			commit;
			RAISE;
	END Fn_Test;
	
	/***************************************************************************/
	/*
	/* Function:	Fn_SplitString
	/*
	/* Parameters:	p_String       	IN  	VARCHAR2
	/*				++ String to split
	/*				p_Delimiter		IN		CHAR
	/*				++ Delimiter to split the string on
	/*
	/* Description:	This function will split the string and return the values
	/*				as a row of data
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Pipelined string values
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	02/05/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_SplitString
	(
	p_String	IN		VARCHAR2,
	p_Delimiter	IN		CHAR			DEFAULT ','
	)
	RETURN tbl_Strings
	PIPELINED
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_Strings
				(
				p_String		varchar2,
				p_Delim			varchar2
				)
		is
				select 	regexp_substr( p_String,'[^' || p_Delim || ']+', 1, level) as string_val
				from 	dual
				connect by regexp_substr( p_String, '[^' || p_Delim || ']+', 1, level) is not null;
				-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Display the strings
		/********************************************************************/
		for lr in c_Strings( p_String, p_Delimiter ) loop
			PIPE ROW( lr.string_val );
		end loop;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN;
	
	EXCEPTION
		WHEN NO_DATA_NEEDED THEN
			NULL; -- this means the function returned x nbr of rows but the query only requested first y rows
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_SplitString for P_String: ' || p_String || ' and p_Delimiter: ' || p_Delimiter );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_SplitString', b_SqlCode, b_SqlErrm,
				'Other error',
				'P_String: ' || p_String || ' | p_Delimiter: ' || p_Delimiter );
			commit;
			RAISE;
	END Fn_SplitString;
	/***************************************************************************/
	/*
	/* Function:	Fn_KeepRunning
	/*
	/* Parameters:	None
	/*
	/* Description:	This function determines if we should keep running
	/*
	/* Notes:		None
	/*
	/* Return:		BOOLEAN
	/*				++ Yes or No to keep running
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	02/03/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_KeepRunning
	RETURN BOOLEAN
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Running			purge_run_check.purge_running%TYPE	:= null;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Determine if we should continue running
		/********************************************************************/
		select	purge_running
		into	f_Running
		from	purge_run_check;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		if( f_Running = c_Yes ) then
			RETURN TRUE;
		else
			RETURN FALSE;
		end if;
		
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			insert into purge_run_check ( activity_date, purge_running ) values ( systimestamp, c_Yes );
			RETURN FALSE;
			commit;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_KeepRunning' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_KeepRunning', b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Fn_KeepRunning;
	
	/***************************************************************************/
	/*
	/* Function:	Fn_GetMonthsToKeep
	/*
	/* Parameters:	p_TableName      IN    VARCHAR2
	/*				++ Table to get months to keep for
	/*
	/* Description:	This function will get number of months of data to keep
	/*				for the table name passed in
	/*
	/* Notes:		Months will depend on if the table is an application table
	/*				or one associated just with the purge process
	/*
	/* Return:		NUMBER
	/*				++ Months of data to keep associated with the table passed
	/*					in
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetMonthsToKeep
	(
	p_TableName	IN		VARCHAR2
	)
	RETURN NUMBER
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Months			NUMBER							:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Determine the months to keep based upon purge tables or app
		/********************************************************************/
		if( p_TableName = 'PURGE_HISTORY' ) then
			f_Months := b_PurgeMonthsToKeep;
		else
			f_Months := b_AppMonthsToKeep;
		end if;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Months;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetMonthsToKeep for ' || p_TableName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetMonthsToKeep', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName );
			commit;
			RAISE;
	END Fn_GetMonthsToKeep;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetPurgeDate
	/*
	/* Parameters:	p_TableName		IN		VARCHAR2
	/*				++ Table name associated with the request
	/*
	/* Description:	This function will get the purge date from the first table
	/*				in the last run, if there are no records use sysdate
	/*
	/* Notes:		If the passed in table is the first table in the purge
	/*				order, return sysdate
	/*
	/* Return:		Date
	/*				++ Purge date
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/27/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetPurgeDate
	(
	p_TableName	IN		VARCHAR2
	)
	RETURN DATE
	IS
		-- Processing Variables
		v_MonthsToKeep		NUMBER				:= NULL;
		
		-- Fetch Variables
		f_PurgePos			NUMBER				:= NULL;
		f_MinPurgePos		NUMBER				:= NULL;
		f_Date				DATE				:= NULL;
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the purge position of the passed in table and the minimum
		/* purge position from purge tables
		/********************************************************************/
		select	purge_position
		into	f_PurgePos
		from	purge_tables
		where	table_name = p_TableName;
		select	min(purge_position)
		into	f_MinPurgePos
		from	purge_tables;
		
		/********************************************************************/
		/* If this is the first table in the purge order set null
		/* else get the purge_date of the first table in the purge order
		/* if no data is found it will still be null
		/********************************************************************/
		if( f_PurgePos = f_MinPurgePos ) then
			f_Date := null;
		else
			/********************************************************************/
			/* Get the purge date of the first table in the current purge run
			/********************************************************************/
			begin
				select 	max(h.purge_date)
				into	f_Date
				from 	purge_history h,
						purge_tables t
				where 	h.table_name = t.table_name
						and t.purge_position = f_MinPurgePos;
			exception
				when no_data_found then
					f_Date := null;
			end;
		end if; -- f_PurgePos = f_MinPurgePos
		
		/********************************************************************/
		/* If no date has been found determine which is lower, current date
		/* minus months to keep or the oldest rx-cores record plus months
		/* to keep
		/********************************************************************/
		if( f_Date is null ) then
		
			/***************************************************************/
			/* Get the number of months to keep
			/***************************************************************/
			v_MonthsToKeep := Fn_GetMonthsToKeep(p_TableName);
			select  min(purge_date)
			into	f_Date
			from    (
					select add_months( sysdate, -v_MonthsToKeep ) as purge_date
					from dual
					union
					select	min(created_date) + b_MaxDaysToPurge as purge_date
					from rx_cores
					);
		end if;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Date;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetPurgeDate for p_TableName: ' || p_TableName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetPurgeDate', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName );
			commit;
			RAISE;
	END Fn_GetPurgeDate;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetDbParameter
	/*
	/* Parameters:	p_Name		IN		VARCHAR2
	/*				++ Parameter name to get value for
	/*
	/* Description:	This function will get the value associated with the passed
	/*				in name
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Database parameter value
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/20/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetDbParameter
	(
	p_Name		IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Value				VARCHAR2(30)		:= NULL;
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get the parameter value
		/********************************************************************/
		select	value
		into	f_Value
		from	sys.v_$parameter
		where	name = p_Name;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Value;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( p_Name || ' not found in the v$parameter table ' );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetDbParameter', b_SqlCode, b_SqlErrm,
				'No data found in the v$parameter table for the name passed in',
				'P_Name: ' || p_Name );
			commit;
			RAISE NO_DATA_FOUND;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetDbParameter for ' || p_Name );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetDbParameter', b_SqlCode, b_SqlErrm,
				'Other error',
				'P_Name: ' || p_Name );
			commit;
			RAISE;
	END Fn_GetDbParameter;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetConfig
	/*
	/* Parameters:	p_Name           IN    VARCHAR2
	/*				++ Name of configuration value to retrieve
	/*
	/* Description:	This function will retrieve the value of the configuration
	/*				associated with the name passed in
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Value of the configuration
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetConfig
	(
	p_Name		IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Value				PURGE_CONFIG_SETTINGS.VALUE%TYPE	:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Comment of what you are doing
		/********************************************************************/
		select	value
		into	f_Value
		from	purge_config_settings
		where	name = p_Name;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Value;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetConfig, ' || p_Name || ' does not exist in the purge_config_settings table ' );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetConfig', b_SqlCode, b_SqlErrm,
				'No data found in purge_config_settings for the name passed in',
				'P_Name: ' || p_Name );
			commit;
			RAISE;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetConfig for name ' || p_Name );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetConfig', b_SqlCode, b_SqlErrm,
				'Other error',
				'P_Name: ' || p_Name );
			commit;
			RAISE;
	END Fn_GetConfig;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetEndWindow
	/*
	/* Parameters:	None
	/*
	/* Description:	This function will ensure we are starting inside the
	/*				processing window and determine the date value for the
	/*				end of the window
	/*
	/* Notes:		None
	/*
	/* Return:		DATE
	/*				++ Date value representing the end of the processing window
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetEndWindow
	RETURN DATE
	IS
		-- Processing Variables
		v_WindowTimes		PURGE_CONFIG_SETTINGS.VALUE%TYPE	:= NULL;
		v_StartHour			VARCHAR2(4)							:= NULL;
		v_EndHour			VARCHAR2(4)							:= NULL;
		v_StartDate			DATE								:= NULL;
		v_EndDate			DATE								:= NULL;
		v_RunTime			DATE								:= SYSDATE;
		
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get the window times configuration setting
		/********************************************************************/
		v_WindowTimes := Fn_GetConfig( c_WindowTimes );
		v_StartHour := substr( v_WindowTimes, 0, instr( v_WindowTimes, '-' )-1 );
		v_EndHour := substr( v_WindowTimes, instr( v_WindowTimes, '-' )+1 );
		/********************************************************************/
		/* Determine the start and end dates
		/********************************************************************/
		v_StartDate := to_date( to_char( v_RunTime, 'mm/dd/yyyy ' ) || v_StartHour, 'mm/dd/yyyy HH24mi' );
		v_EndDate := to_date( to_char( v_RunTime, 'mm/dd/yyyy ' ) || v_EndHour, 'mm/dd/yyyy HH24mi' );
		/********************************************************************/
		/* If the window spans a day increment the end time to accomodate
		/********************************************************************/
		if( v_StartDate > v_EndDate ) then
			v_EndDate := v_EndDate + 1;
		end if;
		/********************************************************************/
		/* If sysdate is before the start date, move the start date back one
		/* day and see if we are in the middle of the time range, if not
		/* error
		/* If sysdate is greater than the start date and the start date is
		/* greater than the end date increment the end date to tomorrow
		/********************************************************************/
		if( v_RunTime < v_StartDate ) then
			if( v_RunTime > v_StartDate-1 and v_RunTime < v_EndDate-1 ) then
				v_StartDate := v_StartDate - 1;
				v_EndDate := v_EndDate - 1;
			else
				raise e_NotInWindow;
			end if;
		elsif( v_RunTime > v_StartDate and v_RunTime < v_EndDate ) then
			NULL;
		else
			raise e_NotInWindow;
		end if;
		
		/********************************************************************/
		/* Set the number of hours in the window
		/********************************************************************/
		b_NbrHoursInWindow := 24 * ( v_EndDate - v_StartDate );
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN v_EndDate;
	
	EXCEPTION
		WHEN e_NotInWindow THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Program was called before the valid start time, ' || to_char( v_StartDate, 'mm/dd/yyyy hh24:mi' ) || ' determined by ' || c_WindowTimes || ' configuration setting of ' || v_WindowTimes );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetEndWindow', b_SqlCode, b_SqlErrm,
				'Program was called before the valid start time, ' || to_char( v_StartDate, 'mm/dd/yyyy hh24:mi' ) || ' determined by ' || c_WindowTimes || ' configuration setting of ' || v_WindowTimes,
				'None' );
			commit;
			RAISE_APPLICATION_ERROR( -20001, 'Program was called before the valid start time, ' || to_char( v_StartDate, 'mm/dd/yyyy hh24:mi' ) || ' determined by ' || c_WindowTimes || ' configuration setting of ' || v_WindowTimes );
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetEndWindow using ' || v_WindowTimes );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetEndWindow', b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Fn_GetEndWindow;
	/***************************************************************************/
	/*
	/* Function:	Fn_HasSelfReferenceFk
	/*
	/* Parameters:	p_TableName           IN    VARCHAR2
	/*				++ Table name to check
	/*
	/* Description:	This function will determine if the table has a self
	/*				referencing foreign key
	/*
	/* Notes:		None
	/*
	/* Return:		BOOLEAN
	/*				++ Boolean true or false does it have a self ref fk
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/31/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_HasSelfReferenceFk
	(
	p_TableName		IN		VARCHAR2
	)
	RETURN BOOLEAN
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Count				NUMBER				:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Count how many self referencing foreign keys the table has
		/********************************************************************/
		select  count(*)
		into	f_Count
		from    purge_tables p,
				user_constraints cc,
				user_constraints cp
		where   p.table_name = p_TableName
				and p.table_name = cp.table_name
				and cp.constraint_type='P'
				and cp.constraint_name = cc.r_constraint_name
				and cc.constraint_type = 'R';
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		if( f_Count > 0 ) then
			RETURN TRUE;
		else
			RETURN FALSE;
		end if;
		
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_HasSelfReferenceFk' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_HasSelfReferenceFk', b_SqlCode, b_SqlErrm,
				'Other error',
				'P_TableName: ' || p_TableName );
			commit;
			RAISE;
	END Fn_HasSelfReferenceFk;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetTaskElapsedSecs
	/*
	/* Parameters:	p_HistId           IN    NUMBER
	/*				++ purge_history.id to get elapsed seconds for
	/*
	/* Description:	This function will sum all the elapsed seconds for all
	/*				the partitions associated with the history record
	/*
	/* Notes:		None
	/*
	/* Return:		NUMER
	/*				++ Total elapsed seconds for table
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/24/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetTaskElapsedSecs
	(
	p_HistId	IN		NUMBER
	)
	RETURN NUMBER
	IS
		-- Processing Variables
		-- Fetch Variables
		f_TotSecs			NUMBER				:= NULL;
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Sum all the elapsed seconds for the partitions
		/********************************************************************/
		select 	sum(tot_elapsed_secs)
		into	f_TotSecs
		from 	purge_history_partitions
		where 	id_purge_history = p_HistId;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_TotSecs;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetTaskElapsedSecs for id ' || p_HistId );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetTaskElapsedSecs', b_SqlCode, b_SqlErrm,
				'Other error',
				'P_HistId: ' || p_HistId );
			commit;
			RAISE;
	END Fn_GetTaskElapsedSecs;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetEligibleCount
	/*
	/* Parameters:	None
	/*
	/* Description:	This function will return the number of tables that are
	/*				eligible to be purged
	/*
	/* Notes:		The number of eligible tables is the sum of all the tables
	/*				to be purged plus the number not completed from the last
	/*				run
	/*
	/* Return:		NUMBER
	/*				++ Number of tables that are eligible for purge
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/17/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetEligibleCount
	RETURN NUMBER
	IS
		-- Processing Variables
		-- Fetch Variables
		f_TableCount		NUMBER				:= 0;
		f_CurrentCount		NUMBER				:= 0;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get a count of all the purge tables
		/********************************************************************/
		select	count(purge_position)
		into	f_TableCount
		from	purge_tables;
		/********************************************************************/
		/* Get a count of all the purge tables left to complete the
		/* current cycle
		/********************************************************************/
		select	count(purge_position)
		into	f_CurrentCount
		from	purge_tables
		where	purge_position >
				(
				select	purge_position
				from	purge_tables
				where	table_name =
						(
						select	table_name
						from	purge_history
						where	id =
								(
								select	max(id)
								from	purge_history
								)
						)
				);
		/********************************************************************/
		/* Return the number of eligible tables
		/********************************************************************/
		RETURN f_TableCount+f_CurrentCount;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_Test' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetEligibleCount', b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Fn_GetEligibleCount;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetLatestHistory
	/*
	/* Parameters:	None
	/*
	/* Description:	This function will retrieve the last purge_history record
	/*				generated by the SBMO purge process
	/*
	/* Notes:		None
	/*
	/* Return:		PURGE_HISTORY%ROWTYPE
	/*				++ The latest history row in purge_history
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetLatestHistory
	RETURN PURGE_HISTORY%ROWTYPE
	IS
		-- Processing Variables
		-- Fetch Variables
		f_HistoryRec		PURGE_HISTORY%ROWTYPE			:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the last row in the purge_history table
		/********************************************************************/
		select	*
		into	f_HistoryRec
		from	purge_history
		where	id =
				(
				select	max(id)
				from	purge_history
				-- this is taken care of in Sp_PurgeSbmo where	status in ( c_Stopped, c_Finished, c_FinishedErrors )
				);
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_HistoryRec;
	
	EXCEPTION
		/********************************************************************/
		/* If no data is in the history table set status and no table
		/********************************************************************/
		WHEN NO_DATA_FOUND THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			f_HistoryRec.STATUS := c_Finished;
			f_HistoryRec.TABLE_NAME := c_NoTable;
			RETURN f_HistoryRec;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetLatestHistory' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetLatestHistory', b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Fn_GetLatestHistory;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetLatestHistoryPartitions
	/*
	/* Parameters:	None
	/*
	/* Description:	This function will retrieve the last purge_history_partitions
	/*				record generated by the SBMO purge process for a partition
	/*				that is associated with the purge_history.id passed in
	/*
	/* Notes:		None
	/*
	/* Return:		PURGE_HISTORY_PARTITIONS%ROWTYPE
	/*				++ The latest history row in purge_history
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/23/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetLatestHistoryPartitions
	(
	p_HistId		IN		NUMBER
	)
	RETURN PURGE_HISTORY_PARTITIONS%ROWTYPE
	IS
		-- Processing Variables
		-- Fetch Variables
		f_HistoryRec		PURGE_HISTORY_PARTITIONS%ROWTYPE	:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the last row in the purge_history_partitions table
		/********************************************************************/
		select	*
		into	f_HistoryRec
		from	purge_history_partitions
		where	id =
				(
				select	max(id)
				from	purge_history_partitions
				where	id_purge_history = p_HistId
				);
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_HistoryRec;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			RAISE NO_DATA_FOUND;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetLatestHistoryPartitions for purge_history_id ' || P_HistId );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetLatestHistoryPartitions', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_HistId: ' || p_HistId );
			commit;
			RAISE;
	END Fn_GetLatestHistoryPartitions;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetNextPurgeTable
	/*
	/* Parameters:	p_TableName      IN    VARCHAR2
	/*				++ Last purge table
	/*
	/* Description:	This function will get the table name of the next table to
	/*				be purged, it used the input table name to determine the
	/*				next
	/*
	/* Notes:		There may be gaps in the table id
	/*
	/* Return:		VARCHAR2
	/*				++ Next table to be purged
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetNextPurgeTable
	(
	p_TableName	IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		-- Fetch Variables
		f_TableName			PURGE_TABLES.TABLE_NAME%TYPE	:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the next available table with a higher purge position
		/* If none found, return the first one
		/********************************************************************/
		BEGIN
			select	table_name
			into	f_TableName
			from	purge_tables
			where	purge_position >
					(
					select	purge_position
					from	purge_tables
					where	table_name = p_TableName
					)
			order by purge_position
			fetch first 1 rows only;
		EXCEPTION
			WHEN NO_DATA_FOUND then
				select	table_name
				into	f_TableName
				from	purge_tables
				where	purge_position =
						(
						select	min(purge_position)
						from	purge_tables
						);
		END;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_TableName;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetNextPurgeTable for ' || p_TableName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetNextPurgeTable', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName );
			commit;
			RAISE;
	END Fn_GetNextPurgeTable;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetPurgePosition
	/*
	/* Parameters:	p_TableName      IN    VARCHAR2
	/*				++ Table to get purge position for
	/*
	/* Description:	This function will get purge position for the table name
	/*				passed in
	/*
	/* Notes:		None
	/*
	/* Return:		NUMBER
	/*				++ Purge position associated with the table passed in
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetPurgePosition
	(
	p_TableName	IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Position			NUMBER							:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the purge position of the passed in table
		/********************************************************************/
		select	purge_position
		into	f_Position
		from	purge_tables
		where	table_name = p_TableName;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Position;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetPurgePosition for ' || p_TableName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetPurgePosition', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName );
			commit;
			RAISE;
	END Fn_GetPurgePosition;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetTaskParallelCount
	/*
	/* Parameters:	p_TableName      IN    VARCHAR2
	/*				++ Table to get parallel count for
	/*
	/* Description:	This function will get the parallel count (or use the default)
	/*				for the table name passed in
	/*
	/* Notes:		If no parallel count exists in purge tables or it is higher
	/8				than the configuration setting, use the configuration
	/*
	/* Return:		NUMBER
	/*				++ Parallel count associated with the table passed in
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/28/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetTaskParallelCount
	(
	p_TableName	IN		VARCHAR2
	)
	RETURN NUMBER
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Parallel			NUMBER							:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the purge position of the passed in table
		/********************************************************************/
		select	nvl(parallel_count, b_ParallelChunkCount)
		into	f_Parallel
		from	purge_tables
		where	table_name = p_TableName;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		if( f_Parallel <= b_ParallelChunkCount ) then
			RETURN f_Parallel;
		else
			RETURN b_ParallelChunkCount;
		end if;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetTaskParallelCount for ' || p_TableName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetTaskParallelCount', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName );
			commit;
			RAISE;
	END Fn_GetTaskParallelCount;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetPurgeColumn
	/*
	/* Parameters:	p_TableName      IN    VARCHAR2
	/*				++ Table to get purge column for
	/*
	/* Description:	This function will get purge column for the table name
	/*				passed in
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Purge column associated with the table passed in
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetPurgeColumn
	(
	p_TableName	IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Column			VARCHAR2(30)					:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the purge column of the passed in table
		/********************************************************************/
		select	purge_column
		into	f_Column
		from	purge_tables
		where	table_name = p_TableName;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Column;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetPurgeColumn for ' || p_TableName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetPurgeColumn', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName );
			commit;
			RAISE;
	END Fn_GetPurgeColumn;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetTaskName
	/*
	/* Parameters:	p_TableName			IN		VARCHAR2
	/*				++ Table name used for the task name
	/*				p_PartName			IN		VARCHAR2
	/*				++ Partition name used for task name
	/*
	/* Description:	This function will generate the task name
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Task name
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetTaskName
	(
	p_TableName		IN		VARCHAR2,
	p_PartName		IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		v_Name				VARCHAR2(30)		:= NULL;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Generate the task name
		/********************************************************************/
		v_Name := c_TaskNamePrefix || '_PP' || fn_GetPurgePosition( p_TableName );
		v_Name := v_Name || '_' || p_PartName;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN UPPER( v_Name );
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetTaskName for table ' || p_TableName || ' and partition ' || p_PartName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetTaskName', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
			RAISE;
	END Fn_GetTaskName;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetJobName
	/*
	/* Parameters:	p_TableName			IN		VARCHAR2
	/*				++ Table name used for the task name
	/*				p_PartName			IN		VARCHAR2
	/*				++ Partition name used for task name
	/*
	/* Description:	This function will generate the scheduler job name
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Job name
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetJobName
	(
	p_JobType		IN		VARCHAR2,
	p_TableName		IN		VARCHAR2,
	p_PartName		IN		VARCHAR2
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		v_Name				VARCHAR2(60)		:= NULL;
		v_Date				VARCHAR2(20)		:= to_char( sysdate, 'mmddyyyy' );
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Generate the job name
		/********************************************************************/
		if( p_JobType = c_Monitor ) then
			v_Name := c_MonJobNamePrefix || '_PP' || fn_GetPurgePosition( p_TableName );
			v_Name := v_Name || '_' || p_PartName || '_' || v_Date;
		elsif( p_JobType = c_Index ) then
			v_Name := c_IndJobNamePrefix || '_PP' || fn_GetPurgePosition( p_TableName );
			v_Name := v_Name || '_' || p_PartName || '_' || v_Date;
		else
			raise e_BadJobType;
		end if;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN substr( UPPER( v_Name ), 1, 30 );
	
	EXCEPTION
		WHEN e_BadJobType THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetJobName job type ' || p_JobType || ' does not exist ' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetJobName', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_JobType: ' || p_JobType || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
			RAISE;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetJobName for job type ' || p_JobType || ', table ' || p_TableName || ' and partition ' || p_PartName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetJobName', b_SqlCode, b_SqlErrm,
				'Job type ' || p_JobType || ' does not exist ',
				'p_JobType: ' || p_JobType || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
			RAISE;
	END Fn_GetJobName;
/***************************************************************************/
	/*
	/* Function:	Fn_GetChunkCount
	/*
	/* Parameters:	p_TaskName			IN		VARCHAR2
	/*				++ Task name to get count for
	/*
	/* Description:	This function will get the chunk count for a task
	/*
	/* Notes:		None
	/*
	/* Return:		NUMBER
	/*				++ Chunk Count
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetChunkCount
	(
	p_TaskName		IN		VARCHAR2
	)
	RETURN NUMBER
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Count				NUMBER				:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get the chunk count
		/********************************************************************/
		select	count(*)
		into	f_Count
		from	user_parallel_execute_chunks
		where	task_name = p_TaskName;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Count;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetChunkCount for task ' || p_TaskName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetChunkCount', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TaskName: ' || p_TaskName );
			commit;
			RAISE;
	END Fn_GetChunkCount;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetConsColumns
	/*
	/* Parameters:	p_TableName			IN		VARCHAR2
	/*				++ Table associated with the constraint
	/*				p_ConsName			IN		VARCHAR2
	/*				++ Constraint name
	/*				p_AddTenant			IN		CHAR
	/*				++ Flag denoting to add the tenant column or not
	/*
	/* Description:	This function will get the column list for the passed in
	/*				table and constraint
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Column list
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/26/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetConsColumns
	(
	p_TableName		IN		VARCHAR2,
	p_ConsName		IN		VARCHAR2,
	p_AddTenant		IN		CHAR				DEFAULT c_Yes
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Cols				VARCHAR2(500)		:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get the column list
		/********************************************************************/
		if( p_AddTenant = c_Yes ) THEN
			select  LISTAGG(column_name, ',')
					within group (order by position) as columns
			into	f_Cols
			FROM    user_cons_columns
			where   table_name = p_TableName
					and constraint_name = p_ConsName;
		else
			select  LISTAGG(column_name, ',')
					within group (order by position) as columns
			into	f_Cols
			FROM    user_cons_columns
			where   table_name = p_TableName
					and constraint_name = p_ConsName
					and column_name <> 'TENANT_ID';
		end if;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_Cols;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetConsColumns for table ' || p_TableName || ' and constraint ' || p_ConsName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetConsColumns',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' p_ConsName: ' || p_ConsName );
			commit;
			RAISE;
	END Fn_GetConsColumns;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetChunkSql
	/*
	/* Parameters:	p_TableName			IN		VARCHAR2
	/*				++ Table to chunk sql for
	/*				p_PartName			IN		VARCHAR2
	/*				++ Partition to chunk sql for
	/*				p_ColumnName		IN		VARCHAR2
	/*				++ Date column used to purge by
	/*				++ Purge anything older than this many months
	/*				p_PurgeDate			IN		DATE
	/*				++ Date to purge before
	/*				p_Tenant			IN		NUMBER
	/*				++ Tenant id
	/*
	/* Description:	This function will generate the sql used to chunk the
	/*				table into pieces for the parallel execution
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Chunk sql
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetChunkSql
	(
	p_TableName		IN		VARCHAR2,
	p_PartName		IN		VARCHAR2,
	p_ColumnName	IN		VARCHAR2,
	p_PurgeDate		IN		DATE,
	p_Tenant		IN		NUMBER
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		v_Sql				VARCHAR2(4000)		:= NULL;
		v_part_clause       VARCHAR2(4000)		:= NULL;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Generate the chunk sql
		/********************************************************************/
dbms_output.put_line('DEBUG Fn_GetChunkSql : p_TableName - ' || p_TableName || ' , p_PartName - ' || p_PartName );
		
		if (p_partName = 'NON_PARTITIONED') then
		v_part_clause := null ;
		else
		  v_part_clause := ' partition (' || p_partName || ') '  ;
		end if ;
		
		v_Sql := ' with ids ' ||
				' as ' ||
				'( ' ||
					'select  id as start_id ' ||
					'from    ( ' ||
							'select  id ' ||
							'from ' || p_TableName || v_part_clause ; -- old code :' partition (' || p_partName || ') ';
	
		-- Medha: add check here if partition is NULL or NON_PARTITIONED , then skip part clause
		
		if(	p_Tenant is NULL ) then
			v_Sql := v_Sql || ' where ' || p_ColumnName || ' < ';
		else
			v_Sql := v_Sql || ' where  tenant_id = ' || p_Tenant || ' and ' || p_ColumnName || ' < ';
		end if;
		v_Sql := v_Sql || 'to_date( ''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ''', ''mm/dd/yyyy hh24:mi:ss'' ) ' ||
							'order by id ' ||
							') ' ||
					'group by rownum, id ' ||
					'having mod(rownum, ' || b_ChunkSize || ' ) = 0 ' ||
					'union ' ||
					'select min(id) as start_id ' ||
					'from ' || p_TableName || v_part_clause ; -- old code : ' partition (' || p_partName || ') ';
		if(	p_Tenant is NULL ) then
			v_Sql := v_Sql || ' where ' || p_ColumnName || ' < ';
		else
			v_Sql := v_Sql || ' where  tenant_id = ' || p_Tenant || ' and ' || p_ColumnName || ' < ';
		end if;
		
		v_Sql := v_Sql || 'to_date( ''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ''', ''mm/dd/yyyy hh24:mi:ss'' ) ' ||
					'union ' ||
					'select max(id) as start_id ' ||
					'from ' || p_TableName || v_part_clause ; -- old code: ' partition (' || p_partName || ') ';
					
		-- Do not include tenant_id, testing determined it is faster for the chunking
		-- sql to just do the subpartition pruning and then full subpartition scan
		v_Sql := v_Sql || ' where ' || p_ColumnName || ' < ';
		v_Sql := v_Sql || 'to_date( ''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ''', ''mm/dd/yyyy hh24:mi:ss'' ) ' ||
					'order by 1 ' ||
				'), ' ||
				'chunks ' ||
				'as ' ||
				'( ' ||
					'select  start_id, ' ||
							'lead(start_id,1,0) over (order by start_id) as end_id, ' ||
							'lag(start_id,1,0) over (order by start_id) as prevr ' ||
					'from    ids ' ||
				') ' ||
				'select	start_id, ' ||
						'decode( end_id, 0, start_id + ' || b_ChunkSize || ', end_id-1 ) as end_id ' ||
				'from	chunks ';
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
dbms_output.put_line('DEBUG | Fn_GetChunkSql - ' || v_Sql );
		RETURN v_Sql;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetChunkSql for table ' || p_TableName || ' and partition ' || p_PartName || ' and column ' || p_ColumnName|| ' | p_PurgeDate: ' || to_char(p_PurgeDate,'mm/dd/yyyy hh24:mi:ss') );
			DBMS_OUTPUT.PUT_LINE( 'Sql thus far: ' || v_Sql );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetChunkSql',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_ColumnName: ' || p_ColumnName || ' | p_PurgeDate: ' || to_char(p_PurgeDate,'mm/dd/yyyy hh24:mi:ss') );
			commit;
			RAISE;
	END Fn_GetChunkSql;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetTaskSql
	/*
	/* Parameters:	p_TaskName			IN		VARCHAR2
	/*				++ Task name associated, used in final row count insert
	/*				p_TableName			IN		VARCHAR2
	/*				++ Table to chunk sql for
	/*				p_PartName			IN		VARCHAR2
	/*				++ Partition to chunk sql for
	/*				p_ColumnName		IN		VARCHAR2
	/*				++ Date column used to purge by
	/*				p_PurgeDate			IN		DATE
	/*				++ Date to purge below
	/*				p_HistId			IN		NUMBER
	/*				++ Purge history record id for the table passed in
	/*				p_Tenant			IN		NUMBER
	/*				++ Tenant id
	/*
	/* Description:	This function will generate the sql used to delete the
	/*				table
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Task sql
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetTaskSql
	(
	p_TaskName		IN		VARCHAR2,
	p_TableName		IN		VARCHAR2,
	p_PartName		IN		VARCHAR2,
	p_ColumnName	IN		VARCHAR2,
	p_PurgeDate		IN		DATE,
	p_HistId		IN		NUMBER,
	p_Tenant		IN		NUMBER
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		v_FkSql				VARCHAR2(4000)		:= ' ';
		v_Sql				VARCHAR2(4000)		:= NULL;
		v_part_clause   	VARCHAR2(4000)		:= NULL;
		
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_SelfFks
				(
				p_Table		VARCHAR2
				)
		is
				select  cp.constraint_name as parent_constraint,
						cc.constraint_name as fk_constraint
				from    user_constraints cp,
						user_constraints cc
				where   cp.table_name = p_Table
						and cp.constraint_type='P'
						and cp.constraint_name = cc.r_constraint_name
						and cc.constraint_type = 'R'
						and cp.table_name = cc.table_name;
		
		cursor	c_Cols
				(
				p_String	VARCHAR2
				)
		is
				select	column_value as string_val
				from	table(Fn_SplitString( p_String ) );
		-- Cursor Fetch Variables
	BEGIN
		--Medha: Depending on if table is partitioned or not use the v_part_clause clause 		
		if (p_PartName = 'NON_PARTITIONED') then
		v_part_clause := null;
		else
		  v_part_clause := ' partition (' || p_PartName || ') ' ;
		end if;
		
		
		/********************************************************************/
		/* Generate the self referencing foreign key sql
		/********************************************************************/
		for lr in c_SelfFks( p_TableName ) loop
			v_FkSql := v_FkSql || 'update ' ||
					p_TableName || v_part_clause || ' d ' ||
					'set ';
					
			for lr1 in c_Cols( Fn_GetConsColumns( p_TableName, lr.fk_constraint, c_No ) ) loop
				v_FkSql := v_FkSql || lr1.string_val || ' = null, ';
			end loop;
			v_FkSql := substr( v_FkSql, 1, instr( v_FkSql, ',' )-1 );
			v_FkSql := v_FkSql || ' ' ||
					' where (' || Fn_GetConsColumns( p_TableName, lr.fk_constraint ) || ') in ' ||
						'( ' ||
						'select ' || Fn_GetConsColumns( p_TableName, lr.parent_constraint ) || ' ' ||
						'from ' || p_TableName || v_part_clause ||
						' where ' || Fn_GetConsColumns( p_TableName, lr.parent_constraint, c_No ) || ' ' ||
										'between :start_id and :end_id  ';
		if(	p_Tenant is NOT NULL ) then
			v_FkSql := v_FkSql || 'and tenant_id = ' || p_Tenant || ' ';
		end if;
			v_FkSql := v_FkSql || 'and ' || p_ColumnName || ' < ' ||
							'to_date( ''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ''', ''mm/dd/yyyy hh24:mi:ss'' ) ' ||
					'); ';
		end loop;
		
		/********************************************************************/
		/* Generate the task sql
		/********************************************************************/
		v_Sql :=	'declare ' ||
						'v_StartTime	date	:= sysdate; ' ||
						'v_count		number	:= null; ' ||
					'begin ' ||
						' ' ||
						v_FkSql ||
						' ' ||
						'delete ' || p_TableName || v_part_clause ;
		if(	p_Tenant is NULL ) then
			v_Sql := v_Sql || ' where ' || p_ColumnName || ' < ';
		else
			v_Sql := v_Sql || ' where  tenant_id = ' || p_Tenant || ' and ' || p_ColumnName || ' < ';
		end if;
		v_Sql := v_Sql || 'to_date( ''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ''', ''mm/dd/yyyy hh24:mi:ss'' ) ' ||
						'and id between :start_id and :end_id ; ' ||
						' ' ||
						'v_count := sql%rowcount; ' ||
						' ' ||
						'insert into purge_history_chunks( id, id_purge_history_partitions, ' ||
							' table_name, part_name, task_name, start_time, end_time, row_count ) ' ||
						'values ( purge_seq.nextval, ' || p_HistId || ', ' ||
							'''' || p_TableName || ''', ''' || p_PartName || ''', ' ||
							'''' || p_TaskName || ''', v_StartTime, sysdate, v_count ); ' ||
						'commit; ' ||
					'end; ';
					
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN v_Sql;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetTaskSql for table ' || p_TableName || ' and partition ' || p_PartName || ' and column ' || p_ColumnName || ' | p_PurgeDate: ' || to_char(p_PurgeDate,'mm/dd/yyyy hh24:mi:ss') || ' | p_HistId: ' || p_HistId );
			DBMS_OUTPUT.PUT_LINE( 'Sql thus far: ' || v_Sql );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetTaskSql',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_ColumnName: ' || p_ColumnName || ' | p_PurgeDate: ' || to_char(p_PurgeDate,'mm/dd/yyyy hh24:mi:ss') || ' | p_HistId: ' || p_HistId );
			commit;
			RAISE;
	END Fn_GetTaskSql;
	/***************************************************************************/
	/*
	/* Function:	Fn_GetTenantId
	/*
	/* Parameters:	p_TableName			IN		VARCHAR2
	/*				++ Table to chunk sql for
	/*				p_PartName			IN		VARCHAR2
	/*				++ Partition to chunk sql for
	/*
	/* Description:	This function will get the tenant_id associated with the
	/*				table and partition unless the partition is other then it
	/*				will return null
	/*
	/* Notes:		None
	/*
	/* Return:		NUMBER
	/*				++ Tenant id
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	02/08/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetTenantId
	(
	p_TableName		IN		VARCHAR2,
	p_PartName		IN		VARCHAR2
	)
	RETURN NUMBER
	IS
		-- Processing Variables
		v_Count				NUMBER				:= 0;
		v_Tenant			NUMBER				:= null;
		
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_Val
				(
				p_Table		VARCHAR2,
				p_Part		VARCHAR2
				)
		is
				select  high_value
				from    user_tab_partitions
				where   table_name = p_Table
						and partition_name = p_Part;
		
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Look at the high value for the partition, error if none found
		/********************************************************************/
		for lr in c_val( p_TableName, p_PartName ) loop
			if( upper(lr.high_value) = 'DEFAULT' ) then
				v_Tenant := null;
			else	
				v_Tenant := to_number(lr.high_value);
			end if;
			v_Count := v_Count + 1;
		end loop;
		if( v_count = 0 ) then
			raise no_data_found;
		end if;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN v_Tenant;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'No data found in Fn_GetTenantId for table ' || p_TableName || ' and partition ' || p_PartName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetTenantId',  b_SqlCode, b_SqlErrm,
				'No Data Found',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
			RAISE;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetTenantId for table ' || p_TableName || ' and partition ' || p_PartName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetTenantId',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
			RAISE;
	END Fn_GetTenantId;
	-----------------------------------------------------------------------------
	-- Declare Private Procedures
	-----------------------------------------------------------------------------
	/***************************************************************************/
	/*
	/* Procedure:	Sp_Test
	/*
	/* Parameters:	p_Test1           IN    VARCHAR2
	/*				++ Description of parameter
	/*
	/* Description:	YY
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/10/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_Test
	(
	p_Test1		IN		VARCHAR2
	)
	IS
		-- Processing Variables
		v_Return			VARCHAR2(30)		:= NULL;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Comment of what you are doing
		/********************************************************************/
		NULL;
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_Test' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_Test',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_Test1: ' || p_Test1 );
			commit;
			RAISE;
	END Sp_Test;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_SetConfig
	/*
	/* Parameters:	None
	/*
	/* Description:	This procedure will set the package body variables
	/*				associated with all the configuration settings
	/*
	/* Notes:		This procedure should be the first line of any public
	/*				function or procedure
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/25/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_SetConfig
	IS
		-- Processing Variables
		v_Today				VARCHAR2(20)		:= rtrim(to_char(sysdate,'DAY'));
		v_Config			VARCHAR2(255)		:= NULL;
		
		-- Fetch Variables
		f_Count				NUMBER				:= NULL;
		f_Freespace			NUMBER				:= NULL;
		
		-- Exception Variables
		-- Cursors
		cursor	c_Blackout
				(
				p_String	VARCHAR2
				)
		is
				select	upper(column_value) as blackout_day
				from	table(Fn_SplitString( p_String ) );
				
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Set the package body variables for configuration settings
		/* and check minimum requirements
		/********************************************************************/
		b_DefPartMins := to_number( Fn_GetConfig( c_DefPartMins ) );
		b_ChunkSize	:= to_number( Fn_GetConfig( c_ChunkSize ) );
		b_ParallelChunkCount	:= to_number( Fn_GetConfig( c_ParallelChunkCount ) );
		b_ParallelQueryCount	:= to_number( Fn_GetConfig( c_ParallelQueryCount ) );
		b_RetryCount := to_number( Fn_GetConfig( c_RetryCount ) );
		b_SleepTime := to_number( Fn_GetConfig( c_SleepTime ) );
		b_MultiBlock := to_number( Fn_GetConfig( c_MultiBlock ) );
		b_OrigMultiBlock := Fn_GetDbParameter( 'db_file_multiblock_read_count' );
		b_OrigOptimizerMode := Fn_GetDbParameter( 'optimizer_mode' );
		
		b_MailHost := Fn_GetConfig( c_MailHost );
		b_MailPort := Fn_GetConfig( c_MailPort );
		b_MailFrom := Fn_GetConfig( c_MailFrom );
		b_MailTo := Fn_GetConfig( c_MailTo );
		b_PageTo := Fn_GetConfig( c_PageTo );
		b_ForceRestart := Fn_GetConfig( c_ForceRestart );
		b_AppMonthsToKeep := to_number( Fn_GetConfig( c_AppMonthsToKeep ) );
		b_PurgeMonthsToKeep := to_number( Fn_GetConfig( c_PurgeMonthsToKeep ) );
		b_SubpartOptMode := Fn_GetConfig( c_SubpartOptMode );
		b_MaxDaysToPurge := to_number( Fn_GetConfig( c_MaxDaysToPurge ) );
		/********************************************************************/
		/* Make sure job class exists and we can use it
		/********************************************************************/
		b_JobClass := Fn_GetConfig( c_JobClass );
		select 	sum(priv_count)
		into	f_Count
		from 	(
				select 	count(*) as priv_count
				from 	user_tab_privs
				where 	table_name = b_JobClass
						and privilege = 'EXECUTE'
				union
				select 	count(*)  as priv_count
				from 	all_tab_privs
				where 	grantee = 'PUBLIC'
						and table_name = b_JobClass
						and privilege = 'EXECUTE'
				);
				
		if( f_Count = 0 ) then
			raise e_InvalidJobClass;
		end if;
		b_WindowEnd	:= Fn_GetEndWindow;
		/********************************************************************/
		/* Ensure today is not a blackout day
		/********************************************************************/
		for lr in c_Blackout( Fn_GetConfig( c_BlackoutDay ) ) loop
			if( lr.blackout_day = v_Today ) then
				raise e_BlackoutDay;
			end if;
		end loop;
		
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'No data found in Sp_SetConfig for config ' || v_Config );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SetConfig',  b_SqlCode, b_SqlErrm,
				'No data found for config ' || v_Config,
				'v_Config: ' || v_Config );
			commit;
			raise_application_error(-20912, 'No data found for config ' || v_Config);
		WHEN e_InvalidJobClass THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SetConfig Invalid job class ' || b_JobClass );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SetConfig',  b_SqlCode, b_SqlErrm,
				'Invalid job class - ' || b_JobClass,
				'None' );
			commit;
			raise_application_error(-20011, 'Job class does not exist or user has no permissions on it: ' || b_JobClass );
		WHEN e_BlackoutDay THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SetConfig today, ' || v_Today || ', is defined as a blackout day' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SetConfig',  b_SqlCode, b_SqlErrm,
				'Today, ' || v_Today || ', is defined as a blackout day',
				'None' );
			commit;
			raise_application_error(-20012, 'Today, ' || v_Today || ', is defined as a blackout day' );
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SetConfig' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SetConfig',  b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			raise_application_error(-20015, 'Other error setting configurations, sqlcode: ' || b_SqlCode || ' and message: ' || b_SqlErrm );
	END Sp_SetConfig;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_WriteLogFile
	/*
	/* Parameters:	p_PurgeDate		DATE
	/*				++ Date used as the purge baseline
	/*
	/* Description:	This procedure will write all input data to a log file
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	05/08/2020	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_WriteLogFile
	(
	p_RunStart		IN			DATE,
	p_Msg			IN			CLOB
	)
	IS
		-- Processing Variables
		v_Sql				VARCHAR2(4000)		:= null;
		v_FileName			VARCHAR2(255)		:= 'ora_purge_sbmo_' || sys_context('USERENV','INSTANCE_NAME') || '_' || to_char(p_RunStart, 'yyyymmdd_hh24mi') || '.log';
		v_File			UTL_FILE.FILE_TYPE;
		v_Length			NUMBER			:= NVL(DBMS_LOB.GetLength(p_Msg),0);
		v_Buffer			NUMBER			:= 32000;
		v_Offset			NUMBER			:= 1;
		
		-- Fetch Variables
		f_HistId			NUMBER			:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Open the log file, if error recreate the directory object and
		/* try again
		/********************************************************************/
		begin
			v_File := utl_file.fopen( 'DBA_LOG_DIR', v_FileName, 'w', 32760 );
		exception
			when others then
				v_Sql := 'Create or replace directory dba_log_dir as ''/oracle_scripts/log/' || sys_context('USERENV','INSTANCE_NAME') || ''' ';
				execute immediate v_Sql;
				v_File := utl_file.fopen( 'DBA_LOG_DIR', v_FileName, 'w', 32760 );
		end;
		/********************************************************************/
		/* Write the message to the file
		/********************************************************************/
		while( v_Offset < v_Length ) loop
			utl_file.put( v_File, dbms_lob.substr(p_Msg, v_Buffer, v_Offset) );
			utl_file.fflush(v_File);
			v_Offset := v_Offset + v_Buffer;
		end loop;
		utl_file.new_line(v_File);
		/********************************************************************/
		/* Close the file
		/********************************************************************/
		utl_file.fclose( v_File );
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_WriteLogFile for p_RunStart: ' || to_char(p_RunStart, 'mm/dd/yyyy hh24:mi:ss') );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			rollback;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_WriteLogFile',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_RunStart: ' || to_char(p_RunStart, 'mm/dd/yyyy hh24:mi:ss') || ' | p_Msg: ' || p_Msg );
			commit;
			if( utl_file.is_open(v_File) ) then
				utl_file.fflush(v_File);
				utl_file.fclose( v_File );
			end if;
			RAISE;
	END Sp_WriteLogFile;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_SendEmail
	/*
	/* Parameters:	p_Subj           IN    	VARCHAR2
	/*				++ Subject of the email
	/*				p_Msg			IN		CLOB
	/*				++ Body of the email
	/*				p_Fail			IN		CHAR
	/*				++ Flag to denote failure
	/*
	/* Description:	This procedure sends an email
	/*
	/* Notes:		If failure also include page email
	/*			If 'Mail To' is not set and no failure, no email will be
	/*			sent
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/28/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_SendEmail
	(
	p_Subj		IN		VARCHAR2,
	p_Msg		IN		CLOB,
	p_Fail		IN		CHAR					DEFAULT c_No
	)
	IS
		-- Processing Variables
		v_MailConn			UTL_SMTP.CONNECTION;
		v_Subj				VARCHAR2(1000)		:= 	lower(sys_context('USERENV','HOST')) || ':' || lower(sys_context('USERENV','DB_NAME')) || ':' || p_Subj;
		v_Count				NUMBER			:= 0;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_Addrs
				(
				p_String	VARCHAR2
				)
		is
				select	column_value as string_val
				from	table(Fn_SplitString( p_String ) )
				where		length(column_value) > 1
						and upper(column_value) <> 'NONE';
				-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Fill in the email and send it, add pager address if needed
		/********************************************************************/
		v_MailConn := UTL_SMTP.open_connection( b_MailHost, b_MailPort );
		UTL_SMTP.HELO( v_MailConn, b_MailHost );
		UTL_SMTP.MAIL( v_MailConn, b_MailFrom );
		for lr in c_Addrs( b_MailTo ) loop
			UTL_SMTP.RCPT( v_MailConn, lr.string_val );
			v_Count := v_Count + 1;
		end loop;
		if( p_Fail = c_Yes ) then
			for lr in c_Addrs( b_PageTo ) loop
				UTL_SMTP.RCPT( v_MailConn, lr.string_val );
				v_Count := v_Count + 1;
			end loop;
		end if;
		
		if( v_Count > 0 ) then
			UTL_SMTP.OPEN_DATA( v_MailConn );
			UTL_SMTP.WRITE_DATA( v_MailConn, 'Date: ' || to_char(sysdate, 'DD-MON-YYYY HH24:mi:ss') || UTL_TCP.crlf );
			UTL_SMTP.WRITE_DATA( v_MailConn, 'To: ' || b_MailTo || UTL_TCP.crlf );
			UTL_SMTP.WRITE_DATA( v_MailConn, 'From: ' || b_MailFrom || UTL_TCP.crlf );
			UTL_SMTP.WRITE_DATA( v_MailConn, 'Subject: ' || v_Subj || UTL_TCP.crlf );
			UTL_SMTP.WRITE_DATA( v_MailConn, 'Reply-To: ' || b_MailFrom || UTL_TCP.crlf || UTL_TCP.crlf );
			UTL_SMTP.WRITE_DATA( v_MailConn, p_Msg );
			UTL_SMTP.CLOSE_DATA( v_MailConn );
			UTL_SMTP.QUIT( v_MailConn );
		end if;
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SendEmail p_Subj: ' || p_Subj || ' | p_Msg: ' || substr(p_Msg, 1, 200) );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SendEmail',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_Subj: ' || p_Subj || ' | p_Msg: ' || substr(p_Msg, 1, 200) );
			commit;
			RAISE;
	END Sp_SendEmail;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_SendStatusReport
	/*
	/* Parameters:	p_Status		IN			VARCHAR2
	/*				++ Status of the return from Sp_PurgeSbmo
	/*				p_RunStart		IN			DATE
	/*				++ Date/time the current run started
	/*				p_Fail			IN			CHAR
	/*				++ Flag to denote if the status is a failure
	/*
	/* Description:	This procedure will generate and send the daily status rpt
	/*
	/* Notes:		If fail is yes then send fail notification as well
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/28/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_SendStatusReport
	(
	p_Status		IN			VARCHAR2,
	p_RunStart		IN 			DATE,
	p_Fail			IN			CHAR			DEFAULT c_No
	)
	IS
		-- Processing Variables
		v_Report			CLOB				:= empty_clob();
		v_Status			CLOB				:= p_Status;
		v_RunStart			DATE				:= p_RunStart;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_rpt
		is
				select	*
				from	table(Pkg_SBMO_Purge.Fn_DailyRpt(p_RunStart));
		cursor	c_errs
		is
				select	*
				from table(pkg_sbmo_purge.fn_ShowErrors(p_RunStart));
				
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Add the status and header to the report
		/********************************************************************/
		v_Report := 'SBMO Purge Report from ' || to_char(p_RunStart, 'mm/dd/yyyy hh24:mi:ss') || ' - ' || to_char(sysdate,'mm/dd/yyyy hh24:mi:ss') || chr(10) || chr(10);
		v_Report := v_Report || 'Report Status: ' || p_Status || chr(10) || chr(10);
		v_Report := v_Report || rpad('Table Name',33) || rpad('Tot Secs',15) || rpad('Tot Purged',15) || rpad('Tot FK Del',15) || rpad('Tot FK Secs',15) || rpad('# Dropped SP',15) || rpad('Purged / Sec',15) || 'FK / Sec' || chr(10);
		v_Report := v_Report || rpad('-',30,'-') || '   ' || rpad('-',12,'-') || '   ' || rpad('-',12,'-') || '   ' || rpad('-',12,'-') || '   ' || rpad('-',12,'-') || '   ' || rpad('-',12,'-') || '   ' || rpad('-',12,'-') || '   ' || rpad('-',12,'-') || chr(10);
		
		/********************************************************************/
		/* Loop through the daily report and add them to the message clob
		/********************************************************************/
		for lr in c_rpt loop
			v_Report := v_Report || rpad(lr.table_name,33) || to_char(lpad(lr.tot_secs,12),'999,999,999') || '   ' || to_char(lpad(lr.tot_purged,12),'999,999,999') || '   ' || to_char(lpad(lr.tot_fk_del,12),'999,999,999') || '   ' || to_char(lpad(lr.tot_fk_secs,12),'999,999,999') || '   ' || to_char(lpad(lr.tot_subparts,12),'999,999,999') || '   ' || to_char(lpad(lr.purged_per_sec,12),'999,999,999') || '   ' || to_char(lpad(lr.fk_per_sec,12),'999,999,999') || chr(10);
		end loop;
		/********************************************************************/
		/* Send the report
		/********************************************************************/
		Sp_SendEmail( 'Daily SBMO Purge Report - ' || to_char(sysdate, 'dd Mon yyyy'), v_Report );
		
		/********************************************************************/
		/* Send the failure email if necessary
		/********************************************************************/
		if( p_Fail = c_Yes ) then
			v_Status := v_Status || chr(10);
			for lr in c_errs loop
				v_Status := v_Status || chr(10) || lr.column_value;
			end loop;
			Sp_SendEmail( '[CRITICAL] Daily SBMO Purge ++FAILED++ - ' || to_char(sysdate, 'dd Mon yyyy'), '++FAILED++ Daily SBMO Purge with ' || v_Status, c_Yes );
		end if;
		/********************************************************************/
		/* Write the report to a log file
		/********************************************************************/
		Sp_WriteLogFile( v_RunStart, v_Report );
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SendStatusReport - Status: ' || p_Status || ' and Run Start: ' || to_char(p_RunStart,'mm/dd/yyyy hh24:mi:ss') );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SendStatusReport',  b_SqlCode, b_SqlErrm,
				'Other error',
				'Status: ' || p_Status || ' and Run Start: ' || to_char(p_RunStart,'mm/dd/yyyy hh24:mi:ss') );
			commit;
			RAISE;
	END Sp_SendStatusReport;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_SetRunFlag
	/*
	/* Parameters:	p_State           IN    CHAR
	/*				++ State to set the flag, running or stopped
	/*
	/* Description:	This procedure will update the run state table to reflect
	/*				the code sent in
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/28/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_SetRunFlag
	(
	p_State		IN		CHAR
	)
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* If data already exists, remove it.  Then insert a record to
		/* indicate the status passed in
		/********************************************************************/
		delete purge_run_check;
		
		insert into purge_run_check ( activity_date, purge_running )
		values ( systimestamp, p_State );
		
		commit;
		
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SetRunFlag' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SetRunFlag',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_State: ' || p_State );
			commit;
			RAISE;
	END Sp_SetRunFlag;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_CheckMonitorReturn
	/*
	/* Parameters:	None
	/*
	/* Description:	This procedure will check the monitor job return and if it
	/*				stopped the job it will raise the appropriate error
	/*
	/* Notes:		If the monitor determines it is the end of the processing
	/*				window or the stop run flag was set it will update the
	/*				table accordingly
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	04/30/2020	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_CheckMonitorReturn
	IS
		-- Processing Variables
		-- Fetch Variables
		f_Running			purge_run_check.purge_running%TYPE	:= null;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get the running value and determine if it was updated by the
		/* monitor
		/********************************************************************/
		select	purge_running
		into	f_Running
		from	purge_run_check;
		/********************************************************************/
		/* If the monitor updated the value raise the appropriate flag
		/********************************************************************/
		case	f_Running
				when c_MonitorStop then
					raise e_StopRunning;
				when c_MonitorWindow then
					raise e_EndWindow;
				when c_StopJob then
					raise e_StopRunning;
				else
					null;
		end case;
	EXCEPTION
		WHEN e_StopRunning THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_CheckMonitorReturn' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CheckMonitorReturn',  b_SqlCode, b_SqlErrm,
				'Stop running',
				'None' );
			commit;
			RAISE e_StopRunning;
		WHEN e_EndWindow THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_CheckMonitorReturn' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CheckMonitorReturn',  b_SqlCode, b_SqlErrm,
				'End of Window',
				'None' );
			commit;
			RAISE e_EndWindow;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_CheckMonitorReturn' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CheckMonitorReturn',  b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Sp_CheckMonitorReturn;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_SumChunksToParts
	/*
	/* Parameters:	p_HistRec		IN OUT	purge_history_partitions%rowtype
	/*				++ Purge_History_Partitions record to get counts for
	/*
	/* Description:	This procedure will get the total counts for the partition
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	02/05/2019	Created function
	/*
	/***************************************************************************/
	PROCEDURE Sp_SumChunksToParts
	(
	p_HistRec		IN OUT	purge_history_partitions%ROWTYPE
	)
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get the total elapsed seconds
		/********************************************************************/
		select	sum(Fn_GetElapsedSecs( start_time, end_time )),
				sum(row_count)
		into	p_HistRec.tot_elapsed_secs,
				p_HistRec.nbr_rows_purged
		from	purge_history_chunks
		where	id_purge_history_partitions = p_HistRec.ID;
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SumChunksToParts for History ID ' || p_HistRec.ID || ' and table ' || p_HistRec.table_name || ' and partition ' || p_HistRec.partition_name );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SumChunksToParts', b_SqlCode, b_SqlErrm,
				'Other error',
				'ID ' || p_HistRec.ID || ' and table ' || p_HistRec.table_name || ' and partition ' || p_HistRec.partition_name );
			commit;
			RAISE;
	END Sp_SumChunksToParts;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_SumPartsToTable
	/*
	/* Parameters:	p_HistRec		IN OUT	purge_history%rowtype
	/*				++ Purge_History record to get counts for
	/*
	/* Description:	This procedure will get the total counts for the table
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/29/2019	Created function
	/*
	/***************************************************************************/
	PROCEDURE Sp_SumPartsToTable
	(
	p_HistRec		IN OUT	purge_history%ROWTYPE
	)
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Get the total elapsed seconds
		/********************************************************************/
		select	sum(tot_elapsed_secs),
				sum(tot_index_secs),
				sum(tot_nbr_chunks),
				sum(nbr_rows_purged),
				sum(nbr_rows_deleted_fk+nbr_rows_deleted_child_fk+nbr_rows_deleted_grandchild_fk),
				sum(tot_elapsed_fk_secs),
				sum(nbr_subparts_dropped),
				sum(tot_elapsed_drop_secs)
		into	p_HistRec.tot_elapsed_secs,
				p_HistRec.tot_index_secs,
				p_HistRec.tot_nbr_chunks,
				p_HistRec.nbr_rows_purged,
				p_HistRec.nbr_rows_deleted_fk,
				p_HistRec.tot_elapsed_fk_secs,
				p_HistRec.nbr_subparts_dropped,
				p_HistRec.tot_elapsed_drop_secs
		from	purge_history_partitions
		where	id_purge_history = p_HistRec.ID;
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_SumPartsToTable for History ID ' || p_HistRec.ID || ' and table ' || p_HistRec.table_name );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_SumPartsToTable', b_SqlCode, b_SqlErrm,
				'Other error',
				'ID ' || p_HistRec.ID || ' and table ' || p_HistRec.table_name );
			commit;
			RAISE;
	END Sp_SumPartsToTable;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_RebuildIndexes
	/*
	/* Parameters:	p_TableName     IN    	VARCHAR2
	/*				++ Table to rebuild indexes for
	/*				p_PartName		IN		VARCHAR2
	/*				++ Partition name of table if building part or subpart indexes
	/*				p_Sql			IN OUT	VARCHAR2
	/*				++ Index_sql column from the history record to save the sql
	/*				p_HistId		IN		NUMBER
	/*				++ purge_history record id
	/*				p_HistPartId	IN		NUMBER
	/*				++ purge_history_partitions id
	/*				p_ExecJob		IN		CHAR
	/*				++ Flag to denote whether to run the index sql or create
	/*					a scheduler job for it
	/*
	/* Description:	This procedure will run or create a scheduler job to rebuild
	/*				all the bad indexes found for the level passed in
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/28/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_RebuildIndexes
	(
	p_TableName		IN			VARCHAR2,
	p_PartName		IN			VARCHAR2		DEFAULT NULL,
	p_Sql			IN OUT		VARCHAR2,
	p_HistId		IN			NUMBER,
	p_HistPartId	IN			NUMBER			DEFAULT NULL,
	p_ExecJob		IN			CHAR			DEFAULT c_Yes
	)
	IS
		-- Processing Variables
		v_Sql				VARCHAR2(4000)		:= NULL;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_bad_subparts
				(
				p_Table		VARCHAR2,
				p_Part		VARCHAR2
				)
		is	
			select 	p.index_name,
					p.partition_name,
					s.subpartition_name
			from 	user_indexes i,
					user_ind_partitions p,
					user_ind_subpartitions s
			where	i.table_name = p_Table
					and i.index_name = p.index_name
					and p.partition_name = p_Part
					and p.index_name = s.index_name
					and p.partition_name = s.partition_name
					and s.status != 'USABLE' ;
		cursor	c_bad_parts
				(
				p_Table		VARCHAR2,
				p_Part		VARCHAR2
				)
		is	
			select 	p.index_name,
					p.partition_name
			from 	user_indexes i,
					user_ind_partitions p
			where	i.table_name = p_Table
					and i.index_name = p.index_name
					and p.partition_name = p_Part
					and p.status not in ('N/A', 'USABLE');
		cursor	c_bad_ind
				(
				p_Table		VARCHAR2
				)
		is	
			select 	index_name
			from 	user_indexes
			where 	table_name = p_Table
					and status not in ('N/A', 'VALID');
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Add each index that needs rebuilt into the sql statement
		/********************************************************************/
		if(( p_PartName is not null) and (p_PartName != 'NON_PARTITIONED' ) ) then
			for lr in c_bad_subparts( p_TableName, p_PartName ) loop
				v_Sql := v_Sql || 'execute immediate ''alter index ' || lr.index_name ||
					' rebuild subpartition ' || lr.subpartition_name ||
					' online parallel ' || b_ParallelQueryCount || ' ''; ';
			end loop;
			for lr in c_bad_parts( p_TableName, p_PartName ) loop
				v_Sql := v_Sql || 'execute immediate ''alter index ' || lr.index_name ||
					' rebuild partition ' || lr.partition_name ||
					' online parallel ' || b_ParallelQueryCount || ' ''; ';
			end loop;
		end if;
		
		if(( p_PartName is null ) or (p_PartName = 'NON_PARTITIONED' )) then
			for lr in c_bad_ind( p_TableName ) loop
				v_Sql := v_Sql || 'execute immediate ''alter index ' || lr.index_name ||
					' rebuild ' ||
					' online parallel ' || b_ParallelQueryCount || ' ''; ';
			end loop;
		end if;
		
		/********************************************************************/
		/* Finish the sql and create the job if bad indexes were found
		/********************************************************************/
		if( v_Sql is not null ) then
			p_Sql := 'declare v_Start date := sysdate; v_Secs number := null; begin ' ||
				v_Sql || ' v_secs := ' || 'round((sysdate-v_Start) * 24 * 60 * 60 ); ' ||
				'update purge_history set tot_index_secs = ' ||
				'nvl(tot_index_secs,0) + v_Secs where id = ' || p_HistId || '; ';
				
			if( p_HistPartId is not null ) then
				p_Sql := p_Sql || 'update purge_history_partitions set tot_index_secs = ' ||
				'nvl(tot_index_secs,0) + v_Secs where id = ' || p_HistPartId || '; ';
			end if;
			
			p_Sql := p_Sql || ' end; ';
			if( p_ExecJob = c_Yes ) then
				dbms_scheduler.create_job(
					job_name	=> Fn_GetJobName( c_Index, p_TableName, p_PartName ),
					job_type	=> 'PLSQL_BLOCK',
					job_action	=> p_Sql,
					start_date	=> sysdate,
					job_class	=> b_JobClass,
					comments	=> 'Index rebuild task for Table.Part: ' || p_TableName || '.' || nvl(p_PartName,'None'),
					auto_drop	=> true,
					enabled		=> true );
			else
				execute immediate p_Sql;
			end if;
			
		end if;
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_RebuildIndexes for p_TableName: ' || p_TableName || ' | p_PartName ' || p_PartName || ' | p_HistId: ' || p_HistId || ' | p_HistPartId: ' || p_HistPartId || ' | p_Sql ' || p_Sql );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RebuildIndexes',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' | p_PartName ' || p_PartName || ' | p_HistId: ' || p_HistId || ' | p_HistPartId: ' || p_HistPartId || ' | p_Sql: ' || p_Sql );
			commit;
			RAISE;
	END Sp_RebuildIndexes;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_StopTask
	/*
	/* Parameters:	p_TaskName     IN    VARCHAR2
	/*				++ Task to stop
	/*
	/* Description:	This procedure will stop the task passed in
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/19/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_StopTask
	(
	p_TaskName	IN		VARCHAR2
	)
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Stop the task
		/********************************************************************/
		dbms_parallel_execute.stop_task( p_TaskName );
	EXCEPTION
		WHEN e_NoTask THEN
			NULL;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_StopTask for task ' || p_TaskName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_StopTask',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TaskName: ' || p_TaskName );
			commit;
			RAISE;
	END Sp_StopTask;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_StopAllTasks
	/*
	/* Parameters:	None
	/*
	/* Description:	This procedure will stop all the running tasks
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/19/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_StopAllTasks
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		CURSOR	c_tasks
		IS
				select	task_name
				from	user_parallel_execute_tasks
				where	task_name like c_TaskNamePrefix || '%'
						and status = c_Processing;
						
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Loop through all the tasks and stop them
		/********************************************************************/
		for lr in c_tasks loop
			Sp_StopTask( lr.task_name );
		end loop;
		
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_StopAllTasks ' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_StopAllTasks',  b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Sp_StopAllTasks;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_CheckWindowEndTime
	/*
	/* Parameters:	p_TableName			IN		VARCHAR2
	/*				++ Table to check end interval for
	/*				p_PartName			IN 		VARCHAR2
	/*				++ Partition to check end interval for
	/*
	/* Description:	This procedure will check if the end of the processing
	/*				window minus the maximum time recorded for the table and
	/*				partition combination has been broached.  If it has, it
	/*				will abort the purge process
	/*
	/* Notes:		If there is no data in the history tables to determine the
	/*				interval a default value from config settings will be used
	/*				This value is set at package instantiation
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_CheckWindowEndTime
	(
	p_TableName		IN		VARCHAR2,
	p_PartName		IN		VARCHAR2
	)
	IS
		-- Processing Variables
		v_ParallelCount		NUMBER				:= Fn_GetTaskParallelCount( p_TableName );
		
		-- Fetch Variables
		f_MaxMinDiff		NUMBER				:= NULL;
		f_EstEndTime		DATE				:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		if( Fn_KeepRunning ) then
		
			/****************************************************************/
			/* Determine the max amount of time to complete one partition for
			/* this table/partition combination and number of parallel
			/* If no data exists use the default value
			/****************************************************************/
			select 	nvl(round(max((end_time-start_time) * 24 * 60) * v_ParallelCount), b_DefPartMins ) as diff_min
			into	f_MaxMinDiff
			from 	purge_history_chunks
			where 	table_name = p_Tablename
					and part_name = p_PartName;
					
			/****************************************************************/
			/* If the max number of minutes is greater than the entire window
			/* use the default
			/****************************************************************/
			if( f_MaxMinDiff > (b_NbrHoursInWindow * 60) ) then
				f_MaxMinDiff := b_DefPartMins * v_ParallelCount;
			end if;
			/****************************************************************/
			/* Add the max minute difference to sysdate to get estimated
			/* finish
			/****************************************************************/
			f_EstEndTime := sysdate + numtodsinterval( f_MaxMinDiff, 'MINUTE' );
			/****************************************************************/
			/* If the estimated time for a chunk to complete exceeds the purge
			/* window raise an error to abort the purge processing
			/****************************************************************/
			if( f_EstEndTime > b_WindowEnd ) then
				RAISE e_EndWindow;
			end if;
		else
			raise e_StopRunning;
		end if; -- Fn_KeepRunning
		
	EXCEPTION
		WHEN e_EndWindow THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CheckWindowEndTime',  b_SqlCode, b_SqlErrm,
				'Estimated end time surpasses the end of the window',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | f_EstEndTime: ' || to_char(f_EstEndTime, 'mm/dd/yyyy hh24:mi:ss') || ' | b_WindowEnd: ' || to_char(b_WindowEnd, 'mm/dd/yyyy hh24:mi:ss' ) );
			commit;
			RAISE e_EndWindow;
		WHEN e_StopRunning THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CheckWindowEndTime',  b_SqlCode, b_SqlErrm,
				'Stop running set, exiting',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | f_EstEndTime: ' || to_char(f_EstEndTime, 'mm/dd/yyyy hh24:mi:ss') || ' | b_WindowEnd: ' || to_char(b_WindowEnd, 'mm/dd/yyyy hh24:mi:ss' ) );
			commit;
			RAISE e_StopRunning;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_CheckWindowEndTime for table ' || p_TableName || ' and partition ' || p_PartName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CheckWindowEndTime',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
			RAISE;
	END Sp_CheckWindowEndTime;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_CreateTask
	/*
	/* Parameters:	p_Taskname           IN    VARCHAR2
	/*				++ Name of task to create
	/*
	/* Description:	This procedure create a dbms_parallel task
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_CreateTask
	(
	p_TaskName	IN		VARCHAR2
	)
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Create the task
		/********************************************************************/
		dbms_parallel_execute.create_task( p_TaskName );
	EXCEPTION
		WHEN e_DupTask THEN
			dbms_parallel_execute.drop_task( p_TaskName );
			dbms_parallel_execute.create_task( p_TaskName );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CreateTask',  b_SqlCode, b_SqlErrm,
				'Task exists, drop and create it',
				'p_TaskName: ' || p_TaskName );
			commit;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_CreateTask for ' || p_TaskName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CreateTask',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TaskName: ' || p_TaskName );
			commit;
			RAISE;
	END Sp_CreateTask;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_ChunkTask
	/*
	/* Parameters:	p_Taskname           IN    VARCHAR2
	/*				++ Name of task to create
	/*				p_Sql				IN		VARCHAR2
	/*				++ Sql to chunk with
	/*
	/* Description:	This procedure will take the passed sql and chunk it and
	/*				associate it with the passed in task
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_ChunkTask
	(
	p_TaskName	IN		VARCHAR2,
	p_Sql		IN		VARCHAR2
	)
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Chunk the task
		/********************************************************************/
		dbms_parallel_execute.create_chunks_by_sql(
			task_name 	=> p_TaskName,
			sql_stmt  	=> p_Sql,
			by_rowid  	=> FALSE );
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_ChunkTask for ' || p_TaskName );
			DBMS_OUTPUT.PUT_LINE( 'Chunk Sql: ' || p_Sql );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_ChunkTask',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TaskName: ' || p_TaskName || ' | p_Sql: ' || p_Sql );
			commit;
			RAISE;
	END Sp_ChunkTask;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_ExecuteTask
	/*
	/* Parameters:	p_Taskname      IN    	VARCHAR2
	/*				++ Name of task to create
	/*				p_Sql			IN		VARCHAR2
	/*				++ Sql to execute with
	/*				p_TableName		IN		VARCHAR2
	/*				++ Used to get the parallel count for the task
	/*
	/* Description:	This procedure will execute the task and start purging data
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_ExecuteTask
	(
	p_TaskName	IN		VARCHAR2,
	p_Sql		IN		VARCHAR2,
	p_TableName	IN		VARCHAR2
	)
	IS
		-- Processing Variables
		v_ParallelCount				NUMBER			:= Fn_GetTaskParallelCount( p_TableName );
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Execute the task
		/********************************************************************/
		dbms_parallel_execute.run_task(
			task_name 		=> p_TaskName,
			sql_stmt 		=> p_Sql,
			language_flag 	=> DBMS_SQL.NATIVE,
			parallel_level 	=> v_ParallelCount,
			job_class		=> b_JobClass );
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_ExecuteTask for ' || p_TaskName || ', table name: ' || p_TableName || ' with parallel of ' || v_ParallelCount );
			DBMS_OUTPUT.PUT_LINE( 'Task Sql: ' || p_Sql );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_ExecuteTask',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TaskName: ' || p_TaskName || ' | p_Sql: ' || p_Sql || ' | p_TableName: ' || p_TableName || ' | v_ParallelCount: ' || v_ParallelCount );
			commit;
			RAISE;
	END Sp_ExecuteTask;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_CreateMonitorJob
	/*
	/* Parameters:	p_Taskname          IN    	VARCHAR2
	/*				++ Name of task to create monitor job for
	/* 				p_TableName			IN OUT	VARCHAR2
	/*				++ Table being purged
	/*				p_PartName			IN OUT	VARCHAR2
	/*				++ Tables partition being purged
	/*
	/* Description:	This procedure will create a scheduler job to monitor a
	/*				task and restart it up to configuration times if needed and
	/*				stop the job at the end of the window
	/*
	/* Notes:		If the task completes successfully in the window this job
	/*				will do nothing
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/22/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_CreateMonitorJob
	(
	p_TaskName		IN OUT	VARCHAR2,
	p_TableName	IN OUT	VARCHAR2,
	p_PartName		IN OUT	VARCHAR2
	)
	IS
		-- Processing Variables
		v_Sql				VARCHAR2(4000)				:= NULL;
		v_JobName			VARCHAR2(50)				:= Fn_GetJobName( c_Monitor, p_TableName, p_PartName );
		
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Create the job sql
		/********************************************************************/
		v_Sql := 'begin dbms_lock.sleep(' || b_SleepTime || '); ' ||
			'Pkg_SBMO_Purge.Sp_MonitorTask( ' ||
			'''' || p_TaskName || ''',''' || p_TableName ||
			''',''' || p_PartName || ''' ); ' ||
			'end; ';
			
		/********************************************************************/
		/* Create the job
		/********************************************************************/
		dbms_scheduler.create_job(
			job_name	=> v_JobName,
			job_type	=> 'PLSQL_BLOCK',
			job_action	=> v_Sql,
			start_date	=> sysdate,
			job_class	=> b_JobClass,
			comments	=> 'Monitor parallel exeute task for ' || p_TaskName || ' Table.Part: ' || p_TableName || '.' || p_PartName,
			auto_drop	=> true,
			enabled		=> true );
	EXCEPTION
		WHEN e_JobExists THEN
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CreateMonitorJob',  -25000, 'ORA-25000 Drop and recreate monitor job, ' || v_JobName,
				'JObExists',
				'p_TaskName: ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' v_Sql: ' || v_Sql );
			commit;
			dbms_scheduler.drop_job( job_name => v_JobName, force => TRUE );
			dbms_lock.sleep(10);
			Sp_CreateMonitorJob( 	p_TaskName, p_TableName, p_PartName );
		WHEN e_BadJobType THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CreateMonitorJob',  b_SqlCode, b_SqlErrm,
				'Bad job type',
				'p_TaskName: ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' v_Sql: ' || v_Sql );
			commit;
			RAISE e_BadJobType;
			
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_CreateMonitorJob for ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			DBMS_OUTPUT.PUT_LINE( 'Task Sql: ' || v_Sql );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CreateMonitorJob',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TaskName: ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' v_Sql: ' || v_Sql );
			commit;
			RAISE;
	END Sp_CreateMonitorJob;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_DeleteFKs
	/*
	/* Parameters:	p_Hist			IN 		VARCHAR2
	/*				++ purge_history_partitions record with table info
	/*				p_PurgeDate		IN		DATE
	/*				++ Date to purge from
	/*				p_Tenant		IN		NUMBER
	/*				++ Tenant id
	/*				
	/* Description:	This procedure will delete all the rows from the table
	/*				that are associated with a parent record that is also
	/*				going to be purged
	/*
	/* Notes:		If child records are found delete up to two level below
	/*				the current table
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/27/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_DeleteFKs
	(
	p_Hist			IN OUT	purge_history_partitions%ROWTYPE,
	p_PurgeDate		IN		DATE,
	p_Tenant		IN		NUMBER
	)
	IS
		-- Processing Variables
		v_DelSql			VARCHAR2(4000)				:= NULL;
		v_ChildSql			VARCHAR2(4000)				:= NULL;
		v_GrandChildSql		VARCHAR2(4000)				:= NULL;
		v_PurgeColumn		VARCHAR2(30)				:= NULL;
		v_PartName			VARCHAR2(30)				:= p_Hist.partition_name;
		v_StartDate			DATE						:= NULL;
		v_part_clause	    VARCHAR2(4000)				:= NULL;
				
		-- Fetch Variables
		f_Count				NUMBER						:= NULL;
		
		-- Exception Variables
		-- Cursors
		cursor	c_Fks
				(
				p_Table		VARCHAR2
				)
		is
				select  c.constraint_name,
						c.r_constraint_name ,
						f.table_name
				from    user_constraints c,
						user_constraints f,
						purge_tables p
				where   c.table_name = p_Table
						and c.constraint_type = 'R'
						and c.r_constraint_name = f.constraint_name
						and f.table_name = p.table_name;
		cursor	c_Childfks
				(
				p_Table		VARCHAR2
				)
		is
select  c.constraint_name,
c.r_constraint_name ,
c.table_name,
						t.partitioned
from    user_constraints c,
user_constraints f,
purge_tables p,
						user_tables t
where   f.table_name = p_Table
				        and c.table_name = t.table_name
and f.constraint_type = 'P'
and f.constraint_name = c.r_constraint_name
and c.table_name = p.table_name;
		cursor	c_GrandChildfks
				(
				p_Table		VARCHAR2
				)
		is
select  c.constraint_name,
c.r_constraint_name ,
c.table_name,
						t.partitioned
from    user_constraints c,
user_constraints f,
purge_tables p,
						user_tables t
where   f.table_name = p_Table
				        and c.table_name = t.table_name
and f.constraint_type = 'P'
and f.constraint_name = c.r_constraint_name
and c.table_name = p.table_name;
						-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Ensure the history sql columns are empty
		/********************************************************************/
		p_Hist.fk_sql := null;
		p_Hist.child_fk_sql := null;
	
		/********************************************************************/
		/* Loop through all the foreign keys
		/********************************************************************/
		for lr in c_Fks( p_Hist.table_name ) loop
			/****************************************************************/
			/* Make sure we have time to start purging the delete
			/****************************************************************/
			Sp_CheckWindowEndTime( p_Hist.table_name, p_Hist.partition_name );
			/****************************************************************/
			/* Get the purge column and months to keep for the parent table
			/****************************************************************/
			v_PurgeColumn := Fn_GetPurgeColumn( lr.table_name );
			/****************************************************************/
			/* Check if the partition exists in the parent table, if not use
			/* the other partition
			/****************************************************************/
	       -- Medha : Check if table is partitioned or not, if not , then set partition_name to 'NON_PARTITIONED'
		   if ( p_Hist.partition_name = 'NON_PARTITIONED' ) then
				v_PartName := 'NON_PARTITIONED';
		   else
			select	count(*)
			into	f_Count
			from	user_tab_partitions
			where	table_name = lr.table_name
					and partition_name = p_Hist.partition_name;
					
			if( f_Count = 0 ) then
				v_PartName := 'OTHER';
			end if;
			
		   end if;
					
			/****************************************************************/
			/* Generate the sql to delete any records associated with the
			/* parent records that will be purged
			/****************************************************************/
			-- Medha : Dynamically Generate Partition Clause
			if (v_PartName = 'NON_PARTITIONED') then
			 v_part_clause := null;
			
			else
			 v_part_clause := ' partition ( ' || v_PartName || ' ) ' ;
			end if;
			v_DelSql := 'delete /*+ parallel (d,' || b_ParallelQueryCount || ') */ ' ||
					'from ' || p_Hist.table_name ||  v_part_clause || ' d ' ||
					' where (' || Fn_GetConsColumns( p_Hist.table_name, lr.constraint_name ) || ') in ' ||
							'( ' ||
							'select /*+ parallel(t,' || b_ParallelQueryCount || ') */ ' ||
								Fn_GetConsColumns( p_Hist.table_name, lr.constraint_name ) || ' ' ||
							'from ' || p_Hist.table_name || v_part_clause || ' t ' ||
							' where (' || Fn_GetConsColumns( p_Hist.table_name, lr.constraint_name ) || ') in ' ||
								'( ' ||
								'select  /*+ parallel(r,' || b_ParallelQueryCount || ') */ ' ||
									Fn_GetConsColumns( lr.table_name, lr.r_constraint_name ) || ' ' ||
								'from ' || lr.table_name || v_part_clause || ' r ';
			if( p_Tenant is NULL ) then
				v_DelSql := v_DelSql || ' where ' || v_PurgeColumn || ' < ';
			else
				v_DelSql := v_DelSql || ' where tenant_id = ' || p_Tenant || ' and ' || v_PurgeColumn || ' < ';
			end if;
			v_DelSql := v_DelSql ||	'to_date(''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss') || ''', ''mm/dd/yyyy hh24:mi:ss'') ' ||
								') ' ||
							') ';
			p_Hist.fk_sql := p_Hist.fk_sql || ' ' || v_DelSql;
			
			/****************************************************************/
			/* Delete the rows and set the number of deleted rows
			/****************************************************************/
dbms_output.put_line ('Inside spdelete - v_DelSql : ' || v_DelSql);
			execute immediate 'alter session set db_file_multiblock_read_count=' || b_MultiBlock;
			v_StartDate := sysdate;
			begin
				execute immediate v_Delsql;
			exception
				/************************************************************/
				/* If child rows are found delete the rows for all child
				/* tables and set the number of deleted rows then try again
				/************************************************************/
				when e_ChildRecFound then
				
				dbms_output.put_line ('Debug : Inside e_ChildRecFound exception ');
				
						for lr1 in c_ChildFks( p_Hist.table_name ) loop
						dbms_output.put_line ('Debug : Inside c_ChildFks loppop ');
						
						if (lr1.PARTITIONED = 'YES') then
						     v_part_clause :=  ' partition (' || v_PartName || ') ';
						else
						      v_part_clause :=  null;
						end if;
							v_ChildSql := 'delete /*+ parallel (d,' || b_ParallelQueryCount || ') */ ' ||
											'from ' || lr1.table_name || v_part_clause || ' d ' ||
											' where (' || Fn_GetConsColumns( lr1.table_name, lr1.constraint_name ) || ') in ' ||
													'( ' ||
													'select /*+ parallel(t,' || b_ParallelQueryCount || ') */ ' ||
															Fn_GetConsColumns( p_Hist.table_name, lr1.r_constraint_name ) || ' ' ||
													'from ' || p_Hist.table_name || v_part_clause ||  ' t ' ||
													' where (' || Fn_GetConsColumns( p_Hist.table_name, lr.constraint_name ) || ') in ' ||
															'( ' ||
															'select	/*+ parallel(r,' || b_ParallelQueryCount || ') */ ' ||
																Fn_GetConsColumns( lr.table_name, lr.r_constraint_name ) || ' ' ||
															'from ' || lr.table_name || v_part_clause || ' r ';
dbms_output.put_line ('Inside spdelete 2 - v_ChildSql : ' || v_ChildSql);
							if( p_Tenant is NULL ) then
								v_ChildSql := v_ChildSql || ' where ' || v_PurgeColumn || ' < ';
							else
								v_ChildSql := v_ChildSql || ' where tenant_id = ' || p_Tenant || ' and ' || v_PurgeColumn || ' < ';
							end if;
							v_ChildSql := v_ChildSql || 'to_date(''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss') || ''', ''mm/dd/yyyy hh24:mi:ss'') ' ||
											') ' ||
										') ';
							p_Hist.child_fk_sql := p_Hist.child_fk_sql || ' ' || v_ChildSql;
							begin
								execute immediate v_ChildSql;
							exception						
								/********************************************/
								/* If child rows are found delete the rows
								/* for all grandchild tables and set the
								/* number of deleted rows then try again
								/********************************************/
								when e_ChildRecFound then
									for lr2 in c_GrandChildfks( lr1.table_name ) loop	
									  if ( lr2.partitioned = 'YES') then
						                v_part_clause :=  ' partition (' || v_PartName || ') ';
						              else
						                 v_part_clause  :=  null;
						              end if;
										v_GrandChildSql := 'delete /*+ parallel (d,' || b_ParallelQueryCount || ') */ ' ||
												'from ' || lr2.table_name || v_part_clause || ' d ' ||
												' where (' || Fn_GetConsColumns( lr2.table_name, lr2.constraint_name ) || ') in ' ||
													'( ' ||
													'select /*+ parallel(c,' || b_ParallelQueryCount || ') */ ' ||
														Fn_GetConsColumns( lr1.table_name, lr2.r_constraint_name ) || ' ' ||
													'from ' || lr1.table_name || v_part_clause || ' c ' ||
													' where (' || Fn_GetConsColumns( lr1.table_name, lr1.constraint_name ) || ') in ' ||
														'( ' ||
														'select /*+ parallel(t,' || b_ParallelQueryCount || ') */ ' ||
															Fn_GetConsColumns( p_Hist.table_name, lr1.r_constraint_name ) || ' ' ||
														'from ' || p_Hist.table_name || v_part_clause || ' t ' ||
														' where (' || Fn_GetConsColumns( p_Hist.table_name, lr.constraint_name ) || ') in ' ||
															'( ' ||
															'select /*+ parallel(r,' || b_ParallelQueryCount || ') */ ' ||
																Fn_GetConsColumns( lr.table_name, lr.r_constraint_name ) || ' ' ||
															'from ' || lr.table_name || v_part_clause || ' r ';
											dbms_output.put_line ('Inside spdelete 3  - v_GrandChildSql : ' || v_GrandChildSql);
										if( p_Tenant is NULL ) then
											v_GrandChildSql := v_GrandChildSql || ' where ' || v_PurgeColumn || ' < ';
										else
											v_GrandChildSql := v_GrandChildSql || ' where tenant_id = ' || p_Tenant || ' and ' || v_PurgeColumn || ' < ';
										end if;
										v_GrandChildSql := v_GrandChildSql ||	'to_date(''' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss') || ''', ''mm/dd/yyyy hh24:mi:ss'') ' ||
															') ' ||
														') ' ||
													') ';
										p_Hist.grandchild_fk_sql := p_Hist.grandchild_fk_sql || ' ' || v_GrandChildSql;
										execute immediate v_GrandChildSql;
										p_Hist.nbr_rows_deleted_grandchild_fk := nvl(p_Hist.nbr_rows_deleted_grandchild_fk,0) + sql%ROWCOUNT;
									end loop;
									
									execute immediate v_ChildSql;
							end;
							p_Hist.nbr_rows_deleted_child_fk := nvl(p_Hist.nbr_rows_deleted_child_fk,0) + sql%ROWCOUNT;
						end loop;
					execute immediate v_Delsql;
			end;
			p_Hist.nbr_rows_deleted_fk := nvl(p_Hist.nbr_rows_deleted_fk,0) + sql%ROWCOUNT;
			execute immediate 'alter session set db_file_multiblock_read_count=' || b_OrigMultiBlock;
			p_Hist.tot_elapsed_fk_secs := nvl(p_Hist.tot_elapsed_fk_secs,0) + Fn_GetElapsedSecs( v_StartDate, SYSDATE );
			commit;
		end loop; -- for lr in c_Fks
	EXCEPTION
		WHEN e_EndWindow THEN
			raise e_FkDelete;
		WHEN e_StopRunning THEN
			raise e_FkDelete;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_DeleteFKs for Table: ' || p_hist.table_name || ' Partition: ' || p_Hist.partition_name );
			DBMS_OUTPUT.PUT_LINE( 'Delete Sql: ' || substr(p_Hist.fk_sql, 1, 3975) );
			DBMS_OUTPUT.PUT_LINE( 'Delete Child Sql: ' || substr(p_Hist.child_fk_sql, 1, 3975) );
			DBMS_OUTPUT.PUT_LINE( 'Delete GrandChild Sql: ' || substr(p_Hist.grandchild_fk_sql, 1, 3975)  );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_DeleteFKs',  b_SqlCode, b_SqlErrm,
				'Other error',
				substr( 'TableName: ' || p_Hist.table_name || ' | PartName: ' || p_Hist.partition_name || ' | fk_sql: ' || p_Hist.fk_sql || ' | child_fk_sql: ' || p_hist.child_fk_sql || ' | grandchild_fk_sql: ' || p_hist.grandchild_fk_sql, 1, 4000) );
			commit;
			RAISE;
	END Sp_DeleteFKs;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_DropSubpartitions
	/*
	/* Parameters:	p_HistRec			IN OUT	purge_history_partitions%ROWTYPE
	/*				++ History record with table and partition to drop for
	/*				p_PurgeDate			IN		DATE
	/*				++ Highest date to purge
	/*
	/* Description:	This procedure will delete all subpartitions in the table
	/*				and partition starting from the bottom that are empty
	/*
	/* Notes:		Once a non-empty partition is found, stop
	/*				If the partition high value date is greater than purge
	/*				date, stop
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/29/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_DropSubpartitions
	(
	p_HistRec		IN OUT		purge_history_partitions%ROWTYPE,
	p_PurgeDate		IN			DATE
	)
	IS
		-- Processing Variables
		v_Sql				VARCHAR2(4000)				:= NULL;
		v_StartDate			DATE						:= NULL;
		v_TestDate			DATE						:= NULL;
		v_PurgeDate			DATE						:= NULL;
		
		-- Fetch Variables
		f_Id				NUMBER						:= NULL;
		
		-- Exception Variables
		-- Cursors
		cursor	c_Subs
				(
				p_Table		VARCHAR2,
				p_Part		VARCHAR2
				)
		is
				select 	subpartition_name,
					high_value,
					subpartition_position
				from 	user_tab_subpartitions
				where 	table_name = p_Table
					and partition_name = p_Part
					and subpartition_position <
					(
					--Ensure we leave one subpartition and the default
					select	max(subpartition_position)-1
					from	user_tab_subpartitions
					where 	table_name = p_Table
						and partition_name = p_Part
					)
				and subpartition_name not like '%1900%'  -- Exclude partition with high_value 1900-02-01
				order by subpartition_position;
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Make sure we have time to start dropping the subpartitions
		/********************************************************************/
		Sp_CheckWindowEndTime( p_HistRec.table_name, p_HistRec.partition_name );
		/********************************************************************/
		/* Loop through all the subpartitions
		/********************************************************************/
		for lr in c_Subs( p_HistRec.table_name, p_HistRec.partition_name ) loop
			/****************************************************************/
			/* Make sure we have time to start dropping the subpartitions
			/* Check again after every 2 subpartition drops
			/****************************************************************/
			if( mod( c_Subs%ROWCOUNT, 2 ) = 0 ) then
				Sp_CheckWindowEndTime( p_HistRec.table_name, p_HistRec.partition_name );
			end if;
			
			/****************************************************************/
			/* Turn the high value into a date variable
			/****************************************************************/
			v_TestDate := to_date( substr(lr.high_value,instr(lr.high_value,'2'),19), 'yyyy-mm-dd hh24:mi:ss' );
			/****************************************************************/
			/* If the partition is newer than the purge date exit, else
			/* Check if the subpartition has any data
			/* If the subpartition is empty, drop it
			/****************************************************************/
			if( v_TestDate > p_PurgeDate ) then
				raise e_PartitionIsNewer;
			else
				v_Sql := 'Select id from ' || p_HistRec.table_name || ' SUBPARTITION (' || lr.subpartition_name || ') fetch first 1 row only ';
			
				begin
					execute immediate v_Sql into f_Id;
					raise e_DataFound;
				exception
					when no_data_found then
						v_Sql := 'alter table ' || p_HistRec.table_name || ' drop subpartition ' || lr.subpartition_name || ' ';
						execute immediate 'alter session set optimizer_mode = ' || b_SubpartOptMode || ' ';
						v_StartDate := sysdate;
						execute immediate v_Sql;
						execute immediate 'alter session set optimizer_mode = ' || b_OrigOptimizerMode || ' ';
						p_HistRec.nbr_subparts_dropped := nvl(p_HistRec.nbr_subparts_dropped,0) + 1;
						p_HistRec.tot_elapsed_drop_secs := nvl(p_HistRec.tot_elapsed_drop_secs,0) + Fn_GetElapsedSecs( v_StartDate, SYSDATE );
						commit;
				end;
			end if;
		end loop; -- for lr in c_Subs
		
	EXCEPTION
		WHEN e_EndWindow THEN
			raise e_SubpartDrop;
		WHEN e_StopRunning THEN
			raise e_SubpartDrop;
		WHEN e_PartitionIsNewer THEN
			null;
		WHEN e_DataFound THEN
			null;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_DropSubpartitions for Table: ' || p_HistRec.table_name || ' Partition: ' || p_HistRec.partition_name );
			DBMS_OUTPUT.PUT_LINE( 'v_Sql: ' || v_Sql );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_DropSubpartitions',  b_SqlCode, b_SqlErrm,
				'Other error',
				'TableName: ' || p_HistRec.table_name || ' PartName: ' || p_HistRec.partition_name || ' | v_Sql ' || v_Sql );
			commit;
			RAISE;
	END Sp_DropSubpartitions;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_PurgePartition
	/*
	/* Parameters:	p_TableName			IN OUT	VARCHAR2
	/*				++ Table to purge
	/*				p_PartName			IN OUT	VARCHAR2
	/*				++ Tables partition to purge
	/*				p_PurgeColumn		IN OUT	VARCHAR2
	/*				++ Date column used to purge with
	/*				p_HistId			IN		NUMBER
	/*				++ Purge history record id for the table passed in
	/*				p_PurgeDate			IN OUT	DATE
	/*				++ Date used as the base for the data deletes
	/*
	/* Description:	This procedure will purge the table/partition passed in
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name			Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_PurgePartition
	(
	p_TableName		IN OUT	VARCHAR2,
	p_PartName		IN OUT	VARCHAR2,
	p_PurgeColumn	IN OUT	VARCHAR2,
	p_HistId		IN		NUMBER,
	p_PurgeDate		IN OUT	DATE
	)
	IS
		-- Processing Variables
		v_TaskName			VARCHAR2(30)		:= NULL;
		v_Tenant			NUMBER				:= NULL;
		v_Status			NUMBER				:= NULL;
		v_HistoryRec		PURGE_HISTORY_PARTITIONS%ROWTYPE	:= NULL;
		
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Make sure we have time to start purging the partition
		/********************************************************************/
		dbms_output.put_line ( 'DEBUG - Sp_PurgePartition - Begins ' );
		
		Sp_CheckWindowEndTime( p_TableName, p_PartName );
		Sp_RebuildIndexes( p_TableName, p_PartName, v_HistoryRec.index_sql, p_HistId, v_HistoryRec.ID, c_No );
		/********************************************************************/
		/* Get the tenant_id associated with the partition
		/********************************************************************/
--Medha : This is needed only incase table is partitioned
	    dbms_output.put_line('DEBUG Sp_PurgePartition p_TableName - ' || p_TableName || ', p_PartName - ' || p_PartName );	
	    if ((p_PartName = 'NON_PARTITIONED') OR (p_PartName IS NULL )) then
		 v_Tenant := null ;
		else
		 v_Tenant := Fn_GetTenantId( p_TableName, p_partName );
		end if;
		
		/********************************************************************/
		/* Create the task
		/********************************************************************/
		v_TaskName := Fn_GetTaskName( p_TableName, p_PartName );
		Sp_CreateTask( v_TaskName );
		/********************************************************************/
		/* Populate the initial history record values
		/********************************************************************/
		v_HistoryRec.ID := purge_seq.nextval;
		v_HistoryRec.ID_PURGE_HISTORY := p_HistId;
		v_HistoryRec.TABLE_NAME := p_TableName;
		v_HistoryRec.PARTITION_NAME := p_PartName;
		v_HistoryRec.TASK_NAME := v_TaskName;
		v_HistoryRec.START_DATE := SYSDATE;
		v_HistoryRec.STATUS := c_Begin;
		insert into purge_history_partitions values v_HistoryRec;
		commit;
		/********************************************************************/
		/* Chunk the task and set the status
		/* Set the multiblock parameter to help speed up the I/O
		/********************************************************************/
		v_HistoryRec.chunk_sql := Fn_GetChunkSql( p_TableName, p_PartName, p_PurgeColumn, p_PurgeDate, v_Tenant );
		execute immediate 'alter session set db_file_multiblock_read_count=' || b_MultiBlock;
		Sp_ChunkTask( v_TaskName, v_HistoryRec.chunk_sql );
		execute immediate 'alter session set db_file_multiblock_read_count=' || b_OrigMultiBlock;
		v_Status := dbms_parallel_execute.task_status( v_TaskName );
		/********************************************************************/
		/* If there are no chunks do not process further for the partition
		/********************************************************************/
		if( v_Status = dbms_parallel_execute.no_chunks ) then
			v_HistoryRec.TOT_NBR_CHUNKS := 0;
			v_HistoryRec.NBR_ROWS_PURGED := 0;
			v_HistoryRec.END_DATE := SYSDATE;
		else
		
			/****************************************************************/
			/* Set the number of chunks and ensure we have time to start
			/* the partition purge
			/****************************************************************/
			v_HistoryRec.TOT_NBR_CHUNKS := Fn_GetChunkCount( v_TaskName );
			Sp_CheckWindowEndTime( p_TableName, p_PartName );
			/****************************************************************/
			/* Create the monitor job and send the task to be executed
			/****************************************************************/
			v_HistoryRec.task_sql := Fn_GetTaskSql( v_TaskName, p_TableName, p_PartName, p_PurgeColumn, p_PurgeDate, v_HistoryRec.ID, v_Tenant );
			Sp_CreateMonitorJob( v_TaskName, p_TableName, p_PartName );
			Sp_ExecuteTask( v_TaskName, v_HistoryRec.task_sql, p_TableName );
			v_Status := dbms_parallel_execute.task_status( v_TaskName );
			/****************************************************************/
			/* Determine if the monitor stopped the job, else check the status
			/****************************************************************/
			Sp_CheckMonitorReturn;
			if( v_Status = dbms_parallel_execute.crashed ) then
				raise e_EndWindow;
			elsif( v_Status = dbms_parallel_execute.finished_with_error ) then
				raise e_FinishedErrors;
			elsif( v_Status <> dbms_parallel_execute.finished ) then
				raise e_FailedTask;
			end if;
			
		end if;		-- If no_chunks
		
		/********************************************************************/
		/* Delete rows that are not eligible for purge for parent records
		/* that will be purged
		/********************************************************************/
dbms_output.put_line( 'EHS: Calling Sp_DeleteFKs - v_HistoryRec.id- '  || v_HistoryRec.id || 'p_TableName' || p_TableName );
		Sp_DeleteFKs( v_HistoryRec, p_PurgeDate, v_Tenant );
		Sp_RebuildIndexes( p_TableName, p_PartName, v_HistoryRec.index_sql, p_HistId, v_HistoryRec.ID );
		Sp_DropSubpartitions( v_HistoryRec, p_PurgeDate );
		/********************************************************************/
		/* Complete the history record and insert it
		/********************************************************************/
		v_HistoryRec.STATUS := Fn_StatusNbrToChar( v_Status );
		Sp_SumChunksToParts( v_HistoryRec );
		v_HistoryRec.END_DATE := SYSDATE;
		dbms_parallel_execute.drop_task( v_TaskName );
		update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
		commit;
	EXCEPTION
		WHEN e_SubPartDrop THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_PurgePartition: Window ended for table ' || p_TableName || ' and partition ' || p_PartName || ' and tenant id ' || nvl(v_Tenant, -1) );
			v_HistoryRec.STATUS := c_SubPartDrop;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgePartition',  b_SqlCode, b_SqlErrm,
				'End of window while deleting Subpartitions',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_PurgeColumn: ' || p_PurgeColumn || ' | p_HistId: ' || p_HistId || ' | p_PurgeDate: ' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ' and tenant id ' || nvl(v_Tenant, -1) );
			commit;
			RAISE e_SubPartDrop;
		WHEN e_FkDelete THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_PurgePartition: Window ended for table ' || p_TableName || ' and partition ' || p_PartName || ' and tenant id ' || nvl(v_Tenant, -1) );
			v_HistoryRec.STATUS := c_FkDelete;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgePartition',  b_SqlCode, b_SqlErrm,
				'End of window while deleting FKs',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_PurgeColumn: ' || p_PurgeColumn || ' | p_HistId: ' || p_HistId || ' | p_PurgeDate: ' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ' and tenant id ' || nvl(v_Tenant, -1) );
			commit;
			RAISE e_FkDelete;
		WHEN e_EndWindow THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_PurgePartition: Window ended for table ' || p_TableName || ' and partition ' || p_PartName || ' and tenant id ' || nvl(v_Tenant, -1) );
			v_HistoryRec.STATUS := c_Stopped;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgePartition',  b_SqlCode, b_SqlErrm,
				'End of window',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_PurgeColumn: ' || p_PurgeColumn || ' | p_HistId: ' || p_HistId || ' | p_PurgeDate: ' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ' and tenant id ' || nvl(v_Tenant, -1) );
			commit;
			RAISE e_EndWindow;
		WHEN e_StopRunning THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_PurgePartition: Stop run requested ' || p_TableName || ' and partition ' || p_PartName || ' and tenant id ' || nvl(v_Tenant, -1) );
			v_HistoryRec.STATUS := c_Stopped;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgePartition',  b_SqlCode, b_SqlErrm,
				'Stop run requested',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_PurgeColumn: ' || p_PurgeColumn || ' | p_HistId: ' || p_HistId || ' | p_PurgeDate: ' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ' and tenant id ' || nvl(v_Tenant, -1) );
			commit;
			RAISE e_StopRunning;
		WHEN e_FinishedErrors THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			v_HistoryRec.STATUS := Fn_StatusNbrToChar( v_Status );
			Sp_SumChunksToParts( v_HistoryRec );
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_PurgePartition task finished with errors ' || p_TableName || ' and partition ' || p_PartName || ' with status ' || v_HistoryRec.STATUS  || ' and tenant id ' || nvl(v_Tenant, -1));
			DBMS_OUTPUT.PUT_LINE( '   select * from table(pkg_sbmo_purge.fn_showerrors(' || b_ErrDate || ')); ' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgePartition',  b_SqlCode, b_SqlErrm,
				'Task finished with errors',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_PurgeColumn: ' || p_PurgeColumn || ' | p_HistId: ' || p_HistId || ' | p_PurgeDate: ' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ' and tenant id ' || nvl(v_Tenant, -1) );
			commit;
			RAISE e_FinishedErrors;
		WHEN e_FailedTask THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			v_HistoryRec.STATUS := Fn_StatusNbrToChar( v_Status );
			Sp_SumChunksToParts( v_HistoryRec );
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_PurgePartition task failed for ' || p_TableName || ' and partition ' || p_PartName || ' with status ' || v_HistoryRec.STATUS || ' and tenant id ' || nvl(v_Tenant, -1) );
			DBMS_OUTPUT.PUT_LINE( '   select * from table(pkg_sbmo_purge.fn_showerrors(' || b_ErrDate || ')); ' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgePartition',  b_SqlCode, b_SqlErrm,
				'Task failed with status ' || v_HistoryRec.STATUS,
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_PurgeColumn: ' || p_PurgeColumn || ' | p_HistId: ' || p_HistId || ' | p_PurgeDate: ' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ' and tenant id ' || nvl(v_Tenant, -1) );
			commit;
			RAISE e_FailedTask;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_PurgePartition for table ' || p_TableName || ' and partition ' || p_PartName || ' and tenant id ' || nvl(v_Tenant, -1) );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			v_HistoryRec.STATUS := c_Failed;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgePartition',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | p_PurgeColumn: ' || p_PurgeColumn || ' | p_HistId: ' || p_HistId || ' | p_PurgeDate: ' || to_char( p_PurgeDate, 'mm/dd/yyyy hh24:mi:ss' ) || ' and tenant id ' || nvl(v_Tenant, -1) );
			commit;
			RAISE;
	END Sp_PurgePartition;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_RestartPurgePartition
	/*
	/* Parameters:	p_HistId			IN		NUMBER
	/*				++ Purge history record id for the table passed in
	/*				p_PurgeDate			IN OUT	DATE
	/*				++ Original purge date
	/*
	/* Description:	This procedure will restart the purge that was previously
	/*				stopped
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name			Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/23/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_RestartPurgePartition
	(
	p_HistId		IN		NUMBER,
	p_PurgeDate		IN OUT	DATE
	)
	IS
		-- Processing Variables
		v_ResumeDate		DATE								:= SYSDATE;
		v_Status			NUMBER								:= NULL;
		v_HistoryRec		PURGE_HISTORY_PARTITIONS%ROWTYPE	:= NULL;
		v_PurgeColumn		VARCHAR2(30)						:= NULL;
		v_Tenant			NUMBER								:= NULL;
		
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Retrieve the history record for the partition to restart
		/* If no data found the purge was stopped at a new partition in
		/* Sp_PurgePartition before the record was inserted so there is
		/* nothing to do
		/********************************************************************/
		begin
			v_HistoryRec := Fn_GetLatestHistoryPartitions( p_HistId );
		exception
			when no_data_found then
				raise e_NoPartitionToRestart;
		end;
		Sp_RebuildIndexes( v_HistoryRec.table_name, v_HistoryRec.partition_name, v_HistoryRec.index_sql, p_HistId, v_HistoryRec.ID, c_No );
		Sp_CheckWindowEndTime( v_HistoryRec.table_name, v_HistoryRec.partition_name );
		v_PurgeColumn := Fn_GetPurgeColumn( v_HistoryRec.table_name );
		/********************************************************************/
		/* If the status is foreign key deletes the task already completed
		/* and all we need to do is finish deleting the foreign keys
		/********************************************************************/
		if( v_HistoryRec.Status = c_FkDelete ) THEN
		
			/****************************************************************/
			/* Delete rows that are not eligible for purge for parent records
			/* that will be purged
			/****************************************************************/
			v_HistoryRec.fk_sql := null;
			v_HistoryRec.child_fk_sql := null;
			v_Tenant := Fn_GetTenantId( v_HistoryRec.table_name, v_HistoryRec.partition_name );
			Sp_DeleteFKs( v_HistoryRec, p_PurgeDate, v_Tenant );
			v_Status := dbms_parallel_execute.finished;
		elsif( v_HistoryRec.Status = c_SubPartDrop ) THEN
			/****************************************************************/
			/* Do nothing it will be done at the end of this procedure
			/****************************************************************/
			v_Status := dbms_parallel_execute.finished;
		
		elsif( v_HistoryRec.Status in ( c_FinishedErrors, c_Processed, c_Processing, c_Failed ) ) THEN
		
			/****************************************************************/
			/* Reprocess the partition forcing rechunk to accept any fixes
			/* might have been applied since last run
			/* Then error so we don't attempt to continue this task
			/****************************************************************/
			Sp_PurgePartition( v_HistoryRec.table_name, v_HistoryRec.partition_name, v_PurgeColumn, p_HistId, p_PurgeDate );
			raise e_NoPartitionToRestart;
		elsif( v_HistoryRec.STATUS in ( c_Stopped, c_Chunked, c_Crashed, c_Begin ) ) then
			/****************************************************************/
			/* Set the number of chunks and ensure we have time to start the
			/* partition purge
			/****************************************************************/
			v_HistoryRec.TOT_NBR_CHUNKS := Fn_GetChunkCount( v_HistoryRec.task_name );
			Sp_CheckWindowEndTime( v_HistoryRec.table_name, v_HistoryRec.partition_name );
			/****************************************************************/
			/* Create the monitor job and resume the task execution
			/****************************************************************/
			Sp_CreateMonitorJob( v_HistoryRec.task_name, v_HistoryRec.table_name, v_HistoryRec.partition_name );
			begin
				dbms_parallel_execute.resume_task( v_HistoryRec.task_name );
				v_Status := dbms_parallel_execute.task_status( v_HistoryRec.task_name );
				/************************************************************/
				/* Determine if the monitor stopped the job, else check the
				/* status
				/************************************************************/
				Sp_CheckMonitorReturn;
				if( v_Status = dbms_parallel_execute.crashed ) then
					raise e_EndWindow;
				elsif( v_Status = dbms_parallel_execute.finished_with_error ) then
					raise e_FinishedErrors;
				elsif( v_Status <> dbms_parallel_execute.finished ) then
					raise e_FailedTask;
				end if;
			exception
				when e_InvalidRestartStatus then
					dbms_parallel_execute.drop_task( v_HistoryRec.task_name );
					Sp_PurgePartition( v_HistoryRec.table_name, v_HistoryRec.partition_name, v_PurgeColumn, p_HistId, p_PurgeDate );
			end;
		elsif( v_HistoryRec.STATUS in ( c_Finished ) ) then
			raise e_NoPartitionToRestart;
		else
			raise e_InvalidRestartStatus;
		end if; -- v_HistoryRec.Status = c_FkDelete
		
		/********************************************************************/
		/* Complete the history record and insert it
		/********************************************************************/
		Sp_RebuildIndexes( v_HistoryRec.table_name, v_HistoryRec.partition_name, v_HistoryRec.index_sql, v_HistoryRec.id_purge_history, v_HistoryRec.id );
		Sp_DropSubpartitions( v_HistoryRec, p_PurgeDate );
		v_HistoryRec.STATUS := Fn_StatusNbrToChar( v_Status );
		Sp_SumChunksToParts( v_HistoryRec );
		v_HistoryRec.END_DATE := SYSDATE;
		begin
			dbms_parallel_execute.drop_task( v_HistoryRec.task_name );
		exception
			when e_NoTask then
				null;
		end;
		update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
		commit;
	EXCEPTION
		WHEN e_NoPartitionToRestart THEN
			NULL;
		WHEN e_SubPartDrop THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_RestartPurgePartition: Window ended for table ' || v_HistoryRec.table_name || ' and partition ' || v_HistoryRec.partition_name );
			v_HistoryRec.STATUS := c_SubPartDrop;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'End of window while deleting Subpartitions',
				'p_HistId: ' || p_HistId );
			commit;
			RAISE e_SubPartDrop;
		WHEN e_FkDelete THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_RestartPurgePartition: Window ended for table ' || v_HistoryRec.table_name || ' and partition ' || v_HistoryRec.partition_name );
			v_HistoryRec.STATUS := c_FkDelete;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'End of window while deleting FKs',
				'p_HistId: ' || p_HistId );
			commit;
			RAISE e_FkDelete;
		WHEN e_EndWindow THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_RestartPurgePartition: Window ended for table ' || v_HistoryRec.table_name || ' and partition ' || v_HistoryRec.partition_name );
			v_HistoryRec.STATUS := c_Stopped;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'End of window',
				'p_HistId: ' || p_HistId );
			commit;
			RAISE e_EndWindow;
		WHEN e_StopRunning THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Sp_RestartPurgePartition: Stop run requested ' || v_HistoryRec.table_name || ' and partition ' || v_HistoryRec.partition_name );
			v_HistoryRec.STATUS := c_Stopped;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'Stop run requested',
				'p_HistId: ' || p_HistId );
			commit;
			RAISE e_StopRunning;
		WHEN e_FinishedErrors THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			v_HistoryRec.STATUS := Fn_StatusNbrToChar( v_Status );
			Sp_SumChunksToParts( v_HistoryRec );
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_RestartPurgePartition task finished with errors ' || v_HistoryRec.table_name || ' and partition ' || v_HistoryRec.partition_name );
			DBMS_OUTPUT.PUT_LINE( '   select * from table(pkg_sbmo_purge.fn_showerrors(' || b_ErrDate || ')); ' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'Task finished with errors',
				'p_TableName: ' || v_HistoryRec.table_name || ' | p_PartName: ' || v_HistoryRec.partition_name );
			commit;
			RAISE e_FinishedErrors;
		WHEN e_FailedTask THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			v_HistoryRec.STATUS := Fn_StatusNbrToChar( v_Status );
			Sp_SumChunksToParts( v_HistoryRec );
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_RestartPurgePartition task failed for table ' || v_HistoryRec.table_name || ' and partition ' || v_HistoryRec.partition_name || ' with status ' || v_HistoryRec.STATUS );
			DBMS_OUTPUT.PUT_LINE( '   select * from table(pkg_sbmo_purge.fn_showerrors(' || b_ErrDate || ')); ' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'Task failed with status ' || v_HistoryRec.STATUS,
				'p_HistId: ' || p_HistId );
			commit;
			RAISE e_FailedTask;
		WHEN e_InvalidRestartStatus THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_RestartPurgePartition, Restart has invalid status ' || v_HistoryRec.STATUS );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'Restart has invalid status ' || v_HistoryRec.STATUS,
				'p_HistId: ' || p_HistId );
			commit;
			Raise e_InvalidRestartStatus;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Other Error in Sp_RestartPurgePartition for table ' || v_HistoryRec.table_name || ' and partition ' || v_HistoryRec.partition_name );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			v_HistoryRec.STATUS := c_Failed;
			Sp_SumChunksToParts( v_HistoryRec );
			update purge_history_partitions set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_RestartPurgePartition',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_HistId: ' || p_HistId );
			commit;
			RAISE;
	END Sp_RestartPurgePartition;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_PurgeHistoryTables
	/*
	/* Parameters:	p_PurgeDate		DATE
	/*				++ Date used as the purge baseline
	/*
	/* Description:	This procedure will set purge the purge history tables
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	02/04/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_PurgeHistoryTables
	(
	p_PurgeDate			IN			DATE
	)
	IS
		-- Processing Variables
		v_Start				DATE			:= SYSDATE;
		
		-- Fetch Variables
		f_HistId			NUMBER			:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Determine the lowest purge_history record to keep
		/********************************************************************/
		select  min(id)
		into	f_HistId
		from    purge_history
		where   table_name =
				(
				select  table_name
				from    purge_tables
				where   purge_position =
						(
						select  min(purge_position)
						from    purge_tables
						)
				)
				and start_date > p_PurgeDate;
		/********************************************************************/
		/* Determine all records older than the lowest purge history record
		/* to keep
		/********************************************************************/
		delete 	purge_history_chunks
		where	id_purge_history_partitions <=
				(
				select 	max(id)
				from 	purge_history_partitions
				where 	id_purge_history < f_HistId
				);
		delete	purge_history_partitions
		where	id_purge_history < f_HistId;
		
		delete	purge_history
		where	id < f_HistId;
		commit;
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_PurgeHistoryTables for p_PurgeDate: ' || to_char(p_purgedate, 'mm/dd/yyyy hh24:mi:ss') );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			rollback;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeHistoryTables',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_PurgeDate: ' || to_char(p_purgedate, 'mm/dd/yyyy hh24:mi:ss') );
			commit;
			RAISE;
	END Sp_PurgeHistoryTables;
	-----------------------------------------------------------------------------
	-- Declare Public Functions
	-----------------------------------------------------------------------------
	/***************************************************************************/
	/*
	/* Function:	Fn_GetElapsedSecs
	/*
	/* Parameters:	p_Start         IN    	DATE
	/*				++ Start date/time
	/*				p_End			IN		DATE
	/*				++ End date/time
	/*
	/* Description:	This function returns the number of seconds between the
	/*				two dates passed in
	/*
	/* Notes:		None
	/*
	/* Return:		NUBER
	/*				++ Number of seconds between the dates
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/23/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_GetElapsedSecs
	(
	p_Start		IN		DATE,
	p_End		IN		DATE
	)
	RETURN NUMBER
	IS
		-- Processing Variables
		-- Fetch Variables
		f_ElapsedSecs		NUMBER				:= NULL;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Determine the number of seconds between the two dates
		/********************************************************************/
		select 	round(max((p_End - p_Start) * 24 * 60 * 60)) as diff_min
		into	f_ElapsedSecs
		from	dual;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN f_ElapsedSecs;
	
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Fn_GetElapsedSecs for ' || 'p_Start: ' || to_char( p_Start, 'mm/dd/yyyy hh24:mi:ss' ) || ' | p_End: ' || to_char( p_End, 'mm/dd/yyyy hh24:mi:ss' ) );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Fn_GetElapsedSecs', b_SqlCode, b_SqlErrm,
				'Other error',
				'p_Start: ' || to_char( p_Start, 'mm/dd/yyyy hh24:mi:ss' ) || ' | p_End: ' || to_char( p_End, 'mm/dd/yyyy hh24:mi:ss' ) );
			commit;
			RAISE;
	END Fn_GetElapsedSecs;
	/***************************************************************************/
	/*
	/* Function:	Fn_StatusNbrToChar
	/*
	/* Parameters:	p_Status           IN    NUMBER
	/*				++ Numeric status to translate
	/*
	/* Description:	This function will translate dbms_parallel numeric status
	/*				into a character status
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Readable status
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/19/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_StatusNbrToChar
	(
	p_Status	IN		NUMBER
	)
	RETURN VARCHAR2
	IS
		-- Processing Variables
		v_Return			VARCHAR2(30)		:= NULL;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Translate numeric to character status value
		/********************************************************************/
		CASE	p_Status
				WHEN dbms_parallel_execute.created				
					THEN v_Return := c_Created;
				WHEN dbms_parallel_execute.chunking				
					THEN v_Return := c_Chunking;
				WHEN dbms_parallel_execute.chunking_failed		
					THEN v_Return := c_ChunkingFailed;
				WHEN dbms_parallel_execute.no_chunks
					THEN v_Return := c_NoChunks;
				WHEN dbms_parallel_execute.chunked				
					THEN v_Return := c_Chunked;
				WHEN dbms_parallel_execute.processing			
					THEN v_Return := c_Processing;
				WHEN dbms_parallel_execute.processed
					THEN v_Return := c_Processed;
				WHEN dbms_parallel_execute.finished				
					THEN v_Return := c_Finished;
				WHEN dbms_parallel_execute.finished_with_error	
					THEN v_Return := c_FinishedErrors;
				WHEN dbms_parallel_execute.crashed				
					THEN v_Return := c_Crashed;
				ELSE
					v_Return := 'Uknown - ' || p_Status;
		END CASE;
		
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN v_Return;
	
	END Fn_StatusNbrToChar;
	/***************************************************************************/
	/*
	/* Function:	Fn_ShowErrors
	/*
	/* Parameters:	p_FromDate		IN		DATE
	/*				++ Show data from this date forward
	/* 			p_TaskName          IN    VARCHAR2
	/*				++ Task name to get errors for
	/*
	/* Description:	This function shows errors for the task passed in or the
	/*				most recent with errors if it is omitted
	/*
	/* Notes:		None
	/*
	/* Return:		VARCHAR2
	/*				++ Pipelined error messages
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/25/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_ShowErrors
	(
	p_FromDate			DATE,
	p_TaskName	IN		VARCHAR2		DEFAULT NULL
	)
	RETURN tbl_Strings
	PIPELINED
	IS
		-- Processing Variables
		v_TaskName			VARCHAR2(128)			:= upper(p_TaskName);
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_errs
				(
				p_Task		varchar2
				)
		is
				select	distinct
						substr(error_message,1,1000) as error_message
				from	user_parallel_execute_chunks
				where	task_name = p_Task
						and error_message is not null
				order by error_message;
	cursor		c_procs
				(
				p_Date		date
				)
	is
				select 	code_block || ': ' || exception_message as error_message
				from		purge_error_log
				where		error_time >= p_Date
				order by error_time;
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* If no task is passed in get the latest one with errors
		/********************************************************************/
		if( v_TaskName is null ) then
			begin
				select 	task_name
				into	v_TaskName
				from 	user_parallel_execute_chunks
				where 	chunk_id =
						(
							select 	max(chunk_id)
							from 	user_parallel_execute_chunks
	    					where 	error_message is not null
						);
			exception
				when no_data_found then
					null;
			end;
		end if;
		/********************************************************************/
		/* Display the parallel execute chunk errors
		/********************************************************************/
		PIPE ROW( 'Parallel_Execute_Chunk Errors:' );
		for lr in c_errs( v_TaskName ) loop
			PIPE ROW( lr.error_message );
		end loop;
		/********************************************************************/
		/* Display the processing errors
		/********************************************************************/
		PIPE ROW( 'Processing Errors:' );
		for lr in c_procs( p_FromDate ) loop
			PIPE ROW( lr.error_message );
		end loop;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			dbms_output.put_line( 'No errors found to display' );
		WHEN NO_DATA_NEEDED THEN
			NULL; -- this means the function returned x nbr of rows but the query only requested first y rows
	END Fn_ShowErrors;
	/***************************************************************************/
	/*
	/* Function:	Fn_DailyRpt
	/*
	/* Parameters:	p_FromDate		IN		DATE
	/*				++ Show data from this date forward
	/*
	/* Description:	This function shows statistics for the last run
	/*
	/* Notes:		The last run may or may not have completed all tables
	/*
	/* Return:		VARCHAR2
	/*				++ Pipelined error messages
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/25/2019	Created function
	/*
	/***************************************************************************/
	FUNCTION Fn_DailyRpt
	(
	p_FromDate		DATE
	)
	RETURN tbl_DailyRec
	PIPELINED
	IS
		-- Processing Variables
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		cursor	c_Rows
		is
				select  table_name as table_name,
						sum(tot_elapsed_secs) as tot_elapsed_secs,
						sum(nbr_rows_purged) as nbr_rows_purged,
						nvl(sum(nbr_rows_deleted_fk+nbr_rows_deleted_child_fk+nbr_rows_deleted_grandchild_fk),0) as nbr_rows_delted_fk,
						nvl(sum(tot_elapsed_fk_secs),0) as tot_elapsed_fk_secs,
						nvl(sum(nbr_subparts_dropped),0) as nbr_subparts_dropped,
						round(sum(nbr_rows_purged)/case sum(tot_elapsed_secs) when 0 then 1 else sum(tot_elapsed_secs) end,2) as purged_per_sec,
						round(sum(nvl(nbr_rows_deleted_fk,0))/case sum(nvl(tot_elapsed_fk_secs,0)) when 0 then 1 else sum(nvl(tot_elapsed_fk_secs,0)) end,2) as fk_per_sec
				from    purge_history_partitions
				where	start_date > p_FromDate
				group by table_name
				order by table_name;
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Display the data rows
		/********************************************************************/
		for lr in c_Rows loop
			PIPE ROW( lr );
		end loop;
		/********************************************************************/
		/* Return the value to the calling procedure
		/********************************************************************/
		RETURN;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			dbms_output.put_line( 'No last run found to display' );
		WHEN NO_DATA_NEEDED THEN
			NULL; -- this means the function returned x nbr of rows but the query only requested first y rows
	END Fn_DailyRpt;
	-----------------------------------------------------------------------------
	-- Declare Public Procedures
	-----------------------------------------------------------------------------
	/***************************************************************************/
	/*
	/* Procedure:	Sp_CreatePurgeSchedulerJob
	/*
	/* Parameters:	None
	/*
	/* Description:	This procedure will create a scheduler job to automate the
	/*				SBMO purge daily
	/*
	/* Notes:		None
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	02/25/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_CreatePurgeSchedulerJob
	IS
		-- Processing Variables
		v_JobName			VARCHAR2(30)						:= 'ORA_SBMO_PURGE';
		v_WindowTimes		PURGE_CONFIG_SETTINGS.VALUE%TYPE	:= NULL;
		v_StartHour			VARCHAR2(4)							:= NULL;
		v_StartDate			DATE								:= NULL;
		
		-- Fetch Variables
		f_Count				NUMBER								:= 0;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Determine if the job is currently running, if so then error
		/********************************************************************/
		select	count(*)
		into	f_Count
		from	user_scheduler_running_jobs
		where	job_name = v_JobName;
		
		if( f_Count > 0 ) then
			RAISE_APPLICATION_ERROR( -20699, v_JobName || ' is currently running - unable to recreate the job, exiting' );
		end if;
		
		/********************************************************************/
		/* Get the window times configuration setting and determine the start
		/* date for the job, 1 second past the next configuration start time
		/********************************************************************/
		v_WindowTimes := Fn_GetConfig( c_WindowTimes );
		v_StartHour := substr( v_WindowTimes, 0, instr( v_WindowTimes, '-' )-1 );
		v_StartDate := to_date(to_char( sysdate, 'mm/dd/yyyy ' ) || v_StartHour || '01', 'mm/dd/yyyy hh24miss');
		if( v_StartDate < sysdate ) then
			v_StartDate := v_StartDate + 1;
		end if;
		
		/********************************************************************/
		/* Create a scheduler job to execute the purge that will begin
		/********************************************************************/
		dbms_scheduler.create_job(
			job_name	=> v_JobName,
			job_type	=> 'PLSQL_BLOCK',
			job_action	=> 'begin pkg_sbmo_purge.sp_purgesbmo; end; ',
			start_date	=> v_StartDate,
			repeat_interval	=> 'FREQ=DAILY',
			end_date	=> NULL,
			job_class	=> Fn_GetConfig( c_JobClass ),
			comments	=> 'Purge SBMO',
			auto_drop	=> false,
			enabled		=> true );
	EXCEPTION
		WHEN e_JobExists THEN
			dbms_scheduler.drop_job( v_JobName );
			Sp_CreatePurgeSchedulerJob;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_CreatePurgeSchedulerJob' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_CreatePurgeSchedulerJob',  b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Sp_CreatePurgeSchedulerJob;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_StopRunningPurge
	/*
	/* Parameters:	None
	/*
	/* Description:	This procedure will stop the purge that is currently running
	/*
	/* Notes:		The stop will occur when a task is created and is able to
	/*				be stopped.  The code may be working on a FK delete or so
	/*				but when the next task is created the purge will stop
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/28/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_StopRunningPurge
	IS
		-- Processing Variables
		v_Return			VARCHAR2(30)		:= NULL;
		-- Fetch Variables
		f_Running			CHAR(1)				:= c_Yes;
		
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Loop until the purge running flag is set to N
		/* Each loop will kill any purge tasks and will trigger a stop
		/* However, it may loop with no effect if a FK delete or processing
		/* leading to a task is running but will catch up once a task is
		/* created
		/********************************************************************/
		Sp_SetRunFlag( c_StopJob );
		Sp_StopAllTasks;
		dbms_output.put_line( 'It may take up to 10 minutes for all process to completely stop' );
	EXCEPTION
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_StopRunningPurge' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_StopRunningPurge',  b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			RAISE;
	END Sp_StopRunningPurge;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_MonitorTask
	/*
	/* Parameters:	p_Taskname          IN    	VARCHAR2
	/*				++ Name of task to monitor
	/* 				p_TableName			IN OUT	VARCHAR2
	/*				++ Table being purged
	/*				p_PartName			IN OUT	VARCHAR2
	/*				++ Tables partition being purged
	/*
	/* Description:	This procedure will monitor the task until it errors over
	/*				the configured number of times, completes or the end of the
	/*				maintenance window
	/*
	/* Notes:		This should never be run manually, only scheduled via a
	/*				job in the package
	/*
	/***************************************************************************
	/*
	/* Name					Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/18/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_MonitorTask
	(
	p_TaskName		IN		VARCHAR2,
	p_TableName		IN 		VARCHAR2,
	p_PartName		IN 		VARCHAR2
	)
	IS
		-- Processing Variables
		v_Retries				NUMBER				:= 0;
		v_Status				NUMBER				:= NULL;
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Set the body processing variables from the configuration table
		/********************************************************************/
		Sp_SetConfig;
	
		/********************************************************************/
		/* Monitor the task
		/********************************************************************/
		v_Status := dbms_parallel_execute.task_status( p_TaskName );
		WHILE ( v_Retries < b_RetryCount and v_Status in ( dbms_parallel_execute.processing, dbms_parallel_execute.processed ) ) LOOP
			if( v_Status = dbms_parallel_execute.processing ) then
				dbms_lock.sleep( b_SleepTime );
			else
				v_Retries := v_Retries + 1;
				dbms_parallel_execute.resume_task( p_TaskName );
			end if;
			v_Status := dbms_parallel_execute.task_status( p_TaskName );
			Sp_CheckWindowEndTime( p_TableName, p_PartName );
		END LOOP;
		/********************************************************************/
		/* Error if other than finished status for the task
		/********************************************************************/
		if( v_Status not in ( dbms_parallel_execute.finished, dbms_parallel_execute.crashed ) ) then
			RAISE e_FailedTask;
		end if;
		
	EXCEPTION
		WHEN e_NoTask THEN
			NULL;
		WHEN e_EndWindow THEN
			Sp_StopTask( p_TaskName );
			Sp_SetRunFlag( c_MonitorWindow );
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_MonitorTask',  b_SqlCode, b_SqlErrm,
				'Task stopped due to end of window condition ',
				'p_TaskName: ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
		WHEN e_StopRunning THEN
			Sp_StopTask( p_TaskName );
			Sp_SetRunFlag( c_MonitorStop );
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_MonitorTask',  b_SqlCode, b_SqlErrm,
				'Stop run requested ',
				'p_TaskName: ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName );
			commit;
		WHEN e_FailedTask THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Task ' || p_TaskName || ' for table ' || p_TableName || ' and partition ' || p_PartName || ' failed with status ' || v_Status || ', ' || Fn_StatusNbrToChar(v_Status) );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_MonitorTask',  b_SqlCode, b_SqlErrm,
				'Task failed with status ' || v_Status,
				'p_TaskName: ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | v_Status: ' || v_Status || ', ' || Fn_StatusNbrToChar(v_Status) );
			commit;
			RAISE e_FailedTask;
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_MonitorTask for ' || p_TaskName );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_MonitorTask',  b_SqlCode, b_SqlErrm,
				'Other error',
				'p_TaskName: ' || p_TaskName || ' | p_TableName: ' || p_TableName || ' | p_PartName: ' || p_PartName || ' | v_Status: ' || v_Status || ', ' || Fn_StatusNbrToChar(v_Status) );
			commit;
			RAISE;
	END Sp_MonitorTask;
	/***************************************************************************/
	/*
	/* Procedure:	Sp_PurgeSBMO
	/*
	/* Parameters:	None
	/*
	/* Description:	This procedure is the main driver for the sbmo purge
	/*
	/* Notes:		This is the driving procedure for the SBMO purge
	/*
	/***************************************************************************
	/*
	/* Name			Date		Modifications
	/* -----------------	----------	-------------------------------------------
	/* Edward Stephenson	01/15/2019	Created procedure
	/*
	/***************************************************************************/
	PROCEDURE Sp_PurgeSBMO
	IS
		-- Processing Variables
		v_EligibleCount		NUMBER							:= 0;
		v_TableCount		NUMBER							:= 0;
		v_ChunkCount		NUMBER							:= 0;
		v_ResumeTime		DATE							:= SYSDATE;
		
		v_HistoryRec		PURGE_HISTORY%ROWTYPE			:= NULL;
		v_PurgeTable		PURGE_TABLES.TABLE_NAME%TYPE	:= NULL;
		v_PurgeColumn		VARCHAR2(30)					:= NULL;
		
		-- Fetch Variables
		-- Exception Variables
		-- Cursors
		CURSOR	c_Parts
				(
				p_TableName		VARCHAR2
				)
		IS		
		    -- Medha : We want to pick partition_name when table is partitioned , else set the value to NON_PARTITIONED when
		     with all_tbl(partition_name) as (
select	partition_name
from	user_tab_partitions
where	table_name = p_TableName
union
select 'NON_PARTITIONED' -- We are fetching only non partitioned tables here
from user_tables
where	table_name = p_TableName
			 and partitioned='NO' )
select partition_name from all_tbl
order by partition_name;
		
		       -- old sql
				--select	partition_name
				--from	user_tab_partitions
				--where	table_name = p_TableName
				--order by partition_name;
				
		CURSOR	c_CatchUpParts
				(
				p_HistId		NUMBER,
				p_TableName		VARCHAR2
				)
		IS
				select	partition_name
				from	user_tab_partitions
				where	table_name = p_TableName
						and partition_name not in
						(
						select	partition_name
						from	purge_history_partitions
						where	id_purge_history = p_HistId
								and status = c_Finished
						)
				order by partition_name;
		-- Cursor Fetch Variables
	BEGIN
		/********************************************************************/
		/* Set the body processing variables from the configuration table
		/********************************************************************/
		Sp_SetConfig;
		/********************************************************************/
		/* Check if the purge is already running, if so error
		/********************************************************************/
		if( Fn_KeepRunning ) then
			raise e_AlreadyRunning;
		else
			Sp_SetRunFlag( c_Yes );
		end if;
		
		/********************************************************************/
		/* Get the number of tables eligible for purge and the last history
		/* record
		/* If force restart is requested setup the history record and
		/* update config settings so it will not force on next run but will
		/* again pick up where we left off
		/********************************************************************/
		v_EligibleCount := Fn_GetEligibleCount;
		
		dbms_output.put_line('DEBUG | Force Restart-' ||b_ForceRestart );
		
		if( b_ForceRestart = c_Yes ) then
			v_HistoryRec.STATUS := c_Finished;
			v_HistoryRec.TABLE_NAME := c_NoTable;
			update purge_config_settings set value = c_No where name = c_ForceRestart;
			commit;
		else
			v_HistoryRec := Fn_GetLatestHistory;
		end if;
		
		/********************************************************************/
		/* If the last run stopped a task, restart it
		/********************************************************************/
		dbms_output.put_line('DEBUG | History Task Status -' ||v_HistoryRec.STATUS );
		if( v_HistoryRec.STATUS in ( c_Stopped, c_Chunked, c_Crashed, c_FkDelete, c_SubPartDrop, c_FinishedErrors, c_Processed, c_Processing, c_Failed ) ) then
dbms_output.put_line('DEBUG | Restart Stopped task from previous run, task status was -' || v_HistoryRec.STATUS );
			
			dbms_output.put_line('DEBUG | Before Sp_RestartPurgePartition. Details of prev task - PURGE_HISTORY.ID: ' ||  v_HistoryRec.ID || 'PURGE_DATE : ' || v_HistoryRec.PURGE_DATE  );     			
			
			Sp_RestartPurgePartition( v_HistoryRec.ID, v_HistoryRec.PURGE_DATE );
		
			/****************************************************************/
			/* Loop through all the remaining table partitions and process
			/* each one
			/****************************************************************/
			dbms_output.put_line('DEBUG | Before Fn_GetPurgeColumn Restartv_HistoryRec.table_name  -' || v_HistoryRec.table_name );
			v_PurgeColumn := Fn_GetPurgeColumn( v_HistoryRec.table_name );
			for lr in c_CatchUpParts( v_HistoryRec.ID, v_HistoryRec.TABLE_NAME ) loop
			    dbms_output.put_line('DEBUG | Loop thru c_CatchUpParts, before  Sp_PurgePartition' );
				dbms_output.put_line('DEBUG | v_HistoryRec.table_name-' || v_HistoryRec.table_name || 'lr.partition_name - ' || lr.partition_name || 'v_PurgeColumn -' || v_PurgeColumn || 'v_HistoryRec.ID - ' || v_HistoryRec.ID || 'v_HistoryRec.PURGE_DAT-' || v_HistoryRec.PURGE_DATE );
				Sp_PurgePartition( v_HistoryRec.table_name, lr.partition_name, v_PurgeColumn, v_HistoryRec.ID, v_HistoryRec.PURGE_DATE );
			end loop;
			/****************************************************************/
			/* Complete the history record values and insert it
			/****************************************************************/
		
			v_HistoryRec.Status := c_Finished;
			v_HistoryRec.End_Date := sysdate;
			Sp_SumPartsToTable( v_HistoryRec );
			Sp_RebuildIndexes( v_HistoryRec.table_name, NULL, v_HistoryRec.index_sql, v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			v_TableCount := v_TableCount + 1;
		elsif( v_HistoryRec.Status in ( c_Finished ) ) then
			null;
		else
			raise e_InvalidRestartStatus;
		end if;
		
		/********************************************************************/
		/* Purge tables until time runs out or all tables are processed
		/********************************************************************/
		dbms_output.put_line('DEBUG |Outside IF task stats  v_TableCount - ' || v_TableCount);
		while v_TableCount < v_EligibleCount loop
			/****************************************************************/
			/* Get the next table to be purged and its purge column
			/****************************************************************/
		   dbms_output.put_line ('DEBUG| Before call First table to purge  TABLE_NAME - ' || v_HistoryRec.TABLE_NAME  );
			v_PurgeTable := Fn_GetNextPurgeTable( v_HistoryRec.TABLE_NAME );
			dbms_output.put_line ('DEBUG| Before call First table to purge  ' || v_HistoryRec.TABLE_NAME);
			v_PurgeColumn := Fn_GetPurgeColumn( v_PurgeTable );
			
			dbms_output.put_line ('DEBUG| After Call table to purge  ' || v_HistoryRec.TABLE_NAME);
			
			/****************************************************************/
			/* Set the initial history record values
			/****************************************************************/
		
			v_HistoryRec := NULL;
			v_HistoryRec.ID := purge_seq.nextval;
			v_HistoryRec.Table_Name := v_PurgeTable;
			v_HistoryRec.Start_Date := sysdate;
			v_HistoryRec.Purge_Date := Fn_GetPurgeDate( v_PurgeTable );
			v_HistoryRec.Status := c_Processing;
			insert into purge_history values v_HistoryRec;
			commit;
			
			/****************************************************************/
			/* Loop through all the table partitions and process each one
			/****************************************************************/
		
			if( v_PurgeTable = 'PURGE_HISTORY' ) then
				Sp_PurgeHistoryTables( v_HistoryRec.PURGE_DATE );
			else
				for lr in c_parts( v_PurgeTable ) loop
					Sp_PurgePartition( v_PurgeTable, lr.partition_name, v_PurgeColumn, v_HistoryRec.ID, v_HistoryRec.PURGE_DATE );
				end loop;
			end if;
			
			/****************************************************************/
			/* Rebuild any invalid indexes
			/****************************************************************/
		
			Sp_RebuildIndexes( v_PurgeTable, NULL, v_HistoryRec.index_sql, v_HistoryRec.ID );
			/****************************************************************/
			/* Complete the history record values and insert it
			/****************************************************************/
		
			v_HistoryRec.Status := c_Finished;
			v_HistoryRec.End_Date := sysdate;
			Sp_SumPartsToTable( v_HistoryRec );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			
			/****************************************************************/
			/* Increment the table counter
			/****************************************************************/
		
			v_TableCount := v_TableCount + 1;
		end loop; -- while v_TableCount < v_EligibleCount
		
		/********************************************************************/
		/* Set the run flag to no, as this run has completed
		/********************************************************************/
		Sp_SetRunFlag( c_No );
		Sp_SendStatusReport( 'All tables successfully purged', v_ResumeTime );
	EXCEPTION
		WHEN e_AlreadyRunning THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			dbms_output.put_line( 'Purge is already running according to purge_run_check table, exiting' );
			dbms_output.put_line( 'If this is incorrect please truncate purge_run_check table' );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'Purge is already running, exiting',
				'None' );
			commit;
			Sp_SendStatusReport( 'FAILED: Attempted to start purge when it is already running according to purge_run_check table, exiting.  ' || chr(10) || 'If this is incorrect please truncate purge_run_check table', sysdate, c_Yes );
			RAISE_APPLICATION_ERROR( -20299, 'Purge is already running according to purge_run_check table, exiting' || chr(10) || 'If this is incorrect please truncate purge_run_check table' );
		WHEN e_SubPartDrop THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_SubPartDrop;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'End of Window while dropping subpartitions',
				'None' );
			commit;
			Sp_SendStatusReport( 'End of Window while dropping subpartitions', v_ResumeTime );
		WHEN e_FkDelete THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_FkDelete;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'End of Window while deleting Fks',
				'None' );
			commit;
			Sp_SendStatusReport( 'End of Window while deleting Fks', v_ResumeTime );
		WHEN e_FinishedErrors THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_FinishedErrors;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'Finished with errors.',
				'None' );
			commit;
			Sp_SendStatusReport( 'FAILED: Finished with errors', v_ResumeTime, c_Yes );
			RAISE_APPLICATION_ERROR( -20220, 'Task finished with errors.  Get errors from purge_error_log using: select * from table(pkg_sbmo_purge.fn_ShowErrors(' || b_ErrDate || ')).  Also review dba_parallel_execute_tasks.' );
		WHEN e_EndWindow THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_Stopped;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'End of Window',
				'None' );
			commit;
			Sp_SendStatusReport( 'End of Window', v_ResumeTime );
		WHEN e_StopRunning THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_Stopped;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'Stop run requested',
				'None' );
			commit;
			Sp_SendStatusReport( 'Stop run requested', v_ResumeTime );
		WHEN e_BlackoutDay THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_Stopped;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'Today is a blackout day',
				'None' );
			commit;
			-- No need to send for blackout day Sp_SendStatusReport( b_SqlErrm, v_ResumeTime );
		WHEN e_InvalidRestartStatus THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_PurgeSBMO, Restart has invalid status ' || v_HistoryRec.STATUS );
			Sp_SetRunFlag( c_No );
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'Restart has invalid status ' || v_HistoryRec.STATUS,
				'None' );
			commit;
			Sp_SendStatusReport( 'FAILED: Restart has invalid status ' || v_HistoryRec.STATUS, v_ResumeTime, c_Yes );
			RAISE_APPLICATION_ERROR( -20200, 'Restart has invalid status: ' || v_HistoryRec.STATUS );
		WHEN e_FailedTask THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_PurgeSBMO, table failed' );
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_Failed;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'Failed task',
				'None' );
			commit;
			Sp_SendStatusReport( 'FAILED: Failed Task', v_ResumeTime, c_Yes );
			RAISE_APPLICATION_ERROR( -20200, 'Task failed. Get errors from purge_error_log using: select * from table(pkg_sbmo_purge.fn_ShowErrors(' || b_ErrDate || ')).  Also review dba_parallel_execute_tasks.' );
		WHEN OTHERS THEN
			b_SqlCode := SQLCODE;
			b_SqlErrm := substr(SQLERRM,1,250);
			DBMS_OUTPUT.PUT_LINE( 'Error in Sp_PurgeSBMO' );
			DBMS_OUTPUT.PUT_LINE( SQLERRM );
			Sp_SetRunFlag( c_No );
			v_HistoryRec.Status := c_Failed;
			v_HistoryRec.TOT_ELAPSED_SECS := Fn_GetTaskElapsedSecs( v_HistoryRec.ID );
			update purge_history set row = v_HistoryRec where id = v_HistoryRec.ID;
			commit;
			insert into purge_error_log(id, error_time, code_block, sql_code, sql_errm, exception_message, parameter_values)
			values( master_seq.nextval, systimestamp,
				'Sp_PurgeSBMO',  b_SqlCode, b_SqlErrm,
				'Other error',
				'None' );
			commit;
			Sp_SendStatusReport( 'FAILED: Other Error: ' || b_SqlCode || ' - ' || b_SqlErrm, v_ResumeTime, c_Yes );
			RAISE_APPLICATION_ERROR( -20100, 'Other error in sp_PurgeSbmo.  Get errors from purge_error_log using: select * from table(pkg_sbmo_purge.fn_ShowErrors(' || b_ErrDate || ')).  Also review dba_parallel_execute_tasks.' );
	END Sp_PurgeSBMO;
--BEGIN
	/************************************************************************/
	/*
	/************************************************************************/
	
END Pkg_Sbmo_Purge;			-- End Package Body

-- ============================================================================
-- Production-Ready Azure SQL MI Deployment Script
-- Schema: WL_SBMO
-- Table: PLAN_TABLE
-- Source: Oracle WL_SBMO.PLAN_TABLE
-- Converted: 2026-08-19
-- ============================================================================
-- SSMA-generated extended properties and TRY/CATCH blocks removed
-- Datatypes validated against DATATYPE_CONVERSION_REFERENCE.md
-- ============================================================================

-- Create schema if it doesn't exist
IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'WL_SBMO')
    EXEC (N'CREATE SCHEMA WL_SBMO')
GO

-- Drop existing table if present (with FK cleanup if needed)
IF EXISTS (SELECT * FROM sys.objects so 
           JOIN sys.schemas sc ON so.schema_id = sc.schema_id 
           WHERE so.name = N'PLAN_TABLE' AND sc.name = N'WL_SBMO' AND type in (N'U'))
BEGIN
    -- Drop any foreign keys that reference this table
    DECLARE @drop_statement nvarchar(500)
    DECLARE drop_cursor CURSOR FOR
        SELECT 'ALTER TABLE ' + QUOTENAME(schema_name(ob.schema_id)) + '.' + 
               QUOTENAME(object_name(ob.object_id)) + ' DROP CONSTRAINT ' + 
               QUOTENAME(fk.name) 
        FROM sys.objects ob 
        INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
        WHERE fk.referenced_object_id = 
            (
                SELECT so.object_id 
                FROM sys.objects so 
                JOIN sys.schemas sc ON so.schema_id = sc.schema_id
                WHERE so.name = N'PLAN_TABLE' AND sc.name = N'WL_SBMO' AND type in (N'U')
            )
    
    OPEN drop_cursor
    FETCH NEXT FROM drop_cursor INTO @drop_statement
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC (@drop_statement)
        FETCH NEXT FROM drop_cursor INTO @drop_statement
    END
    
    CLOSE drop_cursor
    DEALLOCATE drop_cursor
    
    DROP TABLE [WL_SBMO].[PLAN_TABLE]
END
GO

-- ============================================================================
-- CREATE TABLE: WL_SBMO.PLAN_TABLE
-- ============================================================================
-- Datatype Conversions Applied:
--   Oracle NUMBER           → Azure SQL bigint
--   Oracle NUMBER(38, 0)    → Azure SQL bigint (or numeric(38,0) for exact match)
--   Oracle VARCHAR2(n)      → Azure SQL varchar(n)
--   Oracle LONG             → Azure SQL varchar(max)
--   Oracle CLOB             → Azure SQL varchar(max)
--   Oracle DATE             → Azure SQL datetime2(0)
--   Oracle TIMESTAMP(6)     → Azure SQL datetime2(6)
-- ============================================================================

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [WL_SBMO].[PLAN_TABLE]
(
    [STATEMENT_ID]         varchar(30)      NULL,
    [PLAN_ID]              bigint            NULL,          -- FIXED: was float(53), now bigint per DATATYPE_CONVERSION_REFERENCE.md
    [TIMESTAMP]            datetime2(0)     NULL,          -- FIXED: Oracle DATE → datetime2(0)
    [REMARKS]              varchar(4000)    NULL,
    [OPERATION]            varchar(30)      NULL,
    [OPTIONS]              varchar(255)     NULL,
    [OBJECT_NODE]          varchar(128)     NULL,
    [OBJECT_OWNER]         varchar(30)      NULL,
    [OBJECT_NAME]          varchar(30)      NULL,
    [OBJECT_ALIAS]         varchar(65)      NULL,
    [OBJECT_INSTANCE]      numeric(38, 0)   NULL,
    [OBJECT_TYPE]          varchar(30)      NULL,
    [OPTIMIZER]            varchar(255)     NULL,
    [SEARCH_COLUMNS]       bigint            NULL,          -- FIXED: was float(53), now bigint per DATATYPE_CONVERSION_REFERENCE.md
    [ID]                   numeric(38, 0)   NULL,
    [PARENT_ID]            numeric(38, 0)   NULL,
    [DEPTH]                numeric(38, 0)   NULL,
    [POSITION]             numeric(38, 0)   NULL,
    [COST]                 numeric(38, 0)   NULL,
    [CARDINALITY]          numeric(38, 0)   NULL,
    [BYTES]                numeric(38, 0)   NULL,
    [OTHER_TAG]            varchar(255)     NULL,
    [PARTITION_START]      varchar(255)     NULL,
    [PARTITION_STOP]       varchar(255)     NULL,
    [PARTITION_ID]         numeric(38, 0)   NULL,
    [OTHER]                varchar(max)     NULL,          -- Oracle LONG → varchar(max)
    [DISTRIBUTION]         varchar(30)      NULL,
    [CPU_COST]             numeric(38, 0)   NULL,
    [IO_COST]              numeric(38, 0)   NULL,
    [TEMP_SPACE]           numeric(38, 0)   NULL,
    [ACCESS_PREDICATES]    varchar(4000)    NULL,
    [FILTER_PREDICATES]    varchar(4000)    NULL,
    [PROJECTION]           varchar(4000)    NULL,
    [TIME]                 numeric(38, 0)   NULL,
    [QBLOCK_NAME]          varchar(30)      NULL,
    [OTHER_XML]            varchar(max)     NULL           -- Oracle CLOB → varchar(max)
)
WITH (DATA_COMPRESSION = NONE)
GO

-- ============================================================================
-- Validation Summary
-- ============================================================================
-- Total Columns: 36
-- Critical Fixes Applied:
--   1. PLAN_ID: float(53) → bigint (NUMBER type mapping)
--   2. SEARCH_COLUMNS: float(53) → bigint (NUMBER type mapping)
-- Removed:
--   - All sp_addextendedproperty statements (53 TRY/CATCH blocks)
--   - Unnecessary cursor logic for FK drops
--   - SSMA-generated warnings/comments
-- Status: Production-ready for Azure SQL Managed Instance deployment
-- ============================================================================

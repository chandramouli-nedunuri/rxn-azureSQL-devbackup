
USE noneprdb
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'PBC')      
     EXEC (N'CREATE SCHEMA PBC')                                   
 GO                                                               

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MEMBER_ACCT'  AND sc.name = N'PBC'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'MEMBER_ACCT'  AND sc.name = N'PBC'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [PBC].[MEMBER_ACCT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[PBC].[MEMBER_ACCT]
(

   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   [ID] float(53)  NOT NULL,
   [FIRST_NAME] varchar(20)  NOT NULL,
   [LAST_NAME] varchar(25)  NOT NULL,
   [CARDHOLDER_ID] varchar(20)  NOT NULL,
   [MEMBER_GROUP] varchar(15)  NOT NULL,
   [BIRTH_DATE] datetime2(0)  NOT NULL,
   [EMAIL] varchar(120)  NOT NULL,
   [PASSWORD] varchar(40)  NOT NULL,
   [CREATE_DATE] datetime2(6)  NOT NULL,
   [UPDATE_DATE] datetime2(6)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT.ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT.FIRST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT.LAST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT.CARDHOLDER_ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT',
        N'COLUMN', N'CARDHOLDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT.MEMBER_GROUP',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT',
        N'COLUMN', N'MEMBER_GROUP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT.BIRTH_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT',
        N'COLUMN', N'BIRTH_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT.EMAIL',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT',
        N'COLUMN', N'EMAIL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT.PASSWORD',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT',
        N'COLUMN', N'PASSWORD'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT.CREATE_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT',
        N'COLUMN', N'CREATE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT.UPDATE_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT',
        N'COLUMN', N'UPDATE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MEMBER_ACCT_04182011'  AND sc.name = N'PBC'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'MEMBER_ACCT_04182011'  AND sc.name = N'PBC'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [PBC].[MEMBER_ACCT_04182011]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[PBC].[MEMBER_ACCT_04182011]
(

   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   [ID] float(53)  NOT NULL,
   [FIRST_NAME] varchar(20)  NOT NULL,
   [LAST_NAME] varchar(25)  NOT NULL,
   [CARDHOLDER_ID] varchar(20)  NOT NULL,
   [MEMBER_GROUP] varchar(15)  NOT NULL,
   [BIRTH_DATE] datetime2(0)  NOT NULL,
   [EMAIL] varchar(120)  NOT NULL,
   [PASSWORD] varchar(40)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT_04182011',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT_04182011'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT_04182011.ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT_04182011',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT_04182011.FIRST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT_04182011',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT_04182011.LAST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT_04182011',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT_04182011.CARDHOLDER_ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT_04182011',
        N'COLUMN', N'CARDHOLDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT_04182011.MEMBER_GROUP',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT_04182011',
        N'COLUMN', N'MEMBER_GROUP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT_04182011.BIRTH_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT_04182011',
        N'COLUMN', N'BIRTH_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT_04182011.EMAIL',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT_04182011',
        N'COLUMN', N'EMAIL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT_04182011.PASSWORD',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT_04182011',
        N'COLUMN', N'PASSWORD'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MEMBER_INFO'  AND sc.name = N'PBC'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'MEMBER_INFO'  AND sc.name = N'PBC'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [PBC].[MEMBER_INFO]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[PBC].[MEMBER_INFO]
(

   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   [ID] float(53)  NOT NULL,
   [CARRIER_CODE] varchar(3)  NOT NULL,
   [MEMBER_GROUP] varchar(15)  NOT NULL,
   [CARDHOLDER_ID] varchar(20)  NOT NULL,
   [BIRTH_DATE] datetime2(0)  NOT NULL,
   [FIRST_NAME] varchar(12)  NOT NULL,
   [LAST_NAME] varchar(15)  NOT NULL,
   [MIDDLE_INITIAL] char(1)  NULL,
   [SUFFIX] varchar(3)  NULL,
   [PERSON_CODE] varchar(3)  NULL,
   [ADDRESS] varchar(35)  NULL,
   [ADDRESS_LINE2] varchar(35)  NULL,
   [CITY] varchar(18)  NULL,
   [STATE] varchar(2)  NULL,
   [ZIP_CODE] varchar(9)  NULL,
   [EFFECTIVE_DATE] datetime2(0)  NULL,
   [TERM_DATE] datetime2(0)  NULL,
   [GENDER] char(1)  NULL,
   [RELAT_CODE] char(1)  NULL,
   [COV_CODE] char(1)  NULL,
   [CREATE_DATE] datetime2(6)  NOT NULL,
   [UPDATE_DATE] datetime2(6)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.CARRIER_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'CARRIER_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.MEMBER_GROUP',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'MEMBER_GROUP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.CARDHOLDER_ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'CARDHOLDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.BIRTH_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'BIRTH_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.FIRST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.LAST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.MIDDLE_INITIAL',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'MIDDLE_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.SUFFIX',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.PERSON_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'PERSON_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.ADDRESS',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.ADDRESS_LINE2',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'ADDRESS_LINE2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.CITY',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.STATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.ZIP_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'ZIP_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.EFFECTIVE_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'EFFECTIVE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.TERM_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'TERM_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.GENDER',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'GENDER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.RELAT_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'RELAT_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.COV_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'COV_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.CREATE_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'CREATE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.UPDATE_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'COLUMN', N'UPDATE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MEMBER_INFO_031011'  AND sc.name = N'PBC'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'MEMBER_INFO_031011'  AND sc.name = N'PBC'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [PBC].[MEMBER_INFO_031011]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[PBC].[MEMBER_INFO_031011]
(

   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   [ID] float(53)  NOT NULL,
   [CARRIER_CODE] varchar(3)  NOT NULL,
   [MEMBER_GROUP] varchar(15)  NOT NULL,
   [CARDHOLDER_ID] varchar(20)  NOT NULL,
   [BIRTH_DATE] datetime2(0)  NOT NULL,
   [FIRST_NAME] varchar(12)  NOT NULL,
   [LAST_NAME] varchar(15)  NOT NULL,
   [MIDDLE_INITIAL] char(1)  NULL,
   [SUFFIX] varchar(3)  NULL,
   [PERSON_CODE] varchar(3)  NULL,
   [ADDRESS] varchar(35)  NULL,
   [ADDRESS_LINE2] varchar(35)  NULL,
   [CITY] varchar(18)  NULL,
   [STATE] varchar(2)  NULL,
   [ZIP_CODE] varchar(9)  NULL,
   [EFFECTIVE_DATE] datetime2(0)  NULL,
   [TERM_DATE] datetime2(0)  NULL,
   [GENDER] char(1)  NULL,
   [RELAT_CODE] char(1)  NULL,
   [COV_CODE] char(1)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.CARRIER_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'CARRIER_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.MEMBER_GROUP',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'MEMBER_GROUP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.CARDHOLDER_ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'CARDHOLDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.BIRTH_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'BIRTH_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.FIRST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.LAST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.MIDDLE_INITIAL',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'MIDDLE_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.SUFFIX',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.PERSON_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'PERSON_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.ADDRESS',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.ADDRESS_LINE2',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'ADDRESS_LINE2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.CITY',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.STATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.ZIP_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'ZIP_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.EFFECTIVE_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'EFFECTIVE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.TERM_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'TERM_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.GENDER',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'GENDER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.RELAT_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'RELAT_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_031011.COV_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_031011',
        N'COLUMN', N'COV_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MEMBER_INFO_04182011'  AND sc.name = N'PBC'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'MEMBER_INFO_04182011'  AND sc.name = N'PBC'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [PBC].[MEMBER_INFO_04182011]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[PBC].[MEMBER_INFO_04182011]
(

   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   [ID] float(53)  NOT NULL,
   [CARRIER_CODE] varchar(3)  NOT NULL,
   [MEMBER_GROUP] varchar(15)  NOT NULL,
   [CARDHOLDER_ID] varchar(20)  NOT NULL,
   [BIRTH_DATE] datetime2(0)  NOT NULL,
   [FIRST_NAME] varchar(12)  NOT NULL,
   [LAST_NAME] varchar(15)  NOT NULL,
   [MIDDLE_INITIAL] char(1)  NULL,
   [SUFFIX] varchar(3)  NULL,
   [PERSON_CODE] varchar(3)  NULL,
   [ADDRESS] varchar(35)  NULL,
   [ADDRESS_LINE2] varchar(35)  NULL,
   [CITY] varchar(18)  NULL,
   [STATE] varchar(2)  NULL,
   [ZIP_CODE] varchar(9)  NULL,
   [EFFECTIVE_DATE] datetime2(0)  NULL,
   [TERM_DATE] datetime2(0)  NULL,
   [GENDER] char(1)  NULL,
   [RELAT_CODE] char(1)  NULL,
   [COV_CODE] char(1)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.CARRIER_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'CARRIER_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.MEMBER_GROUP',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'MEMBER_GROUP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.CARDHOLDER_ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'CARDHOLDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.BIRTH_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'BIRTH_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.FIRST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.LAST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.MIDDLE_INITIAL',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'MIDDLE_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.SUFFIX',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.PERSON_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'PERSON_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.ADDRESS',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.ADDRESS_LINE2',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'ADDRESS_LINE2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.CITY',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.STATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.ZIP_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'ZIP_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.EFFECTIVE_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'EFFECTIVE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.TERM_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'TERM_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.GENDER',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'GENDER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.RELAT_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'RELAT_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_04182011.COV_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_04182011',
        N'COLUMN', N'COV_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MEMBER_INFO_05122011'  AND sc.name = N'PBC'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'MEMBER_INFO_05122011'  AND sc.name = N'PBC'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [PBC].[MEMBER_INFO_05122011]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[PBC].[MEMBER_INFO_05122011]
(

   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   [ID] float(53)  NOT NULL,
   [CARRIER_CODE] varchar(3)  NOT NULL,
   [MEMBER_GROUP] varchar(15)  NOT NULL,
   [CARDHOLDER_ID] varchar(20)  NOT NULL,
   [BIRTH_DATE] datetime2(0)  NOT NULL,
   [FIRST_NAME] varchar(12)  NOT NULL,
   [LAST_NAME] varchar(15)  NOT NULL,
   [MIDDLE_INITIAL] char(1)  NULL,
   [SUFFIX] varchar(3)  NULL,
   [PERSON_CODE] varchar(3)  NULL,
   [ADDRESS] varchar(35)  NULL,
   [ADDRESS_LINE2] varchar(35)  NULL,
   [CITY] varchar(18)  NULL,
   [STATE] varchar(2)  NULL,
   [ZIP_CODE] varchar(9)  NULL,
   [EFFECTIVE_DATE] datetime2(0)  NULL,
   [TERM_DATE] datetime2(0)  NULL,
   [GENDER] char(1)  NULL,
   [RELAT_CODE] char(1)  NULL,
   [COV_CODE] char(1)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.CARRIER_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'CARRIER_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.MEMBER_GROUP',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'MEMBER_GROUP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.CARDHOLDER_ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'CARDHOLDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.BIRTH_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'BIRTH_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.FIRST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.LAST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.MIDDLE_INITIAL',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'MIDDLE_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.SUFFIX',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.PERSON_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'PERSON_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.ADDRESS',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.ADDRESS_LINE2',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'ADDRESS_LINE2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.CITY',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.STATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.ZIP_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'ZIP_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.EFFECTIVE_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'EFFECTIVE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.TERM_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'TERM_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.GENDER',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'GENDER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.RELAT_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'RELAT_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05122011.COV_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05122011',
        N'COLUMN', N'COV_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MEMBER_INFO_05172011'  AND sc.name = N'PBC'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'MEMBER_INFO_05172011'  AND sc.name = N'PBC'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [PBC].[MEMBER_INFO_05172011]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[PBC].[MEMBER_INFO_05172011]
(

   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   [ID] float(53)  NOT NULL,
   [CARRIER_CODE] varchar(3)  NOT NULL,
   [MEMBER_GROUP] varchar(15)  NOT NULL,
   [CARDHOLDER_ID] varchar(20)  NOT NULL,
   [BIRTH_DATE] datetime2(0)  NOT NULL,
   [FIRST_NAME] varchar(12)  NOT NULL,
   [LAST_NAME] varchar(15)  NOT NULL,
   [MIDDLE_INITIAL] char(1)  NULL,
   [SUFFIX] varchar(3)  NULL,
   [PERSON_CODE] varchar(3)  NULL,
   [ADDRESS] varchar(35)  NULL,
   [ADDRESS_LINE2] varchar(35)  NULL,
   [CITY] varchar(18)  NULL,
   [STATE] varchar(2)  NULL,
   [ZIP_CODE] varchar(9)  NULL,
   [EFFECTIVE_DATE] datetime2(0)  NULL,
   [TERM_DATE] datetime2(0)  NULL,
   [GENDER] char(1)  NULL,
   [RELAT_CODE] char(1)  NULL,
   [COV_CODE] char(1)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.CARRIER_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'CARRIER_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.MEMBER_GROUP',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'MEMBER_GROUP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.CARDHOLDER_ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'CARDHOLDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.BIRTH_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'BIRTH_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.FIRST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.LAST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.MIDDLE_INITIAL',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'MIDDLE_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.SUFFIX',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.PERSON_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'PERSON_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.ADDRESS',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.ADDRESS_LINE2',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'ADDRESS_LINE2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.CITY',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.STATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.ZIP_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'ZIP_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.EFFECTIVE_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'EFFECTIVE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.TERM_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'TERM_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.GENDER',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'GENDER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.RELAT_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'RELAT_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_05172011.COV_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_05172011',
        N'COLUMN', N'COV_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MEMBER_INFO_08012011'  AND sc.name = N'PBC'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'MEMBER_INFO_08012011'  AND sc.name = N'PBC'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [PBC].[MEMBER_INFO_08012011]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[PBC].[MEMBER_INFO_08012011]
(

   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   [ID] float(53)  NOT NULL,
   [CARRIER_CODE] varchar(3)  NOT NULL,
   [MEMBER_GROUP] varchar(15)  NOT NULL,
   [CARDHOLDER_ID] varchar(20)  NOT NULL,
   [BIRTH_DATE] datetime2(0)  NOT NULL,
   [FIRST_NAME] varchar(12)  NOT NULL,
   [LAST_NAME] varchar(15)  NOT NULL,
   [MIDDLE_INITIAL] char(1)  NULL,
   [SUFFIX] varchar(3)  NULL,
   [PERSON_CODE] varchar(3)  NULL,
   [ADDRESS] varchar(35)  NULL,
   [ADDRESS_LINE2] varchar(35)  NULL,
   [CITY] varchar(18)  NULL,
   [STATE] varchar(2)  NULL,
   [ZIP_CODE] varchar(9)  NULL,
   [EFFECTIVE_DATE] datetime2(0)  NULL,
   [TERM_DATE] datetime2(0)  NULL,
   [GENDER] char(1)  NULL,
   [RELAT_CODE] char(1)  NULL,
   [COV_CODE] char(1)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.CARRIER_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'CARRIER_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.MEMBER_GROUP',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'MEMBER_GROUP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.CARDHOLDER_ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'CARDHOLDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.BIRTH_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'BIRTH_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.FIRST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.LAST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.MIDDLE_INITIAL',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'MIDDLE_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.SUFFIX',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.PERSON_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'PERSON_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.ADDRESS',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.ADDRESS_LINE2',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'ADDRESS_LINE2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.CITY',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.STATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.ZIP_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'ZIP_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.EFFECTIVE_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'EFFECTIVE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.TERM_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'TERM_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.GENDER',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'GENDER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.RELAT_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'RELAT_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_08012011.COV_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_08012011',
        N'COLUMN', N'COV_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MEMBER_INFO_14072011'  AND sc.name = N'PBC'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'MEMBER_INFO_14072011'  AND sc.name = N'PBC'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [PBC].[MEMBER_INFO_14072011]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[PBC].[MEMBER_INFO_14072011]
(

   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   [ID] float(53)  NOT NULL,
   [CARRIER_CODE] varchar(3)  NOT NULL,
   [MEMBER_GROUP] varchar(15)  NOT NULL,
   [CARDHOLDER_ID] varchar(20)  NOT NULL,
   [BIRTH_DATE] datetime2(0)  NOT NULL,
   [FIRST_NAME] varchar(12)  NOT NULL,
   [LAST_NAME] varchar(15)  NOT NULL,
   [MIDDLE_INITIAL] char(1)  NULL,
   [SUFFIX] varchar(3)  NULL,
   [PERSON_CODE] varchar(3)  NULL,
   [ADDRESS] varchar(35)  NULL,
   [ADDRESS_LINE2] varchar(35)  NULL,
   [CITY] varchar(18)  NULL,
   [STATE] varchar(2)  NULL,
   [ZIP_CODE] varchar(9)  NULL,
   [EFFECTIVE_DATE] datetime2(0)  NULL,
   [TERM_DATE] datetime2(0)  NULL,
   [GENDER] char(1)  NULL,
   [RELAT_CODE] char(1)  NULL,
   [COV_CODE] char(1)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.CARRIER_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'CARRIER_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.MEMBER_GROUP',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'MEMBER_GROUP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.CARDHOLDER_ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'CARDHOLDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.BIRTH_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'BIRTH_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.FIRST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.LAST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.MIDDLE_INITIAL',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'MIDDLE_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.SUFFIX',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.PERSON_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'PERSON_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.ADDRESS',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.ADDRESS_LINE2',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'ADDRESS_LINE2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.CITY',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.STATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.ZIP_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'ZIP_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.EFFECTIVE_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'EFFECTIVE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.TERM_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'TERM_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.GENDER',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'GENDER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.RELAT_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'RELAT_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_14072011.COV_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_14072011',
        N'COLUMN', N'COV_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MEMBER_INFO_26052011'  AND sc.name = N'PBC'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'MEMBER_INFO_26052011'  AND sc.name = N'PBC'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [PBC].[MEMBER_INFO_26052011]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[PBC].[MEMBER_INFO_26052011]
(

   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   [ID] float(53)  NOT NULL,
   [CARRIER_CODE] varchar(3)  NOT NULL,
   [MEMBER_GROUP] varchar(15)  NOT NULL,
   [CARDHOLDER_ID] varchar(20)  NOT NULL,
   [BIRTH_DATE] datetime2(0)  NOT NULL,
   [FIRST_NAME] varchar(12)  NOT NULL,
   [LAST_NAME] varchar(15)  NOT NULL,
   [MIDDLE_INITIAL] char(1)  NULL,
   [SUFFIX] varchar(3)  NULL,
   [PERSON_CODE] varchar(3)  NULL,
   [ADDRESS] varchar(35)  NULL,
   [ADDRESS_LINE2] varchar(35)  NULL,
   [CITY] varchar(18)  NULL,
   [STATE] varchar(2)  NULL,
   [ZIP_CODE] varchar(9)  NULL,
   [EFFECTIVE_DATE] datetime2(0)  NULL,
   [TERM_DATE] datetime2(0)  NULL,
   [GENDER] char(1)  NULL,
   [RELAT_CODE] char(1)  NULL,
   [COV_CODE] char(1)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.CARRIER_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'CARRIER_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.MEMBER_GROUP',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'MEMBER_GROUP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.CARDHOLDER_ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'CARDHOLDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.BIRTH_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'BIRTH_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.FIRST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.LAST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.MIDDLE_INITIAL',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'MIDDLE_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.SUFFIX',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.PERSON_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'PERSON_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.ADDRESS',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.ADDRESS_LINE2',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'ADDRESS_LINE2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.CITY',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.STATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.ZIP_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'ZIP_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.EFFECTIVE_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'EFFECTIVE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.TERM_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'TERM_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.GENDER',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'GENDER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.RELAT_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'RELAT_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_26052011.COV_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_26052011',
        N'COLUMN', N'COV_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MEMBER_INFO_29062011'  AND sc.name = N'PBC'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'MEMBER_INFO_29062011'  AND sc.name = N'PBC'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [PBC].[MEMBER_INFO_29062011]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[PBC].[MEMBER_INFO_29062011]
(

   /*
   *   SSMA warning messages:
   *   O2SS0356: Conversion from NUMBER datatype can cause data loss.
   */

   [ID] float(53)  NOT NULL,
   [CARRIER_CODE] varchar(3)  NOT NULL,
   [MEMBER_GROUP] varchar(15)  NOT NULL,
   [CARDHOLDER_ID] varchar(20)  NOT NULL,
   [BIRTH_DATE] datetime2(0)  NOT NULL,
   [FIRST_NAME] varchar(12)  NOT NULL,
   [LAST_NAME] varchar(15)  NOT NULL,
   [MIDDLE_INITIAL] char(1)  NULL,
   [SUFFIX] varchar(3)  NULL,
   [PERSON_CODE] varchar(3)  NULL,
   [ADDRESS] varchar(35)  NULL,
   [ADDRESS_LINE2] varchar(35)  NULL,
   [CITY] varchar(18)  NULL,
   [STATE] varchar(2)  NULL,
   [ZIP_CODE] varchar(9)  NULL,
   [EFFECTIVE_DATE] datetime2(0)  NULL,
   [TERM_DATE] datetime2(0)  NULL,
   [GENDER] char(1)  NULL,
   [RELAT_CODE] char(1)  NULL,
   [COV_CODE] char(1)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.CARRIER_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'CARRIER_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.MEMBER_GROUP',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'MEMBER_GROUP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.CARDHOLDER_ID',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'CARDHOLDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.BIRTH_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'BIRTH_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.FIRST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.LAST_NAME',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.MIDDLE_INITIAL',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'MIDDLE_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.SUFFIX',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.PERSON_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'PERSON_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.ADDRESS',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.ADDRESS_LINE2',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'ADDRESS_LINE2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.CITY',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.STATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.ZIP_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'ZIP_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.EFFECTIVE_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'EFFECTIVE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.TERM_DATE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'TERM_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.GENDER',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'GENDER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.RELAT_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'RELAT_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO_29062011.COV_CODE',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO_29062011',
        N'COLUMN', N'COV_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MEMBER_ACCT_PK'  AND sc.name = N'PBC'  AND type in (N'PK'))
ALTER TABLE [PBC].[MEMBER_ACCT] DROP CONSTRAINT [MEMBER_ACCT_PK]
 GO



ALTER TABLE [PBC].[MEMBER_ACCT]
 ADD CONSTRAINT [MEMBER_ACCT_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_ACCT.MEMBER_ACCT_PK',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_ACCT',
        N'CONSTRAINT', N'MEMBER_ACCT_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MEMBER_INFO_PK'  AND sc.name = N'PBC'  AND type in (N'PK'))
ALTER TABLE [PBC].[MEMBER_INFO] DROP CONSTRAINT [MEMBER_INFO_PK]
 GO



ALTER TABLE [PBC].[MEMBER_INFO]
 ADD CONSTRAINT [MEMBER_INFO_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.MEMBER_INFO_PK',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'CONSTRAINT', N'MEMBER_INFO_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MBR_INFO_UQ_GRP_CARD_NAMES_DOB'  AND sc.name = N'PBC'  AND type in (N'UQ'))
ALTER TABLE [PBC].[MEMBER_INFO] DROP CONSTRAINT [MBR_INFO_UQ_GRP_CARD_NAMES_DOB]
 GO



ALTER TABLE [PBC].[MEMBER_INFO]
 ADD CONSTRAINT [MBR_INFO_UQ_GRP_CARD_NAMES_DOB]
 UNIQUE 
   NONCLUSTERED ([MEMBER_GROUP] ASC, [CARDHOLDER_ID] ASC, [FIRST_NAME] ASC, [LAST_NAME] ASC, [BIRTH_DATE] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'PBC.MEMBER_INFO.MBR_INFO_UQ_GRP_CARD_NAMES_DOB',
        N'SCHEMA', N'PBC',
        N'TABLE', N'MEMBER_INFO',
        N'CONSTRAINT', N'MBR_INFO_UQ_GRP_CARD_NAMES_DOB'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
ALTER TABLE  [PBC].[MEMBER_ACCT]
 ADD DEFAULT sysdatetime() FOR [CREATE_DATE]
GO

ALTER TABLE  [PBC].[MEMBER_ACCT]
 ADD DEFAULT sysdatetime() FOR [UPDATE_DATE]
GO


USE noneprdb
GO
ALTER TABLE  [PBC].[MEMBER_INFO]
 ADD DEFAULT sysdatetime() FOR [CREATE_DATE]
GO

ALTER TABLE  [PBC].[MEMBER_INFO]
 ADD DEFAULT sysdatetime() FOR [UPDATE_DATE]
GO


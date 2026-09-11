
USE noneprdb
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'ESCRIBE')      
     EXEC (N'CREATE SCHEMA ESCRIBE')                                   
 GO                                                               

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ADDRESS'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'ADDRESS'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[ADDRESS]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[ADDRESS]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ADDRESS_LINE_1] varchar(55)  NOT NULL,
   [CITY] varchar(30)  NOT NULL,
   [STATE] varchar(2)  NOT NULL,
   [ZIP_CODE] varchar(9)  NOT NULL,
   [COUNTRY] varchar(3)  NULL,
   [ADDRESS_LINE_2] varchar(55)  NULL,
   [DEPARTMENT_MAIL_STOP] varchar(40)  NULL,
   [SYS_NC00009$] AS (substring(ZIP_CODE, 1, 5)) 
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS.ADDRESS_LINE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS',
        N'COLUMN', N'ADDRESS_LINE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS.CITY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS',
        N'COLUMN', N'CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS.STATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS',
        N'COLUMN', N'STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS.ZIP_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS',
        N'COLUMN', N'ZIP_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS.COUNTRY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS',
        N'COLUMN', N'COUNTRY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS.ADDRESS_LINE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS',
        N'COLUMN', N'ADDRESS_LINE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS.DEPARTMENT_MAIL_STOP',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS',
        N'COLUMN', N'DEPARTMENT_MAIL_STOP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS.SYS_NC00009$',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS',
        N'COLUMN', N'SYS_NC00009$'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ADDRESS_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'ADDRESS_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[ADDRESS_UPD_ERR]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[ADDRESS_UPD_ERR]
(
   [ID] numeric(38, 0)  NULL,
   [ADDRESS_LINE_1] varchar(55)  NULL,
   [CITY] varchar(30)  NULL,
   [STATE] varchar(2)  NULL,
   [ZIP_CODE] varchar(9)  NULL,
   [COUNTRY] varchar(3)  NULL,
   [ADDRESS_LINE_2] varchar(55)  NULL,
   [DEPARTMENT_MAIL_STOP] varchar(40)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS_UPD_ERR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS_UPD_ERR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS_UPD_ERR.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS_UPD_ERR',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS_UPD_ERR.ADDRESS_LINE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS_UPD_ERR',
        N'COLUMN', N'ADDRESS_LINE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS_UPD_ERR.CITY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS_UPD_ERR',
        N'COLUMN', N'CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS_UPD_ERR.STATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS_UPD_ERR',
        N'COLUMN', N'STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS_UPD_ERR.ZIP_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS_UPD_ERR',
        N'COLUMN', N'ZIP_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS_UPD_ERR.COUNTRY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS_UPD_ERR',
        N'COLUMN', N'COUNTRY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS_UPD_ERR.ADDRESS_LINE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS_UPD_ERR',
        N'COLUMN', N'ADDRESS_LINE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS_UPD_ERR.DEPARTMENT_MAIL_STOP',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS_UPD_ERR',
        N'COLUMN', N'DEPARTMENT_MAIL_STOP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'APP_ROLE'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'APP_ROLE'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[APP_ROLE]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[APP_ROLE]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ROLE] varchar(20)  NOT NULL,
   [DESCRIPTION] varchar(100)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_ROLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_ROLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_ROLE.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_ROLE',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_ROLE.ROLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_ROLE',
        N'COLUMN', N'ROLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_ROLE.DESCRIPTION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_ROLE',
        N'COLUMN', N'DESCRIPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'APP_USER'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'APP_USER'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[APP_USER]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[APP_USER]
(
   [ID] numeric(38, 0)  NOT NULL,
   [USERNAME] varchar(20)  NOT NULL,
   [LAST_NAME] varchar(25)  NOT NULL,
   [FIRST_NAME] varchar(25)  NOT NULL,
   [ID_NHIN_PRESCRIBER] numeric(38, 0)  NOT NULL,
   [MIDDLE_NAME] varchar(20)  NULL,
   [INACTIVE] numeric(1, 0)  NULL,
   [EMAIL_ADDRESS] varchar(120)  NULL,
   [LOCKOUT_DATE] datetime2(0)  NULL,
   [INVALID_ATTEMPTS] numeric(2, 0)  NULL,
   [PASSWORD] varchar(32)  NULL,
   [PASSWORD_DATE_CREATED] datetime2(0)  NULL,
   [LAST_FAILED_LOGIN] datetime2(0)  NULL,
   [LAST_SUCCESSFUL_LOGIN] datetime2(0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.USERNAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'COLUMN', N'USERNAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.ID_NHIN_PRESCRIBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'COLUMN', N'ID_NHIN_PRESCRIBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.MIDDLE_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'COLUMN', N'MIDDLE_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.INACTIVE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'COLUMN', N'INACTIVE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'COLUMN', N'EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.LOCKOUT_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'COLUMN', N'LOCKOUT_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.INVALID_ATTEMPTS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'COLUMN', N'INVALID_ATTEMPTS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.PASSWORD',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'COLUMN', N'PASSWORD'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.PASSWORD_DATE_CREATED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'COLUMN', N'PASSWORD_DATE_CREATED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.LAST_FAILED_LOGIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'COLUMN', N'LAST_FAILED_LOGIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.LAST_SUCCESSFUL_LOGIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'COLUMN', N'LAST_SUCCESSFUL_LOGIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'APP_USER_ROLE'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'APP_USER_ROLE'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[APP_USER_ROLE]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[APP_USER_ROLE]
(
   [ID_APP_USER] numeric(38, 0)  NOT NULL,
   [ID_APP_ROLE] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER_ROLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER_ROLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER_ROLE.ID_APP_USER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER_ROLE',
        N'COLUMN', N'ID_APP_USER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER_ROLE.ID_APP_ROLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER_ROLE',
        N'COLUMN', N'ID_APP_ROLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'AUDIT_DATES'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'AUDIT_DATES'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[AUDIT_DATES]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[AUDIT_DATES]
(
   [ID] numeric(38, 0)  NOT NULL,
   [TABLE_CLASS_NAME] varchar(30)  NOT NULL,
   [TABLE_ROW_ID] numeric(38, 0)  NOT NULL,
   [USER_CREATE_LOGIN] varchar(255)  NULL,
   [USER_CREATE_DATE] datetime2(0)  NULL,
   [SYSTEM_CREATE_DATE] datetime2(0)  NULL,
   [USER_UPDATE_LOGIN] varchar(255)  NULL,
   [USER_UPDATE_DATE] datetime2(0)  NULL,
   [SYSTEM_UPDATE_DATE] datetime2(0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES.TABLE_CLASS_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES',
        N'COLUMN', N'TABLE_CLASS_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES.TABLE_ROW_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES',
        N'COLUMN', N'TABLE_ROW_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES.USER_CREATE_LOGIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES',
        N'COLUMN', N'USER_CREATE_LOGIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES.USER_CREATE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES',
        N'COLUMN', N'USER_CREATE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES.SYSTEM_CREATE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES',
        N'COLUMN', N'SYSTEM_CREATE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES.USER_UPDATE_LOGIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES',
        N'COLUMN', N'USER_UPDATE_LOGIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES.USER_UPDATE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES',
        N'COLUMN', N'USER_UPDATE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES.SYSTEM_UPDATE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES',
        N'COLUMN', N'SYSTEM_UPDATE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'AUDIT_DATES_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'AUDIT_DATES_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[AUDIT_DATES_UPD_ERR]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[AUDIT_DATES_UPD_ERR]
(
   [ID] numeric(38, 0)  NULL,
   [TABLE_CLASS_NAME] varchar(30)  NULL,
   [TABLE_ROW_ID] numeric(38, 0)  NULL,
   [USER_CREATE_LOGIN] varchar(255)  NULL,
   [USER_CREATE_DATE] datetime2(0)  NULL,
   [SYSTEM_CREATE_DATE] datetime2(0)  NULL,
   [USER_UPDATE_LOGIN] varchar(255)  NULL,
   [USER_UPDATE_DATE] datetime2(0)  NULL,
   [SYSTEM_UPDATE_DATE] datetime2(0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES_UPD_ERR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES_UPD_ERR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES_UPD_ERR.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES_UPD_ERR',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES_UPD_ERR.TABLE_CLASS_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES_UPD_ERR',
        N'COLUMN', N'TABLE_CLASS_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES_UPD_ERR.TABLE_ROW_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES_UPD_ERR',
        N'COLUMN', N'TABLE_ROW_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES_UPD_ERR.USER_CREATE_LOGIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES_UPD_ERR',
        N'COLUMN', N'USER_CREATE_LOGIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES_UPD_ERR.USER_CREATE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES_UPD_ERR',
        N'COLUMN', N'USER_CREATE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES_UPD_ERR.SYSTEM_CREATE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES_UPD_ERR',
        N'COLUMN', N'SYSTEM_CREATE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES_UPD_ERR.USER_UPDATE_LOGIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES_UPD_ERR',
        N'COLUMN', N'USER_UPDATE_LOGIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES_UPD_ERR.USER_UPDATE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES_UPD_ERR',
        N'COLUMN', N'USER_UPDATE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES_UPD_ERR.SYSTEM_UPDATE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES_UPD_ERR',
        N'COLUMN', N'SYSTEM_UPDATE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'BILLING_SERVICES'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'BILLING_SERVICES'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[BILLING_SERVICES]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[BILLING_SERVICES]
(
   [ID] numeric(38, 0)  NOT NULL,
   [NCPDP_BILLING_NUMBER] numeric(7, 0)  NULL,
   [SERVICE_PHONE_NUMBER] numeric(10, 0)  NULL,
   [SERVICE_NAME] varchar(120)  NULL,
   [SERVICE_WEB_SITE] varchar(120)  NULL,
   [SERVICE_EMAIL_ADDRESS] varchar(120)  NULL,
   [SERVICE_CONTACT_NAME] varchar(120)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.BILLING_SERVICES',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'BILLING_SERVICES'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.BILLING_SERVICES.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'BILLING_SERVICES',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.BILLING_SERVICES.NCPDP_BILLING_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'BILLING_SERVICES',
        N'COLUMN', N'NCPDP_BILLING_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.BILLING_SERVICES.SERVICE_PHONE_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'BILLING_SERVICES',
        N'COLUMN', N'SERVICE_PHONE_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.BILLING_SERVICES.SERVICE_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'BILLING_SERVICES',
        N'COLUMN', N'SERVICE_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.BILLING_SERVICES.SERVICE_WEB_SITE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'BILLING_SERVICES',
        N'COLUMN', N'SERVICE_WEB_SITE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.BILLING_SERVICES.SERVICE_EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'BILLING_SERVICES',
        N'COLUMN', N'SERVICE_EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.BILLING_SERVICES.SERVICE_CONTACT_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'BILLING_SERVICES',
        N'COLUMN', N'SERVICE_CONTACT_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'CLAIM_HISTORY'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'CLAIM_HISTORY'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[CLAIM_HISTORY]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[CLAIM_HISTORY]
(
   [ID] numeric(38, 0)  NOT NULL,
   [RX_NUMBER] numeric(10, 0)  NOT NULL,
   [ID_DRUG] numeric(38, 0)  NOT NULL,
   [ID_NHIN_PRESCRIBER] numeric(38, 0)  NOT NULL,
   [ID_INSURANCE_PLAN] numeric(38, 0)  NOT NULL,
   [ID_NCPDP_MESSAGE_CLAIM] numeric(38, 0)  NULL,
   [ID_NCPDP_MESSAGE_CLAIM_RESP] numeric(38, 0)  NULL,
   [ID_NCPDP_MESSAGE_REVERSE] numeric(38, 0)  NULL,
   [ID_NCPDP_MESSAGE_REVERSE_RESP] numeric(38, 0)  NULL,
   [USER_ENTERED_QUANTITY] numeric(13, 3)  NULL,
   [SUBMIT_AMOUNT] numeric(13, 2)  NULL,
   [RECEIVED_AMOUNT] numeric(13, 2)  NULL,
   [RECEIVED_COPAY] numeric(13, 2)  NULL,
   [PATIENT_DATE_OF_BIRTH] datetime2(0)  NULL,
   [DATE_OF_SERVICE] datetime2(0)  NULL,
   [REVERSAL_DATE] datetime2(0)  NULL,
   [SUBMIT_TIME] datetime2(0)  NULL,
   [PATIENT_LAST_NAME] varchar(35)  NULL,
   [PATIENT_FIRST_NAME] varchar(35)  NULL,
   [PRIOR_AUTHORIZATION_NUMBER] varchar(28)  NULL,
   [REFERENCE_NUMBER] varchar(20)  NULL,
   [CARDHOLDER_ID] varchar(15)  NULL,
   [GROUP_NUMBER] varchar(15)  NULL,
   [PCN] varchar(10)  NULL,
   [BIN] varchar(6)  NULL,
   [REVERSAL_PAID_STATUS] varchar(1)  NULL,
   [PAID_STATUS] varchar(1)  NULL,
   [SUBMITTED_QUANTITY] numeric(16, 3)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.RX_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'RX_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.ID_DRUG',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'ID_DRUG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.ID_NHIN_PRESCRIBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'ID_NHIN_PRESCRIBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.ID_INSURANCE_PLAN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'ID_INSURANCE_PLAN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.ID_NCPDP_MESSAGE_CLAIM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'ID_NCPDP_MESSAGE_CLAIM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.ID_NCPDP_MESSAGE_CLAIM_RESP',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'ID_NCPDP_MESSAGE_CLAIM_RESP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.ID_NCPDP_MESSAGE_REVERSE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'ID_NCPDP_MESSAGE_REVERSE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.ID_NCPDP_MESSAGE_REVERSE_RESP',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'ID_NCPDP_MESSAGE_REVERSE_RESP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.USER_ENTERED_QUANTITY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'USER_ENTERED_QUANTITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.SUBMIT_AMOUNT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'SUBMIT_AMOUNT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.RECEIVED_AMOUNT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'RECEIVED_AMOUNT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.RECEIVED_COPAY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'RECEIVED_COPAY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.PATIENT_DATE_OF_BIRTH',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'PATIENT_DATE_OF_BIRTH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.DATE_OF_SERVICE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'DATE_OF_SERVICE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.REVERSAL_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'REVERSAL_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.SUBMIT_TIME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'SUBMIT_TIME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.PATIENT_LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'PATIENT_LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.PATIENT_FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'PATIENT_FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.PRIOR_AUTHORIZATION_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'PRIOR_AUTHORIZATION_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.REFERENCE_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'REFERENCE_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.CARDHOLDER_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'CARDHOLDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.GROUP_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'GROUP_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.PCN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'PCN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.BIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'BIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.REVERSAL_PAID_STATUS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'REVERSAL_PAID_STATUS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.PAID_STATUS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'PAID_STATUS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.SUBMITTED_QUANTITY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'COLUMN', N'SUBMITTED_QUANTITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'CLAIM_PROCESSOR'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'CLAIM_PROCESSOR'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[CLAIM_PROCESSOR]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[CLAIM_PROCESSOR]
(
   [ID] numeric(38, 0)  NOT NULL,
   [CLAIM_PROCESSOR_CODE] varchar(10)  NOT NULL,
   [SOFTWARE_VENDOR_ID] varchar(10)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_PROCESSOR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_PROCESSOR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_PROCESSOR.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_PROCESSOR',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_PROCESSOR.CLAIM_PROCESSOR_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_PROCESSOR',
        N'COLUMN', N'CLAIM_PROCESSOR_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_PROCESSOR.SOFTWARE_VENDOR_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_PROCESSOR',
        N'COLUMN', N'SOFTWARE_VENDOR_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'CPR_LINK_AUDIT'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'CPR_LINK_AUDIT'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[CPR_LINK_AUDIT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[CPR_LINK_AUDIT]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_PRESCRIPTIONS_WRITTEN] numeric(38, 0)  NOT NULL,
   [OLD_RXCOM_ID] numeric(38, 0)  NOT NULL,
   [NEW_RXCOM_ID] numeric(38, 0)  NOT NULL,
   [DATE_UPDATED] datetime2(0)  NOT NULL,
   [MESSAGE_ID] numeric(38, 0)  NOT NULL,
   [RECORD_UPDATED_BY] varchar(20)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CPR_LINK_AUDIT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CPR_LINK_AUDIT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CPR_LINK_AUDIT.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CPR_LINK_AUDIT',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CPR_LINK_AUDIT.ID_PRESCRIPTIONS_WRITTEN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CPR_LINK_AUDIT',
        N'COLUMN', N'ID_PRESCRIPTIONS_WRITTEN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CPR_LINK_AUDIT.OLD_RXCOM_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CPR_LINK_AUDIT',
        N'COLUMN', N'OLD_RXCOM_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CPR_LINK_AUDIT.NEW_RXCOM_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CPR_LINK_AUDIT',
        N'COLUMN', N'NEW_RXCOM_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CPR_LINK_AUDIT.DATE_UPDATED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CPR_LINK_AUDIT',
        N'COLUMN', N'DATE_UPDATED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CPR_LINK_AUDIT.MESSAGE_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CPR_LINK_AUDIT',
        N'COLUMN', N'MESSAGE_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CPR_LINK_AUDIT.RECORD_UPDATED_BY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CPR_LINK_AUDIT',
        N'COLUMN', N'RECORD_UPDATED_BY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'CUSTOM_SIGS'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'CUSTOM_SIGS'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[CUSTOM_SIGS]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[CUSTOM_SIGS]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_NHIN_PRESCRIBER] numeric(38, 0)  NOT NULL,
   [SIG_CODE] varchar(10)  NOT NULL,
   [SIG_TEXT] varchar(255)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CUSTOM_SIGS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CUSTOM_SIGS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CUSTOM_SIGS.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CUSTOM_SIGS',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CUSTOM_SIGS.ID_NHIN_PRESCRIBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CUSTOM_SIGS',
        N'COLUMN', N'ID_NHIN_PRESCRIBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CUSTOM_SIGS.SIG_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CUSTOM_SIGS',
        N'COLUMN', N'SIG_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CUSTOM_SIGS.SIG_TEXT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CUSTOM_SIGS',
        N'COLUMN', N'SIG_TEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'DRUG'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'DRUG'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[DRUG]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[DRUG]
(
   [ID] numeric(38, 0)  NOT NULL,
   [NDC] numeric(11, 0)  NOT NULL,
   [DRUG_NAME] varchar(255)  NOT NULL,
   [PACK_SIZE] numeric(13, 2)  NULL,
   [AWP] numeric(13, 2)  NULL,
   [MANUFACTURER] varchar(10)  NULL,
   [CONVERSION_FACTOR] numeric(8, 3)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.DRUG',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'DRUG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.DRUG.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'DRUG',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.DRUG.NDC',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'DRUG',
        N'COLUMN', N'NDC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.DRUG.DRUG_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'DRUG',
        N'COLUMN', N'DRUG_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.DRUG.PACK_SIZE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'DRUG',
        N'COLUMN', N'PACK_SIZE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.DRUG.AWP',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'DRUG',
        N'COLUMN', N'AWP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.DRUG.MANUFACTURER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'DRUG',
        N'COLUMN', N'MANUFACTURER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.DRUG.CONVERSION_FACTOR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'DRUG',
        N'COLUMN', N'CONVERSION_FACTOR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ENROLLMENT_FORMS'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'ENROLLMENT_FORMS'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[ENROLLMENT_FORMS]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[ENROLLMENT_FORMS]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_PRESCRIPTIONS_WRITTEN] numeric(38, 0)  NOT NULL,
   [PATIENT_MIDDLE_INITIAL] varchar(1)  NULL,
   [PATIENT_CELL_PHONE] numeric(10, 0)  NULL,
   [PATIENT_EMAIL] varchar(255)  NULL,
   [CREDIT_CARD_TYPE] varchar(1)  NULL,
   [CREDIT_CARD_NUMBER] varchar(33)  NULL,
   [CREDIT_CARD_EXP_DATE] varchar(17)  NULL,
   [CREDIT_CARD_POSTAL_CODE] varchar(24)  NULL,
   [CREDIT_CARD_SIG_ON_FILE] varchar(1)  NULL,
   [PATIENT_RELATIONSHIP] varchar(1)  NULL,
   [CONTACT_METHOD] varchar(1)  NULL,
   [AUTOSHIP] varchar(1)  NULL,
   [INITIAL_SHIPMENT] varchar(1)  NULL,
   [INITIAL_SHIPMENT_DATE] datetime2(0)  NULL,
   [PRICING_LEVEL] varchar(1)  NULL,
   [SHIPPING_PREFERENCE] varchar(1)  NULL,
   [PATIENT_SIG_ON_FILE] varchar(1)  NULL,
   [OTHER_HEALTH_CONDITION] varchar(255)  NULL,
   [OTHER_ALLERGY] varchar(255)  NULL,
   [PROMOTION_CODE] varchar(20)  NULL,
   [DAYS_SUPPLY_INDICATED] numeric(3, 0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.ID_PRESCRIPTIONS_WRITTEN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'ID_PRESCRIPTIONS_WRITTEN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.PATIENT_MIDDLE_INITIAL',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'PATIENT_MIDDLE_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.PATIENT_CELL_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'PATIENT_CELL_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.PATIENT_EMAIL',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'PATIENT_EMAIL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.CREDIT_CARD_TYPE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'CREDIT_CARD_TYPE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.CREDIT_CARD_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'CREDIT_CARD_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.CREDIT_CARD_EXP_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'CREDIT_CARD_EXP_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.CREDIT_CARD_POSTAL_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'CREDIT_CARD_POSTAL_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.CREDIT_CARD_SIG_ON_FILE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'CREDIT_CARD_SIG_ON_FILE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.PATIENT_RELATIONSHIP',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'PATIENT_RELATIONSHIP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.CONTACT_METHOD',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'CONTACT_METHOD'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.AUTOSHIP',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'AUTOSHIP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.INITIAL_SHIPMENT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'INITIAL_SHIPMENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.INITIAL_SHIPMENT_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'INITIAL_SHIPMENT_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.PRICING_LEVEL',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'PRICING_LEVEL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.SHIPPING_PREFERENCE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'SHIPPING_PREFERENCE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.PATIENT_SIG_ON_FILE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'PATIENT_SIG_ON_FILE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.OTHER_HEALTH_CONDITION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'OTHER_HEALTH_CONDITION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.OTHER_ALLERGY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'OTHER_ALLERGY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.PROMOTION_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'PROMOTION_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS.DAYS_SUPPLY_INDICATED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS',
        N'COLUMN', N'DAYS_SUPPLY_INDICATED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ENROLLMENT_FORMS_ALLERGIES'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'ENROLLMENT_FORMS_ALLERGIES'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[ENROLLMENT_FORMS_ALLERGIES]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[ENROLLMENT_FORMS_ALLERGIES]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_ENROLLMENT_FORMS] numeric(38, 0)  NOT NULL,
   [ALLERGY_INDICATED] varchar(6)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS_ALLERGIES',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS_ALLERGIES'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS_ALLERGIES.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS_ALLERGIES',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS_ALLERGIES.ID_ENROLLMENT_FORMS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS_ALLERGIES',
        N'COLUMN', N'ID_ENROLLMENT_FORMS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS_ALLERGIES.ALLERGY_INDICATED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS_ALLERGIES',
        N'COLUMN', N'ALLERGY_INDICATED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ENROLLMENT_FORMS_HEALTH_COND'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'ENROLLMENT_FORMS_HEALTH_COND'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[ENROLLMENT_FORMS_HEALTH_COND]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[ENROLLMENT_FORMS_HEALTH_COND]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_ENROLLMENT_FORMS] numeric(38, 0)  NOT NULL,
   [HEALTH_COND_INDICATED] varchar(6)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS_HEALTH_COND',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS_HEALTH_COND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS_HEALTH_COND.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS_HEALTH_COND',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS_HEALTH_COND.ID_ENROLLMENT_FORMS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS_HEALTH_COND',
        N'COLUMN', N'ID_ENROLLMENT_FORMS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ENROLLMENT_FORMS_HEALTH_COND.HEALTH_COND_INDICATED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ENROLLMENT_FORMS_HEALTH_COND',
        N'COLUMN', N'HEALTH_COND_INDICATED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ERX_EDI_PHARMACIES_XT'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'ERX_EDI_PHARMACIES_XT'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[ERX_EDI_PHARMACIES_XT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[ERX_EDI_PHARMACIES_XT]
(
   [NCPDP_NUMBER] varchar(7)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ERX_EDI_PHARMACIES_XT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ERX_EDI_PHARMACIES_XT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ERX_EDI_PHARMACIES_XT.NCPDP_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ERX_EDI_PHARMACIES_XT',
        N'COLUMN', N'NCPDP_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'FAILED_MESSAGES'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'FAILED_MESSAGES'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[FAILED_MESSAGES]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[FAILED_MESSAGES]
(
   [ID] numeric(38, 0)  NOT NULL,
   [FAILURE_TYPE] numeric(1, 0)  NULL,
   [DATE_FAILED] datetime2(0)  NULL,
   [FAILED_MESSAGE] varbinary(max)  NULL,
   [RETRY_ATTEMPTS] numeric(2, 0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.FAILED_MESSAGES',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'FAILED_MESSAGES'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.FAILED_MESSAGES.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'FAILED_MESSAGES',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.FAILED_MESSAGES.FAILURE_TYPE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'FAILED_MESSAGES',
        N'COLUMN', N'FAILURE_TYPE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.FAILED_MESSAGES.DATE_FAILED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'FAILED_MESSAGES',
        N'COLUMN', N'DATE_FAILED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.FAILED_MESSAGES.FAILED_MESSAGE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'FAILED_MESSAGES',
        N'COLUMN', N'FAILED_MESSAGE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.FAILED_MESSAGES.RETRY_ATTEMPTS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'FAILED_MESSAGES',
        N'COLUMN', N'RETRY_ATTEMPTS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'HCI_PRESCRIBER_SOURCE_DATA_XT'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'HCI_PRESCRIBER_SOURCE_DATA_XT'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[HCI_PRESCRIBER_SOURCE_DATA_XT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[HCI_PRESCRIBER_SOURCE_DATA_XT]
(
   [COMM_GROUP_ID] varchar(10)  NULL,
   [DEA_REGISTRATION_NUM] varchar(13)  NULL,
   [DEA_NUM_RENEWAL_DATE] numeric(8, 0)  NULL,
   [LAST_NAME] varchar(25)  NULL,
   [PREVIOUS_LAST_NAME] varchar(40)  NULL,
   [FIRST_NAME] varchar(25)  NULL,
   [MIDDLE_NAME_INITIAL] varchar(1)  NULL,
   [NAME_SUFFIX] varchar(3)  NULL,
   [GENDER_CODE] varchar(1)  NULL,
   [ORGANIZATION_NAME] varchar(60)  NULL,
   [DEPARTMENT_MAIL_STOP] varchar(40)  NULL,
   [PHYS_ADDRESS_LINE_1] varchar(30)  NULL,
   [PHYS_ADDRESS_LINE_2] varchar(30)  NULL,
   [PHYS_SUITE_APARTMENT_NUM] varchar(8)  NULL,
   [PHYS_CITY_NAME] varchar(20)  NULL,
   [PHYS_STATE_PROVINCE_CODE] varchar(2)  NULL,
   [PHYS_ZIP_POSTAL_ZONE] varchar(9)  NULL,
   [PHYS_COUNTRY_CODE] varchar(3)  NULL,
   [PRIME_PHONE_NUM] numeric(10, 0)  NULL,
   [SECOND_PHONE_NUM] numeric(10, 0)  NULL,
   [REFILL_PHONE_NUM] numeric(10, 0)  NULL,
   [FAX_NUM] numeric(10, 0)  NULL,
   [EMAIL_ADDRESS] varchar(25)  NULL,
   [PRIME_DEGREE] varchar(5)  NULL,
   [PRIME_TAXONOMY_CODE] varchar(10)  NULL,
   [SECOND_DEGREE] varchar(5)  NULL,
   [SECOND_TAXONOMY_CODE] varchar(10)  NULL,
   [STATE_CODE_PRIME_MEDICAID_ID] varchar(2)  NULL,
   [PRIME_MEDICAID_ID] varchar(15)  NULL,
   [STATE_CODE_SECOND_MEDICAID_ID] varchar(2)  NULL,
   [SECOND_MEDICAID_ID] varchar(15)  NULL,
   [STATE_CODE_THIRD_MEDICAID_ID] varchar(2)  NULL,
   [THIRD_MEDICAID_ID] varchar(15)  NULL,
   [UPIN_NUM] varchar(6)  NULL,
   [HIN_NUM] varchar(15)  NULL,
   [HCID_LOCATION_CODE] numeric(2, 0)  NULL,
   [DEA_STATUS_CODE] varchar(1)  NULL,
   [RETIRE_DATE] numeric(8, 0)  NULL,
   [DATA_SUPPLIER_REF_KEY_1] varchar(20)  NULL,
   [DATA_SUPPLIER_REF_KEY_2] varchar(20)  NULL,
   [DATA_SUPPLIER_REF_KEY_3] varchar(20)  NULL,
   [DATA_SUPPLIER_SITE_NUM] varchar(15)  NULL,
   [NPI] varchar(30)  NULL,
   [HCID_IDENTIFIER] varchar(30)  NULL,
   [NHIN_PROVIDER_ID] varchar(30)  NULL,
   [PHYS_LOCATION_TYPE_CODE] varchar(2)  NULL,
   [DUPE_DEA_FLAG] char(1)  NULL,
   [DUPE_DATA_SUPPLIER_REF_KEY_1] varchar(20)  NULL,
   [COMM_SUB_GROUP_ID] varchar(10)  NULL,
   [UPDATE_RECORD_TYPE_CODE] varchar(1)  NULL,
   [DATE_LAST_CHANGE] numeric(8, 0)  NULL,
   [DEA_REGISTRATION_NUM_SUFFIX] varchar(7)  NULL,
   [DEA_DRUG_SCHEDULE] varchar(12)  NULL,
   [NCPDP_PROVIDER_ID_NUM] varchar(15)  NULL,
   [DUPE_DATA_SUPPLIER_REF_KEY_2] varchar(20)  NULL,
   [DUPE_DATA_SUPPLIER_REF_KEY_3] varchar(20)  NULL,
   [ORIGIN] varchar(1)  NULL,
   [RESERVE_1] varchar(1)  NULL,
   [PREVIOUS_HCID] varchar(15)  NULL,
   [REPLACEMENT_HCID] varchar(15)  NULL,
   [HCID_DC_DATE] numeric(8, 0)  NULL,
   [NHIN_DECEASED_FLAG] varchar(1)  NULL,
   [NHIN_DECEASED_DATE] numeric(8, 0)  NULL,
   [REPLACEMENT_DEA_NUM] varchar(13)  NULL,
   [PREVIOUS_DEA_NUM] varchar(13)  NULL,
   [DATA_ELEMENT_CHANGE_TYPE] varchar(3)  NULL,
   [RESERVED] varchar(4)  NULL,
   [STATE_LICENSE_1] varchar(20)  NULL,
   [LICENSING_STATE_1] varchar(3)  NULL,
   [STATE_LICENSE_2] varchar(20)  NULL,
   [LICENSING_STATE_2] varchar(3)  NULL,
   [STATE_LICENSE_3] varchar(20)  NULL,
   [LICENSING_STATE_3] varchar(3)  NULL,
   [FILLER] varchar(149)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.COMM_GROUP_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'COMM_GROUP_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DEA_REGISTRATION_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DEA_REGISTRATION_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DEA_NUM_RENEWAL_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DEA_NUM_RENEWAL_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.PREVIOUS_LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'PREVIOUS_LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.MIDDLE_NAME_INITIAL',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'MIDDLE_NAME_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.NAME_SUFFIX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'NAME_SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.GENDER_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'GENDER_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.ORGANIZATION_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'ORGANIZATION_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DEPARTMENT_MAIL_STOP',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DEPARTMENT_MAIL_STOP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.PHYS_ADDRESS_LINE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'PHYS_ADDRESS_LINE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.PHYS_ADDRESS_LINE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'PHYS_ADDRESS_LINE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.PHYS_SUITE_APARTMENT_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'PHYS_SUITE_APARTMENT_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.PHYS_CITY_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'PHYS_CITY_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.PHYS_STATE_PROVINCE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'PHYS_STATE_PROVINCE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.PHYS_ZIP_POSTAL_ZONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'PHYS_ZIP_POSTAL_ZONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.PHYS_COUNTRY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'PHYS_COUNTRY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.PRIME_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'PRIME_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.SECOND_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'SECOND_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.REFILL_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'REFILL_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.FAX_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'FAX_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.PRIME_DEGREE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'PRIME_DEGREE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.PRIME_TAXONOMY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'PRIME_TAXONOMY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.SECOND_DEGREE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'SECOND_DEGREE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.SECOND_TAXONOMY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'SECOND_TAXONOMY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.STATE_CODE_PRIME_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'STATE_CODE_PRIME_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.PRIME_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'PRIME_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.STATE_CODE_SECOND_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'STATE_CODE_SECOND_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.SECOND_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'SECOND_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.STATE_CODE_THIRD_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'STATE_CODE_THIRD_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.THIRD_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'THIRD_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.UPIN_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'UPIN_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.HIN_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'HIN_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.HCID_LOCATION_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'HCID_LOCATION_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DEA_STATUS_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DEA_STATUS_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.RETIRE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'RETIRE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DATA_SUPPLIER_REF_KEY_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DATA_SUPPLIER_REF_KEY_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DATA_SUPPLIER_REF_KEY_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DATA_SUPPLIER_REF_KEY_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DATA_SUPPLIER_REF_KEY_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DATA_SUPPLIER_REF_KEY_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DATA_SUPPLIER_SITE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DATA_SUPPLIER_SITE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.NPI',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'NPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.HCID_IDENTIFIER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'HCID_IDENTIFIER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.NHIN_PROVIDER_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'NHIN_PROVIDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.PHYS_LOCATION_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'PHYS_LOCATION_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DUPE_DEA_FLAG',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DUPE_DEA_FLAG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DUPE_DATA_SUPPLIER_REF_KEY_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DUPE_DATA_SUPPLIER_REF_KEY_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.COMM_SUB_GROUP_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'COMM_SUB_GROUP_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.UPDATE_RECORD_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'UPDATE_RECORD_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DATE_LAST_CHANGE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DATE_LAST_CHANGE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DEA_REGISTRATION_NUM_SUFFIX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DEA_REGISTRATION_NUM_SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DEA_DRUG_SCHEDULE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DEA_DRUG_SCHEDULE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.NCPDP_PROVIDER_ID_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'NCPDP_PROVIDER_ID_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DUPE_DATA_SUPPLIER_REF_KEY_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DUPE_DATA_SUPPLIER_REF_KEY_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DUPE_DATA_SUPPLIER_REF_KEY_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DUPE_DATA_SUPPLIER_REF_KEY_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.ORIGIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'ORIGIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.RESERVE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'RESERVE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.PREVIOUS_HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'PREVIOUS_HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.REPLACEMENT_HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'REPLACEMENT_HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.HCID_DC_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'HCID_DC_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.NHIN_DECEASED_FLAG',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'NHIN_DECEASED_FLAG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.NHIN_DECEASED_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'NHIN_DECEASED_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.REPLACEMENT_DEA_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'REPLACEMENT_DEA_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.PREVIOUS_DEA_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'PREVIOUS_DEA_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.DATA_ELEMENT_CHANGE_TYPE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'DATA_ELEMENT_CHANGE_TYPE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.RESERVED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'RESERVED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.STATE_LICENSE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'STATE_LICENSE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.LICENSING_STATE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'LICENSING_STATE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.STATE_LICENSE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'STATE_LICENSE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.LICENSING_STATE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'LICENSING_STATE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.STATE_LICENSE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'STATE_LICENSE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.LICENSING_STATE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'LICENSING_STATE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.HCI_PRESCRIBER_SOURCE_DATA_XT.FILLER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'HCI_PRESCRIBER_SOURCE_DATA_XT',
        N'COLUMN', N'FILLER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'INSURANCE_PLAN'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'INSURANCE_PLAN'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[INSURANCE_PLAN]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[INSURANCE_PLAN]
(
   [ID] numeric(38, 0)  NOT NULL,
   [BIN] varchar(6)  NOT NULL,
   [PCN] varchar(10)  NULL,
   [PLAN_NAME] varchar(120)  NULL,
   [PHONE_NUMBER] numeric(10, 0)  NULL,
   [GROUP_NUMBER] varchar(15)  NULL,
   [PDX_CARRIER_CODE] varchar(10)  NOT NULL,
   [CLAIM_PROCESSOR] numeric(38, 0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.INSURANCE_PLAN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'INSURANCE_PLAN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.INSURANCE_PLAN.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'INSURANCE_PLAN',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.INSURANCE_PLAN.BIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'INSURANCE_PLAN',
        N'COLUMN', N'BIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.INSURANCE_PLAN.PCN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'INSURANCE_PLAN',
        N'COLUMN', N'PCN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.INSURANCE_PLAN.PLAN_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'INSURANCE_PLAN',
        N'COLUMN', N'PLAN_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.INSURANCE_PLAN.PHONE_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'INSURANCE_PLAN',
        N'COLUMN', N'PHONE_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.INSURANCE_PLAN.GROUP_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'INSURANCE_PLAN',
        N'COLUMN', N'GROUP_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.INSURANCE_PLAN.PDX_CARRIER_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'INSURANCE_PLAN',
        N'COLUMN', N'PDX_CARRIER_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.INSURANCE_PLAN.CLAIM_PROCESSOR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'INSURANCE_PLAN',
        N'COLUMN', N'CLAIM_PROCESSOR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MANUFACTURER_PROGRAM'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'MANUFACTURER_PROGRAM'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[MANUFACTURER_PROGRAM]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[MANUFACTURER_PROGRAM]
(
   [ID] numeric(38, 0)  NOT NULL,
   [PROGRAM_NAME] varchar(120)  NOT NULL,
   [PROGRAM_PHONE] numeric(10, 0)  NULL,
   [PROGRAM_CONTACT_NAME] varchar(60)  NULL,
   [PROGRAM_FORM_URL] varchar(120)  NULL,
   [PROGRAM_LOGO_IMAGE] varchar(120)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MANUFACTURER_PROGRAM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MANUFACTURER_PROGRAM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MANUFACTURER_PROGRAM.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MANUFACTURER_PROGRAM',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MANUFACTURER_PROGRAM.PROGRAM_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MANUFACTURER_PROGRAM',
        N'COLUMN', N'PROGRAM_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MANUFACTURER_PROGRAM.PROGRAM_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MANUFACTURER_PROGRAM',
        N'COLUMN', N'PROGRAM_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MANUFACTURER_PROGRAM.PROGRAM_CONTACT_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MANUFACTURER_PROGRAM',
        N'COLUMN', N'PROGRAM_CONTACT_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MANUFACTURER_PROGRAM.PROGRAM_FORM_URL',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MANUFACTURER_PROGRAM',
        N'COLUMN', N'PROGRAM_FORM_URL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MANUFACTURER_PROGRAM.PROGRAM_LOGO_IMAGE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MANUFACTURER_PROGRAM',
        N'COLUMN', N'PROGRAM_LOGO_IMAGE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MFR_PROGRAM_NDC_LINK'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'MFR_PROGRAM_NDC_LINK'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[MFR_PROGRAM_NDC_LINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[MFR_PROGRAM_NDC_LINK]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_MANUFACTURER_PROGRAM] numeric(38, 0)  NOT NULL,
   [PROGRAM_FORM_URL] varchar(120)  NULL,
   [NDC] varchar(13)  NULL,
   [DRUG_NAME] varchar(120)  NULL,
   [DDID] numeric(10, 0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_NDC_LINK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_NDC_LINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_NDC_LINK.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_NDC_LINK',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_NDC_LINK.ID_MANUFACTURER_PROGRAM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_NDC_LINK',
        N'COLUMN', N'ID_MANUFACTURER_PROGRAM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_NDC_LINK.PROGRAM_FORM_URL',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_NDC_LINK',
        N'COLUMN', N'PROGRAM_FORM_URL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_NDC_LINK.NDC',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_NDC_LINK',
        N'COLUMN', N'NDC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_NDC_LINK.DRUG_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_NDC_LINK',
        N'COLUMN', N'DRUG_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_NDC_LINK.DDID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_NDC_LINK',
        N'COLUMN', N'DDID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MFR_PROGRAM_PHARMACY_LINK'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'MFR_PROGRAM_PHARMACY_LINK'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[MFR_PROGRAM_PHARMACY_LINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[MFR_PROGRAM_PHARMACY_LINK]
(
   [ID] numeric(38, 0)  NOT NULL,
   [NCPDP_NUMBER] varchar(7)  NOT NULL,
   [ID_MANUFACTURER_PROGRAM] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_PHARMACY_LINK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_PHARMACY_LINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_PHARMACY_LINK.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_PHARMACY_LINK',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_PHARMACY_LINK.NCPDP_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_PHARMACY_LINK',
        N'COLUMN', N'NCPDP_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_PHARMACY_LINK.ID_MANUFACTURER_PROGRAM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_PHARMACY_LINK',
        N'COLUMN', N'ID_MANUFACTURER_PROGRAM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NCPDP_MESSAGES'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'NCPDP_MESSAGES'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[NCPDP_MESSAGES]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[NCPDP_MESSAGES]
(
   [ID] numeric(38, 0)  NOT NULL,
   [NCPDP_MESSAGE] varbinary(max)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_MESSAGES',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_MESSAGES'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_MESSAGES.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_MESSAGES',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_MESSAGES.NCPDP_MESSAGE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_MESSAGES',
        N'COLUMN', N'NCPDP_MESSAGE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NCPDP_PHARMACY_MEDICAID_IDS_XT'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'NCPDP_PHARMACY_MEDICAID_IDS_XT'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[NCPDP_PHARMACY_MEDICAID_IDS_XT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[NCPDP_PHARMACY_MEDICAID_IDS_XT]
(
   [NCPDP_PROVIDER_NUM] varchar(7)  NULL,
   [STATE_CODE] varchar(2)  NULL,
   [MEDICAID_ID] varchar(20)  NULL,
   [DELETE_DATE] varchar(8)  NULL,
   [FILLER] varchar(113)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_MEDICAID_IDS_XT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_MEDICAID_IDS_XT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_MEDICAID_IDS_XT.NCPDP_PROVIDER_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_MEDICAID_IDS_XT',
        N'COLUMN', N'NCPDP_PROVIDER_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_MEDICAID_IDS_XT.STATE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_MEDICAID_IDS_XT',
        N'COLUMN', N'STATE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_MEDICAID_IDS_XT.MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_MEDICAID_IDS_XT',
        N'COLUMN', N'MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_MEDICAID_IDS_XT.DELETE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_MEDICAID_IDS_XT',
        N'COLUMN', N'DELETE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_MEDICAID_IDS_XT.FILLER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_MEDICAID_IDS_XT',
        N'COLUMN', N'FILLER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NCPDP_PHARMACY_SOURCE_DATA_XT'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'NCPDP_PHARMACY_SOURCE_DATA_XT'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[NCPDP_PHARMACY_SOURCE_DATA_XT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[NCPDP_PHARMACY_SOURCE_DATA_XT]
(
   [NCPDP_PROVIDER_NUM] varchar(7)  NULL,
   [LEGAL_BUS_NAME] varchar(60)  NULL,
   [NAME] varchar(60)  NULL,
   [STORE_NUM] varchar(10)  NULL,
   [ADDRESS_1] varchar(55)  NULL,
   [ADDRESS_2] varchar(55)  NULL,
   [CITY] varchar(30)  NULL,
   [STATE_CODE] varchar(2)  NULL,
   [ZIP_CODE] varchar(9)  NULL,
   [PHONE_NUM] varchar(10)  NULL,
   [FAX_NUM] varchar(10)  NULL,
   [E_MAIL_ADDRESS] varchar(50)  NULL,
   [CROSS_STREET_DIRECTIONS] varchar(50)  NULL,
   [FIPS_COUNTY_PARISH_CODE] varchar(5)  NULL,
   [FIPS_MSA_CODE] varchar(4)  NULL,
   [FIPS_PMSA_CODE] varchar(4)  NULL,
   [OPEN_24_HOUR] varchar(1)  NULL,
   [PROVIDER_HOURS] varchar(35)  NULL,
   [ACCEPTS_ESCRIPTS] varchar(1)  NULL,
   [DELIVERY_SERVICE] varchar(1)  NULL,
   [COMPOUNDING_SERVICE] varchar(1)  NULL,
   [DRIVE_UP_WINDOW] varchar(1)  NULL,
   [SELLS_DME_EQUIPMENT] varchar(1)  NULL,
   [CONGRESSIONAL_VOTING_DIST] varchar(4)  NULL,
   [LANGUAGE_CODE_1] varchar(2)  NULL,
   [LANGUAGE_CODE_2] varchar(2)  NULL,
   [LANGUAGE_CODE_3] varchar(2)  NULL,
   [LANGUAGE_CODE_4] varchar(2)  NULL,
   [LANGUAGE_CODE_5] varchar(2)  NULL,
   [HANDICAP_ACCESSIBLE] varchar(1)  NULL,
   [STORE_OPEN_DATE] varchar(8)  NULL,
   [STORE_CLOSURE_DATE] varchar(8)  NULL,
   [MAILING_ADDRESS_1] varchar(55)  NULL,
   [MAILING_ADDRESS_2] varchar(55)  NULL,
   [MAILING_ADDRESS_CITY] varchar(30)  NULL,
   [MAILING_ADDRESS_STATE_CODE] varchar(2)  NULL,
   [MAILING_ADDRESS_ZIP_CODE] varchar(9)  NULL,
   [CONTACT_LAST_NAME] varchar(20)  NULL,
   [CONTACT_FIRST_NAME] varchar(20)  NULL,
   [CONTACT_MIDDLE_INITIAL] varchar(1)  NULL,
   [CONTACT_TITLE] varchar(30)  NULL,
   [CONTACT_PHONE_NUM] varchar(10)  NULL,
   [CONTACT_EXTENSION] varchar(5)  NULL,
   [CONTACT_E_MAIL_ADDRESS] varchar(50)  NULL,
   [DISPENSER_CLASS_CODE] varchar(2)  NULL,
   [PRIMARY_DISPENSER_TYPE_CODE] varchar(2)  NULL,
   [SECONDARY_DISPENSER_TYPE_CODE] varchar(2)  NULL,
   [TERTIARY_DISPENSER_TYPE_CODE] varchar(2)  NULL,
   [MEDICARE_ID] varchar(10)  NULL,
   [NPI_ID] varchar(10)  NULL,
   [DEA_REGISTRATION_ID] varchar(12)  NULL,
   [FEDERAL_TAX_ID] varchar(15)  NULL,
   [STATE_LICENSE_NUM] varchar(20)  NULL,
   [STATE_TAX_ID] varchar(15)  NULL,
   [DELETE_DATE] varchar(8)  NULL,
   [TRANSACTION_CODE] varchar(1)  NULL,
   [TRANSACTION_DATE] varchar(8)  NULL,
   [FILLER] varchar(108)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.NCPDP_PROVIDER_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'NCPDP_PROVIDER_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.LEGAL_BUS_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'LEGAL_BUS_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT."NAME"',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.STORE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'STORE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.ADDRESS_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'ADDRESS_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.ADDRESS_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'ADDRESS_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.CITY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.STATE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'STATE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.ZIP_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'ZIP_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.FAX_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'FAX_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.E_MAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'E_MAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.CROSS_STREET_DIRECTIONS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'CROSS_STREET_DIRECTIONS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.FIPS_COUNTY_PARISH_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'FIPS_COUNTY_PARISH_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.FIPS_MSA_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'FIPS_MSA_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.FIPS_PMSA_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'FIPS_PMSA_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.OPEN_24_HOUR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'OPEN_24_HOUR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.PROVIDER_HOURS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'PROVIDER_HOURS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.ACCEPTS_ESCRIPTS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'ACCEPTS_ESCRIPTS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.DELIVERY_SERVICE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'DELIVERY_SERVICE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.COMPOUNDING_SERVICE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'COMPOUNDING_SERVICE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.DRIVE_UP_WINDOW',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'DRIVE_UP_WINDOW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.SELLS_DME_EQUIPMENT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'SELLS_DME_EQUIPMENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.CONGRESSIONAL_VOTING_DIST',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'CONGRESSIONAL_VOTING_DIST'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.LANGUAGE_CODE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'LANGUAGE_CODE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.LANGUAGE_CODE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'LANGUAGE_CODE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.LANGUAGE_CODE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'LANGUAGE_CODE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.LANGUAGE_CODE_4',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'LANGUAGE_CODE_4'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.LANGUAGE_CODE_5',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'LANGUAGE_CODE_5'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.HANDICAP_ACCESSIBLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'HANDICAP_ACCESSIBLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.STORE_OPEN_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'STORE_OPEN_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.STORE_CLOSURE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'STORE_CLOSURE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.MAILING_ADDRESS_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'MAILING_ADDRESS_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.MAILING_ADDRESS_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'MAILING_ADDRESS_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.MAILING_ADDRESS_CITY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'MAILING_ADDRESS_CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.MAILING_ADDRESS_STATE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'MAILING_ADDRESS_STATE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.MAILING_ADDRESS_ZIP_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'MAILING_ADDRESS_ZIP_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.CONTACT_LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'CONTACT_LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.CONTACT_FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'CONTACT_FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.CONTACT_MIDDLE_INITIAL',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'CONTACT_MIDDLE_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.CONTACT_TITLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'CONTACT_TITLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.CONTACT_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'CONTACT_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.CONTACT_EXTENSION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'CONTACT_EXTENSION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.CONTACT_E_MAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'CONTACT_E_MAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.DISPENSER_CLASS_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'DISPENSER_CLASS_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.PRIMARY_DISPENSER_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'PRIMARY_DISPENSER_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.SECONDARY_DISPENSER_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'SECONDARY_DISPENSER_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.TERTIARY_DISPENSER_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'TERTIARY_DISPENSER_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.MEDICARE_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'MEDICARE_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.NPI_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'NPI_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.DEA_REGISTRATION_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'DEA_REGISTRATION_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.FEDERAL_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'FEDERAL_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.STATE_LICENSE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'STATE_LICENSE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.STATE_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'STATE_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.DELETE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'DELETE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.TRANSACTION_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'TRANSACTION_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.TRANSACTION_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'TRANSACTION_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_PHARMACY_SOURCE_DATA_XT.FILLER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_PHARMACY_SOURCE_DATA_XT',
        N'COLUMN', N'FILLER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NHIN_CLINIC'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'NHIN_CLINIC'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[NHIN_CLINIC]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[NHIN_CLINIC]
(
   [ID] numeric(38, 0)  NOT NULL,
   [NHIN_COM_CLINIC_ID] numeric(38, 0)  NOT NULL,
   [ID_ADDRESS] numeric(38, 0)  NOT NULL,
   [OFFICE_PHONE_1] numeric(10, 0)  NULL,
   [OFFICE_PHONE_2] numeric(10, 0)  NULL,
   [FAX_PHONE] numeric(10, 0)  NULL,
   [REFILL_PHONE] numeric(10, 0)  NULL,
   [CONTACT_PREF] numeric(2, 0)  NULL,
   [SCRIPT_VERSION] varchar(6)  NULL,
   [HIN] varchar(9)  NULL,
   [FEDERAL_TAX_ID] varchar(10)  NULL,
   [NPI] varchar(30)  NULL,
   [DEPARTMENT_MAIL_STOP] varchar(40)  NULL,
   [CLINIC_NAME] varchar(60)  NULL,
   [CONTACT_NAME] varchar(60)  NULL,
   [DEPARTMENT] varchar(60)  NULL,
   [DEACTIVATION_DATE] datetime2(0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.NHIN_COM_CLINIC_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'NHIN_COM_CLINIC_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.ID_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'ID_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.OFFICE_PHONE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'OFFICE_PHONE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.OFFICE_PHONE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'OFFICE_PHONE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.FAX_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'FAX_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.REFILL_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'REFILL_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.CONTACT_PREF',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'CONTACT_PREF'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.SCRIPT_VERSION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'SCRIPT_VERSION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.HIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'HIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.FEDERAL_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'FEDERAL_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.NPI',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'NPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.DEPARTMENT_MAIL_STOP',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'DEPARTMENT_MAIL_STOP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.CLINIC_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'CLINIC_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.CONTACT_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'CONTACT_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.DEPARTMENT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'DEPARTMENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.DEACTIVATION_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'COLUMN', N'DEACTIVATION_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NHIN_CLINIC_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'NHIN_CLINIC_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[NHIN_CLINIC_UPD_ERR]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[NHIN_CLINIC_UPD_ERR]
(
   [ID] numeric(38, 0)  NULL,
   [NHIN_COM_CLINIC_ID] numeric(38, 0)  NULL,
   [ID_ADDRESS] numeric(38, 0)  NULL,
   [OFFICE_PHONE_1] numeric(10, 0)  NULL,
   [OFFICE_PHONE_2] numeric(10, 0)  NULL,
   [FAX_PHONE] numeric(10, 0)  NULL,
   [REFILL_PHONE] numeric(10, 0)  NULL,
   [CONTACT_PREF] numeric(2, 0)  NULL,
   [SCRIPT_VERSION] varchar(6)  NULL,
   [HIN] varchar(9)  NULL,
   [FEDERAL_TAX_ID] varchar(10)  NULL,
   [NPI] varchar(30)  NULL,
   [DEPARTMENT_MAIL_STOP] varchar(40)  NULL,
   [CLINIC_NAME] varchar(60)  NULL,
   [CONTACT_NAME] varchar(60)  NULL,
   [DEPARTMENT] varchar(60)  NULL,
   [DEACTIVATION_DATE] datetime2(0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.NHIN_COM_CLINIC_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'NHIN_COM_CLINIC_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.ID_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'ID_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.OFFICE_PHONE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'OFFICE_PHONE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.OFFICE_PHONE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'OFFICE_PHONE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.FAX_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'FAX_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.REFILL_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'REFILL_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.CONTACT_PREF',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'CONTACT_PREF'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.SCRIPT_VERSION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'SCRIPT_VERSION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.HIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'HIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.FEDERAL_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'FEDERAL_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.NPI',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'NPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.DEPARTMENT_MAIL_STOP',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'DEPARTMENT_MAIL_STOP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.CLINIC_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'CLINIC_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.CONTACT_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'CONTACT_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.DEPARTMENT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'DEPARTMENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC_UPD_ERR.DEACTIVATION_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC_UPD_ERR',
        N'COLUMN', N'DEACTIVATION_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[NHIN_PRESCR_CLINIC_LNK_UPD_ERR]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[NHIN_PRESCR_CLINIC_LNK_UPD_ERR]
(
   [ID] numeric(38, 0)  NULL,
   [ID_NHIN_CLINIC] numeric(38, 0)  NULL,
   [ID_NHIN_PRESCRIBER] numeric(38, 0)  NULL,
   [DEACTIVATION_DATE] datetime2(0)  NULL,
   [SUPERVISING_PRES_ID] numeric(38, 0)  NULL,
   [OFFICE_PHONE] numeric(10, 0)  NULL,
   [FAX_PHONE] numeric(10, 0)  NULL,
   [REFILL_PHONE] numeric(10, 0)  NULL,
   [HCID] varchar(30)  NULL,
   [HCIDEA_LOCATION] varchar(3)  NULL,
   [HIN] varchar(9)  NULL,
   [FEDERAL_TAX_ID] varchar(10)  NULL,
   [DEA_ID] varchar(15)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCR_CLINIC_LNK_UPD_ERR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCR_CLINIC_LNK_UPD_ERR.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCR_CLINIC_LNK_UPD_ERR.ID_NHIN_CLINIC',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR',
        N'COLUMN', N'ID_NHIN_CLINIC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCR_CLINIC_LNK_UPD_ERR.ID_NHIN_PRESCRIBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR',
        N'COLUMN', N'ID_NHIN_PRESCRIBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCR_CLINIC_LNK_UPD_ERR.DEACTIVATION_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR',
        N'COLUMN', N'DEACTIVATION_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCR_CLINIC_LNK_UPD_ERR.SUPERVISING_PRES_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR',
        N'COLUMN', N'SUPERVISING_PRES_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCR_CLINIC_LNK_UPD_ERR.OFFICE_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR',
        N'COLUMN', N'OFFICE_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCR_CLINIC_LNK_UPD_ERR.FAX_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR',
        N'COLUMN', N'FAX_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCR_CLINIC_LNK_UPD_ERR.REFILL_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR',
        N'COLUMN', N'REFILL_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCR_CLINIC_LNK_UPD_ERR.HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR',
        N'COLUMN', N'HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCR_CLINIC_LNK_UPD_ERR.HCIDEA_LOCATION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR',
        N'COLUMN', N'HCIDEA_LOCATION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCR_CLINIC_LNK_UPD_ERR.HIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR',
        N'COLUMN', N'HIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCR_CLINIC_LNK_UPD_ERR.FEDERAL_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR',
        N'COLUMN', N'FEDERAL_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCR_CLINIC_LNK_UPD_ERR.DEA_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCR_CLINIC_LNK_UPD_ERR',
        N'COLUMN', N'DEA_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NHIN_PRESCRIBER'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'NHIN_PRESCRIBER'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[NHIN_PRESCRIBER]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[NHIN_PRESCRIBER]
(
   [ID] numeric(38, 0)  NOT NULL,
   [NHIN_COM_ID] numeric(22, 0)  NOT NULL,
   [LAST_NAME] varchar(25)  NOT NULL,
   [FIRST_NAME] varchar(25)  NOT NULL,
   [MIDDLE_NAME] varchar(20)  NULL,
   [NAME_SUFFIX] varchar(5)  NULL,
   [NAME_PREFIX] varchar(5)  NULL,
   [HCID] varchar(30)  NULL,
   [NPI] varchar(30)  NULL,
   [DEA_ID] varchar(15)  NULL,
   [DEA_STATUS_CODE] char(1)  NULL,
   [DAW] char(1)  NULL,
   [GENDER] char(1)  NULL,
   [BIRTH_DATE] datetime2(0)  NULL,
   [DEACTIVATION_DATE] datetime2(0)  NULL,
   [NHIN_RETIRE] datetime2(0)  NULL,
   [NHIN_DECEASED] datetime2(0)  NULL,
   [MOBILE_PHONE] numeric(10, 0)  NULL,
   [PAGER] numeric(10, 0)  NULL,
   [HOME_PHONE] numeric(10, 0)  NULL,
   [PROBATION] varchar(1)  NULL,
   [SPECIALTY] varchar(3)  NULL,
   [DEGREE_1] varchar(5)  NULL,
   [DEGREE_2] varchar(5)  NULL,
   [UPIN] varchar(6)  NULL,
   [TAXONOMY_CODE_1] varchar(10)  NULL,
   [TAXONOMY_CODE_2] varchar(10)  NULL,
   [FEDERAL_TAX_ID] varchar(10)  NULL,
   [NCPDP_ID] varchar(15)  NULL,
   [PREVIOUS_HCID] varchar(15)  NULL,
   [MEDICARE_ID] varchar(20)  NULL,
   [BLUE_CROSS_ID] varchar(20)  NULL,
   [BLUE_SHIELD_ID] varchar(20)  NULL,
   [CHAMPUS_ID] varchar(20)  NULL,
   [NHIN_ID] varchar(30)  NULL,
   [EMAIL_ADDRESS] varchar(120)  NULL,
   [VERIFIED] varchar(1)  NULL,
   [ID_PRIMARY_CLINIC_LINK] numeric(38, 0)  NULL,
   [NEW_RX_EMAIL_ADDRESS] varchar(120)  NULL,
   [REGISTRATION_DATE] datetime2(0)  NULL,
   [REGISTRATION_PIN] varchar(10)  NULL,
   [VERIFICATION_DATE] datetime2(0)  NULL,
   [ID_REGISTRATION_ADDRESS] numeric(38, 0)  NULL,
   [ID_BILLING_SERVICE] numeric(38, 0)  NULL,
   [TERMS_OF_USE_ACCEPTED] varchar(10)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NHIN_COM_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'NHIN_COM_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.MIDDLE_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'MIDDLE_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NAME_SUFFIX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'NAME_SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NAME_PREFIX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'NAME_PREFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NPI',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'NPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.DEA_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'DEA_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.DEA_STATUS_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'DEA_STATUS_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.DAW',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'DAW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.GENDER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'GENDER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.BIRTH_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'BIRTH_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.DEACTIVATION_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'DEACTIVATION_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NHIN_RETIRE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'NHIN_RETIRE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NHIN_DECEASED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'NHIN_DECEASED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.MOBILE_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'MOBILE_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.PAGER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'PAGER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.HOME_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'HOME_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.PROBATION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'PROBATION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.SPECIALTY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'SPECIALTY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.DEGREE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'DEGREE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.DEGREE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'DEGREE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.UPIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'UPIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.TAXONOMY_CODE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'TAXONOMY_CODE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.TAXONOMY_CODE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'TAXONOMY_CODE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.FEDERAL_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'FEDERAL_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NCPDP_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'NCPDP_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.PREVIOUS_HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'PREVIOUS_HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.MEDICARE_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'MEDICARE_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.BLUE_CROSS_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'BLUE_CROSS_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.BLUE_SHIELD_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'BLUE_SHIELD_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.CHAMPUS_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'CHAMPUS_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NHIN_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'NHIN_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.VERIFIED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'VERIFIED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.ID_PRIMARY_CLINIC_LINK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'ID_PRIMARY_CLINIC_LINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NEW_RX_EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'NEW_RX_EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.REGISTRATION_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'REGISTRATION_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.REGISTRATION_PIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'REGISTRATION_PIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.VERIFICATION_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'VERIFICATION_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.ID_REGISTRATION_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'ID_REGISTRATION_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.ID_BILLING_SERVICE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'ID_BILLING_SERVICE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.TERMS_OF_USE_ACCEPTED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'COLUMN', N'TERMS_OF_USE_ACCEPTED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NHIN_PRESCRIBER_CLINIC_LINK'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'NHIN_PRESCRIBER_CLINIC_LINK'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[NHIN_PRESCRIBER_CLINIC_LINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[NHIN_PRESCRIBER_CLINIC_LINK]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_NHIN_CLINIC] numeric(38, 0)  NOT NULL,
   [ID_NHIN_PRESCRIBER] numeric(38, 0)  NOT NULL,
   [DEACTIVATION_DATE] datetime2(0)  NULL,
   [SUPERVISING_PRES_ID] numeric(38, 0)  NULL,
   [OFFICE_PHONE] numeric(10, 0)  NULL,
   [FAX_PHONE] numeric(10, 0)  NULL,
   [REFILL_PHONE] numeric(10, 0)  NULL,
   [HCID] varchar(30)  NULL,
   [HCIDEA_LOCATION] varchar(3)  NULL,
   [HIN] varchar(9)  NULL,
   [FEDERAL_TAX_ID] varchar(10)  NULL,
   [DEA_ID] varchar(15)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.ID_NHIN_CLINIC',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'COLUMN', N'ID_NHIN_CLINIC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.ID_NHIN_PRESCRIBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'COLUMN', N'ID_NHIN_PRESCRIBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.DEACTIVATION_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'COLUMN', N'DEACTIVATION_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.SUPERVISING_PRES_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'COLUMN', N'SUPERVISING_PRES_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.OFFICE_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'COLUMN', N'OFFICE_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.FAX_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'COLUMN', N'FAX_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.REFILL_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'COLUMN', N'REFILL_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'COLUMN', N'HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.HCIDEA_LOCATION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'COLUMN', N'HCIDEA_LOCATION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.HIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'COLUMN', N'HIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.FEDERAL_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'COLUMN', N'FEDERAL_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.DEA_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'COLUMN', N'DEA_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NHIN_PRESCRIBER_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'NHIN_PRESCRIBER_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[NHIN_PRESCRIBER_UPD_ERR]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[NHIN_PRESCRIBER_UPD_ERR]
(
   [ID] numeric(38, 0)  NULL,
   [NHIN_COM_ID] numeric(22, 0)  NULL,
   [LAST_NAME] varchar(25)  NULL,
   [FIRST_NAME] varchar(25)  NULL,
   [MIDDLE_NAME] varchar(20)  NULL,
   [NAME_SUFFIX] varchar(5)  NULL,
   [NAME_PREFIX] varchar(5)  NULL,
   [HCID] varchar(30)  NULL,
   [NPI] varchar(30)  NULL,
   [DEA_ID] varchar(15)  NULL,
   [DEA_STATUS_CODE] char(1)  NULL,
   [DAW] char(1)  NULL,
   [GENDER] char(1)  NULL,
   [BIRTH_DATE] datetime2(0)  NULL,
   [DEACTIVATION_DATE] datetime2(0)  NULL,
   [NHIN_RETIRE] datetime2(0)  NULL,
   [NHIN_DECEASED] datetime2(0)  NULL,
   [MOBILE_PHONE] numeric(10, 0)  NULL,
   [PAGER] numeric(10, 0)  NULL,
   [HOME_PHONE] numeric(10, 0)  NULL,
   [PROBATION] varchar(1)  NULL,
   [SPECIALTY] varchar(3)  NULL,
   [DEGREE_1] varchar(5)  NULL,
   [DEGREE_2] varchar(5)  NULL,
   [UPIN] varchar(6)  NULL,
   [TAXONOMY_CODE_1] varchar(10)  NULL,
   [TAXONOMY_CODE_2] varchar(10)  NULL,
   [FEDERAL_TAX_ID] varchar(10)  NULL,
   [NCPDP_ID] varchar(15)  NULL,
   [PREVIOUS_HCID] varchar(15)  NULL,
   [MEDICARE_ID] varchar(20)  NULL,
   [BLUE_CROSS_ID] varchar(20)  NULL,
   [BLUE_SHIELD_ID] varchar(20)  NULL,
   [CHAMPUS_ID] varchar(20)  NULL,
   [NHIN_ID] varchar(30)  NULL,
   [EMAIL_ADDRESS] varchar(120)  NULL,
   [VERIFIED] varchar(1)  NULL,
   [ID_PRIMARY_CLINIC_LINK] numeric(38, 0)  NULL,
   [NEW_RX_EMAIL_ADDRESS] varchar(120)  NULL,
   [REGISTRATION_DATE] datetime2(0)  NULL,
   [REGISTRATION_PIN] varchar(10)  NULL,
   [VERIFICATION_DATE] datetime2(0)  NULL,
   [ID_REGISTRATION_ADDRESS] numeric(38, 0)  NULL,
   [ID_BILLING_SERVICE] numeric(38, 0)  NULL,
   [TERMS_OF_USE_ACCEPTED] varchar(10)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.NHIN_COM_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'NHIN_COM_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.MIDDLE_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'MIDDLE_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.NAME_SUFFIX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'NAME_SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.NAME_PREFIX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'NAME_PREFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.NPI',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'NPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.DEA_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'DEA_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.DEA_STATUS_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'DEA_STATUS_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.DAW',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'DAW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.GENDER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'GENDER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.BIRTH_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'BIRTH_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.DEACTIVATION_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'DEACTIVATION_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.NHIN_RETIRE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'NHIN_RETIRE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.NHIN_DECEASED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'NHIN_DECEASED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.MOBILE_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'MOBILE_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.PAGER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'PAGER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.HOME_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'HOME_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.PROBATION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'PROBATION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.SPECIALTY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'SPECIALTY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.DEGREE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'DEGREE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.DEGREE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'DEGREE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.UPIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'UPIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.TAXONOMY_CODE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'TAXONOMY_CODE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.TAXONOMY_CODE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'TAXONOMY_CODE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.FEDERAL_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'FEDERAL_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.NCPDP_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'NCPDP_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.PREVIOUS_HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'PREVIOUS_HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.MEDICARE_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'MEDICARE_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.BLUE_CROSS_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'BLUE_CROSS_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.BLUE_SHIELD_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'BLUE_SHIELD_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.CHAMPUS_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'CHAMPUS_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.NHIN_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'NHIN_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.VERIFIED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'VERIFIED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.ID_PRIMARY_CLINIC_LINK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'ID_PRIMARY_CLINIC_LINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.NEW_RX_EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'NEW_RX_EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.REGISTRATION_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'REGISTRATION_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.REGISTRATION_PIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'REGISTRATION_PIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.VERIFICATION_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'VERIFICATION_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.ID_REGISTRATION_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'ID_REGISTRATION_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.ID_BILLING_SERVICE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'ID_BILLING_SERVICE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_UPD_ERR.TERMS_OF_USE_ACCEPTED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_UPD_ERR',
        N'COLUMN', N'TERMS_OF_USE_ACCEPTED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ORDER_INFO'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'ORDER_INFO'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[ORDER_INFO]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[ORDER_INFO]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_PRESCRIPTIONS_WRITTEN] numeric(38, 0)  NOT NULL,
   [SHIPPED_DATE] datetime2(0)  NULL,
   [ORDER_STATUS] numeric(2, 0)  NULL,
   [LAST_STATUS_DATE] datetime2(0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO.ID_PRESCRIPTIONS_WRITTEN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO',
        N'COLUMN', N'ID_PRESCRIPTIONS_WRITTEN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO.SHIPPED_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO',
        N'COLUMN', N'SHIPPED_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO.ORDER_STATUS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO',
        N'COLUMN', N'ORDER_STATUS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO.LAST_STATUS_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO',
        N'COLUMN', N'LAST_STATUS_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ORDER_INFO_20071101'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'ORDER_INFO_20071101'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[ORDER_INFO_20071101]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[ORDER_INFO_20071101]
(
   [ID] numeric(38, 0)  NULL,
   [ID_PRESCRIPTIONS_WRITTEN] numeric(38, 0)  NOT NULL,
   [SHIPPED_DATE] datetime2(0)  NULL,
   [ORDER_STATUS] numeric(2, 0)  NULL,
   [LAST_STATUS_DATE] datetime2(0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO_20071101',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO_20071101'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO_20071101.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO_20071101',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO_20071101.ID_PRESCRIPTIONS_WRITTEN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO_20071101',
        N'COLUMN', N'ID_PRESCRIPTIONS_WRITTEN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO_20071101.SHIPPED_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO_20071101',
        N'COLUMN', N'SHIPPED_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO_20071101.ORDER_STATUS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO_20071101',
        N'COLUMN', N'ORDER_STATUS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO_20071101.LAST_STATUS_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO_20071101',
        N'COLUMN', N'LAST_STATUS_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ORDER_INFO_BK'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'ORDER_INFO_BK'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[ORDER_INFO_BK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[ORDER_INFO_BK]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_PRESCRIPTIONS_WRITTEN] numeric(38, 0)  NOT NULL,
   [SHIPPED_DATE] datetime2(0)  NULL,
   [ORDER_STATUS] numeric(2, 0)  NULL,
   [LAST_STATUS_DATE] datetime2(0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO_BK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO_BK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO_BK.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO_BK',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO_BK.ID_PRESCRIPTIONS_WRITTEN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO_BK',
        N'COLUMN', N'ID_PRESCRIPTIONS_WRITTEN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO_BK.SHIPPED_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO_BK',
        N'COLUMN', N'SHIPPED_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO_BK.ORDER_STATUS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO_BK',
        N'COLUMN', N'ORDER_STATUS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO_BK.LAST_STATUS_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO_BK',
        N'COLUMN', N'LAST_STATUS_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PASSWORD_HISTORY'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PASSWORD_HISTORY'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PASSWORD_HISTORY]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PASSWORD_HISTORY]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_APP_USER] numeric(38, 0)  NOT NULL,
   [PASSWORD] varchar(32)  NOT NULL,
   [DATE_CREATED] datetime2(0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PASSWORD_HISTORY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PASSWORD_HISTORY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PASSWORD_HISTORY.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PASSWORD_HISTORY',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PASSWORD_HISTORY.ID_APP_USER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PASSWORD_HISTORY',
        N'COLUMN', N'ID_APP_USER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PASSWORD_HISTORY.PASSWORD',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PASSWORD_HISTORY',
        N'COLUMN', N'PASSWORD'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PASSWORD_HISTORY.DATE_CREATED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PASSWORD_HISTORY',
        N'COLUMN', N'DATE_CREATED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PHARM_MEDI_UPD_XT'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PHARM_MEDI_UPD_XT'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PHARM_MEDI_UPD_XT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PHARM_MEDI_UPD_XT]
(
   [NCPDP_PROVIDER_NUM] varchar(7)  NULL,
   [STATE_CODE] varchar(2)  NULL,
   [MEDICAID_ID] varchar(20)  NULL,
   [DELETE_DATE] varchar(8)  NULL,
   [FILLER] varchar(113)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_MEDI_UPD_XT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_MEDI_UPD_XT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_MEDI_UPD_XT.NCPDP_PROVIDER_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_MEDI_UPD_XT',
        N'COLUMN', N'NCPDP_PROVIDER_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_MEDI_UPD_XT.STATE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_MEDI_UPD_XT',
        N'COLUMN', N'STATE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_MEDI_UPD_XT.MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_MEDI_UPD_XT',
        N'COLUMN', N'MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_MEDI_UPD_XT.DELETE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_MEDI_UPD_XT',
        N'COLUMN', N'DELETE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_MEDI_UPD_XT.FILLER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_MEDI_UPD_XT',
        N'COLUMN', N'FILLER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PHARM_UPD_XT'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PHARM_UPD_XT'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PHARM_UPD_XT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PHARM_UPD_XT]
(
   [NCPDP_PROVIDER_NUM] varchar(7)  NULL,
   [LEGAL_BUS_NAME] varchar(60)  NULL,
   [NAME] varchar(60)  NULL,
   [STORE_NUM] varchar(10)  NULL,
   [ADDRESS_1] varchar(55)  NULL,
   [ADDRESS_2] varchar(55)  NULL,
   [CITY] varchar(30)  NULL,
   [STATE_CODE] varchar(2)  NULL,
   [ZIP_CODE] varchar(9)  NULL,
   [PHONE_NUM] varchar(10)  NULL,
   [FAX_NUM] varchar(10)  NULL,
   [E_MAIL_ADDRESS] varchar(50)  NULL,
   [CROSS_STREET_DIRECTIONS] varchar(50)  NULL,
   [FIPS_COUNTY_PARISH_CODE] varchar(5)  NULL,
   [FIPS_MSA_CODE] varchar(4)  NULL,
   [FIPS_PMSA_CODE] varchar(4)  NULL,
   [OPEN_24_HOUR] varchar(1)  NULL,
   [PROVIDER_HOURS] varchar(35)  NULL,
   [ACCEPTS_ESCRIPTS] varchar(1)  NULL,
   [DELIVERY_SERVICE] varchar(1)  NULL,
   [COMPOUNDING_SERVICE] varchar(1)  NULL,
   [DRIVE_UP_WINDOW] varchar(1)  NULL,
   [SELLS_DME_EQUIPMENT] varchar(1)  NULL,
   [CONGRESSIONAL_VOTING_DIST] varchar(4)  NULL,
   [LANGUAGE_CODE_1] varchar(2)  NULL,
   [LANGUAGE_CODE_2] varchar(2)  NULL,
   [LANGUAGE_CODE_3] varchar(2)  NULL,
   [LANGUAGE_CODE_4] varchar(2)  NULL,
   [LANGUAGE_CODE_5] varchar(2)  NULL,
   [HANDICAP_ACCESSIBLE] varchar(1)  NULL,
   [STORE_OPEN_DATE] varchar(8)  NULL,
   [STORE_CLOSURE_DATE] varchar(8)  NULL,
   [MAILING_ADDRESS_1] varchar(55)  NULL,
   [MAILING_ADDRESS_2] varchar(55)  NULL,
   [MAILING_ADDRESS_CITY] varchar(30)  NULL,
   [MAILING_ADDRESS_STATE_CODE] varchar(2)  NULL,
   [MAILING_ADDRESS_ZIP_CODE] varchar(9)  NULL,
   [CONTACT_LAST_NAME] varchar(20)  NULL,
   [CONTACT_FIRST_NAME] varchar(20)  NULL,
   [CONTACT_MIDDLE_INITIAL] varchar(1)  NULL,
   [CONTACT_TITLE] varchar(30)  NULL,
   [CONTACT_PHONE_NUM] varchar(10)  NULL,
   [CONTACT_EXTENSION] varchar(5)  NULL,
   [CONTACT_E_MAIL_ADDRESS] varchar(50)  NULL,
   [DISPENSER_CLASS_CODE] varchar(2)  NULL,
   [PRIMARY_DISPENSER_TYPE_CODE] varchar(2)  NULL,
   [SECONDARY_DISPENSER_TYPE_CODE] varchar(2)  NULL,
   [TERTIARY_DISPENSER_TYPE_CODE] varchar(2)  NULL,
   [MEDICARE_ID] varchar(10)  NULL,
   [NPI_ID] varchar(10)  NULL,
   [DEA_REGISTRATION_ID] varchar(12)  NULL,
   [FEDERAL_TAX_ID] varchar(15)  NULL,
   [STATE_LICENSE_NUM] varchar(20)  NULL,
   [STATE_TAX_ID] varchar(15)  NULL,
   [DELETE_DATE] varchar(8)  NULL,
   [TRANSACTION_CODE] varchar(1)  NULL,
   [TRANSACTION_DATE] varchar(8)  NULL,
   [FILLER] varchar(108)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.NCPDP_PROVIDER_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'NCPDP_PROVIDER_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.LEGAL_BUS_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'LEGAL_BUS_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT."NAME"',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.STORE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'STORE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.ADDRESS_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'ADDRESS_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.ADDRESS_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'ADDRESS_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.CITY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.STATE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'STATE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.ZIP_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'ZIP_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.FAX_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'FAX_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.E_MAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'E_MAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.CROSS_STREET_DIRECTIONS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'CROSS_STREET_DIRECTIONS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.FIPS_COUNTY_PARISH_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'FIPS_COUNTY_PARISH_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.FIPS_MSA_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'FIPS_MSA_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.FIPS_PMSA_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'FIPS_PMSA_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.OPEN_24_HOUR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'OPEN_24_HOUR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.PROVIDER_HOURS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'PROVIDER_HOURS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.ACCEPTS_ESCRIPTS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'ACCEPTS_ESCRIPTS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.DELIVERY_SERVICE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'DELIVERY_SERVICE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.COMPOUNDING_SERVICE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'COMPOUNDING_SERVICE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.DRIVE_UP_WINDOW',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'DRIVE_UP_WINDOW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.SELLS_DME_EQUIPMENT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'SELLS_DME_EQUIPMENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.CONGRESSIONAL_VOTING_DIST',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'CONGRESSIONAL_VOTING_DIST'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.LANGUAGE_CODE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'LANGUAGE_CODE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.LANGUAGE_CODE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'LANGUAGE_CODE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.LANGUAGE_CODE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'LANGUAGE_CODE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.LANGUAGE_CODE_4',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'LANGUAGE_CODE_4'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.LANGUAGE_CODE_5',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'LANGUAGE_CODE_5'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.HANDICAP_ACCESSIBLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'HANDICAP_ACCESSIBLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.STORE_OPEN_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'STORE_OPEN_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.STORE_CLOSURE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'STORE_CLOSURE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.MAILING_ADDRESS_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'MAILING_ADDRESS_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.MAILING_ADDRESS_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'MAILING_ADDRESS_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.MAILING_ADDRESS_CITY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'MAILING_ADDRESS_CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.MAILING_ADDRESS_STATE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'MAILING_ADDRESS_STATE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.MAILING_ADDRESS_ZIP_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'MAILING_ADDRESS_ZIP_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.CONTACT_LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'CONTACT_LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.CONTACT_FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'CONTACT_FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.CONTACT_MIDDLE_INITIAL',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'CONTACT_MIDDLE_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.CONTACT_TITLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'CONTACT_TITLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.CONTACT_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'CONTACT_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.CONTACT_EXTENSION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'CONTACT_EXTENSION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.CONTACT_E_MAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'CONTACT_E_MAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.DISPENSER_CLASS_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'DISPENSER_CLASS_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.PRIMARY_DISPENSER_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'PRIMARY_DISPENSER_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.SECONDARY_DISPENSER_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'SECONDARY_DISPENSER_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.TERTIARY_DISPENSER_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'TERTIARY_DISPENSER_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.MEDICARE_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'MEDICARE_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.NPI_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'NPI_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.DEA_REGISTRATION_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'DEA_REGISTRATION_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.FEDERAL_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'FEDERAL_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.STATE_LICENSE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'STATE_LICENSE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.STATE_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'STATE_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.DELETE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'DELETE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.TRANSACTION_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'TRANSACTION_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.TRANSACTION_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'TRANSACTION_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARM_UPD_XT.FILLER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARM_UPD_XT',
        N'COLUMN', N'FILLER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PHARMACY'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PHARMACY'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PHARMACY]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PHARMACY]
(
   [ID] numeric(38, 0)  NOT NULL,
   [NCPDP_NUMBER] varchar(7)  NOT NULL,
   [ID_ADDRESS] numeric(38, 0)  NOT NULL,
   [PHARMACY_NAME] varchar(60)  NOT NULL,
   [NHIN_STORE_ID] numeric(10, 0)  NULL,
   [STORE_NUMBER] varchar(10)  NULL,
   [PHARMACY_DBA_NAME] varchar(60)  NULL,
   [DEA_ID] varchar(15)  NULL,
   [ID_MAILING_ADDRESS] numeric(38, 0)  NULL,
   [PHONE_NUMBER] numeric(10, 0)  NULL,
   [FAX_PHONE] numeric(10, 0)  NULL,
   [DATE_OPENED] datetime2(0)  NULL,
   [DATE_CLOSED] datetime2(0)  NULL,
   [DEACTIVATED] datetime2(0)  NULL,
   [ACCEPTS_ESCRIPTS] char(1)  NULL,
   [DELIVERY_SERVICE] char(1)  NULL,
   [COMPOUNDING_SERVICE] char(1)  NULL,
   [DRIVE_UP_WINDOW] char(1)  NULL,
   [SELLS_DME_EQUIPMENT] char(1)  NULL,
   [HANDICAP_ACCESSIBLE] char(1)  NULL,
   [OPEN_24_HOUR] char(1)  NULL,
   [STATE_TAX_ID] varchar(15)  NULL,
   [FEDERAL_TAX_ID] varchar(15)  NULL,
   [STATE_LICENSE_NUMBER] varchar(20)  NULL,
   [DISPENSER_CLASS_CODE] varchar(2)  NULL,
   [DISPENSER_TYPE_CODE_1] varchar(2)  NULL,
   [DISPENSER_TYPE_CODE_2] varchar(2)  NULL,
   [DISPENSER_TYPE_CODE_3] varchar(2)  NULL,
   [LANGUAGE_CODE_1] varchar(2)  NULL,
   [LANGUAGE_CODE_2] varchar(2)  NULL,
   [LANGUAGE_CODE_3] varchar(2)  NULL,
   [LANGUAGE_CODE_4] varchar(2)  NULL,
   [LANGUAGE_CODE_5] varchar(2)  NULL,
   [CONGRESSIONAL_VOTING_DISTRICT] varchar(4)  NULL,
   [FIPS_MSA_CODE] varchar(4)  NULL,
   [FIPS_PMSA_CODE] varchar(4)  NULL,
   [FIPS_COUNTY_CODE] varchar(5)  NULL,
   [CONTACT_FIRST_NAME] varchar(20)  NULL,
   [CONTACT_MIDDLE_INITIAL] varchar(1)  NULL,
   [CONTACT_LAST_NAME] varchar(20)  NULL,
   [CONTACT_TITLE] varchar(30)  NULL,
   [CONTACT_PHONE_NUMBER] varchar(10)  NULL,
   [CONTACT_PHONE_EXT] varchar(5)  NULL,
   [UPIN] varchar(10)  NULL,
   [NPI] varchar(15)  NULL,
   [PHARMACY_HOURS] varchar(35)  NULL,
   [CROSS_STREET_DIRECTIONS] varchar(50)  NULL,
   [EMAIL_ADDRESS] varchar(50)  NULL,
   [CONTACT_EMAIL_ADDRESS] varchar(50)  NULL,
   [VENDOR_ID] varchar(60)  NULL,
   [FAXABLE] varchar(1)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.NCPDP_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'NCPDP_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.ID_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'ID_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.PHARMACY_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'PHARMACY_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.NHIN_STORE_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'NHIN_STORE_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.STORE_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'STORE_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.PHARMACY_DBA_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'PHARMACY_DBA_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.DEA_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'DEA_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.ID_MAILING_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'ID_MAILING_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.PHONE_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'PHONE_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.FAX_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'FAX_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.DATE_OPENED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'DATE_OPENED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.DATE_CLOSED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'DATE_CLOSED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.DEACTIVATED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'DEACTIVATED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.ACCEPTS_ESCRIPTS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'ACCEPTS_ESCRIPTS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.DELIVERY_SERVICE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'DELIVERY_SERVICE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.COMPOUNDING_SERVICE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'COMPOUNDING_SERVICE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.DRIVE_UP_WINDOW',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'DRIVE_UP_WINDOW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.SELLS_DME_EQUIPMENT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'SELLS_DME_EQUIPMENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.HANDICAP_ACCESSIBLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'HANDICAP_ACCESSIBLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.OPEN_24_HOUR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'OPEN_24_HOUR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.STATE_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'STATE_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.FEDERAL_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'FEDERAL_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.STATE_LICENSE_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'STATE_LICENSE_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.DISPENSER_CLASS_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'DISPENSER_CLASS_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.DISPENSER_TYPE_CODE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'DISPENSER_TYPE_CODE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.DISPENSER_TYPE_CODE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'DISPENSER_TYPE_CODE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.DISPENSER_TYPE_CODE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'DISPENSER_TYPE_CODE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.LANGUAGE_CODE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'LANGUAGE_CODE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.LANGUAGE_CODE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'LANGUAGE_CODE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.LANGUAGE_CODE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'LANGUAGE_CODE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.LANGUAGE_CODE_4',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'LANGUAGE_CODE_4'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.LANGUAGE_CODE_5',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'LANGUAGE_CODE_5'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.CONGRESSIONAL_VOTING_DISTRICT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'CONGRESSIONAL_VOTING_DISTRICT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.FIPS_MSA_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'FIPS_MSA_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.FIPS_PMSA_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'FIPS_PMSA_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.FIPS_COUNTY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'FIPS_COUNTY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.CONTACT_FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'CONTACT_FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.CONTACT_MIDDLE_INITIAL',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'CONTACT_MIDDLE_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.CONTACT_LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'CONTACT_LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.CONTACT_TITLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'CONTACT_TITLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.CONTACT_PHONE_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'CONTACT_PHONE_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.CONTACT_PHONE_EXT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'CONTACT_PHONE_EXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.UPIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'UPIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.NPI',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'NPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.PHARMACY_HOURS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'PHARMACY_HOURS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.CROSS_STREET_DIRECTIONS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'CROSS_STREET_DIRECTIONS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.CONTACT_EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'CONTACT_EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.VENDOR_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'VENDOR_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.FAXABLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'COLUMN', N'FAXABLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PHARMACY_MEDICAID_IDS'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PHARMACY_MEDICAID_IDS'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PHARMACY_MEDICAID_IDS]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PHARMACY_MEDICAID_IDS]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_PHARMACY] numeric(38, 0)  NOT NULL,
   [STATE_CODE] varchar(2)  NOT NULL,
   [MEDICAID_ID] varchar(20)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_MEDICAID_IDS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_MEDICAID_IDS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_MEDICAID_IDS.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_MEDICAID_IDS',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_MEDICAID_IDS.ID_PHARMACY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_MEDICAID_IDS',
        N'COLUMN', N'ID_PHARMACY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_MEDICAID_IDS.STATE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_MEDICAID_IDS',
        N'COLUMN', N'STATE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_MEDICAID_IDS.MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_MEDICAID_IDS',
        N'COLUMN', N'MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PHARMACY_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PHARMACY_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PHARMACY_UPD_ERR]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PHARMACY_UPD_ERR]
(
   [ID] numeric(38, 0)  NULL,
   [NCPDP_NUMBER] varchar(7)  NULL,
   [ID_ADDRESS] numeric(38, 0)  NULL,
   [PHARMACY_NAME] varchar(35)  NULL,
   [NHIN_STORE_ID] numeric(10, 0)  NULL,
   [STORE_NUMBER] varchar(10)  NULL,
   [PHARMACY_DBA_NAME] varchar(35)  NULL,
   [DEA_ID] varchar(15)  NULL,
   [ID_MAILING_ADDRESS] numeric(38, 0)  NULL,
   [PHONE_NUMBER] numeric(10, 0)  NULL,
   [FAX_PHONE] numeric(10, 0)  NULL,
   [DATE_OPENED] datetime2(0)  NULL,
   [DATE_CLOSED] datetime2(0)  NULL,
   [DEACTIVATED] datetime2(0)  NULL,
   [ACCEPTS_ESCRIPTS] char(1)  NULL,
   [DELIVERY_SERVICE] char(1)  NULL,
   [COMPOUNDING_SERVICE] char(1)  NULL,
   [DRIVE_UP_WINDOW] char(1)  NULL,
   [SELLS_DME_EQUIPMENT] char(1)  NULL,
   [HANDICAP_ACCESSIBLE] char(1)  NULL,
   [OPEN_24_HOUR] char(1)  NULL,
   [STATE_TAX_ID] varchar(15)  NULL,
   [FEDERAL_TAX_ID] varchar(15)  NULL,
   [STATE_LICENSE_NUMBER] varchar(20)  NULL,
   [DISPENSER_CLASS_CODE] varchar(2)  NULL,
   [DISPENSER_TYPE_CODE_1] varchar(2)  NULL,
   [DISPENSER_TYPE_CODE_2] varchar(2)  NULL,
   [DISPENSER_TYPE_CODE_3] varchar(2)  NULL,
   [LANGUAGE_CODE_1] varchar(2)  NULL,
   [LANGUAGE_CODE_2] varchar(2)  NULL,
   [LANGUAGE_CODE_3] varchar(2)  NULL,
   [LANGUAGE_CODE_4] varchar(2)  NULL,
   [LANGUAGE_CODE_5] varchar(2)  NULL,
   [CONGRESSIONAL_VOTING_DISTRICT] varchar(4)  NULL,
   [FIPS_MSA_CODE] varchar(4)  NULL,
   [FIPS_PMSA_CODE] varchar(4)  NULL,
   [FIPS_COUNTY_CODE] varchar(5)  NULL,
   [CONTACT_FIRST_NAME] varchar(20)  NULL,
   [CONTACT_MIDDLE_INITIAL] varchar(1)  NULL,
   [CONTACT_LAST_NAME] varchar(20)  NULL,
   [CONTACT_TITLE] varchar(30)  NULL,
   [CONTACT_PHONE_NUMBER] varchar(10)  NULL,
   [CONTACT_PHONE_EXT] varchar(5)  NULL,
   [UPIN] varchar(10)  NULL,
   [NPI] varchar(15)  NULL,
   [PHARMACY_HOURS] varchar(35)  NULL,
   [CROSS_STREET_DIRECTIONS] varchar(50)  NULL,
   [EMAIL_ADDRESS] varchar(50)  NULL,
   [CONTACT_EMAIL_ADDRESS] varchar(50)  NULL,
   [VENDOR_ID] varchar(60)  NULL,
   [FAXABLE] varchar(1)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.NCPDP_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'NCPDP_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.ID_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'ID_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.PHARMACY_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'PHARMACY_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.NHIN_STORE_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'NHIN_STORE_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.STORE_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'STORE_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.PHARMACY_DBA_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'PHARMACY_DBA_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.DEA_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'DEA_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.ID_MAILING_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'ID_MAILING_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.PHONE_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'PHONE_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.FAX_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'FAX_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.DATE_OPENED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'DATE_OPENED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.DATE_CLOSED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'DATE_CLOSED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.DEACTIVATED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'DEACTIVATED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.ACCEPTS_ESCRIPTS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'ACCEPTS_ESCRIPTS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.DELIVERY_SERVICE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'DELIVERY_SERVICE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.COMPOUNDING_SERVICE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'COMPOUNDING_SERVICE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.DRIVE_UP_WINDOW',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'DRIVE_UP_WINDOW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.SELLS_DME_EQUIPMENT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'SELLS_DME_EQUIPMENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.HANDICAP_ACCESSIBLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'HANDICAP_ACCESSIBLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.OPEN_24_HOUR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'OPEN_24_HOUR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.STATE_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'STATE_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.FEDERAL_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'FEDERAL_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.STATE_LICENSE_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'STATE_LICENSE_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.DISPENSER_CLASS_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'DISPENSER_CLASS_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.DISPENSER_TYPE_CODE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'DISPENSER_TYPE_CODE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.DISPENSER_TYPE_CODE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'DISPENSER_TYPE_CODE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.DISPENSER_TYPE_CODE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'DISPENSER_TYPE_CODE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.LANGUAGE_CODE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'LANGUAGE_CODE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.LANGUAGE_CODE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'LANGUAGE_CODE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.LANGUAGE_CODE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'LANGUAGE_CODE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.LANGUAGE_CODE_4',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'LANGUAGE_CODE_4'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.LANGUAGE_CODE_5',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'LANGUAGE_CODE_5'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.CONGRESSIONAL_VOTING_DISTRICT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'CONGRESSIONAL_VOTING_DISTRICT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.FIPS_MSA_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'FIPS_MSA_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.FIPS_PMSA_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'FIPS_PMSA_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.FIPS_COUNTY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'FIPS_COUNTY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.CONTACT_FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'CONTACT_FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.CONTACT_MIDDLE_INITIAL',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'CONTACT_MIDDLE_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.CONTACT_LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'CONTACT_LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.CONTACT_TITLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'CONTACT_TITLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.CONTACT_PHONE_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'CONTACT_PHONE_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.CONTACT_PHONE_EXT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'CONTACT_PHONE_EXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.UPIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'UPIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.NPI',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'NPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.PHARMACY_HOURS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'PHARMACY_HOURS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.CROSS_STREET_DIRECTIONS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'CROSS_STREET_DIRECTIONS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.CONTACT_EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'CONTACT_EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.VENDOR_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'VENDOR_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_UPD_ERR.FAXABLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_UPD_ERR',
        N'COLUMN', N'FAXABLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCR_UPD_XT'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PRESCR_UPD_XT'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PRESCR_UPD_XT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PRESCR_UPD_XT]
(
   [COMM_GROUP_ID] varchar(10)  NULL,
   [DEA_REGISTRATION_NUM] varchar(13)  NULL,
   [DEA_NUM_RENEWAL_DATE] numeric(8, 0)  NULL,
   [LAST_NAME] varchar(25)  NULL,
   [PREVIOUS_LAST_NAME] varchar(40)  NULL,
   [FIRST_NAME] varchar(25)  NULL,
   [MIDDLE_NAME_INITIAL] varchar(1)  NULL,
   [NAME_SUFFIX] varchar(3)  NULL,
   [GENDER_CODE] varchar(1)  NULL,
   [ORGANIZATION_NAME] varchar(60)  NULL,
   [DEPARTMENT_MAIL_STOP] varchar(40)  NULL,
   [PHYS_ADDRESS_LINE_1] varchar(30)  NULL,
   [PHYS_ADDRESS_LINE_2] varchar(30)  NULL,
   [PHYS_SUITE_APARTMENT_NUM] varchar(8)  NULL,
   [PHYS_CITY_NAME] varchar(20)  NULL,
   [PHYS_STATE_PROVINCE_CODE] varchar(2)  NULL,
   [PHYS_ZIP_POSTAL_ZONE] varchar(9)  NULL,
   [PHYS_COUNTRY_CODE] varchar(3)  NULL,
   [PRIME_PHONE_NUM] numeric(10, 0)  NULL,
   [SECOND_PHONE_NUM] numeric(10, 0)  NULL,
   [REFILL_PHONE_NUM] numeric(10, 0)  NULL,
   [FAX_NUM] numeric(10, 0)  NULL,
   [EMAIL_IGNORED] varchar(25)  NULL,
   [PRIME_DEGREE] varchar(5)  NULL,
   [PRIME_TAXONOMY_CODE] varchar(10)  NULL,
   [SECOND_DEGREE] varchar(5)  NULL,
   [SECOND_TAXONOMY_CODE] varchar(10)  NULL,
   [STATE_CODE_PRIME_MEDICAID_ID] varchar(2)  NULL,
   [PRIME_MEDICAID_ID] varchar(15)  NULL,
   [STATE_CODE_SECOND_MEDICAID_ID] varchar(2)  NULL,
   [SECOND_MEDICAID_ID] varchar(15)  NULL,
   [STATE_CODE_THIRD_MEDICAID_ID] varchar(2)  NULL,
   [THIRD_MEDICAID_ID] varchar(15)  NULL,
   [UPIN_NUM] varchar(6)  NULL,
   [HIN_NUM] varchar(15)  NULL,
   [HCID_LOCATION_CODE] numeric(2, 0)  NULL,
   [DEA_STATUS_CODE] varchar(1)  NULL,
   [RETIRE_DATE] numeric(8, 0)  NULL,
   [DATA_SUPPLIER_REF_KEY_1] varchar(20)  NULL,
   [DATA_SUPPLIER_REF_KEY_2] varchar(20)  NULL,
   [DATA_SUPPLIER_REF_KEY_3] varchar(20)  NULL,
   [DATA_SUPPLIER_SITE_NUM] varchar(15)  NULL,
   [NPI] varchar(30)  NULL,
   [HCID_IDENTIFIER] varchar(30)  NULL,
   [NHIN_PROVIDER_ID] varchar(30)  NULL,
   [PHYS_LOCATION_TYPE_CODE] varchar(2)  NULL,
   [DUPE_DEA_FLAG] char(1)  NULL,
   [DUPE_DATA_SUPPLIER_REF_KEY_1] varchar(20)  NULL,
   [COMM_SUB_GROUP_ID] varchar(10)  NULL,
   [UPDATE_RECORD_TYPE_CODE] varchar(1)  NULL,
   [DATE_LAST_CHANGE] numeric(8, 0)  NULL,
   [DEA_REGISTRATION_NUM_SUFFIX] varchar(7)  NULL,
   [DEA_DRUG_SCHEDULE] varchar(12)  NULL,
   [NCPDP_PROVIDER_ID_NUM] varchar(15)  NULL,
   [DUPE_DATA_SUPPLIER_REF_KEY_2] varchar(20)  NULL,
   [DUPE_DATA_SUPPLIER_REF_KEY_3] varchar(20)  NULL,
   [ORIGIN] varchar(1)  NULL,
   [RESERVE_1] varchar(1)  NULL,
   [PREVIOUS_HCID] varchar(15)  NULL,
   [REPLACEMENT_HCID] varchar(15)  NULL,
   [HCID_DC_DATE] numeric(8, 0)  NULL,
   [NHIN_DECEASED_FLAG] varchar(1)  NULL,
   [NHIN_DECEASED_DATE] numeric(8, 0)  NULL,
   [REPLACEMENT_DEA_NUM] varchar(13)  NULL,
   [PREVIOUS_DEA_NUM] varchar(13)  NULL,
   [DATA_ELEMENT_CHANGE_TYPE] varchar(3)  NULL,
   [EMAIL_ADDRESS] varchar(60)  NULL,
   [FILLER_1] varchar(60)  NULL,
   [PDX_RESERVE] varchar(9)  NULL,
   [RESERVED] varchar(4)  NULL,
   [STATE_LICENSE_1] varchar(20)  NULL,
   [LICENSING_STATE_1] varchar(2)  NULL,
   [STATE_LICENSE_2] varchar(20)  NULL,
   [LICENSING_STATE_2] varchar(2)  NULL,
   [STATE_LICENSE_3] varchar(20)  NULL,
   [LICENSING_STATE_3] varchar(2)  NULL,
   [NHIN_USE] varchar(4)  NULL,
   [FILLER] varchar(19)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.COMM_GROUP_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'COMM_GROUP_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DEA_REGISTRATION_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DEA_REGISTRATION_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DEA_NUM_RENEWAL_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DEA_NUM_RENEWAL_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PREVIOUS_LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PREVIOUS_LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.MIDDLE_NAME_INITIAL',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'MIDDLE_NAME_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.NAME_SUFFIX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'NAME_SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.GENDER_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'GENDER_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.ORGANIZATION_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'ORGANIZATION_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DEPARTMENT_MAIL_STOP',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DEPARTMENT_MAIL_STOP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PHYS_ADDRESS_LINE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PHYS_ADDRESS_LINE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PHYS_ADDRESS_LINE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PHYS_ADDRESS_LINE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PHYS_SUITE_APARTMENT_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PHYS_SUITE_APARTMENT_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PHYS_CITY_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PHYS_CITY_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PHYS_STATE_PROVINCE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PHYS_STATE_PROVINCE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PHYS_ZIP_POSTAL_ZONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PHYS_ZIP_POSTAL_ZONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PHYS_COUNTRY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PHYS_COUNTRY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PRIME_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PRIME_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.SECOND_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'SECOND_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.REFILL_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'REFILL_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.FAX_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'FAX_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.EMAIL_IGNORED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'EMAIL_IGNORED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PRIME_DEGREE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PRIME_DEGREE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PRIME_TAXONOMY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PRIME_TAXONOMY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.SECOND_DEGREE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'SECOND_DEGREE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.SECOND_TAXONOMY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'SECOND_TAXONOMY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.STATE_CODE_PRIME_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'STATE_CODE_PRIME_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PRIME_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PRIME_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.STATE_CODE_SECOND_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'STATE_CODE_SECOND_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.SECOND_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'SECOND_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.STATE_CODE_THIRD_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'STATE_CODE_THIRD_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.THIRD_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'THIRD_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.UPIN_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'UPIN_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.HIN_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'HIN_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.HCID_LOCATION_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'HCID_LOCATION_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DEA_STATUS_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DEA_STATUS_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.RETIRE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'RETIRE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DATA_SUPPLIER_REF_KEY_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DATA_SUPPLIER_REF_KEY_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DATA_SUPPLIER_REF_KEY_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DATA_SUPPLIER_REF_KEY_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DATA_SUPPLIER_REF_KEY_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DATA_SUPPLIER_REF_KEY_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DATA_SUPPLIER_SITE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DATA_SUPPLIER_SITE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.NPI',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'NPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.HCID_IDENTIFIER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'HCID_IDENTIFIER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.NHIN_PROVIDER_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'NHIN_PROVIDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PHYS_LOCATION_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PHYS_LOCATION_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DUPE_DEA_FLAG',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DUPE_DEA_FLAG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DUPE_DATA_SUPPLIER_REF_KEY_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DUPE_DATA_SUPPLIER_REF_KEY_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.COMM_SUB_GROUP_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'COMM_SUB_GROUP_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.UPDATE_RECORD_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'UPDATE_RECORD_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DATE_LAST_CHANGE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DATE_LAST_CHANGE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DEA_REGISTRATION_NUM_SUFFIX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DEA_REGISTRATION_NUM_SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DEA_DRUG_SCHEDULE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DEA_DRUG_SCHEDULE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.NCPDP_PROVIDER_ID_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'NCPDP_PROVIDER_ID_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DUPE_DATA_SUPPLIER_REF_KEY_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DUPE_DATA_SUPPLIER_REF_KEY_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DUPE_DATA_SUPPLIER_REF_KEY_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DUPE_DATA_SUPPLIER_REF_KEY_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.ORIGIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'ORIGIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.RESERVE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'RESERVE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PREVIOUS_HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PREVIOUS_HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.REPLACEMENT_HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'REPLACEMENT_HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.HCID_DC_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'HCID_DC_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.NHIN_DECEASED_FLAG',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'NHIN_DECEASED_FLAG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.NHIN_DECEASED_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'NHIN_DECEASED_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.REPLACEMENT_DEA_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'REPLACEMENT_DEA_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PREVIOUS_DEA_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PREVIOUS_DEA_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.DATA_ELEMENT_CHANGE_TYPE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'DATA_ELEMENT_CHANGE_TYPE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.FILLER_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'FILLER_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.PDX_RESERVE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'PDX_RESERVE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.RESERVED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'RESERVED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.STATE_LICENSE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'STATE_LICENSE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.LICENSING_STATE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'LICENSING_STATE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.STATE_LICENSE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'STATE_LICENSE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.LICENSING_STATE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'LICENSING_STATE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.STATE_LICENSE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'STATE_LICENSE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.LICENSING_STATE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'LICENSING_STATE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.NHIN_USE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'NHIN_USE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT.FILLER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT',
        N'COLUMN', N'FILLER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCR_UPD_XT_ORIG'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PRESCR_UPD_XT_ORIG'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PRESCR_UPD_XT_ORIG]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PRESCR_UPD_XT_ORIG]
(
   [COMM_GROUP_ID] varchar(10)  NULL,
   [DEA_REGISTRATION_NUM] varchar(13)  NULL,
   [DEA_NUM_RENEWAL_DATE] numeric(8, 0)  NULL,
   [LAST_NAME] varchar(25)  NULL,
   [PREVIOUS_LAST_NAME] varchar(40)  NULL,
   [FIRST_NAME] varchar(25)  NULL,
   [MIDDLE_NAME_INITIAL] varchar(1)  NULL,
   [NAME_SUFFIX] varchar(3)  NULL,
   [GENDER_CODE] varchar(1)  NULL,
   [ORGANIZATION_NAME] varchar(60)  NULL,
   [DEPARTMENT_MAIL_STOP] varchar(40)  NULL,
   [PHYS_ADDRESS_LINE_1] varchar(30)  NULL,
   [PHYS_ADDRESS_LINE_2] varchar(30)  NULL,
   [PHYS_SUITE_APARTMENT_NUM] varchar(8)  NULL,
   [PHYS_CITY_NAME] varchar(20)  NULL,
   [PHYS_STATE_PROVINCE_CODE] varchar(2)  NULL,
   [PHYS_ZIP_POSTAL_ZONE] varchar(9)  NULL,
   [PHYS_COUNTRY_CODE] varchar(3)  NULL,
   [PRIME_PHONE_NUM] numeric(10, 0)  NULL,
   [SECOND_PHONE_NUM] numeric(10, 0)  NULL,
   [REFILL_PHONE_NUM] numeric(10, 0)  NULL,
   [FAX_NUM] numeric(10, 0)  NULL,
   [EMAIL_ADDRESS] varchar(25)  NULL,
   [PRIME_DEGREE] varchar(5)  NULL,
   [PRIME_TAXONOMY_CODE] varchar(10)  NULL,
   [SECOND_DEGREE] varchar(5)  NULL,
   [SECOND_TAXONOMY_CODE] varchar(10)  NULL,
   [STATE_CODE_PRIME_MEDICAID_ID] varchar(2)  NULL,
   [PRIME_MEDICAID_ID] varchar(15)  NULL,
   [STATE_CODE_SECOND_MEDICAID_ID] varchar(2)  NULL,
   [SECOND_MEDICAID_ID] varchar(15)  NULL,
   [STATE_CODE_THIRD_MEDICAID_ID] varchar(2)  NULL,
   [THIRD_MEDICAID_ID] varchar(15)  NULL,
   [UPIN_NUM] varchar(6)  NULL,
   [HIN_NUM] varchar(15)  NULL,
   [HCID_LOCATION_CODE] numeric(2, 0)  NULL,
   [DEA_STATUS_CODE] varchar(1)  NULL,
   [RETIRE_DATE] numeric(8, 0)  NULL,
   [DATA_SUPPLIER_REF_KEY_1] varchar(20)  NULL,
   [DATA_SUPPLIER_REF_KEY_2] varchar(20)  NULL,
   [DATA_SUPPLIER_REF_KEY_3] varchar(20)  NULL,
   [DATA_SUPPLIER_SITE_NUM] varchar(15)  NULL,
   [NPI] varchar(30)  NULL,
   [HCID_IDENTIFIER] varchar(30)  NULL,
   [NHIN_PROVIDER_ID] varchar(30)  NULL,
   [PHYS_LOCATION_TYPE_CODE] varchar(2)  NULL,
   [DUPE_DEA_FLAG] char(1)  NULL,
   [DUPE_DATA_SUPPLIER_REF_KEY_1] varchar(20)  NULL,
   [COMM_SUB_GROUP_ID] varchar(10)  NULL,
   [UPDATE_RECORD_TYPE_CODE] varchar(1)  NULL,
   [DATE_LAST_CHANGE] numeric(8, 0)  NULL,
   [DEA_REGISTRATION_NUM_SUFFIX] varchar(7)  NULL,
   [DEA_DRUG_SCHEDULE] varchar(12)  NULL,
   [NCPDP_PROVIDER_ID_NUM] varchar(15)  NULL,
   [DUPE_DATA_SUPPLIER_REF_KEY_2] varchar(20)  NULL,
   [DUPE_DATA_SUPPLIER_REF_KEY_3] varchar(20)  NULL,
   [ORIGIN] varchar(1)  NULL,
   [RESERVE_1] varchar(1)  NULL,
   [PREVIOUS_HCID] varchar(15)  NULL,
   [REPLACEMENT_HCID] varchar(15)  NULL,
   [HCID_DC_DATE] numeric(8, 0)  NULL,
   [NHIN_DECEASED_FLAG] varchar(1)  NULL,
   [NHIN_DECEASED_DATE] numeric(8, 0)  NULL,
   [REPLACEMENT_DEA_NUM] varchar(13)  NULL,
   [PREVIOUS_DEA_NUM] varchar(13)  NULL,
   [DATA_ELEMENT_CHANGE_TYPE] varchar(3)  NULL,
   [RESERVED] varchar(4)  NULL,
   [STATE_LICENSE_1] varchar(20)  NULL,
   [LICENSING_STATE_1] varchar(3)  NULL,
   [STATE_LICENSE_2] varchar(20)  NULL,
   [LICENSING_STATE_2] varchar(3)  NULL,
   [STATE_LICENSE_3] varchar(20)  NULL,
   [LICENSING_STATE_3] varchar(3)  NULL,
   [FILLER] varchar(149)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.COMM_GROUP_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'COMM_GROUP_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DEA_REGISTRATION_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DEA_REGISTRATION_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DEA_NUM_RENEWAL_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DEA_NUM_RENEWAL_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.PREVIOUS_LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'PREVIOUS_LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.MIDDLE_NAME_INITIAL',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'MIDDLE_NAME_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.NAME_SUFFIX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'NAME_SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.GENDER_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'GENDER_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.ORGANIZATION_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'ORGANIZATION_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DEPARTMENT_MAIL_STOP',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DEPARTMENT_MAIL_STOP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.PHYS_ADDRESS_LINE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'PHYS_ADDRESS_LINE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.PHYS_ADDRESS_LINE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'PHYS_ADDRESS_LINE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.PHYS_SUITE_APARTMENT_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'PHYS_SUITE_APARTMENT_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.PHYS_CITY_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'PHYS_CITY_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.PHYS_STATE_PROVINCE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'PHYS_STATE_PROVINCE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.PHYS_ZIP_POSTAL_ZONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'PHYS_ZIP_POSTAL_ZONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.PHYS_COUNTRY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'PHYS_COUNTRY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.PRIME_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'PRIME_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.SECOND_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'SECOND_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.REFILL_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'REFILL_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.FAX_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'FAX_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.PRIME_DEGREE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'PRIME_DEGREE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.PRIME_TAXONOMY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'PRIME_TAXONOMY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.SECOND_DEGREE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'SECOND_DEGREE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.SECOND_TAXONOMY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'SECOND_TAXONOMY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.STATE_CODE_PRIME_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'STATE_CODE_PRIME_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.PRIME_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'PRIME_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.STATE_CODE_SECOND_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'STATE_CODE_SECOND_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.SECOND_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'SECOND_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.STATE_CODE_THIRD_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'STATE_CODE_THIRD_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.THIRD_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'THIRD_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.UPIN_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'UPIN_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.HIN_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'HIN_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.HCID_LOCATION_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'HCID_LOCATION_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DEA_STATUS_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DEA_STATUS_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.RETIRE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'RETIRE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DATA_SUPPLIER_REF_KEY_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DATA_SUPPLIER_REF_KEY_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DATA_SUPPLIER_REF_KEY_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DATA_SUPPLIER_REF_KEY_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DATA_SUPPLIER_REF_KEY_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DATA_SUPPLIER_REF_KEY_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DATA_SUPPLIER_SITE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DATA_SUPPLIER_SITE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.NPI',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'NPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.HCID_IDENTIFIER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'HCID_IDENTIFIER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.NHIN_PROVIDER_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'NHIN_PROVIDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.PHYS_LOCATION_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'PHYS_LOCATION_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DUPE_DEA_FLAG',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DUPE_DEA_FLAG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DUPE_DATA_SUPPLIER_REF_KEY_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DUPE_DATA_SUPPLIER_REF_KEY_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.COMM_SUB_GROUP_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'COMM_SUB_GROUP_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.UPDATE_RECORD_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'UPDATE_RECORD_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DATE_LAST_CHANGE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DATE_LAST_CHANGE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DEA_REGISTRATION_NUM_SUFFIX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DEA_REGISTRATION_NUM_SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DEA_DRUG_SCHEDULE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DEA_DRUG_SCHEDULE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.NCPDP_PROVIDER_ID_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'NCPDP_PROVIDER_ID_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DUPE_DATA_SUPPLIER_REF_KEY_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DUPE_DATA_SUPPLIER_REF_KEY_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DUPE_DATA_SUPPLIER_REF_KEY_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DUPE_DATA_SUPPLIER_REF_KEY_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.ORIGIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'ORIGIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.RESERVE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'RESERVE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.PREVIOUS_HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'PREVIOUS_HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.REPLACEMENT_HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'REPLACEMENT_HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.HCID_DC_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'HCID_DC_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.NHIN_DECEASED_FLAG',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'NHIN_DECEASED_FLAG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.NHIN_DECEASED_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'NHIN_DECEASED_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.REPLACEMENT_DEA_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'REPLACEMENT_DEA_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.PREVIOUS_DEA_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'PREVIOUS_DEA_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.DATA_ELEMENT_CHANGE_TYPE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'DATA_ELEMENT_CHANGE_TYPE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.RESERVED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'RESERVED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.STATE_LICENSE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'STATE_LICENSE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.LICENSING_STATE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'LICENSING_STATE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.STATE_LICENSE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'STATE_LICENSE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.LICENSING_STATE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'LICENSING_STATE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.STATE_LICENSE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'STATE_LICENSE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.LICENSING_STATE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'LICENSING_STATE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCR_UPD_XT_ORIG.FILLER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCR_UPD_XT_ORIG',
        N'COLUMN', N'FILLER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCRIBER_DRUG_USAGE'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PRESCRIBER_DRUG_USAGE'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PRESCRIBER_DRUG_USAGE]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PRESCRIBER_DRUG_USAGE]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_NHIN_PRESCRIBER] numeric(38, 0)  NOT NULL,
   [DDID] numeric(38, 0)  NOT NULL,
   [DATE_USED] datetime2(0)  NULL,
   [DRUG_NAME] varchar(70)  NOT NULL,
   [STRENGTH] varchar(15)  NULL,
   [STRENGTH_UNIT] varchar(10)  NULL,
   [DOSING_UNIT] varchar(20)  NULL,
   [SIG_VERB] varchar(60)  NULL,
   [SIG_UNIT] varchar(60)  NULL,
   [SIG_UNITS] varchar(60)  NULL,
   [SIG_ROUTE] varchar(60)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE.ID_NHIN_PRESCRIBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE',
        N'COLUMN', N'ID_NHIN_PRESCRIBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE.DDID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE',
        N'COLUMN', N'DDID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE.DATE_USED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE',
        N'COLUMN', N'DATE_USED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE.DRUG_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE',
        N'COLUMN', N'DRUG_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE.STRENGTH',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE',
        N'COLUMN', N'STRENGTH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE.STRENGTH_UNIT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE',
        N'COLUMN', N'STRENGTH_UNIT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE.DOSING_UNIT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE',
        N'COLUMN', N'DOSING_UNIT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE.SIG_VERB',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE',
        N'COLUMN', N'SIG_VERB'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE.SIG_UNIT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE',
        N'COLUMN', N'SIG_UNIT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE.SIG_UNITS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE',
        N'COLUMN', N'SIG_UNITS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE.SIG_ROUTE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE',
        N'COLUMN', N'SIG_ROUTE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCRIBER_MEDICAID'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PRESCRIBER_MEDICAID'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PRESCRIBER_MEDICAID]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PRESCRIBER_MEDICAID]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_NHIN_PRESCRIBER] numeric(38, 0)  NOT NULL,
   [STATE] varchar(2)  NOT NULL,
   [MEDICAID_ID] varchar(15)  NOT NULL,
   [DEACTIVATE_DATE] datetime2(0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_MEDICAID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_MEDICAID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_MEDICAID.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_MEDICAID',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_MEDICAID.ID_NHIN_PRESCRIBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_MEDICAID',
        N'COLUMN', N'ID_NHIN_PRESCRIBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_MEDICAID.STATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_MEDICAID',
        N'COLUMN', N'STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_MEDICAID.MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_MEDICAID',
        N'COLUMN', N'MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_MEDICAID.DEACTIVATE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_MEDICAID',
        N'COLUMN', N'DEACTIVATE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCRIBER_MEDICAID_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PRESCRIBER_MEDICAID_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PRESCRIBER_MEDICAID_UPD_ERR]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PRESCRIBER_MEDICAID_UPD_ERR]
(
   [ID] numeric(38, 0)  NULL,
   [ID_NHIN_PRESCRIBER] numeric(38, 0)  NULL,
   [STATE] varchar(2)  NULL,
   [MEDICAID_ID] varchar(15)  NULL,
   [DEACTIVATE_DATE] datetime2(0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_MEDICAID_UPD_ERR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_MEDICAID_UPD_ERR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_MEDICAID_UPD_ERR.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_MEDICAID_UPD_ERR',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_MEDICAID_UPD_ERR.ID_NHIN_PRESCRIBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_MEDICAID_UPD_ERR',
        N'COLUMN', N'ID_NHIN_PRESCRIBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_MEDICAID_UPD_ERR.STATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_MEDICAID_UPD_ERR',
        N'COLUMN', N'STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_MEDICAID_UPD_ERR.MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_MEDICAID_UPD_ERR',
        N'COLUMN', N'MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_MEDICAID_UPD_ERR.DEACTIVATE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_MEDICAID_UPD_ERR',
        N'COLUMN', N'DEACTIVATE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCRIBER_PHARMACY_USAGE'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PRESCRIBER_PHARMACY_USAGE'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PRESCRIBER_PHARMACY_USAGE]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PRESCRIBER_PHARMACY_USAGE]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_NHIN_PRESCRIBER] numeric(38, 0)  NOT NULL,
   [ID_PHARMACY] numeric(38, 0)  NOT NULL,
   [DATE_USED] datetime2(0)  NULL,
   [PHARMACY_NAME] varchar(150)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PHARMACY_USAGE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PHARMACY_USAGE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PHARMACY_USAGE.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PHARMACY_USAGE',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PHARMACY_USAGE.ID_NHIN_PRESCRIBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PHARMACY_USAGE',
        N'COLUMN', N'ID_NHIN_PRESCRIBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PHARMACY_USAGE.ID_PHARMACY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PHARMACY_USAGE',
        N'COLUMN', N'ID_PHARMACY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PHARMACY_USAGE.DATE_USED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PHARMACY_USAGE',
        N'COLUMN', N'DATE_USED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PHARMACY_USAGE.PHARMACY_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PHARMACY_USAGE',
        N'COLUMN', N'PHARMACY_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCRIBER_PIN_MAILING'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PRESCRIBER_PIN_MAILING'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PRESCRIBER_PIN_MAILING]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PRESCRIBER_PIN_MAILING]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_NHIN_PRESCRIBER] numeric(38, 0)  NOT NULL,
   [LAST_DATE_PRINTED] datetime2(0)  NULL,
   [NUMBER_OF_PRINTS] numeric(2, 0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PIN_MAILING',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PIN_MAILING'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PIN_MAILING.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PIN_MAILING',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PIN_MAILING.ID_NHIN_PRESCRIBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PIN_MAILING',
        N'COLUMN', N'ID_NHIN_PRESCRIBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PIN_MAILING.LAST_DATE_PRINTED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PIN_MAILING',
        N'COLUMN', N'LAST_DATE_PRINTED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PIN_MAILING.NUMBER_OF_PRINTS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PIN_MAILING',
        N'COLUMN', N'NUMBER_OF_PRINTS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCRIBER_STATE'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PRESCRIBER_STATE'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PRESCRIBER_STATE]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PRESCRIBER_STATE]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_NHIN_PRESCRIBER] numeric(38, 0)  NOT NULL,
   [STATE] varchar(2)  NOT NULL,
   [STATE_LICENSE_ID] varchar(15)  NULL,
   [OTHER_STATE_ID_TYPE] numeric(1, 0)  NULL,
   [OTHER_STATE_ID] varchar(20)  NULL,
   [DEACTIVATION_DATE] datetime2(0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE.ID_NHIN_PRESCRIBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE',
        N'COLUMN', N'ID_NHIN_PRESCRIBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE.STATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE',
        N'COLUMN', N'STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE.STATE_LICENSE_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE',
        N'COLUMN', N'STATE_LICENSE_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE.OTHER_STATE_ID_TYPE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE',
        N'COLUMN', N'OTHER_STATE_ID_TYPE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE.OTHER_STATE_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE',
        N'COLUMN', N'OTHER_STATE_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE.DEACTIVATION_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE',
        N'COLUMN', N'DEACTIVATION_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCRIBER_STATE_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PRESCRIBER_STATE_UPD_ERR'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PRESCRIBER_STATE_UPD_ERR]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PRESCRIBER_STATE_UPD_ERR]
(
   [ID] numeric(38, 0)  NULL,
   [ID_NHIN_PRESCRIBER] numeric(38, 0)  NULL,
   [STATE] varchar(2)  NULL,
   [STATE_LICENSE_ID] varchar(15)  NULL,
   [OTHER_STATE_ID_TYPE] numeric(1, 0)  NULL,
   [OTHER_STATE_ID] varchar(20)  NULL,
   [DEACTIVATION_DATE] datetime2(0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE_UPD_ERR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE_UPD_ERR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE_UPD_ERR.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE_UPD_ERR',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE_UPD_ERR.ID_NHIN_PRESCRIBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE_UPD_ERR',
        N'COLUMN', N'ID_NHIN_PRESCRIBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE_UPD_ERR.STATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE_UPD_ERR',
        N'COLUMN', N'STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE_UPD_ERR.STATE_LICENSE_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE_UPD_ERR',
        N'COLUMN', N'STATE_LICENSE_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE_UPD_ERR.OTHER_STATE_ID_TYPE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE_UPD_ERR',
        N'COLUMN', N'OTHER_STATE_ID_TYPE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE_UPD_ERR.OTHER_STATE_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE_UPD_ERR',
        N'COLUMN', N'OTHER_STATE_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE_UPD_ERR.DEACTIVATION_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE_UPD_ERR',
        N'COLUMN', N'DEACTIVATION_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCRIBER_UPDATE_ERROR'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PRESCRIBER_UPDATE_ERROR'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PRESCRIBER_UPDATE_ERROR]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PRESCRIBER_UPDATE_ERROR]
(
   [COMM_GROUP_ID] varchar(10)  NULL,
   [DEA_REGISTRATION_NUM] varchar(13)  NULL,
   [DEA_NUM_RENEWAL_DATE] numeric(8, 0)  NULL,
   [LAST_NAME] varchar(25)  NULL,
   [PREVIOUS_LAST_NAME] varchar(40)  NULL,
   [FIRST_NAME] varchar(25)  NULL,
   [MIDDLE_NAME_INITIAL] varchar(1)  NULL,
   [NAME_SUFFIX] varchar(3)  NULL,
   [GENDER_CODE] varchar(1)  NULL,
   [ORGANIZATION_NAME] varchar(60)  NULL,
   [DEPARTMENT_MAIL_STOP] varchar(40)  NULL,
   [PHYS_ADDRESS_LINE_1] varchar(30)  NULL,
   [PHYS_ADDRESS_LINE_2] varchar(30)  NULL,
   [PHYS_SUITE_APARTMENT_NUM] varchar(8)  NULL,
   [PHYS_CITY_NAME] varchar(20)  NULL,
   [PHYS_STATE_PROVINCE_CODE] varchar(2)  NULL,
   [PHYS_ZIP_POSTAL_ZONE] varchar(9)  NULL,
   [PHYS_COUNTRY_CODE] varchar(3)  NULL,
   [PRIME_PHONE_NUM] numeric(10, 0)  NULL,
   [SECOND_PHONE_NUM] numeric(10, 0)  NULL,
   [REFILL_PHONE_NUM] numeric(10, 0)  NULL,
   [FAX_NUM] numeric(10, 0)  NULL,
   [EMAIL_IGNORED] varchar(25)  NULL,
   [PRIME_DEGREE] varchar(5)  NULL,
   [PRIME_TAXONOMY_CODE] varchar(10)  NULL,
   [SECOND_DEGREE] varchar(5)  NULL,
   [SECOND_TAXONOMY_CODE] varchar(10)  NULL,
   [STATE_CODE_PRIME_MEDICAID_ID] varchar(2)  NULL,
   [PRIME_MEDICAID_ID] varchar(15)  NULL,
   [STATE_CODE_SECOND_MEDICAID_ID] varchar(2)  NULL,
   [SECOND_MEDICAID_ID] varchar(15)  NULL,
   [STATE_CODE_THIRD_MEDICAID_ID] varchar(2)  NULL,
   [THIRD_MEDICAID_ID] varchar(15)  NULL,
   [UPIN_NUM] varchar(6)  NULL,
   [HIN_NUM] varchar(15)  NULL,
   [HCID_LOCATION_CODE] numeric(2, 0)  NULL,
   [DEA_STATUS_CODE] varchar(1)  NULL,
   [RETIRE_DATE] numeric(8, 0)  NULL,
   [DATA_SUPPLIER_REF_KEY_1] varchar(20)  NULL,
   [DATA_SUPPLIER_REF_KEY_2] varchar(20)  NULL,
   [DATA_SUPPLIER_REF_KEY_3] varchar(20)  NULL,
   [DATA_SUPPLIER_SITE_NUM] varchar(15)  NULL,
   [NPI] varchar(30)  NULL,
   [HCID_IDENTIFIER] varchar(30)  NULL,
   [NHIN_PROVIDER_ID] varchar(30)  NULL,
   [PHYS_LOCATION_TYPE_CODE] varchar(2)  NULL,
   [DUPE_DEA_FLAG] char(1)  NULL,
   [DUPE_DATA_SUPPLIER_REF_KEY_1] varchar(20)  NULL,
   [COMM_SUB_GROUP_ID] varchar(10)  NULL,
   [UPDATE_RECORD_TYPE_CODE] varchar(1)  NULL,
   [DATE_LAST_CHANGE] numeric(8, 0)  NULL,
   [DEA_REGISTRATION_NUM_SUFFIX] varchar(7)  NULL,
   [DEA_DRUG_SCHEDULE] varchar(12)  NULL,
   [NCPDP_PROVIDER_ID_NUM] varchar(15)  NULL,
   [DUPE_DATA_SUPPLIER_REF_KEY_2] varchar(20)  NULL,
   [DUPE_DATA_SUPPLIER_REF_KEY_3] varchar(20)  NULL,
   [ORIGIN] varchar(1)  NULL,
   [RESERVE_1] varchar(1)  NULL,
   [PREVIOUS_HCID] varchar(15)  NULL,
   [REPLACEMENT_HCID] varchar(15)  NULL,
   [HCID_DC_DATE] numeric(8, 0)  NULL,
   [NHIN_DECEASED_FLAG] varchar(1)  NULL,
   [NHIN_DECEASED_DATE] numeric(8, 0)  NULL,
   [REPLACEMENT_DEA_NUM] varchar(13)  NULL,
   [PREVIOUS_DEA_NUM] varchar(13)  NULL,
   [DATA_ELEMENT_CHANGE_TYPE] varchar(3)  NULL,
   [EMAIL_ADDRESS] varchar(60)  NULL,
   [FILLER_1] varchar(60)  NULL,
   [PDX_RESERVE] varchar(9)  NULL,
   [RESERVED] varchar(4)  NULL,
   [STATE_LICENSE_1] varchar(20)  NULL,
   [LICENSING_STATE_1] varchar(2)  NULL,
   [STATE_LICENSE_2] varchar(20)  NULL,
   [LICENSING_STATE_2] varchar(2)  NULL,
   [STATE_LICENSE_3] varchar(20)  NULL,
   [LICENSING_STATE_3] varchar(2)  NULL,
   [NHIN_USE] varchar(4)  NULL,
   [FILLER] varchar(19)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.COMM_GROUP_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'COMM_GROUP_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DEA_REGISTRATION_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DEA_REGISTRATION_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DEA_NUM_RENEWAL_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DEA_NUM_RENEWAL_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PREVIOUS_LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PREVIOUS_LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.MIDDLE_NAME_INITIAL',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'MIDDLE_NAME_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.NAME_SUFFIX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'NAME_SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.GENDER_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'GENDER_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.ORGANIZATION_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'ORGANIZATION_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DEPARTMENT_MAIL_STOP',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DEPARTMENT_MAIL_STOP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PHYS_ADDRESS_LINE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PHYS_ADDRESS_LINE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PHYS_ADDRESS_LINE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PHYS_ADDRESS_LINE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PHYS_SUITE_APARTMENT_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PHYS_SUITE_APARTMENT_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PHYS_CITY_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PHYS_CITY_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PHYS_STATE_PROVINCE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PHYS_STATE_PROVINCE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PHYS_ZIP_POSTAL_ZONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PHYS_ZIP_POSTAL_ZONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PHYS_COUNTRY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PHYS_COUNTRY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PRIME_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PRIME_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.SECOND_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'SECOND_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.REFILL_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'REFILL_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.FAX_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'FAX_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.EMAIL_IGNORED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'EMAIL_IGNORED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PRIME_DEGREE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PRIME_DEGREE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PRIME_TAXONOMY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PRIME_TAXONOMY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.SECOND_DEGREE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'SECOND_DEGREE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.SECOND_TAXONOMY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'SECOND_TAXONOMY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.STATE_CODE_PRIME_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'STATE_CODE_PRIME_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PRIME_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PRIME_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.STATE_CODE_SECOND_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'STATE_CODE_SECOND_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.SECOND_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'SECOND_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.STATE_CODE_THIRD_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'STATE_CODE_THIRD_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.THIRD_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'THIRD_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.UPIN_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'UPIN_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.HIN_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'HIN_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.HCID_LOCATION_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'HCID_LOCATION_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DEA_STATUS_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DEA_STATUS_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.RETIRE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'RETIRE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DATA_SUPPLIER_REF_KEY_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DATA_SUPPLIER_REF_KEY_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DATA_SUPPLIER_REF_KEY_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DATA_SUPPLIER_REF_KEY_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DATA_SUPPLIER_REF_KEY_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DATA_SUPPLIER_REF_KEY_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DATA_SUPPLIER_SITE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DATA_SUPPLIER_SITE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.NPI',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'NPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.HCID_IDENTIFIER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'HCID_IDENTIFIER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.NHIN_PROVIDER_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'NHIN_PROVIDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PHYS_LOCATION_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PHYS_LOCATION_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DUPE_DEA_FLAG',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DUPE_DEA_FLAG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DUPE_DATA_SUPPLIER_REF_KEY_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DUPE_DATA_SUPPLIER_REF_KEY_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.COMM_SUB_GROUP_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'COMM_SUB_GROUP_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.UPDATE_RECORD_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'UPDATE_RECORD_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DATE_LAST_CHANGE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DATE_LAST_CHANGE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DEA_REGISTRATION_NUM_SUFFIX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DEA_REGISTRATION_NUM_SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DEA_DRUG_SCHEDULE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DEA_DRUG_SCHEDULE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.NCPDP_PROVIDER_ID_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'NCPDP_PROVIDER_ID_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DUPE_DATA_SUPPLIER_REF_KEY_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DUPE_DATA_SUPPLIER_REF_KEY_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DUPE_DATA_SUPPLIER_REF_KEY_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DUPE_DATA_SUPPLIER_REF_KEY_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.ORIGIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'ORIGIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.RESERVE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'RESERVE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PREVIOUS_HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PREVIOUS_HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.REPLACEMENT_HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'REPLACEMENT_HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.HCID_DC_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'HCID_DC_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.NHIN_DECEASED_FLAG',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'NHIN_DECEASED_FLAG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.NHIN_DECEASED_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'NHIN_DECEASED_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.REPLACEMENT_DEA_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'REPLACEMENT_DEA_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PREVIOUS_DEA_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PREVIOUS_DEA_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.DATA_ELEMENT_CHANGE_TYPE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'DATA_ELEMENT_CHANGE_TYPE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.FILLER_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'FILLER_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.PDX_RESERVE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'PDX_RESERVE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.RESERVED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'RESERVED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.STATE_LICENSE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'STATE_LICENSE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.LICENSING_STATE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'LICENSING_STATE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.STATE_LICENSE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'STATE_LICENSE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.LICENSING_STATE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'LICENSING_STATE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.STATE_LICENSE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'STATE_LICENSE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.LICENSING_STATE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'LICENSING_STATE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.NHIN_USE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'NHIN_USE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR.FILLER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR',
        N'COLUMN', N'FILLER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCRIBER_UPDATE_ERROR_ORIG'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PRESCRIBER_UPDATE_ERROR_ORIG'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PRESCRIBER_UPDATE_ERROR_ORIG]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PRESCRIBER_UPDATE_ERROR_ORIG]
(
   [COMM_GROUP_ID] varchar(10)  NULL,
   [DEA_REGISTRATION_NUM] varchar(13)  NULL,
   [DEA_NUM_RENEWAL_DATE] numeric(8, 0)  NULL,
   [LAST_NAME] varchar(25)  NULL,
   [PREVIOUS_LAST_NAME] varchar(40)  NULL,
   [FIRST_NAME] varchar(25)  NULL,
   [MIDDLE_NAME_INITIAL] varchar(1)  NULL,
   [NAME_SUFFIX] varchar(3)  NULL,
   [GENDER_CODE] varchar(1)  NULL,
   [ORGANIZATION_NAME] varchar(60)  NULL,
   [DEPARTMENT_MAIL_STOP] varchar(40)  NULL,
   [PHYS_ADDRESS_LINE_1] varchar(30)  NULL,
   [PHYS_ADDRESS_LINE_2] varchar(30)  NULL,
   [PHYS_SUITE_APARTMENT_NUM] varchar(8)  NULL,
   [PHYS_CITY_NAME] varchar(20)  NULL,
   [PHYS_STATE_PROVINCE_CODE] varchar(2)  NULL,
   [PHYS_ZIP_POSTAL_ZONE] varchar(9)  NULL,
   [PHYS_COUNTRY_CODE] varchar(3)  NULL,
   [PRIME_PHONE_NUM] numeric(10, 0)  NULL,
   [SECOND_PHONE_NUM] numeric(10, 0)  NULL,
   [REFILL_PHONE_NUM] numeric(10, 0)  NULL,
   [FAX_NUM] numeric(10, 0)  NULL,
   [EMAIL_ADDRESS] varchar(25)  NULL,
   [PRIME_DEGREE] varchar(5)  NULL,
   [PRIME_TAXONOMY_CODE] varchar(10)  NULL,
   [SECOND_DEGREE] varchar(5)  NULL,
   [SECOND_TAXONOMY_CODE] varchar(10)  NULL,
   [STATE_CODE_PRIME_MEDICAID_ID] varchar(2)  NULL,
   [PRIME_MEDICAID_ID] varchar(15)  NULL,
   [STATE_CODE_SECOND_MEDICAID_ID] varchar(2)  NULL,
   [SECOND_MEDICAID_ID] varchar(15)  NULL,
   [STATE_CODE_THIRD_MEDICAID_ID] varchar(2)  NULL,
   [THIRD_MEDICAID_ID] varchar(15)  NULL,
   [UPIN_NUM] varchar(6)  NULL,
   [HIN_NUM] varchar(15)  NULL,
   [HCID_LOCATION_CODE] numeric(2, 0)  NULL,
   [DEA_STATUS_CODE] varchar(1)  NULL,
   [RETIRE_DATE] numeric(8, 0)  NULL,
   [DATA_SUPPLIER_REF_KEY_1] varchar(20)  NULL,
   [DATA_SUPPLIER_REF_KEY_2] varchar(20)  NULL,
   [DATA_SUPPLIER_REF_KEY_3] varchar(20)  NULL,
   [DATA_SUPPLIER_SITE_NUM] varchar(15)  NULL,
   [NPI] varchar(30)  NULL,
   [HCID_IDENTIFIER] varchar(30)  NULL,
   [NHIN_PROVIDER_ID] varchar(30)  NULL,
   [PHYS_LOCATION_TYPE_CODE] varchar(2)  NULL,
   [DUPE_DEA_FLAG] char(1)  NULL,
   [DUPE_DATA_SUPPLIER_REF_KEY_1] varchar(20)  NULL,
   [COMM_SUB_GROUP_ID] varchar(10)  NULL,
   [UPDATE_RECORD_TYPE_CODE] varchar(1)  NULL,
   [DATE_LAST_CHANGE] numeric(8, 0)  NULL,
   [DEA_REGISTRATION_NUM_SUFFIX] varchar(7)  NULL,
   [DEA_DRUG_SCHEDULE] varchar(12)  NULL,
   [NCPDP_PROVIDER_ID_NUM] varchar(15)  NULL,
   [DUPE_DATA_SUPPLIER_REF_KEY_2] varchar(20)  NULL,
   [DUPE_DATA_SUPPLIER_REF_KEY_3] varchar(20)  NULL,
   [ORIGIN] varchar(1)  NULL,
   [RESERVE_1] varchar(1)  NULL,
   [PREVIOUS_HCID] varchar(15)  NULL,
   [REPLACEMENT_HCID] varchar(15)  NULL,
   [HCID_DC_DATE] numeric(8, 0)  NULL,
   [NHIN_DECEASED_FLAG] varchar(1)  NULL,
   [NHIN_DECEASED_DATE] numeric(8, 0)  NULL,
   [REPLACEMENT_DEA_NUM] varchar(13)  NULL,
   [PREVIOUS_DEA_NUM] varchar(13)  NULL,
   [DATA_ELEMENT_CHANGE_TYPE] varchar(3)  NULL,
   [RESERVED] varchar(4)  NULL,
   [STATE_LICENSE_1] varchar(20)  NULL,
   [LICENSING_STATE_1] varchar(3)  NULL,
   [STATE_LICENSE_2] varchar(20)  NULL,
   [LICENSING_STATE_2] varchar(3)  NULL,
   [STATE_LICENSE_3] varchar(20)  NULL,
   [LICENSING_STATE_3] varchar(3)  NULL,
   [FILLER] varchar(149)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.COMM_GROUP_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'COMM_GROUP_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DEA_REGISTRATION_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DEA_REGISTRATION_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DEA_NUM_RENEWAL_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DEA_NUM_RENEWAL_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.PREVIOUS_LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'PREVIOUS_LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.MIDDLE_NAME_INITIAL',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'MIDDLE_NAME_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.NAME_SUFFIX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'NAME_SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.GENDER_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'GENDER_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.ORGANIZATION_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'ORGANIZATION_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DEPARTMENT_MAIL_STOP',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DEPARTMENT_MAIL_STOP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.PHYS_ADDRESS_LINE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'PHYS_ADDRESS_LINE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.PHYS_ADDRESS_LINE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'PHYS_ADDRESS_LINE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.PHYS_SUITE_APARTMENT_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'PHYS_SUITE_APARTMENT_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.PHYS_CITY_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'PHYS_CITY_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.PHYS_STATE_PROVINCE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'PHYS_STATE_PROVINCE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.PHYS_ZIP_POSTAL_ZONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'PHYS_ZIP_POSTAL_ZONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.PHYS_COUNTRY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'PHYS_COUNTRY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.PRIME_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'PRIME_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.SECOND_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'SECOND_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.REFILL_PHONE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'REFILL_PHONE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.FAX_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'FAX_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.PRIME_DEGREE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'PRIME_DEGREE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.PRIME_TAXONOMY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'PRIME_TAXONOMY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.SECOND_DEGREE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'SECOND_DEGREE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.SECOND_TAXONOMY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'SECOND_TAXONOMY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.STATE_CODE_PRIME_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'STATE_CODE_PRIME_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.PRIME_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'PRIME_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.STATE_CODE_SECOND_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'STATE_CODE_SECOND_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.SECOND_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'SECOND_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.STATE_CODE_THIRD_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'STATE_CODE_THIRD_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.THIRD_MEDICAID_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'THIRD_MEDICAID_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.UPIN_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'UPIN_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.HIN_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'HIN_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.HCID_LOCATION_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'HCID_LOCATION_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DEA_STATUS_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DEA_STATUS_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.RETIRE_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'RETIRE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DATA_SUPPLIER_REF_KEY_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DATA_SUPPLIER_REF_KEY_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DATA_SUPPLIER_REF_KEY_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DATA_SUPPLIER_REF_KEY_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DATA_SUPPLIER_REF_KEY_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DATA_SUPPLIER_REF_KEY_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DATA_SUPPLIER_SITE_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DATA_SUPPLIER_SITE_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.NPI',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'NPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.HCID_IDENTIFIER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'HCID_IDENTIFIER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.NHIN_PROVIDER_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'NHIN_PROVIDER_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.PHYS_LOCATION_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'PHYS_LOCATION_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DUPE_DEA_FLAG',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DUPE_DEA_FLAG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DUPE_DATA_SUPPLIER_REF_KEY_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DUPE_DATA_SUPPLIER_REF_KEY_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.COMM_SUB_GROUP_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'COMM_SUB_GROUP_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.UPDATE_RECORD_TYPE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'UPDATE_RECORD_TYPE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DATE_LAST_CHANGE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DATE_LAST_CHANGE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DEA_REGISTRATION_NUM_SUFFIX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DEA_REGISTRATION_NUM_SUFFIX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DEA_DRUG_SCHEDULE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DEA_DRUG_SCHEDULE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.NCPDP_PROVIDER_ID_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'NCPDP_PROVIDER_ID_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DUPE_DATA_SUPPLIER_REF_KEY_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DUPE_DATA_SUPPLIER_REF_KEY_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DUPE_DATA_SUPPLIER_REF_KEY_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DUPE_DATA_SUPPLIER_REF_KEY_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.ORIGIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'ORIGIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.RESERVE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'RESERVE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.PREVIOUS_HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'PREVIOUS_HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.REPLACEMENT_HCID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'REPLACEMENT_HCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.HCID_DC_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'HCID_DC_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.NHIN_DECEASED_FLAG',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'NHIN_DECEASED_FLAG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.NHIN_DECEASED_DATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'NHIN_DECEASED_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.REPLACEMENT_DEA_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'REPLACEMENT_DEA_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.PREVIOUS_DEA_NUM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'PREVIOUS_DEA_NUM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.DATA_ELEMENT_CHANGE_TYPE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'DATA_ELEMENT_CHANGE_TYPE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.RESERVED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'RESERVED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.STATE_LICENSE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'STATE_LICENSE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.LICENSING_STATE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'LICENSING_STATE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.STATE_LICENSE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'STATE_LICENSE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.LICENSING_STATE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'LICENSING_STATE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.STATE_LICENSE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'STATE_LICENSE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.LICENSING_STATE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'LICENSING_STATE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_UPDATE_ERROR_ORIG.FILLER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_UPDATE_ERROR_ORIG',
        N'COLUMN', N'FILLER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCRIPTIONS_WRITTEN'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PRESCRIPTIONS_WRITTEN'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PRESCRIPTIONS_WRITTEN]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PRESCRIPTIONS_WRITTEN]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_NHIN_PRESCRIBER_CLINIC_LINK] numeric(38, 0)  NOT NULL,
   [ID_PHARMACY] numeric(38, 0)  NULL,
   [RX_COM_ID] numeric(38, 0)  NULL,
   [TRANSACTION_NUMBER] numeric(15, 0)  NOT NULL,
   [SCRIPT_MESSAGE] varbinary(max)  NULL,
   [PATIENT_LAST_NAME] varchar(35)  NOT NULL,
   [PATIENT_FIRST_NAME] varchar(35)  NOT NULL,
   [PRESCRIPTION_WRITTEN_BY] varchar(20)  NOT NULL,
   [DATE_SENT] datetime2(0)  NOT NULL,
   [PATIENT_DATE_OF_BIRTH] datetime2(0)  NOT NULL,
   [PATIENT_PHONE] numeric(10, 0)  NOT NULL,
   [PATIENT_ADDRESS] varchar(35)  NOT NULL,
   [PATIENT_CITY] varchar(35)  NOT NULL,
   [PATIENT_STATE] varchar(2)  NOT NULL,
   [PATIENT_ZIP] varchar(15)  NOT NULL,
   [PRESCRIBED_QUANTITY] numeric(13, 2)  NOT NULL,
   [SIG_TEXT] varchar(255)  NOT NULL,
   [DISPENSE_AS_WRITTEN] varchar(1)  NOT NULL,
   [PRESCRIBED_DRUG_NAME] varchar(255)  NULL,
   [DELIVERY_METHOD] varchar(1)  NULL,
   [EMAIL_NOTIFICATION_STATUS] varchar(1)  NULL,
   [REFILLS_AUTHORIZED] varchar(5)  NULL,
   [DDID] numeric(10, 0)  NOT NULL,
   [DELIVERY_STATUS] varchar(1)  NULL,
   [PATIENT_GENDER] varchar(1)  NULL,
   [ID_MANUFACTURER_PROGRAM] numeric(38, 0)  NULL,
   [PATIENT_ADDRESS_LINE_2] varchar(35)  NULL,
   [SOFTWARE_USED] varchar(20)  NULL,
   [SOFTWARE_VERSION] varchar(10)  NULL,
   [SYS_NC00031$] AS (CONVERT(date, [DATE_SENT])) 
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.ID_NHIN_PRESCRIBER_CLINIC_LINK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'ID_NHIN_PRESCRIBER_CLINIC_LINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.ID_PHARMACY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'ID_PHARMACY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.RX_COM_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'RX_COM_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.TRANSACTION_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'TRANSACTION_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.SCRIPT_MESSAGE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'SCRIPT_MESSAGE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PATIENT_LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'PATIENT_LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PATIENT_FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'PATIENT_FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PRESCRIPTION_WRITTEN_BY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'PRESCRIPTION_WRITTEN_BY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.DATE_SENT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'DATE_SENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PATIENT_DATE_OF_BIRTH',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'PATIENT_DATE_OF_BIRTH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PATIENT_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'PATIENT_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PATIENT_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'PATIENT_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PATIENT_CITY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'PATIENT_CITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PATIENT_STATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'PATIENT_STATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PATIENT_ZIP',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'PATIENT_ZIP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PRESCRIBED_QUANTITY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'PRESCRIBED_QUANTITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.SIG_TEXT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'SIG_TEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.DISPENSE_AS_WRITTEN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'DISPENSE_AS_WRITTEN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PRESCRIBED_DRUG_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'PRESCRIBED_DRUG_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.DELIVERY_METHOD',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'DELIVERY_METHOD'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.EMAIL_NOTIFICATION_STATUS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'EMAIL_NOTIFICATION_STATUS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.REFILLS_AUTHORIZED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'REFILLS_AUTHORIZED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.DDID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'DDID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.DELIVERY_STATUS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'DELIVERY_STATUS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PATIENT_GENDER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'PATIENT_GENDER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.ID_MANUFACTURER_PROGRAM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'ID_MANUFACTURER_PROGRAM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PATIENT_ADDRESS_LINE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'PATIENT_ADDRESS_LINE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.SOFTWARE_USED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'SOFTWARE_USED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.SOFTWARE_VERSION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'SOFTWARE_VERSION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.SYS_NC00031$',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'COLUMN', N'SYS_NC00031$'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PROGRAM_NDC_SHIP_OPTION_LINK'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PROGRAM_NDC_SHIP_OPTION_LINK'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PROGRAM_NDC_SHIP_OPTION_LINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PROGRAM_NDC_SHIP_OPTION_LINK]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_SHIPPING_OPTION] numeric(38, 0)  NOT NULL,
   [ID_MFR_PROGRAM_NDC_LINK] numeric(38, 0)  NOT NULL,
   [SHIPPING_RATE] numeric(13, 2)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_NDC_SHIP_OPTION_LINK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_NDC_SHIP_OPTION_LINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_NDC_SHIP_OPTION_LINK.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_NDC_SHIP_OPTION_LINK',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_NDC_SHIP_OPTION_LINK.ID_SHIPPING_OPTION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_NDC_SHIP_OPTION_LINK',
        N'COLUMN', N'ID_SHIPPING_OPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_NDC_SHIP_OPTION_LINK.ID_MFR_PROGRAM_NDC_LINK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_NDC_SHIP_OPTION_LINK',
        N'COLUMN', N'ID_MFR_PROGRAM_NDC_LINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_NDC_SHIP_OPTION_LINK.SHIPPING_RATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_NDC_SHIP_OPTION_LINK',
        N'COLUMN', N'SHIPPING_RATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PROGRAM_SHIPPING_OPTION_LINK'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'PROGRAM_SHIPPING_OPTION_LINK'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[PROGRAM_SHIPPING_OPTION_LINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[PROGRAM_SHIPPING_OPTION_LINK]
(
   [ID] numeric(38, 0)  NOT NULL,
   [ID_SHIPPING_OPTION] numeric(38, 0)  NOT NULL,
   [ID_MANUFACTURER_PROGRAM] numeric(38, 0)  NOT NULL,
   [SHIPPING_RATE] numeric(13, 2)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_SHIPPING_OPTION_LINK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_SHIPPING_OPTION_LINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_SHIPPING_OPTION_LINK.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_SHIPPING_OPTION_LINK',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_SHIPPING_OPTION_LINK.ID_SHIPPING_OPTION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_SHIPPING_OPTION_LINK',
        N'COLUMN', N'ID_SHIPPING_OPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_SHIPPING_OPTION_LINK.ID_MANUFACTURER_PROGRAM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_SHIPPING_OPTION_LINK',
        N'COLUMN', N'ID_MANUFACTURER_PROGRAM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_SHIPPING_OPTION_LINK.SHIPPING_RATE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_SHIPPING_OPTION_LINK',
        N'COLUMN', N'SHIPPING_RATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'REJECT_CODES'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'REJECT_CODES'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[REJECT_CODES]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[REJECT_CODES]
(
   [ID] numeric(38, 0)  NOT NULL,
   [REJECT_CODE] varchar(3)  NOT NULL,
   [REJECT_DESCRIPTION] varchar(255)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.REJECT_CODES',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'REJECT_CODES'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.REJECT_CODES.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'REJECT_CODES',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.REJECT_CODES.REJECT_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'REJECT_CODES',
        N'COLUMN', N'REJECT_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.REJECT_CODES.REJECT_DESCRIPTION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'REJECT_CODES',
        N'COLUMN', N'REJECT_DESCRIPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'SHIPPING_OPTION'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'SHIPPING_OPTION'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[SHIPPING_OPTION]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[SHIPPING_OPTION]
(
   [ID] numeric(38, 0)  NOT NULL,
   [SHIPPING_TYPE] numeric(1, 0)  NOT NULL,
   [DESCRIPTION] varchar(120)  NULL,
   [SHIPPING_OPTION_NOTE] varchar(120)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SHIPPING_OPTION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SHIPPING_OPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SHIPPING_OPTION.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SHIPPING_OPTION',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SHIPPING_OPTION.SHIPPING_TYPE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SHIPPING_OPTION',
        N'COLUMN', N'SHIPPING_TYPE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SHIPPING_OPTION.DESCRIPTION',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SHIPPING_OPTION',
        N'COLUMN', N'DESCRIPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SHIPPING_OPTION.SHIPPING_OPTION_NOTE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SHIPPING_OPTION',
        N'COLUMN', N'SHIPPING_OPTION_NOTE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'SIG_TEXT_MASTER'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'SIG_TEXT_MASTER'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[SIG_TEXT_MASTER]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[SIG_TEXT_MASTER]
(
   [ID] numeric(38, 0)  NOT NULL,
   [DOSAGE_FORM] varchar(10)  NULL,
   [ROUTE_CODE] varchar(10)  NULL,
   [SIG_VERB] varchar(60)  NULL,
   [SIG_UNIT] varchar(60)  NULL,
   [SIG_UNITS] varchar(60)  NULL,
   [SIG_ROUTE] varchar(60)  NULL,
   [LANG] varchar(2)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SIG_TEXT_MASTER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SIG_TEXT_MASTER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SIG_TEXT_MASTER.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SIG_TEXT_MASTER',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SIG_TEXT_MASTER.DOSAGE_FORM',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SIG_TEXT_MASTER',
        N'COLUMN', N'DOSAGE_FORM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SIG_TEXT_MASTER.ROUTE_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SIG_TEXT_MASTER',
        N'COLUMN', N'ROUTE_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SIG_TEXT_MASTER.SIG_VERB',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SIG_TEXT_MASTER',
        N'COLUMN', N'SIG_VERB'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SIG_TEXT_MASTER.SIG_UNIT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SIG_TEXT_MASTER',
        N'COLUMN', N'SIG_UNIT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SIG_TEXT_MASTER.SIG_UNITS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SIG_TEXT_MASTER',
        N'COLUMN', N'SIG_UNITS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SIG_TEXT_MASTER.SIG_ROUTE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SIG_TEXT_MASTER',
        N'COLUMN', N'SIG_ROUTE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SIG_TEXT_MASTER.LANG',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SIG_TEXT_MASTER',
        N'COLUMN', N'LANG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'STANDARD_SIGS'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'STANDARD_SIGS'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[STANDARD_SIGS]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[STANDARD_SIGS]
(
   [ID] numeric(38, 0)  NOT NULL,
   [SIG_CODE] varchar(10)  NOT NULL,
   [SIG_TEXT] varchar(255)  NOT NULL,
   [DISPLAY_ORDER] numeric(2, 0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.STANDARD_SIGS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'STANDARD_SIGS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.STANDARD_SIGS.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'STANDARD_SIGS',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.STANDARD_SIGS.SIG_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'STANDARD_SIGS',
        N'COLUMN', N'SIG_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.STANDARD_SIGS.SIG_TEXT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'STANDARD_SIGS',
        N'COLUMN', N'SIG_TEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.STANDARD_SIGS.DISPLAY_ORDER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'STANDARD_SIGS',
        N'COLUMN', N'DISPLAY_ORDER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'SUPPORT_USER'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'SUPPORT_USER'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[SUPPORT_USER]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[SUPPORT_USER]
(
   [ID] numeric(38, 0)  NOT NULL,
   [USERNAME] varchar(20)  NOT NULL,
   [LAST_NAME] varchar(25)  NOT NULL,
   [FIRST_NAME] varchar(25)  NOT NULL,
   [EMPLOYEE_ID] varchar(10)  NULL,
   [EMAIL_ADDRESS] varchar(120)  NULL,
   [PASSWORD] varchar(32)  NULL,
   [INACTIVE] numeric(1, 0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SUPPORT_USER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SUPPORT_USER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SUPPORT_USER.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SUPPORT_USER',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SUPPORT_USER.USERNAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SUPPORT_USER',
        N'COLUMN', N'USERNAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SUPPORT_USER.LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SUPPORT_USER',
        N'COLUMN', N'LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SUPPORT_USER.FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SUPPORT_USER',
        N'COLUMN', N'FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SUPPORT_USER.EMPLOYEE_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SUPPORT_USER',
        N'COLUMN', N'EMPLOYEE_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SUPPORT_USER.EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SUPPORT_USER',
        N'COLUMN', N'EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SUPPORT_USER.PASSWORD',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SUPPORT_USER',
        N'COLUMN', N'PASSWORD'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SUPPORT_USER.INACTIVE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SUPPORT_USER',
        N'COLUMN', N'INACTIVE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'TEMP_PHARMACY'  AND sc.name = N'ESCRIBE'  AND type in (N'U'))
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
             WHERE so.name = N'TEMP_PHARMACY'  AND sc.name = N'ESCRIBE'  AND type in (N'U')
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

  DROP TABLE [ESCRIBE].[TEMP_PHARMACY]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[ESCRIBE].[TEMP_PHARMACY]
(
   [ID] numeric(38, 0)  NOT NULL,
   [NCPDP_NUMBER] varchar(7)  NOT NULL,
   [ID_ADDRESS] numeric(38, 0)  NOT NULL,
   [PHARMACY_NAME] varchar(60)  NOT NULL,
   [NHIN_STORE_ID] numeric(10, 0)  NULL,
   [STORE_NUMBER] varchar(10)  NULL,
   [PHARMACY_DBA_NAME] varchar(60)  NULL,
   [DEA_ID] varchar(15)  NULL,
   [ID_MAILING_ADDRESS] numeric(38, 0)  NULL,
   [PHONE_NUMBER] numeric(10, 0)  NULL,
   [FAX_PHONE] numeric(10, 0)  NULL,
   [DATE_OPENED] datetime2(0)  NULL,
   [DATE_CLOSED] datetime2(0)  NULL,
   [DEACTIVATED] datetime2(0)  NULL,
   [ACCEPTS_ESCRIPTS] char(1)  NULL,
   [DELIVERY_SERVICE] char(1)  NULL,
   [COMPOUNDING_SERVICE] char(1)  NULL,
   [DRIVE_UP_WINDOW] char(1)  NULL,
   [SELLS_DME_EQUIPMENT] char(1)  NULL,
   [HANDICAP_ACCESSIBLE] char(1)  NULL,
   [OPEN_24_HOUR] char(1)  NULL,
   [STATE_TAX_ID] varchar(15)  NULL,
   [FEDERAL_TAX_ID] varchar(15)  NULL,
   [STATE_LICENSE_NUMBER] varchar(20)  NULL,
   [DISPENSER_CLASS_CODE] varchar(2)  NULL,
   [DISPENSER_TYPE_CODE_1] varchar(2)  NULL,
   [DISPENSER_TYPE_CODE_2] varchar(2)  NULL,
   [DISPENSER_TYPE_CODE_3] varchar(2)  NULL,
   [LANGUAGE_CODE_1] varchar(2)  NULL,
   [LANGUAGE_CODE_2] varchar(2)  NULL,
   [LANGUAGE_CODE_3] varchar(2)  NULL,
   [LANGUAGE_CODE_4] varchar(2)  NULL,
   [LANGUAGE_CODE_5] varchar(2)  NULL,
   [CONGRESSIONAL_VOTING_DISTRICT] varchar(4)  NULL,
   [FIPS_MSA_CODE] varchar(4)  NULL,
   [FIPS_PMSA_CODE] varchar(4)  NULL,
   [FIPS_COUNTY_CODE] varchar(5)  NULL,
   [CONTACT_FIRST_NAME] varchar(20)  NULL,
   [CONTACT_MIDDLE_INITIAL] varchar(1)  NULL,
   [CONTACT_LAST_NAME] varchar(20)  NULL,
   [CONTACT_TITLE] varchar(30)  NULL,
   [CONTACT_PHONE_NUMBER] varchar(10)  NULL,
   [CONTACT_PHONE_EXT] varchar(5)  NULL,
   [UPIN] varchar(10)  NULL,
   [NPI] varchar(15)  NULL,
   [PHARMACY_HOURS] varchar(35)  NULL,
   [CROSS_STREET_DIRECTIONS] varchar(50)  NULL,
   [EMAIL_ADDRESS] varchar(50)  NULL,
   [CONTACT_EMAIL_ADDRESS] varchar(50)  NULL,
   [VENDOR_ID] varchar(60)  NULL,
   [FAXABLE] varchar(1)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.NCPDP_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'NCPDP_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.ID_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'ID_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.PHARMACY_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'PHARMACY_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.NHIN_STORE_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'NHIN_STORE_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.STORE_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'STORE_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.PHARMACY_DBA_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'PHARMACY_DBA_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.DEA_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'DEA_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.ID_MAILING_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'ID_MAILING_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.PHONE_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'PHONE_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.FAX_PHONE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'FAX_PHONE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.DATE_OPENED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'DATE_OPENED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.DATE_CLOSED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'DATE_CLOSED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.DEACTIVATED',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'DEACTIVATED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.ACCEPTS_ESCRIPTS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'ACCEPTS_ESCRIPTS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.DELIVERY_SERVICE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'DELIVERY_SERVICE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.COMPOUNDING_SERVICE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'COMPOUNDING_SERVICE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.DRIVE_UP_WINDOW',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'DRIVE_UP_WINDOW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.SELLS_DME_EQUIPMENT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'SELLS_DME_EQUIPMENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.HANDICAP_ACCESSIBLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'HANDICAP_ACCESSIBLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.OPEN_24_HOUR',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'OPEN_24_HOUR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.STATE_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'STATE_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.FEDERAL_TAX_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'FEDERAL_TAX_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.STATE_LICENSE_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'STATE_LICENSE_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.DISPENSER_CLASS_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'DISPENSER_CLASS_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.DISPENSER_TYPE_CODE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'DISPENSER_TYPE_CODE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.DISPENSER_TYPE_CODE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'DISPENSER_TYPE_CODE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.DISPENSER_TYPE_CODE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'DISPENSER_TYPE_CODE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.LANGUAGE_CODE_1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'LANGUAGE_CODE_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.LANGUAGE_CODE_2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'LANGUAGE_CODE_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.LANGUAGE_CODE_3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'LANGUAGE_CODE_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.LANGUAGE_CODE_4',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'LANGUAGE_CODE_4'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.LANGUAGE_CODE_5',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'LANGUAGE_CODE_5'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.CONGRESSIONAL_VOTING_DISTRICT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'CONGRESSIONAL_VOTING_DISTRICT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.FIPS_MSA_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'FIPS_MSA_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.FIPS_PMSA_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'FIPS_PMSA_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.FIPS_COUNTY_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'FIPS_COUNTY_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.CONTACT_FIRST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'CONTACT_FIRST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.CONTACT_MIDDLE_INITIAL',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'CONTACT_MIDDLE_INITIAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.CONTACT_LAST_NAME',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'CONTACT_LAST_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.CONTACT_TITLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'CONTACT_TITLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.CONTACT_PHONE_NUMBER',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'CONTACT_PHONE_NUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.CONTACT_PHONE_EXT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'CONTACT_PHONE_EXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.UPIN',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'UPIN'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.NPI',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'NPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.PHARMACY_HOURS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'PHARMACY_HOURS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.CROSS_STREET_DIRECTIONS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'CROSS_STREET_DIRECTIONS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.CONTACT_EMAIL_ADDRESS',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'CONTACT_EMAIL_ADDRESS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.VENDOR_ID',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'VENDOR_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.TEMP_PHARMACY.FAXABLE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'TEMP_PHARMACY',
        N'COLUMN', N'FAXABLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ADDRESS_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[ADDRESS] DROP CONSTRAINT [ADDRESS_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[ADDRESS]
 ADD CONSTRAINT [ADDRESS_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS.ADDRESS_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS',
        N'CONSTRAINT', N'ADDRESS_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'APP_ROLE_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[APP_ROLE] DROP CONSTRAINT [APP_ROLE_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[APP_ROLE]
 ADD CONSTRAINT [APP_ROLE_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_ROLE.APP_ROLE_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_ROLE',
        N'CONSTRAINT', N'APP_ROLE_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'AP_USER_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[APP_USER] DROP CONSTRAINT [AP_USER_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[APP_USER]
 ADD CONSTRAINT [AP_USER_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.AP_USER_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'CONSTRAINT', N'AP_USER_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'AUDIT_DATES_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[AUDIT_DATES] DROP CONSTRAINT [AUDIT_DATES_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[AUDIT_DATES]
 ADD CONSTRAINT [AUDIT_DATES_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES.AUDIT_DATES_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES',
        N'CONSTRAINT', N'AUDIT_DATES_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'BILLING_SERVICES_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[BILLING_SERVICES] DROP CONSTRAINT [BILLING_SERVICES_PK]
 GO



ALTER TABLE [ESCRIBE].[BILLING_SERVICES]
 ADD CONSTRAINT [BILLING_SERVICES_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.BILLING_SERVICES.BILLING_SERVICES_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'BILLING_SERVICES',
        N'CONSTRAINT', N'BILLING_SERVICES_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'CLAIM_HISTORY_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[CLAIM_HISTORY] DROP CONSTRAINT [CLAIM_HISTORY_PK]
 GO



ALTER TABLE [ESCRIBE].[CLAIM_HISTORY]
 ADD CONSTRAINT [CLAIM_HISTORY_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.CLAIM_HISTORY_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'CONSTRAINT', N'CLAIM_HISTORY_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'CLAIM_PROCESSOR_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[CLAIM_PROCESSOR] DROP CONSTRAINT [CLAIM_PROCESSOR_PK]
 GO



ALTER TABLE [ESCRIBE].[CLAIM_PROCESSOR]
 ADD CONSTRAINT [CLAIM_PROCESSOR_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_PROCESSOR.CLAIM_PROCESSOR_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_PROCESSOR',
        N'CONSTRAINT', N'CLAIM_PROCESSOR_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'CPR_LINK_AUDIT_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[CPR_LINK_AUDIT] DROP CONSTRAINT [CPR_LINK_AUDIT_PK]
 GO



ALTER TABLE [ESCRIBE].[CPR_LINK_AUDIT]
 ADD CONSTRAINT [CPR_LINK_AUDIT_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CPR_LINK_AUDIT.CPR_LINK_AUDIT_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CPR_LINK_AUDIT',
        N'CONSTRAINT', N'CPR_LINK_AUDIT_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'CUSTOMER_SIGS_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[CUSTOM_SIGS] DROP CONSTRAINT [CUSTOMER_SIGS_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[CUSTOM_SIGS]
 ADD CONSTRAINT [CUSTOMER_SIGS_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CUSTOM_SIGS.CUSTOMER_SIGS_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CUSTOM_SIGS',
        N'CONSTRAINT', N'CUSTOMER_SIGS_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'DRUG_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[DRUG] DROP CONSTRAINT [DRUG_PK]
 GO



ALTER TABLE [ESCRIBE].[DRUG]
 ADD CONSTRAINT [DRUG_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.DRUG.DRUG_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'DRUG',
        N'CONSTRAINT', N'DRUG_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'FAILED_MESSAGES_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[FAILED_MESSAGES] DROP CONSTRAINT [FAILED_MESSAGES_PK]
 GO



ALTER TABLE [ESCRIBE].[FAILED_MESSAGES]
 ADD CONSTRAINT [FAILED_MESSAGES_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.FAILED_MESSAGES.FAILED_MESSAGES_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'FAILED_MESSAGES',
        N'CONSTRAINT', N'FAILED_MESSAGES_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'INSURANCE_PLAN_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[INSURANCE_PLAN] DROP CONSTRAINT [INSURANCE_PLAN_PK]
 GO



ALTER TABLE [ESCRIBE].[INSURANCE_PLAN]
 ADD CONSTRAINT [INSURANCE_PLAN_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.INSURANCE_PLAN.INSURANCE_PLAN_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'INSURANCE_PLAN',
        N'CONSTRAINT', N'INSURANCE_PLAN_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MANUFACTURER_PROGRAM_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[MANUFACTURER_PROGRAM] DROP CONSTRAINT [MANUFACTURER_PROGRAM_PK]
 GO



ALTER TABLE [ESCRIBE].[MANUFACTURER_PROGRAM]
 ADD CONSTRAINT [MANUFACTURER_PROGRAM_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MANUFACTURER_PROGRAM.MANUFACTURER_PROGRAM_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MANUFACTURER_PROGRAM',
        N'CONSTRAINT', N'MANUFACTURER_PROGRAM_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MFR_PROGRAM_NDC_LINK_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[MFR_PROGRAM_NDC_LINK] DROP CONSTRAINT [MFR_PROGRAM_NDC_LINK_PK]
 GO



ALTER TABLE [ESCRIBE].[MFR_PROGRAM_NDC_LINK]
 ADD CONSTRAINT [MFR_PROGRAM_NDC_LINK_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_NDC_LINK.MFR_PROGRAM_NDC_LINK_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_NDC_LINK',
        N'CONSTRAINT', N'MFR_PROGRAM_NDC_LINK_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MFR_PROGRAM_PHARMACY_LINK_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[MFR_PROGRAM_PHARMACY_LINK] DROP CONSTRAINT [MFR_PROGRAM_PHARMACY_LINK_PK]
 GO



ALTER TABLE [ESCRIBE].[MFR_PROGRAM_PHARMACY_LINK]
 ADD CONSTRAINT [MFR_PROGRAM_PHARMACY_LINK_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_PHARMACY_LINK.MFR_PROGRAM_PHARMACY_LINK_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_PHARMACY_LINK',
        N'CONSTRAINT', N'MFR_PROGRAM_PHARMACY_LINK_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NCPDP_MESSAGES_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[NCPDP_MESSAGES] DROP CONSTRAINT [NCPDP_MESSAGES_PK]
 GO



ALTER TABLE [ESCRIBE].[NCPDP_MESSAGES]
 ADD CONSTRAINT [NCPDP_MESSAGES_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NCPDP_MESSAGES.NCPDP_MESSAGES_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NCPDP_MESSAGES',
        N'CONSTRAINT', N'NCPDP_MESSAGES_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NHIN_CLINIC_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[NHIN_CLINIC] DROP CONSTRAINT [NHIN_CLINIC_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[NHIN_CLINIC]
 ADD CONSTRAINT [NHIN_CLINIC_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.NHIN_CLINIC_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'CONSTRAINT', N'NHIN_CLINIC_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NHIN_PRESCRIBER_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[NHIN_PRESCRIBER] DROP CONSTRAINT [NHIN_PRESCRIBER_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[NHIN_PRESCRIBER]
 ADD CONSTRAINT [NHIN_PRESCRIBER_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NHIN_PRESCRIBER_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'CONSTRAINT', N'NHIN_PRESCRIBER_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NHIN_PRESCR_CLINIC_LINK_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[NHIN_PRESCRIBER_CLINIC_LINK] DROP CONSTRAINT [NHIN_PRESCR_CLINIC_LINK_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[NHIN_PRESCRIBER_CLINIC_LINK]
 ADD CONSTRAINT [NHIN_PRESCR_CLINIC_LINK_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.NHIN_PRESCR_CLINIC_LINK_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'CONSTRAINT', N'NHIN_PRESCR_CLINIC_LINK_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ORDER_INFO_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[ORDER_INFO] DROP CONSTRAINT [ORDER_INFO_PK]
 GO



ALTER TABLE [ESCRIBE].[ORDER_INFO]
 ADD CONSTRAINT [ORDER_INFO_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO.ORDER_INFO_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO',
        N'CONSTRAINT', N'ORDER_INFO_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ORDER_INFO_BK_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[ORDER_INFO_BK] DROP CONSTRAINT [ORDER_INFO_BK_PK]
 GO



ALTER TABLE [ESCRIBE].[ORDER_INFO_BK]
 ADD CONSTRAINT [ORDER_INFO_BK_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO_BK.ORDER_INFO_BK_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO_BK',
        N'CONSTRAINT', N'ORDER_INFO_BK_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PHARMACY_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[PHARMACY] DROP CONSTRAINT [PHARMACY_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[PHARMACY]
 ADD CONSTRAINT [PHARMACY_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.PHARMACY_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'CONSTRAINT', N'PHARMACY_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PHARM_MEDICAID_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[PHARMACY_MEDICAID_IDS] DROP CONSTRAINT [PHARM_MEDICAID_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[PHARMACY_MEDICAID_IDS]
 ADD CONSTRAINT [PHARM_MEDICAID_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_MEDICAID_IDS.PHARM_MEDICAID_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_MEDICAID_IDS',
        N'CONSTRAINT', N'PHARM_MEDICAID_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCRIBER_DRUG_USAGE_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[PRESCRIBER_DRUG_USAGE] DROP CONSTRAINT [PRESCRIBER_DRUG_USAGE_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[PRESCRIBER_DRUG_USAGE]
 ADD CONSTRAINT [PRESCRIBER_DRUG_USAGE_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE.PRESCRIBER_DRUG_USAGE_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE',
        N'CONSTRAINT', N'PRESCRIBER_DRUG_USAGE_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCRIBER_MEDICAID_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[PRESCRIBER_MEDICAID] DROP CONSTRAINT [PRESCRIBER_MEDICAID_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[PRESCRIBER_MEDICAID]
 ADD CONSTRAINT [PRESCRIBER_MEDICAID_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_MEDICAID.PRESCRIBER_MEDICAID_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_MEDICAID',
        N'CONSTRAINT', N'PRESCRIBER_MEDICAID_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESRIBER_PHARMACY_USAGE_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[PRESCRIBER_PHARMACY_USAGE] DROP CONSTRAINT [PRESRIBER_PHARMACY_USAGE_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[PRESCRIBER_PHARMACY_USAGE]
 ADD CONSTRAINT [PRESRIBER_PHARMACY_USAGE_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PHARMACY_USAGE.PRESRIBER_PHARMACY_USAGE_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PHARMACY_USAGE',
        N'CONSTRAINT', N'PRESRIBER_PHARMACY_USAGE_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCRIBER_PIN_MAILING_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[PRESCRIBER_PIN_MAILING] DROP CONSTRAINT [PRESCRIBER_PIN_MAILING_PK]
 GO



ALTER TABLE [ESCRIBE].[PRESCRIBER_PIN_MAILING]
 ADD CONSTRAINT [PRESCRIBER_PIN_MAILING_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PIN_MAILING.PRESCRIBER_PIN_MAILING_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PIN_MAILING',
        N'CONSTRAINT', N'PRESCRIBER_PIN_MAILING_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCRIBER_STATE_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[PRESCRIBER_STATE] DROP CONSTRAINT [PRESCRIBER_STATE_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[PRESCRIBER_STATE]
 ADD CONSTRAINT [PRESCRIBER_STATE_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE.PRESCRIBER_STATE_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE',
        N'CONSTRAINT', N'PRESCRIBER_STATE_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCRIPTIONS_WRITTEN_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[PRESCRIPTIONS_WRITTEN] DROP CONSTRAINT [PRESCRIPTIONS_WRITTEN_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[PRESCRIPTIONS_WRITTEN]
 ADD CONSTRAINT [PRESCRIPTIONS_WRITTEN_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PRESCRIPTIONS_WRITTEN_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'CONSTRAINT', N'PRESCRIPTIONS_WRITTEN_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PROGRAM_NDC_SHIP_OPTION_LNK_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[PROGRAM_NDC_SHIP_OPTION_LINK] DROP CONSTRAINT [PROGRAM_NDC_SHIP_OPTION_LNK_PK]
 GO



ALTER TABLE [ESCRIBE].[PROGRAM_NDC_SHIP_OPTION_LINK]
 ADD CONSTRAINT [PROGRAM_NDC_SHIP_OPTION_LNK_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_NDC_SHIP_OPTION_LINK.PROGRAM_NDC_SHIP_OPTION_LNK_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_NDC_SHIP_OPTION_LINK',
        N'CONSTRAINT', N'PROGRAM_NDC_SHIP_OPTION_LNK_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PROGRAM_SHIPPING_OPTION_LNK_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[PROGRAM_SHIPPING_OPTION_LINK] DROP CONSTRAINT [PROGRAM_SHIPPING_OPTION_LNK_PK]
 GO



ALTER TABLE [ESCRIBE].[PROGRAM_SHIPPING_OPTION_LINK]
 ADD CONSTRAINT [PROGRAM_SHIPPING_OPTION_LNK_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_SHIPPING_OPTION_LINK.PROGRAM_SHIPPING_OPTION_LNK_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_SHIPPING_OPTION_LINK',
        N'CONSTRAINT', N'PROGRAM_SHIPPING_OPTION_LNK_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'REJECT_CODES_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[REJECT_CODES] DROP CONSTRAINT [REJECT_CODES_PK]
 GO



ALTER TABLE [ESCRIBE].[REJECT_CODES]
 ADD CONSTRAINT [REJECT_CODES_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.REJECT_CODES.REJECT_CODES_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'REJECT_CODES',
        N'CONSTRAINT', N'REJECT_CODES_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'SHIPPING_OPTION_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[SHIPPING_OPTION] DROP CONSTRAINT [SHIPPING_OPTION_PK]
 GO



ALTER TABLE [ESCRIBE].[SHIPPING_OPTION]
 ADD CONSTRAINT [SHIPPING_OPTION_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SHIPPING_OPTION.SHIPPING_OPTION_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SHIPPING_OPTION',
        N'CONSTRAINT', N'SHIPPING_OPTION_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'SIG_TEXT_MASTER_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[SIG_TEXT_MASTER] DROP CONSTRAINT [SIG_TEXT_MASTER_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[SIG_TEXT_MASTER]
 ADD CONSTRAINT [SIG_TEXT_MASTER_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SIG_TEXT_MASTER.SIG_TEXT_MASTER_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SIG_TEXT_MASTER',
        N'CONSTRAINT', N'SIG_TEXT_MASTER_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'STANDARD_SIGS_ID_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[STANDARD_SIGS] DROP CONSTRAINT [STANDARD_SIGS_ID_PK]
 GO



ALTER TABLE [ESCRIBE].[STANDARD_SIGS]
 ADD CONSTRAINT [STANDARD_SIGS_ID_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.STANDARD_SIGS.STANDARD_SIGS_ID_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'STANDARD_SIGS',
        N'CONSTRAINT', N'STANDARD_SIGS_ID_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'SUPPORT_USER_PK'  AND sc.name = N'ESCRIBE'  AND type in (N'PK'))
ALTER TABLE [ESCRIBE].[SUPPORT_USER] DROP CONSTRAINT [SUPPORT_USER_PK]
 GO



ALTER TABLE [ESCRIBE].[SUPPORT_USER]
 ADD CONSTRAINT [SUPPORT_USER_PK]
   PRIMARY KEY
   CLUSTERED ([ID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SUPPORT_USER.SUPPORT_USER_PK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SUPPORT_USER',
        N'CONSTRAINT', N'SUPPORT_USER_PK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'AP_USER_USERNAME_UNIQUE'  AND sc.name = N'ESCRIBE'  AND type in (N'UQ'))
ALTER TABLE [ESCRIBE].[APP_USER] DROP CONSTRAINT [AP_USER_USERNAME_UNIQUE]
 GO



ALTER TABLE [ESCRIBE].[APP_USER]
 ADD CONSTRAINT [AP_USER_USERNAME_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([USERNAME] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.AP_USER_USERNAME_UNIQUE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'CONSTRAINT', N'AP_USER_USERNAME_UNIQUE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'CLAIM_PROC_UNQ_CLAIM_PROC_CODE'  AND sc.name = N'ESCRIBE'  AND type in (N'UQ'))
ALTER TABLE [ESCRIBE].[CLAIM_PROCESSOR] DROP CONSTRAINT [CLAIM_PROC_UNQ_CLAIM_PROC_CODE]
 GO



ALTER TABLE [ESCRIBE].[CLAIM_PROCESSOR]
 ADD CONSTRAINT [CLAIM_PROC_UNQ_CLAIM_PROC_CODE]
 UNIQUE 
   NONCLUSTERED ([CLAIM_PROCESSOR_CODE] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_PROCESSOR.CLAIM_PROC_UNQ_CLAIM_PROC_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_PROCESSOR',
        N'CONSTRAINT', N'CLAIM_PROC_UNQ_CLAIM_PROC_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'DRUG_NDC_UNQ'  AND sc.name = N'ESCRIBE'  AND type in (N'UQ'))
ALTER TABLE [ESCRIBE].[DRUG] DROP CONSTRAINT [DRUG_NDC_UNQ]
 GO



ALTER TABLE [ESCRIBE].[DRUG]
 ADD CONSTRAINT [DRUG_NDC_UNQ]
 UNIQUE 
   NONCLUSTERED ([NDC] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.DRUG.DRUG_NDC_UNQ',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'DRUG',
        N'CONSTRAINT', N'DRUG_NDC_UNQ'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'REJECT_CODES_UNQ_REJECT_CODE'  AND sc.name = N'ESCRIBE'  AND type in (N'UQ'))
ALTER TABLE [ESCRIBE].[REJECT_CODES] DROP CONSTRAINT [REJECT_CODES_UNQ_REJECT_CODE]
 GO



ALTER TABLE [ESCRIBE].[REJECT_CODES]
 ADD CONSTRAINT [REJECT_CODES_UNQ_REJECT_CODE]
 UNIQUE 
   NONCLUSTERED ([REJECT_CODE] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.REJECT_CODES.REJECT_CODES_UNQ_REJECT_CODE',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'REJECT_CODES',
        N'CONSTRAINT', N'REJECT_CODES_UNQ_REJECT_CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'ADDRESS'  AND sc.name = N'ESCRIBE'  AND si.name = N'ADDRESS_CITY_STATE_ZIP_INDX' AND so.type in (N'U'))
   DROP INDEX [ADDRESS_CITY_STATE_ZIP_INDX] ON [ESCRIBE].[ADDRESS] 
GO
CREATE NONCLUSTERED INDEX [ADDRESS_CITY_STATE_ZIP_INDX] ON [ESCRIBE].[ADDRESS]
(
   [CITY] ASC,
   [STATE] ASC,
   [ZIP_CODE] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS.ADDRESS_CITY_STATE_ZIP_INDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS',
        N'INDEX', N'ADDRESS_CITY_STATE_ZIP_INDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'ADDRESS'  AND sc.name = N'ESCRIBE'  AND si.name = N'ADDRESS_INDX1' AND so.type in (N'U'))
   DROP INDEX [ADDRESS_INDX1] ON [ESCRIBE].[ADDRESS] 
GO
CREATE NONCLUSTERED INDEX [ADDRESS_INDX1] ON [ESCRIBE].[ADDRESS]
(
   [ADDRESS_LINE_1] ASC,
   [ADDRESS_LINE_2] ASC,
   [DEPARTMENT_MAIL_STOP] ASC,
   [CITY] ASC,
   [STATE] ASC,
   [ZIP_CODE] ASC,
   [COUNTRY] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS.ADDRESS_INDX1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS',
        N'INDEX', N'ADDRESS_INDX1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO

   /* 
   *   SSMA error messages:
   *   O2SS0269: Index 'ADDRESS_INDX2' is functional and cannot be converted.


IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'ADDRESS'  AND sc.name = N'ESCRIBE'  AND si.name = N'ADDRESS_INDX2' AND so.type in (N'U'))
   DROP INDEX [ADDRESS_INDX2] ON [ESCRIBE].[ADDRESS] 
GO
CREATE NONCLUSTERED INDEX [ADDRESS_INDX2] ON [ESCRIBE].[ADDRESS]
(
   [ADDRESS_LINE_1] ASC,
   [ADDRESS_LINE_2] ASC,
   [SYS_NC00009$] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS.ADDRESS_INDX2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS',
        N'INDEX', N'ADDRESS_INDX2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO
   */


USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'ADDRESS'  AND sc.name = N'ESCRIBE'  AND si.name = N'ADDRESS_STATE_ZIP_INDX' AND so.type in (N'U'))
   DROP INDEX [ADDRESS_STATE_ZIP_INDX] ON [ESCRIBE].[ADDRESS] 
GO
CREATE NONCLUSTERED INDEX [ADDRESS_STATE_ZIP_INDX] ON [ESCRIBE].[ADDRESS]
(
   [STATE] ASC,
   [ZIP_CODE] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS.ADDRESS_STATE_ZIP_INDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS',
        N'INDEX', N'ADDRESS_STATE_ZIP_INDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'ADDRESS'  AND sc.name = N'ESCRIBE'  AND si.name = N'ADDRESS_ZIP_INDX' AND so.type in (N'U'))
   DROP INDEX [ADDRESS_ZIP_INDX] ON [ESCRIBE].[ADDRESS] 
GO
CREATE NONCLUSTERED INDEX [ADDRESS_ZIP_INDX] ON [ESCRIBE].[ADDRESS]
(
   [ZIP_CODE] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ADDRESS.ADDRESS_ZIP_INDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ADDRESS',
        N'INDEX', N'ADDRESS_ZIP_INDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'APP_USER'  AND sc.name = N'ESCRIBE'  AND si.name = N'APP_USER_PRESCRIBER_NDX' AND so.type in (N'U'))
   DROP INDEX [APP_USER_PRESCRIBER_NDX] ON [ESCRIBE].[APP_USER] 
GO
CREATE NONCLUSTERED INDEX [APP_USER_PRESCRIBER_NDX] ON [ESCRIBE].[APP_USER]
(
   [ID_NHIN_PRESCRIBER] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.APP_USER_PRESCRIBER_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'INDEX', N'APP_USER_PRESCRIBER_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'APP_USER_ROLE'  AND sc.name = N'ESCRIBE'  AND si.name = N'APP_USER_ROLE_ID_APP_USER_INDX' AND so.type in (N'U'))
   DROP INDEX [APP_USER_ROLE_ID_APP_USER_INDX] ON [ESCRIBE].[APP_USER_ROLE] 
GO
CREATE NONCLUSTERED INDEX [APP_USER_ROLE_ID_APP_USER_INDX] ON [ESCRIBE].[APP_USER_ROLE]
(
   [ID_APP_USER] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER_ROLE.APP_USER_ROLE_ID_APP_USER_INDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER_ROLE',
        N'INDEX', N'APP_USER_ROLE_ID_APP_USER_INDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'APP_USER_ROLE'  AND sc.name = N'ESCRIBE'  AND si.name = N'APP_USER_ROLE_IX1' AND so.type in (N'U'))
   DROP INDEX [APP_USER_ROLE_IX1] ON [ESCRIBE].[APP_USER_ROLE] 
GO
CREATE NONCLUSTERED INDEX [APP_USER_ROLE_IX1] ON [ESCRIBE].[APP_USER_ROLE]
(
   [ID_APP_ROLE] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER_ROLE.APP_USER_ROLE_IX1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER_ROLE',
        N'INDEX', N'APP_USER_ROLE_IX1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'AUDIT_DATES'  AND sc.name = N'ESCRIBE'  AND si.name = N'AUDIT_DATES_NDX1' AND so.type in (N'U'))
   DROP INDEX [AUDIT_DATES_NDX1] ON [ESCRIBE].[AUDIT_DATES] 
GO
CREATE NONCLUSTERED INDEX [AUDIT_DATES_NDX1] ON [ESCRIBE].[AUDIT_DATES]
(
   [TABLE_CLASS_NAME] ASC,
   [TABLE_ROW_ID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.AUDIT_DATES.AUDIT_DATES_NDX1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'AUDIT_DATES',
        N'INDEX', N'AUDIT_DATES_NDX1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'CLAIM_HISTORY'  AND sc.name = N'ESCRIBE'  AND si.name = N'CLAIM_HISTORY_IX1' AND so.type in (N'U'))
   DROP INDEX [CLAIM_HISTORY_IX1] ON [ESCRIBE].[CLAIM_HISTORY] 
GO
CREATE NONCLUSTERED INDEX [CLAIM_HISTORY_IX1] ON [ESCRIBE].[CLAIM_HISTORY]
(
   [ID_NCPDP_MESSAGE_REVERSE] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.CLAIM_HISTORY_IX1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'INDEX', N'CLAIM_HISTORY_IX1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'CLAIM_HISTORY'  AND sc.name = N'ESCRIBE'  AND si.name = N'CLAIM_HISTORY_IX2' AND so.type in (N'U'))
   DROP INDEX [CLAIM_HISTORY_IX2] ON [ESCRIBE].[CLAIM_HISTORY] 
GO
CREATE NONCLUSTERED INDEX [CLAIM_HISTORY_IX2] ON [ESCRIBE].[CLAIM_HISTORY]
(
   [ID_NCPDP_MESSAGE_CLAIM] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.CLAIM_HISTORY_IX2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'INDEX', N'CLAIM_HISTORY_IX2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'CLAIM_HISTORY'  AND sc.name = N'ESCRIBE'  AND si.name = N'CLAIM_HISTORY_IX3' AND so.type in (N'U'))
   DROP INDEX [CLAIM_HISTORY_IX3] ON [ESCRIBE].[CLAIM_HISTORY] 
GO
CREATE NONCLUSTERED INDEX [CLAIM_HISTORY_IX3] ON [ESCRIBE].[CLAIM_HISTORY]
(
   [ID_NCPDP_MESSAGE_CLAIM_RESP] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.CLAIM_HISTORY_IX3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'INDEX', N'CLAIM_HISTORY_IX3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'CLAIM_HISTORY'  AND sc.name = N'ESCRIBE'  AND si.name = N'CLAIM_HISTORY_IX4' AND so.type in (N'U'))
   DROP INDEX [CLAIM_HISTORY_IX4] ON [ESCRIBE].[CLAIM_HISTORY] 
GO
CREATE NONCLUSTERED INDEX [CLAIM_HISTORY_IX4] ON [ESCRIBE].[CLAIM_HISTORY]
(
   [ID_NCPDP_MESSAGE_REVERSE_RESP] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.CLAIM_HISTORY_IX4',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'INDEX', N'CLAIM_HISTORY_IX4'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'CLAIM_HISTORY'  AND sc.name = N'ESCRIBE'  AND si.name = N'CLAIM_HST_NHIN_PRES_CLN_LNK_FK' AND so.type in (N'U'))
   DROP INDEX [CLAIM_HST_NHIN_PRES_CLN_LNK_FK] ON [ESCRIBE].[CLAIM_HISTORY] 
GO
CREATE NONCLUSTERED INDEX [CLAIM_HST_NHIN_PRES_CLN_LNK_FK] ON [ESCRIBE].[CLAIM_HISTORY]
(
   [ID_NHIN_PRESCRIBER] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.CLAIM_HST_NHIN_PRES_CLN_LNK_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'INDEX', N'CLAIM_HST_NHIN_PRES_CLN_LNK_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'CPR_LINK_AUDIT'  AND sc.name = N'ESCRIBE'  AND si.name = N'CPR_LINK_AUDIT_OLD_RXCOM_NDX' AND so.type in (N'U'))
   DROP INDEX [CPR_LINK_AUDIT_OLD_RXCOM_NDX] ON [ESCRIBE].[CPR_LINK_AUDIT] 
GO
CREATE NONCLUSTERED INDEX [CPR_LINK_AUDIT_OLD_RXCOM_NDX] ON [ESCRIBE].[CPR_LINK_AUDIT]
(
   [OLD_RXCOM_ID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CPR_LINK_AUDIT.CPR_LINK_AUDIT_OLD_RXCOM_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CPR_LINK_AUDIT',
        N'INDEX', N'CPR_LINK_AUDIT_OLD_RXCOM_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'CUSTOM_SIGS'  AND sc.name = N'ESCRIBE'  AND si.name = N'CUSTOM_SIGS_ID_NHIN_PRESCR_NDX' AND so.type in (N'U'))
   DROP INDEX [CUSTOM_SIGS_ID_NHIN_PRESCR_NDX] ON [ESCRIBE].[CUSTOM_SIGS] 
GO
CREATE NONCLUSTERED INDEX [CUSTOM_SIGS_ID_NHIN_PRESCR_NDX] ON [ESCRIBE].[CUSTOM_SIGS]
(
   [ID_NHIN_PRESCRIBER] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CUSTOM_SIGS.CUSTOM_SIGS_ID_NHIN_PRESCR_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CUSTOM_SIGS',
        N'INDEX', N'CUSTOM_SIGS_ID_NHIN_PRESCR_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'INSURANCE_PLAN'  AND sc.name = N'ESCRIBE'  AND si.name = N'INS_PLAN_BIN_PCN_GROUP_NUM_IDX' AND so.type in (N'U'))
   DROP INDEX [INS_PLAN_BIN_PCN_GROUP_NUM_IDX] ON [ESCRIBE].[INSURANCE_PLAN] 
GO
CREATE NONCLUSTERED INDEX [INS_PLAN_BIN_PCN_GROUP_NUM_IDX] ON [ESCRIBE].[INSURANCE_PLAN]
(
   [BIN] ASC,
   [PCN] ASC,
   [GROUP_NUMBER] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.INSURANCE_PLAN.INS_PLAN_BIN_PCN_GROUP_NUM_IDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'INSURANCE_PLAN',
        N'INDEX', N'INS_PLAN_BIN_PCN_GROUP_NUM_IDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'INSURANCE_PLAN'  AND sc.name = N'ESCRIBE'  AND si.name = N'INS_PLAN_PDX_CARRIER_CODE_IDX' AND so.type in (N'U'))
   DROP INDEX [INS_PLAN_PDX_CARRIER_CODE_IDX] ON [ESCRIBE].[INSURANCE_PLAN] 
GO
CREATE NONCLUSTERED INDEX [INS_PLAN_PDX_CARRIER_CODE_IDX] ON [ESCRIBE].[INSURANCE_PLAN]
(
   [PDX_CARRIER_CODE] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.INSURANCE_PLAN.INS_PLAN_PDX_CARRIER_CODE_IDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'INSURANCE_PLAN',
        N'INDEX', N'INS_PLAN_PDX_CARRIER_CODE_IDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'MFR_PROGRAM_NDC_LINK'  AND sc.name = N'ESCRIBE'  AND si.name = N'MFR_PROGRAM_NDC_LINK_IX1' AND so.type in (N'U'))
   DROP INDEX [MFR_PROGRAM_NDC_LINK_IX1] ON [ESCRIBE].[MFR_PROGRAM_NDC_LINK] 
GO
CREATE NONCLUSTERED INDEX [MFR_PROGRAM_NDC_LINK_IX1] ON [ESCRIBE].[MFR_PROGRAM_NDC_LINK]
(
   [ID_MANUFACTURER_PROGRAM] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_NDC_LINK.MFR_PROGRAM_NDC_LINK_IX1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_NDC_LINK',
        N'INDEX', N'MFR_PROGRAM_NDC_LINK_IX1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'MFR_PROGRAM_PHARMACY_LINK'  AND sc.name = N'ESCRIBE'  AND si.name = N'MFR_PROGRAM_PHARMACY_LINK_IX1' AND so.type in (N'U'))
   DROP INDEX [MFR_PROGRAM_PHARMACY_LINK_IX1] ON [ESCRIBE].[MFR_PROGRAM_PHARMACY_LINK] 
GO
CREATE NONCLUSTERED INDEX [MFR_PROGRAM_PHARMACY_LINK_IX1] ON [ESCRIBE].[MFR_PROGRAM_PHARMACY_LINK]
(
   [ID_MANUFACTURER_PROGRAM] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_PHARMACY_LINK.MFR_PROGRAM_PHARMACY_LINK_IX1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_PHARMACY_LINK',
        N'INDEX', N'MFR_PROGRAM_PHARMACY_LINK_IX1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'NHIN_CLINIC'  AND sc.name = N'ESCRIBE'  AND si.name = N'NHIN_CLINIC_CLINIC_NAME_INDX' AND so.type in (N'U'))
   DROP INDEX [NHIN_CLINIC_CLINIC_NAME_INDX] ON [ESCRIBE].[NHIN_CLINIC] 
GO
CREATE NONCLUSTERED INDEX [NHIN_CLINIC_CLINIC_NAME_INDX] ON [ESCRIBE].[NHIN_CLINIC]
(
   [CLINIC_NAME] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.NHIN_CLINIC_CLINIC_NAME_INDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'INDEX', N'NHIN_CLINIC_CLINIC_NAME_INDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'NHIN_CLINIC'  AND sc.name = N'ESCRIBE'  AND si.name = N'NHIN_CLINIC_ID_ADDRESS_IDX' AND so.type in (N'U'))
   DROP INDEX [NHIN_CLINIC_ID_ADDRESS_IDX] ON [ESCRIBE].[NHIN_CLINIC] 
GO
CREATE NONCLUSTERED INDEX [NHIN_CLINIC_ID_ADDRESS_IDX] ON [ESCRIBE].[NHIN_CLINIC]
(
   [ID_ADDRESS] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.NHIN_CLINIC_ID_ADDRESS_IDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'INDEX', N'NHIN_CLINIC_ID_ADDRESS_IDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'NHIN_PRESCRIBER_CLINIC_LINK'  AND sc.name = N'ESCRIBE'  AND si.name = N'NHIN_PRESCR_CLN_LNK_DEA_ID_NDX' AND so.type in (N'U'))
   DROP INDEX [NHIN_PRESCR_CLN_LNK_DEA_ID_NDX] ON [ESCRIBE].[NHIN_PRESCRIBER_CLINIC_LINK] 
GO
CREATE NONCLUSTERED INDEX [NHIN_PRESCR_CLN_LNK_DEA_ID_NDX] ON [ESCRIBE].[NHIN_PRESCRIBER_CLINIC_LINK]
(
   [DEA_ID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.NHIN_PRESCR_CLN_LNK_DEA_ID_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'INDEX', N'NHIN_PRESCR_CLN_LNK_DEA_ID_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'NHIN_PRESCRIBER_CLINIC_LINK'  AND sc.name = N'ESCRIBE'  AND si.name = N'NHIN_PRESCRIBER_CLINIC_LK_IX1' AND so.type in (N'U'))
   DROP INDEX [NHIN_PRESCRIBER_CLINIC_LK_IX1] ON [ESCRIBE].[NHIN_PRESCRIBER_CLINIC_LINK] 
GO
CREATE NONCLUSTERED INDEX [NHIN_PRESCRIBER_CLINIC_LK_IX1] ON [ESCRIBE].[NHIN_PRESCRIBER_CLINIC_LINK]
(
   [ID_NHIN_CLINIC] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.NHIN_PRESCRIBER_CLINIC_LK_IX1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'INDEX', N'NHIN_PRESCRIBER_CLINIC_LK_IX1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'NHIN_PRESCRIBER'  AND sc.name = N'ESCRIBE'  AND si.name = N'NHIN_PRESCRIBER_DEA_ID_INDX' AND so.type in (N'U'))
   DROP INDEX [NHIN_PRESCRIBER_DEA_ID_INDX] ON [ESCRIBE].[NHIN_PRESCRIBER] 
GO
CREATE NONCLUSTERED INDEX [NHIN_PRESCRIBER_DEA_ID_INDX] ON [ESCRIBE].[NHIN_PRESCRIBER]
(
   [DEA_ID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NHIN_PRESCRIBER_DEA_ID_INDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'INDEX', N'NHIN_PRESCRIBER_DEA_ID_INDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'NHIN_PRESCRIBER'  AND sc.name = N'ESCRIBE'  AND si.name = N'NHIN_PRESCRIBER_EMAIL_NDX' AND so.type in (N'U'))
   DROP INDEX [NHIN_PRESCRIBER_EMAIL_NDX] ON [ESCRIBE].[NHIN_PRESCRIBER] 
GO
CREATE NONCLUSTERED INDEX [NHIN_PRESCRIBER_EMAIL_NDX] ON [ESCRIBE].[NHIN_PRESCRIBER]
(
   [EMAIL_ADDRESS] ASC,
   [REGISTRATION_PIN] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NHIN_PRESCRIBER_EMAIL_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'INDEX', N'NHIN_PRESCRIBER_EMAIL_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'NHIN_PRESCRIBER'  AND sc.name = N'ESCRIBE'  AND si.name = N'NHIN_PRESCRIBER_FIRST_NAME_NDX' AND so.type in (N'U'))
   DROP INDEX [NHIN_PRESCRIBER_FIRST_NAME_NDX] ON [ESCRIBE].[NHIN_PRESCRIBER] 
GO
CREATE NONCLUSTERED INDEX [NHIN_PRESCRIBER_FIRST_NAME_NDX] ON [ESCRIBE].[NHIN_PRESCRIBER]
(
   [FIRST_NAME] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NHIN_PRESCRIBER_FIRST_NAME_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'INDEX', N'NHIN_PRESCRIBER_FIRST_NAME_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'NHIN_PRESCRIBER'  AND sc.name = N'ESCRIBE'  AND si.name = N'NHIN_PRESCRIBER_HCID_NDX' AND so.type in (N'U'))
   DROP INDEX [NHIN_PRESCRIBER_HCID_NDX] ON [ESCRIBE].[NHIN_PRESCRIBER] 
GO
CREATE NONCLUSTERED INDEX [NHIN_PRESCRIBER_HCID_NDX] ON [ESCRIBE].[NHIN_PRESCRIBER]
(
   [HCID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NHIN_PRESCRIBER_HCID_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'INDEX', N'NHIN_PRESCRIBER_HCID_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'NHIN_PRESCRIBER'  AND sc.name = N'ESCRIBE'  AND si.name = N'NHIN_PRESCRIBER_IX1' AND so.type in (N'U'))
   DROP INDEX [NHIN_PRESCRIBER_IX1] ON [ESCRIBE].[NHIN_PRESCRIBER] 
GO
CREATE NONCLUSTERED INDEX [NHIN_PRESCRIBER_IX1] ON [ESCRIBE].[NHIN_PRESCRIBER]
(
   [ID_REGISTRATION_ADDRESS] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NHIN_PRESCRIBER_IX1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'INDEX', N'NHIN_PRESCRIBER_IX1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'NHIN_PRESCRIBER'  AND sc.name = N'ESCRIBE'  AND si.name = N'NHIN_PRESCRIBER_NAME_NDX' AND so.type in (N'U'))
   DROP INDEX [NHIN_PRESCRIBER_NAME_NDX] ON [ESCRIBE].[NHIN_PRESCRIBER] 
GO
CREATE NONCLUSTERED INDEX [NHIN_PRESCRIBER_NAME_NDX] ON [ESCRIBE].[NHIN_PRESCRIBER]
(
   [LAST_NAME] ASC,
   [FIRST_NAME] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NHIN_PRESCRIBER_NAME_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'INDEX', N'NHIN_PRESCRIBER_NAME_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'NHIN_PRESCRIBER'  AND sc.name = N'ESCRIBE'  AND si.name = N'NHIN_PRESCRIBER_REG_DATE_NDX' AND so.type in (N'U'))
   DROP INDEX [NHIN_PRESCRIBER_REG_DATE_NDX] ON [ESCRIBE].[NHIN_PRESCRIBER] 
GO
CREATE NONCLUSTERED INDEX [NHIN_PRESCRIBER_REG_DATE_NDX] ON [ESCRIBE].[NHIN_PRESCRIBER]
(
   [REGISTRATION_DATE] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NHIN_PRESCRIBER_REG_DATE_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'INDEX', N'NHIN_PRESCRIBER_REG_DATE_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'ORDER_INFO'  AND sc.name = N'ESCRIBE'  AND si.name = N'ORDER_INFO_IDX_IDPRESCWRT' AND so.type in (N'U'))
   DROP INDEX [ORDER_INFO_IDX_IDPRESCWRT] ON [ESCRIBE].[ORDER_INFO] 
GO
CREATE NONCLUSTERED INDEX [ORDER_INFO_IDX_IDPRESCWRT] ON [ESCRIBE].[ORDER_INFO]
(
   [ID_PRESCRIPTIONS_WRITTEN] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO.ORDER_INFO_IDX_IDPRESCWRT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO',
        N'INDEX', N'ORDER_INFO_IDX_IDPRESCWRT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PASSWORD_HISTORY'  AND sc.name = N'ESCRIBE'  AND si.name = N'PASSWORD_HISTORY_APP_USER_NDX' AND so.type in (N'U'))
   DROP INDEX [PASSWORD_HISTORY_APP_USER_NDX] ON [ESCRIBE].[PASSWORD_HISTORY] 
GO
CREATE NONCLUSTERED INDEX [PASSWORD_HISTORY_APP_USER_NDX] ON [ESCRIBE].[PASSWORD_HISTORY]
(
   [ID_APP_USER] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PASSWORD_HISTORY.PASSWORD_HISTORY_APP_USER_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PASSWORD_HISTORY',
        N'INDEX', N'PASSWORD_HISTORY_APP_USER_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PHARMACY'  AND sc.name = N'ESCRIBE'  AND si.name = N'PHARMACY_IX1' AND so.type in (N'U'))
   DROP INDEX [PHARMACY_IX1] ON [ESCRIBE].[PHARMACY] 
GO
CREATE NONCLUSTERED INDEX [PHARMACY_IX1] ON [ESCRIBE].[PHARMACY]
(
   [ID_ADDRESS] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.PHARMACY_IX1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'INDEX', N'PHARMACY_IX1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PHARMACY_MEDICAID_IDS'  AND sc.name = N'ESCRIBE'  AND si.name = N'PHARMACY_MEDICAID_IDS_IX1' AND so.type in (N'U'))
   DROP INDEX [PHARMACY_MEDICAID_IDS_IX1] ON [ESCRIBE].[PHARMACY_MEDICAID_IDS] 
GO
CREATE NONCLUSTERED INDEX [PHARMACY_MEDICAID_IDS_IX1] ON [ESCRIBE].[PHARMACY_MEDICAID_IDS]
(
   [ID_PHARMACY] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_MEDICAID_IDS.PHARMACY_MEDICAID_IDS_IX1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_MEDICAID_IDS',
        N'INDEX', N'PHARMACY_MEDICAID_IDS_IX1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PHARMACY'  AND sc.name = N'ESCRIBE'  AND si.name = N'PHARMACY_NCPDP_NUMBER_INDX' AND so.type in (N'U'))
   DROP INDEX [PHARMACY_NCPDP_NUMBER_INDX] ON [ESCRIBE].[PHARMACY] 
GO
CREATE UNIQUE NONCLUSTERED INDEX [PHARMACY_NCPDP_NUMBER_INDX] ON [ESCRIBE].[PHARMACY]
(
   [NCPDP_NUMBER] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.PHARMACY_NCPDP_NUMBER_INDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'INDEX', N'PHARMACY_NCPDP_NUMBER_INDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PHARMACY'  AND sc.name = N'ESCRIBE'  AND si.name = N'PHARMACY_PHARMACY_NAME_INDX' AND so.type in (N'U'))
   DROP INDEX [PHARMACY_PHARMACY_NAME_INDX] ON [ESCRIBE].[PHARMACY] 
GO
CREATE NONCLUSTERED INDEX [PHARMACY_PHARMACY_NAME_INDX] ON [ESCRIBE].[PHARMACY]
(
   [PHARMACY_NAME] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.PHARMACY_PHARMACY_NAME_INDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'INDEX', N'PHARMACY_PHARMACY_NAME_INDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PRESCRIBER_PIN_MAILING'  AND sc.name = N'ESCRIBE'  AND si.name = N'PRES_PIN_MAIL_ID_NHIN_PRES_NDX' AND so.type in (N'U'))
   DROP INDEX [PRES_PIN_MAIL_ID_NHIN_PRES_NDX] ON [ESCRIBE].[PRESCRIBER_PIN_MAILING] 
GO
CREATE UNIQUE NONCLUSTERED INDEX [PRES_PIN_MAIL_ID_NHIN_PRES_NDX] ON [ESCRIBE].[PRESCRIBER_PIN_MAILING]
(
   [ID_NHIN_PRESCRIBER] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PIN_MAILING.PRES_PIN_MAIL_ID_NHIN_PRES_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PIN_MAILING',
        N'INDEX', N'PRES_PIN_MAIL_ID_NHIN_PRES_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'NHIN_PRESCRIBER_CLINIC_LINK'  AND sc.name = N'ESCRIBE'  AND si.name = N'PRESCR_CLN_LNK_ID_PRESCR_INDX' AND so.type in (N'U'))
   DROP INDEX [PRESCR_CLN_LNK_ID_PRESCR_INDX] ON [ESCRIBE].[NHIN_PRESCRIBER_CLINIC_LINK] 
GO
CREATE NONCLUSTERED INDEX [PRESCR_CLN_LNK_ID_PRESCR_INDX] ON [ESCRIBE].[NHIN_PRESCRIBER_CLINIC_LINK]
(
   [ID_NHIN_PRESCRIBER] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.PRESCR_CLN_LNK_ID_PRESCR_INDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'INDEX', N'PRESCR_CLN_LNK_ID_PRESCR_INDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PRESCRIBER_DRUG_USAGE'  AND sc.name = N'ESCRIBE'  AND si.name = N'PRESCR_DRUG_ID_NHIN_PRESCR_NDX' AND so.type in (N'U'))
   DROP INDEX [PRESCR_DRUG_ID_NHIN_PRESCR_NDX] ON [ESCRIBE].[PRESCRIBER_DRUG_USAGE] 
GO
CREATE NONCLUSTERED INDEX [PRESCR_DRUG_ID_NHIN_PRESCR_NDX] ON [ESCRIBE].[PRESCRIBER_DRUG_USAGE]
(
   [ID_NHIN_PRESCRIBER] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE.PRESCR_DRUG_ID_NHIN_PRESCR_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE',
        N'INDEX', N'PRESCR_DRUG_ID_NHIN_PRESCR_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PRESCRIBER_MEDICAID'  AND sc.name = N'ESCRIBE'  AND si.name = N'PRESCR_MEDI_ID_NHIN_PRESCR_NDX' AND so.type in (N'U'))
   DROP INDEX [PRESCR_MEDI_ID_NHIN_PRESCR_NDX] ON [ESCRIBE].[PRESCRIBER_MEDICAID] 
GO
CREATE NONCLUSTERED INDEX [PRESCR_MEDI_ID_NHIN_PRESCR_NDX] ON [ESCRIBE].[PRESCRIBER_MEDICAID]
(
   [ID_NHIN_PRESCRIBER] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_MEDICAID.PRESCR_MEDI_ID_NHIN_PRESCR_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_MEDICAID',
        N'INDEX', N'PRESCR_MEDI_ID_NHIN_PRESCR_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PRESCRIBER_MEDICAID'  AND sc.name = N'ESCRIBE'  AND si.name = N'PRESCR_MEDICAID_ST_MEDI_ID_NDX' AND so.type in (N'U'))
   DROP INDEX [PRESCR_MEDICAID_ST_MEDI_ID_NDX] ON [ESCRIBE].[PRESCRIBER_MEDICAID] 
GO
CREATE NONCLUSTERED INDEX [PRESCR_MEDICAID_ST_MEDI_ID_NDX] ON [ESCRIBE].[PRESCRIBER_MEDICAID]
(
   [STATE] ASC,
   [MEDICAID_ID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_MEDICAID.PRESCR_MEDICAID_ST_MEDI_ID_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_MEDICAID',
        N'INDEX', N'PRESCR_MEDICAID_ST_MEDI_ID_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PRESCRIBER_PHARMACY_USAGE'  AND sc.name = N'ESCRIBE'  AND si.name = N'PRESCR_PHRM_ID_NHIN_PRESCR_NDX' AND so.type in (N'U'))
   DROP INDEX [PRESCR_PHRM_ID_NHIN_PRESCR_NDX] ON [ESCRIBE].[PRESCRIBER_PHARMACY_USAGE] 
GO
CREATE NONCLUSTERED INDEX [PRESCR_PHRM_ID_NHIN_PRESCR_NDX] ON [ESCRIBE].[PRESCRIBER_PHARMACY_USAGE]
(
   [ID_NHIN_PRESCRIBER] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PHARMACY_USAGE.PRESCR_PHRM_ID_NHIN_PRESCR_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PHARMACY_USAGE',
        N'INDEX', N'PRESCR_PHRM_ID_NHIN_PRESCR_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PRESCRIBER_STATE'  AND sc.name = N'ESCRIBE'  AND si.name = N'PRESCR_STAT_ID_NHIN_PRESCR_NDX' AND so.type in (N'U'))
   DROP INDEX [PRESCR_STAT_ID_NHIN_PRESCR_NDX] ON [ESCRIBE].[PRESCRIBER_STATE] 
GO
CREATE NONCLUSTERED INDEX [PRESCR_STAT_ID_NHIN_PRESCR_NDX] ON [ESCRIBE].[PRESCRIBER_STATE]
(
   [ID_NHIN_PRESCRIBER] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE.PRESCR_STAT_ID_NHIN_PRESCR_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE',
        N'INDEX', N'PRESCR_STAT_ID_NHIN_PRESCR_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PRESCRIBER_PHARMACY_USAGE'  AND sc.name = N'ESCRIBE'  AND si.name = N'PRESCRIBER_PHARMACY_USAGE_IX1' AND so.type in (N'U'))
   DROP INDEX [PRESCRIBER_PHARMACY_USAGE_IX1] ON [ESCRIBE].[PRESCRIBER_PHARMACY_USAGE] 
GO
CREATE NONCLUSTERED INDEX [PRESCRIBER_PHARMACY_USAGE_IX1] ON [ESCRIBE].[PRESCRIBER_PHARMACY_USAGE]
(
   [ID_PHARMACY] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PHARMACY_USAGE.PRESCRIBER_PHARMACY_USAGE_IX1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PHARMACY_USAGE',
        N'INDEX', N'PRESCRIBER_PHARMACY_USAGE_IX1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PRESCRIBER_STATE'  AND sc.name = N'ESCRIBE'  AND si.name = N'PRESCRIBER_STATE_ST_LIC_ID_NDX' AND so.type in (N'U'))
   DROP INDEX [PRESCRIBER_STATE_ST_LIC_ID_NDX] ON [ESCRIBE].[PRESCRIBER_STATE] 
GO
CREATE NONCLUSTERED INDEX [PRESCRIBER_STATE_ST_LIC_ID_NDX] ON [ESCRIBE].[PRESCRIBER_STATE]
(
   [STATE] ASC,
   [STATE_LICENSE_ID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE.PRESCRIBER_STATE_ST_LIC_ID_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE',
        N'INDEX', N'PRESCRIBER_STATE_ST_LIC_ID_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PRESCRIPTIONS_WRITTEN'  AND sc.name = N'ESCRIBE'  AND si.name = N'PRESCRIPTIONS_WRITTEN_IX1' AND so.type in (N'U'))
   DROP INDEX [PRESCRIPTIONS_WRITTEN_IX1] ON [ESCRIBE].[PRESCRIPTIONS_WRITTEN] 
GO
CREATE NONCLUSTERED INDEX [PRESCRIPTIONS_WRITTEN_IX1] ON [ESCRIBE].[PRESCRIPTIONS_WRITTEN]
(
   [ID_PHARMACY] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PRESCRIPTIONS_WRITTEN_IX1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'INDEX', N'PRESCRIPTIONS_WRITTEN_IX1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PRESCRIPTIONS_WRITTEN'  AND sc.name = N'ESCRIBE'  AND si.name = N'PRESCRIPTIONS_WRITTEN_NDX1' AND so.type in (N'U'))
   DROP INDEX [PRESCRIPTIONS_WRITTEN_NDX1] ON [ESCRIBE].[PRESCRIPTIONS_WRITTEN] 
GO
CREATE NONCLUSTERED INDEX [PRESCRIPTIONS_WRITTEN_NDX1] ON [ESCRIBE].[PRESCRIPTIONS_WRITTEN]
(
   [ID_NHIN_PRESCRIBER_CLINIC_LINK] ASC,
   [PATIENT_LAST_NAME] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PRESCRIPTIONS_WRITTEN_NDX1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'INDEX', N'PRESCRIPTIONS_WRITTEN_NDX1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO

   /* 
   *   SSMA error messages:
   *   O2SS0269: Index 'PRESCRIPTIONS_WRITTEN_NDX2' is functional and cannot be converted.


IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PRESCRIPTIONS_WRITTEN'  AND sc.name = N'ESCRIBE'  AND si.name = N'PRESCRIPTIONS_WRITTEN_NDX2' AND so.type in (N'U'))
   DROP INDEX [PRESCRIPTIONS_WRITTEN_NDX2] ON [ESCRIBE].[PRESCRIPTIONS_WRITTEN] 
GO
CREATE NONCLUSTERED INDEX [PRESCRIPTIONS_WRITTEN_NDX2] ON [ESCRIBE].[PRESCRIPTIONS_WRITTEN]
(
   [ID_NHIN_PRESCRIBER_CLINIC_LINK] ASC,
   [SYS_NC00031$] ASC,
   [PATIENT_LAST_NAME] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PRESCRIPTIONS_WRITTEN_NDX2',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'INDEX', N'PRESCRIPTIONS_WRITTEN_NDX2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO
   */


USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PRESCRIPTIONS_WRITTEN'  AND sc.name = N'ESCRIBE'  AND si.name = N'PRESCRIPTIONS_WRITTEN_NDX3' AND so.type in (N'U'))
   DROP INDEX [PRESCRIPTIONS_WRITTEN_NDX3] ON [ESCRIBE].[PRESCRIPTIONS_WRITTEN] 
GO
CREATE NONCLUSTERED INDEX [PRESCRIPTIONS_WRITTEN_NDX3] ON [ESCRIBE].[PRESCRIPTIONS_WRITTEN]
(
   [RX_COM_ID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PRESCRIPTIONS_WRITTEN_NDX3',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'INDEX', N'PRESCRIPTIONS_WRITTEN_NDX3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PRESCRIPTIONS_WRITTEN'  AND sc.name = N'ESCRIBE'  AND si.name = N'PRESCRIPTIONS_WRITTEN_NDX4' AND so.type in (N'U'))
   DROP INDEX [PRESCRIPTIONS_WRITTEN_NDX4] ON [ESCRIBE].[PRESCRIPTIONS_WRITTEN] 
GO
CREATE UNIQUE NONCLUSTERED INDEX [PRESCRIPTIONS_WRITTEN_NDX4] ON [ESCRIBE].[PRESCRIPTIONS_WRITTEN]
(
   [TRANSACTION_NUMBER] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PRESCRIPTIONS_WRITTEN_NDX4',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'INDEX', N'PRESCRIPTIONS_WRITTEN_NDX4'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PROGRAM_NDC_SHIP_OPTION_LINK'  AND sc.name = N'ESCRIBE'  AND si.name = N'PROG_NDC_SHIP_OPT_LNK_MFR_NDX' AND so.type in (N'U'))
   DROP INDEX [PROG_NDC_SHIP_OPT_LNK_MFR_NDX] ON [ESCRIBE].[PROGRAM_NDC_SHIP_OPTION_LINK] 
GO
CREATE NONCLUSTERED INDEX [PROG_NDC_SHIP_OPT_LNK_MFR_NDX] ON [ESCRIBE].[PROGRAM_NDC_SHIP_OPTION_LINK]
(
   [ID_MFR_PROGRAM_NDC_LINK] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_NDC_SHIP_OPTION_LINK.PROG_NDC_SHIP_OPT_LNK_MFR_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_NDC_SHIP_OPTION_LINK',
        N'INDEX', N'PROG_NDC_SHIP_OPT_LNK_MFR_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PROGRAM_SHIPPING_OPTION_LINK'  AND sc.name = N'ESCRIBE'  AND si.name = N'PROG_SHIP_OPT_LNK_MFR_NDX' AND so.type in (N'U'))
   DROP INDEX [PROG_SHIP_OPT_LNK_MFR_NDX] ON [ESCRIBE].[PROGRAM_SHIPPING_OPTION_LINK] 
GO
CREATE NONCLUSTERED INDEX [PROG_SHIP_OPT_LNK_MFR_NDX] ON [ESCRIBE].[PROGRAM_SHIPPING_OPTION_LINK]
(
   [ID_MANUFACTURER_PROGRAM] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_SHIPPING_OPTION_LINK.PROG_SHIP_OPT_LNK_MFR_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_SHIPPING_OPTION_LINK',
        N'INDEX', N'PROG_SHIP_OPT_LNK_MFR_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PROGRAM_NDC_SHIP_OPTION_LINK'  AND sc.name = N'ESCRIBE'  AND si.name = N'PROGRAM_NDC_SHIP_OPT_LINK_IX1' AND so.type in (N'U'))
   DROP INDEX [PROGRAM_NDC_SHIP_OPT_LINK_IX1] ON [ESCRIBE].[PROGRAM_NDC_SHIP_OPTION_LINK] 
GO
CREATE NONCLUSTERED INDEX [PROGRAM_NDC_SHIP_OPT_LINK_IX1] ON [ESCRIBE].[PROGRAM_NDC_SHIP_OPTION_LINK]
(
   [ID_SHIPPING_OPTION] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_NDC_SHIP_OPTION_LINK.PROGRAM_NDC_SHIP_OPT_LINK_IX1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_NDC_SHIP_OPTION_LINK',
        N'INDEX', N'PROGRAM_NDC_SHIP_OPT_LINK_IX1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'PROGRAM_SHIPPING_OPTION_LINK'  AND sc.name = N'ESCRIBE'  AND si.name = N'PROGRAM_SHIPPING_OPT_LINK_IX1' AND so.type in (N'U'))
   DROP INDEX [PROGRAM_SHIPPING_OPT_LINK_IX1] ON [ESCRIBE].[PROGRAM_SHIPPING_OPTION_LINK] 
GO
CREATE NONCLUSTERED INDEX [PROGRAM_SHIPPING_OPT_LINK_IX1] ON [ESCRIBE].[PROGRAM_SHIPPING_OPTION_LINK]
(
   [ID_SHIPPING_OPTION] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_SHIPPING_OPTION_LINK.PROGRAM_SHIPPING_OPT_LINK_IX1',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_SHIPPING_OPTION_LINK',
        N'INDEX', N'PROGRAM_SHIPPING_OPT_LINK_IX1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'SIG_TEXT_MASTER'  AND sc.name = N'ESCRIBE'  AND si.name = N'SIG_TEXT_MASTER_DOSAGE_NDX' AND so.type in (N'U'))
   DROP INDEX [SIG_TEXT_MASTER_DOSAGE_NDX] ON [ESCRIBE].[SIG_TEXT_MASTER] 
GO
CREATE NONCLUSTERED INDEX [SIG_TEXT_MASTER_DOSAGE_NDX] ON [ESCRIBE].[SIG_TEXT_MASTER]
(
   [DOSAGE_FORM] ASC,
   [ROUTE_CODE] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.SIG_TEXT_MASTER.SIG_TEXT_MASTER_DOSAGE_NDX',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'SIG_TEXT_MASTER',
        N'INDEX', N'SIG_TEXT_MASTER_DOSAGE_NDX'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'AP_USER_ID_NHIN_PRESRIBER_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[APP_USER] DROP CONSTRAINT [AP_USER_ID_NHIN_PRESRIBER_FK]
 GO



ALTER TABLE [ESCRIBE].[APP_USER]
 ADD CONSTRAINT [AP_USER_ID_NHIN_PRESRIBER_FK]
 FOREIGN KEY 
   ([ID_NHIN_PRESCRIBER])
 REFERENCES 
   [noneprdb].[ESCRIBE].[NHIN_PRESCRIBER]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER.AP_USER_ID_NHIN_PRESRIBER_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER',
        N'CONSTRAINT', N'AP_USER_ID_NHIN_PRESRIBER_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'APP_USER_ROLE_ID_APP_ROLE_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[APP_USER_ROLE] DROP CONSTRAINT [APP_USER_ROLE_ID_APP_ROLE_FK]
 GO



ALTER TABLE [ESCRIBE].[APP_USER_ROLE]
 ADD CONSTRAINT [APP_USER_ROLE_ID_APP_ROLE_FK]
 FOREIGN KEY 
   ([ID_APP_ROLE])
 REFERENCES 
   [noneprdb].[ESCRIBE].[APP_ROLE]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER_ROLE.APP_USER_ROLE_ID_APP_ROLE_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER_ROLE',
        N'CONSTRAINT', N'APP_USER_ROLE_ID_APP_ROLE_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'APP_USER_ROLE_ID_APP_USER_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[APP_USER_ROLE] DROP CONSTRAINT [APP_USER_ROLE_ID_APP_USER_FK]
 GO



ALTER TABLE [ESCRIBE].[APP_USER_ROLE]
 ADD CONSTRAINT [APP_USER_ROLE_ID_APP_USER_FK]
 FOREIGN KEY 
   ([ID_APP_USER])
 REFERENCES 
   [noneprdb].[ESCRIBE].[APP_USER]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.APP_USER_ROLE.APP_USER_ROLE_ID_APP_USER_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'APP_USER_ROLE',
        N'CONSTRAINT', N'APP_USER_ROLE_ID_APP_USER_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'CLAIN_HST_NHIN_PRESCRIBER_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[CLAIM_HISTORY] DROP CONSTRAINT [CLAIN_HST_NHIN_PRESCRIBER_FK]
 GO



ALTER TABLE [ESCRIBE].[CLAIM_HISTORY]
 ADD CONSTRAINT [CLAIN_HST_NHIN_PRESCRIBER_FK]
 FOREIGN KEY 
   ([ID_NHIN_PRESCRIBER])
 REFERENCES 
   [noneprdb].[ESCRIBE].[NHIN_PRESCRIBER]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.CLAIN_HST_NHIN_PRESCRIBER_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'CONSTRAINT', N'CLAIN_HST_NHIN_PRESCRIBER_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'CLAIM_HST_NCPDP_MSG_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[CLAIM_HISTORY] DROP CONSTRAINT [CLAIM_HST_NCPDP_MSG_FK]
 GO



ALTER TABLE [ESCRIBE].[CLAIM_HISTORY]
 ADD CONSTRAINT [CLAIM_HST_NCPDP_MSG_FK]
 FOREIGN KEY 
   ([ID_NCPDP_MESSAGE_CLAIM])
 REFERENCES 
   [noneprdb].[ESCRIBE].[NCPDP_MESSAGES]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.CLAIM_HST_NCPDP_MSG_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'CONSTRAINT', N'CLAIM_HST_NCPDP_MSG_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'CLAIM_HST_NCPDP_MSG_RESP_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[CLAIM_HISTORY] DROP CONSTRAINT [CLAIM_HST_NCPDP_MSG_RESP_FK]
 GO



ALTER TABLE [ESCRIBE].[CLAIM_HISTORY]
 ADD CONSTRAINT [CLAIM_HST_NCPDP_MSG_RESP_FK]
 FOREIGN KEY 
   ([ID_NCPDP_MESSAGE_CLAIM_RESP])
 REFERENCES 
   [noneprdb].[ESCRIBE].[NCPDP_MESSAGES]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.CLAIM_HST_NCPDP_MSG_RESP_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'CONSTRAINT', N'CLAIM_HST_NCPDP_MSG_RESP_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'CLAIM_HST_NCPDP_MSG_REV_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[CLAIM_HISTORY] DROP CONSTRAINT [CLAIM_HST_NCPDP_MSG_REV_FK]
 GO



ALTER TABLE [ESCRIBE].[CLAIM_HISTORY]
 ADD CONSTRAINT [CLAIM_HST_NCPDP_MSG_REV_FK]
 FOREIGN KEY 
   ([ID_NCPDP_MESSAGE_REVERSE])
 REFERENCES 
   [noneprdb].[ESCRIBE].[NCPDP_MESSAGES]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.CLAIM_HST_NCPDP_MSG_REV_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'CONSTRAINT', N'CLAIM_HST_NCPDP_MSG_REV_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'CLAIM_HST_NCPDP_MSG_REV_RES_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[CLAIM_HISTORY] DROP CONSTRAINT [CLAIM_HST_NCPDP_MSG_REV_RES_FK]
 GO



ALTER TABLE [ESCRIBE].[CLAIM_HISTORY]
 ADD CONSTRAINT [CLAIM_HST_NCPDP_MSG_REV_RES_FK]
 FOREIGN KEY 
   ([ID_NCPDP_MESSAGE_REVERSE_RESP])
 REFERENCES 
   [noneprdb].[ESCRIBE].[NCPDP_MESSAGES]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CLAIM_HISTORY.CLAIM_HST_NCPDP_MSG_REV_RES_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CLAIM_HISTORY',
        N'CONSTRAINT', N'CLAIM_HST_NCPDP_MSG_REV_RES_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'CUSTOM_SIGS_ID_NHIN_PRESCR_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[CUSTOM_SIGS] DROP CONSTRAINT [CUSTOM_SIGS_ID_NHIN_PRESCR_FK]
 GO



ALTER TABLE [ESCRIBE].[CUSTOM_SIGS]
 ADD CONSTRAINT [CUSTOM_SIGS_ID_NHIN_PRESCR_FK]
 FOREIGN KEY 
   ([ID_NHIN_PRESCRIBER])
 REFERENCES 
   [noneprdb].[ESCRIBE].[NHIN_PRESCRIBER]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.CUSTOM_SIGS.CUSTOM_SIGS_ID_NHIN_PRESCR_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'CUSTOM_SIGS',
        N'CONSTRAINT', N'CUSTOM_SIGS_ID_NHIN_PRESCR_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MFR_PROG_NDC_LNK_MFR_PROG_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[MFR_PROGRAM_NDC_LINK] DROP CONSTRAINT [MFR_PROG_NDC_LNK_MFR_PROG_FK]
 GO



ALTER TABLE [ESCRIBE].[MFR_PROGRAM_NDC_LINK]
 ADD CONSTRAINT [MFR_PROG_NDC_LNK_MFR_PROG_FK]
 FOREIGN KEY 
   ([ID_MANUFACTURER_PROGRAM])
 REFERENCES 
   [noneprdb].[ESCRIBE].[MANUFACTURER_PROGRAM]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_NDC_LINK.MFR_PROG_NDC_LNK_MFR_PROG_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_NDC_LINK',
        N'CONSTRAINT', N'MFR_PROG_NDC_LNK_MFR_PROG_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MFR_PROG_PHARM_LNK_MFR_PROG_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[MFR_PROGRAM_PHARMACY_LINK] DROP CONSTRAINT [MFR_PROG_PHARM_LNK_MFR_PROG_FK]
 GO



ALTER TABLE [ESCRIBE].[MFR_PROGRAM_PHARMACY_LINK]
 ADD CONSTRAINT [MFR_PROG_PHARM_LNK_MFR_PROG_FK]
 FOREIGN KEY 
   ([ID_MANUFACTURER_PROGRAM])
 REFERENCES 
   [noneprdb].[ESCRIBE].[MANUFACTURER_PROGRAM]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.MFR_PROGRAM_PHARMACY_LINK.MFR_PROG_PHARM_LNK_MFR_PROG_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'MFR_PROGRAM_PHARMACY_LINK',
        N'CONSTRAINT', N'MFR_PROG_PHARM_LNK_MFR_PROG_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NHIN_CLINIC_ID_ADDRESS_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[NHIN_CLINIC] DROP CONSTRAINT [NHIN_CLINIC_ID_ADDRESS_FK]
 GO



ALTER TABLE [ESCRIBE].[NHIN_CLINIC]
 ADD CONSTRAINT [NHIN_CLINIC_ID_ADDRESS_FK]
 FOREIGN KEY 
   ([ID_ADDRESS])
 REFERENCES 
   [noneprdb].[ESCRIBE].[ADDRESS]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_CLINIC.NHIN_CLINIC_ID_ADDRESS_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_CLINIC',
        N'CONSTRAINT', N'NHIN_CLINIC_ID_ADDRESS_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NHIN_PRESCR_REGISTR_ADDRESS_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[NHIN_PRESCRIBER] DROP CONSTRAINT [NHIN_PRESCR_REGISTR_ADDRESS_FK]
 GO



ALTER TABLE [ESCRIBE].[NHIN_PRESCRIBER]
 ADD CONSTRAINT [NHIN_PRESCR_REGISTR_ADDRESS_FK]
 FOREIGN KEY 
   ([ID_REGISTRATION_ADDRESS])
 REFERENCES 
   [noneprdb].[ESCRIBE].[ADDRESS]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER.NHIN_PRESCR_REGISTR_ADDRESS_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER',
        N'CONSTRAINT', N'NHIN_PRESCR_REGISTR_ADDRESS_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NHIN_PRE_CLN_LK_ID_NHIN_CLN_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[NHIN_PRESCRIBER_CLINIC_LINK] DROP CONSTRAINT [NHIN_PRE_CLN_LK_ID_NHIN_CLN_FK]
 GO



ALTER TABLE [ESCRIBE].[NHIN_PRESCRIBER_CLINIC_LINK]
 ADD CONSTRAINT [NHIN_PRE_CLN_LK_ID_NHIN_CLN_FK]
 FOREIGN KEY 
   ([ID_NHIN_CLINIC])
 REFERENCES 
   [noneprdb].[ESCRIBE].[NHIN_CLINIC]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.NHIN_PRE_CLN_LK_ID_NHIN_CLN_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'CONSTRAINT', N'NHIN_PRE_CLN_LK_ID_NHIN_CLN_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'NHIN_PRE_CLN_LK_ID_PRESCR_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[NHIN_PRESCRIBER_CLINIC_LINK] DROP CONSTRAINT [NHIN_PRE_CLN_LK_ID_PRESCR_FK]
 GO



ALTER TABLE [ESCRIBE].[NHIN_PRESCRIBER_CLINIC_LINK]
 ADD CONSTRAINT [NHIN_PRE_CLN_LK_ID_PRESCR_FK]
 FOREIGN KEY 
   ([ID_NHIN_PRESCRIBER])
 REFERENCES 
   [noneprdb].[ESCRIBE].[NHIN_PRESCRIBER]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.NHIN_PRESCRIBER_CLINIC_LINK.NHIN_PRE_CLN_LK_ID_PRESCR_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'NHIN_PRESCRIBER_CLINIC_LINK',
        N'CONSTRAINT', N'NHIN_PRE_CLN_LK_ID_PRESCR_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ORDER_INFO_FK_PRESCWRT'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[ORDER_INFO] DROP CONSTRAINT [ORDER_INFO_FK_PRESCWRT]
 GO



ALTER TABLE [ESCRIBE].[ORDER_INFO]
 ADD CONSTRAINT [ORDER_INFO_FK_PRESCWRT]
 FOREIGN KEY 
   ([ID_PRESCRIPTIONS_WRITTEN])
 REFERENCES 
   [noneprdb].[ESCRIBE].[PRESCRIPTIONS_WRITTEN]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.ORDER_INFO.ORDER_INFO_FK_PRESCWRT',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'ORDER_INFO',
        N'CONSTRAINT', N'ORDER_INFO_FK_PRESCWRT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PASSWRD_HISTORY_ID_APP_USER_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[PASSWORD_HISTORY] DROP CONSTRAINT [PASSWRD_HISTORY_ID_APP_USER_FK]
 GO



ALTER TABLE [ESCRIBE].[PASSWORD_HISTORY]
 ADD CONSTRAINT [PASSWRD_HISTORY_ID_APP_USER_FK]
 FOREIGN KEY 
   ([ID_APP_USER])
 REFERENCES 
   [noneprdb].[ESCRIBE].[APP_USER]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PASSWORD_HISTORY.PASSWRD_HISTORY_ID_APP_USER_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PASSWORD_HISTORY',
        N'CONSTRAINT', N'PASSWRD_HISTORY_ID_APP_USER_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PHARMACY_ID_ADDRESS_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[PHARMACY] DROP CONSTRAINT [PHARMACY_ID_ADDRESS_FK]
 GO



ALTER TABLE [ESCRIBE].[PHARMACY]
 ADD CONSTRAINT [PHARMACY_ID_ADDRESS_FK]
 FOREIGN KEY 
   ([ID_ADDRESS])
 REFERENCES 
   [noneprdb].[ESCRIBE].[ADDRESS]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY.PHARMACY_ID_ADDRESS_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY',
        N'CONSTRAINT', N'PHARMACY_ID_ADDRESS_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PHARM_MEDICAID_ID_ID_PHARM_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[PHARMACY_MEDICAID_IDS] DROP CONSTRAINT [PHARM_MEDICAID_ID_ID_PHARM_FK]
 GO



ALTER TABLE [ESCRIBE].[PHARMACY_MEDICAID_IDS]
 ADD CONSTRAINT [PHARM_MEDICAID_ID_ID_PHARM_FK]
 FOREIGN KEY 
   ([ID_PHARMACY])
 REFERENCES 
   [noneprdb].[ESCRIBE].[PHARMACY]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PHARMACY_MEDICAID_IDS.PHARM_MEDICAID_ID_ID_PHARM_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PHARMACY_MEDICAID_IDS',
        N'CONSTRAINT', N'PHARM_MEDICAID_ID_ID_PHARM_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRES_DRUG_USE_ID_NHIN_PRES_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[PRESCRIBER_DRUG_USAGE] DROP CONSTRAINT [PRES_DRUG_USE_ID_NHIN_PRES_FK]
 GO



ALTER TABLE [ESCRIBE].[PRESCRIBER_DRUG_USAGE]
 ADD CONSTRAINT [PRES_DRUG_USE_ID_NHIN_PRES_FK]
 FOREIGN KEY 
   ([ID_NHIN_PRESCRIBER])
 REFERENCES 
   [noneprdb].[ESCRIBE].[NHIN_PRESCRIBER]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_DRUG_USAGE.PRES_DRUG_USE_ID_NHIN_PRES_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_DRUG_USAGE',
        N'CONSTRAINT', N'PRES_DRUG_USE_ID_NHIN_PRES_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRES_PHARM_USE_ID_NHIN_PRES_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[PRESCRIBER_PHARMACY_USAGE] DROP CONSTRAINT [PRES_PHARM_USE_ID_NHIN_PRES_FK]
 GO



ALTER TABLE [ESCRIBE].[PRESCRIBER_PHARMACY_USAGE]
 ADD CONSTRAINT [PRES_PHARM_USE_ID_NHIN_PRES_FK]
 FOREIGN KEY 
   ([ID_NHIN_PRESCRIBER])
 REFERENCES 
   [noneprdb].[ESCRIBE].[NHIN_PRESCRIBER]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PHARMACY_USAGE.PRES_PHARM_USE_ID_NHIN_PRES_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PHARMACY_USAGE',
        N'CONSTRAINT', N'PRES_PHARM_USE_ID_NHIN_PRES_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRES_PHARM_USE_ID_PHARMACY_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[PRESCRIBER_PHARMACY_USAGE] DROP CONSTRAINT [PRES_PHARM_USE_ID_PHARMACY_FK]
 GO



ALTER TABLE [ESCRIBE].[PRESCRIBER_PHARMACY_USAGE]
 ADD CONSTRAINT [PRES_PHARM_USE_ID_PHARMACY_FK]
 FOREIGN KEY 
   ([ID_PHARMACY])
 REFERENCES 
   [noneprdb].[ESCRIBE].[PHARMACY]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_PHARMACY_USAGE.PRES_PHARM_USE_ID_PHARMACY_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_PHARMACY_USAGE',
        N'CONSTRAINT', N'PRES_PHARM_USE_ID_PHARMACY_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESCR_STATE_ID_NHIN_PRESCR_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[PRESCRIBER_STATE] DROP CONSTRAINT [PRESCR_STATE_ID_NHIN_PRESCR_FK]
 GO



ALTER TABLE [ESCRIBE].[PRESCRIBER_STATE]
 ADD CONSTRAINT [PRESCR_STATE_ID_NHIN_PRESCR_FK]
 FOREIGN KEY 
   ([ID_NHIN_PRESCRIBER])
 REFERENCES 
   [noneprdb].[ESCRIBE].[NHIN_PRESCRIBER]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIBER_STATE.PRESCR_STATE_ID_NHIN_PRESCR_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIBER_STATE',
        N'CONSTRAINT', N'PRESCR_STATE_ID_NHIN_PRESCR_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESC_WRIT_ID_PRESC_CLN_LNK_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[PRESCRIPTIONS_WRITTEN] DROP CONSTRAINT [PRESC_WRIT_ID_PRESC_CLN_LNK_FK]
 GO



ALTER TABLE [ESCRIBE].[PRESCRIPTIONS_WRITTEN]
 ADD CONSTRAINT [PRESC_WRIT_ID_PRESC_CLN_LNK_FK]
 FOREIGN KEY 
   ([ID_NHIN_PRESCRIBER_CLINIC_LINK])
 REFERENCES 
   [noneprdb].[ESCRIBE].[NHIN_PRESCRIBER_CLINIC_LINK]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PRESC_WRIT_ID_PRESC_CLN_LNK_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'CONSTRAINT', N'PRESC_WRIT_ID_PRESC_CLN_LNK_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRESC_WRIT_ID_PHARMACY_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[PRESCRIPTIONS_WRITTEN] DROP CONSTRAINT [PRESC_WRIT_ID_PHARMACY_FK]
 GO



ALTER TABLE [ESCRIBE].[PRESCRIPTIONS_WRITTEN]
 ADD CONSTRAINT [PRESC_WRIT_ID_PHARMACY_FK]
 FOREIGN KEY 
   ([ID_PHARMACY])
 REFERENCES 
   [noneprdb].[ESCRIBE].[PHARMACY]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PRESCRIPTIONS_WRITTEN.PRESC_WRIT_ID_PHARMACY_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PRESCRIPTIONS_WRITTEN',
        N'CONSTRAINT', N'PRESC_WRIT_ID_PHARMACY_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRG_NDC_SHP_OPT_MFR_PRG_NDC_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[PROGRAM_NDC_SHIP_OPTION_LINK] DROP CONSTRAINT [PRG_NDC_SHP_OPT_MFR_PRG_NDC_FK]
 GO



ALTER TABLE [ESCRIBE].[PROGRAM_NDC_SHIP_OPTION_LINK]
 ADD CONSTRAINT [PRG_NDC_SHP_OPT_MFR_PRG_NDC_FK]
 FOREIGN KEY 
   ([ID_MFR_PROGRAM_NDC_LINK])
 REFERENCES 
   [noneprdb].[ESCRIBE].[MFR_PROGRAM_NDC_LINK]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_NDC_SHIP_OPTION_LINK.PRG_NDC_SHP_OPT_MFR_PRG_NDC_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_NDC_SHIP_OPTION_LINK',
        N'CONSTRAINT', N'PRG_NDC_SHP_OPT_MFR_PRG_NDC_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PRG_NDC_SHP_OPT_LNK_MFR_PRG_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[PROGRAM_NDC_SHIP_OPTION_LINK] DROP CONSTRAINT [PRG_NDC_SHP_OPT_LNK_MFR_PRG_FK]
 GO



ALTER TABLE [ESCRIBE].[PROGRAM_NDC_SHIP_OPTION_LINK]
 ADD CONSTRAINT [PRG_NDC_SHP_OPT_LNK_MFR_PRG_FK]
 FOREIGN KEY 
   ([ID_SHIPPING_OPTION])
 REFERENCES 
   [noneprdb].[ESCRIBE].[SHIPPING_OPTION]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_NDC_SHIP_OPTION_LINK.PRG_NDC_SHP_OPT_LNK_MFR_PRG_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_NDC_SHIP_OPTION_LINK',
        N'CONSTRAINT', N'PRG_NDC_SHP_OPT_LNK_MFR_PRG_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PROG_SHIP_OPT_LNK_MFR_PROG_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[PROGRAM_SHIPPING_OPTION_LINK] DROP CONSTRAINT [PROG_SHIP_OPT_LNK_MFR_PROG_FK]
 GO



ALTER TABLE [ESCRIBE].[PROGRAM_SHIPPING_OPTION_LINK]
 ADD CONSTRAINT [PROG_SHIP_OPT_LNK_MFR_PROG_FK]
 FOREIGN KEY 
   ([ID_MANUFACTURER_PROGRAM])
 REFERENCES 
   [noneprdb].[ESCRIBE].[MANUFACTURER_PROGRAM]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_SHIPPING_OPTION_LINK.PROG_SHIP_OPT_LNK_MFR_PROG_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_SHIPPING_OPTION_LINK',
        N'CONSTRAINT', N'PROG_SHIP_OPT_LNK_MFR_PROG_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PROG_SHIP_OPT_LNK_SHIP_OPT_FK'  AND sc.name = N'ESCRIBE'  AND type in (N'F'))
ALTER TABLE [ESCRIBE].[PROGRAM_SHIPPING_OPTION_LINK] DROP CONSTRAINT [PROG_SHIP_OPT_LNK_SHIP_OPT_FK]
 GO



ALTER TABLE [ESCRIBE].[PROGRAM_SHIPPING_OPTION_LINK]
 ADD CONSTRAINT [PROG_SHIP_OPT_LNK_SHIP_OPT_FK]
 FOREIGN KEY 
   ([ID_SHIPPING_OPTION])
 REFERENCES 
   [noneprdb].[ESCRIBE].[SHIPPING_OPTION]     ([ID])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'ESCRIBE.PROGRAM_SHIPPING_OPTION_LINK.PROG_SHIP_OPT_LNK_SHIP_OPT_FK',
        N'SCHEMA', N'ESCRIBE',
        N'TABLE', N'PROGRAM_SHIPPING_OPTION_LINK',
        N'CONSTRAINT', N'PROG_SHIP_OPT_LNK_SHIP_OPT_FK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO



USE noneprdb
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'DIB3_2')      
     EXEC (N'CREATE SCHEMA DIB3_2')                                   
 GO                                                               

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IMGIPT_BASIC'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'IMGIPT_BASIC'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[IMGIPT_BASIC]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[IMGIPT_BASIC]
(
   [CATEGORYID] numeric(5, 0)  NOT NULL,
   [BASICDESCID] numeric(5, 0)  NOT NULL,
   [BASICDESC] varchar(30)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_BASIC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_BASIC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_BASIC.CATEGORYID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_BASIC',
        N'COLUMN', N'CATEGORYID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_BASIC.BASICDESCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_BASIC',
        N'COLUMN', N'BASICDESCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_BASIC.BASICDESC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_BASIC',
        N'COLUMN', N'BASICDESC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IMGIPT_CATEGORY'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'IMGIPT_CATEGORY'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[IMGIPT_CATEGORY]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[IMGIPT_CATEGORY]
(
   [CATEGORYID] numeric(5, 0)  NOT NULL,
   [CATEGORYDESC] varchar(30)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_CATEGORY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_CATEGORY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_CATEGORY.CATEGORYID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_CATEGORY',
        N'COLUMN', N'CATEGORYID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_CATEGORY.CATEGORYDESC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_CATEGORY',
        N'COLUMN', N'CATEGORYDESC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IMGIPT_DESC'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'IMGIPT_DESC'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[IMGIPT_DESC]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[IMGIPT_DESC]
(
   [CATEGORYID] numeric(5, 0)  NOT NULL,
   [DESCRIPTORID] numeric(5, 0)  NOT NULL,
   [BASICDESCID] numeric(5, 0)  NOT NULL,
   [DESCRIPTION] varchar(30)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_DESC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_DESC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_DESC.CATEGORYID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_DESC',
        N'COLUMN', N'CATEGORYID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_DESC.DESCRIPTORID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_DESC',
        N'COLUMN', N'DESCRIPTORID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_DESC.BASICDESCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_DESC',
        N'COLUMN', N'BASICDESCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_DESC.DESCRIPTION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_DESC',
        N'COLUMN', N'DESCRIPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IMGIPT_DOSE_FORM'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'IMGIPT_DOSE_FORM'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[IMGIPT_DOSE_FORM]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[IMGIPT_DOSE_FORM]
(
   [DOSAGEFORMID] numeric(5, 0)  NOT NULL,
   [DOSAGEFORMDESC] varchar(30)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_DOSE_FORM',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_DOSE_FORM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_DOSE_FORM.DOSAGEFORMID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_DOSE_FORM',
        N'COLUMN', N'DOSAGEFORMID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_DOSE_FORM.DOSAGEFORMDESC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_DOSE_FORM',
        N'COLUMN', N'DOSAGEFORMDESC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IMGIPT_IMAGE'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'IMGIPT_IMAGE'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[IMGIPT_IMAGE]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[IMGIPT_IMAGE]
(
   [IMAGEID] numeric(10, 0)  NOT NULL,
   [IMAGEFILE] varchar(20)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_IMAGE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_IMAGE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_IMAGE.IMAGEID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_IMAGE',
        N'COLUMN', N'IMAGEID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_IMAGE.IMAGEFILE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_IMAGE',
        N'COLUMN', N'IMAGEFILE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IMGIPT_IMPRINT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'IMGIPT_IMPRINT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[IMGIPT_IMPRINT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[IMGIPT_IMPRINT]
(
   [PROPERTYID] numeric(10, 0)  NOT NULL,
   [IMPRINTSIDE1] varchar(40)  NOT NULL,
   [IMPRINTSIDE2] varchar(40)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_IMPRINT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_IMPRINT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_IMPRINT.PROPERTYID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_IMPRINT',
        N'COLUMN', N'PROPERTYID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_IMPRINT.IMPRINTSIDE1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_IMPRINT',
        N'COLUMN', N'IMPRINTSIDE1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_IMPRINT.IMPRINTSIDE2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_IMPRINT',
        N'COLUMN', N'IMPRINTSIDE2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IMGIPT_JOURNAL'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'IMGIPT_JOURNAL'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[IMGIPT_JOURNAL]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[IMGIPT_JOURNAL]
(
   [UNIQUEDRUGID] numeric(10, 0)  NOT NULL,
   [STARTDATE] numeric(8, 0)  NOT NULL,
   [STOPDATE] numeric(8, 0)  NULL,
   [PROPERTYID] numeric(10, 0)  NULL,
   [IMAGEID] numeric(10, 0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_JOURNAL',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_JOURNAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_JOURNAL.UNIQUEDRUGID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_JOURNAL',
        N'COLUMN', N'UNIQUEDRUGID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_JOURNAL.STARTDATE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_JOURNAL',
        N'COLUMN', N'STARTDATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_JOURNAL.STOPDATE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_JOURNAL',
        N'COLUMN', N'STOPDATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_JOURNAL.PROPERTYID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_JOURNAL',
        N'COLUMN', N'PROPERTYID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_JOURNAL.IMAGEID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_JOURNAL',
        N'COLUMN', N'IMAGEID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IMGIPT_LIB_VERSION'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'IMGIPT_LIB_VERSION'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[IMGIPT_LIB_VERSION]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[IMGIPT_LIB_VERSION]
(
   [VERSIONKEY] numeric(5, 0)  NOT NULL,
   [DBVERSION] varchar(5)  NULL,
   [BUILDVERSION] varchar(5)  NULL,
   [FREQUENCY] varchar(1)  NULL,
   [ISSUEDATE] varchar(8)  NULL,
   [VERSIONCOMMENT] varchar(80)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_LIB_VERSION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_LIB_VERSION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_LIB_VERSION.VERSIONKEY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_LIB_VERSION',
        N'COLUMN', N'VERSIONKEY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_LIB_VERSION.DBVERSION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_LIB_VERSION',
        N'COLUMN', N'DBVERSION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_LIB_VERSION.BUILDVERSION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_LIB_VERSION',
        N'COLUMN', N'BUILDVERSION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_LIB_VERSION.FREQUENCY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_LIB_VERSION',
        N'COLUMN', N'FREQUENCY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_LIB_VERSION.ISSUEDATE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_LIB_VERSION',
        N'COLUMN', N'ISSUEDATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_LIB_VERSION.VERSIONCOMMENT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_LIB_VERSION',
        N'COLUMN', N'VERSIONCOMMENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IMGIPT_MANUFACT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'IMGIPT_MANUFACT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[IMGIPT_MANUFACT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[IMGIPT_MANUFACT]
(
   [MANUFACTURERID] numeric(10, 0)  NOT NULL,
   [MANUFACTURERNAME] varchar(30)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_MANUFACT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_MANUFACT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_MANUFACT.MANUFACTURERID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_MANUFACT',
        N'COLUMN', N'MANUFACTURERID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_MANUFACT.MANUFACTURERNAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_MANUFACT',
        N'COLUMN', N'MANUFACTURERNAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IMGIPT_PROP_DESC'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'IMGIPT_PROP_DESC'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[IMGIPT_PROP_DESC]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[IMGIPT_PROP_DESC]
(
   [PROPERTYID] numeric(10, 0)  NOT NULL,
   [CATEGORYID] numeric(5, 0)  NOT NULL,
   [DESCRIPTORID] numeric(5, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROP_DESC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROP_DESC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROP_DESC.PROPERTYID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROP_DESC',
        N'COLUMN', N'PROPERTYID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROP_DESC.CATEGORYID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROP_DESC',
        N'COLUMN', N'CATEGORYID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROP_DESC.DESCRIPTORID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROP_DESC',
        N'COLUMN', N'DESCRIPTORID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IMGIPT_PROP_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'IMGIPT_PROP_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[IMGIPT_PROP_TEXT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[IMGIPT_PROP_TEXT]
(
   [PROPERTYID] numeric(10, 0)  NOT NULL,
   [TEXTID] numeric(10, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROP_TEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROP_TEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROP_TEXT.PROPERTYID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROP_TEXT',
        N'COLUMN', N'PROPERTYID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROP_TEXT.TEXTID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROP_TEXT',
        N'COLUMN', N'TEXTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IMGIPT_PROPERTY'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'IMGIPT_PROPERTY'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[IMGIPT_PROPERTY]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[IMGIPT_PROPERTY]
(
   [PROPERTYID] numeric(10, 0)  NOT NULL,
   [IMPRINTSIDE1] varchar(40)  NULL,
   [IMPRINTSIDE2] varchar(40)  NULL,
   [COLOR1ID] numeric(5, 0)  NULL,
   [COLOR2ID] numeric(5, 0)  NULL,
   [COLOR3ID] numeric(5, 0)  NULL,
   [BASICCOLOR1ID] numeric(5, 0)  NULL,
   [BASICCOLOR2ID] numeric(5, 0)  NULL,
   [BASICCOLOR3ID] numeric(5, 0)  NULL,
   [COATINGID] numeric(5, 0)  NULL,
   [CLARITYID] numeric(5, 0)  NULL,
   [FLAVORID] numeric(5, 0)  NULL,
   [SHAPEID] numeric(5, 0)  NULL,
   [BASICSHAPEID] numeric(5, 0)  NULL,
   [SCOREID] numeric(5, 0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.PROPERTYID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'COLUMN', N'PROPERTYID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.IMPRINTSIDE1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'COLUMN', N'IMPRINTSIDE1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.IMPRINTSIDE2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'COLUMN', N'IMPRINTSIDE2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.COLOR1ID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'COLUMN', N'COLOR1ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.COLOR2ID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'COLUMN', N'COLOR2ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.COLOR3ID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'COLUMN', N'COLOR3ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.BASICCOLOR1ID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'COLUMN', N'BASICCOLOR1ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.BASICCOLOR2ID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'COLUMN', N'BASICCOLOR2ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.BASICCOLOR3ID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'COLUMN', N'BASICCOLOR3ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.COATINGID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'COLUMN', N'COATINGID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.CLARITYID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'COLUMN', N'CLARITYID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.FLAVORID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'COLUMN', N'FLAVORID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.SHAPEID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'COLUMN', N'SHAPEID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.BASICSHAPEID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'COLUMN', N'BASICSHAPEID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.SCOREID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'COLUMN', N'SCOREID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IMGIPT_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'IMGIPT_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[IMGIPT_TEXT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[IMGIPT_TEXT]
(
   [TEXTID] numeric(10, 0)  NOT NULL,
   [LINENUMBER] numeric(3, 0)  NOT NULL,
   [TEXT] varchar(70)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_TEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_TEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_TEXT.TEXTID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_TEXT',
        N'COLUMN', N'TEXTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_TEXT.LINENUMBER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_TEXT',
        N'COLUMN', N'LINENUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_TEXT.TEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_TEXT',
        N'COLUMN', N'TEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IMGIPT_UNIQUE'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'IMGIPT_UNIQUE'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[IMGIPT_UNIQUE]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[IMGIPT_UNIQUE]
(
   [UNIQUEDRUGID] numeric(10, 0)  NOT NULL,
   [DOSAGEFORMID] numeric(5, 0)  NOT NULL,
   [EXTERNALDRUGID] varchar(20)  NOT NULL,
   [MANUFACTURERID] numeric(10, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_UNIQUE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_UNIQUE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_UNIQUE.UNIQUEDRUGID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_UNIQUE',
        N'COLUMN', N'UNIQUEDRUGID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_UNIQUE.DOSAGEFORMID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_UNIQUE',
        N'COLUMN', N'DOSAGEFORMID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_UNIQUE.EXTERNALDRUGID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_UNIQUE',
        N'COLUMN', N'EXTERNALDRUGID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_UNIQUE.MANUFACTURERID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_UNIQUE',
        N'COLUMN', N'MANUFACTURERID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_ADE_COM'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_ADE_COM'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_ADE_COM]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_ADE_COM]
(
   [GPI] varchar(14)  NOT NULL,
   [MCID] numeric(38, 0)  NOT NULL,
   [RESTRICTIONID] numeric(38, 0)  NOT NULL,
   [SEQUENCENUMBER] numeric(38, 0)  NOT NULL,
   [TEXTID] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_COM',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_COM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_COM.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_COM',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_COM.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_COM',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_COM.RESTRICTIONID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_COM',
        N'COLUMN', N'RESTRICTIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_COM.SEQUENCENUMBER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_COM',
        N'COLUMN', N'SEQUENCENUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_COM.TEXTID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_COM',
        N'COLUMN', N'TEXTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_ADE_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_ADE_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_ADE_DRUGLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_ADE_DRUGLINK]
(
   [GPI] varchar(14)  NOT NULL,
   [MCID] numeric(38, 0)  NOT NULL,
   [RESTRICTIONID] numeric(38, 0)  NOT NULL,
   [SEVERITYCODE] varchar(2)  NOT NULL,
   [ONSETCODE] varchar(2)  NOT NULL,
   [INCIDENCECODE] varchar(2)  NOT NULL,
   [DOCLEVELCODE] varchar(2)  NOT NULL,
   [TYPECODE] varchar(2)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_DRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_DRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_DRUGLINK.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_DRUGLINK',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_DRUGLINK.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_DRUGLINK',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_DRUGLINK.RESTRICTIONID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_DRUGLINK',
        N'COLUMN', N'RESTRICTIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_DRUGLINK.SEVERITYCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_DRUGLINK',
        N'COLUMN', N'SEVERITYCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_DRUGLINK.ONSETCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_DRUGLINK',
        N'COLUMN', N'ONSETCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_DRUGLINK.INCIDENCECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_DRUGLINK',
        N'COLUMN', N'INCIDENCECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_DRUGLINK.DOCLEVELCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_DRUGLINK',
        N'COLUMN', N'DOCLEVELCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_DRUGLINK.TYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_DRUGLINK',
        N'COLUMN', N'TYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_ADE_SPECCOND'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_ADE_SPECCOND'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_ADE_SPECCOND]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_ADE_SPECCOND]
(
   [GPI] varchar(14)  NOT NULL,
   [MCID] numeric(38, 0)  NOT NULL,
   [RESTRICTIONID] numeric(38, 0)  NOT NULL,
   [SPECCONDID] numeric(38, 0)  NOT NULL,
   [INCIDENCECODE] varchar(2)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_SPECCOND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_SPECCOND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_SPECCOND.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_SPECCOND',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_SPECCOND.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_SPECCOND',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_SPECCOND.RESTRICTIONID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_SPECCOND',
        N'COLUMN', N'RESTRICTIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_SPECCOND.SPECCONDID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_SPECCOND',
        N'COLUMN', N'SPECCONDID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_SPECCOND.INCIDENCECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_SPECCOND',
        N'COLUMN', N'INCIDENCECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_CLS_AHFS'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_CLS_AHFS'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_CLS_AHFS]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_CLS_AHFS]
(
   [CLASSID] varchar(6)  NOT NULL,
   [DESCDISPLAY] varchar(65)  NOT NULL,
   [DESCSEARCH] varchar(65)  NOT NULL,
   [DESCPHONETIC] varchar(65)  NOT NULL,
   [PARENTCLASSID] varchar(6)  NULL,
   [HASCHILDRENIND] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFS',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFS.CLASSID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFS',
        N'COLUMN', N'CLASSID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFS.DESCDISPLAY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFS',
        N'COLUMN', N'DESCDISPLAY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFS.DESCSEARCH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFS',
        N'COLUMN', N'DESCSEARCH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFS.DESCPHONETIC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFS',
        N'COLUMN', N'DESCPHONETIC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFS.PARENTCLASSID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFS',
        N'COLUMN', N'PARENTCLASSID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFS.HASCHILDRENIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFS',
        N'COLUMN', N'HASCHILDRENIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_CLS_AHFSDRUG'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_CLS_AHFSDRUG'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_CLS_AHFSDRUG]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_CLS_AHFSDRUG]
(
   [CLASSID] varchar(6)  NOT NULL,
   [DRUGTYPE] numeric(38, 0)  NOT NULL,
   [DRUGID] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFSDRUG',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFSDRUG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFSDRUG.CLASSID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFSDRUG',
        N'COLUMN', N'CLASSID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFSDRUG.DRUGTYPE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFSDRUG',
        N'COLUMN', N'DRUGTYPE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFSDRUG.DRUGID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFSDRUG',
        N'COLUMN', N'DRUGID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_CLS_GPI'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_CLS_GPI'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_CLS_GPI]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_CLS_GPI]
(
   [CLASSID] varchar(6)  NOT NULL,
   [DESCDISPLAY] varchar(65)  NOT NULL,
   [DESCSEARCH] varchar(65)  NOT NULL,
   [DESCPHONETIC] varchar(65)  NOT NULL,
   [PARENTCLASSID] varchar(6)  NULL,
   [HASCHILDRENIND] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPI.CLASSID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPI',
        N'COLUMN', N'CLASSID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPI.DESCDISPLAY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPI',
        N'COLUMN', N'DESCDISPLAY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPI.DESCSEARCH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPI',
        N'COLUMN', N'DESCSEARCH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPI.DESCPHONETIC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPI',
        N'COLUMN', N'DESCPHONETIC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPI.PARENTCLASSID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPI',
        N'COLUMN', N'PARENTCLASSID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPI.HASCHILDRENIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPI',
        N'COLUMN', N'HASCHILDRENIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_CLS_GPIDRUG'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_CLS_GPIDRUG'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_CLS_GPIDRUG]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_CLS_GPIDRUG]
(
   [CLASSID] varchar(6)  NOT NULL,
   [DRUGTYPE] numeric(38, 0)  NOT NULL,
   [DRUGID] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPIDRUG',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPIDRUG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPIDRUG.CLASSID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPIDRUG',
        N'COLUMN', N'CLASSID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPIDRUG.DRUGTYPE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPIDRUG',
        N'COLUMN', N'DRUGTYPE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPIDRUG.DRUGID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPIDRUG',
        N'COLUMN', N'DRUGID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_CM_DISPLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_CM_DISPLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_CM_DISPLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_CM_DISPLINK]
(
   [DDID] numeric(38, 0)  NOT NULL,
   [CMID] varchar(3)  NOT NULL,
   [PRIORITY] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_DISPLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_DISPLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_DISPLINK.DDID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_DISPLINK',
        N'COLUMN', N'DDID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_DISPLINK.CMID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_DISPLINK',
        N'COLUMN', N'CMID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_DISPLINK.PRIORITY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_DISPLINK',
        N'COLUMN', N'PRIORITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_CM_PACKLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_CM_PACKLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_CM_PACKLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_CM_PACKLINK]
(
   [PPID] varchar(20)  NOT NULL,
   [CMID] varchar(3)  NOT NULL,
   [PRIORITY] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_PACKLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_PACKLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_PACKLINK.PPID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_PACKLINK',
        N'COLUMN', N'PPID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_PACKLINK.CMID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_PACKLINK',
        N'COLUMN', N'CMID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_PACKLINK.PRIORITY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_PACKLINK',
        N'COLUMN', N'PRIORITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_CM_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_CM_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_CM_TEXT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_CM_TEXT]
(
   [VERSIONCODE] varchar(10)  NOT NULL,
   [CMID] varchar(3)  NOT NULL,
   [PROFMSG1] varchar(34)  NULL,
   [PROFMSG2] varchar(34)  NULL,
   [PATMSG1] varchar(25)  NULL,
   [PATMSG2] varchar(25)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_TEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_TEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_TEXT.VERSIONCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_TEXT',
        N'COLUMN', N'VERSIONCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_TEXT.CMID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_TEXT',
        N'COLUMN', N'CMID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_TEXT.PROFMSG1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_TEXT',
        N'COLUMN', N'PROFMSG1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_TEXT.PROFMSG2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_TEXT',
        N'COLUMN', N'PROFMSG2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_TEXT.PATMSG1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_TEXT',
        N'COLUMN', N'PATMSG1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_TEXT.PATMSG2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_TEXT',
        N'COLUMN', N'PATMSG2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DCK_COM'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DCK_COM'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DCK_COM]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DCK_COM]
(
   [GPI] varchar(14)  NOT NULL,
   [AGEINDAYSLOW] numeric(38, 0)  NOT NULL,
   [AGEINDAYSHIGH] numeric(38, 0)  NOT NULL,
   [EFFECTCODE] varchar(2)  NOT NULL,
   [COMMENTCODE] varchar(3)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_COM',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_COM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_COM.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_COM',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_COM.AGEINDAYSLOW',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_COM',
        N'COLUMN', N'AGEINDAYSLOW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_COM.AGEINDAYSHIGH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_COM',
        N'COLUMN', N'AGEINDAYSHIGH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_COM.EFFECTCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_COM',
        N'COLUMN', N'EFFECTCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_COM.COMMENTCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_COM',
        N'COLUMN', N'COMMENTCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DCK_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DCK_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DCK_DRUGLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DCK_DRUGLINK]
(
   [GPI] varchar(14)  NOT NULL,
   [AGEINDAYSLOW] numeric(38, 0)  NOT NULL,
   [AGEINDAYSHIGH] numeric(38, 0)  NOT NULL,
   [DOSEFORMLOW] numeric(6, 2)  NOT NULL,
   [DOSEFORMHIGH] numeric(6, 2)  NOT NULL,
   [DOSEFORMUSUAL] numeric(6, 2)  NULL,
   [SINGLEDOSEHIGH] numeric(6, 2)  NULL,
   [DURATIONLOW] numeric(38, 0)  NOT NULL,
   [DURATIONHIGH] numeric(38, 0)  NULL,
   [DURATIONUSUAL] numeric(38, 0)  NULL,
   [REFERENCECODE] varchar(3)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_DRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_DRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_DRUGLINK.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_DRUGLINK',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_DRUGLINK.AGEINDAYSLOW',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_DRUGLINK',
        N'COLUMN', N'AGEINDAYSLOW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_DRUGLINK.AGEINDAYSHIGH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_DRUGLINK',
        N'COLUMN', N'AGEINDAYSHIGH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_DRUGLINK.DOSEFORMLOW',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_DRUGLINK',
        N'COLUMN', N'DOSEFORMLOW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_DRUGLINK.DOSEFORMHIGH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_DRUGLINK',
        N'COLUMN', N'DOSEFORMHIGH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_DRUGLINK.DOSEFORMUSUAL',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_DRUGLINK',
        N'COLUMN', N'DOSEFORMUSUAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_DRUGLINK.SINGLEDOSEHIGH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_DRUGLINK',
        N'COLUMN', N'SINGLEDOSEHIGH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_DRUGLINK.DURATIONLOW',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_DRUGLINK',
        N'COLUMN', N'DURATIONLOW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_DRUGLINK.DURATIONHIGH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_DRUGLINK',
        N'COLUMN', N'DURATIONHIGH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_DRUGLINK.DURATIONUSUAL',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_DRUGLINK',
        N'COLUMN', N'DURATIONUSUAL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_DRUGLINK.REFERENCECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_DRUGLINK',
        N'COLUMN', N'REFERENCECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DFA_INT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DFA_INT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DFA_INT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DFA_INT]
(
   [DRUGCLASSID] varchar(5)  NOT NULL,
   [FOODCLASSID] varchar(5)  NOT NULL,
   [DRUGACTCODE] varchar(1)  NOT NULL,
   [DRUGDURATION] numeric(38, 0)  NOT NULL,
   [FOODDURATION] numeric(38, 0)  NOT NULL,
   [DRUGSCHREGIND] numeric(38, 0)  NOT NULL,
   [DRUGSCHASNEEDIND] numeric(38, 0)  NOT NULL,
   [DRUGSCHSINGLEIND] numeric(38, 0)  NOT NULL,
   [FOODSCHREGIND] numeric(38, 0)  NOT NULL,
   [FOODSCHASNEEDIND] numeric(38, 0)  NOT NULL,
   [FOODSCHSINGLEIND] numeric(38, 0)  NOT NULL,
   [ONSETCODE] varchar(1)  NOT NULL,
   [SEVERITYCODE] varchar(1)  NOT NULL,
   [DOCLEVELCODE] varchar(1)  NOT NULL,
   [DRUGCLASSNAME] varchar(75)  NOT NULL,
   [FOODCLASSNAME] varchar(75)  NOT NULL,
   [MONOID] varchar(20)  NOT NULL,
   [ALCOHOLIND] numeric(38, 0)  NOT NULL,
   [CLASS1FOODIND] numeric(38, 0)  NOT NULL,
   [MGMTCODE] varchar(1)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.DRUGCLASSID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'DRUGCLASSID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.FOODCLASSID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'FOODCLASSID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.DRUGACTCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'DRUGACTCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.DRUGDURATION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'DRUGDURATION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.FOODDURATION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'FOODDURATION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.DRUGSCHREGIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'DRUGSCHREGIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.DRUGSCHASNEEDIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'DRUGSCHASNEEDIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.DRUGSCHSINGLEIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'DRUGSCHSINGLEIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.FOODSCHREGIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'FOODSCHREGIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.FOODSCHASNEEDIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'FOODSCHASNEEDIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.FOODSCHSINGLEIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'FOODSCHSINGLEIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.ONSETCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'ONSETCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.SEVERITYCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'SEVERITYCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.DOCLEVELCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'DOCLEVELCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.DRUGCLASSNAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'DRUGCLASSNAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.FOODCLASSNAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'FOODCLASSNAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.MONOID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'MONOID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.ALCOHOLIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'ALCOHOLIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.CLASS1FOODIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'CLASS1FOODIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.MGMTCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'COLUMN', N'MGMTCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DFA_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DFA_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DFA_TEXT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DFA_TEXT]
(
   [VERSION] varchar(10)  NOT NULL,
   [DRUGCLASSID] varchar(5)  NOT NULL,
   [FOODCLASSID] varchar(5)  NOT NULL,
   [LINENUMBER] numeric(38, 0)  NOT NULL,
   [LINETEXT] varchar(255)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_TEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_TEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_TEXT.VERSION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_TEXT',
        N'COLUMN', N'VERSION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_TEXT.DRUGCLASSID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_TEXT',
        N'COLUMN', N'DRUGCLASSID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_TEXT.FOODCLASSID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_TEXT',
        N'COLUMN', N'FOODCLASSID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_TEXT.LINENUMBER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_TEXT',
        N'COLUMN', N'LINENUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_TEXT.LINETEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_TEXT',
        N'COLUMN', N'LINETEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DI_CLASSLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DI_CLASSLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DI_CLASSLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DI_CLASSLINK]
(
   [KDC1] varchar(5)  NOT NULL,
   [CLASSID] varchar(5)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_CLASSLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_CLASSLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_CLASSLINK.KDC1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_CLASSLINK',
        N'COLUMN', N'KDC1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_CLASSLINK.CLASSID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_CLASSLINK',
        N'COLUMN', N'CLASSID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DI_INT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DI_INT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DI_INT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DI_INT]
(
   [CLASSID1] varchar(5)  NOT NULL,
   [CLASSID2] varchar(5)  NOT NULL,
   [ACTCODE1] varchar(1)  NOT NULL,
   [ACTCODE2] varchar(1)  NOT NULL,
   [DURATION1] numeric(38, 0)  NOT NULL,
   [DURATION2] numeric(38, 0)  NOT NULL,
   [SCHEDREG1IND] numeric(38, 0)  NOT NULL,
   [SCHEDASNEEDED1IND] numeric(38, 0)  NOT NULL,
   [SCHEDSINGLE1IND] numeric(38, 0)  NOT NULL,
   [SCHEDREG2IND] numeric(38, 0)  NOT NULL,
   [SCHEDASNEEDED2IND] numeric(38, 0)  NOT NULL,
   [SCHEDSINGLE2IND] numeric(38, 0)  NOT NULL,
   [ONSETCODE] varchar(1)  NOT NULL,
   [SEVERITYCODE] varchar(1)  NOT NULL,
   [DOCLEVELCODE] varchar(1)  NOT NULL,
   [CLASS1NAME] varchar(75)  NOT NULL,
   [CLASS2NAME] varchar(75)  NOT NULL,
   [MONOID] varchar(20)  NOT NULL,
   [SCREENINGIND] numeric(38, 0)  NOT NULL,
   [MGMTCODE] varchar(1)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.CLASSID1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'CLASSID1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.CLASSID2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'CLASSID2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.ACTCODE1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'ACTCODE1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.ACTCODE2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'ACTCODE2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.DURATION1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'DURATION1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.DURATION2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'DURATION2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.SCHEDREG1IND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'SCHEDREG1IND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.SCHEDASNEEDED1IND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'SCHEDASNEEDED1IND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.SCHEDSINGLE1IND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'SCHEDSINGLE1IND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.SCHEDREG2IND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'SCHEDREG2IND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.SCHEDASNEEDED2IND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'SCHEDASNEEDED2IND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.SCHEDSINGLE2IND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'SCHEDSINGLE2IND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.ONSETCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'ONSETCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.SEVERITYCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'SEVERITYCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.DOCLEVELCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'DOCLEVELCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.CLASS1NAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'CLASS1NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.CLASS2NAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'CLASS2NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.MONOID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'MONOID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.SCREENINGIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'SCREENINGIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.MGMTCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'COLUMN', N'MGMTCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DI_RPIDLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DI_RPIDLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DI_RPIDLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DI_RPIDLINK]
(
   [KDC1] varchar(5)  NOT NULL,
   [NAMETYPECODE] varchar(1)  NOT NULL,
   [RPID] numeric(38, 0)  NOT NULL,
   [DESCRIPTION] varchar(65)  NULL,
   [ACTCODE] varchar(1)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_RPIDLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_RPIDLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_RPIDLINK.KDC1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_RPIDLINK',
        N'COLUMN', N'KDC1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_RPIDLINK.NAMETYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_RPIDLINK',
        N'COLUMN', N'NAMETYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_RPIDLINK.RPID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_RPIDLINK',
        N'COLUMN', N'RPID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_RPIDLINK.DESCRIPTION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_RPIDLINK',
        N'COLUMN', N'DESCRIPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_RPIDLINK.ACTCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_RPIDLINK',
        N'COLUMN', N'ACTCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DI_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DI_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DI_TEXT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DI_TEXT]
(
   [VERSION] varchar(10)  NOT NULL,
   [CLASSID1] varchar(5)  NOT NULL,
   [CLASSID2] varchar(5)  NOT NULL,
   [LINENUMBER] numeric(38, 0)  NOT NULL,
   [LINETEXT] varchar(255)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_TEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_TEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_TEXT.VERSION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_TEXT',
        N'COLUMN', N'VERSION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_TEXT.CLASSID1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_TEXT',
        N'COLUMN', N'CLASSID1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_TEXT.CLASSID2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_TEXT',
        N'COLUMN', N'CLASSID2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_TEXT.LINENUMBER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_TEXT',
        N'COLUMN', N'LINENUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_TEXT.LINETEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_TEXT',
        N'COLUMN', N'LINETEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DRUG_DISP'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DRUG_DISP'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DRUG_DISP]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DRUG_DISP]
(
   [DDID] numeric(38, 0)  NOT NULL,
   [DESCDISPLAY] varchar(125)  NOT NULL,
   [DESCSEARCH] varchar(125)  NOT NULL,
   [DESCPHONETIC] varchar(125)  NOT NULL,
   [RTID] numeric(38, 0)  NOT NULL,
   [DFID] numeric(38, 0)  NOT NULL,
   [STRENGTH] varchar(15)  NULL,
   [STRENGTHUNIT] varchar(10)  NULL,
   [RPID] numeric(38, 0)  NOT NULL,
   [PNID] numeric(38, 0)  NOT NULL,
   [BIOEQUIVCODE] varchar(1)  NOT NULL,
   [CTRLSUBSTANCECODE] varchar(1)  NOT NULL,
   [EFFICACYCODE] varchar(1)  NULL,
   [RXOTCCODE] varchar(1)  NOT NULL,
   [GENERICCODE] varchar(1)  NOT NULL,
   [NAMETYPECODE] varchar(1)  NOT NULL,
   [NAMESOURCECODE] varchar(1)  NOT NULL,
   [GPI] varchar(14)  NULL,
   [PARTIALGPIIND] numeric(38, 0)  NOT NULL,
   [KDC] varchar(10)  NULL,
   [KDCFLAG] varchar(1)  NULL,
   [ACTCODE] varchar(1)  NULL,
   [SINGLEINGRIND] numeric(38, 0)  NOT NULL,
   [MEDDEVIND] numeric(38, 0)  NOT NULL,
   [HASPACKDRUGIND] numeric(38, 0)  NOT NULL,
   [HASEQVPACKDRUGIND] numeric(38, 0)  NOT NULL,
   [HASIMAGEIND] numeric(38, 0)  NOT NULL,
   [CMMULTIND] numeric(38, 0)  NOT NULL,
   [DOSECHEKUNIT] varchar(20)  NULL,
   [HISTORICALIND] numeric(38, 0)  NOT NULL,
   [OBSOLETEDATE] varchar(8)  NULL,
   [SCREENCLEANADE] numeric(38, 0)  NULL,
   [SCREENCLEANPRC] numeric(38, 0)  NULL,
   [SCREENCLEANDFA] numeric(38, 0)  NULL,
   [SCREENCLEANDI] numeric(38, 0)  NULL,
   [SCREENCLEANDC] numeric(38, 0)  NULL,
   [SCREENCLEANDDA] numeric(38, 0)  NULL,
   [REPACKCODE] numeric(38, 0)  NULL,
   [PRIVATELABELERCODE] numeric(38, 0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.DDID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'DDID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.DESCDISPLAY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'DESCDISPLAY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.DESCSEARCH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'DESCSEARCH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.DESCPHONETIC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'DESCPHONETIC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.RTID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'RTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.DFID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'DFID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.STRENGTH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'STRENGTH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.STRENGTHUNIT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'STRENGTHUNIT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.RPID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'RPID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.PNID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'PNID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.BIOEQUIVCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'BIOEQUIVCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.CTRLSUBSTANCECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'CTRLSUBSTANCECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.EFFICACYCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'EFFICACYCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.RXOTCCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'RXOTCCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.GENERICCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'GENERICCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.NAMETYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'NAMETYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.NAMESOURCECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'NAMESOURCECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.PARTIALGPIIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'PARTIALGPIIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.KDC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'KDC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.KDCFLAG',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'KDCFLAG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.ACTCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'ACTCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.SINGLEINGRIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'SINGLEINGRIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.MEDDEVIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'MEDDEVIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.HASPACKDRUGIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'HASPACKDRUGIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.HASEQVPACKDRUGIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'HASEQVPACKDRUGIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.HASIMAGEIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'HASIMAGEIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.CMMULTIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'CMMULTIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.DOSECHEKUNIT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'DOSECHEKUNIT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.HISTORICALIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'HISTORICALIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.OBSOLETEDATE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'OBSOLETEDATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.SCREENCLEANADE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'SCREENCLEANADE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.SCREENCLEANPRC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'SCREENCLEANPRC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.SCREENCLEANDFA',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'SCREENCLEANDFA'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.SCREENCLEANDI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'SCREENCLEANDI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.SCREENCLEANDC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'SCREENCLEANDC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.SCREENCLEANDDA',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'SCREENCLEANDDA'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.REPACKCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'REPACKCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.PRIVATELABELERCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'COLUMN', N'PRIVATELABELERCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DRUG_DISP_LBLR'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DRUG_DISP_LBLR'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DRUG_DISP_LBLR]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DRUG_DISP_LBLR]
(
   [DDID] numeric(38, 0)  NOT NULL,
   [LABELERID] varchar(5)  NOT NULL,
   [REFREPACKCODE] varchar(1)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP_LBLR',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP_LBLR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP_LBLR.DDID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP_LBLR',
        N'COLUMN', N'DDID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP_LBLR.LABELERID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP_LBLR',
        N'COLUMN', N'LABELERID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP_LBLR.REFREPACKCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP_LBLR',
        N'COLUMN', N'REFREPACKCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DRUG_DOSEFORM'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DRUG_DOSEFORM'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DRUG_DOSEFORM]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DRUG_DOSEFORM]
(
   [DFID] numeric(38, 0)  NOT NULL,
   [DESCRIPTION] varchar(40)  NOT NULL,
   [ABBREV] varchar(4)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DOSEFORM',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DOSEFORM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DOSEFORM.DFID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DOSEFORM',
        N'COLUMN', N'DFID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DOSEFORM.DESCRIPTION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DOSEFORM',
        N'COLUMN', N'DESCRIPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DOSEFORM.ABBREV',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DOSEFORM',
        N'COLUMN', N'ABBREV'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DRUG_GPI'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DRUG_GPI'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DRUG_GPI]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DRUG_GPI]
(
   [GPI] varchar(14)  NOT NULL,
   [DESCRIPTION] varchar(60)  NULL,
   [GENERICDDID] numeric(38, 0)  NULL,
   [DOSECHEKUNIT] varchar(20)  NULL,
   [DDASINGLEROUTE] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_GPI.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_GPI',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_GPI.DESCRIPTION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_GPI',
        N'COLUMN', N'DESCRIPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_GPI.GENERICDDID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_GPI',
        N'COLUMN', N'GENERICDDID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_GPI.DOSECHEKUNIT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_GPI',
        N'COLUMN', N'DOSECHEKUNIT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_GPI.DDASINGLEROUTE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_GPI',
        N'COLUMN', N'DDASINGLEROUTE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DRUG_GPILINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DRUG_GPILINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DRUG_GPILINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DRUG_GPILINK]
(
   [DRUGID] varchar(16)  NOT NULL,
   [GPI] varchar(14)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_GPILINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_GPILINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_GPILINK.DRUGID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_GPILINK',
        N'COLUMN', N'DRUGID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_GPILINK.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_GPILINK',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DRUG_KDC'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DRUG_KDC'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DRUG_KDC]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DRUG_KDC]
(
   [KDC1] varchar(5)  NOT NULL,
   [DESCRIPTION] varchar(50)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_KDC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_KDC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_KDC.KDC1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_KDC',
        N'COLUMN', N'KDC1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_KDC.DESCRIPTION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_KDC',
        N'COLUMN', N'DESCRIPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DRUG_KDCLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DRUG_KDCLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DRUG_KDCLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DRUG_KDCLINK]
(
   [DRUGID] varchar(12)  NOT NULL,
   [KDC1] varchar(5)  NOT NULL,
   [RPID] numeric(38, 0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_KDCLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_KDCLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_KDCLINK.DRUGID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_KDCLINK',
        N'COLUMN', N'DRUGID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_KDCLINK.KDC1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_KDCLINK',
        N'COLUMN', N'KDC1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_KDCLINK.RPID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_KDCLINK',
        N'COLUMN', N'RPID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DRUG_LABELER'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DRUG_LABELER'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DRUG_LABELER]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DRUG_LABELER]
(
   [LABELERID] varchar(5)  NOT NULL,
   [NAMEFULL] varchar(30)  NOT NULL,
   [NAMEABBREV] varchar(10)  NOT NULL,
   [TYPECODE] varchar(1)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_LABELER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_LABELER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_LABELER.LABELERID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_LABELER',
        N'COLUMN', N'LABELERID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_LABELER.NAMEFULL',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_LABELER',
        N'COLUMN', N'NAMEFULL'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_LABELER.NAMEABBREV',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_LABELER',
        N'COLUMN', N'NAMEABBREV'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_LABELER.TYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_LABELER',
        N'COLUMN', N'TYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DRUG_NAME'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DRUG_NAME'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DRUG_NAME]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DRUG_NAME]
(
   [PNID] numeric(38, 0)  NOT NULL,
   [DESCDISPLAY] varchar(35)  NOT NULL,
   [DESCSEARCH] varchar(35)  NOT NULL,
   [DESCPHONETIC] varchar(35)  NOT NULL,
   [RPIDUNIQUE] numeric(38, 0)  NULL,
   [DDIDUNIQUE] numeric(38, 0)  NULL,
   [NAMETYPECODE] varchar(1)  NOT NULL,
   [RXOTCCODE] varchar(1)  NULL,
   [SINGLEINGRIND] numeric(38, 0)  NOT NULL,
   [MEDDEVIND] numeric(38, 0)  NOT NULL,
   [HASPACKDRUGIND] numeric(38, 0)  NOT NULL,
   [HASEQVPACKDRUGIND] numeric(38, 0)  NOT NULL,
   [HASKDCIND] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.PNID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'COLUMN', N'PNID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.DESCDISPLAY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'COLUMN', N'DESCDISPLAY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.DESCSEARCH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'COLUMN', N'DESCSEARCH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.DESCPHONETIC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'COLUMN', N'DESCPHONETIC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.RPIDUNIQUE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'COLUMN', N'RPIDUNIQUE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.DDIDUNIQUE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'COLUMN', N'DDIDUNIQUE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.NAMETYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'COLUMN', N'NAMETYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.RXOTCCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'COLUMN', N'RXOTCCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.SINGLEINGRIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'COLUMN', N'SINGLEINGRIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.MEDDEVIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'COLUMN', N'MEDDEVIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.HASPACKDRUGIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'COLUMN', N'HASPACKDRUGIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.HASEQVPACKDRUGIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'COLUMN', N'HASEQVPACKDRUGIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.HASKDCIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'COLUMN', N'HASKDCIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DRUG_PACK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DRUG_PACK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DRUG_PACK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DRUG_PACK]
(
   [PPID] varchar(20)  NOT NULL,
   [DDID] numeric(38, 0)  NOT NULL,
   [RTID] numeric(38, 0)  NOT NULL,
   [DFID] numeric(38, 0)  NOT NULL,
   [STRENGTH] varchar(15)  NULL,
   [STRENGTHUNIT] varchar(15)  NULL,
   [TEECODE] varchar(2)  NOT NULL,
   [DEACLASSCODE] varchar(1)  NULL,
   [DESICODE] varchar(1)  NULL,
   [RXOTCCODE] varchar(1)  NOT NULL,
   [GPPC] varchar(8)  NOT NULL,
   [OLDPPID] varchar(20)  NULL,
   [NEWPPID] varchar(20)  NULL,
   [REPACKIND] numeric(38, 0)  NOT NULL,
   [IDFORMATCODE] varchar(1)  NOT NULL,
   [THIRDPRTYRESTRCODE] varchar(1)  NULL,
   [KDC] varchar(10)  NULL,
   [LABELERID] varchar(5)  NOT NULL,
   [MULTISOURCECODE] varchar(1)  NOT NULL,
   [NAMETYPECODE] varchar(1)  NOT NULL,
   [INNERPACKIND] numeric(38, 0)  NOT NULL,
   [CLINICPACKIND] numeric(38, 0)  NOT NULL,
   [REIMBURSEMENTCODE] varchar(1)  NOT NULL,
   [PRICESPREADCODE] varchar(1)  NOT NULL,
   [GPI] varchar(14)  NOT NULL,
   [PACKSIZE] numeric(8, 3)  NOT NULL,
   [PACKSIZEUNITCODE] varchar(2)  NOT NULL,
   [PACKQUANTITY] numeric(38, 0)  NOT NULL,
   [UNITDOSECODE] varchar(1)  NULL,
   [PACKDESCCODE] varchar(2)  NOT NULL,
   [NDC] varchar(13)  NOT NULL,
   [GENIDTYPECODE] varchar(1)  NOT NULL,
   [GENIDNUMBER] varchar(9)  NOT NULL,
   [AHFSTHERACLASSCODE] varchar(6)  NOT NULL,
   [LOCALSYSTEMICCODE] varchar(1)  NOT NULL,
   [MAINTDRUGIND] numeric(38, 0)  NOT NULL,
   [FORMTYPECODE] varchar(1)  NOT NULL,
   [DOLLARRANKCODE] varchar(1)  NOT NULL,
   [RXRANKCODE] varchar(1)  NOT NULL,
   [INTEXTCODE] varchar(1)  NOT NULL,
   [SINGLECOMBCODE] varchar(1)  NOT NULL,
   [STORAGECONDCODE] varchar(1)  NULL,
   [OLDPPIDEFFDATE] varchar(8)  NULL,
   [NEWPPIDEFFDATE] varchar(8)  NULL,
   [PRODUCTNAME] varchar(25)  NOT NULL,
   [PRODUCTNAMEEXT] varchar(35)  NULL,
   [TOTALPACKAGEQTY] numeric(12, 3)  NOT NULL,
   [CURRIMAGEFILENAME] varchar(8)  NULL,
   [ACTCODE] varchar(1)  NULL,
   [SINGLEINGRIND] numeric(38, 0)  NOT NULL,
   [MEDDEVIND] numeric(38, 0)  NOT NULL,
   [INACTIVEDATE] varchar(8)  NULL,
   [PRODUCTDESCABBREV] varchar(25)  NOT NULL,
   [DOSECHEKUNIT] varchar(20)  NULL,
   [ITEMSTATUS] varchar(1)  NOT NULL,
   [SCREENCLEANADE] numeric(38, 0)  NULL,
   [SCREENCLEANPRC] numeric(38, 0)  NULL,
   [SCREENCLEANDFA] numeric(38, 0)  NULL,
   [SCREENCLEANDI] numeric(38, 0)  NULL,
   [SCREENCLEANDC] numeric(38, 0)  NULL,
   [SCREENCLEANDDA] numeric(38, 0)  NULL,
   [PARTIALGPIIND] numeric(38, 0)  NOT NULL,
   [PRIVATELABELERIND] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.PPID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'PPID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.DDID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'DDID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.RTID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'RTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.DFID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'DFID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.STRENGTH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'STRENGTH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.STRENGTHUNIT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'STRENGTHUNIT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.TEECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'TEECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.DEACLASSCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'DEACLASSCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.DESICODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'DESICODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.RXOTCCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'RXOTCCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.GPPC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'GPPC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.OLDPPID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'OLDPPID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.NEWPPID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'NEWPPID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.REPACKIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'REPACKIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.IDFORMATCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'IDFORMATCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.THIRDPRTYRESTRCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'THIRDPRTYRESTRCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.KDC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'KDC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.LABELERID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'LABELERID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.MULTISOURCECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'MULTISOURCECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.NAMETYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'NAMETYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.INNERPACKIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'INNERPACKIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.CLINICPACKIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'CLINICPACKIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.REIMBURSEMENTCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'REIMBURSEMENTCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.PRICESPREADCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'PRICESPREADCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.PACKSIZE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'PACKSIZE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.PACKSIZEUNITCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'PACKSIZEUNITCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.PACKQUANTITY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'PACKQUANTITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.UNITDOSECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'UNITDOSECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.PACKDESCCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'PACKDESCCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.NDC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'NDC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.GENIDTYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'GENIDTYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.GENIDNUMBER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'GENIDNUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.AHFSTHERACLASSCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'AHFSTHERACLASSCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.LOCALSYSTEMICCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'LOCALSYSTEMICCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.MAINTDRUGIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'MAINTDRUGIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.FORMTYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'FORMTYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.DOLLARRANKCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'DOLLARRANKCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.RXRANKCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'RXRANKCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.INTEXTCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'INTEXTCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.SINGLECOMBCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'SINGLECOMBCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.STORAGECONDCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'STORAGECONDCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.OLDPPIDEFFDATE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'OLDPPIDEFFDATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.NEWPPIDEFFDATE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'NEWPPIDEFFDATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.PRODUCTNAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'PRODUCTNAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.PRODUCTNAMEEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'PRODUCTNAMEEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.TOTALPACKAGEQTY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'TOTALPACKAGEQTY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.CURRIMAGEFILENAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'CURRIMAGEFILENAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.ACTCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'ACTCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.SINGLEINGRIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'SINGLEINGRIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.MEDDEVIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'MEDDEVIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.INACTIVEDATE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'INACTIVEDATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.PRODUCTDESCABBREV',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'PRODUCTDESCABBREV'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.DOSECHEKUNIT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'DOSECHEKUNIT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.ITEMSTATUS',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'ITEMSTATUS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.SCREENCLEANADE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'SCREENCLEANADE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.SCREENCLEANPRC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'SCREENCLEANPRC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.SCREENCLEANDFA',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'SCREENCLEANDFA'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.SCREENCLEANDI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'SCREENCLEANDI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.SCREENCLEANDC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'SCREENCLEANDC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.SCREENCLEANDDA',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'SCREENCLEANDDA'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.PARTIALGPIIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'PARTIALGPIIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.PRIVATELABELERIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'COLUMN', N'PRIVATELABELERIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DRUG_PACK_MOD'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DRUG_PACK_MOD'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DRUG_PACK_MOD]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DRUG_PACK_MOD]
(
   [PPID] varchar(20)  NOT NULL,
   [MODID] varchar(6)  NOT NULL,
   [TYPECODE] varchar(2)  NOT NULL,
   [CATCODE] varchar(4)  NOT NULL,
   [DESCRIPTION] varchar(25)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK_MOD',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK_MOD'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK_MOD.PPID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK_MOD',
        N'COLUMN', N'PPID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK_MOD.MODID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK_MOD',
        N'COLUMN', N'MODID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK_MOD.TYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK_MOD',
        N'COLUMN', N'TYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK_MOD.CATCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK_MOD',
        N'COLUMN', N'CATCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK_MOD.DESCRIPTION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK_MOD',
        N'COLUMN', N'DESCRIPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DRUG_ROUTE'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DRUG_ROUTE'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DRUG_ROUTE]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DRUG_ROUTE]
(
   [RTID] numeric(38, 0)  NOT NULL,
   [DESCRIPTION] varchar(40)  NULL,
   [ABBREV] varchar(2)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTE.RTID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTE',
        N'COLUMN', N'RTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTE.DESCRIPTION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTE',
        N'COLUMN', N'DESCRIPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTE.ABBREV',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTE',
        N'COLUMN', N'ABBREV'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DRUG_ROUTED'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DRUG_ROUTED'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DRUG_ROUTED]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DRUG_ROUTED]
(
   [RPID] numeric(38, 0)  NOT NULL,
   [DESCDISPLAY] varchar(65)  NOT NULL,
   [DESCSEARCH] varchar(65)  NOT NULL,
   [DESCPHONETIC] varchar(65)  NOT NULL,
   [RTID] numeric(38, 0)  NOT NULL,
   [PNID] numeric(38, 0)  NOT NULL,
   [DDIDUNIQUE] numeric(38, 0)  NULL,
   [NAMETYPECODE] varchar(1)  NOT NULL,
   [RXOTCCODE] varchar(1)  NULL,
   [ACTCODE] varchar(1)  NULL,
   [SINGLEINGRIND] numeric(38, 0)  NOT NULL,
   [MEDDEVIND] numeric(38, 0)  NOT NULL,
   [HASPACKDRUGIND] numeric(38, 0)  NOT NULL,
   [HASEQVPACKDRUGIND] numeric(38, 0)  NOT NULL,
   [HASGPIIND] numeric(38, 0)  NOT NULL,
   [HASKDCIND] numeric(38, 0)  NOT NULL,
   [SCREENCLEANDFA] numeric(38, 0)  NULL,
   [SCREENCLEANDI] numeric(38, 0)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.RPID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'RPID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.DESCDISPLAY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'DESCDISPLAY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.DESCSEARCH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'DESCSEARCH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.DESCPHONETIC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'DESCPHONETIC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.RTID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'RTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.PNID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'PNID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.DDIDUNIQUE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'DDIDUNIQUE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.NAMETYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'NAMETYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.RXOTCCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'RXOTCCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.ACTCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'ACTCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.SINGLEINGRIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'SINGLEINGRIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.MEDDEVIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'MEDDEVIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.HASPACKDRUGIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'HASPACKDRUGIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.HASEQVPACKDRUGIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'HASEQVPACKDRUGIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.HASGPIIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'HASGPIIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.HASKDCIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'HASKDCIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.SCREENCLEANDFA',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'SCREENCLEANDFA'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.SCREENCLEANDI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'COLUMN', N'SCREENCLEANDI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DUP_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DUP_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DUP_DRUGLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DUP_DRUGLINK]
(
   [GPI] varchar(14)  NOT NULL,
   [DTCID] varchar(8)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DUP_DRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DUP_DRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DUP_DRUGLINK.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DUP_DRUGLINK',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DUP_DRUGLINK.DTCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DUP_DRUGLINK',
        N'COLUMN', N'DTCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_DUP_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_DUP_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_DUP_TEXT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_DUP_TEXT]
(
   [DTCID] varchar(8)  NOT NULL,
   [DESCRIPTION] varchar(40)  NOT NULL,
   [POTENTIALABUSECODE] varchar(1)  NOT NULL,
   [DUPALLOWANCE] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DUP_TEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DUP_TEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DUP_TEXT.DTCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DUP_TEXT',
        N'COLUMN', N'DTCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DUP_TEXT.DESCRIPTION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DUP_TEXT',
        N'COLUMN', N'DESCRIPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DUP_TEXT.POTENTIALABUSECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DUP_TEXT',
        N'COLUMN', N'POTENTIALABUSECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DUP_TEXT.DUPALLOWANCE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DUP_TEXT',
        N'COLUMN', N'DUPALLOWANCE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_IND_COM'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_IND_COM'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_IND_COM]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_IND_COM]
(
   [GPI] varchar(14)  NOT NULL,
   [MCID] numeric(38, 0)  NOT NULL,
   [RESTRICTIONID] numeric(38, 0)  NOT NULL,
   [MICROORGANISMID] numeric(38, 0)  NOT NULL,
   [SEQUENCENUMBER] numeric(38, 0)  NOT NULL,
   [TEXTID] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COM',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COM.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COM',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COM.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COM',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COM.RESTRICTIONID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COM',
        N'COLUMN', N'RESTRICTIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COM.MICROORGANISMID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COM',
        N'COLUMN', N'MICROORGANISMID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COM.SEQUENCENUMBER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COM',
        N'COLUMN', N'SEQUENCENUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COM.TEXTID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COM',
        N'COLUMN', N'TEXTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_IND_COTREAT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_IND_COTREAT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_IND_COTREAT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_IND_COTREAT]
(
   [GPI] varchar(14)  NOT NULL,
   [MCID] numeric(38, 0)  NOT NULL,
   [RESTRICTIONID] numeric(38, 0)  NOT NULL,
   [MICROORGANISMID] numeric(38, 0)  NOT NULL,
   [COTREATSETID] numeric(38, 0)  NOT NULL,
   [SEQUENCENUMBER] numeric(38, 0)  NOT NULL,
   [DESCRIPTION] varchar(80)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COTREAT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COTREAT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COTREAT.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COTREAT',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COTREAT.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COTREAT',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COTREAT.RESTRICTIONID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COTREAT',
        N'COLUMN', N'RESTRICTIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COTREAT.MICROORGANISMID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COTREAT',
        N'COLUMN', N'MICROORGANISMID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COTREAT.COTREATSETID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COTREAT',
        N'COLUMN', N'COTREATSETID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COTREAT.SEQUENCENUMBER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COTREAT',
        N'COLUMN', N'SEQUENCENUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COTREAT.DESCRIPTION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COTREAT',
        N'COLUMN', N'DESCRIPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_IND_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_IND_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_IND_DRUGLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_IND_DRUGLINK]
(
   [GPI] varchar(14)  NOT NULL,
   [MCID] numeric(38, 0)  NOT NULL,
   [RESTRICTIONID] numeric(38, 0)  NOT NULL,
   [MICROORGANISMID] numeric(38, 0)  NOT NULL,
   [ROLEOFTHERAPYCODE] varchar(2)  NOT NULL,
   [OUTCOMECODE] varchar(2)  NOT NULL,
   [TREATMENTRANKCODE] varchar(2)  NOT NULL,
   [ACCEPTANCELVLCODE] varchar(2)  NOT NULL,
   [PROXYCODE] varchar(1)  NOT NULL,
   [PROXYONLYIND] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_DRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_DRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_DRUGLINK.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_DRUGLINK',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_DRUGLINK.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_DRUGLINK',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_DRUGLINK.RESTRICTIONID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_DRUGLINK',
        N'COLUMN', N'RESTRICTIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_DRUGLINK.MICROORGANISMID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_DRUGLINK',
        N'COLUMN', N'MICROORGANISMID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_DRUGLINK.ROLEOFTHERAPYCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_DRUGLINK',
        N'COLUMN', N'ROLEOFTHERAPYCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_DRUGLINK.OUTCOMECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_DRUGLINK',
        N'COLUMN', N'OUTCOMECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_DRUGLINK.TREATMENTRANKCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_DRUGLINK',
        N'COLUMN', N'TREATMENTRANKCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_DRUGLINK.ACCEPTANCELVLCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_DRUGLINK',
        N'COLUMN', N'ACCEPTANCELVLCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_DRUGLINK.PROXYCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_DRUGLINK',
        N'COLUMN', N'PROXYCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_DRUGLINK.PROXYONLYIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_DRUGLINK',
        N'COLUMN', N'PROXYONLYIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_IND_RPID'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_IND_RPID'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_IND_RPID]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_IND_RPID]
(
   [MCID] numeric(38, 0)  NOT NULL,
   [RPID] numeric(38, 0)  NOT NULL,
   [OUTCOMECODE] varchar(2)  NOT NULL,
   [ACCEPTANCELVLCODE] varchar(2)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_RPID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_RPID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_RPID.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_RPID',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_RPID.RPID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_RPID',
        N'COLUMN', N'RPID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_RPID.OUTCOMECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_RPID',
        N'COLUMN', N'OUTCOMECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_RPID.ACCEPTANCELVLCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_RPID',
        N'COLUMN', N'ACCEPTANCELVLCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_IND_SOURCE'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_IND_SOURCE'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_IND_SOURCE]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_IND_SOURCE]
(
   [GPI] varchar(14)  NOT NULL,
   [MCID] numeric(38, 0)  NOT NULL,
   [RESTRICTIONID] numeric(38, 0)  NOT NULL,
   [MICROORGANISMID] numeric(38, 0)  NOT NULL,
   [SOURCECODE] varchar(2)  NOT NULL,
   [SOURCEACCEPTCODE] varchar(2)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_SOURCE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_SOURCE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_SOURCE.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_SOURCE',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_SOURCE.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_SOURCE',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_SOURCE.RESTRICTIONID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_SOURCE',
        N'COLUMN', N'RESTRICTIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_SOURCE.MICROORGANISMID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_SOURCE',
        N'COLUMN', N'MICROORGANISMID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_SOURCE.SOURCECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_SOURCE',
        N'COLUMN', N'SOURCECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_SOURCE.SOURCEACCEPTCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_SOURCE',
        N'COLUMN', N'SOURCEACCEPTCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_LIB_CODEDEF'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_LIB_CODEDEF'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_LIB_CODEDEF]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_LIB_CODEDEF]
(
   [CODETYPE] numeric(38, 0)  NOT NULL,
   [CODEVALUE] varchar(10)  NOT NULL,
   [DESCRIPTION] varchar(255)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_CODEDEF',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_CODEDEF'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_CODEDEF.CODETYPE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_CODEDEF',
        N'COLUMN', N'CODETYPE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_CODEDEF.CODEVALUE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_CODEDEF',
        N'COLUMN', N'CODEVALUE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_CODEDEF.DESCRIPTION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_CODEDEF',
        N'COLUMN', N'DESCRIPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_LIB_DISCLAIMER'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_LIB_DISCLAIMER'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_LIB_DISCLAIMER]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_LIB_DISCLAIMER]
(
   [VERSIONCODE] varchar(10)  NOT NULL,
   [CATEGORYCODE] varchar(10)  NOT NULL,
   [SEQUENCENUMBER] numeric(38, 0)  NOT NULL,
   [SECTIONCODE] varchar(1)  NOT NULL,
   [FORMATCODE] varchar(1)  NOT NULL,
   [LINETEXT] varchar(255)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_DISCLAIMER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_DISCLAIMER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_DISCLAIMER.VERSIONCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_DISCLAIMER',
        N'COLUMN', N'VERSIONCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_DISCLAIMER.CATEGORYCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_DISCLAIMER',
        N'COLUMN', N'CATEGORYCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_DISCLAIMER.SEQUENCENUMBER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_DISCLAIMER',
        N'COLUMN', N'SEQUENCENUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_DISCLAIMER.SECTIONCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_DISCLAIMER',
        N'COLUMN', N'SECTIONCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_DISCLAIMER.FORMATCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_DISCLAIMER',
        N'COLUMN', N'FORMATCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_DISCLAIMER.LINETEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_DISCLAIMER',
        N'COLUMN', N'LINETEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_LIB_VERSION'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_LIB_VERSION'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_LIB_VERSION]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_LIB_VERSION]
(
   [VERSIONKEY] numeric(38, 0)  NOT NULL,
   [DBVERSION] varchar(5)  NOT NULL,
   [BUILDVERSION] varchar(5)  NOT NULL,
   [FREQUENCY] varchar(1)  NOT NULL,
   [ISSUEDATE] varchar(8)  NOT NULL,
   [VERSIONCOMMENT] varchar(80)  NOT NULL,
   [LASTUPDATE] varchar(20)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_VERSION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_VERSION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_VERSION.VERSIONKEY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_VERSION',
        N'COLUMN', N'VERSIONKEY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_VERSION.DBVERSION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_VERSION',
        N'COLUMN', N'DBVERSION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_VERSION.BUILDVERSION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_VERSION',
        N'COLUMN', N'BUILDVERSION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_VERSION.FREQUENCY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_VERSION',
        N'COLUMN', N'FREQUENCY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_VERSION.ISSUEDATE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_VERSION',
        N'COLUMN', N'ISSUEDATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_VERSION.VERSIONCOMMENT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_VERSION',
        N'COLUMN', N'VERSIONCOMMENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_VERSION.LASTUPDATE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_VERSION',
        N'COLUMN', N'LASTUPDATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_MED'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_MED'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_MED]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_MED]
(
   [MCID] numeric(38, 0)  NOT NULL,
   [PRIMARYPROFNAME] varchar(58)  NOT NULL,
   [PRIMARYPATNAME] varchar(58)  NOT NULL,
   [TYPECODE] varchar(2)  NOT NULL,
   [CLASSONLYIND] numeric(38, 0)  NOT NULL,
   [GENDERCODE] varchar(1)  NOT NULL,
   [PREGNANCYIND] numeric(38, 0)  NOT NULL,
   [LACTATIONIND] numeric(38, 0)  NOT NULL,
   [AGEINDAYSLOW] numeric(38, 0)  NOT NULL,
   [AGEINDAYSHIGH] numeric(38, 0)  NOT NULL,
   [DURATIONCODE] varchar(2)  NOT NULL,
   [HASCHILDRENIND] numeric(38, 0)  NOT NULL,
   [DRUGSTOTREATIND] numeric(38, 0)  NOT NULL,
   [DRUGSTOAVOIDIND] numeric(38, 0)  NOT NULL,
   [DRUGSTHATCAUSEIND] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.PRIMARYPROFNAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'COLUMN', N'PRIMARYPROFNAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.PRIMARYPATNAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'COLUMN', N'PRIMARYPATNAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.TYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'COLUMN', N'TYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.CLASSONLYIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'COLUMN', N'CLASSONLYIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.GENDERCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'COLUMN', N'GENDERCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.PREGNANCYIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'COLUMN', N'PREGNANCYIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.LACTATIONIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'COLUMN', N'LACTATIONIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.AGEINDAYSLOW',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'COLUMN', N'AGEINDAYSLOW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.AGEINDAYSHIGH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'COLUMN', N'AGEINDAYSHIGH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.DURATIONCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'COLUMN', N'DURATIONCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.HASCHILDRENIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'COLUMN', N'HASCHILDRENIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.DRUGSTOTREATIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'COLUMN', N'DRUGSTOTREATIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.DRUGSTOAVOIDIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'COLUMN', N'DRUGSTOAVOIDIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.DRUGSTHATCAUSEIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'COLUMN', N'DRUGSTHATCAUSEIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_MED_CIT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_MED_CIT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_MED_CIT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_MED_CIT]
(
   [CITATIONID] numeric(38, 0)  NOT NULL,
   [CITATIONTEXT] varchar(250)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_CIT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_CIT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_CIT.CITATIONID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_CIT',
        N'COLUMN', N'CITATIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_CIT.CITATIONTEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_CIT',
        N'COLUMN', N'CITATIONTEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_MED_EXTVOCAB'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_MED_EXTVOCAB'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_MED_EXTVOCAB]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_MED_EXTVOCAB]
(
   [VOCABTYPECODE] varchar(1)  NOT NULL,
   [EXTVOCABID] varchar(20)  NOT NULL,
   [MCID] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_EXTVOCAB',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_EXTVOCAB'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_EXTVOCAB.VOCABTYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_EXTVOCAB',
        N'COLUMN', N'VOCABTYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_EXTVOCAB.EXTVOCABID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_EXTVOCAB',
        N'COLUMN', N'EXTVOCABID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_EXTVOCAB.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_EXTVOCAB',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_MED_HIER'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_MED_HIER'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_MED_HIER]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_MED_HIER]
(
   [MCID] numeric(38, 0)  NOT NULL,
   [PARENTID] numeric(38, 0)  NOT NULL,
   [RELATIONTYPECODE] varchar(2)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_HIER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_HIER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_HIER.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_HIER',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_HIER.PARENTID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_HIER',
        N'COLUMN', N'PARENTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_HIER.RELATIONTYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_HIER',
        N'COLUMN', N'RELATIONTYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_MED_INTVOCAB'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_MED_INTVOCAB'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_MED_INTVOCAB]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_MED_INTVOCAB]
(
   [VOCABTYPECODE] varchar(1)  NOT NULL,
   [MCID] numeric(38, 0)  NOT NULL,
   [EXTVOCABID] varchar(20)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_INTVOCAB',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_INTVOCAB'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_INTVOCAB.VOCABTYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_INTVOCAB',
        N'COLUMN', N'VOCABTYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_INTVOCAB.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_INTVOCAB',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_INTVOCAB.EXTVOCABID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_INTVOCAB',
        N'COLUMN', N'EXTVOCABID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_MED_LINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_MED_LINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_MED_LINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_MED_LINK]
(
   [MCID] numeric(38, 0)  NOT NULL,
   [RELATEDMCID] numeric(38, 0)  NOT NULL,
   [RELATIONTYPECODE] varchar(2)  NOT NULL,
   [DIRECTIONCODE] varchar(1)  NOT NULL,
   [DISTANCE] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_LINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_LINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_LINK.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_LINK',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_LINK.RELATEDMCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_LINK',
        N'COLUMN', N'RELATEDMCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_LINK.RELATIONTYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_LINK',
        N'COLUMN', N'RELATIONTYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_LINK.DIRECTIONCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_LINK',
        N'COLUMN', N'DIRECTIONCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_LINK.DISTANCE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_LINK',
        N'COLUMN', N'DISTANCE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_MED_NAME'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_MED_NAME'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_MED_NAME]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_MED_NAME]
(
   [MCID] numeric(38, 0)  NOT NULL,
   [NAMETYPECODE] varchar(2)  NOT NULL,
   [SEQUENCENUMBER] numeric(38, 0)  NOT NULL,
   [NAMEDISPLAY] varchar(60)  NOT NULL,
   [NAMESEARCH] varchar(60)  NOT NULL,
   [NAMEPHONETIC] varchar(60)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_NAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_NAME.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_NAME',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_NAME.NAMETYPECODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_NAME',
        N'COLUMN', N'NAMETYPECODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_NAME.SEQUENCENUMBER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_NAME',
        N'COLUMN', N'SEQUENCENUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_NAME.NAMEDISPLAY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_NAME',
        N'COLUMN', N'NAMEDISPLAY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_NAME.NAMESEARCH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_NAME',
        N'COLUMN', N'NAMESEARCH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_NAME.NAMEPHONETIC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_NAME',
        N'COLUMN', N'NAMEPHONETIC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_MED_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_MED_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_MED_TEXT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_MED_TEXT]
(
   [TEXTID] numeric(38, 0)  NOT NULL,
   [LINENUMBER] numeric(38, 0)  NOT NULL,
   [LINETEXT] varchar(140)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_TEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_TEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_TEXT.TEXTID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_TEXT',
        N'COLUMN', N'TEXTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_TEXT.LINENUMBER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_TEXT',
        N'COLUMN', N'LINENUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_TEXT.LINETEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_TEXT',
        N'COLUMN', N'LINETEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_MED_TEXT_CIT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_MED_TEXT_CIT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_MED_TEXT_CIT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_MED_TEXT_CIT]
(
   [TEXTID] numeric(38, 0)  NOT NULL,
   [CITATIONID] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_TEXT_CIT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_TEXT_CIT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_TEXT_CIT.TEXTID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_TEXT_CIT',
        N'COLUMN', N'TEXTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_TEXT_CIT.CITATIONID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_TEXT_CIT',
        N'COLUMN', N'CITATIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_MONO_CLSNAME'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_MONO_CLSNAME'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_MONO_CLSNAME]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_MONO_CLSNAME]
(
   [CATEGORYCODE] varchar(10)  NOT NULL,
   [MONOID] varchar(20)  NOT NULL,
   [CLASS1NAME] varchar(75)  NOT NULL,
   [CLASS2NAME] varchar(75)  NOT NULL,
   [CLASS1FOODIND] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_CLSNAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_CLSNAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_CLSNAME.CATEGORYCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_CLSNAME',
        N'COLUMN', N'CATEGORYCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_CLSNAME.MONOID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_CLSNAME',
        N'COLUMN', N'MONOID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_CLSNAME.CLASS1NAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_CLSNAME',
        N'COLUMN', N'CLASS1NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_CLSNAME.CLASS2NAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_CLSNAME',
        N'COLUMN', N'CLASS2NAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_CLSNAME.CLASS1FOODIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_CLSNAME',
        N'COLUMN', N'CLASS1FOODIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_MONO_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_MONO_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_MONO_TEXT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_MONO_TEXT]
(
   [VERSIONCODE] varchar(10)  NOT NULL,
   [CATEGORYCODE] varchar(10)  NOT NULL,
   [MONOID] varchar(20)  NOT NULL,
   [SEQUENCENUMBER] numeric(38, 0)  NOT NULL,
   [SECTIONCODE] varchar(1)  NOT NULL,
   [FORMATCODE] varchar(1)  NOT NULL,
   [LINETEXT] varchar(255)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_TEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_TEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_TEXT.VERSIONCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_TEXT',
        N'COLUMN', N'VERSIONCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_TEXT.CATEGORYCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_TEXT',
        N'COLUMN', N'CATEGORYCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_TEXT.MONOID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_TEXT',
        N'COLUMN', N'MONOID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_TEXT.SEQUENCENUMBER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_TEXT',
        N'COLUMN', N'SEQUENCENUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_TEXT.SECTIONCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_TEXT',
        N'COLUMN', N'SECTIONCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_TEXT.FORMATCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_TEXT',
        N'COLUMN', N'FORMATCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_TEXT.LINETEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_TEXT',
        N'COLUMN', N'LINETEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_PAR_CLASS'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_PAR_CLASS'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_PAR_CLASS]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_PAR_CLASS]
(
   [CLASSID] varchar(5)  NOT NULL,
   [DESCDISPLAY] varchar(75)  NOT NULL,
   [DESCSEARCH] varchar(75)  NOT NULL,
   [DESCPHONETIC] varchar(75)  NOT NULL,
   [CROSSREACTIND] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_CLASS',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_CLASS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_CLASS.CLASSID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_CLASS',
        N'COLUMN', N'CLASSID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_CLASS.DESCDISPLAY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_CLASS',
        N'COLUMN', N'DESCDISPLAY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_CLASS.DESCSEARCH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_CLASS',
        N'COLUMN', N'DESCSEARCH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_CLASS.DESCPHONETIC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_CLASS',
        N'COLUMN', N'DESCPHONETIC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_CLASS.CROSSREACTIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_CLASS',
        N'COLUMN', N'CROSSREACTIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_PAR_CLASSLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_PAR_CLASSLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_PAR_CLASSLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_PAR_CLASSLINK]
(
   [KDC1] varchar(5)  NOT NULL,
   [CLASSID] varchar(5)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_CLASSLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_CLASSLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_CLASSLINK.KDC1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_CLASSLINK',
        N'COLUMN', N'KDC1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_CLASSLINK.CLASSID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_CLASSLINK',
        N'COLUMN', N'CLASSID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_PAR_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_PAR_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_PAR_DRUGLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_PAR_DRUGLINK]
(
   [ALLERGYID] varchar(12)  NOT NULL,
   [KDC1] varchar(5)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_DRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_DRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_DRUGLINK.ALLERGYID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_DRUGLINK',
        N'COLUMN', N'ALLERGYID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_DRUGLINK.KDC1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_DRUGLINK',
        N'COLUMN', N'KDC1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_PAR_INGRLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_PAR_INGRLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_PAR_INGRLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_PAR_INGRLINK]
(
   [KDC1] varchar(5)  NOT NULL,
   [INGREDKDC1] varchar(5)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INGRLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INGRLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INGRLINK.KDC1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INGRLINK',
        N'COLUMN', N'KDC1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INGRLINK.INGREDKDC1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INGRLINK',
        N'COLUMN', N'INGREDKDC1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_PAR_INT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_PAR_INT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_PAR_INT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_PAR_INT]
(
   [CLASSID1] varchar(5)  NOT NULL,
   [CLASSID2] varchar(5)  NOT NULL,
   [SYMPTOMCODE] varchar(6)  NOT NULL,
   [MONOID] varchar(20)  NULL,
   [SYMRASHIND] numeric(38, 0)  NOT NULL,
   [SYMSHOCKIND] numeric(38, 0)  NOT NULL,
   [SYMASTHMAIND] numeric(38, 0)  NOT NULL,
   [SYMNAUSEAIND] numeric(38, 0)  NOT NULL,
   [SYMANEMIAIND] numeric(38, 0)  NOT NULL,
   [SYMUNSPECIFIEDIND] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INT.CLASSID1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INT',
        N'COLUMN', N'CLASSID1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INT.CLASSID2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INT',
        N'COLUMN', N'CLASSID2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INT.SYMPTOMCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INT',
        N'COLUMN', N'SYMPTOMCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INT.MONOID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INT',
        N'COLUMN', N'MONOID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INT.SYMRASHIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INT',
        N'COLUMN', N'SYMRASHIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INT.SYMSHOCKIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INT',
        N'COLUMN', N'SYMSHOCKIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INT.SYMASTHMAIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INT',
        N'COLUMN', N'SYMASTHMAIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INT.SYMNAUSEAIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INT',
        N'COLUMN', N'SYMNAUSEAIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INT.SYMANEMIAIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INT',
        N'COLUMN', N'SYMANEMIAIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INT.SYMUNSPECIFIEDIND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INT',
        N'COLUMN', N'SYMUNSPECIFIEDIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_PDE_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_PDE_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_PDE_DRUGLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_PDE_DRUGLINK]
(
   [GPI] varchar(14)  NOT NULL,
   [VERSIONCODE] varchar(10)  NOT NULL,
   [MONOID] varchar(20)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PDE_DRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PDE_DRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PDE_DRUGLINK.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PDE_DRUGLINK',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PDE_DRUGLINK.VERSIONCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PDE_DRUGLINK',
        N'COLUMN', N'VERSIONCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PDE_DRUGLINK.MONOID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PDE_DRUGLINK',
        N'COLUMN', N'MONOID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_PRCA_COM'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_PRCA_COM'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_PRCA_COM]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_PRCA_COM]
(
   [GPI] varchar(14)  NOT NULL,
   [AGEINDAYSLOW] numeric(38, 0)  NOT NULL,
   [AGEINDAYSHIGH] numeric(38, 0)  NOT NULL,
   [RESTRICTIONID] numeric(38, 0)  NOT NULL,
   [SEQUENCENUMBER] numeric(38, 0)  NOT NULL,
   [TEXTID] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_COM',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_COM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_COM.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_COM',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_COM.AGEINDAYSLOW',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_COM',
        N'COLUMN', N'AGEINDAYSLOW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_COM.AGEINDAYSHIGH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_COM',
        N'COLUMN', N'AGEINDAYSHIGH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_COM.RESTRICTIONID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_COM',
        N'COLUMN', N'RESTRICTIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_COM.SEQUENCENUMBER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_COM',
        N'COLUMN', N'SEQUENCENUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_COM.TEXTID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_COM',
        N'COLUMN', N'TEXTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_PRCA_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_PRCA_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_PRCA_DRUGLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_PRCA_DRUGLINK]
(
   [GPI] varchar(14)  NOT NULL,
   [AGEINDAYSLOW] numeric(38, 0)  NOT NULL,
   [AGEINDAYSHIGH] numeric(38, 0)  NOT NULL,
   [RESTRICTIONID] numeric(38, 0)  NOT NULL,
   [MGMTLEVELCODE] varchar(1)  NOT NULL,
   [ORIGAGELOW] numeric(38, 0)  NOT NULL,
   [ORIGAGEHIGH] numeric(38, 0)  NOT NULL,
   [ORIGAGEUNITCODE] varchar(1)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_DRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_DRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_DRUGLINK.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_DRUGLINK',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_DRUGLINK.AGEINDAYSLOW',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_DRUGLINK',
        N'COLUMN', N'AGEINDAYSLOW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_DRUGLINK.AGEINDAYSHIGH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_DRUGLINK',
        N'COLUMN', N'AGEINDAYSHIGH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_DRUGLINK.RESTRICTIONID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_DRUGLINK',
        N'COLUMN', N'RESTRICTIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_DRUGLINK.MGMTLEVELCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_DRUGLINK',
        N'COLUMN', N'MGMTLEVELCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_DRUGLINK.ORIGAGELOW',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_DRUGLINK',
        N'COLUMN', N'ORIGAGELOW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_DRUGLINK.ORIGAGEHIGH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_DRUGLINK',
        N'COLUMN', N'ORIGAGEHIGH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_DRUGLINK.ORIGAGEUNITCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_DRUGLINK',
        N'COLUMN', N'ORIGAGEUNITCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_PRCA_SPECCOND'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_PRCA_SPECCOND'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_PRCA_SPECCOND]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_PRCA_SPECCOND]
(
   [GPI] varchar(14)  NOT NULL,
   [AGEINDAYSLOW] numeric(38, 0)  NOT NULL,
   [AGEINDAYSHIGH] numeric(38, 0)  NOT NULL,
   [RESTRICTIONID] numeric(38, 0)  NOT NULL,
   [SPECCONDID] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_SPECCOND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_SPECCOND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_SPECCOND.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_SPECCOND',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_SPECCOND.AGEINDAYSLOW',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_SPECCOND',
        N'COLUMN', N'AGEINDAYSLOW'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_SPECCOND.AGEINDAYSHIGH',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_SPECCOND',
        N'COLUMN', N'AGEINDAYSHIGH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_SPECCOND.RESTRICTIONID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_SPECCOND',
        N'COLUMN', N'RESTRICTIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_SPECCOND.SPECCONDID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_SPECCOND',
        N'COLUMN', N'SPECCONDID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_PRCC_COM'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_PRCC_COM'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_PRCC_COM]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_PRCC_COM]
(
   [GPI] varchar(14)  NOT NULL,
   [MCID] numeric(38, 0)  NOT NULL,
   [RESTRICTIONID] numeric(38, 0)  NOT NULL,
   [SEQUENCENUMBER] numeric(38, 0)  NOT NULL,
   [TEXTID] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_COM',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_COM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_COM.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_COM',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_COM.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_COM',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_COM.RESTRICTIONID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_COM',
        N'COLUMN', N'RESTRICTIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_COM.SEQUENCENUMBER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_COM',
        N'COLUMN', N'SEQUENCENUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_COM.TEXTID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_COM',
        N'COLUMN', N'TEXTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_PRCC_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_PRCC_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_PRCC_DRUGLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_PRCC_DRUGLINK]
(
   [GPI] varchar(14)  NOT NULL,
   [MCID] numeric(38, 0)  NOT NULL,
   [RESTRICTIONID] numeric(38, 0)  NOT NULL,
   [MGMTLEVELCODE] varchar(1)  NOT NULL,
   [PLACENTTRANSCODE] varchar(1)  NULL,
   [FDARISKFACTORCODE] varchar(1)  NULL,
   [BRIGGSRATINGCODE] varchar(1)  NULL,
   [BRSTFEEDEXCRETCODE] varchar(1)  NULL,
   [BRSTFEEDRATINGCODE] varchar(1)  NULL,
   [BRSTFEEDAAPCODE] varchar(1)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_DRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_DRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_DRUGLINK.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_DRUGLINK',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_DRUGLINK.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_DRUGLINK',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_DRUGLINK.RESTRICTIONID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_DRUGLINK',
        N'COLUMN', N'RESTRICTIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_DRUGLINK.MGMTLEVELCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_DRUGLINK',
        N'COLUMN', N'MGMTLEVELCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_DRUGLINK.PLACENTTRANSCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_DRUGLINK',
        N'COLUMN', N'PLACENTTRANSCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_DRUGLINK.FDARISKFACTORCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_DRUGLINK',
        N'COLUMN', N'FDARISKFACTORCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_DRUGLINK.BRIGGSRATINGCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_DRUGLINK',
        N'COLUMN', N'BRIGGSRATINGCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_DRUGLINK.BRSTFEEDEXCRETCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_DRUGLINK',
        N'COLUMN', N'BRSTFEEDEXCRETCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_DRUGLINK.BRSTFEEDRATINGCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_DRUGLINK',
        N'COLUMN', N'BRSTFEEDRATINGCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_DRUGLINK.BRSTFEEDAAPCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_DRUGLINK',
        N'COLUMN', N'BRSTFEEDAAPCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_PRCC_SPECCOND'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_PRCC_SPECCOND'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_PRCC_SPECCOND]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_PRCC_SPECCOND]
(
   [GPI] varchar(14)  NOT NULL,
   [MCID] numeric(38, 0)  NOT NULL,
   [RESTRICTIONID] numeric(38, 0)  NOT NULL,
   [SPECCONDID] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_SPECCOND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_SPECCOND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_SPECCOND.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_SPECCOND',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_SPECCOND.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_SPECCOND',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_SPECCOND.RESTRICTIONID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_SPECCOND',
        N'COLUMN', N'RESTRICTIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_SPECCOND.SPECCONDID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_SPECCOND',
        N'COLUMN', N'SPECCONDID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_SNOMED_MC_LINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_SNOMED_MC_LINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_SNOMED_MC_LINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_SNOMED_MC_LINK]
(
   [MCID] numeric(38, 0)  NOT NULL,
   [SNOMEDID] varchar(18)  NOT NULL,
   [RELATIONTYPE] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_SNOMED_MC_LINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_SNOMED_MC_LINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_SNOMED_MC_LINK.MCID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_SNOMED_MC_LINK',
        N'COLUMN', N'MCID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_SNOMED_MC_LINK.SNOMEDID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_SNOMED_MC_LINK',
        N'COLUMN', N'SNOMEDID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_SNOMED_MC_LINK.RELATIONTYPE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_SNOMED_MC_LINK',
        N'COLUMN', N'RELATIONTYPE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_WL_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_WL_DRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_WL_DRUGLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_WL_DRUGLINK]
(
   [GPI] varchar(14)  NOT NULL,
   [WLID] varchar(6)  NOT NULL,
   [PRIORITY] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_DRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_DRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_DRUGLINK.GPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_DRUGLINK',
        N'COLUMN', N'GPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_DRUGLINK.WLID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_DRUGLINK',
        N'COLUMN', N'WLID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_DRUGLINK.PRIORITY',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_DRUGLINK',
        N'COLUMN', N'PRIORITY'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_WL_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_WL_TEXT'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_WL_TEXT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_WL_TEXT]
(
   [VERSIONCODE] varchar(10)  NOT NULL,
   [WLID] varchar(6)  NOT NULL,
   [SEQUENCENUMBER] numeric(38, 0)  NOT NULL,
   [LINETEXT] varchar(100)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_TEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_TEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_TEXT.VERSIONCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_TEXT',
        N'COLUMN', N'VERSIONCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_TEXT.WLID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_TEXT',
        N'COLUMN', N'WLID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_TEXT.SEQUENCENUMBER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_TEXT',
        N'COLUMN', N'SEQUENCENUMBER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_TEXT.LINETEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_TEXT',
        N'COLUMN', N'LINETEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_WL_VENDCODE'  AND sc.name = N'DIB3_2'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_WL_VENDCODE'  AND sc.name = N'DIB3_2'  AND type in (N'U')
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

  DROP TABLE [DIB3_2].[MMW_WL_VENDCODE]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB3_2].[MMW_WL_VENDCODE]
(
   [VERSIONCODE] varchar(10)  NOT NULL,
   [WLID] varchar(6)  NOT NULL,
   [VENDVERSIONCODE] varchar(3)  NOT NULL,
   [TEXTCODE] varchar(6)  NOT NULL,
   [GRAPHICCODE] varchar(6)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_VENDCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_VENDCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_VENDCODE.VERSIONCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_VENDCODE',
        N'COLUMN', N'VERSIONCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_VENDCODE.WLID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_VENDCODE',
        N'COLUMN', N'WLID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_VENDCODE.VENDVERSIONCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_VENDCODE',
        N'COLUMN', N'VENDVERSIONCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_VENDCODE.TEXTCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_VENDCODE',
        N'COLUMN', N'TEXTCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_VENDCODE.GRAPHICCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_VENDCODE',
        N'COLUMN', N'GRAPHICCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IGPIBCPK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[IMGIPT_BASIC] DROP CONSTRAINT [IGPIBCPK]
 GO



ALTER TABLE [DIB3_2].[IMGIPT_BASIC]
 ADD CONSTRAINT [IGPIBCPK]
   PRIMARY KEY
   CLUSTERED ([CATEGORYID] ASC, [BASICDESCID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_BASIC.IGPIBCPK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_BASIC',
        N'CONSTRAINT', N'IGPIBCPK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IGPIDTPK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[IMGIPT_CATEGORY] DROP CONSTRAINT [IGPIDTPK]
 GO



ALTER TABLE [DIB3_2].[IMGIPT_CATEGORY]
 ADD CONSTRAINT [IGPIDTPK]
   PRIMARY KEY
   CLUSTERED ([CATEGORYID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_CATEGORY.IGPIDTPK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_CATEGORY',
        N'CONSTRAINT', N'IGPIDTPK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IGPIDCPK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[IMGIPT_DESC] DROP CONSTRAINT [IGPIDCPK]
 GO



ALTER TABLE [DIB3_2].[IMGIPT_DESC]
 ADD CONSTRAINT [IGPIDCPK]
   PRIMARY KEY
   CLUSTERED ([CATEGORYID] ASC, [DESCRIPTORID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_DESC.IGPIDCPK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_DESC',
        N'CONSTRAINT', N'IGPIDCPK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IGPIDMPK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[IMGIPT_DOSE_FORM] DROP CONSTRAINT [IGPIDMPK]
 GO



ALTER TABLE [DIB3_2].[IMGIPT_DOSE_FORM]
 ADD CONSTRAINT [IGPIDMPK]
   PRIMARY KEY
   CLUSTERED ([DOSAGEFORMID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_DOSE_FORM.IGPIDMPK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_DOSE_FORM',
        N'CONSTRAINT', N'IGPIDMPK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IGPIIGPK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[IMGIPT_IMAGE] DROP CONSTRAINT [IGPIIGPK]
 GO



ALTER TABLE [DIB3_2].[IMGIPT_IMAGE]
 ADD CONSTRAINT [IGPIIGPK]
   PRIMARY KEY
   CLUSTERED ([IMAGEID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_IMAGE.IGPIIGPK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_IMAGE',
        N'CONSTRAINT', N'IGPIIGPK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IGPIPPPK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[IMGIPT_IMPRINT] DROP CONSTRAINT [IGPIPPPK]
 GO



ALTER TABLE [DIB3_2].[IMGIPT_IMPRINT]
 ADD CONSTRAINT [IGPIPPPK]
   PRIMARY KEY
   CLUSTERED ([PROPERTYID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_IMPRINT.IGPIPPPK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_IMPRINT',
        N'CONSTRAINT', N'IGPIPPPK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IGPIUJPK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[IMGIPT_JOURNAL] DROP CONSTRAINT [IGPIUJPK]
 GO



ALTER TABLE [DIB3_2].[IMGIPT_JOURNAL]
 ADD CONSTRAINT [IGPIUJPK]
   PRIMARY KEY
   CLUSTERED ([UNIQUEDRUGID] ASC, [STARTDATE] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_JOURNAL.IGPIUJPK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_JOURNAL',
        N'CONSTRAINT', N'IGPIUJPK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IMGIPTIMTPK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[IMGIPT_LIB_VERSION] DROP CONSTRAINT [IMGIPTIMTPK]
 GO



ALTER TABLE [DIB3_2].[IMGIPT_LIB_VERSION]
 ADD CONSTRAINT [IMGIPTIMTPK]
   PRIMARY KEY
   CLUSTERED ([VERSIONKEY] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_LIB_VERSION.IMGIPTIMTPK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_LIB_VERSION',
        N'CONSTRAINT', N'IMGIPTIMTPK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IGPIDGPK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[IMGIPT_MANUFACT] DROP CONSTRAINT [IGPIDGPK]
 GO



ALTER TABLE [DIB3_2].[IMGIPT_MANUFACT]
 ADD CONSTRAINT [IGPIDGPK]
   PRIMARY KEY
   CLUSTERED ([MANUFACTURERID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_MANUFACT.IGPIDGPK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_MANUFACT',
        N'CONSTRAINT', N'IGPIDGPK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IGPIPCPK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[IMGIPT_PROP_DESC] DROP CONSTRAINT [IGPIPCPK]
 GO



ALTER TABLE [DIB3_2].[IMGIPT_PROP_DESC]
 ADD CONSTRAINT [IGPIPCPK]
   PRIMARY KEY
   CLUSTERED ([PROPERTYID] ASC, [CATEGORYID] ASC, [DESCRIPTORID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROP_DESC.IGPIPCPK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROP_DESC',
        N'CONSTRAINT', N'IGPIPCPK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IGPIPTPK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[IMGIPT_PROP_TEXT] DROP CONSTRAINT [IGPIPTPK]
 GO



ALTER TABLE [DIB3_2].[IMGIPT_PROP_TEXT]
 ADD CONSTRAINT [IGPIPTPK]
   PRIMARY KEY
   CLUSTERED ([PROPERTYID] ASC, [TEXTID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROP_TEXT.IGPIPTPK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROP_TEXT',
        N'CONSTRAINT', N'IGPIPTPK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IGPPRPPK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[IMGIPT_PROPERTY] DROP CONSTRAINT [IGPPRPPK]
 GO



ALTER TABLE [DIB3_2].[IMGIPT_PROPERTY]
 ADD CONSTRAINT [IGPPRPPK]
   PRIMARY KEY
   CLUSTERED ([PROPERTYID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.IGPPRPPK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'CONSTRAINT', N'IGPPRPPK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IGPITTPK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[IMGIPT_TEXT] DROP CONSTRAINT [IGPITTPK]
 GO



ALTER TABLE [DIB3_2].[IMGIPT_TEXT]
 ADD CONSTRAINT [IGPITTPK]
   PRIMARY KEY
   CLUSTERED ([TEXTID] ASC, [LINENUMBER] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_TEXT.IGPITTPK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_TEXT',
        N'CONSTRAINT', N'IGPITTPK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'IGPIUGPK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[IMGIPT_UNIQUE] DROP CONSTRAINT [IGPIUGPK]
 GO



ALTER TABLE [DIB3_2].[IMGIPT_UNIQUE]
 ADD CONSTRAINT [IGPIUGPK]
   PRIMARY KEY
   CLUSTERED ([UNIQUEDRUGID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_UNIQUE.IGPIUGPK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_UNIQUE',
        N'CONSTRAINT', N'IGPIUGPK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWADECOM'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_ADE_COM] DROP CONSTRAINT [PKMMWADECOM]
 GO



ALTER TABLE [DIB3_2].[MMW_ADE_COM]
 ADD CONSTRAINT [PKMMWADECOM]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [MCID] ASC, [RESTRICTIONID] ASC, [SEQUENCENUMBER] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_COM.PKMMWADECOM',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_COM',
        N'CONSTRAINT', N'PKMMWADECOM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWADEDRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_ADE_DRUGLINK] DROP CONSTRAINT [PKMMWADEDRUGLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_ADE_DRUGLINK]
 ADD CONSTRAINT [PKMMWADEDRUGLINK]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [MCID] ASC, [RESTRICTIONID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_DRUGLINK.PKMMWADEDRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_DRUGLINK',
        N'CONSTRAINT', N'PKMMWADEDRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWADESPECCOND'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_ADE_SPECCOND] DROP CONSTRAINT [PKMMWADESPECCOND]
 GO



ALTER TABLE [DIB3_2].[MMW_ADE_SPECCOND]
 ADD CONSTRAINT [PKMMWADESPECCOND]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [MCID] ASC, [RESTRICTIONID] ASC, [SPECCONDID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_SPECCOND.PKMMWADESPECCOND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_SPECCOND',
        N'CONSTRAINT', N'PKMMWADESPECCOND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWCLSAHFS'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_CLS_AHFS] DROP CONSTRAINT [PKMMWCLSAHFS]
 GO



ALTER TABLE [DIB3_2].[MMW_CLS_AHFS]
 ADD CONSTRAINT [PKMMWCLSAHFS]
   PRIMARY KEY
   CLUSTERED ([CLASSID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFS.PKMMWCLSAHFS',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFS',
        N'CONSTRAINT', N'PKMMWCLSAHFS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWCLSAHFSDRUG'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_CLS_AHFSDRUG] DROP CONSTRAINT [PKMMWCLSAHFSDRUG]
 GO



ALTER TABLE [DIB3_2].[MMW_CLS_AHFSDRUG]
 ADD CONSTRAINT [PKMMWCLSAHFSDRUG]
   PRIMARY KEY
   CLUSTERED ([CLASSID] ASC, [DRUGTYPE] ASC, [DRUGID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFSDRUG.PKMMWCLSAHFSDRUG',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFSDRUG',
        N'CONSTRAINT', N'PKMMWCLSAHFSDRUG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWCLSGPI'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_CLS_GPI] DROP CONSTRAINT [PKMMWCLSGPI]
 GO



ALTER TABLE [DIB3_2].[MMW_CLS_GPI]
 ADD CONSTRAINT [PKMMWCLSGPI]
   PRIMARY KEY
   CLUSTERED ([CLASSID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPI.PKMMWCLSGPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPI',
        N'CONSTRAINT', N'PKMMWCLSGPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWCLSGPIDRUG'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_CLS_GPIDRUG] DROP CONSTRAINT [PKMMWCLSGPIDRUG]
 GO



ALTER TABLE [DIB3_2].[MMW_CLS_GPIDRUG]
 ADD CONSTRAINT [PKMMWCLSGPIDRUG]
   PRIMARY KEY
   CLUSTERED ([CLASSID] ASC, [DRUGTYPE] ASC, [DRUGID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPIDRUG.PKMMWCLSGPIDRUG',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPIDRUG',
        N'CONSTRAINT', N'PKMMWCLSGPIDRUG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWCMDISPLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_CM_DISPLINK] DROP CONSTRAINT [PKMMWCMDISPLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_CM_DISPLINK]
 ADD CONSTRAINT [PKMMWCMDISPLINK]
   PRIMARY KEY
   CLUSTERED ([DDID] ASC, [CMID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_DISPLINK.PKMMWCMDISPLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_DISPLINK',
        N'CONSTRAINT', N'PKMMWCMDISPLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWCMPACKLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_CM_PACKLINK] DROP CONSTRAINT [PKMMWCMPACKLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_CM_PACKLINK]
 ADD CONSTRAINT [PKMMWCMPACKLINK]
   PRIMARY KEY
   CLUSTERED ([PPID] ASC, [CMID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_PACKLINK.PKMMWCMPACKLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_PACKLINK',
        N'CONSTRAINT', N'PKMMWCMPACKLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWCMTEXT'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_CM_TEXT] DROP CONSTRAINT [PKMMWCMTEXT]
 GO



ALTER TABLE [DIB3_2].[MMW_CM_TEXT]
 ADD CONSTRAINT [PKMMWCMTEXT]
   PRIMARY KEY
   CLUSTERED ([VERSIONCODE] ASC, [CMID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CM_TEXT.PKMMWCMTEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CM_TEXT',
        N'CONSTRAINT', N'PKMMWCMTEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDCKCOM'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DCK_COM] DROP CONSTRAINT [PKMMWDCKCOM]
 GO



ALTER TABLE [DIB3_2].[MMW_DCK_COM]
 ADD CONSTRAINT [PKMMWDCKCOM]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [AGEINDAYSLOW] ASC, [AGEINDAYSHIGH] ASC, [EFFECTCODE] ASC, [COMMENTCODE] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_COM.PKMMWDCKCOM',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_COM',
        N'CONSTRAINT', N'PKMMWDCKCOM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDCKDRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DCK_DRUGLINK] DROP CONSTRAINT [PKMMWDCKDRUGLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_DCK_DRUGLINK]
 ADD CONSTRAINT [PKMMWDCKDRUGLINK]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [AGEINDAYSLOW] ASC, [AGEINDAYSHIGH] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DCK_DRUGLINK.PKMMWDCKDRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DCK_DRUGLINK',
        N'CONSTRAINT', N'PKMMWDCKDRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDFAINT'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DFA_INT] DROP CONSTRAINT [PKMMWDFAINT]
 GO



ALTER TABLE [DIB3_2].[MMW_DFA_INT]
 ADD CONSTRAINT [PKMMWDFAINT]
   PRIMARY KEY
   CLUSTERED ([DRUGCLASSID] ASC, [FOODCLASSID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_INT.PKMMWDFAINT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_INT',
        N'CONSTRAINT', N'PKMMWDFAINT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDFATEXT'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DFA_TEXT] DROP CONSTRAINT [PKMMWDFATEXT]
 GO



ALTER TABLE [DIB3_2].[MMW_DFA_TEXT]
 ADD CONSTRAINT [PKMMWDFATEXT]
   PRIMARY KEY
   CLUSTERED ([VERSION] ASC, [DRUGCLASSID] ASC, [FOODCLASSID] ASC, [LINENUMBER] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DFA_TEXT.PKMMWDFATEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DFA_TEXT',
        N'CONSTRAINT', N'PKMMWDFATEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDICLASSLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DI_CLASSLINK] DROP CONSTRAINT [PKMMWDICLASSLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_DI_CLASSLINK]
 ADD CONSTRAINT [PKMMWDICLASSLINK]
   PRIMARY KEY
   CLUSTERED ([KDC1] ASC, [CLASSID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_CLASSLINK.PKMMWDICLASSLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_CLASSLINK',
        N'CONSTRAINT', N'PKMMWDICLASSLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDIINT'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DI_INT] DROP CONSTRAINT [PKMMWDIINT]
 GO



ALTER TABLE [DIB3_2].[MMW_DI_INT]
 ADD CONSTRAINT [PKMMWDIINT]
   PRIMARY KEY
   CLUSTERED ([CLASSID1] ASC, [CLASSID2] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.PKMMWDIINT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'CONSTRAINT', N'PKMMWDIINT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDIRPIDLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DI_RPIDLINK] DROP CONSTRAINT [PKMMWDIRPIDLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_DI_RPIDLINK]
 ADD CONSTRAINT [PKMMWDIRPIDLINK]
   PRIMARY KEY
   CLUSTERED ([KDC1] ASC, [NAMETYPECODE] ASC, [RPID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_RPIDLINK.PKMMWDIRPIDLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_RPIDLINK',
        N'CONSTRAINT', N'PKMMWDIRPIDLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDITEXT'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DI_TEXT] DROP CONSTRAINT [PKMMWDITEXT]
 GO



ALTER TABLE [DIB3_2].[MMW_DI_TEXT]
 ADD CONSTRAINT [PKMMWDITEXT]
   PRIMARY KEY
   CLUSTERED ([VERSION] ASC, [CLASSID1] ASC, [CLASSID2] ASC, [LINENUMBER] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_TEXT.PKMMWDITEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_TEXT',
        N'CONSTRAINT', N'PKMMWDITEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDRUGDISP'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DRUG_DISP] DROP CONSTRAINT [PKMMWDRUGDISP]
 GO



ALTER TABLE [DIB3_2].[MMW_DRUG_DISP]
 ADD CONSTRAINT [PKMMWDRUGDISP]
   PRIMARY KEY
   CLUSTERED ([DDID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.PKMMWDRUGDISP',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'CONSTRAINT', N'PKMMWDRUGDISP'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDRUGDISPLBLR'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DRUG_DISP_LBLR] DROP CONSTRAINT [PKMMWDRUGDISPLBLR]
 GO



ALTER TABLE [DIB3_2].[MMW_DRUG_DISP_LBLR]
 ADD CONSTRAINT [PKMMWDRUGDISPLBLR]
   PRIMARY KEY
   CLUSTERED ([DDID] ASC, [LABELERID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP_LBLR.PKMMWDRUGDISPLBLR',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP_LBLR',
        N'CONSTRAINT', N'PKMMWDRUGDISPLBLR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDRUGDOSEFORM'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DRUG_DOSEFORM] DROP CONSTRAINT [PKMMWDRUGDOSEFORM]
 GO



ALTER TABLE [DIB3_2].[MMW_DRUG_DOSEFORM]
 ADD CONSTRAINT [PKMMWDRUGDOSEFORM]
   PRIMARY KEY
   CLUSTERED ([DFID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DOSEFORM.PKMMWDRUGDOSEFORM',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DOSEFORM',
        N'CONSTRAINT', N'PKMMWDRUGDOSEFORM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDRUGGPI'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DRUG_GPI] DROP CONSTRAINT [PKMMWDRUGGPI]
 GO



ALTER TABLE [DIB3_2].[MMW_DRUG_GPI]
 ADD CONSTRAINT [PKMMWDRUGGPI]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_GPI.PKMMWDRUGGPI',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_GPI',
        N'CONSTRAINT', N'PKMMWDRUGGPI'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDRUGGPILINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DRUG_GPILINK] DROP CONSTRAINT [PKMMWDRUGGPILINK]
 GO



ALTER TABLE [DIB3_2].[MMW_DRUG_GPILINK]
 ADD CONSTRAINT [PKMMWDRUGGPILINK]
   PRIMARY KEY
   CLUSTERED ([DRUGID] ASC, [GPI] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_GPILINK.PKMMWDRUGGPILINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_GPILINK',
        N'CONSTRAINT', N'PKMMWDRUGGPILINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDRUGKDC'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DRUG_KDC] DROP CONSTRAINT [PKMMWDRUGKDC]
 GO



ALTER TABLE [DIB3_2].[MMW_DRUG_KDC]
 ADD CONSTRAINT [PKMMWDRUGKDC]
   PRIMARY KEY
   CLUSTERED ([KDC1] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_KDC.PKMMWDRUGKDC',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_KDC',
        N'CONSTRAINT', N'PKMMWDRUGKDC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDRUGKDCLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DRUG_KDCLINK] DROP CONSTRAINT [PKMMWDRUGKDCLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_DRUG_KDCLINK]
 ADD CONSTRAINT [PKMMWDRUGKDCLINK]
   PRIMARY KEY
   CLUSTERED ([DRUGID] ASC, [KDC1] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_KDCLINK.PKMMWDRUGKDCLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_KDCLINK',
        N'CONSTRAINT', N'PKMMWDRUGKDCLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDRUGLABELER'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DRUG_LABELER] DROP CONSTRAINT [PKMMWDRUGLABELER]
 GO



ALTER TABLE [DIB3_2].[MMW_DRUG_LABELER]
 ADD CONSTRAINT [PKMMWDRUGLABELER]
   PRIMARY KEY
   CLUSTERED ([LABELERID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_LABELER.PKMMWDRUGLABELER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_LABELER',
        N'CONSTRAINT', N'PKMMWDRUGLABELER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDRUGNAME'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DRUG_NAME] DROP CONSTRAINT [PKMMWDRUGNAME]
 GO



ALTER TABLE [DIB3_2].[MMW_DRUG_NAME]
 ADD CONSTRAINT [PKMMWDRUGNAME]
   PRIMARY KEY
   CLUSTERED ([PNID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.PKMMWDRUGNAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'CONSTRAINT', N'PKMMWDRUGNAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDRUGPACK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DRUG_PACK] DROP CONSTRAINT [PKMMWDRUGPACK]
 GO



ALTER TABLE [DIB3_2].[MMW_DRUG_PACK]
 ADD CONSTRAINT [PKMMWDRUGPACK]
   PRIMARY KEY
   CLUSTERED ([PPID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.PKMMWDRUGPACK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'CONSTRAINT', N'PKMMWDRUGPACK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDRUGPACKMOD'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DRUG_PACK_MOD] DROP CONSTRAINT [PKMMWDRUGPACKMOD]
 GO



ALTER TABLE [DIB3_2].[MMW_DRUG_PACK_MOD]
 ADD CONSTRAINT [PKMMWDRUGPACKMOD]
   PRIMARY KEY
   CLUSTERED ([PPID] ASC, [MODID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK_MOD.PKMMWDRUGPACKMOD',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK_MOD',
        N'CONSTRAINT', N'PKMMWDRUGPACKMOD'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDRUGROUTE'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DRUG_ROUTE] DROP CONSTRAINT [PKMMWDRUGROUTE]
 GO



ALTER TABLE [DIB3_2].[MMW_DRUG_ROUTE]
 ADD CONSTRAINT [PKMMWDRUGROUTE]
   PRIMARY KEY
   CLUSTERED ([RTID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTE.PKMMWDRUGROUTE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTE',
        N'CONSTRAINT', N'PKMMWDRUGROUTE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDRUGROUTED'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DRUG_ROUTED] DROP CONSTRAINT [PKMMWDRUGROUTED]
 GO



ALTER TABLE [DIB3_2].[MMW_DRUG_ROUTED]
 ADD CONSTRAINT [PKMMWDRUGROUTED]
   PRIMARY KEY
   CLUSTERED ([RPID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.PKMMWDRUGROUTED',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'CONSTRAINT', N'PKMMWDRUGROUTED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDUPDRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DUP_DRUGLINK] DROP CONSTRAINT [PKMMWDUPDRUGLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_DUP_DRUGLINK]
 ADD CONSTRAINT [PKMMWDUPDRUGLINK]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [DTCID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DUP_DRUGLINK.PKMMWDUPDRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DUP_DRUGLINK',
        N'CONSTRAINT', N'PKMMWDUPDRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWDUPTEXT'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_DUP_TEXT] DROP CONSTRAINT [PKMMWDUPTEXT]
 GO



ALTER TABLE [DIB3_2].[MMW_DUP_TEXT]
 ADD CONSTRAINT [PKMMWDUPTEXT]
   PRIMARY KEY
   CLUSTERED ([DTCID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DUP_TEXT.PKMMWDUPTEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DUP_TEXT',
        N'CONSTRAINT', N'PKMMWDUPTEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWINDCOM'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_IND_COM] DROP CONSTRAINT [PKMMWINDCOM]
 GO



ALTER TABLE [DIB3_2].[MMW_IND_COM]
 ADD CONSTRAINT [PKMMWINDCOM]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [MCID] ASC, [RESTRICTIONID] ASC, [MICROORGANISMID] ASC, [SEQUENCENUMBER] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COM.PKMMWINDCOM',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COM',
        N'CONSTRAINT', N'PKMMWINDCOM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWINDCOTREAT'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_IND_COTREAT] DROP CONSTRAINT [PKMMWINDCOTREAT]
 GO



ALTER TABLE [DIB3_2].[MMW_IND_COTREAT]
 ADD CONSTRAINT [PKMMWINDCOTREAT]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [MCID] ASC, [RESTRICTIONID] ASC, [MICROORGANISMID] ASC, [COTREATSETID] ASC, [SEQUENCENUMBER] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COTREAT.PKMMWINDCOTREAT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COTREAT',
        N'CONSTRAINT', N'PKMMWINDCOTREAT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWINDDRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_IND_DRUGLINK] DROP CONSTRAINT [PKMMWINDDRUGLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_IND_DRUGLINK]
 ADD CONSTRAINT [PKMMWINDDRUGLINK]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [MCID] ASC, [RESTRICTIONID] ASC, [MICROORGANISMID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_DRUGLINK.PKMMWINDDRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_DRUGLINK',
        N'CONSTRAINT', N'PKMMWINDDRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWINDRPID'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_IND_RPID] DROP CONSTRAINT [PKMMWINDRPID]
 GO



ALTER TABLE [DIB3_2].[MMW_IND_RPID]
 ADD CONSTRAINT [PKMMWINDRPID]
   PRIMARY KEY
   CLUSTERED ([MCID] ASC, [RPID] ASC, [OUTCOMECODE] ASC, [ACCEPTANCELVLCODE] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_RPID.PKMMWINDRPID',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_RPID',
        N'CONSTRAINT', N'PKMMWINDRPID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWINDSOURCE'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_IND_SOURCE] DROP CONSTRAINT [PKMMWINDSOURCE]
 GO



ALTER TABLE [DIB3_2].[MMW_IND_SOURCE]
 ADD CONSTRAINT [PKMMWINDSOURCE]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [MCID] ASC, [RESTRICTIONID] ASC, [MICROORGANISMID] ASC, [SOURCECODE] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_SOURCE.PKMMWINDSOURCE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_SOURCE',
        N'CONSTRAINT', N'PKMMWINDSOURCE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWLIBCODEDEF'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_LIB_CODEDEF] DROP CONSTRAINT [PKMMWLIBCODEDEF]
 GO



ALTER TABLE [DIB3_2].[MMW_LIB_CODEDEF]
 ADD CONSTRAINT [PKMMWLIBCODEDEF]
   PRIMARY KEY
   CLUSTERED ([CODETYPE] ASC, [CODEVALUE] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_CODEDEF.PKMMWLIBCODEDEF',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_CODEDEF',
        N'CONSTRAINT', N'PKMMWLIBCODEDEF'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWLIBDISCLAIMER'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_LIB_DISCLAIMER] DROP CONSTRAINT [PKMMWLIBDISCLAIMER]
 GO



ALTER TABLE [DIB3_2].[MMW_LIB_DISCLAIMER]
 ADD CONSTRAINT [PKMMWLIBDISCLAIMER]
   PRIMARY KEY
   CLUSTERED ([VERSIONCODE] ASC, [CATEGORYCODE] ASC, [SEQUENCENUMBER] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_DISCLAIMER.PKMMWLIBDISCLAIMER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_DISCLAIMER',
        N'CONSTRAINT', N'PKMMWLIBDISCLAIMER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWLIBVERSION'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_LIB_VERSION] DROP CONSTRAINT [PKMMWLIBVERSION]
 GO



ALTER TABLE [DIB3_2].[MMW_LIB_VERSION]
 ADD CONSTRAINT [PKMMWLIBVERSION]
   PRIMARY KEY
   CLUSTERED ([VERSIONKEY] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_LIB_VERSION.PKMMWLIBVERSION',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_LIB_VERSION',
        N'CONSTRAINT', N'PKMMWLIBVERSION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWMED'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_MED] DROP CONSTRAINT [PKMMWMED]
 GO



ALTER TABLE [DIB3_2].[MMW_MED]
 ADD CONSTRAINT [PKMMWMED]
   PRIMARY KEY
   CLUSTERED ([MCID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED.PKMMWMED',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED',
        N'CONSTRAINT', N'PKMMWMED'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWMEDCIT'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_MED_CIT] DROP CONSTRAINT [PKMMWMEDCIT]
 GO



ALTER TABLE [DIB3_2].[MMW_MED_CIT]
 ADD CONSTRAINT [PKMMWMEDCIT]
   PRIMARY KEY
   CLUSTERED ([CITATIONID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_CIT.PKMMWMEDCIT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_CIT',
        N'CONSTRAINT', N'PKMMWMEDCIT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWMEDEXTVOCAB'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_MED_EXTVOCAB] DROP CONSTRAINT [PKMMWMEDEXTVOCAB]
 GO



ALTER TABLE [DIB3_2].[MMW_MED_EXTVOCAB]
 ADD CONSTRAINT [PKMMWMEDEXTVOCAB]
   PRIMARY KEY
   CLUSTERED ([VOCABTYPECODE] ASC, [EXTVOCABID] ASC, [MCID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_EXTVOCAB.PKMMWMEDEXTVOCAB',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_EXTVOCAB',
        N'CONSTRAINT', N'PKMMWMEDEXTVOCAB'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWMEDHIER'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_MED_HIER] DROP CONSTRAINT [PKMMWMEDHIER]
 GO



ALTER TABLE [DIB3_2].[MMW_MED_HIER]
 ADD CONSTRAINT [PKMMWMEDHIER]
   PRIMARY KEY
   CLUSTERED ([MCID] ASC, [PARENTID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_HIER.PKMMWMEDHIER',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_HIER',
        N'CONSTRAINT', N'PKMMWMEDHIER'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWMEDINTVOCAB'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_MED_INTVOCAB] DROP CONSTRAINT [PKMMWMEDINTVOCAB]
 GO



ALTER TABLE [DIB3_2].[MMW_MED_INTVOCAB]
 ADD CONSTRAINT [PKMMWMEDINTVOCAB]
   PRIMARY KEY
   CLUSTERED ([VOCABTYPECODE] ASC, [MCID] ASC, [EXTVOCABID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_INTVOCAB.PKMMWMEDINTVOCAB',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_INTVOCAB',
        N'CONSTRAINT', N'PKMMWMEDINTVOCAB'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWMEDLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_MED_LINK] DROP CONSTRAINT [PKMMWMEDLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_MED_LINK]
 ADD CONSTRAINT [PKMMWMEDLINK]
   PRIMARY KEY
   CLUSTERED ([MCID] ASC, [RELATEDMCID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_LINK.PKMMWMEDLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_LINK',
        N'CONSTRAINT', N'PKMMWMEDLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWMEDNAME'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_MED_NAME] DROP CONSTRAINT [PKMMWMEDNAME]
 GO



ALTER TABLE [DIB3_2].[MMW_MED_NAME]
 ADD CONSTRAINT [PKMMWMEDNAME]
   PRIMARY KEY
   CLUSTERED ([MCID] ASC, [NAMETYPECODE] ASC, [SEQUENCENUMBER] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_NAME.PKMMWMEDNAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_NAME',
        N'CONSTRAINT', N'PKMMWMEDNAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWMEDTEXT'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_MED_TEXT] DROP CONSTRAINT [PKMMWMEDTEXT]
 GO



ALTER TABLE [DIB3_2].[MMW_MED_TEXT]
 ADD CONSTRAINT [PKMMWMEDTEXT]
   PRIMARY KEY
   CLUSTERED ([TEXTID] ASC, [LINENUMBER] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_TEXT.PKMMWMEDTEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_TEXT',
        N'CONSTRAINT', N'PKMMWMEDTEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWMEDTEXTCIT'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_MED_TEXT_CIT] DROP CONSTRAINT [PKMMWMEDTEXTCIT]
 GO



ALTER TABLE [DIB3_2].[MMW_MED_TEXT_CIT]
 ADD CONSTRAINT [PKMMWMEDTEXTCIT]
   PRIMARY KEY
   CLUSTERED ([TEXTID] ASC, [CITATIONID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_TEXT_CIT.PKMMWMEDTEXTCIT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_TEXT_CIT',
        N'CONSTRAINT', N'PKMMWMEDTEXTCIT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWMONOCLSNAME'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_MONO_CLSNAME] DROP CONSTRAINT [PKMMWMONOCLSNAME]
 GO



ALTER TABLE [DIB3_2].[MMW_MONO_CLSNAME]
 ADD CONSTRAINT [PKMMWMONOCLSNAME]
   PRIMARY KEY
   CLUSTERED ([CATEGORYCODE] ASC, [MONOID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_CLSNAME.PKMMWMONOCLSNAME',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_CLSNAME',
        N'CONSTRAINT', N'PKMMWMONOCLSNAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWMONOTEXT'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_MONO_TEXT] DROP CONSTRAINT [PKMMWMONOTEXT]
 GO



ALTER TABLE [DIB3_2].[MMW_MONO_TEXT]
 ADD CONSTRAINT [PKMMWMONOTEXT]
   PRIMARY KEY
   CLUSTERED ([VERSIONCODE] ASC, [CATEGORYCODE] ASC, [MONOID] ASC, [SEQUENCENUMBER] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MONO_TEXT.PKMMWMONOTEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MONO_TEXT',
        N'CONSTRAINT', N'PKMMWMONOTEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWPARCLASS'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_PAR_CLASS] DROP CONSTRAINT [PKMMWPARCLASS]
 GO



ALTER TABLE [DIB3_2].[MMW_PAR_CLASS]
 ADD CONSTRAINT [PKMMWPARCLASS]
   PRIMARY KEY
   CLUSTERED ([CLASSID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_CLASS.PKMMWPARCLASS',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_CLASS',
        N'CONSTRAINT', N'PKMMWPARCLASS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWPARCLASSLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_PAR_CLASSLINK] DROP CONSTRAINT [PKMMWPARCLASSLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_PAR_CLASSLINK]
 ADD CONSTRAINT [PKMMWPARCLASSLINK]
   PRIMARY KEY
   CLUSTERED ([KDC1] ASC, [CLASSID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_CLASSLINK.PKMMWPARCLASSLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_CLASSLINK',
        N'CONSTRAINT', N'PKMMWPARCLASSLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWPARDRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_PAR_DRUGLINK] DROP CONSTRAINT [PKMMWPARDRUGLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_PAR_DRUGLINK]
 ADD CONSTRAINT [PKMMWPARDRUGLINK]
   PRIMARY KEY
   CLUSTERED ([ALLERGYID] ASC, [KDC1] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_DRUGLINK.PKMMWPARDRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_DRUGLINK',
        N'CONSTRAINT', N'PKMMWPARDRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWPARINGRLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_PAR_INGRLINK] DROP CONSTRAINT [PKMMWPARINGRLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_PAR_INGRLINK]
 ADD CONSTRAINT [PKMMWPARINGRLINK]
   PRIMARY KEY
   CLUSTERED ([KDC1] ASC, [INGREDKDC1] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INGRLINK.PKMMWPARINGRLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INGRLINK',
        N'CONSTRAINT', N'PKMMWPARINGRLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWPARINT'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_PAR_INT] DROP CONSTRAINT [PKMMWPARINT]
 GO



ALTER TABLE [DIB3_2].[MMW_PAR_INT]
 ADD CONSTRAINT [PKMMWPARINT]
   PRIMARY KEY
   CLUSTERED ([CLASSID1] ASC, [CLASSID2] ASC, [SYMPTOMCODE] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PAR_INT.PKMMWPARINT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PAR_INT',
        N'CONSTRAINT', N'PKMMWPARINT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWPDEDRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_PDE_DRUGLINK] DROP CONSTRAINT [PKMMWPDEDRUGLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_PDE_DRUGLINK]
 ADD CONSTRAINT [PKMMWPDEDRUGLINK]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [VERSIONCODE] ASC, [MONOID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PDE_DRUGLINK.PKMMWPDEDRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PDE_DRUGLINK',
        N'CONSTRAINT', N'PKMMWPDEDRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWPRCACOM'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_PRCA_COM] DROP CONSTRAINT [PKMMWPRCACOM]
 GO



ALTER TABLE [DIB3_2].[MMW_PRCA_COM]
 ADD CONSTRAINT [PKMMWPRCACOM]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [AGEINDAYSLOW] ASC, [AGEINDAYSHIGH] ASC, [RESTRICTIONID] ASC, [SEQUENCENUMBER] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_COM.PKMMWPRCACOM',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_COM',
        N'CONSTRAINT', N'PKMMWPRCACOM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWPRCADRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_PRCA_DRUGLINK] DROP CONSTRAINT [PKMMWPRCADRUGLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_PRCA_DRUGLINK]
 ADD CONSTRAINT [PKMMWPRCADRUGLINK]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [AGEINDAYSLOW] ASC, [AGEINDAYSHIGH] ASC, [RESTRICTIONID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_DRUGLINK.PKMMWPRCADRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_DRUGLINK',
        N'CONSTRAINT', N'PKMMWPRCADRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWPRCASPECCOND'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_PRCA_SPECCOND] DROP CONSTRAINT [PKMMWPRCASPECCOND]
 GO



ALTER TABLE [DIB3_2].[MMW_PRCA_SPECCOND]
 ADD CONSTRAINT [PKMMWPRCASPECCOND]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [AGEINDAYSLOW] ASC, [AGEINDAYSHIGH] ASC, [RESTRICTIONID] ASC, [SPECCONDID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCA_SPECCOND.PKMMWPRCASPECCOND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCA_SPECCOND',
        N'CONSTRAINT', N'PKMMWPRCASPECCOND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWPRCCCOM'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_PRCC_COM] DROP CONSTRAINT [PKMMWPRCCCOM]
 GO



ALTER TABLE [DIB3_2].[MMW_PRCC_COM]
 ADD CONSTRAINT [PKMMWPRCCCOM]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [MCID] ASC, [RESTRICTIONID] ASC, [SEQUENCENUMBER] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_COM.PKMMWPRCCCOM',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_COM',
        N'CONSTRAINT', N'PKMMWPRCCCOM'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWPRCCDRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_PRCC_DRUGLINK] DROP CONSTRAINT [PKMMWPRCCDRUGLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_PRCC_DRUGLINK]
 ADD CONSTRAINT [PKMMWPRCCDRUGLINK]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [MCID] ASC, [RESTRICTIONID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_DRUGLINK.PKMMWPRCCDRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_DRUGLINK',
        N'CONSTRAINT', N'PKMMWPRCCDRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWPRCCSPECCOND'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_PRCC_SPECCOND] DROP CONSTRAINT [PKMMWPRCCSPECCOND]
 GO



ALTER TABLE [DIB3_2].[MMW_PRCC_SPECCOND]
 ADD CONSTRAINT [PKMMWPRCCSPECCOND]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [MCID] ASC, [RESTRICTIONID] ASC, [SPECCONDID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_SPECCOND.PKMMWPRCCSPECCOND',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_SPECCOND',
        N'CONSTRAINT', N'PKMMWPRCCSPECCOND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWSNOMEDMCLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_SNOMED_MC_LINK] DROP CONSTRAINT [PKMMWSNOMEDMCLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_SNOMED_MC_LINK]
 ADD CONSTRAINT [PKMMWSNOMEDMCLINK]
   PRIMARY KEY
   CLUSTERED ([MCID] ASC, [SNOMEDID] ASC, [RELATIONTYPE] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_SNOMED_MC_LINK.PKMMWSNOMEDMCLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_SNOMED_MC_LINK',
        N'CONSTRAINT', N'PKMMWSNOMEDMCLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWWLDRUGLINK'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_WL_DRUGLINK] DROP CONSTRAINT [PKMMWWLDRUGLINK]
 GO



ALTER TABLE [DIB3_2].[MMW_WL_DRUGLINK]
 ADD CONSTRAINT [PKMMWWLDRUGLINK]
   PRIMARY KEY
   CLUSTERED ([GPI] ASC, [WLID] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_DRUGLINK.PKMMWWLDRUGLINK',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_DRUGLINK',
        N'CONSTRAINT', N'PKMMWWLDRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWWLTEXT'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_WL_TEXT] DROP CONSTRAINT [PKMMWWLTEXT]
 GO



ALTER TABLE [DIB3_2].[MMW_WL_TEXT]
 ADD CONSTRAINT [PKMMWWLTEXT]
   PRIMARY KEY
   CLUSTERED ([VERSIONCODE] ASC, [WLID] ASC, [SEQUENCENUMBER] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_TEXT.PKMMWWLTEXT',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_TEXT',
        N'CONSTRAINT', N'PKMMWWLTEXT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH

GO


USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PKMMWWLVENDCODE'  AND sc.name = N'DIB3_2'  AND type in (N'PK'))
ALTER TABLE [DIB3_2].[MMW_WL_VENDCODE] DROP CONSTRAINT [PKMMWWLVENDCODE]
 GO



ALTER TABLE [DIB3_2].[MMW_WL_VENDCODE]
 ADD CONSTRAINT [PKMMWWLVENDCODE]
   PRIMARY KEY
   CLUSTERED ([VERSIONCODE] ASC, [WLID] ASC, [VENDVERSIONCODE] ASC)
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_WL_VENDCODE.PKMMWWLVENDCODE',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_WL_VENDCODE',
        N'CONSTRAINT', N'PKMMWWLVENDCODE'
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
       WHERE so.name = N'IMGIPT_DESC'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPIDCI1' AND so.type in (N'U'))
   DROP INDEX [IGPIDCI1] ON [DIB3_2].[IMGIPT_DESC] 
GO
CREATE NONCLUSTERED INDEX [IGPIDCI1] ON [DIB3_2].[IMGIPT_DESC]
(
   [CATEGORYID] ASC,
   [BASICDESCID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_DESC.IGPIDCI1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_DESC',
        N'INDEX', N'IGPIDCI1'
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
       WHERE so.name = N'IMGIPT_PROP_DESC'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPIPCI1' AND so.type in (N'U'))
   DROP INDEX [IGPIPCI1] ON [DIB3_2].[IMGIPT_PROP_DESC] 
GO
CREATE NONCLUSTERED INDEX [IGPIPCI1] ON [DIB3_2].[IMGIPT_PROP_DESC]
(
   [CATEGORYID] ASC,
   [DESCRIPTORID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROP_DESC.IGPIPCI1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROP_DESC',
        N'INDEX', N'IGPIPCI1'
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
       WHERE so.name = N'IMGIPT_PROP_TEXT'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPIPTI1' AND so.type in (N'U'))
   DROP INDEX [IGPIPTI1] ON [DIB3_2].[IMGIPT_PROP_TEXT] 
GO
CREATE NONCLUSTERED INDEX [IGPIPTI1] ON [DIB3_2].[IMGIPT_PROP_TEXT]
(
   [TEXTID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROP_TEXT.IGPIPTI1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROP_TEXT',
        N'INDEX', N'IGPIPTI1'
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
       WHERE so.name = N'IMGIPT_UNIQUE'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPIUGI1' AND so.type in (N'U'))
   DROP INDEX [IGPIUGI1] ON [DIB3_2].[IMGIPT_UNIQUE] 
GO
CREATE NONCLUSTERED INDEX [IGPIUGI1] ON [DIB3_2].[IMGIPT_UNIQUE]
(
   [MANUFACTURERID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_UNIQUE.IGPIUGI1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_UNIQUE',
        N'INDEX', N'IGPIUGI1'
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
       WHERE so.name = N'IMGIPT_UNIQUE'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPIUGI2' AND so.type in (N'U'))
   DROP INDEX [IGPIUGI2] ON [DIB3_2].[IMGIPT_UNIQUE] 
GO
CREATE NONCLUSTERED INDEX [IGPIUGI2] ON [DIB3_2].[IMGIPT_UNIQUE]
(
   [DOSAGEFORMID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_UNIQUE.IGPIUGI2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_UNIQUE',
        N'INDEX', N'IGPIUGI2'
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
       WHERE so.name = N'IMGIPT_JOURNAL'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPIUJI1' AND so.type in (N'U'))
   DROP INDEX [IGPIUJI1] ON [DIB3_2].[IMGIPT_JOURNAL] 
GO
CREATE NONCLUSTERED INDEX [IGPIUJI1] ON [DIB3_2].[IMGIPT_JOURNAL]
(
   [PROPERTYID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_JOURNAL.IGPIUJI1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_JOURNAL',
        N'INDEX', N'IGPIUJI1'
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
       WHERE so.name = N'IMGIPT_JOURNAL'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPIUJI2' AND so.type in (N'U'))
   DROP INDEX [IGPIUJI2] ON [DIB3_2].[IMGIPT_JOURNAL] 
GO
CREATE NONCLUSTERED INDEX [IGPIUJI2] ON [DIB3_2].[IMGIPT_JOURNAL]
(
   [IMAGEID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_JOURNAL.IGPIUJI2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_JOURNAL',
        N'INDEX', N'IGPIUJI2'
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
       WHERE so.name = N'IMGIPT_PROPERTY'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPPRPI1' AND so.type in (N'U'))
   DROP INDEX [IGPPRPI1] ON [DIB3_2].[IMGIPT_PROPERTY] 
GO
CREATE NONCLUSTERED INDEX [IGPPRPI1] ON [DIB3_2].[IMGIPT_PROPERTY]
(
   [BASICCOLOR1ID] ASC,
   [BASICCOLOR2ID] ASC,
   [BASICCOLOR3ID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.IGPPRPI1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'INDEX', N'IGPPRPI1'
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
       WHERE so.name = N'IMGIPT_PROPERTY'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPPRPI2' AND so.type in (N'U'))
   DROP INDEX [IGPPRPI2] ON [DIB3_2].[IMGIPT_PROPERTY] 
GO
CREATE NONCLUSTERED INDEX [IGPPRPI2] ON [DIB3_2].[IMGIPT_PROPERTY]
(
   [BASICSHAPEID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.IGPPRPI2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'INDEX', N'IGPPRPI2'
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
       WHERE so.name = N'IMGIPT_PROPERTY'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPPRPI3' AND so.type in (N'U'))
   DROP INDEX [IGPPRPI3] ON [DIB3_2].[IMGIPT_PROPERTY] 
GO
CREATE NONCLUSTERED INDEX [IGPPRPI3] ON [DIB3_2].[IMGIPT_PROPERTY]
(
   [COLOR1ID] ASC,
   [COLOR2ID] ASC,
   [COLOR3ID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.IGPPRPI3',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'INDEX', N'IGPPRPI3'
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
       WHERE so.name = N'IMGIPT_PROPERTY'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPPRPI4' AND so.type in (N'U'))
   DROP INDEX [IGPPRPI4] ON [DIB3_2].[IMGIPT_PROPERTY] 
GO
CREATE NONCLUSTERED INDEX [IGPPRPI4] ON [DIB3_2].[IMGIPT_PROPERTY]
(
   [COATINGID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.IGPPRPI4',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'INDEX', N'IGPPRPI4'
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
       WHERE so.name = N'IMGIPT_PROPERTY'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPPRPI5' AND so.type in (N'U'))
   DROP INDEX [IGPPRPI5] ON [DIB3_2].[IMGIPT_PROPERTY] 
GO
CREATE NONCLUSTERED INDEX [IGPPRPI5] ON [DIB3_2].[IMGIPT_PROPERTY]
(
   [CLARITYID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.IGPPRPI5',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'INDEX', N'IGPPRPI5'
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
       WHERE so.name = N'IMGIPT_PROPERTY'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPPRPI6' AND so.type in (N'U'))
   DROP INDEX [IGPPRPI6] ON [DIB3_2].[IMGIPT_PROPERTY] 
GO
CREATE NONCLUSTERED INDEX [IGPPRPI6] ON [DIB3_2].[IMGIPT_PROPERTY]
(
   [FLAVORID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.IGPPRPI6',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'INDEX', N'IGPPRPI6'
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
       WHERE so.name = N'IMGIPT_PROPERTY'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPPRPI7' AND so.type in (N'U'))
   DROP INDEX [IGPPRPI7] ON [DIB3_2].[IMGIPT_PROPERTY] 
GO
CREATE NONCLUSTERED INDEX [IGPPRPI7] ON [DIB3_2].[IMGIPT_PROPERTY]
(
   [SHAPEID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.IGPPRPI7',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'INDEX', N'IGPPRPI7'
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
       WHERE so.name = N'IMGIPT_PROPERTY'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPPRPI8' AND so.type in (N'U'))
   DROP INDEX [IGPPRPI8] ON [DIB3_2].[IMGIPT_PROPERTY] 
GO
CREATE NONCLUSTERED INDEX [IGPPRPI8] ON [DIB3_2].[IMGIPT_PROPERTY]
(
   [IMPRINTSIDE1] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.IGPPRPI8',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'INDEX', N'IGPPRPI8'
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
       WHERE so.name = N'IMGIPT_PROPERTY'  AND sc.name = N'DIB3_2'  AND si.name = N'IGPPRPI9' AND so.type in (N'U'))
   DROP INDEX [IGPPRPI9] ON [DIB3_2].[IMGIPT_PROPERTY] 
GO
CREATE NONCLUSTERED INDEX [IGPPRPI9] ON [DIB3_2].[IMGIPT_PROPERTY]
(
   [IMPRINTSIDE2] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.IMGIPT_PROPERTY.IGPPRPI9',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'IMGIPT_PROPERTY',
        N'INDEX', N'IGPPRPI9'
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
       WHERE so.name = N'MMW_ADE_COM'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWADECOM1' AND so.type in (N'U'))
   DROP INDEX [IXMMWADECOM1] ON [DIB3_2].[MMW_ADE_COM] 
GO
CREATE NONCLUSTERED INDEX [IXMMWADECOM1] ON [DIB3_2].[MMW_ADE_COM]
(
   [MCID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_COM.IXMMWADECOM1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_COM',
        N'INDEX', N'IXMMWADECOM1'
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
       WHERE so.name = N'MMW_ADE_DRUGLINK'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWADEDRUGLINK1' AND so.type in (N'U'))
   DROP INDEX [IXMMWADEDRUGLINK1] ON [DIB3_2].[MMW_ADE_DRUGLINK] 
GO
CREATE NONCLUSTERED INDEX [IXMMWADEDRUGLINK1] ON [DIB3_2].[MMW_ADE_DRUGLINK]
(
   [MCID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_DRUGLINK.IXMMWADEDRUGLINK1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_DRUGLINK',
        N'INDEX', N'IXMMWADEDRUGLINK1'
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
       WHERE so.name = N'MMW_ADE_SPECCOND'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWADESPECCOND1' AND so.type in (N'U'))
   DROP INDEX [IXMMWADESPECCOND1] ON [DIB3_2].[MMW_ADE_SPECCOND] 
GO
CREATE NONCLUSTERED INDEX [IXMMWADESPECCOND1] ON [DIB3_2].[MMW_ADE_SPECCOND]
(
   [MCID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_ADE_SPECCOND.IXMMWADESPECCOND1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_ADE_SPECCOND',
        N'INDEX', N'IXMMWADESPECCOND1'
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
       WHERE so.name = N'MMW_CLS_AHFS'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWCLSAHFS1' AND so.type in (N'U'))
   DROP INDEX [IXMMWCLSAHFS1] ON [DIB3_2].[MMW_CLS_AHFS] 
GO
CREATE NONCLUSTERED INDEX [IXMMWCLSAHFS1] ON [DIB3_2].[MMW_CLS_AHFS]
(
   [DESCPHONETIC] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFS.IXMMWCLSAHFS1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFS',
        N'INDEX', N'IXMMWCLSAHFS1'
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
       WHERE so.name = N'MMW_CLS_AHFS'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWCLSAHFS2' AND so.type in (N'U'))
   DROP INDEX [IXMMWCLSAHFS2] ON [DIB3_2].[MMW_CLS_AHFS] 
GO
CREATE NONCLUSTERED INDEX [IXMMWCLSAHFS2] ON [DIB3_2].[MMW_CLS_AHFS]
(
   [DESCSEARCH] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFS.IXMMWCLSAHFS2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFS',
        N'INDEX', N'IXMMWCLSAHFS2'
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
       WHERE so.name = N'MMW_CLS_AHFS'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWCLSAHFS3' AND so.type in (N'U'))
   DROP INDEX [IXMMWCLSAHFS3] ON [DIB3_2].[MMW_CLS_AHFS] 
GO
CREATE NONCLUSTERED INDEX [IXMMWCLSAHFS3] ON [DIB3_2].[MMW_CLS_AHFS]
(
   [PARENTCLASSID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFS.IXMMWCLSAHFS3',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFS',
        N'INDEX', N'IXMMWCLSAHFS3'
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
       WHERE so.name = N'MMW_CLS_AHFSDRUG'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWCLSAHFSDRUG1' AND so.type in (N'U'))
   DROP INDEX [IXMMWCLSAHFSDRUG1] ON [DIB3_2].[MMW_CLS_AHFSDRUG] 
GO
CREATE NONCLUSTERED INDEX [IXMMWCLSAHFSDRUG1] ON [DIB3_2].[MMW_CLS_AHFSDRUG]
(
   [DRUGID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_AHFSDRUG.IXMMWCLSAHFSDRUG1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_AHFSDRUG',
        N'INDEX', N'IXMMWCLSAHFSDRUG1'
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
       WHERE so.name = N'MMW_CLS_GPI'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWCLSGPI1' AND so.type in (N'U'))
   DROP INDEX [IXMMWCLSGPI1] ON [DIB3_2].[MMW_CLS_GPI] 
GO
CREATE NONCLUSTERED INDEX [IXMMWCLSGPI1] ON [DIB3_2].[MMW_CLS_GPI]
(
   [DESCPHONETIC] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPI.IXMMWCLSGPI1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPI',
        N'INDEX', N'IXMMWCLSGPI1'
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
       WHERE so.name = N'MMW_CLS_GPI'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWCLSGPI2' AND so.type in (N'U'))
   DROP INDEX [IXMMWCLSGPI2] ON [DIB3_2].[MMW_CLS_GPI] 
GO
CREATE NONCLUSTERED INDEX [IXMMWCLSGPI2] ON [DIB3_2].[MMW_CLS_GPI]
(
   [DESCSEARCH] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPI.IXMMWCLSGPI2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPI',
        N'INDEX', N'IXMMWCLSGPI2'
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
       WHERE so.name = N'MMW_CLS_GPI'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWCLSGPI3' AND so.type in (N'U'))
   DROP INDEX [IXMMWCLSGPI3] ON [DIB3_2].[MMW_CLS_GPI] 
GO
CREATE NONCLUSTERED INDEX [IXMMWCLSGPI3] ON [DIB3_2].[MMW_CLS_GPI]
(
   [PARENTCLASSID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPI.IXMMWCLSGPI3',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPI',
        N'INDEX', N'IXMMWCLSGPI3'
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
       WHERE so.name = N'MMW_CLS_GPIDRUG'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWCLSGPIDRUG1' AND so.type in (N'U'))
   DROP INDEX [IXMMWCLSGPIDRUG1] ON [DIB3_2].[MMW_CLS_GPIDRUG] 
GO
CREATE NONCLUSTERED INDEX [IXMMWCLSGPIDRUG1] ON [DIB3_2].[MMW_CLS_GPIDRUG]
(
   [DRUGID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_CLS_GPIDRUG.IXMMWCLSGPIDRUG1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_CLS_GPIDRUG',
        N'INDEX', N'IXMMWCLSGPIDRUG1'
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
       WHERE so.name = N'MMW_DI_CLASSLINK'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWDICLASSLINK1' AND so.type in (N'U'))
   DROP INDEX [IXMMWDICLASSLINK1] ON [DIB3_2].[MMW_DI_CLASSLINK] 
GO
CREATE NONCLUSTERED INDEX [IXMMWDICLASSLINK1] ON [DIB3_2].[MMW_DI_CLASSLINK]
(
   [CLASSID] ASC,
   [KDC1] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_CLASSLINK.IXMMWDICLASSLINK1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_CLASSLINK',
        N'INDEX', N'IXMMWDICLASSLINK1'
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
       WHERE so.name = N'MMW_DI_INT'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWDIINT1' AND so.type in (N'U'))
   DROP INDEX [IXMMWDIINT1] ON [DIB3_2].[MMW_DI_INT] 
GO
CREATE NONCLUSTERED INDEX [IXMMWDIINT1] ON [DIB3_2].[MMW_DI_INT]
(
   [CLASSID1] ASC,
   [ACTCODE1] ASC,
   [CLASSID2] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.IXMMWDIINT1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'INDEX', N'IXMMWDIINT1'
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
       WHERE so.name = N'MMW_DI_INT'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWDIINT2' AND so.type in (N'U'))
   DROP INDEX [IXMMWDIINT2] ON [DIB3_2].[MMW_DI_INT] 
GO
CREATE NONCLUSTERED INDEX [IXMMWDIINT2] ON [DIB3_2].[MMW_DI_INT]
(
   [CLASSID2] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DI_INT.IXMMWDIINT2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DI_INT',
        N'INDEX', N'IXMMWDIINT2'
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
       WHERE so.name = N'MMW_DRUG_DISP'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWDRUGDISP1' AND so.type in (N'U'))
   DROP INDEX [IXMMWDRUGDISP1] ON [DIB3_2].[MMW_DRUG_DISP] 
GO
CREATE NONCLUSTERED INDEX [IXMMWDRUGDISP1] ON [DIB3_2].[MMW_DRUG_DISP]
(
   [PNID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.IXMMWDRUGDISP1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'INDEX', N'IXMMWDRUGDISP1'
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
       WHERE so.name = N'MMW_DRUG_DISP'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWDRUGDISP2' AND so.type in (N'U'))
   DROP INDEX [IXMMWDRUGDISP2] ON [DIB3_2].[MMW_DRUG_DISP] 
GO
CREATE NONCLUSTERED INDEX [IXMMWDRUGDISP2] ON [DIB3_2].[MMW_DRUG_DISP]
(
   [DESCPHONETIC] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.IXMMWDRUGDISP2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'INDEX', N'IXMMWDRUGDISP2'
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
       WHERE so.name = N'MMW_DRUG_DISP'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWDRUGDISP3' AND so.type in (N'U'))
   DROP INDEX [IXMMWDRUGDISP3] ON [DIB3_2].[MMW_DRUG_DISP] 
GO
CREATE NONCLUSTERED INDEX [IXMMWDRUGDISP3] ON [DIB3_2].[MMW_DRUG_DISP]
(
   [DESCSEARCH] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.IXMMWDRUGDISP3',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'INDEX', N'IXMMWDRUGDISP3'
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
       WHERE so.name = N'MMW_DRUG_DISP'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWDRUGDISP4' AND so.type in (N'U'))
   DROP INDEX [IXMMWDRUGDISP4] ON [DIB3_2].[MMW_DRUG_DISP] 
GO
CREATE NONCLUSTERED INDEX [IXMMWDRUGDISP4] ON [DIB3_2].[MMW_DRUG_DISP]
(
   [GPI] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.IXMMWDRUGDISP4',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'INDEX', N'IXMMWDRUGDISP4'
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
       WHERE so.name = N'MMW_DRUG_DISP'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWDRUGDISP5' AND so.type in (N'U'))
   DROP INDEX [IXMMWDRUGDISP5] ON [DIB3_2].[MMW_DRUG_DISP] 
GO
CREATE NONCLUSTERED INDEX [IXMMWDRUGDISP5] ON [DIB3_2].[MMW_DRUG_DISP]
(
   [RPID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_DISP.IXMMWDRUGDISP5',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_DISP',
        N'INDEX', N'IXMMWDRUGDISP5'
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
       WHERE so.name = N'MMW_DRUG_NAME'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWDRUGNAME1' AND so.type in (N'U'))
   DROP INDEX [IXMMWDRUGNAME1] ON [DIB3_2].[MMW_DRUG_NAME] 
GO
CREATE NONCLUSTERED INDEX [IXMMWDRUGNAME1] ON [DIB3_2].[MMW_DRUG_NAME]
(
   [DESCPHONETIC] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.IXMMWDRUGNAME1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'INDEX', N'IXMMWDRUGNAME1'
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
       WHERE so.name = N'MMW_DRUG_NAME'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWDRUGNAME2' AND so.type in (N'U'))
   DROP INDEX [IXMMWDRUGNAME2] ON [DIB3_2].[MMW_DRUG_NAME] 
GO
CREATE NONCLUSTERED INDEX [IXMMWDRUGNAME2] ON [DIB3_2].[MMW_DRUG_NAME]
(
   [DESCSEARCH] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_NAME.IXMMWDRUGNAME2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_NAME',
        N'INDEX', N'IXMMWDRUGNAME2'
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
       WHERE so.name = N'MMW_DRUG_PACK'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWDRUGPACK1' AND so.type in (N'U'))
   DROP INDEX [IXMMWDRUGPACK1] ON [DIB3_2].[MMW_DRUG_PACK] 
GO
CREATE NONCLUSTERED INDEX [IXMMWDRUGPACK1] ON [DIB3_2].[MMW_DRUG_PACK]
(
   [DDID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_PACK.IXMMWDRUGPACK1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_PACK',
        N'INDEX', N'IXMMWDRUGPACK1'
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
       WHERE so.name = N'MMW_DRUG_ROUTED'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWDRUGROUTED1' AND so.type in (N'U'))
   DROP INDEX [IXMMWDRUGROUTED1] ON [DIB3_2].[MMW_DRUG_ROUTED] 
GO
CREATE NONCLUSTERED INDEX [IXMMWDRUGROUTED1] ON [DIB3_2].[MMW_DRUG_ROUTED]
(
   [DESCPHONETIC] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.IXMMWDRUGROUTED1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'INDEX', N'IXMMWDRUGROUTED1'
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
       WHERE so.name = N'MMW_DRUG_ROUTED'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWDRUGROUTED2' AND so.type in (N'U'))
   DROP INDEX [IXMMWDRUGROUTED2] ON [DIB3_2].[MMW_DRUG_ROUTED] 
GO
CREATE NONCLUSTERED INDEX [IXMMWDRUGROUTED2] ON [DIB3_2].[MMW_DRUG_ROUTED]
(
   [DESCSEARCH] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.IXMMWDRUGROUTED2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'INDEX', N'IXMMWDRUGROUTED2'
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
       WHERE so.name = N'MMW_DRUG_ROUTED'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWDRUGROUTED3' AND so.type in (N'U'))
   DROP INDEX [IXMMWDRUGROUTED3] ON [DIB3_2].[MMW_DRUG_ROUTED] 
GO
CREATE NONCLUSTERED INDEX [IXMMWDRUGROUTED3] ON [DIB3_2].[MMW_DRUG_ROUTED]
(
   [PNID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_DRUG_ROUTED.IXMMWDRUGROUTED3',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_DRUG_ROUTED',
        N'INDEX', N'IXMMWDRUGROUTED3'
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
       WHERE so.name = N'MMW_IND_COM'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWINDCOM1' AND so.type in (N'U'))
   DROP INDEX [IXMMWINDCOM1] ON [DIB3_2].[MMW_IND_COM] 
GO
CREATE NONCLUSTERED INDEX [IXMMWINDCOM1] ON [DIB3_2].[MMW_IND_COM]
(
   [MCID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COM.IXMMWINDCOM1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COM',
        N'INDEX', N'IXMMWINDCOM1'
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
       WHERE so.name = N'MMW_IND_COTREAT'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWINDCOTREAT1' AND so.type in (N'U'))
   DROP INDEX [IXMMWINDCOTREAT1] ON [DIB3_2].[MMW_IND_COTREAT] 
GO
CREATE NONCLUSTERED INDEX [IXMMWINDCOTREAT1] ON [DIB3_2].[MMW_IND_COTREAT]
(
   [MCID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_COTREAT.IXMMWINDCOTREAT1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_COTREAT',
        N'INDEX', N'IXMMWINDCOTREAT1'
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
       WHERE so.name = N'MMW_IND_DRUGLINK'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWINDDRUGLINK1' AND so.type in (N'U'))
   DROP INDEX [IXMMWINDDRUGLINK1] ON [DIB3_2].[MMW_IND_DRUGLINK] 
GO
CREATE NONCLUSTERED INDEX [IXMMWINDDRUGLINK1] ON [DIB3_2].[MMW_IND_DRUGLINK]
(
   [MCID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_DRUGLINK.IXMMWINDDRUGLINK1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_DRUGLINK',
        N'INDEX', N'IXMMWINDDRUGLINK1'
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
       WHERE so.name = N'MMW_IND_SOURCE'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWINDSOURCE1' AND so.type in (N'U'))
   DROP INDEX [IXMMWINDSOURCE1] ON [DIB3_2].[MMW_IND_SOURCE] 
GO
CREATE NONCLUSTERED INDEX [IXMMWINDSOURCE1] ON [DIB3_2].[MMW_IND_SOURCE]
(
   [MCID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_IND_SOURCE.IXMMWINDSOURCE1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_IND_SOURCE',
        N'INDEX', N'IXMMWINDSOURCE1'
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
       WHERE so.name = N'MMW_MED_EXTVOCAB'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWMEDEXTVOCAB1' AND so.type in (N'U'))
   DROP INDEX [IXMMWMEDEXTVOCAB1] ON [DIB3_2].[MMW_MED_EXTVOCAB] 
GO
CREATE NONCLUSTERED INDEX [IXMMWMEDEXTVOCAB1] ON [DIB3_2].[MMW_MED_EXTVOCAB]
(
   [EXTVOCABID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_EXTVOCAB.IXMMWMEDEXTVOCAB1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_EXTVOCAB',
        N'INDEX', N'IXMMWMEDEXTVOCAB1'
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
       WHERE so.name = N'MMW_MED_INTVOCAB'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWMEDINTVOCAB1' AND so.type in (N'U'))
   DROP INDEX [IXMMWMEDINTVOCAB1] ON [DIB3_2].[MMW_MED_INTVOCAB] 
GO
CREATE NONCLUSTERED INDEX [IXMMWMEDINTVOCAB1] ON [DIB3_2].[MMW_MED_INTVOCAB]
(
   [MCID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_INTVOCAB.IXMMWMEDINTVOCAB1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_INTVOCAB',
        N'INDEX', N'IXMMWMEDINTVOCAB1'
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
       WHERE so.name = N'MMW_MED_NAME'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWMEDNAME1' AND so.type in (N'U'))
   DROP INDEX [IXMMWMEDNAME1] ON [DIB3_2].[MMW_MED_NAME] 
GO
CREATE NONCLUSTERED INDEX [IXMMWMEDNAME1] ON [DIB3_2].[MMW_MED_NAME]
(
   [NAMEPHONETIC] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_NAME.IXMMWMEDNAME1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_NAME',
        N'INDEX', N'IXMMWMEDNAME1'
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
       WHERE so.name = N'MMW_MED_NAME'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWMEDNAME2' AND so.type in (N'U'))
   DROP INDEX [IXMMWMEDNAME2] ON [DIB3_2].[MMW_MED_NAME] 
GO
CREATE NONCLUSTERED INDEX [IXMMWMEDNAME2] ON [DIB3_2].[MMW_MED_NAME]
(
   [NAMESEARCH] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_MED_NAME.IXMMWMEDNAME2',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_MED_NAME',
        N'INDEX', N'IXMMWMEDNAME2'
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
       WHERE so.name = N'MMW_PRCC_COM'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWPRCCCOM1' AND so.type in (N'U'))
   DROP INDEX [IXMMWPRCCCOM1] ON [DIB3_2].[MMW_PRCC_COM] 
GO
CREATE NONCLUSTERED INDEX [IXMMWPRCCCOM1] ON [DIB3_2].[MMW_PRCC_COM]
(
   [MCID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_COM.IXMMWPRCCCOM1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_COM',
        N'INDEX', N'IXMMWPRCCCOM1'
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
       WHERE so.name = N'MMW_PRCC_DRUGLINK'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWPRCCDRUGLINK1' AND so.type in (N'U'))
   DROP INDEX [IXMMWPRCCDRUGLINK1] ON [DIB3_2].[MMW_PRCC_DRUGLINK] 
GO
CREATE NONCLUSTERED INDEX [IXMMWPRCCDRUGLINK1] ON [DIB3_2].[MMW_PRCC_DRUGLINK]
(
   [MCID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_DRUGLINK.IXMMWPRCCDRUGLINK1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_DRUGLINK',
        N'INDEX', N'IXMMWPRCCDRUGLINK1'
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
       WHERE so.name = N'MMW_PRCC_SPECCOND'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWPRCCSPECCOND1' AND so.type in (N'U'))
   DROP INDEX [IXMMWPRCCSPECCOND1] ON [DIB3_2].[MMW_PRCC_SPECCOND] 
GO
CREATE NONCLUSTERED INDEX [IXMMWPRCCSPECCOND1] ON [DIB3_2].[MMW_PRCC_SPECCOND]
(
   [MCID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_PRCC_SPECCOND.IXMMWPRCCSPECCOND1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_PRCC_SPECCOND',
        N'INDEX', N'IXMMWPRCCSPECCOND1'
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
       WHERE so.name = N'MMW_SNOMED_MC_LINK'  AND sc.name = N'DIB3_2'  AND si.name = N'IXMMWSNOMEDMCLINK1' AND so.type in (N'U'))
   DROP INDEX [IXMMWSNOMEDMCLINK1] ON [DIB3_2].[MMW_SNOMED_MC_LINK] 
GO
CREATE NONCLUSTERED INDEX [IXMMWSNOMEDMCLINK1] ON [DIB3_2].[MMW_SNOMED_MC_LINK]
(
   [MCID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB3_2.MMW_SNOMED_MC_LINK.IXMMWSNOMEDMCLINK1',
        N'SCHEMA', N'DIB3_2',
        N'TABLE', N'MMW_SNOMED_MC_LINK',
        N'INDEX', N'IXMMWSNOMEDMCLINK1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

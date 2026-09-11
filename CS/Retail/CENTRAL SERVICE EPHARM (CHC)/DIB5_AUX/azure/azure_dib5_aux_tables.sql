
USE noneprdb
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'DIB5_AUX')      
     EXEC (N'CREATE SCHEMA DIB5_AUX')                                   
 GO                                                               

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'AGFILE'  AND sc.name = N'DIB5_AUX'  AND type in (N'U'))
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
             WHERE so.name = N'AGFILE'  AND sc.name = N'DIB5_AUX'  AND type in (N'U')
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

  DROP TABLE [DIB5_AUX].[AGFILE]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB5_AUX].[AGFILE]
(
   [AG] char(3)  NOT NULL,
   [ACLASS] varchar(25)  NULL,
   [CSC_0] char(3)  NULL,
   [CSC_1] char(3)  NULL,
   [CSC_2] char(3)  NULL,
   [CSC_3] char(3)  NULL,
   [CSC_4] char(3)  NULL,
   [CSC_5] char(3)  NULL,
   [CR] char(1)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.AGFILE',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'AGFILE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.AGFILE.AG',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'AGFILE',
        N'COLUMN', N'AG'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.AGFILE.ACLASS',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'AGFILE',
        N'COLUMN', N'ACLASS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.AGFILE.CSC_0',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'AGFILE',
        N'COLUMN', N'CSC_0'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.AGFILE.CSC_1',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'AGFILE',
        N'COLUMN', N'CSC_1'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.AGFILE.CSC_2',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'AGFILE',
        N'COLUMN', N'CSC_2'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.AGFILE.CSC_3',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'AGFILE',
        N'COLUMN', N'CSC_3'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.AGFILE.CSC_4',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'AGFILE',
        N'COLUMN', N'CSC_4'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.AGFILE.CSC_5',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'AGFILE',
        N'COLUMN', N'CSC_5'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.AGFILE.CR',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'AGFILE',
        N'COLUMN', N'CR'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'DISFILE'  AND sc.name = N'DIB5_AUX'  AND type in (N'U'))
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
             WHERE so.name = N'DISFILE'  AND sc.name = N'DIB5_AUX'  AND type in (N'U')
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

  DROP TABLE [DIB5_AUX].[DISFILE]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB5_AUX].[DISFILE]
(
   [CODE] varchar(10)  NOT NULL,
   [DESCRIPTION] varchar(25)  NOT NULL,
   [MNEMONIC] varchar(10)  NOT NULL,
   [DURATION] varchar(1)  NOT NULL,
   [DEACTIVATE_DATE] datetime2(6)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.DISFILE',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'DISFILE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.DISFILE.CODE',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'DISFILE',
        N'COLUMN', N'CODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.DISFILE.DESCRIPTION',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'DISFILE',
        N'COLUMN', N'DESCRIPTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.DISFILE.MNEMONIC',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'DISFILE',
        N'COLUMN', N'MNEMONIC'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.DISFILE.DURATION',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'DISFILE',
        N'COLUMN', N'DURATION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.DISFILE.DEACTIVATE_DATE',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'DISFILE',
        N'COLUMN', N'DEACTIVATE_DATE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_FC_CONTENT'  AND sc.name = N'DIB5_AUX'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_FC_CONTENT'  AND sc.name = N'DIB5_AUX'  AND type in (N'U')
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

  DROP TABLE [DIB5_AUX].[MMW_FC_CONTENT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB5_AUX].[MMW_FC_CONTENT]
(
   [ID] numeric(6, 0)  NOT NULL,
   [CONTENT] varchar(max)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_CONTENT',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_CONTENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_CONTENT.ID',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_CONTENT',
        N'COLUMN', N'ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_CONTENT.CONTENT',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_CONTENT',
        N'COLUMN', N'CONTENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_FC_DRUGLINK'  AND sc.name = N'DIB5_AUX'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_FC_DRUGLINK'  AND sc.name = N'DIB5_AUX'  AND type in (N'U')
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

  DROP TABLE [DIB5_AUX].[MMW_FC_DRUGLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB5_AUX].[MMW_FC_DRUGLINK]
(
   [DRUGID] varchar(20)  NOT NULL,
   [ELEMENTID] numeric(38, 0)  NOT NULL,
   [DOCUMENTCODE] varchar(10)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_DRUGLINK',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_DRUGLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_DRUGLINK.DRUGID',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_DRUGLINK',
        N'COLUMN', N'DRUGID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_DRUGLINK.ELEMENTID',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_DRUGLINK',
        N'COLUMN', N'ELEMENTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_DRUGLINK.DOCUMENTCODE',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_DRUGLINK',
        N'COLUMN', N'DOCUMENTCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_FC_ELEMENT'  AND sc.name = N'DIB5_AUX'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_FC_ELEMENT'  AND sc.name = N'DIB5_AUX'  AND type in (N'U')
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

  DROP TABLE [DIB5_AUX].[MMW_FC_ELEMENT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB5_AUX].[MMW_FC_ELEMENT]
(
   [ELEMENTID] numeric(38, 0)  NOT NULL,
   [DOCUMENTCODE] varchar(10)  NOT NULL,
   [PARENTID] numeric(38, 0)  NOT NULL,
   [CHILDSEQUENCE] numeric(38, 0)  NOT NULL,
   [TAGTYPE] varchar(40)  NOT NULL,
   [IDATTRIBUTE] varchar(32)  NULL,
   [HASSECTIONSIND] numeric(38, 0)  NOT NULL,
   [FILENAME] varchar(30)  NOT NULL,
   [ELEMENTTITLE] varchar(255)  NOT NULL,
   [XPATH] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_ELEMENT',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_ELEMENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_ELEMENT.ELEMENTID',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_ELEMENT',
        N'COLUMN', N'ELEMENTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_ELEMENT.DOCUMENTCODE',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_ELEMENT',
        N'COLUMN', N'DOCUMENTCODE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_ELEMENT.PARENTID',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_ELEMENT',
        N'COLUMN', N'PARENTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_ELEMENT.CHILDSEQUENCE',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_ELEMENT',
        N'COLUMN', N'CHILDSEQUENCE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_ELEMENT.TAGTYPE',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_ELEMENT',
        N'COLUMN', N'TAGTYPE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_ELEMENT.IDATTRIBUTE',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_ELEMENT',
        N'COLUMN', N'IDATTRIBUTE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_ELEMENT.HASSECTIONSIND',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_ELEMENT',
        N'COLUMN', N'HASSECTIONSIND'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_ELEMENT.FILENAME',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_ELEMENT',
        N'COLUMN', N'FILENAME'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_ELEMENT.ELEMENTTITLE',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_ELEMENT',
        N'COLUMN', N'ELEMENTTITLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_ELEMENT.XPATH',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_ELEMENT',
        N'COLUMN', N'XPATH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_FC_SECTION'  AND sc.name = N'DIB5_AUX'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_FC_SECTION'  AND sc.name = N'DIB5_AUX'  AND type in (N'U')
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

  DROP TABLE [DIB5_AUX].[MMW_FC_SECTION]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB5_AUX].[MMW_FC_SECTION]
(
   [SECTIONID] numeric(38, 0)  NOT NULL,
   [SECTIONTITLE] varchar(40)  NOT NULL,
   [XPATH] varchar(255)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_SECTION',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_SECTION'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_SECTION.SECTIONID',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_SECTION',
        N'COLUMN', N'SECTIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_SECTION.SECTIONTITLE',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_SECTION',
        N'COLUMN', N'SECTIONTITLE'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_SECTION.XPATH',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_SECTION',
        N'COLUMN', N'XPATH'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_FC_SECTION_CONTENT'  AND sc.name = N'DIB5_AUX'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_FC_SECTION_CONTENT'  AND sc.name = N'DIB5_AUX'  AND type in (N'U')
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

  DROP TABLE [DIB5_AUX].[MMW_FC_SECTION_CONTENT]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB5_AUX].[MMW_FC_SECTION_CONTENT]
(
   [MONOGRAPH_ID] numeric(6, 0)  NOT NULL,
   [SECTION_ID] numeric(22, 0)  NOT NULL,
   [CONTENT] varchar(max)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_SECTION_CONTENT',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_SECTION_CONTENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_SECTION_CONTENT.MONOGRAPH_ID',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_SECTION_CONTENT',
        N'COLUMN', N'MONOGRAPH_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_SECTION_CONTENT.SECTION_ID',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_SECTION_CONTENT',
        N'COLUMN', N'SECTION_ID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_SECTION_CONTENT.CONTENT',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_SECTION_CONTENT',
        N'COLUMN', N'CONTENT'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'MMW_FC_SECTIONLINK'  AND sc.name = N'DIB5_AUX'  AND type in (N'U'))
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
             WHERE so.name = N'MMW_FC_SECTIONLINK'  AND sc.name = N'DIB5_AUX'  AND type in (N'U')
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

  DROP TABLE [DIB5_AUX].[MMW_FC_SECTIONLINK]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB5_AUX].[MMW_FC_SECTIONLINK]
(
   [ELEMENTID] numeric(38, 0)  NOT NULL,
   [SECTIONID] numeric(38, 0)  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_SECTIONLINK',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_SECTIONLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_SECTIONLINK.ELEMENTID',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_SECTIONLINK',
        N'COLUMN', N'ELEMENTID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_SECTIONLINK.SECTIONID',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_SECTIONLINK',
        N'COLUMN', N'SECTIONID'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE noneprdb
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'TOP_DRUGS'  AND sc.name = N'DIB5_AUX'  AND type in (N'U'))
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
             WHERE so.name = N'TOP_DRUGS'  AND sc.name = N'DIB5_AUX'  AND type in (N'U')
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

  DROP TABLE [DIB5_AUX].[TOP_DRUGS]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[DIB5_AUX].[TOP_DRUGS]
(
   [DESCSEARCH] varchar(35)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.TOP_DRUGS',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'TOP_DRUGS'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.TOP_DRUGS.DESCSEARCH',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'TOP_DRUGS',
        N'COLUMN', N'DESCSEARCH'
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
       WHERE so.name = N'MMW_FC_ELEMENT'  AND sc.name = N'DIB5_AUX'  AND si.name = N'IXMMWFCELEMENT1' AND so.type in (N'U'))
   DROP INDEX [IXMMWFCELEMENT1] ON [DIB5_AUX].[MMW_FC_ELEMENT] 
GO
CREATE NONCLUSTERED INDEX [IXMMWFCELEMENT1] ON [DIB5_AUX].[MMW_FC_ELEMENT]
(
   [IDATTRIBUTE] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_ELEMENT.IXMMWFCELEMENT1',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_ELEMENT',
        N'INDEX', N'IXMMWFCELEMENT1'
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
       WHERE so.name = N'MMW_FC_CONTENT'  AND sc.name = N'DIB5_AUX'  AND si.name = N'MMW_FC_CONTENT_ID_PK_1' AND so.type in (N'U'))
   DROP INDEX [MMW_FC_CONTENT_ID_PK_1] ON [DIB5_AUX].[MMW_FC_CONTENT] 
GO
CREATE UNIQUE NONCLUSTERED INDEX [MMW_FC_CONTENT_ID_PK_1] ON [DIB5_AUX].[MMW_FC_CONTENT]
(
   [ID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_CONTENT.MMW_FC_CONTENT_ID_PK_1',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_CONTENT',
        N'INDEX', N'MMW_FC_CONTENT_ID_PK_1'
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
       WHERE so.name = N'MMW_FC_SECTION_CONTENT'  AND sc.name = N'DIB5_AUX'  AND si.name = N'MMW_FC_SECTION_CONTENT_PK' AND so.type in (N'U'))
   DROP INDEX [MMW_FC_SECTION_CONTENT_PK] ON [DIB5_AUX].[MMW_FC_SECTION_CONTENT] 
GO
CREATE UNIQUE NONCLUSTERED INDEX [MMW_FC_SECTION_CONTENT_PK] ON [DIB5_AUX].[MMW_FC_SECTION_CONTENT]
(
   [MONOGRAPH_ID] ASC,
   [SECTION_ID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_SECTION_CONTENT.MMW_FC_SECTION_CONTENT_PK',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_SECTION_CONTENT',
        N'INDEX', N'MMW_FC_SECTION_CONTENT_PK'
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
       WHERE so.name = N'MMW_FC_DRUGLINK'  AND sc.name = N'DIB5_AUX'  AND si.name = N'PKMMWFCDRUGLINK' AND so.type in (N'U'))
   DROP INDEX [PKMMWFCDRUGLINK] ON [DIB5_AUX].[MMW_FC_DRUGLINK] 
GO
CREATE UNIQUE NONCLUSTERED INDEX [PKMMWFCDRUGLINK] ON [DIB5_AUX].[MMW_FC_DRUGLINK]
(
   [DRUGID] ASC,
   [ELEMENTID] ASC,
   [DOCUMENTCODE] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_DRUGLINK.PKMMWFCDRUGLINK',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_DRUGLINK',
        N'INDEX', N'PKMMWFCDRUGLINK'
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
       WHERE so.name = N'MMW_FC_ELEMENT'  AND sc.name = N'DIB5_AUX'  AND si.name = N'PKMMWFCELEMENT' AND so.type in (N'U'))
   DROP INDEX [PKMMWFCELEMENT] ON [DIB5_AUX].[MMW_FC_ELEMENT] 
GO
CREATE UNIQUE NONCLUSTERED INDEX [PKMMWFCELEMENT] ON [DIB5_AUX].[MMW_FC_ELEMENT]
(
   [ELEMENTID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_ELEMENT.PKMMWFCELEMENT',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_ELEMENT',
        N'INDEX', N'PKMMWFCELEMENT'
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
       WHERE so.name = N'MMW_FC_SECTION'  AND sc.name = N'DIB5_AUX'  AND si.name = N'PKMMWFCSECTION' AND so.type in (N'U'))
   DROP INDEX [PKMMWFCSECTION] ON [DIB5_AUX].[MMW_FC_SECTION] 
GO
CREATE UNIQUE NONCLUSTERED INDEX [PKMMWFCSECTION] ON [DIB5_AUX].[MMW_FC_SECTION]
(
   [SECTIONID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_SECTION.PKMMWFCSECTION',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_SECTION',
        N'INDEX', N'PKMMWFCSECTION'
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
       WHERE so.name = N'MMW_FC_SECTIONLINK'  AND sc.name = N'DIB5_AUX'  AND si.name = N'PKMMWFCSECTIONLINK' AND so.type in (N'U'))
   DROP INDEX [PKMMWFCSECTIONLINK] ON [DIB5_AUX].[MMW_FC_SECTIONLINK] 
GO
CREATE UNIQUE NONCLUSTERED INDEX [PKMMWFCSECTIONLINK] ON [DIB5_AUX].[MMW_FC_SECTIONLINK]
(
   [ELEMENTID] ASC,
   [SECTIONID] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'DIB5_AUX.MMW_FC_SECTIONLINK.PKMMWFCSECTIONLINK',
        N'SCHEMA', N'DIB5_AUX',
        N'TABLE', N'MMW_FC_SECTIONLINK',
        N'INDEX', N'PKMMWFCSECTIONLINK'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

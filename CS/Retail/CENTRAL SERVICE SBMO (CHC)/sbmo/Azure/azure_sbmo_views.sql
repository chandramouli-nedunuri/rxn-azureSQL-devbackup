
USE [nonEPR-DB]
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'SBMO')      
     EXEC (N'CREATE SCHEMA SBMO')                                   
 GO                                                               

USE [nonEPR-DB]
GO
IF  EXISTS (select * from sys.objects so join sys.schemas sc on so.schema_id = sc.schema_id where so.name = N'VW_SCHEMA_UPDATER_MANIFEST' and sc.name=N'SBMO' AND type in (N'V'))
 DROP VIEW [SBMO].[VW_SCHEMA_UPDATER_MANIFEST]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [SBMO].[VW_SCHEMA_UPDATER_MANIFEST]
AS
SELECT 
    version,
    file_name,
    ROW_NUMBER() OVER (
        ORDER BY 
            CASE WHEN apply_order IS NULL THEN 1 ELSE 0 END,
            apply_order,
            build_order
    ) AS apply_order
FROM (
    SELECT 
        m.version,
        m.file_name,
        m.apply_order AS apply_order,
        CAST(NULL AS INT) AS build_order
    FROM SBMO.pdx_schema_updater_manifest m

    UNION

    SELECT 
        m.version,
        m.file_name,
        CAST(NULL AS INT) AS apply_order,
        m.apply_order AS build_order
    FROM SBMO.schema_updater_manifest m
    WHERE m.apply_order > (
        SELECT ISNULL(MAX(mi.apply_order), -1)
        FROM SBMO.schema_updater_manifest mi
        JOIN SBMO.pdx_schema_updater_manifest pmi 
            ON mi.file_name = pmi.file_name
    )
) t;

GO
GO

-- AZURE SQL TRIGGERS
-- Converted from Oracle triggers
-- ========================================================

---------------------------------------------------------
-- RETAIL_COST_BIUR
---------------------------------------------------------
CREATE TRIGGER [SBMO].[RETAIL_COST_BIUR]
ON [SBMO].[retail_cost]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- WARNING: Primary key not confirmed. Verify JOIN condition.
    -- Suggested: replace with actual PK columns (likely TENANT_ID + DRUG_ID or similar)

    UPDATE tgt
    SET 
        LAST_UPDATED_DATE = SYSUTCDATETIME(),
        LAST_UPDATED_USER_ID = 
            CASE 
                WHEN i.LAST_UPDATED_USER_ID IS NULL THEN 'DRUG SERVICES'
                ELSE i.LAST_UPDATED_USER_ID
            END
    FROM [SBMO].[retail_cost] tgt
    INNER JOIN INSERTED i
        ON tgt.ID = i.ID;  -- ⚠️ Replace with actual PK
END;

---------------------------------------------------------
-- VENDOR_BIUR
---------------------------------------------------------
CREATE TRIGGER [SBMO].[VENDOR_BIUR]
ON [SBMO].[VENDOR]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- WARNING: Primary key not confirmed. Verify JOIN condition.

    UPDATE tgt
    SET 
        LAST_UPDATED_DATE = SYSUTCDATETIME(),
        LAST_UPDATED_USER_ID = 
            CASE 
                WHEN i.LAST_UPDATED_USER_ID IS NULL THEN 'UNKNOWN'
                ELSE i.LAST_UPDATED_USER_ID
            END
    FROM [SBMO].[VENDOR] tgt
    INNER JOIN INSERTED i
        ON tgt.ID = i.ID;  -- ⚠️ Replace with actual PK
END;

---------------------------------------------------------
-- VENDOR_PROP_BIUR
---------------------------------------------------------
CREATE TRIGGER [SBMO].[VENDOR_PROP_BIUR]
ON [SBMO].[VENDOR_PROP]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- WARNING: Primary key not confirmed. Verify JOIN condition.

    UPDATE tgt
    SET 
        LAST_UPDATED_DATE = SYSUTCDATETIME(),
        LAST_UPDATED_USER_ID = 
            CASE 
                WHEN i.LAST_UPDATED_USER_ID IS NULL THEN 'UNKNOWN'
                ELSE i.LAST_UPDATED_USER_ID
            END
    FROM [SBMO].[VENDOR_PROP] tgt
    INNER JOIN INSERTED i
        ON tgt.ID = i.ID;  -- ⚠️ Replace with actual PK
END;
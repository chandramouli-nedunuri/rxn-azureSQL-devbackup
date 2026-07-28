-- BATCH 5 PRIMARY KEY AND UNIQUE CONSTRAINTS
-- ------------------------------------------------------------------

ALTER TABLE [SBMO].[ORDERS] ADD CONSTRAINT [ORDERS_UQ_ORDER_NUMBER] UNIQUE ([ORDER_NUMBER]);
